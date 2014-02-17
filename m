Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaBQImA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:42:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37670 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaBQIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:46 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-46-5301cb0d99b7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH v3 12/13] rtc: s5m: Support different register layout
Date: Mon, 17 Feb 2014 09:40:26 +0100
Message-id: <1392626427-4518-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
References: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xK7q8pxmDDR4uVrJYcvEqu8XGGetZ
	LV6/MLQ42/SG3eL+16OMFpd3zWGzmHF+H5PF2iN32S32d3YwWpzuZrW4uOILk8X6Ga9ZLOZM
	f8fkwOuxZ+JJNo871/awecw7GejRt2UVo8f0eT+ZPD5vkgtgi+KySUnNySxLLdK3S+DK2Dbp
	D2PB35iKu+/bGRsY33t1MXJySAiYSPxbuocdwhaTuHBvPVsXIxeHkMBSRok7J88zQTh9TBL7
	Xs1nBKliEzCW2Lx8CViViMBmRonF36+ygiSYBR4wSUx/Xg1iCwu4Sny+u4MJxGYRUJW4f/Ml
	M4jNK+AucXbuKqB6DqB1ChJzJtmAhDmBwk/7poKFhQTcJPZvDJvAyLuAkWEVo2hqaXJBcVJ6
	rqFecWJucWleul5yfu4mRkhQftnBuPiY1SFGAQ5GJR5eg2rGYCHWxLLiytxDjBIczEoivLbr
	gEK8KYmVValF+fFFpTmpxYcYmTg4pRoYV08v9Xux8eGpStnyW1zn2N4F/b3tnnNowjybJy+k
	Z3RkH/3SKixzeUK4h/VNC7NC6Q+Pjl/nF5avPNoucuWTrPaqLLGbRYfvFhU/yTJ3Tp90u3X5
	va7V7AKKjAJ9epcm6Pb81u4/GsR0Zmqoqk6shn7eyx0LF336q/66Ln9Oh++vuJyi3r3vlViK
	MxINtZiLihMBRWcEyygCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for adding support for S2MPS14 RTC device to the
rtc-s5m driver:
1. Adds a map of registers used by the driver which differ between
the chipsets (S5M876X and S2MPS14).
2. Moves code of checking for alarm pending to separate function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-s5m.c |  157 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 109 insertions(+), 48 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index b1627e9ab8f0..6a1290f8709a 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ * Copyright (c) 2013-2014 Samsung Electronics Co., Ltd
  *	http://www.samsung.com
  *
  *  Copyright (C) 2013 Google, Inc
@@ -38,6 +38,42 @@
  */
 #define UDR_READ_RETRY_CNT	5
 
+/* Registers used by the driver which are different between chipsets. */
+struct s5m_rtc_reg_config {
+	/* Number of registers used for setting time/alarm0/alarm1 */
+	unsigned int regs_count;
+	/* First register for time, seconds */
+	unsigned int time;
+	/* RTC control register */
+	unsigned int ctrl;
+	/* First register for alarm 0, seconds */
+	unsigned int alarm0;
+	/* First register for alarm 1, seconds */
+	unsigned int alarm1;
+	/* SMPL/WTSR register */
+	unsigned int smpl_wtsr;
+	/*
+	 * Register for update flag (UDR). Typically setting UDR field to 1
+	 * will enable update of time or alarm register. Then it will be
+	 * auto-cleared after successful update.
+	 */
+	unsigned int rtc_udr_update;
+	/* Mask for UDR field in 'rtc_udr_update' register */
+	unsigned int rtc_udr_mask;
+};
+
+/* Register map for S5M8763 and S5M8767 */
+static const struct s5m_rtc_reg_config s5m_rtc_regs = {
+	.regs_count		= 8,
+	.time			= S5M_RTC_SEC,
+	.ctrl			= S5M_ALARM1_CONF,
+	.alarm0			= S5M_ALARM0_SEC,
+	.alarm1			= S5M_ALARM1_SEC,
+	.smpl_wtsr		= S5M_WTSR_SMPL_CNTL,
+	.rtc_udr_update		= S5M_RTC_UDR_CON,
+	.rtc_udr_mask		= S5M_RTC_UDR_MASK,
+};
+
 struct s5m_rtc_info {
 	struct device *dev;
 	struct sec_pmic_dev *s5m87xx;
@@ -47,6 +83,7 @@ struct s5m_rtc_info {
 	int device_type;
 	int rtc_24hr_mode;
 	bool wtsr_smpl;
+	const struct s5m_rtc_reg_config	*regs;
 };
 
 static void s5m8767_data_to_tm(u8 *data, struct rtc_time *tm,
@@ -104,8 +141,9 @@ static inline int s5m8767_wait_for_udr_update(struct s5m_rtc_info *info)
 	unsigned int data;
 
 	do {
-		ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
-	} while (--retry && (data & S5M_RTC_UDR_MASK) && !ret);
+		ret = regmap_read(info->regmap, info->regs->rtc_udr_update,
+				&data);
+	} while (--retry && (data & info->regs->rtc_udr_mask) && !ret);
 
 	if (!retry)
 		dev_err(info->dev, "waiting for UDR update, reached max number of retries\n");
@@ -113,21 +151,47 @@ static inline int s5m8767_wait_for_udr_update(struct s5m_rtc_info *info)
 	return ret;
 }
 
