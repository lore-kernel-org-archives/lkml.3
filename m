Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbaCETdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:33:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59858 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaCETc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:32:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        devicetree@vger.kernel.org
Subject: [PATCH 4/6] rtc: pm8xxx: add support for devicetree
Date: Wed,  5 Mar 2014 13:29:34 -0600
Message-Id: <1394047776-13827-5-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for describing the PM8921/PM8058 RTC in device tree.

Additionally:
   - drop support for describing the RTC using platform data,
     as there are no current in tree users who do so.
   - make allow_set_time a device-specific flag, instead of mucking
     with the rtc_ops

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/rtc/rtc-pm8xxx.c       | 54 +++++++++++++++++++++++-------------------
 include/linux/mfd/pm8xxx/rtc.h | 25 -------------------
 2 files changed, 30 insertions(+), 49 deletions(-)
 delete mode 100644 include/linux/mfd/pm8xxx/rtc.h

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index ed3fe83..cb5576f 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -9,7 +9,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-
+#include <linux/of.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/rtc.h>
@@ -19,9 +19,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <linux/mfd/pm8xxx/rtc.h>
-
-
 /* RTC Register offsets from RTC CTRL REG */
 #define PM8XXX_ALARM_CTRL_OFFSET	0x01
 #define PM8XXX_RTC_WRITE_OFFSET		0x02
@@ -39,6 +36,7 @@
  * struct pm8xxx_rtc -  rtc driver internal structure
  * @rtc:		rtc device for this driver.
  * @regmap:		regmap used to access RTC registers
+ * @allow_set_time:	indicates whether writing to the RTC is allowed
  * @rtc_alarm_irq:	rtc alarm irq number.
  * @rtc_base:		address of rtc control register.
  * @rtc_read_base:	base address of read registers.
@@ -51,6 +49,7 @@
 struct pm8xxx_rtc {
 	struct rtc_device *rtc;
 	struct regmap *regmap;
+	bool allow_set_time;
 	int rtc_alarm_irq;
 	int rtc_base;
 	int rtc_read_base;
@@ -75,6 +74,9 @@ static int pm8xxx_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0, ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
+	if (!rtc_dd->allow_set_time)
+		return -EACCES;
+
 	rtc_tm_to_time(tm, &secs);
 
 	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
@@ -291,8 +293,9 @@ rtc_rw_fail:
 	return rc;
 }
 
-static struct rtc_class_ops pm8xxx_rtc_ops = {
+static const struct rtc_class_ops pm8xxx_rtc_ops = {
 	.read_time	= pm8xxx_rtc_read_time,
+	.set_time	= pm8xxx_rtc_set_time,
 	.set_alarm	= pm8xxx_rtc_set_alarm,
 	.read_alarm	= pm8xxx_rtc_read_alarm,
 	.alarm_irq_enable = pm8xxx_rtc_alarm_irq_enable,
@@ -346,18 +349,26 @@ rtc_alarm_handled:
 	return IRQ_HANDLED;
 }
 
+/*
+ * Hardcoded RTC bases until IORESOURCE_REG mapping is figured out
+ */
+static const struct of_device_id pm8xxx_id_table[] = {
+	{ .compatible = "qcom,pm8921-rtc", .data = (void *) 0x11D },
+	{ .compatible = "qcom,pm8058-rtc", .data = (void *) 0x1E8 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
+
 static int pm8xxx_rtc_probe(struct platform_device *pdev)
 {
 	int rc;
 	unsigned int ctrl_reg;
-	bool rtc_write_enable = false;
 	struct pm8xxx_rtc *rtc_dd;
-	struct resource *rtc_resource;
-	const struct pm8xxx_rtc_platform_data *pdata =
-						dev_get_platdata(&pdev->dev);
+	const struct of_device_id *match;
 
-	if (pdata != NULL)
-		rtc_write_enable = pdata->rtc_write_enable;
+	match = of_match_node(pm8xxx_id_table, pdev->dev.of_node);
+	if (!match)
+		return -ENXIO;
 
 	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
 	if (rtc_dd == NULL)
@@ -372,20 +383,16 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
+	rtc_dd->rtc_alarm_irq = platform_get_irq_byname(pdev, "alarm");
 	if (rtc_dd->rtc_alarm_irq < 0) {
 		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
 		return -ENXIO;
 	}
 
-	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
-						    "pmic_rtc_base");
-	if (!(rtc_resource && rtc_resource->start)) {
-		dev_err(&pdev->dev, "RTC IO resource absent!\n");
-		return -ENXIO;
-	}
+	rtc_dd->allow_set_time = of_property_read_bool(pdev->dev.of_node,
+						      "linux,allow-set-time");
 
-	rtc_dd->rtc_base = rtc_resource->start;
+	rtc_dd->rtc_base = (long) match->data;
 
 	/* Setup RTC register addresses */
 	rtc_dd->rtc_write_base = rtc_dd->rtc_base + PM8XXX_RTC_WRITE_OFFSET;
@@ -412,8 +419,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	}
 
 	rtc_dd->ctrl_reg = ctrl_reg;
-	if (rtc_write_enable)
-		pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
 
 	platform_set_drvdata(pdev, rtc_dd);
 
@@ -472,9 +477,10 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops,
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
 	.driver	= {
-		.name	= PM8XXX_RTC_DEV_NAME,
-		.owner	= THIS_MODULE,
-		.pm	= &pm8xxx_rtc_pm_ops,
+		.name		= "rtc-pm8xxx",
+		.owner		= THIS_MODULE,
+		.pm		= &pm8xxx_rtc_pm_ops,
+		.of_match_table	= pm8xxx_id_table,
 	},
 };
 
diff --git a/include/linux/mfd/pm8xxx/rtc.h b/include/linux/mfd/pm8xxx/rtc.h
deleted file mode 100644
index 14f1983..0000000
--- a/include/linux/mfd/pm8xxx/rtc.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __RTC_PM8XXX_H__
-#define __RTC_PM8XXX_H__
-
-#define PM8XXX_RTC_DEV_NAME     "rtc-pm8xxx"
-/**
- * struct pm8xxx_rtc_pdata - RTC driver platform data
- * @rtc_write_enable: variable stating RTC write capability
- */
-struct pm8xxx_rtc_platform_data {
-	bool rtc_write_enable;
-};
-
-#endif /* __RTC_PM8XXX_H__ */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

