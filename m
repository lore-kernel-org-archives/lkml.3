Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3BDL6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:58:07 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60184 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3BDL6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:58:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Subject: [PATCH 67/73] regulator: ab8500: Use a struct to select the good regulator configuration
Date: Mon,  4 Feb 2013 11:54:22 +0000
Message-Id: <1359978868-28736-68-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the probe use a structure to select the good regulator array from
from ab9540, ab8505, ab8540 or ab8500 configuration.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c |  113 +++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 65 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index fa0979a..b6e8f4d 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2845,10 +2845,17 @@ static struct ab8500_reg_init ab8540_reg_init[] = {
 	REG_INIT(AB8540_REGUCTRLDISCH4,		0x04, 0x49, 0x07),
 };
 
+static struct {
+	struct ab8500_regulator_info *info;
+	int info_size;
+	struct ab8500_reg_init *init;
+	int init_size;
+} abx500_regulator;
+
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
-					   struct ab8500_reg_init *reg_init,
 					   int id, int mask, int value)
 {
+	struct ab8500_reg_init *reg_init = abx500_regulator.init;
 	int err;
 
 	BUG_ON(value & ~mask);
@@ -2878,7 +2885,6 @@ static int ab8500_regulator_init_registers(struct platform_device *pdev,
 
 static int ab8500_regulator_register(struct platform_device *pdev,
 				     struct regulator_init_data *init_data,
-				     struct ab8500_regulator_info *regulator_info,
 				     int id, struct device_node *np)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
@@ -2887,7 +2893,7 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	int err;
 
 	/* assign per-regulator data */
-	info = &regulator_info[id];
+	info = &abx500_regulator.info[id];
 	info->dev = &pdev->dev;
 
 	config.dev = &pdev->dev;
@@ -2913,7 +2919,7 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 			info->desc.name);
 		/* when we fail, un-register all earlier regulators */
 		while (--id >= 0) {
-			info = &regulator_info[id];
+			info = &abx500_regulator.info[id];
 			regulator_unregister(info->regulator);
 		}
 		return err;
@@ -2949,19 +2955,41 @@ static struct of_regulator_match ab9540_regulator_match[] = {
 	{ .name	= "ab9540_ldo_ana",     .driver_data = (void *) AB9540_LDO_ANA, },
 };
 
+static void abx500_get_regulator_info(struct ab8500 *ab8500)
+{
+	if (is_ab9540(ab8500)) {
+		abx500_regulator.info = ab9540_regulator_info;
+		abx500_regulator.info_size = ARRAY_SIZE(ab9540_regulator_info);
+		abx500_regulator.init = ab9540_reg_init;
+		abx500_regulator.init_size = AB9540_NUM_REGULATOR_REGISTERS;
+	} else if (is_ab8505(ab8500)) {
+		abx500_regulator.info = ab8505_regulator_info;
+		abx500_regulator.info_size = ARRAY_SIZE(ab8505_regulator_info);
+		abx500_regulator.init = ab8505_reg_init;
+		abx500_regulator.init_size = AB8505_NUM_REGULATOR_REGISTERS;
+	} else if (is_ab8540(ab8500)) {
+		abx500_regulator.info = ab8540_regulator_info;
+		abx500_regulator.info_size = ARRAY_SIZE(ab8540_regulator_info);
+		abx500_regulator.init = ab8540_reg_init;
+		abx500_regulator.init_size = AB8540_NUM_REGULATOR_REGISTERS;
+	} else {
+		abx500_regulator.info = ab8500_regulator_info;
+		abx500_regulator.info_size = ARRAY_SIZE(ab8500_regulator_info);
+		abx500_regulator.init = ab8500_reg_init;
+		abx500_regulator.init_size = AB8500_NUM_REGULATOR_REGISTERS;
+	}
+}
+
 static int
 ab8500_regulator_of_probe(struct platform_device *pdev,
-			  struct ab8500_regulator_info *regulator_info,
-			  int regulator_info_size,
-			  struct of_regulator_match *match,
 			  struct device_node *np)
 {
+	struct of_regulator_match *match = abx500_regulator.match;
 	int err, i;
 
-	for (i = 0; i < regulator_info_size; i++) {
+	for (i = 0; i < abx500_regulator.info_size; i++) {
 		err = ab8500_regulator_register(
-			pdev, match[i].init_data, regulator_info,
-			i, match[i].of_node);
+			pdev, match[i].init_data, i, match[i].of_node);
 		if (err)
 			return err;
 	}
@@ -2973,41 +3001,14 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *np = pdev->dev.of_node;
-	struct of_regulator_match *match;
 	struct ab8500_platform_data *ppdata;
 	struct ab8500_regulator_platform_data *pdata;
 	int i, err;
-	struct ab8500_regulator_info *regulator_info;
-	int regulator_info_size;
 	struct ab8500_reg_init *reg_init;
-	int reg_init_size;
+
 	/* cache values needed repeatedly inside for-loops */
 
-	if (is_ab9540(ab8500)) {
-		regulator_info = ab9540_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
-		reg_init = ab9540_reg_init;
-		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
-		match = ab9540_regulator_matches;
-		match_size = ARRAY_SIZE(ab9540_regulator_matches)
-	} else if (is_ab8505(ab8500)) {
-		regulator_info = ab8505_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
-		reg_init = ab8505_reg_init;
-		reg_init_size = AB8505_NUM_REGULATOR_REGISTERS;
-	} else if (is_ab8540(ab8500)) {
-		regulator_info = ab8540_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
-		reg_init = ab8540_reg_init;
-		reg_init_size = AB8540_NUM_REGULATOR_REGISTERS;
-	} else {
-		regulator_info = ab8500_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
-		reg_init = ab8500_reg_init;
-		reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
-		match = ab8500_regulator_matches;
-		match_size = ARRAY_SIZE(ab8500_regulator_matches)
-	}
+	abx500_get_regulator_info(ab8500);
 
 	if (np) {
 		err = of_regulator_match(&pdev->dev, np, match, match_size);
@@ -3017,8 +3018,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			return err;
 		}
 
-		err = ab8500_regulator_of_probe(pdev, regulator_info,
-						regulator_info_size, match, np);
+		err = ab8500_regulator_of_probe(pdev, match, np);
 		return err;
 	}
 
@@ -3040,7 +3040,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	}
 
 	/* make sure the platform data has the correct size */
