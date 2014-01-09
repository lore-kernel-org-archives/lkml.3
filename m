Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaAIL0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:26:42 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54905 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaAIL0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:26:36 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, mark.rutland@arm.com, sbkim73@samsung.com,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2 1/3] mfd: Add support for S2MPA01 device
Date: Thu,  9 Jan 2014 16:52:32 +0530
Message-Id: <1389266554-23463-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary entries required for S2MPA01 multi-function
device. While at it also convert whitespaces to tabs in core.h.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
* Fixed nits pointed out by Lee.
---
 drivers/mfd/sec-core.c              |   45 +++++++-
 include/linux/mfd/samsung/core.h    |   16 ++-
 include/linux/mfd/samsung/irq.h     |   50 +++++++++
 include/linux/mfd/samsung/s2mpa01.h |  192 +++++++++++++++++++++++++++++++++++
 4 files changed, 295 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpa01.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index a139798b8065..564265c57fd9 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -26,6 +26,7 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
+#include <linux/mfd/samsung/s2mpa01.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
@@ -69,18 +70,40 @@ static const struct mfd_cell s2mps11_devs[] = {
 	}
 };
 
+static const struct mfd_cell s2mpa01_devs[] = {
+	{
+		.name = "s2mpa01-pmic",
+	},
+};
+
 #ifdef CONFIG_OF
 static struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
 		.data = (void *)S5M8767X,
-	},
-	{	.compatible = "samsung,s2mps11-pmic",
+	}, {
+		.compatible = "samsung,s2mps11-pmic",
 		.data = (void *)S2MPS11X,
+	}, {
+		.compatible = "samsung,s2mpa01-pmic",
+		.data = (void *)S2MPA01,
+	}, {
+		/* Sentinel */
 	},
-	{},
 };
 #endif
 
+static bool s2mpa01_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case S2MPA01_REG_INT1M:
+	case S2MPA01_REG_INT2M:
+	case S2MPA01_REG_INT3M:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static bool s2mps11_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -111,6 +134,15 @@ static const struct regmap_config sec_regmap_config = {
 	.val_bits = 8,
 };
 
+static const struct regmap_config s2mpa01_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPA01_REG_LDO_OVCB4,
+	.volatile_reg = s2mpa01_volatile,
+	.cache_type = REGCACHE_FLAT,
+};
+
 static const struct regmap_config s2mps11_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -229,6 +261,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	}
 
 	switch (sec_pmic->device_type) {
+	case S2MPA01:
+		regmap = &s2mpa01_regmap_config;
+		break;
 	case S2MPS11X:
 		regmap = &s2mps11_regmap_config;
 		break;
@@ -283,6 +318,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
 				      ARRAY_SIZE(s5m8767_devs), NULL, 0, NULL);
 		break;
+	case S2MPA01:
+		ret = mfd_add_devices(sec_pmic->dev, -1, s2mpa01_devs,
+				      ARRAY_SIZE(s2mpa01_devs), NULL, 0, NULL);
+		break;
 	case S2MPS11X:
 		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
 				      ARRAY_SIZE(s2mps11_devs), NULL, 0, NULL);
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 41c9bde410c5..db165f8712d3 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -18,6 +18,7 @@ enum sec_device_type {
 	S5M8751X,
 	S5M8763X,
 	S5M8767X,
+	S2MPA01,
 	S2MPS11X,
 };
 
