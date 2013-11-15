Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab3KON3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:29:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab3KON3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:29:07 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.org, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: arizona-micsupp: Correct wm5110 voltage selection
Date: Fri, 15 Nov 2013 13:13:33 +0000
Message-Id: <1384521213-27141-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384521213-27141-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384521213-27141-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm5110 provides different voltage configurations than the other Arizona
parts, this patch adds support for this into the regulator driver. Also
fixup the default for the configuration register for wm5110.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c         |    2 +-
 drivers/regulator/arizona-micsupp.c |   54 +++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 3113e39..daf2fe8 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -498,7 +498,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x000001AA, 0x0004 },    /* R426   - FLL2 GPIO Clock */
 	{ 0x00000200, 0x0006 },    /* R512   - Mic Charge Pump 1 */
 	{ 0x00000210, 0x0184 },    /* R528   - LDO1 Control 1 */
-	{ 0x00000213, 0x0344 },    /* R531   - LDO2 Control 1 */
+	{ 0x00000213, 0x03E4 },    /* R531   - LDO2 Control 1 */
 	{ 0x00000218, 0x01A6 },    /* R536   - Mic Bias Ctrl 1 */
 	{ 0x00000219, 0x01A6 },    /* R537   - Mic Bias Ctrl 2 */
 	{ 0x0000021A, 0x01A6 },    /* R538   - Mic Bias Ctrl 3 */
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 3c75bf8..034ece7 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -144,6 +144,33 @@ static const struct regulator_desc arizona_micsupp = {
 	.owner = THIS_MODULE,
 };
 
+static const struct regulator_linear_range arizona_micsupp_ext_ranges[] = {
+	REGULATOR_LINEAR_RANGE(900000,  0,    0x14, 25000),
+	REGULATOR_LINEAR_RANGE(1500000, 0x15, 0x27, 100000),
+};
+
+static const struct regulator_desc arizona_micsupp_ext = {
+	.name = "MICVDD",
+	.supply_name = "CPVDD",
+	.type = REGULATOR_VOLTAGE,
+	.n_voltages = 40,
+	.ops = &arizona_micsupp_ops,
+
+	.vsel_reg = ARIZONA_LDO2_CONTROL_1,
+	.vsel_mask = ARIZONA_LDO2_VSEL_MASK,
+	.enable_reg = ARIZONA_MIC_CHARGE_PUMP_1,
+	.enable_mask = ARIZONA_CPMIC_ENA,
+	.bypass_reg = ARIZONA_MIC_CHARGE_PUMP_1,
+	.bypass_mask = ARIZONA_CPMIC_BYPASS,
+
+	.linear_ranges = arizona_micsupp_ext_ranges,
+	.n_linear_ranges = ARRAY_SIZE(arizona_micsupp_ext_ranges),
+
+	.enable_time = 3000,
+
+	.owner = THIS_MODULE,
+};
+
 static const struct regulator_init_data arizona_micsupp_default = {
 	.constraints = {
 		.valid_ops_mask = REGULATOR_CHANGE_STATUS |
@@ -156,9 +183,22 @@ static const struct regulator_init_data arizona_micsupp_default = {
 	.num_consumer_supplies = 1,
 };
 
+static const struct regulator_init_data arizona_micsupp_ext_default = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_BYPASS,
+		.min_uV = 900000,
+		.max_uV = 3300000,
+	},
+
+	.num_consumer_supplies = 1,
+};
+
 static int arizona_micsupp_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
+	const struct regulator_desc *desc;
 	struct regulator_config config = { };
 	struct arizona_micsupp *micsupp;
 	int ret;
@@ -177,7 +217,17 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	 * default init_data for it.  This will be overridden with
 	 * platform data if provided.
 	 */
-	micsupp->init_data = arizona_micsupp_default;
+	switch (arizona->type) {
+	case WM5110:
+		desc = &arizona_micsupp_ext;
+		micsupp->init_data = arizona_micsupp_ext_default;
+		break;
+	default:
+		desc = &arizona_micsupp;
+		micsupp->init_data = arizona_micsupp_default;
+		break;
+	}
+
 	micsupp->init_data.consumer_supplies = &micsupp->supply;
 	micsupp->supply.supply = "MICVDD";
 	micsupp->supply.dev_name = dev_name(arizona->dev);
@@ -196,7 +246,7 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 			   ARIZONA_CPMIC_BYPASS, 0);
 
 	micsupp->regulator = devm_regulator_register(&pdev->dev,
-						     &arizona_micsupp,
+						     desc,
 						     &config);
 	if (IS_ERR(micsupp->regulator)) {
 		ret = PTR_ERR(micsupp->regulator);
-- 
1.7.2.5

