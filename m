Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3LCOIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:08:39 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:45255 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LCOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:08:35 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <mark.brown@linaro.org>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] regulator: ab8500: delete non-devicetree probe path
Date: Tue,  3 Dec 2013 15:08:22 +0100
Message-Id: <1386079702-22821-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ux500 platform has been converted to do device-tree only
boots, no longer supports platform data passing, so this
probe path is unused. Delete it, simplifying the driver a
whole lot.

Cc: Mark Brown <mark.brown@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
I tried to also delete this boot path for the external regulators
in ab8500-ext.c, but it seems to not have been cleanly converted
to device tree yet, making it dependent on passing some platform
data still. Thus I cannot go down the path and delete all platform
data down to the point where (most of)
arch/arm/mach-ux500/board-mop500-regulator.[c|h] gets deleted,
but I can do this much.
---
 drivers/regulator/ab8500.c | 102 ++++-----------------------------------------
 1 file changed, 8 insertions(+), 94 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 603f192e84f1..0f86695b737a 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2998,37 +2998,6 @@ static void abx500_get_regulator_info(struct ab8500 *ab8500)
 	}
 }
 
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
 static int ab8500_regulator_register(struct platform_device *pdev,
 				     struct regulator_init_data *init_data,
 				     int id, struct device_node *np)
@@ -3095,9 +3064,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *np = pdev->dev.of_node;
-	struct ab8500_platform_data *ppdata;
-	struct ab8500_regulator_platform_data *pdata;
-	int i, err;
+	int err;
 
 	if (!ab8500) {
 		dev_err(&pdev->dev, "null mfd parent\n");
@@ -3106,68 +3073,15 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
 	abx500_get_regulator_info(ab8500);
 
-	if (np) {
-		err = of_regulator_match(&pdev->dev, np,
-					 abx500_regulator.match,
-					 abx500_regulator.match_size);
-		if (err < 0) {
-			dev_err(&pdev->dev,
-				"Error parsing regulator init data: %d\n", err);
-			return err;
-		}
-
-		err = ab8500_regulator_of_probe(pdev, np);
-		return err;
-	}
-
-	ppdata = dev_get_platdata(ab8500->dev);
-	if (!ppdata) {
-		dev_err(&pdev->dev, "null parent pdata\n");
-		return -EINVAL;
-	}
-
-	pdata = ppdata->regulator;
-	if (!pdata) {
-		dev_err(&pdev->dev, "null pdata\n");
-		return -EINVAL;
-	}
-
-	/* make sure the platform data has the correct size */
-	if (pdata->num_regulator != abx500_regulator.info_size) {
-		dev_err(&pdev->dev, "Configuration error: size mismatch.\n");
-		return -EINVAL;
-	}
-
-	/* initialize debug (initial state is recorded with this call) */
-	err = ab8500_regulator_debug_init(pdev);
-	if (err)
+	err = of_regulator_match(&pdev->dev, np,
+				 abx500_regulator.match,
+				 abx500_regulator.match_size);
+	if (err < 0) {
+		dev_err(&pdev->dev,
+			"Error parsing regulator init data: %d\n", err);
 		return err;
-
-	/* initialize registers */
-	for (i = 0; i < pdata->num_reg_init; i++) {
-		int id, mask, value;
-
-		id = pdata->reg_init[i].id;
-		mask = pdata->reg_init[i].mask;
-		value = pdata->reg_init[i].value;
-
-		/* check for configuration errors */
-		BUG_ON(id >= abx500_regulator.init_size);
-
-		err = ab8500_regulator_init_registers(pdev, id, mask, value);
-		if (err < 0)
-			return err;
-	}
-
-	/* register all regulators */
-	for (i = 0; i < abx500_regulator.info_size; i++) {
-		err = ab8500_regulator_register(pdev, &pdata->regulator[i],
-						i, NULL);
-		if (err < 0)
-			return err;
 	}
-
-	return 0;
+	return ab8500_regulator_of_probe(pdev, np);
 }
 
 static int ab8500_regulator_remove(struct platform_device *pdev)
-- 
1.8.3.1

