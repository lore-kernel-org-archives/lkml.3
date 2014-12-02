Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaLBIGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:06:41 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33491 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbaLBIGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:06:37 -0500
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
To: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        treding@nvidia.com, florian.vaussard@epfl.ch, trivial@kernel.org,
        linux@roeck-us.net, andrew@lunn.ch, jic23@kernel.org
Subject: [PATCH v9 7/8] regulator: sky81452: Modify Device Tree structure
Date: Tue,  2 Dec 2014 17:05:28 +0900
Message-Id: <1417507529-13654-8-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v9:
Removed the change to remove MODULE_VERSION()

Changes v8:
Changed the DT parsing of regulator using regulator_node and of_match

Changes v7:
Modified licensing text to GPLv2
Splitted Kconfig renaming from DT patch

Changes v6:
Added new line character at the end of line of dev_err()

Changes v5:
Changed DT for regulator : 'lout' node should be defined under 'regulator'
Removed compatible string
Modified to return EINVAL when of_node is NULL

Changes v4:
Removed MODULE_VERSION()
Modified license to GPLv2

Changes v3:
Modified to return ENODATA when of_node is NULL
Modified the messages in error cases

Changes v2:
Added 'compatible' attribute in the driver
Added message for exception or errors.

 drivers/regulator/sky81452-regulator.c | 45 +++++++---------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
index 476b80a..6478606 100644
--- a/drivers/regulator/sky81452-regulator.c
+++ b/drivers/regulator/sky81452-regulator.c
@@ -5,9 +5,8 @@
  * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
  *
  * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
+ * under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
  * WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -52,6 +51,8 @@ static const struct regulator_linear_range sky81452_reg_ranges[] = {
 
 static const struct regulator_desc sky81452_reg = {
 	.name = "LOUT",
+	.of_match = of_match_ptr("lout"),
+	.regulators_node = of_match_ptr("regulator"),
 	.ops = &sky81452_reg_ops,
 	.type = REGULATOR_VOLTAGE,
 	.owner = THIS_MODULE,
@@ -64,30 +65,6 @@ static const struct regulator_desc sky81452_reg = {
 	.enable_mask = SKY81452_LEN,
 };
 
-#ifdef CONFIG_OF
-static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
-{
-	struct regulator_init_data *init_data;
-	struct device_node *np;
-
-	np = of_get_child_by_name(dev->parent->of_node, "regulator");
-	if (unlikely(!np)) {
-		dev_err(dev, "regulator node not found");
-		return NULL;
-	}
-
-	init_data = of_get_regulator_init_data(dev, np);
-
-	of_node_put(np);
-	return init_data;
-}
-#else
-static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
-{
-	return ERR_PTR(-EINVAL);
-}
-#endif
-
 static int sky81452_reg_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -95,20 +72,16 @@ static int sky81452_reg_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 
-	if (!init_data) {
-		init_data = sky81452_reg_parse_dt(dev);
-		if (IS_ERR(init_data))
-			return PTR_ERR(init_data);
-	}
-
-	config.dev = dev;
+	config.dev = dev->parent;
 	config.init_data = init_data;
 	config.of_node = dev->of_node;
 	config.regmap = dev_get_drvdata(dev->parent);
 
 	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
-	if (IS_ERR(rdev))
+	if (IS_ERR(rdev)) {
+		dev_err(dev, "failed to register. err=%ld\n", PTR_ERR(rdev));
 		return PTR_ERR(rdev);
+	}
 
 	platform_set_drvdata(pdev, rdev);
 
@@ -126,4 +99,4 @@ module_platform_driver(sky81452_reg_driver);
 
 MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
 MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

