Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaEZO6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:58:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37861 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752769AbaEZO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:58:43 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 5/5] regulator: axp20x: resolve self dependency issue
Date: Mon, 26 May 2014 16:58:12 +0200
Message-Id: <1401116292-24066-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401116292-24066-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1401116292-24066-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators might take their power supply from other regulators defined
by the same PMIC.

Retry regulators registration until all regulators are registered or the
last iteration didn't manage to register any new regulator (which means
there's an external dependency missing and we can thus return
EPROBE_DEFER).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/regulator/axp20x-regulator.c | 75 ++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 4486517..c5b665e 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -146,6 +146,8 @@ static const struct regulator_desc axp20x_regulators[] = {
 		       AXP20X_IO_DISABLED),
 };
 
+static bool axp20x_registered_regulators[AXP20X_REG_ID_MAX];
+
 static const struct regulator_desc axp22x_regulators[] = {
 	AXP_DESC(AXP22X, DCDC1, "vin1", 1600, 3400, 100, AXP22X_DCDC1_V_OUT, 0x1f,
 		    AXP22X_PWR_OUT_CTRL1, BIT(1)),
@@ -188,6 +190,8 @@ static const struct regulator_desc axp22x_regulators[] = {
 	AXP_DESC_FIXED(AXP22X, RTC_LDO, "rtcldoin", 3000),
 };
 
+static bool axp22x_registered_regulators[AXP22X_REG_ID_MAX];
+
 #define AXP_MATCH(_family, _name, _id) \
 	[_family##_##_id] = { \
 		.name		= #_name, \
@@ -308,6 +312,9 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 	int nmatches;
 	const struct regulator_desc *regulators;
 	int nregulators;
+	bool *registered;
+	int nregistered = 0;
+	int prev_nregistered = -1;
 	int ret, i;
 	u32 workmode;
 
@@ -316,11 +323,13 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 		nmatches = ARRAY_SIZE(axp22x_matches);
 		regulators = axp22x_regulators;
 		nregulators = AXP22X_REG_ID_MAX;
+		registered = axp22x_registered_regulators;
 	} else {
 		matches = axp20x_matches;
 		nmatches = ARRAY_SIZE(axp20x_matches);
 		regulators = axp20x_regulators;
 		nregulators = AXP20X_REG_ID_MAX;
+		registered = axp20x_registered_regulators;
 	}
 
 	/*
@@ -332,36 +341,68 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 		matches[i].of_node = NULL;
 	}
 
+	/*
+	 * Reset registered status table (this table might have been modified
+	 * by a previous AXP2xx device probe).
+	 */
+	memset(registered, 0, nregulators * sizeof(*registered));
+
 	ret = axp20x_regulator_parse_dt(pdev, matches, nmatches);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < AXP20X_REG_ID_MAX; i++) {
-		init_data = matches[i].init_data;
+	/*
+	 * Some regulators might take their power supply from other regulators
+	 * defined by the same PMIC.
+	 *
+	 * Retry regulators registration until all regulators are registered
+	 * or the last iteration didn't manage to register any new regulator
+	 * (which means there's an external dependency missing and we can thus
+	 * return EPROBE_DEFER).
+	 */
+	while (nregistered < nregulators &&
+	       prev_nregistered < nregistered) {
 
-		config.dev = &pdev->dev;
-		config.init_data = init_data;
-		config.regmap = axp20x->regmap;
-		config.of_node = matches[i].of_node;
+		prev_nregistered = nregistered;
 
-		rdev = devm_regulator_register(&pdev->dev, &regulators[i],
-					       &config);
-		if (IS_ERR(rdev)) {
-			dev_err(&pdev->dev, "Failed to register %s\n",
+		for (i = 0; i < nregulators; i++) {
+			if (registered[i])
+				continue;
+
+			init_data = matches[i].init_data;
+
+			config.dev = &pdev->dev;
+			config.init_data = init_data;
+			config.regmap = axp20x->regmap;
+			config.of_node = matches[i].of_node;
+
+			rdev = devm_regulator_register(&pdev->dev,
+						       &regulators[i],
+						       &config);
+			if (IS_ERR(rdev)) {
+				dev_err(&pdev->dev, "Failed to register %s\n",
 				regulators[i].name);
 
-			return PTR_ERR(rdev);
-		}
+				return PTR_ERR(rdev);
+			}
 
-		ret = of_property_read_u32(matches[i].of_node, "x-powers,dcdc-workmode",
-					   &workmode);
-		if (!ret) {
-			if (axp20x_set_dcdc_workmode(rdev, i, workmode))
-				dev_err(&pdev->dev, "Failed to set workmode on %s\n",
+			ret = of_property_read_u32(matches[i].of_node,
+						   "x-powers,dcdc-workmode",
+						   &workmode);
+			if (!ret &&
+			    axp20x_set_dcdc_workmode(rdev, i, workmode))
+				dev_err(&pdev->dev,
+					"Failed to set workmode on %s\n",
 					regulators[i].name);
+
+			registered[i] = true;
+			nregistered++;
 		}
 	}
 
+	if (nregistered < nregulators)
+		return -EPROBE_DEFER;
+
 	return 0;
 }
 
-- 
1.8.3.2

