Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaB1NAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:00:51 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaB1NAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:00:20 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a4-53108862652a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/5] rtc: s5m: Add support for S2MPS14 RTC
Date: Fri, 28 Feb 2014 14:00:08 +0100
Message-id: <1393592408-27181-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
References: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Vd2kDoFggyuzVC2WXLzKbrFxxnpW
	i9cvDC3ONr1ht7j/9SijxeVdc9gs1h65y26xv7OD0eJ0N6vFxRVfmCzWz3jN4sDtsWfiSTaP
	O9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYIvisklJzcksSy3St0vgyjjSdpWlYLVjRc/uC2wN
	jKdMuhg5OSQETCT6d7xigrDFJC7cW8/WxcjFISSwlFHi3oaJjBBOH5PE2vsNYFVsAsYSm5cv
	AasSEbjKKDFxyWJ2kASzwHNGiaffw0FsYQEriXudS8AaWARUJR6c2M4MYvMKuEusPTQXaCoH
	0DoFiTmTbEDCnAIeEiefT2EFsYWASu6t3so8gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS9
	5PzcTYyQEPy6g3HpMatDjAIcjEo8vBM8+YOFWBPLiitzDzFKcDArifA+aRIIFuJNSaysSi3K
	jy8qzUktPsTIxMEp1cA4naOV/8H7qN2m+4RsZCb212x/J/JmlvZbA3O5DfdXzN5/p62/K+CX
	oGSnX3a92m/H99LvTq4UXCR1OnpNuXHf9G1lkqKPrS92x/97u0ru8PktHhe3Tpfmc49KWnp+
	n/Ns/ouxlyYzvjdZ4/278eSxo1fZP7DKNQtUPP/Lq7/r9Kxy9nam6cpHlFiKMxINtZiLihMB
	0B2D2x8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for S2MPS14 to the rtc-s5m driver. Differences in S2MPS14
(in comparison to S5M8767):
 - Layout of registers;
 - Lack of century support for time and alarms (7 registers used for
   storing time/alarm);
 - Two buffer control registers: WUDR and RUDR;
 - No register for enabling writing time;
 - RTC interrupts are reported in main PMIC I2C device;

This patch also adds missing mfd_cell for RTC in the MFD core driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/Kconfig   |    4 +-
 drivers/rtc/rtc-s5m.c |  101 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 86 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index db933decc39c..2d402338a2bd 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -530,11 +530,11 @@ config RTC_DRV_RV3029C2
 	  will be called rtc-rv3029c2.
 
 config RTC_DRV_S5M
-	tristate "Samsung S5M series"
+	tristate "Samsung S2M/S5M series"
 	depends on MFD_SEC_CORE
 	help
 	  If you say yes here you will get support for the
-	  RTC of Samsung S5M PMIC series.
+	  RTC of Samsung S2MPS14 and S5M PMIC series.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-s5m.
diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index b3394b881cad..f7f0609bee01 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -17,16 +17,14 @@
 
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/slab.h>
 #include <linux/bcd.h>
-#include <linux/bitops.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
+#include <linux/mfd/samsung/s2mps14.h>
 
 /*
  * Maximum number of retries for checking changes in UDR field
@@ -74,6 +72,21 @@ static const struct s5m_rtc_reg_config s5m_rtc_regs = {
 	.rtc_udr_mask		= S5M_RTC_UDR_MASK,
 };
 
+/*
+ * Register map for S2MPS14.
+ * It may be also suitable for S2MPS11 but this was not tested.
+ */
+static const struct s5m_rtc_reg_config s2mps_rtc_regs = {
+	.regs_count		= 7,
+	.time			= S2MPS_RTC_SEC,
+	.ctrl			= S2MPS_RTC_CTRL,
+	.alarm0			= S2MPS_ALARM0_SEC,
+	.alarm1			= S2MPS_ALARM1_SEC,
+	.smpl_wtsr		= S2MPS_WTSR_SMPL_CNTL,
+	.rtc_udr_update		= S2MPS_RTC_UDR_CON,
+	.rtc_udr_mask		= S2MPS_RTC_WUDR_MASK,
+};
+
 struct s5m_rtc_info {
 	struct device *dev;
 	struct sec_pmic_dev *s5m87xx;
@@ -163,6 +176,11 @@ static inline int s5m_check_peding_alarm_interrupt(struct s5m_rtc_info *info,
 		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		val &= S5M_ALARM0_STATUS;
 		break;
+	case S2MPS14X:
+		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
+				&val);
+		val &= S2MPS_ALARM0_STATUS;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -188,8 +206,9 @@ static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 		return ret;
 	}
 
