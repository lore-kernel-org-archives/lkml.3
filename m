Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaBQInM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:43:12 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38460 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaBQIko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:44 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-d3-5301cb0be9c9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 09/13] mfd: sec: Add support for S2MPS14
Date: Mon, 17 Feb 2014 09:40:23 +0100
Message-id: <1392626427-4518-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
References: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xK7rcpxmDDd6vFbLYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjBZrJ/xmsVizvR3TA7cHneu7WHz
	mHcy0KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgyVm2wLVhaXfHuxnGWBsZTKV2MHBwSAiYS
	Rz/HdjFyApliEhfurWfrYuTiEBJYyijx+/Bcdginj0ni1dODjCBVbALGEpuXLwGrEhHYzCix
	+PtVVhCHWWAmk8Sfmw+YQMYKC1hLbLueBtLAIqAqcar3AliYV8Bd4k6vJMRiBYk5k2xAKjiB
	ok/7prKChIUE3CT2bwybwMi7gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZImH3dwbj0
	mNUhRgEORiUeXoNqxmAh1sSy4srcQ4wSHMxKIry264BCvCmJlVWpRfnxRaU5qcWHGJk4OKUa
	GI9X3pjybW3xk9exDxYfXpcT5vv4R/pfpc9N5zy26xWvjv2k1Xj7kURD9C739yLP3E8dtdkf
	xsSpJ6lrcyut/+HGmlYLZvE/k8weRSZ8TFX4o8MuqzJl57mXmeaMbNfOM5U82b+7PXfjuwOn
	2y9miHxp+fnORuR0b03/qWXXrI9GhS2d4Fv5rFOJpTgj0VCLuag4EQBEhZgEEQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for S2MPS14 PMIC device to the MFD sec-core driver.
The S2MPS14 is similar to S2MPS11 but it has fewer regulators, two
clocks instead of three and a little different registers layout.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-core.c              |   48 +++++++++--
 drivers/mfd/sec-irq.c               |   89 +++++++++++++++++++-
 include/linux/mfd/samsung/core.h    |    1 +
 include/linux/mfd/samsung/irq.h     |   27 +++++++
 include/linux/mfd/samsung/rtc.h     |   56 +++++++++++--
 include/linux/mfd/samsung/s2mps14.h |  152 +++++++++++++++++++++++++++++++++++
 6 files changed, 361 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 8504de82b7e0..6e5343255633 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/regmap.h>
@@ -69,6 +70,16 @@ static const struct mfd_cell s2mps11_devs[] = {
 	}
 };
 
+static const struct mfd_cell s2mps14_devs[] = {
+	{
+		.name = "s2mps14-pmic",
+	}, {
+		.name = "s2mps14-rtc",
+	}, {
+		.name = "s2mps14-clk",
+	}
+};
+
 #ifdef CONFIG_OF
 static struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
@@ -77,6 +88,9 @@ static struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s2mps11-pmic",
 		.data = (void *)S2MPS11X,
 	},
+	{	.compatible = "samsung,s2mps14-pmic",
+		.data = (void *)S2MPS14X,
+	},
 	{},
 };
 #endif
@@ -120,6 +134,15 @@ static const struct regmap_config s2mps11_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
+static const struct regmap_config s2mps14_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPS14_REG_LDODSCH3,
+	.volatile_reg = s2mps11_volatile,
+	.cache_type = REGCACHE_FLAT,
+};
+
 static const struct regmap_config s5m8763_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -138,13 +161,20 @@ static const struct regmap_config s5m8767_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
-static const struct regmap_config sec_rtc_regmap_config = {
+static const struct regmap_config s5m_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
 	.max_register = S5M_RTC_REG_MAX,
 };
 
+static const struct regmap_config s2mps14_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPS_RTC_REG_MAX,
+};
+
 #ifdef CONFIG_OF
 /*
  * Only the common platform data elements for s5m8767 are parsed here from the
@@ -239,19 +269,23 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		 * However we must pass something to devm_regmap_init_i2c()
 		 * so use S5M-like regmap config even though it wouldn't work.
 		 */
