2.1 ĐƠN GIẢN  
2.1.1 Sắp xếp DANH SÁCH KHÁCH HÀNG THEO tuổi từ nhỏ đến lớn
SELECT MA,HO_TEN, DIA_CHI, DATEDIFF(YEAR, NGAY_SINH, GETDATE()) AS TUOI
FROM KHACH_HANG ORDER BY KHACH_HANG.NGAY_SINH DESC

-- 2.1.2 Lấy ra danh sách khách hàng có mã 'không là' NULL AND có năm sinh <= 2014
-- SELECT * FROM KHACH_HANG WHERE MA IS NOT NULL AND YEAR(NGAY_SINH) <= 2014

-- 2.1.3 Lấy ra danh sách khách hàng sinh vào năm 2016 và khác tháng 7
-- SELECT * FROM KHACH_HANG WHERE YEAR(NGAY_SINH) = 2016 AND MONTH(NGAY_SINH) <> 7

2.1.2 Lấy ra những khách hàng có họ là Trần hoặc Đỗ
SELECT  * FROM KHACH_HANG WHERE HO_TEN LIKE N'Trần%' OR HO_TEN LIKE N'Đỗ%'

2.1.3 Viết câu truy vấn trả về danh sách mã vắc-xin khách hàng có mã khách hàng “KH01” đã hoàn thành tiêm chủng. (Ngày nhắc lại là NULL)
SELECT LICH_TIEM.MA_VACCIN
FROM LICH_TIEM
JOIN CHI_TIET_LICH_TIEM ON LICH_TIEM.MA = CHI_TIET_LICH_TIEM.MA_LICH_TIEM
WHERE CHI_TIET_LICH_TIEM.MA_KHACH_HANG = 'KH01' AND CHI_TIET_LICH_TIEM.NGAY_NHAC_LAI IS NULL

2.1.4 Viết câu truy vấn trả về danh sách các mã vắc-xin, tên vắc-xin, tên nhà sản xuất của vắc-xin có tên loại vắc-xin là “COVID_19”
SELECT VACCIN.MA, CHI_TIET_VACCIN.TEN, NHA_SAN_XUAT.TEN AS TEN_NSX
FROM VACCIN JOIN CHI_TIET_VACCIN ON VACCIN.MA = CHI_TIET_VACCIN.MA_VACCIN
JOIN NHA_SAN_XUAT ON NHA_SAN_XUAT.MA = VACCIN.MA_NHA_SAN_XUAT
WHERE VACCIN.TEN_LOAI LIKE N'COVID_19'


2.2 TRUNG BÌNH
-- 2.2.1 Viết câu truy vấn tính độ tuổi trung bình của khách hàng (sử dụng SUM, COUNT);
-- SELECT SUM(DATEDIFF(YEAR,NGAY_SINH,GETDATE()))/COUNT(MA) AS DO_TUOI_TRUNG_BINH  FROM KHACH_HANG

-- 2.2.2 Thống kê số lượng vacxin theo MÃ (SỬ DỤNG GROUP BY)
-- SELECT MA_VACCIN, COUNT(MA_VACCIN) AS SO_LUONG
-- FROM CHI_TIET_VACCIN
-- GROUP BY MA_VACCIN

2.2.1 Lấy ra danh sách những khách hàng lớn tuổi nhất (Subquery, MIN)
SELECT * 
FROM KHACH_HANG 
WHERE NGAY_SINH = (SELECT MIN(NGAY_SINH) FROM KHACH_HANG)

2.2.2 Thống kê số lượng vaccin theo mã lịch tiêm có thời gian tiêm trong năm 2020 (GROUP BY, HAVING)
SELECT MA,NGAY_TIEM, COUNT(MA_VACCIN) AS SO_LUONG FROM LICH_TIEM
GROUP BY MA,NGAY_TIEM HAVING YEAR(NGAY_TIEM) = 2020

2.2.3 Viết câu truy vấn cho biết khách hàng có mã 'KH01' đã tiêm chủng những loại vacxin nào (không trùng nhau)
SELECT CHI_TIET_LICH_TIEM.MA_KHACH_HANG, LICH_TIEM.MA_VACCIN 
FROM CHI_TIET_LICH_TIEM JOIN LICH_TIEM ON CHI_TIET_LICH_TIEM.MA_LICH_TIEM = LICH_TIEM.MA
WHERE CHI_TIET_LICH_TIEM.MA_KHACH_HANG = 'KH01'