-	if (pdata->num_regulator != regulator_info_size) {
+	if (pdata->num_regulator != abx500_regulator.info_size) {
 		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
 		return -EINVAL;
 	}
@@ -3059,9 +3059,9 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		value = pdata->reg_init[i].value;
 
 		/* check for configuration errors */
-		BUG_ON(id >= AB8500_NUM_REGULATOR_REGISTERS);
+		BUG_ON(id >= abx500_regulator.init_size);
 
-		err = ab8500_regulator_init_registers(pdev, reg_init, id, mask, value);
+		err = ab8500_regulator_init_registers(pdev, id, mask, value);
 		if (err < 0)
 			return err;
 	}
@@ -3074,9 +3074,9 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	}
 
 	/* register all regulators */
-	for (i = 0; i < regulator_info_size; i++) {
+	for (i = 0; i < abx500_regulator.info_size; i++) {
 		err = ab8500_regulator_register(pdev, &pdata->regulator[i],
-						regulator_info, i, NULL);
+						i, NULL);
 		if (err < 0)
 			return err;
 	}
@@ -3088,27 +3088,10 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 {
 	int i, err;
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
-	struct ab8500_regulator_info *regulator_info;
-	int regulator_info_size;
-
-
-	if (is_ab9540(ab8500)) {
-		regulator_info = ab9540_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
-	} else if (is_ab8505(ab8500)) {
-		regulator_info = ab8505_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
-	} else if (is_ab8540(ab8500)) {
-		regulator_info = ab8540_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
-	} else {
-		regulator_info = ab8500_regulator_info;
-		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
-	}
 
-	for (i = 0; i < regulator_info_size; i++) {
+	for (i = 0; i < abx500_regulator.info_size; i++) {
 		struct ab8500_regulator_info *info = NULL;
-		info = &regulator_info[i];
+		info = &abx500_regulator.info[i];
 
 		dev_vdbg(rdev_get_dev(info->regulator),
 			"%s-remove\n", info->desc.name);
-- 
1.7.9.5