-		regmap_rtc = &sec_rtc_regmap_config;
+		regmap_rtc = &s5m_rtc_regmap_config;
+		break;
+	case S2MPS14X:
+		regmap = &s2mps14_regmap_config;
+		regmap_rtc = &s2mps14_rtc_regmap_config;
 		break;
 	case S5M8763X:
 		regmap = &s5m8763_regmap_config;
-		regmap_rtc = &sec_rtc_regmap_config;
+		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	case S5M8767X:
 		regmap = &s5m8767_regmap_config;
-		regmap_rtc = &sec_rtc_regmap_config;
+		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	default:
 		regmap = &sec_regmap_config;
-		regmap_rtc = &sec_rtc_regmap_config;
+		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	}
 
@@ -302,6 +336,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
 				      ARRAY_SIZE(s2mps11_devs), NULL, 0, NULL);
 		break;
+	case S2MPS14X:
+		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps14_devs,
+				      ARRAY_SIZE(s2mps14_devs), NULL, 0, NULL);
+		break;
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index e403c293b437..64e7913aadc6 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -1,7 +1,7 @@
 /*
  * sec-irq.c
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd
  *              http://www.samsung.com
  *
  *  This program is free software; you can redistribute  it and/or modify it
@@ -19,6 +19,7 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
@@ -89,6 +90,76 @@ static const struct regmap_irq s2mps11_irqs[] = {
 	},
 };
 
+static const struct regmap_irq s2mps14_irqs[] = {
+	[S2MPS14_IRQ_PWRONF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRONF_MASK,
+	},
+	[S2MPS14_IRQ_PWRONR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRONR_MASK,
+	},
+	[S2MPS14_IRQ_JIGONBF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_JIGONBF_MASK,
+	},
+	[S2MPS14_IRQ_JIGONBR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_JIGONBR_MASK,
+	},
+	[S2MPS14_IRQ_ACOKBF] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_ACOKBF_MASK,
+	},
+	[S2MPS14_IRQ_ACOKBR] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_ACOKBR_MASK,
+	},
+	[S2MPS14_IRQ_PWRON1S] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_PWRON1S_MASK,
+	},
+	[S2MPS14_IRQ_MRB] = {
+		.reg_offset = 0,
+		.mask = S2MPS11_IRQ_MRB_MASK,
+	},
+	[S2MPS14_IRQ_RTC60S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTC60S_MASK,
+	},
+	[S2MPS14_IRQ_RTCA1] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTCA1_MASK,
+	},
+	[S2MPS14_IRQ_RTCA0] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTCA0_MASK,
+	},
+	[S2MPS14_IRQ_SMPL] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_SMPL_MASK,
+	},
+	[S2MPS14_IRQ_RTC1S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_RTC1S_MASK,
+	},
+	[S2MPS14_IRQ_WTSR] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_WTSR_MASK,
+	},
+	[S2MPS14_IRQ_INT120C] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_INT120C_MASK,
+	},
+	[S2MPS14_IRQ_INT140C] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_INT140C_MASK,
+	},
+	[S2MPS14_IRQ_TSD] = {
+		.reg_offset = 2,
+		.mask = S2MPS14_IRQ_TSD_MASK,
+	},
+};
 
 static const struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
@@ -246,6 +317,16 @@ static const struct regmap_irq_chip s2mps11_irq_chip = {
 	.ack_base = S2MPS11_REG_INT1,
 };
 
+static const struct regmap_irq_chip s2mps14_irq_chip = {
+	.name = "s2mps14",
+	.irqs = s2mps14_irqs,
+	.num_irqs = ARRAY_SIZE(s2mps14_irqs),
+	.num_regs = 3,
+	.status_base = S2MPS14_REG_INT1,
+	.mask_base = S2MPS14_REG_INT1M,
+	.ack_base = S2MPS14_REG_INT1,
+};
+
 static const struct regmap_irq_chip s5m8767_irq_chip = {
 	.name = "s5m8767",
 	.irqs = s5m8767_irqs,
@@ -297,6 +378,12 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 				  sec_pmic->irq_base, &s2mps11_irq_chip,
 				  &sec_pmic->irq_data);
 		break;
+	case S2MPS14X:
+		ret = regmap_add_irq_chip(sec_pmic->regmap_pmic, sec_pmic->irq,
+				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				  sec_pmic->irq_base, &s2mps14_irq_chip,
+				  &sec_pmic->irq_data);
+		break;
 	default:
 		dev_err(sec_pmic->dev, "Unknown device type %d\n",
 			sec_pmic->device_type);
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 55510444b9fd..e517b12f290f 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -19,6 +19,7 @@ enum sec_device_type {
 	S5M8763X,
 	S5M8767X,
 	S2MPS11X,
+	S2MPS14X,
 };
 
 /**
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index abe1a6aae3b7..0065f6f1daf4 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -55,6 +55,33 @@ enum s2mps11_irq {
 #define S2MPS11_IRQ_INT120C_MASK	(1 << 0)
 #define S2MPS11_IRQ_INT140C_MASK	(1 << 1)
 
+enum s2mps14_irq {
+	S2MPS14_IRQ_PWRONF,
+	S2MPS14_IRQ_PWRONR,
+	S2MPS14_IRQ_JIGONBF,
+	S2MPS14_IRQ_JIGONBR,
+	S2MPS14_IRQ_ACOKBF,
+	S2MPS14_IRQ_ACOKBR,
+	S2MPS14_IRQ_PWRON1S,
+	S2MPS14_IRQ_MRB,
+
+	S2MPS14_IRQ_RTC60S,
+	S2MPS14_IRQ_RTCA1,
+	S2MPS14_IRQ_RTCA0,
+	S2MPS14_IRQ_SMPL,
+	S2MPS14_IRQ_RTC1S,
+	S2MPS14_IRQ_WTSR,
+
+	S2MPS14_IRQ_INT120C,
+	S2MPS14_IRQ_INT140C,
+	S2MPS14_IRQ_TSD,
+
+	S2MPS14_IRQ_NR,
+};
+
+/* Masks for interrupts are the same as in s2mps11 */
+#define S2MPS14_IRQ_TSD_MASK		(1 << 2)
+
 enum s5m8767_irq {
 	S5M8767_IRQ_PWRR,
 	S5M8767_IRQ_PWRF,
diff --git a/include/linux/mfd/samsung/rtc.h b/include/linux/mfd/samsung/rtc.h
index bdf0573891d0..fa0fc32c763a 100644
--- a/include/linux/mfd/samsung/rtc.h
+++ b/include/linux/mfd/samsung/rtc.h
@@ -1,12 +1,17 @@
-/*  rtc.h
+/* rtc.h
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd
  *              http://www.samsung.com
  *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  */
 
@@ -47,15 +52,50 @@ enum s5m_rtc_reg {
 	S5M_RTC_REG_MAX,
 };
 
+enum s2mps_rtc_reg {
+	S2MPS_RTC_CTRL,
+	S2MPS_WTSR_SMPL_CNTL,
+	S2MPS_RTC_UDR_CON,
+	S2MPS_RSVD,
+	S2MPS_RTC_SEC,
+	S2MPS_RTC_MIN,
+	S2MPS_RTC_HOUR,
+	S2MPS_RTC_WEEKDAY,
+	S2MPS_RTC_DATE,
+	S2MPS_RTC_MONTH,
+	S2MPS_RTC_YEAR,
+	S2MPS_ALARM0_SEC,
+	S2MPS_ALARM0_MIN,
+	S2MPS_ALARM0_HOUR,
+	S2MPS_ALARM0_WEEKDAY,
+	S2MPS_ALARM0_DATE,
+	S2MPS_ALARM0_MONTH,
+	S2MPS_ALARM0_YEAR,
+	S2MPS_ALARM1_SEC,
+	S2MPS_ALARM1_MIN,
+	S2MPS_ALARM1_HOUR,
+	S2MPS_ALARM1_WEEKDAY,
+	S2MPS_ALARM1_DATE,
+	S2MPS_ALARM1_MONTH,
+	S2MPS_ALARM1_YEAR,
+	S2MPS_OFFSRC,
+
+	S2MPS_RTC_REG_MAX,
+};
+
 #define RTC_I2C_ADDR		(0x0C >> 1)
 
 #define HOUR_12			(1 << 7)
 #define HOUR_AMPM		(1 << 6)
 #define HOUR_PM			(1 << 5)
+
 #define S5M_ALARM0_STATUS	(1 << 1)
 #define S5M_ALARM1_STATUS	(1 << 2)
 #define S5M_UPDATE_AD		(1 << 0)
 
+#define S2MPS_ALARM0_STATUS	(1 << 2)
+#define S2MPS_ALARM1_STATUS	(1 << 1)
+
 /* RTC Control Register */
 #define BCD_EN_SHIFT		0
 #define BCD_EN_MASK		(1 << BCD_EN_SHIFT)
@@ -64,6 +104,10 @@ enum s5m_rtc_reg {
 /* RTC Update Register1 */
 #define S5M_RTC_UDR_SHIFT	0
 #define S5M_RTC_UDR_MASK	(1 << S5M_RTC_UDR_SHIFT)
+#define S2MPS_RTC_WUDR_SHIFT	4
+#define S2MPS_RTC_WUDR_MASK	(1 << S2MPS_RTC_WUDR_SHIFT)
+#define S2MPS_RTC_RUDR_SHIFT	0
+#define S2MPS_RTC_RUDR_MASK	(1 << S2MPS_RTC_RUDR_SHIFT)
 #define RTC_TCON_SHIFT		1
 #define RTC_TCON_MASK		(1 << RTC_TCON_SHIFT)
 #define S5M_RTC_TIME_EN_SHIFT	3
diff --git a/include/linux/mfd/samsung/s2mps14.h b/include/linux/mfd/samsung/s2mps14.h
new file mode 100644
index 000000000000..ec1e0857ddde
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mps14.h
@@ -0,0 +1,152 @@
+/*
+ * s2mps14.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPS14_H
+#define __LINUX_MFD_S2MPS14_H
+
+/* S2MPS14 registers */
+enum s2mps14_reg {
+	S2MPS14_REG_ID,
+	S2MPS14_REG_INT1,
+	S2MPS14_REG_INT2,
+	S2MPS14_REG_INT3,
+	S2MPS14_REG_INT1M,
+	S2MPS14_REG_INT2M,
+	S2MPS14_REG_INT3M,
+	S2MPS14_REG_ST1,
+	S2MPS14_REG_ST2,
+	S2MPS14_REG_PWRONSRC,
+	S2MPS14_REG_OFFSRC,
+	S2MPS14_REG_BU_CHG,
+	S2MPS14_REG_RTCCTRL,
+	S2MPS14_REG_CTRL1,
+	S2MPS14_REG_CTRL2,
+	S2MPS14_REG_RSVD1,
+	S2MPS14_REG_RSVD2,
+	S2MPS14_REG_RSVD3,
+	S2MPS14_REG_RSVD4,
+	S2MPS14_REG_RSVD5,
+	S2MPS14_REG_RSVD6,
+	S2MPS14_REG_CTRL3,
+	S2MPS14_REG_RSVD7,
+	S2MPS14_REG_RSVD8,
+	S2MPS14_REG_WRSTBI,
+	S2MPS14_REG_B1CTRL1,
+	S2MPS14_REG_B1CTRL2,
+	S2MPS14_REG_B2CTRL1,
+	S2MPS14_REG_B2CTRL2,
+	S2MPS14_REG_B3CTRL1,
+	S2MPS14_REG_B3CTRL2,
+	S2MPS14_REG_B4CTRL1,
+	S2MPS14_REG_B4CTRL2,
+	S2MPS14_REG_B5CTRL1,
+	S2MPS14_REG_B5CTRL2,
+	S2MPS14_REG_L1CTRL,
+	S2MPS14_REG_L2CTRL,
+	S2MPS14_REG_L3CTRL,
+	S2MPS14_REG_L4CTRL,
+	S2MPS14_REG_L5CTRL,
+	S2MPS14_REG_L6CTRL,
+	S2MPS14_REG_L7CTRL,
+	S2MPS14_REG_L8CTRL,
+	S2MPS14_REG_L9CTRL,
+	S2MPS14_REG_L10CTRL,
+	S2MPS14_REG_L11CTRL,
+	S2MPS14_REG_L12CTRL,
+	S2MPS14_REG_L13CTRL,
+	S2MPS14_REG_L14CTRL,
+	S2MPS14_REG_L15CTRL,
+	S2MPS14_REG_L16CTRL,
+	S2MPS14_REG_L17CTRL,
+	S2MPS14_REG_L18CTRL,
+	S2MPS14_REG_L19CTRL,
+	S2MPS14_REG_L20CTRL,
+	S2MPS14_REG_L21CTRL,
+	S2MPS14_REG_L22CTRL,
+	S2MPS14_REG_L23CTRL,
+	S2MPS14_REG_L24CTRL,
+	S2MPS14_REG_L25CTRL,
+	S2MPS14_REG_LDODSCH1,
+	S2MPS14_REG_LDODSCH2,
+	S2MPS14_REG_LDODSCH3,
+};
+
+/* S2MPS14 regulator ids */
+enum s2mps14_regulators {
+	S2MPS14_LDO1,
+	S2MPS14_LDO2,
+	S2MPS14_LDO3,
+	S2MPS14_LDO4,
+	S2MPS14_LDO5,
+	S2MPS14_LDO6,
+	S2MPS14_LDO7,
+	S2MPS14_LDO8,
+	S2MPS14_LDO9,
+	S2MPS14_LDO10,
+	S2MPS14_LDO11,
+	S2MPS14_LDO12,
+	S2MPS14_LDO13,
+	S2MPS14_LDO14,
+	S2MPS14_LDO15,
+	S2MPS14_LDO16,
+	S2MPS14_LDO17,
+	S2MPS14_LDO18,
+	S2MPS14_LDO19,
+	S2MPS14_LDO20,
+	S2MPS14_LDO21,
+	S2MPS14_LDO22,
+	S2MPS14_LDO23,
+	S2MPS14_LDO24,
+	S2MPS14_LDO25,
+	S2MPS14_BUCK1,
+	S2MPS14_BUCK2,
+	S2MPS14_BUCK3,
+	S2MPS14_BUCK4,
+	S2MPS14_BUCK5,
+
+	S2MPS14_REGULATOR_MAX,
+};
+
+/* Regulator constraints for BUCKx */
+#define S2MPS14_BUCK1235_MIN_600MV	600000
+#define S2MPS14_BUCK4_MIN_1400MV	1400000
+#define S2MPS14_BUCK1235_STEP_6_25MV	6250
+#define S2MPS14_BUCK4_STEP_12_5MV	12500
+#define S2MPS14_BUCK1235_START_SEL	0x20
+#define S2MPS14_BUCK4_START_SEL		0x40
+/*
+ * Default ramp delay in uv/us. Datasheet says that ramp delay can be
+ * controlled however it does not specify which register is used for that.
+ * Let's assume that default value will be set.
+ */
+#define S2MPS14_BUCK_RAMP_DELAY		12500
+
+/* Regulator constraints for different types of LDOx */
+#define S2MPS14_LDO_MIN_800MV		800000
+#define S2MPS14_LDO_MIN_1800MV		1800000
+#define S2MPS14_LDO_STEP_12_5MV		12500
+#define S2MPS14_LDO_STEP_25MV		25000
+
+#define S2MPS14_LDO_VSEL_MASK		0x3F
+#define S2MPS14_BUCK_VSEL_MASK		0xFF
+#define S2MPS14_ENABLE_MASK		(0x03 << S2MPS14_ENABLE_SHIFT)
+#define S2MPS14_ENABLE_SHIFT		6
+#define S2MPS14_LDO_N_VOLTAGES		(S2MPS14_LDO_VSEL_MASK + 1)
+#define S2MPS14_BUCK_N_VOLTAGES		(S2MPS14_BUCK_VSEL_MASK + 1)
+
+#endif /*  __LINUX_MFD_S2MPS14_H */
-- 
1.7.9.5

