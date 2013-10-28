Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3J1TQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:16:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45253 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3J1TOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:14:10 -0400
Message-Id: <1392ea90487793f9cbbdfb7f8d148f45122a52c2.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <cover.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 28 Oct 2013 13:12:35 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, rtc-linux@googlegroups.com,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v3 10/10] rtc: pm8xxx: add support for pm8941
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the existing pm8xxx driver to work with the RTC available on
Qualcomm's 8941 PMIC.  In order to do this, rework the register access
functions to use a regmap provided by the parent driver.  Account for
slight differences in the RTC address space by parameterizing addresses
and providing a chip-specific initialization function.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/rtc/Kconfig      |   1 -
 drivers/rtc/rtc-pm8xxx.c | 229 +++++++++++++++++++++++++++++------------------
 2 files changed, 143 insertions(+), 87 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9654aa3..19b89ee 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1177,7 +1177,6 @@ config RTC_DRV_LPC32XX
 
 config RTC_DRV_PM8XXX
 	tristate "Qualcomm PMIC8XXX RTC"
-	depends on MFD_PM8XXX
 	help
 	  If you say yes here you get support for the
 	  Qualcomm PMIC8XXX RTC.
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 03f8f75..a9044d4 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -1,4 +1,5 @@
 /* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -13,35 +14,33 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/rtc.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
 #include <linux/mfd/pm8xxx/core.h>
 #include <linux/mfd/pm8xxx/rtc.h>
 
-
-/* RTC Register offsets from RTC CTRL REG */
-#define PM8XXX_ALARM_CTRL_OFFSET	0x01
-#define PM8XXX_RTC_WRITE_OFFSET		0x02
-#define PM8XXX_RTC_READ_OFFSET		0x06
-#define PM8XXX_ALARM_RW_OFFSET		0x0A
-
 /* RTC_CTRL register bit fields */
 #define PM8xxx_RTC_ENABLE		BIT(7)
 #define PM8xxx_RTC_ALARM_ENABLE		BIT(1)
 #define PM8xxx_RTC_ALARM_CLEAR		BIT(0)
 
 #define NUM_8_BIT_RTC_REGS		0x4
-
 /**
  * struct pm8xxx_rtc -  rtc driver internal structure
  * @rtc:		rtc device for this driver.
  * @rtc_alarm_irq:	rtc alarm irq number.
- * @rtc_base:		address of rtc control register.
+ * @rtc_control_reg:	address of control register.
  * @rtc_read_base:	base address of read registers.
  * @rtc_write_base:	base address of write registers.
  * @alarm_rw_base:	base address of alarm registers.
+ * @alarm_ctrl1:	address of alarm ctrl1 register.
+ * @alarm_ctrl2:	address of alarm ctrl2 register (only used on pm8941).
+ * @alarm_clear:	RTC-specific callback to clear alarm interrupt.
  * @ctrl_reg:		rtc control register.
  * @rtc_dev:		device structure.
  * @ctrl_reg_lock:	spinlock protecting access to ctrl_reg.
@@ -49,51 +48,34 @@
 struct pm8xxx_rtc {
 	struct rtc_device *rtc;
 	int rtc_alarm_irq;
-	int rtc_base;
+	int rtc_control_reg;
 	int rtc_read_base;
 	int rtc_write_base;
 	int alarm_rw_base;
-	u8  ctrl_reg;
+	int alarm_ctrl1;
+	int alarm_ctrl2;
+	int (*alarm_clear)(struct pm8xxx_rtc *);
+	u8 ctrl_reg;
 	struct device *rtc_dev;
 	spinlock_t ctrl_reg_lock;
+	struct regmap *regmap;
 };
 
 /*
  * The RTC registers need to be read/written one byte at a time. This is a
  * hardware limitation.
  */
-static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-		int base, int count)
+static inline int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
+				      int base, int count)
 {
-	int i, rc;
-	struct device *parent = rtc_dd->rtc_dev->parent;
-
-	for (i = 0; i < count; i++) {
-		rc = pm8xxx_readb(parent, base + i, &rtc_val[i]);
-		if (rc < 0) {
-			dev_err(rtc_dd->rtc_dev, "PMIC read failed\n");
-			return rc;
-		}
-	}
-
-	return 0;
+	return regmap_bulk_read(rtc_dd->regmap, base, rtc_val, count);
 }
 
