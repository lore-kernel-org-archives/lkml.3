Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaCETca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:32:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59847 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaCETc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:32:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] rtc: pm8xxx: use regmap API for register accesses
Date: Wed,  5 Mar 2014 13:29:32 -0600
Message-Id: <1394047776-13827-3-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the parent mfd driver has been made to work again, and has been
reworked to create a regmap instance intended for it's children to use,
rework the pm8xxx driver to use the regmap API for it's register
accesses.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c | 145 +++++++++++++++++++----------------------------
 1 file changed, 57 insertions(+), 88 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 772b070..f6d140a 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -13,11 +13,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/rtc.h>
+#include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <linux/mfd/pm8xxx/core.h>
 #include <linux/mfd/pm8xxx/rtc.h>
 
 
@@ -37,6 +38,7 @@
 /**
  * struct pm8xxx_rtc -  rtc driver internal structure
  * @rtc:		rtc device for this driver.
+ * @regmap:		regmap used to access RTC registers
  * @rtc_alarm_irq:	rtc alarm irq number.
  * @rtc_base:		address of rtc control register.
  * @rtc_read_base:	base address of read registers.
@@ -48,6 +50,7 @@
  */
 struct pm8xxx_rtc {
 	struct rtc_device *rtc;
+	struct regmap *regmap;
 	int rtc_alarm_irq;
 	int rtc_base;
 	int rtc_read_base;
@@ -59,44 +62,6 @@ struct pm8xxx_rtc {
 };
 
 /*
- * The RTC registers need to be read/written one byte at a time. This is a
- * hardware limitation.
- */
-static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-			       int base, int count)
-{
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
-}
-
-static int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-				int base, int count)
-{
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
-}
-
-/*
  * Steps to write the RTC registers.
  * 1. Disable alarm if enabled.
  * 2. Write 0x00 to LSB.
@@ -107,7 +72,7 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	int rc, i;
 	unsigned long secs, irq_flags;
-	u8 value[NUM_8_BIT_RTC_REGS], reg = 0, alarm_enabled = 0, ctrl_reg;
+	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0, ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(tm, &secs);
@@ -125,9 +90,8 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	if (ctrl_reg & PM8xxx_RTC_ALARM_ENABLE) {
 		alarm_enabled = 1;
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-					  1);
-		if (rc < 0) {
+		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
@@ -137,33 +101,31 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	}
 
 	/* Write 0 to Byte[0] */
-	reg = 0;
-	rc = pm8xxx_write_wrapper(rtc_dd, &reg, rtc_dd->rtc_write_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_write_base, 0);
+	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	/* Write Byte[1], Byte[2], Byte[3] */
-	rc = pm8xxx_write_wrapper(rtc_dd, value + 1,
-				  rtc_dd->rtc_write_base + 1, 3);
-	if (rc < 0) {
+	rc = regmap_bulk_write(rtc_dd->regmap, rtc_dd->rtc_write_base + 1,
+			       &value[1], sizeof(value) - 1);
+	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	/* Write Byte[0] */
-	rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->rtc_write_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_write_base, value[0]);
+	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	if (alarm_enabled) {
 		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-					  1);
-		if (rc < 0) {
+		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
@@ -180,13 +142,14 @@ rtc_rw_fail:
 static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	int rc;
-	u8 value[NUM_8_BIT_RTC_REGS], reg;
+	u8 value[NUM_8_BIT_RTC_REGS];
 	unsigned long secs;
+	unsigned int reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
-	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->rtc_read_base,
-				 NUM_8_BIT_RTC_REGS);
-	if (rc < 0) {
+	rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->rtc_read_base,
+			      value, sizeof(value));
+	if (rc) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
 	}
@@ -195,17 +158,16 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	 * Read the LSB again and check if there has been a carry over.
 	 * If there is, redo the read operation.
 	 */