@@ -92,7 +93,7 @@ struct sec_platform_data {
 	int				buck3_default_idx;
 	int				buck4_default_idx;
 
-	int                             buck_ramp_delay;
+	int				buck_ramp_delay;
 
 	int				buck2_ramp_delay;
 	int				buck34_ramp_delay;
@@ -100,10 +101,15 @@ struct sec_platform_data {
 	int				buck16_ramp_delay;
 	int				buck7810_ramp_delay;
 	int				buck9_ramp_delay;
-
-	bool                            buck2_ramp_enable;
-	bool                            buck3_ramp_enable;
-	bool                            buck4_ramp_enable;
+	int				buck24_ramp_delay;
+	int				buck3_ramp_delay;
+	int				buck7_ramp_delay;
+	int				buck8910_ramp_delay;
+
+	bool				buck1_ramp_enable;
+	bool				buck2_ramp_enable;
+	bool				buck3_ramp_enable;
+	bool				buck4_ramp_enable;
 	bool				buck6_ramp_enable;
 
 	int				buck2_init;
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index d43b4f9e7fb2..2ca965948cd4 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -13,6 +13,56 @@
 #ifndef __LINUX_MFD_SEC_IRQ_H
 #define __LINUX_MFD_SEC_IRQ_H
 
+enum s2mpa01_irq {
+	S2MPA01_IRQ_PWRONF,
+	S2MPA01_IRQ_PWRONR,
+	S2MPA01_IRQ_JIGONBF,
+	S2MPA01_IRQ_JIGONBR,
+	S2MPA01_IRQ_ACOKBF,
+	S2MPA01_IRQ_ACOKBR,
+	S2MPA01_IRQ_PWRON1S,
+	S2MPA01_IRQ_MRB,
+
+	S2MPA01_IRQ_RTC60S,
+	S2MPA01_IRQ_RTCA1,
+	S2MPA01_IRQ_RTCA0,
+	S2MPA01_IRQ_SMPL,
+	S2MPA01_IRQ_RTC1S,
+	S2MPA01_IRQ_WTSR,
+
+	S2MPA01_IRQ_INT120C,
+	S2MPA01_IRQ_INT140C,
+	S2MPA01_IRQ_LDO3_TSD,
+	S2MPA01_IRQ_B16_TSD,
+	S2MPA01_IRQ_B24_TSD,
+	S2MPA01_IRQ_B35_TSD,
+
+	S2MPA01_IRQ_NR,
+};
+
+#define S2MPA01_IRQ_PWRONF_MASK		(1 << 0)
+#define S2MPA01_IRQ_PWRONR_MASK		(1 << 1)
+#define S2MPA01_IRQ_JIGONBF_MASK	(1 << 2)
+#define S2MPA01_IRQ_JIGONBR_MASK	(1 << 3)
+#define S2MPA01_IRQ_ACOKBF_MASK		(1 << 4)
+#define S2MPA01_IRQ_ACOKBR_MASK		(1 << 5)
+#define S2MPA01_IRQ_PWRON1S_MASK	(1 << 6)
+#define S2MPA01_IRQ_MRB_MASK		(1 << 7)
+
+#define S2MPA01_IRQ_RTC60S_MASK		(1 << 0)
+#define S2MPA01_IRQ_RTCA1_MASK		(1 << 1)
+#define S2MPA01_IRQ_RTCA0_MASK		(1 << 2)
+#define S2MPA01_IRQ_SMPL_MASK		(1 << 3)
+#define S2MPA01_IRQ_RTC1S_MASK		(1 << 4)
+#define S2MPA01_IRQ_WTSR_MASK		(1 << 5)
+
+#define S2MPA01_IRQ_INT120C_MASK	(1 << 0)
+#define S2MPA01_IRQ_INT140C_MASK	(1 << 1)
+#define S2MPA01_IRQ_LDO3_TSD_MASK	(1 << 2)
+#define S2MPA01_IRQ_B16_TSD_MASK	(1 << 3)
+#define S2MPA01_IRQ_B24_TSD_MASK	(1 << 4)
+#define S2MPA01_IRQ_B35_TSD_MASK	(1 << 5)
+
 enum s2mps11_irq {
 	S2MPS11_IRQ_PWRONF,
 	S2MPS11_IRQ_PWRONR,
diff --git a/include/linux/mfd/samsung/s2mpa01.h b/include/linux/mfd/samsung/s2mpa01.h
new file mode 100644
index 000000000000..fbc63bc0d6a2
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mpa01.h
@@ -0,0 +1,192 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ *		http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPA01_H
+#define __LINUX_MFD_S2MPA01_H
+
+/* S2MPA01 registers */
+enum s2mpa01_reg {
+	S2MPA01_REG_ID,
+	S2MPA01_REG_INT1,
+	S2MPA01_REG_INT2,
+	S2MPA01_REG_INT3,
+	S2MPA01_REG_INT1M,
+	S2MPA01_REG_INT2M,
+	S2MPA01_REG_INT3M,
+	S2MPA01_REG_ST1,
+	S2MPA01_REG_ST2,
+	S2MPA01_REG_PWRONSRC,
+	S2MPA01_REG_OFFSRC,
+	S2MPA01_REG_RTC_BUF,
+	S2MPA01_REG_CTRL1,
+	S2MPA01_REG_ETC_TEST,
+	S2MPA01_REG_RSVD1,
+	S2MPA01_REG_BU_CHG,
+	S2MPA01_REG_RAMP1,
+	S2MPA01_REG_RAMP2,
+	S2MPA01_REG_LDO_DSCH1,
+	S2MPA01_REG_LDO_DSCH2,
+	S2MPA01_REG_LDO_DSCH3,
+	S2MPA01_REG_LDO_DSCH4,
+	S2MPA01_REG_OTP_ADRL,
+	S2MPA01_REG_OTP_ADRH,
+	S2MPA01_REG_OTP_DATA,
+	S2MPA01_REG_MON1SEL,
+	S2MPA01_REG_MON2SEL,
+	S2MPA01_REG_LEE,
+	S2MPA01_REG_RSVD2,
+	S2MPA01_REG_RSVD3,
+	S2MPA01_REG_RSVD4,
+	S2MPA01_REG_RSVD5,
+	S2MPA01_REG_RSVD6,
+	S2MPA01_REG_TOP_RSVD,
+	S2MPA01_REG_DVS_SEL,
+	S2MPA01_REG_DVS_PTR,
+	S2MPA01_REG_DVS_DATA,
+	S2MPA01_REG_RSVD_NO,
+	S2MPA01_REG_UVLO,
+	S2MPA01_REG_LEE_NO,
+	S2MPA01_REG_B1CTRL1,
+	S2MPA01_REG_B1CTRL2,
+	S2MPA01_REG_B2CTRL1,
+	S2MPA01_REG_B2CTRL2,
+	S2MPA01_REG_B3CTRL1,
+	S2MPA01_REG_B3CTRL2,
+	S2MPA01_REG_B4CTRL1,
+	S2MPA01_REG_B4CTRL2,
+	S2MPA01_REG_B5CTRL1,
+	S2MPA01_REG_B5CTRL2,
+	S2MPA01_REG_B5CTRL3,
+	S2MPA01_REG_B5CTRL4,
+	S2MPA01_REG_B5CTRL5,
+	S2MPA01_REG_B5CTRL6,
+	S2MPA01_REG_B6CTRL1,
+	S2MPA01_REG_B6CTRL2,
+	S2MPA01_REG_B7CTRL1,
+	S2MPA01_REG_B7CTRL2,
+	S2MPA01_REG_B8CTRL1,
+	S2MPA01_REG_B8CTRL2,
+	S2MPA01_REG_B9CTRL1,
+	S2MPA01_REG_B9CTRL2,
+	S2MPA01_REG_B10CTRL1,
+	S2MPA01_REG_B10CTRL2,
+	S2MPA01_REG_L1CTRL,
+	S2MPA01_REG_L2CTRL,
+	S2MPA01_REG_L3CTRL,
+	S2MPA01_REG_L4CTRL,
+	S2MPA01_REG_L5CTRL,
+	S2MPA01_REG_L6CTRL,
+	S2MPA01_REG_L7CTRL,
+	S2MPA01_REG_L8CTRL,
+	S2MPA01_REG_L9CTRL,
+	S2MPA01_REG_L10CTRL,
+	S2MPA01_REG_L11CTRL,
+	S2MPA01_REG_L12CTRL,
+	S2MPA01_REG_L13CTRL,
+	S2MPA01_REG_L14CTRL,
+	S2MPA01_REG_L15CTRL,
+	S2MPA01_REG_L16CTRL,
+	S2MPA01_REG_L17CTRL,
+	S2MPA01_REG_L18CTRL,
+	S2MPA01_REG_L19CTRL,
+	S2MPA01_REG_L20CTRL,
+	S2MPA01_REG_L21CTRL,
+	S2MPA01_REG_L22CTRL,
+	S2MPA01_REG_L23CTRL,
+	S2MPA01_REG_L24CTRL,
+	S2MPA01_REG_L25CTRL,
+	S2MPA01_REG_L26CTRL,
+
+	S2MPA01_REG_LDO_OVCB1,
+	S2MPA01_REG_LDO_OVCB2,
+	S2MPA01_REG_LDO_OVCB3,
+	S2MPA01_REG_LDO_OVCB4,
+
+};
+
+/* S2MPA01 regulator ids */
+enum s2mpa01_regulators {
+	S2MPA01_LDO1,
+	S2MPA01_LDO2,
+	S2MPA01_LDO3,
+	S2MPA01_LDO4,
+	S2MPA01_LDO5,
+	S2MPA01_LDO6,
+	S2MPA01_LDO7,
+	S2MPA01_LDO8,
+	S2MPA01_LDO9,
+	S2MPA01_LDO10,
+	S2MPA01_LDO11,
+	S2MPA01_LDO12,
+	S2MPA01_LDO13,
+	S2MPA01_LDO14,
+	S2MPA01_LDO15,
+	S2MPA01_LDO16,
+	S2MPA01_LDO17,
+	S2MPA01_LDO18,
+	S2MPA01_LDO19,
+	S2MPA01_LDO20,
+	S2MPA01_LDO21,
+	S2MPA01_LDO22,
+	S2MPA01_LDO23,
+	S2MPA01_LDO24,
+	S2MPA01_LDO25,
+	S2MPA01_LDO26,
+
+	S2MPA01_BUCK1,
+	S2MPA01_BUCK2,
+	S2MPA01_BUCK3,
+	S2MPA01_BUCK4,
+	S2MPA01_BUCK5,
+	S2MPA01_BUCK6,
+	S2MPA01_BUCK7,
+	S2MPA01_BUCK8,
+	S2MPA01_BUCK9,
+	S2MPA01_BUCK10,
+
+	S2MPA01_REGULATOR_MAX,
+};
+
+#define S2MPA01_BUCK_MIN1	600000
+#define S2MPA01_BUCK_MIN2	800000
+#define S2MPA01_BUCK_MIN3	1000000
+#define S2MPA01_BUCK_MIN4	1500000
+#define S2MPA01_LDO_MIN		800000
+
+#define S2MPA01_BUCK_STEP1	6250
+#define S2MPA01_BUCK_STEP2	12500
+
+#define S2MPA01_LDO_STEP1	50000
+#define S2MPA01_LDO_STEP2	25000
+
+#define S2MPA01_LDO_VSEL_MASK	0x3F
+#define S2MPA01_BUCK_VSEL_MASK	0xFF
+#define S2MPA01_ENABLE_MASK	(0x03 << S2MPA01_ENABLE_SHIFT)
+#define S2MPA01_ENABLE_SHIFT	0x06
+#define S2MPA01_LDO_N_VOLTAGES	(S2MPA01_LDO_VSEL_MASK + 1)
+#define S2MPA01_BUCK_N_VOLTAGES (S2MPA01_BUCK_VSEL_MASK + 1)
+
+#define S2MPA01_RAMP_DELAY	12500	/* uV/us */
+
+#define S2MPA01_BUCK16_RAMP_SHIFT	4
+#define S2MPA01_BUCK24_RAMP_SHIFT	6
+#define S2MPA01_BUCK3_RAMP_SHIFT	4
+#define S2MPA01_BUCK5_RAMP_SHIFT	6
+#define S2MPA01_BUCK7_RAMP_SHIFT	2
+#define S2MPA01_BUCK8910_RAMP_SHIFT	0
+
+#define S2MPA01_BUCK1_RAMP_EN_SHIFT	3
+#define S2MPA01_BUCK2_RAMP_EN_SHIFT	2
+#define S2MPA01_BUCK3_RAMP_EN_SHIFT	1
+#define S2MPA01_BUCK4_RAMP_EN_SHIFT	0
+#define S2MPA01_PMIC_EN_SHIFT	6
+
+#endif /*__LINUX_MFD_S2MPA01_H */
-- 
1.7.9.5

