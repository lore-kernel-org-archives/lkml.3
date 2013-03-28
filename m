Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3C1QNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:13:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65389 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab3C1QM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/33] regulator: ab8500: Shuffle init functions into a more logical order
Date: Thu, 28 Mar 2013 16:11:32 +0000
Message-Id: <1364487093-19551-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ab*_match[] arrays should be moved out of the way, instead of
bunched in the middle of the initialisation functions. This patch
moves all initialisation code which currently resides above these
arrays down to be grouped with the others. This makes the whole
thing slightly easier to read.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |  170 ++++++++++++++++++++++----------------------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index bb574bf..535a94f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2916,91 +2916,6 @@ static struct ab8500_reg_init ab8540_reg_init[] = {
 	REG_INIT(AB8540_REGUCTRLDISCH4,		0x04, 0x49, 0x07),
 };
 
-static struct {
-	struct ab8500_regulator_info *info;
-	int info_size;
-	struct ab8500_reg_init *init;
-	int init_size;
-	struct of_regulator_match *match;
-	int match_size;
-} abx500_regulator;
-
-static int ab8500_regulator_init_registers(struct platform_device *pdev,
-					   int id, int mask, int value)
-{
-	struct ab8500_reg_init *reg_init = abx500_regulator.init;
-	int err;
-
-	BUG_ON(value & ~mask);
-	BUG_ON(mask & ~reg_init[id].mask);
-
-	/* initialize register */
-	err = abx500_mask_and_set_register_interruptible(
-		&pdev->dev,
-		reg_init[id].bank,
-		reg_init[id].addr,
-		mask, value);
-	if (err < 0) {
-		dev_err(&pdev->dev,
-			"Failed to initialize 0x%02x, 0x%02x.\n",
-			reg_init[id].bank,
-			reg_init[id].addr);
-		return err;
-	}
-	dev_vdbg(&pdev->dev,
-		 "  init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
-		 reg_init[id].bank,
-		 reg_init[id].addr,
-		 mask, value);
-
-	return 0;
-}
-
-static int ab8500_regulator_register(struct platform_device *pdev,
-				     struct regulator_init_data *init_data,
-				     int id, struct device_node *np)
-{
-	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
-	struct ab8500_regulator_info *info = NULL;
-	struct regulator_config config = { };
-	int err;
-
-	/* assign per-regulator data */
-	info = &abx500_regulator.info[id];
-	info->dev = &pdev->dev;
-
-	config.dev = &pdev->dev;
-	config.init_data = init_data;
-	config.driver_data = info;
-	config.of_node = np;
-
-	/* fix for hardware before ab8500v2.0 */
-	if (is_ab8500_1p1_or_earlier(ab8500)) {
-		if (info->desc.id == AB8500_LDO_AUX3) {
-			info->desc.n_voltages =
-				ARRAY_SIZE(ldo_vauxn_voltages);
-			info->desc.volt_table = ldo_vauxn_voltages;
-			info->voltage_mask = 0xf;
-		}
-	}
-
-	/* register regulator with framework */
-	info->regulator = regulator_register(&info->desc, &config);
-	if (IS_ERR(info->regulator)) {
-		err = PTR_ERR(info->regulator);
-		dev_err(&pdev->dev, "failed to register regulator %s\n",
-			info->desc.name);
-		/* when we fail, un-register all earlier regulators */
-		while (--id >= 0) {
-			info = &abx500_regulator.info[id];
-			regulator_unregister(info->regulator);
-		}
-		return err;
-	}
-
-	return 0;
-}
-
 static struct of_regulator_match ab8500_regulator_match[] = {
 	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8500_LDO_AUX1, },
 	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8500_LDO_AUX2, },
@@ -3061,6 +2976,15 @@ static struct of_regulator_match ab9540_regulator_match[] = {
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB9540_LDO_ANA, },
 };
 
+static struct {
+	struct ab8500_regulator_info *info;
+	int info_size;
+	struct ab8500_reg_init *init;
+	int init_size;
+	struct of_regulator_match *match;
+	int match_size;
+} abx500_regulator;
+
 static void abx500_get_regulator_info(struct ab8500 *ab8500)
 {
 	if (is_ab9540(ab8500)) {
@@ -3094,6 +3018,82 @@ static void abx500_get_regulator_info(struct ab8500 *ab8500)
 	}
 }
 
+static int ab8500_regulator_init_registers(struct platform_device *pdev,
+					   int id, int mask, int value)
+{
+	struct ab8500_reg_init *reg_init = abx500_regulator.init;
+	int err;
+
+	BUG_ON(value & ~mask);
+	BUG_ON(mask & ~reg_init[id].mask);
+
+	/* initialize register */
+	err = abx500_mask_and_set_register_interruptible(
+		&pdev->dev,
+		reg_init[id].bank,
+		reg_init[id].addr,
+		mask, value);
+	if (err < 0) {
+		dev_err(&pdev->dev,
+			"Failed to initialize 0x%02x, 0x%02x.\n",
+			reg_init[id].bank,
+			reg_init[id].addr);
+		return err;
+	}
+	dev_vdbg(&pdev->dev,
+		 "  init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		 reg_init[id].bank,
+		 reg_init[id].addr,
+		 mask, value);
+
+	return 0;
+}
+
+static int ab8500_regulator_register(struct platform_device *pdev,
+				     struct regulator_init_data *init_data,
+				     int id, struct device_node *np)
+{
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_regulator_info *info = NULL;
+	struct regulator_config config = { };
+	int err;
+
+	/* assign per-regulator data */
+	info = &abx500_regulator.info[id];
+	info->dev = &pdev->dev;
+
+	config.dev = &pdev->dev;
+	config.init_data = init_data;
+	config.driver_data = info;
+	config.of_node = np;
+
+	/* fix for hardware before ab8500v2.0 */
+	if (is_ab8500_1p1_or_earlier(ab8500)) {
+		if (info->desc.id == AB8500_LDO_AUX3) {
+			info->desc.n_voltages =
+				ARRAY_SIZE(ldo_vauxn_voltages);
+			info->desc.volt_table = ldo_vauxn_voltages;
+			info->voltage_mask = 0xf;
+		}
+	}
+
+	/* register regulator with framework */
+	info->regulator = regulator_register(&info->desc, &config);
+	if (IS_ERR(info->regulator)) {
+		err = PTR_ERR(info->regulator);
+		dev_err(&pdev->dev, "failed to register regulator %s\n",
+			info->desc.name);
+		/* when we fail, un-register all earlier regulators */
+		while (--id >= 0) {
+			info = &abx500_regulator.info[id];
+			regulator_unregister(info->regulator);
+		}
+		return err;
+	}
+
+	return 0;
+}
+
 static int
 ab8500_regulator_of_probe(struct platform_device *pdev,
 			  struct device_node *np)
-- 
1.7.10.4