+static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
+		struct rtc_wkalrm *alarm)
+{
+	int ret;
+	unsigned int val;
+
+	switch (info->device_type) {
+	case S5M8767X:
+	case S5M8763X:
+		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
+		val &= S5M_ALARM0_STATUS;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (ret < 0)
+		return ret;
+
+	if (val)
+		alarm->pending = 1;
+	else
+		alarm->pending = 0;
+
+	return 0;
+}
+
 static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 {
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, info->regs->rtc_udr_update, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to read update reg(%d)\n", ret);
 		return ret;
 	}
 
 	data |= S5M_RTC_TIME_EN_MASK;
-	data |= S5M_RTC_UDR_MASK;
+	data |= info->regs->rtc_udr_mask;
 
-	ret = regmap_write(info->regmap, S5M_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, info->regs->rtc_udr_update, data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to write update reg(%d)\n", ret);
 		return ret;
@@ -143,7 +207,7 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, info->regs->rtc_udr_update, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read update reg(%d)\n",
 			__func__, ret);
@@ -151,9 +215,9 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	}
 
 	data &= ~S5M_RTC_TIME_EN_MASK;
-	data |= S5M_RTC_UDR_MASK;
+	data |= info->regs->rtc_udr_mask;
 
-	ret = regmap_write(info->regmap, S5M_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, info->regs->rtc_udr_update, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 			__func__, ret);
@@ -200,10 +264,11 @@ static void s5m8763_tm_to_data(struct rtc_time *tm, u8 *data)
 static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
-	u8 data[8];
+	u8 data[info->regs->regs_count];
 	int ret;
 
-	ret = regmap_bulk_read(info->regmap, S5M_RTC_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, info->regs->time, data,
+			info->regs->regs_count);
 	if (ret < 0)
 		return ret;
 
@@ -230,7 +295,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
-	u8 data[8];
+	u8 data[info->regs->regs_count];
 	int ret = 0;
 
 	switch (info->device_type) {
@@ -251,7 +316,8 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, 1 + tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec, tm->tm_wday);
 
-	ret = regmap_raw_write(info->regmap, S5M_RTC_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, info->regs->time, data,
+			info->regs->regs_count);
 	if (ret < 0)
 		return ret;
 
@@ -263,11 +329,12 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
-	u8 data[8];
+	u8 data[info->regs->regs_count];
 	unsigned int val;
 	int ret, i;
 
-	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, info->regs->alarm0, data,
+			info->regs->regs_count);
 	if (ret < 0)
 		return ret;
 
@@ -279,54 +346,42 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 			return ret;
 
 		alrm->enabled = !!val;
-
-		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
-		if (ret < 0)
-			return ret;
-
 		break;
 
 	case S5M8767X:
 		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