-static int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-		int base, int count)
+static inline int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd,
+				       const u8 *rtc_val,
+				       int base, int count)
 {
-	int i, rc;
-	struct device *parent = rtc_dd->rtc_dev->parent;
-
-	for (i = 0; i < count; i++) {
-		rc = pm8xxx_writeb(parent, base + i, rtc_val[i]);
-		if (rc < 0) {
-			dev_err(rtc_dd->rtc_dev, "PMIC write failed\n");
-			return rc;
-		}
-	}
-
-	return 0;
+	return regmap_bulk_write(rtc_dd->regmap, base, rtc_val, count);
 }
 
 /*
@@ -125,8 +107,8 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	if (ctrl_reg & PM8xxx_RTC_ALARM_ENABLE) {
 		alarm_enabled = 1;
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-				1);
+		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg,
+					  rtc_dd->rtc_control_reg, 1);
 		if (rc < 0) {
 			dev_err(dev, "Write to RTC control register "
 								"failed\n");
@@ -161,8 +143,8 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	if (alarm_enabled) {
 		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-									1);
+		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg,
+					  rtc_dd->rtc_control_reg, 1);
 		if (rc < 0) {
 			dev_err(dev, "Write to RTC control register "
 								"failed\n");
@@ -255,7 +237,8 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
 					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
+	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg,
+				  rtc_dd->rtc_control_reg, 1);
 	if (rc < 0) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
@@ -316,7 +299,8 @@ static int pm8xxx_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 	ctrl_reg = (enable) ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
 				(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
+	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg,
+				  rtc_dd->rtc_control_reg, 1);
 	if (rc < 0) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
@@ -351,7 +335,8 @@ static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 	ctrl_reg = rtc_dd->ctrl_reg;
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
+	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg,
+				  rtc_dd->rtc_control_reg, 1);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 		dev_err(rtc_dd->rtc_dev, "Write to RTC control register "
@@ -363,37 +348,105 @@ static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	/* Clear RTC alarm register */
-	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-						PM8XXX_ALARM_CTRL_OFFSET, 1);
+	rc = rtc_dd->alarm_clear(rtc_dd);
+	if (rc < 0)
+		dev_err(rtc_dd->rtc_dev, "failed to clear RTC alarm\n");
+
+rtc_alarm_handled:
+	return IRQ_HANDLED;
+}
+
+static int pm8941_alarm_clear(struct pm8xxx_rtc *rtc_dd)
+{
+	u8 ctrl = PM8xxx_RTC_ALARM_CLEAR;
+	return pm8xxx_write_wrapper(rtc_dd, &ctrl, rtc_dd->alarm_ctrl2, 1);
+}
+
+static int pm8941_chip_init(struct platform_device *pdev,
+			    struct pm8xxx_rtc *rtc)
+{
+	u32 addr[2];
+	int err;
+
+	err = of_property_read_u32_array(pdev->dev.of_node,
+					 "reg", addr, 2);
+	if (err || addr[0] > 0xFFFF || addr[1] > 0xFFFF) {
+		dev_err(&pdev->dev, "RTC IO resources absent or invalid\n");
+		return err;
+	}
+
+	rtc->alarm_clear = pm8941_alarm_clear;
+
+	rtc->rtc_control_reg = addr[0] + 0x46;
+	rtc->rtc_write_base  = addr[0] + 0x40;
+	rtc->rtc_read_base   = addr[0] + 0x48;
+	rtc->alarm_rw_base   = addr[1] + 0x40;
+	rtc->alarm_ctrl1     = addr[1] + 0x46;
+	rtc->alarm_ctrl2     = addr[1] + 0x48;
+	return 0;
+}
+
+static int pm8xxx_alarm_clear(struct pm8xxx_rtc *rtc_dd)
+{
+	u8 ctrl_reg;
+	int rc;
+
+	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->alarm_ctrl1, 1);
 	if (rc < 0) {
 		dev_err(rtc_dd->rtc_dev, "RTC Alarm control register read "
 								"failed\n");
-		goto rtc_alarm_handled;
+		return rc;
 	}
 
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_CLEAR;
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-						PM8XXX_ALARM_CTRL_OFFSET, 1);
-	if (rc < 0)
-		dev_err(rtc_dd->rtc_dev, "Write to RTC Alarm control register"
-								" failed\n");
+	return pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->alarm_ctrl1, 1);
+}
 
