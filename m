Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaIIWYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:24:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59863 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaIIWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:24:11 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue,  9 Sep 2014 23:23:55 +0100
Message-Id: <1410301435-554-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410301435-554-1-git-send-email-broonie@kernel.org>
References: <1410301435-554-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] regulator: tps65217: Use simplified DT parsing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Remove a bunch of code in favour of data.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/tps65217-regulator.c | 114 +++++++++------------------------
 1 file changed, 31 insertions(+), 83 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 89593a6..adbe4fc 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -27,10 +27,13 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/tps65217.h>
 
-#define TPS65217_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _em, _t, _lr, _nlr) \
+#define TPS65217_REGULATOR(_name, _id, _of_match, _ops, _n, _vr, _vm, _em, \
+                           _t, _lr, _nlr) \
 	{						\
 		.name		= _name,		\
 		.id		= _id,			\
+		.of_match       = of_match_ptr(_of_match),    \
+		.regulators_node= of_match_ptr("regulators"), \
 		.ops		= &_ops,		\
 		.n_voltages	= _n,			\
 		.type		= REGULATOR_VOLTAGE,	\
@@ -138,87 +141,40 @@ static struct regulator_ops tps65217_pmic_ldo1_ops = {
 };
 
 static const struct regulator_desc regulators[] = {
-	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64,
-			   TPS65217_REG_DEFDCDC1, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC1_EN, NULL, tps65217_uv1_ranges,
-			   2),	/* DCDC1 voltage range: 900000 ~ 1800000 */
-	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64,
-			   TPS65217_REG_DEFDCDC2, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC2_EN, NULL, tps65217_uv1_ranges,
+	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, "dcdc1",
+			   tps65217_pmic_ops, 64, TPS65217_REG_DEFDCDC1,
+			   TPS65217_DEFDCDCX_DCDC_MASK, TPS65217_ENABLE_DC1_EN,
+			   NULL, tps65217_uv1_ranges, 2),
+	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, "dcdc2",
+			   tps65217_pmic_ops, 64, TPS65217_REG_DEFDCDC2,
+			   TPS65217_DEFDCDCX_DCDC_MASK, TPS65217_ENABLE_DC2_EN,
+			   NULL, tps65217_uv1_ranges,
 			   ARRAY_SIZE(tps65217_uv1_ranges)),
-	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64,
-			   TPS65217_REG_DEFDCDC3, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC3_EN, NULL, tps65217_uv1_ranges,
-			   1),	/* DCDC3 voltage range: 900000 ~ 1500000 */
-	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, tps65217_pmic_ldo1_ops, 16,
-			   TPS65217_REG_DEFLDO1, TPS65217_DEFLDO1_LDO1_MASK,
-			   TPS65217_ENABLE_LDO1_EN, LDO1_VSEL_table, NULL, 0),
-	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, tps65217_pmic_ops, 64,
-			   TPS65217_REG_DEFLDO2, TPS65217_DEFLDO2_LDO2_MASK,
-			   TPS65217_ENABLE_LDO2_EN, NULL, tps65217_uv1_ranges,
+	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, "dcdc3",
+			   tps65217_pmic_ops, 64, TPS65217_REG_DEFDCDC3,
+			   TPS65217_DEFDCDCX_DCDC_MASK, TPS65217_ENABLE_DC3_EN,
+			   NULL, tps65217_uv1_ranges, 1),
+	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, "ldo1",
+			   tps65217_pmic_ldo1_ops, 16, TPS65217_REG_DEFLDO1,
+			   TPS65217_DEFLDO1_LDO1_MASK, TPS65217_ENABLE_LDO1_EN,
+			   LDO1_VSEL_table, NULL, 0),
+	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, "ldo2", tps65217_pmic_ops,
+			   64, TPS65217_REG_DEFLDO2,
+			   TPS65217_DEFLDO2_LDO2_MASK, TPS65217_ENABLE_LDO2_EN,
+			   NULL, tps65217_uv1_ranges,
 			   ARRAY_SIZE(tps65217_uv1_ranges)),
-	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, tps65217_pmic_ops, 32,
-			   TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK,
+	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, "ldo3", tps65217_pmic_ops,
+			   32, TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK,
 			   TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN,
 			   NULL, tps65217_uv2_ranges,
 			   ARRAY_SIZE(tps65217_uv2_ranges)),
-	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, tps65217_pmic_ops, 32,
-			   TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK,
+	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, "ldo4", tps65217_pmic_ops,
+			   32, TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK,
 			   TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN,
 			   NULL, tps65217_uv2_ranges,
 			   ARRAY_SIZE(tps65217_uv2_ranges)),
 };
 
-#ifdef CONFIG_OF
-static struct of_regulator_match reg_matches[] = {
-	{ .name = "dcdc1" },
-	{ .name = "dcdc2" },
-	{ .name = "dcdc3" },
-	{ .name = "ldo1"  },
-	{ .name = "ldo2"  },
-	{ .name = "ldo3"  },
-	{ .name = "ldo4"  },
-};
-
-static struct tps65217_board *tps65217_parse_dt(struct platform_device *pdev)
-{
-	struct tps65217 *tps = dev_get_drvdata(pdev->dev.parent);
-	struct device_node *node = tps->dev->of_node;
-	struct tps65217_board *pdata;
-	struct device_node *regs;
-	int i, count;
-
-	regs = of_get_child_by_name(node, "regulators");
-	if (!regs)
-		return NULL;
-
-	count = of_regulator_match(&pdev->dev, regs, reg_matches,
-				   TPS65217_NUM_REGULATOR);
-	of_node_put(regs);
-	if ((count < 0) || (count > TPS65217_NUM_REGULATOR))
-		return NULL;
-
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return NULL;
-
-	for (i = 0; i < count; i++) {
-		if (!reg_matches[i].of_node)
-			continue;
-
-		pdata->tps65217_init_data[i] = reg_matches[i].init_data;
-		pdata->of_node[i] = reg_matches[i].of_node;
-	}
-
-	return pdata;
-}
-#else
-static struct tps65217_board *tps65217_parse_dt(struct platform_device *pdev)
-{
-	return NULL;
-}
-#endif
-
 static int tps65217_regulator_probe(struct platform_device *pdev)
 {
 	struct tps65217 *tps = dev_get_drvdata(pdev->dev.parent);
@@ -227,14 +183,6 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	int i;
 
-	if (tps->dev->of_node)
-		pdata = tps65217_parse_dt(pdev);
-
-	if (!pdata) {
-		dev_err(&pdev->dev, "Platform data not found\n");
-		return -EINVAL;
-	}
-
 	if (tps65217_chip_id(tps) != TPS65217) {
 		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return -ENODEV;
@@ -245,11 +193,10 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 	for (i = 0; i < TPS65217_NUM_REGULATOR; i++) {
 		/* Register the regulators */
 		config.dev = tps->dev;
-		config.init_data = pdata->tps65217_init_data[i];
+		if (pdata)
+			config.init_data = pdata->tps65217_init_data[i];
 		config.driver_data = tps;
 		config.regmap = tps->regmap;
-		if (tps->dev->of_node)
-			config.of_node = pdata->of_node[i];
 
 		rdev = devm_regulator_register(&pdev->dev, &regulators[i],
 					       &config);
@@ -259,6 +206,7 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 			return PTR_ERR(rdev);
 		}
 	}
+
 	return 0;
 }
 
-- 
2.1.0