-	data |= S5M_RTC_TIME_EN_MASK;
 	data |= info->regs->rtc_udr_mask;
+	if (info->device_type == S5M8763X || info->device_type == S5M8767X)
+		data |= S5M_RTC_TIME_EN_MASK;
 
 	ret = regmap_write(info->regmap, info->regs->rtc_udr_update, data);
 	if (ret < 0) {
@@ -214,8 +233,18 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 		return ret;
 	}
 
-	data &= ~S5M_RTC_TIME_EN_MASK;
 	data |= info->regs->rtc_udr_mask;
+	switch (info->device_type) {
+	case S5M8763X:
+	case S5M8767X:
+		data &= ~S5M_RTC_TIME_EN_MASK;
+		break;
+	case S2MPS14X:
+		data |= S2MPS_RTC_RUDR_MASK;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	ret = regmap_write(info->regmap, info->regs->rtc_udr_update, data);
 	if (ret < 0) {
@@ -267,6 +296,17 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	u8 data[info->regs->regs_count];
 	int ret;
 
+	if (info->device_type == S2MPS14X) {
+		ret = regmap_update_bits(info->regmap,
+				info->regs->rtc_udr_update,
+				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
+		if (ret) {
+			dev_err(dev,
+				"Failed to prepare registers for time reading: %d\n",
+				ret);
+			return ret;
+		}
+	}
 	ret = regmap_bulk_read(info->regmap, info->regs->time, data,
 			info->regs->regs_count);
 	if (ret < 0)
@@ -278,6 +318,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
 		break;
 
@@ -303,6 +344,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		s5m8763_tm_to_data(tm, data);
 		break;
 	case S5M8767X:
+	case S2MPS14X:
 		ret = s5m8767_tm_to_data(tm, data);
 		break;
 	default:
@@ -349,6 +391,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
 		alrm->enabled = 0;
 		for (i = 0; i < info->regs->regs_count; i++) {
@@ -396,6 +439,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		for (i = 0; i < info->regs->regs_count; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
@@ -439,6 +483,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		data[RTC_SEC] |= ALARM_ENABLE_MASK;
 		data[RTC_MIN] |= ALARM_ENABLE_MASK;
 		data[RTC_HOUR] |= ALARM_ENABLE_MASK;
@@ -477,6 +522,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		s5m8767_tm_to_data(&alrm->time, data);
 		break;
 
@@ -563,19 +609,33 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 	u8 data[2];
 	int ret;
 
-	/* UDR update time. Default of 7.32 ms is to long. */
-	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
-			S5M_RTC_UDR_T_MASK, S5M_RTC_UDR_T_450_US);
-	if (ret < 0)
-		dev_err(info->dev, "%s: fail to change UDR time: %d\n",
-				__func__, ret);
+	switch (info->device_type) {
+	case S5M8763X:
+	case S5M8767X:
+		/* UDR update time. Default of 7.32 ms is to long. */
+		ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
+				S5M_RTC_UDR_T_MASK, S5M_RTC_UDR_T_450_US);
+		if (ret < 0)
+			dev_err(info->dev, "%s: fail to change UDR time: %d\n",
+					__func__, ret);
+
+		/* Set RTC control register : Binary mode, 24hour mode */
+		data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+		data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+
+		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
+		break;
 
-	/* Set RTC control register : Binary mode, 24hour mode */
-	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
-	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+	case S2MPS14X:
+		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
+		break;
+
+	default:
+		return -EINVAL;
+	}
 
 	info->rtc_24hr_mode = 1;
-	ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 			__func__, ret);
@@ -620,6 +680,12 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 		info->regs = &s5m_rtc_regs;
 		break;
 
+	case S2MPS14X:
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S2MPS14_IRQ_RTCA0);
+		info->regs = &s2mps_rtc_regs;
+		break;
+
 	default:
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "Unsupported device type: %d\n", ret);
@@ -704,7 +770,8 @@ static int s5m_rtc_suspend(struct device *dev)
 static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
 
 static const struct platform_device_id s5m_rtc_id[] = {
-	{ "s5m-rtc", 0 },
+	{ "s5m-rtc",		S5M8767X },
+	{ "s2mps14-rtc",	S2MPS14X },
 };
 
 static struct platform_driver s5m_rtc_driver = {
@@ -722,6 +789,6 @@ module_platform_driver(s5m_rtc_driver);
 
 /* Module information */
 MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
-MODULE_DESCRIPTION("Samsung S5M RTC driver");
+MODULE_DESCRIPTION("Samsung S5M/S2MPS14 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:s5m-rtc");
-- 
1.7.9.5