-rtc_alarm_handled:
-	return IRQ_HANDLED;
+static int pm8xxx_chip_init(struct platform_device *pdev,
+			    struct pm8xxx_rtc *rtc)
+{
+	const struct pm8xxx_rtc_platform_data *pdata =
+				dev_get_platdata(&pdev->dev);
+	struct resource *res;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data not initialized.\n");
+		return -ENXIO;
+	}
+
+	if (pdata->rtc_write_enable)
+		pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IO,
+					   "pmic_rtc_base");
+	if (!res) {
+		dev_err(&pdev->dev, "RTC IO resource absent\n");
+		return -ENXIO;
+	}
+
+	rtc->rtc_control_reg = res->start;
+	rtc->rtc_write_base  = res->start + 0x02;
+	rtc->rtc_read_base   = res->start + 0x06;
+	rtc->alarm_rw_base   = res->start + 0x0A;
+	rtc->alarm_ctrl1     = res->start + 0x01;
+
+	rtc->alarm_clear = pm8xxx_alarm_clear;
+	return 0;
 }
 
+static const struct of_device_id pm8xxx_rtc_idtable[] = {
+	{ .compatible = "qcom,pm8941-rtc", pm8941_chip_init },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_rtc_idtable);
+
 static int pm8xxx_rtc_probe(struct platform_device *pdev)
 {
-	int rc;
-	u8 ctrl_reg;
-	bool rtc_write_enable = false;
+	int (*chip_init)(struct platform_device *pdev, struct pm8xxx_rtc *rtc);
+	const struct device_node *node = pdev->dev.of_node;
 	struct pm8xxx_rtc *rtc_dd;
-	struct resource *rtc_resource;
-	const struct pm8xxx_rtc_platform_data *pdata =
-						dev_get_platdata(&pdev->dev);
-
-	if (pdata != NULL)
-		rtc_write_enable = pdata->rtc_write_enable;
+	u8 ctrl_reg;
+	int rc;
 
 	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
 	if (rtc_dd == NULL) {
@@ -401,33 +454,40 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	/* Initialise spinlock to protect RTC control register */
-	spin_lock_init(&rtc_dd->ctrl_reg_lock);
+	chip_init = pm8xxx_chip_init;
+	if (node) {
+		const
+		struct of_device_id *id = of_match_node(pm8xxx_rtc_idtable,
+							pdev->dev.of_node);
+		if (id && id->data)
+			chip_init = id->data;
+	}
 
-	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
-	if (rtc_dd->rtc_alarm_irq < 0) {
-		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
+	rc = chip_init(pdev, rtc_dd);
+	if (rc) {
+		dev_err(&pdev->dev, "Failed to initialize chip.\n");
 		return -ENXIO;
 	}
 
-	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
-							"pmic_rtc_base");
-	if (!(rtc_resource && rtc_resource->start)) {
-		dev_err(&pdev->dev, "RTC IO resource absent!\n");
+	rtc_dd->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!rtc_dd->regmap) {
+		dev_err(&pdev->dev, "Unable to get regmap.\n");
 		return -ENXIO;
 	}
 
-	rtc_dd->rtc_base = rtc_resource->start;
+	/* Initialise spinlock to protect RTC control register */
+	spin_lock_init(&rtc_dd->ctrl_reg_lock);
 
-	/* Setup RTC register addresses */
-	rtc_dd->rtc_write_base = rtc_dd->rtc_base + PM8XXX_RTC_WRITE_OFFSET;
-	rtc_dd->rtc_read_base = rtc_dd->rtc_base + PM8XXX_RTC_READ_OFFSET;
-	rtc_dd->alarm_rw_base = rtc_dd->rtc_base + PM8XXX_ALARM_RW_OFFSET;
+	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
+	if (rtc_dd->rtc_alarm_irq < 0) {
+		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
+		return -ENXIO;
+	}
 
 	rtc_dd->rtc_dev = &pdev->dev;
 
 	/* Check if the RTC is on, else turn it on */
-	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
+	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_control_reg, 1);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "RTC control register read failed!\n");
 		return rc;
@@ -435,8 +495,8 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 
 	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
 		ctrl_reg |= PM8xxx_RTC_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-									1);
+		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg,
+					  rtc_dd->rtc_control_reg, 1);
 		if (rc < 0) {
 			dev_err(&pdev->dev, "Write to RTC control register "
 								"failed\n");
@@ -444,10 +504,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	rtc_dd->ctrl_reg = ctrl_reg;
-	if (rtc_write_enable == true)
-		pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
-
 	platform_set_drvdata(pdev, rtc_dd);
 
 	/* Register the RTC device */
@@ -516,6 +572,7 @@ static struct platform_driver pm8xxx_rtc_driver = {
 		.name	= PM8XXX_RTC_DEV_NAME,
 		.owner	= THIS_MODULE,
 		.pm	= &pm8xxx_rtc_pm_ops,
+		.of_match_table	= pm8xxx_rtc_idtable,
 	},
 };
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

