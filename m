Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaCDSe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:34:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54981 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaCDSez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:34:55 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>, linux-input@vger.kernel.org
Subject: [PATCH v5 5/9] Input: pmic8xxx-pwrkey - Migrate to DT
Date: Tue,  4 Mar 2014 10:34:44 -0800
Message-Id: <1393958088-1456-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
References: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is only supported on DT enabled platforms. Convert the
driver to DT so that it can probe properly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pmic8xxx-pwrkey.c  | 33 ++++++++++++++++++++-------------
 include/linux/input/pmic8xxx-pwrkey.h | 31 -------------------------------
 2 files changed, 20 insertions(+), 44 deletions(-)
 delete mode 100644 include/linux/input/pmic8xxx-pwrkey.h

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index 0e1a05f95858..99a3587ff49f 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -19,8 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/log2.h>
-
-#include <linux/input/pmic8xxx-pwrkey.h>
+#include <linux/of.h>
 
 #define PON_CNTL_1 0x1C
 #define PON_CNTL_PULL_UP BIT(7)
@@ -79,6 +78,13 @@ static int pmic8xxx_pwrkey_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(pm8xxx_pwr_key_pm_ops,
 		pmic8xxx_pwrkey_suspend, pmic8xxx_pwrkey_resume);
 
+static const struct of_device_id pm8xxx_pwr_key_id_table[] = {
+	{ .compatible = "qcom,pm8058-pwrkey" },
+	{ .compatible = "qcom,pm8921-pwrkey" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_pwr_key_id_table);
+
 static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 {
 	struct input_dev *pwr;
@@ -89,15 +95,15 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	unsigned int pon_cntl;
 	struct regmap *regmap;
 	struct pmic8xxx_pwrkey *pwrkey;
-	const struct pm8xxx_pwrkey_platform_data *pdata =
-					dev_get_platdata(&pdev->dev);
+	u32 kpd_delay;
+	bool pull_up;
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "power key platform data not supplied\n");
-		return -EINVAL;
-	}
+	if (of_property_read_u32(pdev->dev.of_node, "debounce", &kpd_delay))
+		kpd_delay = 0;
+
+	pull_up = of_property_read_bool(pdev->dev.of_node, "pull-up");
 
-	if (pdata->kpd_trigger_delay_us > 62500) {
+	if (kpd_delay > 62500) {
 		dev_err(&pdev->dev, "invalid power key trigger delay\n");
 		return -EINVAL;
 	}
@@ -125,7 +131,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	pwr->name = "pmic8xxx_pwrkey";
 	pwr->phys = "pmic8xxx_pwrkey/input0";
 
-	delay = (pdata->kpd_trigger_delay_us << 10) / USEC_PER_SEC;
+	delay = (kpd_delay << 10) / USEC_PER_SEC;
 	delay = 1 + ilog2(delay);
 
 	err = regmap_read(regmap, PON_CNTL_1, &pon_cntl);
@@ -136,7 +142,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 
 	pon_cntl &= ~PON_CNTL_TRIG_DELAY_MASK;
 	pon_cntl |= (delay & PON_CNTL_TRIG_DELAY_MASK);
-	if (pdata->pull_up)
+	if (pull_up)
 		pon_cntl |= PON_CNTL_PULL_UP;
 	else
 		pon_cntl &= ~PON_CNTL_PULL_UP;
@@ -172,7 +178,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, pwrkey);
-	device_init_wakeup(&pdev->dev, pdata->wakeup);
+	device_init_wakeup(&pdev->dev, 1);
 
 	return 0;
 }
@@ -188,9 +194,10 @@ static struct platform_driver pmic8xxx_pwrkey_driver = {
 	.probe		= pmic8xxx_pwrkey_probe,
 	.remove		= pmic8xxx_pwrkey_remove,
 	.driver		= {
-		.name	= PM8XXX_PWRKEY_DEV_NAME,
+		.name	= "pm8xxx-pwrkey",
 		.owner	= THIS_MODULE,
 		.pm	= &pm8xxx_pwr_key_pm_ops,
+		.of_match_table = pm8xxx_pwr_key_id_table,
 	},
 };
 module_platform_driver(pmic8xxx_pwrkey_driver);
diff --git a/include/linux/input/pmic8xxx-pwrkey.h b/include/linux/input/pmic8xxx-pwrkey.h
deleted file mode 100644
index 6d2974e57109..000000000000
--- a/include/linux/input/pmic8xxx-pwrkey.h
+++ /dev/null
@@ -1,31 +0,0 @@
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
-#ifndef __PMIC8XXX_PWRKEY_H__
-#define __PMIC8XXX_PWRKEY_H__
-
-#define PM8XXX_PWRKEY_DEV_NAME "pm8xxx-pwrkey"
-
-/**
- * struct pm8xxx_pwrkey_platform_data - platform data for pwrkey driver
- * @pull up:  power on register control for pull up/down configuration
- * @kpd_trigger_delay_us: time delay for power key state change interrupt
- *                  trigger.
- * @wakeup: configure power key as wakeup source
- */
-struct pm8xxx_pwrkey_platform_data  {
-	bool pull_up;
-	u32  kpd_trigger_delay_us;
-	u32  wakeup;
-};
-
-#endif /* __PMIC8XXX_PWRKEY_H__ */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

