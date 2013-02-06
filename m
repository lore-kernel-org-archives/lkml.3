Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab3BFLGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:06 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:60698 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3BFKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/49] regulator: ab8500: Separate regulator and MFD platform data
Date: Wed,  6 Feb 2013 10:53:29 +0000
Message-Id: <1360148051-7560-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The ab8500 MFD should not have knowledge about regulator-
specific platform data like number of regulators and
regulator registers. As the regulator platform data is
about to grow with external regulators, this information
is moved to a new structure provided by the regulator
driver.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Yvan FILLION <yvan.fillion@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   12 +++++++++---
 arch/arm/mach-ux500/board-mop500-regulators.h |    4 +---
 drivers/regulator/ab8500.c                    |   21 +++++++++++++++------
 include/linux/regulator/ab8500.h              |    7 +++++++
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index a8141e3..0fd84d4 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -122,8 +122,7 @@ static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 };
 
 /* ab8500 regulator register initialization */
-struct ab8500_regulator_reg_init
-ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
+static struct ab8500_regulator_reg_init ab8500_reg_init[] = {
 	/*
 	 * VanaRequestCtrl          = HP/LP depending on VxRequest
 	 * VpllRequestCtrl          = HP/LP depending on VxRequest
@@ -314,7 +313,7 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 };
 
 /* AB8500 regulators */
-struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
+static struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 	/* supplies to the display/camera */
 	[AB8500_LDO_AUX1] = {
 		.constraints = {
@@ -423,3 +422,10 @@ struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
 		.consumer_supplies = ab8500_vana_consumers,
 	},
 };
+
+struct ab8500_regulator_platform_data ab8500_regulator_plat_data = {
+	.reg_init               = ab8500_reg_init,
+	.num_reg_init           = ARRAY_SIZE(ab8500_reg_init),
+	.regulator              = ab8500_regulators,
+	.num_regulator          = ARRAY_SIZE(ab8500_regulators),
+};
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 78a0642..9ca4869 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -14,9 +14,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
 
-extern struct ab8500_regulator_reg_init
-ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS];
-extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
+extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index abc9e43..a7ec26f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -940,8 +940,9 @@ ab8500_regulator_of_probe(struct platform_device *pdev, struct device_node *np)
 static int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
-	struct ab8500_platform_data *pdata;
 	struct device_node *np = pdev->dev.of_node;
+	struct ab8500_platform_data *ppdata;
+	struct ab8500_regulator_platform_data *pdata;
 	int i, err;
 
 	if (np) {
@@ -962,7 +963,14 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "null mfd parent\n");
 		return -EINVAL;
 	}
-	pdata = dev_get_platdata(ab8500->dev);
+
+	ppdata = dev_get_platdata(ab8500->dev);
+	if (!ppdata) {
+		dev_err(&pdev->dev, "null parent pdata\n");
+		return -EINVAL;
+	}
+
+	pdata = ppdata->regulator;
 	if (!pdata) {
 		dev_err(&pdev->dev, "null pdata\n");
 		return -EINVAL;
@@ -975,12 +983,12 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	}
 
 	/* initialize registers */
-	for (i = 0; i < pdata->num_regulator_reg_init; i++) {
+	for (i = 0; i < pdata->num_reg_init; i++) {
 		int id, mask, value;
 
-		id = pdata->regulator_reg_init[i].id;
-		mask = pdata->regulator_reg_init[i].mask;
-		value = pdata->regulator_reg_init[i].value;
+		id = pdata->reg_init[i].id;
+		mask = pdata->reg_init[i].mask;
+		value = pdata->reg_init[i].value;
 
 		/* check for configuration errors */
 		BUG_ON(id >= AB8500_NUM_REGULATOR_REGISTERS);
@@ -1046,5 +1054,6 @@ module_exit(ab8500_regulator_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sundar Iyer <sundar.iyer@stericsson.com>");
+MODULE_AUTHOR("Bengt Jonsson <bengt.g.jonsson@stericsson.com>");
 MODULE_DESCRIPTION("Regulator Driver for ST-Ericsson AB8500 Mixed-Sig PMIC");
 MODULE_ALIAS("platform:ab8500-regulator");
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index dd7944f..3a8e026 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -152,4 +152,11 @@ enum ab9540_regulator_reg {
 	AB9540_NUM_REGULATOR_REGISTERS,
 };
 
+struct ab8500_regulator_platform_data {
+	int num_reg_init;
+	struct ab8500_regulator_reg_init *reg_init;
+	int num_regulator;
+	struct regulator_init_data *regulator;
+};
+
 #endif
-- 
1.7.9.5