-	rc = pm8xxx_read_wrapper(rtc_dd, &reg, rtc_dd->rtc_read_base, 1);
+	rc = regmap_read(rtc_dd->regmap, rtc_dd->rtc_read_base, &reg);
 	if (rc < 0) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
 	}
 
 	if (unlikely(reg < value[0])) {
-		rc = pm8xxx_read_wrapper(rtc_dd, value,
-					 rtc_dd->rtc_read_base,
-					 NUM_8_BIT_RTC_REGS);
-		if (rc < 0) {
+		rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->rtc_read_base,
+				      value, sizeof(value));
+		if (rc) {
 			dev_err(dev, "RTC read data register failed\n");
 			return rc;
 		}
@@ -244,9 +206,9 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
-	rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-				  NUM_8_BIT_RTC_REGS);
-	if (rc < 0) {
+	rc = regmap_bulk_write(rtc_dd->regmap, rtc_dd->alarm_rw_base, value,
+			       sizeof(value));
+	if (rc) {
 		dev_err(dev, "Write to RTC ALARM register failed\n");
 		goto rtc_rw_fail;
 	}
@@ -255,8 +217,8 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
 				    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	if (rc) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
 	}
@@ -279,9 +241,9 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	unsigned long secs;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
-	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-				 NUM_8_BIT_RTC_REGS);
-	if (rc < 0) {
+	rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->alarm_rw_base, value,
+			      sizeof(value));
+	if (rc) {
 		dev_err(dev, "RTC alarm time read failed\n");
 		return rc;
 	}
@@ -316,8 +278,8 @@ static int pm8xxx_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 	ctrl_reg = enable ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
 			    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	if (rc) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
 	}
@@ -339,7 +301,7 @@ static struct rtc_class_ops pm8xxx_rtc_ops = {
 static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 {
 	struct pm8xxx_rtc *rtc_dd = dev_id;
-	u8 ctrl_reg;
+	unsigned int ctrl_reg;
 	int rc;
 	unsigned long irq_flags;
 
@@ -351,8 +313,8 @@ static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 	ctrl_reg = rtc_dd->ctrl_reg;
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	if (rc) {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 		dev_err(rtc_dd->rtc_dev,
 			"Write to RTC control register failed\n");
@@ -363,18 +325,20 @@ static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	/* Clear RTC alarm register */
-	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-				 PM8XXX_ALARM_CTRL_OFFSET, 1);
-	if (rc < 0) {
+	rc = regmap_read(rtc_dd->regmap,
+			 rtc_dd->rtc_base + PM8XXX_ALARM_CTRL_OFFSET,
+			 &ctrl_reg);
+	if (rc) {
 		dev_err(rtc_dd->rtc_dev,
 			"RTC Alarm control register read failed\n");
 		goto rtc_alarm_handled;
 	}
 
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_CLEAR;
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-				  PM8XXX_ALARM_CTRL_OFFSET, 1);
-	if (rc < 0)
+	rc = regmap_write(rtc_dd->regmap,
+			  rtc_dd->rtc_base + PM8XXX_ALARM_CTRL_OFFSET,
+			  ctrl_reg);
+	if (rc)
 		dev_err(rtc_dd->rtc_dev,
 			"Write to RTC Alarm control register failed\n");
 
@@ -385,7 +349,7 @@ rtc_alarm_handled:
 static int pm8xxx_rtc_probe(struct platform_device *pdev)
 {
 	int rc;
-	u8 ctrl_reg;
+	unsigned int ctrl_reg;
 	bool rtc_write_enable = false;
 	struct pm8xxx_rtc *rtc_dd;
 	struct resource *rtc_resource;
@@ -402,6 +366,12 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	/* Initialise spinlock to protect RTC control register */
 	spin_lock_init(&rtc_dd->ctrl_reg_lock);
 
+	rtc_dd->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!rtc_dd->regmap) {
+		dev_err(&pdev->dev, "Parent regmap unavailable.\n");
+		return -ENXIO;
+	}
+
 	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
 	if (rtc_dd->rtc_alarm_irq < 0) {
 		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
@@ -425,17 +395,16 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	rtc_dd->rtc_dev = &pdev->dev;
 
 	/* Check if the RTC is on, else turn it on */
-	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_read(rtc_dd->regmap, rtc_dd->rtc_base, &ctrl_reg);
+	if (rc) {
 		dev_err(&pdev->dev, "RTC control register read failed!\n");
 		return rc;
 	}
 
 	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
 		ctrl_reg |= PM8xxx_RTC_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-									1);
-		if (rc < 0) {
+		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		if (rc) {
 			dev_err(&pdev->dev,
 				"Write to RTC control register failed\n");
 			return rc;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