2.2.4 Viết câu truy vấn thống kê mã khách hàng, tên khách hàng, số lượng vacxin khách hàng đã tiêm
SELECT KHACH_HANG.MA,KHACH_HANG.HO_TEN, COUNT(LICH_TIEM.MA_VACCIN) AS SO_LUONG 
FROM KHACH_HANG JOIN CHI_TIET_LICH_TIEM ON CHI_TIET_LICH_TIEM.MA_KHACH_HANG = KHACH_HANG.MA 
JOIN LICH_TIEM ON LICH_TIEM.MA = CHI_TIET_LICH_TIEM.MA_LICH_TIEM
GROUP BY KHACH_HANG.MA,KHACH_HANG.HO_TEN
-- 2.2.7 Thống kê số lượng người thân có 2 SĐT trở lên
-- SELECT MA,COUNT(SDT) AS SO_LUONG FROM NGUOI_THAN_SDT
-- GROUP BY MA HAVING COUNT(SDT) >= 2

--2.2.8  Lấy khách hàng có tuổi nhỏ nhất và đã tiêm ít nhất một mũi
-- SELECT  TOP 1 TRE_EM.MA, KHACH_HANG.HO_TEN FROM TRE_EM JOIN KHACH_HANG ON KHACH_HANG.MA = TRE_EM.MA
-- JOIN CHI_TIET_LICH_TIEM ON KHACH_HANG.MA = CHI_TIET_LICH_TIEM.MA_KHACH_HANG
-- WHERE NGAY_SINH = (SELECT MIN(KHACH_HANG.NGAY_SINH) FROM KHACH_HANG JOIN TRE_EM ON KHACH_HANG.MA = TRE_EM.MA)
-- AND CHI_TIET_LICH_TIEM.STT_MUI_TIEM >=1

2.3 PHỨC TẠP
-- 2.3.1 Lấy ra danh sách khách hàng có lịch tiêm chủng TRONG NĂM 2020 có tuổi là 18 hoặc 20 hoặc 60 hoặc 90 (IN)
-- SELECT KHACH_HANG.MA,KHACH_HANG.HO_TEN
-- FROM KHACH_HANG
-- JOIN CHI_TIET_LICH_TIEM ON KHACH_HANG.MA = CHI_TIET_LICH_TIEM.MA_KHACH_HANG
-- JOIN LICH_TIEM ON LICH_TIEM.MA = CHI_TIET_LICH_TIEM.MA_LICH_TIEM
-- WHERE YEAR(LICH_TIEM.NGAY_TIEM) = 2020 AND (DATEDIFF(YEAR, KHACH_HANG.NGAY_SINH, GETDATE()) IN (18,20,60,90))

--2.3.2 Lấy ra danh sách vaccin + lô của vaccin đó có ngày hết hạn trong những tháng 10 11 12 KHÁC NĂM 2018,2019 (NOT IN) 
-- SELECT VACCIN.MA,CHI_TIET_VACCIN.MA_LO
-- FROM VACCIN
-- JOIN CHI_TIET_VACCIN ON VACCIN.MA = CHI_TIET_VACCIN.MA_VACCIN
-- WHERE MONTH(CHI_TIET_VACCIN.NGAY_HET_HAN) IN (10,11,12) AND YEAR(CHI_TIET_VACCIN.NGAY_HET_HAN) NOT IN (2018,2019)

-- 2.3.3 Lấy ra những vaccin + mã lô có mã tồn tại trong bảng Vaccin CẦN PHẢI THỎA MÃN  DDIEUF KIỆN : NGÀY SẢN XUẤT (YEAR) >= 2020
-- SELECT VACCIN.MA,CHI_TIET_VACCIN.MA_LO
-- FROM VACCIN
-- JOIN CHI_TIET_VACCIN ON VACCIN.MA = CHI_TIET_VACCIN.MA_VACCIN
-- WHERE EXISTS 
-- 							(SELECT MA_VACCIN FROM CHI_TIET_VACCIN WHERE YEAR(NGAY_SAN_XUAT) >=2020)
							
