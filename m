Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3C1QMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:24 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:39452 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab3C1QMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/33] regulator: ab8500: Prepare the driver for additional platforms
Date: Thu, 28 Mar 2013 16:11:10 +0000
Message-Id: <1364487093-19551-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More platforms are to be supported by the AB8500 regulator driver,
so in this patch we prepare for their arrival. Instead of using
the AB8500 settings blindly, we provide an infrastructure where
adding a new platform is as easy as providing a couple of platform
specific data structures.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   76 ++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index bf34c4c..f323fba 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -763,46 +763,47 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 };
 
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
+					   struct ab8500_reg_init *reg_init,
 					   int id, int mask, int value)
 {
 	int err;
 
 	BUG_ON(value & ~mask);
-	BUG_ON(mask & ~ab8500_reg_init[id].mask);
+	BUG_ON(mask & ~reg_init[id].mask);
 
 	/* initialize register */
 	err = abx500_mask_and_set_register_interruptible(
 		&pdev->dev,
-		ab8500_reg_init[id].bank,
-		ab8500_reg_init[id].addr,
+		reg_init[id].bank,
+		reg_init[id].addr,
 		mask, value);
 	if (err < 0) {
 		dev_err(&pdev->dev,
 			"Failed to initialize 0x%02x, 0x%02x.\n",
-			ab8500_reg_init[id].bank,
-			ab8500_reg_init[id].addr);
+			reg_init[id].bank,
+			reg_init[id].addr);
 		return err;
 	}
 	dev_vdbg(&pdev->dev,
 		 "  init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
-		 ab8500_reg_init[id].bank,
-		 ab8500_reg_init[id].addr,
+		 reg_init[id].bank,
+		 reg_init[id].addr,
 		 mask, value);
 
 	return 0;
 }
 
 static int ab8500_regulator_register(struct platform_device *pdev,
-					struct regulator_init_data *init_data,
-					int id,
-					struct device_node *np)
+				     struct regulator_init_data *init_data,
+				     struct ab8500_regulator_info *regulator_info,
+				     int id, struct device_node *np)
 {
 	struct ab8500_regulator_info *info = NULL;
 	struct regulator_config config = { };
 	int err;
 
 	/* assign per-regulator data */
-	info = &ab8500_regulator_info[id];
+	info = &regulator_info[id];
 	info->dev = &pdev->dev;
 
 	config.dev = &pdev->dev;
@@ -828,7 +829,7 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 			info->desc.name);
 		/* when we fail, un-register all earlier regulators */
 		while (--id >= 0) {
-			info = &ab8500_regulator_info[id];
+			info = &regulator_info[id];
 			regulator_unregister(info->regulator);
 		}
 		return err;
@@ -837,7 +838,7 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	return 0;
 }
 
-static struct of_regulator_match ab8500_regulator_matches[] = {
+static struct of_regulator_match ab8500_regulator_match[] = {
 	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8500_LDO_AUX1, },
 	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8500_LDO_AUX2, },
 	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8500_LDO_AUX3, },
@@ -851,14 +852,18 @@ static struct of_regulator_match ab8500_regulator_matches[] = {
 };
 
 static int
-ab8500_regulator_of_probe(struct platform_device *pdev, struct device_node *np)
+ab8500_regulator_of_probe(struct platform_device *pdev,
+			  struct ab8500_regulator_info *regulator_info,
+			  int regulator_info_size,
+			  struct of_regulator_match *match,
+			  struct device_node *np)
 {
 	int err, i;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
+	for (i = 0; i < regulator_info_size; i++) {
 		err = ab8500_regulator_register(
-			pdev, ab8500_regulator_matches[i].init_data,
-			i, ab8500_regulator_matches[i].of_node);
+			pdev, match[i].init_data, regulator_info,
+			i, match[i].of_node);
 		if (err)
 			return err;
 	}
@@ -870,21 +875,32 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *np = pdev->dev.of_node;
+	struct of_regulator_match *match;
 	struct ab8500_platform_data *ppdata;
 	struct ab8500_regulator_platform_data *pdata;
 	int i, err;
+	struct ab8500_regulator_info *regulator_info;
+	int regulator_info_size;
+	struct ab8500_reg_init *reg_init;
+	int reg_init_size;
+
+	regulator_info = ab8500_regulator_info;
+	regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
+	reg_init = ab8500_reg_init;
+	reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
+	match = ab8500_regulator_match;
+	match_size = ARRAY_SIZE(ab8500_regulator_match)
 
 	if (np) {
-		err = of_regulator_match(&pdev->dev, np,
-					ab8500_regulator_matches,
-					ARRAY_SIZE(ab8500_regulator_matches));
+		err = of_regulator_match(&pdev->dev, np, match, match_size);
 		if (err < 0) {
 			dev_err(&pdev->dev,
 				"Error parsing regulator init data: %d\n", err);
 			return err;
 		}
 
-		err = ab8500_regulator_of_probe(pdev, np);
+		err = ab8500_regulator_of_probe(pdev, regulator_info,
+						regulator_info_size, match, np);
 		return err;
 	}
 
@@ -906,7 +922,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	}
 
 	/* make sure the platform data has the correct size */
-	if (pdata->num_regulator != ARRAY_SIZE(ab8500_regulator_info)) {
+	if (pdata->num_regulator != regulator_info_size) {
 		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
 		return -EINVAL;
 	}
@@ -927,7 +943,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		/* check for configuration errors */
 		BUG_ON(id >= AB8500_NUM_REGULATOR_REGISTERS);
 
-		err = ab8500_regulator_init_registers(pdev, id, mask, value);
+		err = ab8500_regulator_init_registers(pdev, reg_init, id, mask, value);
 		if (err < 0)
 			return err;
 	}
@@ -938,8 +954,9 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		return err;
 
 	/* register all regulators */
-	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
-		err = ab8500_regulator_register(pdev, &pdata->regulator[i], i, NULL);
+	for (i = 0; i < regulator_info_size; i++) {
+		err = ab8500_regulator_register(pdev, &pdata->regulator[i],
+						regulator_info, i, NULL);
 		if (err < 0)
 			return err;
 	}
@@ -950,10 +967,15 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
 	int i, err;
+	struct ab8500_regulator_info *regulator_info;
+	int regulator_info_size;
 
-	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
+	regulator_info = ab8500_regulator_info;
+	regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
+
+	for (i = 0; i < regulator_info_size; i++) {
 		struct ab8500_regulator_info *info = NULL;
-		info = &ab8500_regulator_info[i];
+		info = &regulator_info[i];
 
 		dev_vdbg(rdev_get_dev(info->regulator),
 			"%s-remove\n", info->desc.name);
-- 
1.7.10.4

