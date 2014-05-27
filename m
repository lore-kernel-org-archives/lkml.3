Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaE0JkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:40:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752278AbaE0JkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:40:16 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 6/6] regulator: axp20x: make use of devm_regulator_set_register
Date: Tue, 27 May 2014 11:38:55 +0200
Message-Id: <1401183535-31003-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the devm_regulator_set_register instead of registering each
regulator provided by the PMIC.

This also solves a self dependency issue where one regulator of the PMIC
is used as a supply for anoher regulator provided by the same PMIC.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/regulator/axp20x-regulator.c | 59 ++++++++++++++----------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 4486517..c799827 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -300,66 +300,53 @@ static int axp20x_set_dcdc_workmode(struct regulator_dev *rdev, int id, u32 work
 
 static int axp20x_regulator_probe(struct platform_device *pdev)
 {
-	struct regulator_dev *rdev;
+	struct regulator_set *rset;
 	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
-	struct regulator_config config = { };
-	struct regulator_init_data *init_data;
+	struct regulator_set_config config;
 	struct of_regulator_match *matches;
-	int nmatches;
-	const struct regulator_desc *regulators;
-	int nregulators;
 	int ret, i;
 	u32 workmode;
 
+	memset(&config, 0, sizeof(config));
+	config.dev = &pdev->dev;
+	config.regmap = axp20x->regmap;
 	if (axp20x->variant == AXP221_ID) {
 		matches = axp22x_matches;
-		nmatches = ARRAY_SIZE(axp22x_matches);
-		regulators = axp22x_regulators;
-		nregulators = AXP22X_REG_ID_MAX;
+		config.descs = axp22x_regulators;
+		config.nregulators = AXP22X_REG_ID_MAX;
 	} else {
 		matches = axp20x_matches;
-		nmatches = ARRAY_SIZE(axp20x_matches);
-		regulators = axp20x_regulators;
-		nregulators = AXP20X_REG_ID_MAX;
+		config.descs = axp20x_regulators;
+		config.nregulators = AXP20X_REG_ID_MAX;
 	}
+	config.matches = matches;
 
 	/*
 	 * Reset matches table (this table might have been modified by a
 	 * previous AXP2xx device probe).
 	 */
-	for (i = 0; i < nmatches; i++) {
+	for (i = 0; i < config.nregulators; i++) {
 		matches[i].init_data = NULL;
 		matches[i].of_node = NULL;
 	}
 
-	ret = axp20x_regulator_parse_dt(pdev, matches, nmatches);
+	ret = axp20x_regulator_parse_dt(pdev, matches,
+					config.nregulators);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < AXP20X_REG_ID_MAX; i++) {
-		init_data = matches[i].init_data;
+	rset = devm_regulator_set_register(&pdev->dev, &config);
+	if (IS_ERR(rset))
+		return PTR_ERR(rset);
 
-		config.dev = &pdev->dev;
-		config.init_data = init_data;
-		config.regmap = axp20x->regmap;
-		config.of_node = matches[i].of_node;
-
-		rdev = devm_regulator_register(&pdev->dev, &regulators[i],
-					       &config);
-		if (IS_ERR(rdev)) {
-			dev_err(&pdev->dev, "Failed to register %s\n",
-				regulators[i].name);
-
-			return PTR_ERR(rdev);
-		}
-
-		ret = of_property_read_u32(matches[i].of_node, "x-powers,dcdc-workmode",
+	for (i = 0; i < rset->nregulators; i++) {
+		ret = of_property_read_u32(config.matches[i].of_node,
+					   "x-powers,dcdc-workmode",
 					   &workmode);
-		if (!ret) {
-			if (axp20x_set_dcdc_workmode(rdev, i, workmode))
-				dev_err(&pdev->dev, "Failed to set workmode on %s\n",
-					regulators[i].name);
-		}
+		if (!ret &&
+		    axp20x_set_dcdc_workmode(rset->regulators[i], i, workmode))
+			dev_err(&pdev->dev, "Failed to set workmode on %s\n",
+				config.descs[i].name);
 	}
 
 	return 0;
-- 
1.8.3.2