-- 2.3.4 Thống kê các vaccin dành cho khách hàng có đội tuổi từ 5 hoặc từ 18 theo Mã Vaccin + Mã Lô. Điều kiện cần phải thỏa mãn : không tồn tại vaccin có mã IS NULL (NOT EXISTS, IS NULL)
-- SELECT VACCIN.MA,CHI_TIET_VACCIN.MA_LO,CHI_TIET_VACCIN.DO_TUOI_TIEM_CHUNG
-- FROM VACCIN 
-- JOIN CHI_TIET_VACCIN ON VACCIN.MA = CHI_TIET_VACCIN.MA_VACCIN
-- WHERE CHI_TIET_VACCIN.DO_TUOI_TIEM_CHUNG >= 5 
-- OR CHI_TIET_VACCIN.DO_TUOI_TIEM_CHUNG >=18 
-- AND NOT EXISTS (SELECT MA
-- 									FROM VACCIN WHERE MA IS NULL)
-- GROUP BY VACCIN.MA, CHI_TIET_VACCIN.MA_LO,CHI_TIET_VACCIN.DO_TUOI_TIEM_CHUNG

2.3.1 Thống kê những khách hàng tiêm vaccin có mã bác sĩ chỉ định là bất kì thuộc bảng BAC_SI, sau khi tiêm có tình trạng 'TỐT', ngày nhắc lại is NOT NULL, STT_MUI_TIEM >=2  (GROUP BY)
SELECT MA_KHACH_HANG,STT_MUI_TIEM,MA_BAC_SI FROM CHI_TIET_LICH_TIEM
WHERE GHI_CHU LIKE N'TỐT'
AND NGAY_NHAC_LAI IS NOT NULL 
GROUP BY MA_KHACH_HANG,STT_MUI_TIEM,MA_BAC_SI HAVING STT_MUI_TIEM >=2 AND MA_BAC_SI IN (SELECT MA FROM BAC_SI)

2.3.2 Lấy ra danh sách có mã lich tiêm, mã BS, mã KH theo điều kiện: có NGAY_NHAC_LAI IS NOT NULL và STT_MUI_TIEM >=2 (SOME)
SELECT * FROM CHI_TIET_LICH_TIEM
WHERE NGAY_NHAC_LAI = SOME(SELECT NGAY_NHAC_LAI FROM CHI_TIET_LICH_TIEM WHERE NGAY_NHAC_LAI IS NOT NULL AND STT_MUI_TIEM >= 2)

2.3.3 Viết câu truy vấn cho biết có bao nhiêu khách hàng 65 tuổi trở lên đã tiêm chủng loại vacxin 'COVID_19' tên là Pfizer (IN + SUBQUERY)
SELECT COUNT(CHI_TIET_LICH_TIEM.MA_KHACH_HANG) AS SO_LUONG_KHACH_HANG
FROM KHACH_HANG
JOIN CHI_TIET_LICH_TIEM ON KHACH_HANG.MA = CHI_TIET_LICH_TIEM.MA_KHACH_HANG
JOIN LICH_TIEM ON LICH_TIEM.MA = CHI_TIET_LICH_TIEM.MA_LICH_TIEM
WHERE LICH_TIEM.MA_VACCIN IN (SELECT VACCIN.MA
										FROM VACCIN JOIN CHI_TIET_VACCIN
										ON VACCIN.MA = CHI_TIET_VACCIN.MA_VACCIN
										WHERE VACCIN.MA_LOAI LIKE 'COVID_19'
										AND CHI_TIET_VACCIN.TEN LIKE 'Pfizer'

)
AND DATEDIFF(YEAR,KHACH_HANG.NGAY_SINH, GETDATE()) >= 65

2.3.4 Viết câu truy vấn khách hàng có năm sinh 2017 chưa tiêm đủ các văc-xin dành cho độ tuổi từ 2-4 (GROUP BY HAVING, SUBQUERY)
SELECT CHI_TIET_LICH_TIEM.MA_KHACH_HANG,MAX(CHI_TIET_LICH_TIEM.STT_MUI_TIEM) AS MUI_TIEM_CUOI
FROM CHI_TIET_LICH_TIEM
JOIN KHACH_HANG ON KHACH_HANG.MA = CHI_TIET_LICH_TIEM.MA_KHACH_HANG
WHERE YEAR(KHACH_HANG.NGAY_SINH) = 2015
GROUP BY CHI_TIET_LICH_TIEM.MA_KHACH_HANG 
HAVING MAX(CHI_TIET_LICH_TIEM.STT_MUI_TIEM) < (SELECT SO_LIEU_DAT_HIEU_QUA FROM CHI_TIET_VACCIN
												WHERE DO_TUOI_TIEM_CHUNG IN (2,3,4))