-		dev_dbg(dev, "%s: %d/%d/%d %d:%d:%d(%d)\n", __func__,
-			1900 + alrm->time.tm_year, 1 + alrm->time.tm_mon,
-			alrm->time.tm_mday, alrm->time.tm_hour,
-			alrm->time.tm_min, alrm->time.tm_sec,
-			alrm->time.tm_wday);
-
 		alrm->enabled = 0;
-		for (i = 0; i < 7; i++) {
+		for (i = 0; i < info->regs->regs_count; i++) {
 			if (data[i] & ALARM_ENABLE_MASK) {
 				alrm->enabled = 1;
 				break;
 			}
 		}
-
-		alrm->pending = 0;
-		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
-		if (ret < 0)
-			return ret;
 		break;
 
 	default:
 		return -EINVAL;
 	}
 
-	if (val & S5M_ALARM0_STATUS)
-		alrm->pending = 1;
-	else
-		alrm->pending = 0;
+	dev_dbg(dev, "%s: %d/%d/%d %d:%d:%d(%d)\n", __func__,
+		1900 + alrm->time.tm_year, 1 + alrm->time.tm_mon,
+		alrm->time.tm_mday, alrm->time.tm_hour,
+		alrm->time.tm_min, alrm->time.tm_sec,
+		alrm->time.tm_wday);
+
+	ret = s5m_check_peding_alarm_interrupt(info, alrm);
 
 	return 0;
 }
 
 static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 {
-	u8 data[8];
+	u8 data[info->regs->regs_count];
 	int ret, i;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, info->regs->alarm0, data,
+			info->regs->regs_count);
 	if (ret < 0)
 		return ret;
 
@@ -341,10 +396,11 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 		break;
 
 	case S5M8767X:
-		for (i = 0; i < 7; i++)
+		for (i = 0; i < info->regs->regs_count; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, info->regs->alarm0, data,
+				info->regs->regs_count);
 		if (ret < 0)
 			return ret;
 
@@ -362,11 +418,12 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 {
 	int ret;
-	u8 data[8];
+	u8 data[info->regs->regs_count];
 	u8 alarm0_conf;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, info->regs->alarm0, data,
+			info->regs->regs_count);
 	if (ret < 0)
 		return ret;
 
@@ -393,7 +450,8 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 		if (data[RTC_YEAR1] & 0x7f)
 			data[RTC_YEAR1] |= ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, info->regs->alarm0, data,
+				info->regs->regs_count);
 		if (ret < 0)
 			return ret;
 		ret = s5m8767_rtc_set_alarm_reg(info);
@@ -410,7 +468,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
-	u8 data[8];
+	u8 data[info->regs->regs_count];
 	int ret;
 
 	switch (info->device_type) {
@@ -435,7 +493,8 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, info->regs->alarm0, data,
+			info->regs->regs_count);
 	if (ret < 0)
 		return ret;
 
@@ -480,7 +539,7 @@ static const struct rtc_class_ops s5m_rtc_ops = {
 static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->regmap, S5M_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, info->regs->smpl_wtsr,
 				 WTSR_ENABLE_MASK,
 				 enable ? WTSR_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -491,7 +550,7 @@ static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->regmap, S5M_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, info->regs->smpl_wtsr,
 				 SMPL_ENABLE_MASK,
 				 enable ? SMPL_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -545,11 +604,13 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 	case S5M8763X:
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
 				S5M8763_IRQ_ALARM0);
+		info->regs = &s5m_rtc_regs;
 		break;
 
 	case S5M8767X:
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
 				S5M8767_IRQ_RTCA1);
+		info->regs = &s5m_rtc_regs;
 		break;
 
 	default:
@@ -593,7 +654,7 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	if (info->wtsr_smpl) {
 		for (i = 0; i < 3; i++) {
 			s5m_rtc_enable_wtsr(info, false);
-			regmap_read(info->regmap, S5M_WTSR_SMPL_CNTL, &val);
+			regmap_read(info->regmap, info->regs->smpl_wtsr, &val);
 			pr_debug("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
 			if (val & WTSR_ENABLE_MASK)
 				pr_emerg("%s: fail to disable WTSR\n",
-- 
1.7.9.5

