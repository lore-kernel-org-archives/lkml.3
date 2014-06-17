Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaFQHks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:40:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44359 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbaFQHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:39:00 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 2/7] regulator: axp20x: prepare support for multiple AXP chip families
Date: Tue, 17 Jun 2014 09:38:38 +0200
Message-Id: <1402990723-28138-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the AXP20X_ macros to support the several chip families, so that
each family can define it's own set of regulators, and regulator matches.

Pass a match table to the axp20x_regulator_parse_dt function instead of
statically using the axp20x match table.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/regulator/axp20x-regulator.c | 74 +++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 004aadb..9716f8e 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -32,13 +32,13 @@
 
 #define AXP20X_FREQ_DCDC_MASK		0x0f
 
-#define AXP20X_DESC_IO(_id, _supply, _min, _max, _step, _vreg, _vmask, _ereg,   \
-		       _emask, _enable_val, _disable_val)			\
-	[AXP20X_##_id] = {							\
+#define AXP_DESC_IO(_family, _id, _supply, _min, _max, _step, _vreg, _vmask,	\
+		    _ereg, _emask, _enable_val, _disable_val)			\
+	[_family##_##_id] = {							\
 		.name		= #_id,						\
 		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
-		.id		= AXP20X_##_id,					\
+		.id		= _family##_##_id,				\
 		.n_voltages	= (((_max) - (_min)) / (_step) + 1),		\
 		.owner		= THIS_MODULE,					\
 		.min_uV		= (_min) * 1000,				\
@@ -52,13 +52,13 @@
 		.ops		= &axp20x_ops,					\
 	}
 
-#define AXP20X_DESC(_id, _supply, _min, _max, _step, _vreg, _vmask, _ereg,	\
-		    _emask) 							\
-	[AXP20X_##_id] = {							\
+#define AXP_DESC(_family, _id, _supply, _min, _max, _step, _vreg, _vmask, 	\
+		 _ereg, _emask) 						\
+	[_family##_##_id] = {							\
 		.name		= #_id,						\
 		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
-		.id		= AXP20X_##_id,					\
+		.id		= _family##_##_id,				\
 		.n_voltages	= (((_max) - (_min)) / (_step) + 1),		\
 		.owner		= THIS_MODULE,					\
 		.min_uV		= (_min) * 1000,				\
@@ -70,24 +70,25 @@
 		.ops		= &axp20x_ops,					\
 	}
 
-#define AXP20X_DESC_FIXED(_id, _supply, _volt)					\
-	[AXP20X_##_id] = {							\
+#define AXP_DESC_FIXED(_family, _id, _supply, _volt)				\
+	[_family##_##_id] = {							\
 		.name		= #_id,						\
 		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
-		.id		= AXP20X_##_id,					\
+		.id		= _family##_##_id,				\
 		.n_voltages	= 1,						\
 		.owner		= THIS_MODULE,					\
 		.min_uV		= (_volt) * 1000,				\
 		.ops		= &axp20x_ops_fixed				\
 	}
 
-#define AXP20X_DESC_TABLE(_id, _supply, _table, _vreg, _vmask, _ereg, _emask)	\
-	[AXP20X_##_id] = {							\
+#define AXP_DESC_TABLE(_family, _id, _supply, _table, _vreg, _vmask, _ereg,	\
+		       _emask)							\
+	[_family##_##_id] = {							\
 		.name		= #_id,						\
 		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
-		.id		= AXP20X_##_id,					\
+		.id		= _family##_##_id,				\
 		.n_voltages	= ARRAY_SIZE(_table),				\
 		.owner		= THIS_MODULE,					\
 		.vsel_reg	= (_vreg),					\
@@ -127,36 +128,36 @@ static struct regulator_ops axp20x_ops = {
 };
 
 static const struct regulator_desc axp20x_regulators[] = {
-	AXP20X_DESC(DCDC2, "vin2", 700, 2275, 25, AXP20X_DCDC2_V_OUT, 0x3f,
+	AXP_DESC(AXP20X, DCDC2, "vin2", 700, 2275, 25, AXP20X_DCDC2_V_OUT, 0x3f,
 		    AXP20X_PWR_OUT_CTRL, 0x10),
-	AXP20X_DESC(DCDC3, "vin3", 700, 3500, 25, AXP20X_DCDC3_V_OUT, 0x7f,
+	AXP_DESC(AXP20X, DCDC3, "vin3", 700, 3500, 25, AXP20X_DCDC3_V_OUT, 0x7f,
 		    AXP20X_PWR_OUT_CTRL, 0x02),
-	AXP20X_DESC_FIXED(LDO1, "acin", 1300),
-	AXP20X_DESC(LDO2, "ldo24in", 1800, 3300, 100, AXP20X_LDO24_V_OUT, 0xf0,
+	AXP_DESC_FIXED(AXP20X, LDO1, "acin", 1300),
+	AXP_DESC(AXP20X, LDO2, "ldo24in", 1800, 3300, 100, AXP20X_LDO24_V_OUT, 0xf0,
 		    AXP20X_PWR_OUT_CTRL, 0x04),
-	AXP20X_DESC(LDO3, "ldo3in", 700, 3500, 25, AXP20X_LDO3_V_OUT, 0x7f,
+	AXP_DESC(AXP20X, LDO3, "ldo3in", 700, 3500, 25, AXP20X_LDO3_V_OUT, 0x7f,
 		    AXP20X_PWR_OUT_CTRL, 0x40),
-	AXP20X_DESC_TABLE(LDO4, "ldo24in", axp20x_ldo4_data, AXP20X_LDO24_V_OUT, 0x0f,
+	AXP_DESC_TABLE(AXP20X, LDO4, "ldo24in", axp20x_ldo4_data, AXP20X_LDO24_V_OUT, 0x0f,
 			  AXP20X_PWR_OUT_CTRL, 0x08),
-	AXP20X_DESC_IO(LDO5, "ldo5in", 1800, 3300, 100, AXP20X_LDO5_V_OUT, 0xf0,
+	AXP_DESC_IO(AXP20X, LDO5, "ldo5in", 1800, 3300, 100, AXP20X_LDO5_V_OUT, 0xf0,
 		       AXP20X_GPIO0_CTRL, 0x07, AXP20X_IO_ENABLED,
 		       AXP20X_IO_DISABLED),
 };
 
-#define AXP_MATCH(_name, _id) \
-	[AXP20X_##_id] = { \
+#define AXP_MATCH(_family, _name, _id) \
+	[_family##_##_id] = { \
 		.name		= #_name, \
-		.driver_data	= (void *) &axp20x_regulators[AXP20X_##_id], \
+		.driver_data	= (void *) &axp20x_regulators[_family##_##_id], \
 	}
 
 static struct of_regulator_match axp20x_matches[] = {
-	AXP_MATCH(dcdc2, DCDC2),
-	AXP_MATCH(dcdc3, DCDC3),
-	AXP_MATCH(ldo1, LDO1),
-	AXP_MATCH(ldo2, LDO2),
-	AXP_MATCH(ldo3, LDO3),
-	AXP_MATCH(ldo4, LDO4),
-	AXP_MATCH(ldo5, LDO5),
+	AXP_MATCH(AXP20X, dcdc2, DCDC2),
+	AXP_MATCH(AXP20X, dcdc3, DCDC3),
+	AXP_MATCH(AXP20X, ldo1, LDO1),
+	AXP_MATCH(AXP20X, ldo2, LDO2),
+	AXP_MATCH(AXP20X, ldo3, LDO3),
+	AXP_MATCH(AXP20X, ldo4, LDO4),
+	AXP_MATCH(AXP20X, ldo5, LDO5),
 };
 
 static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
@@ -179,7 +180,9 @@ static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
 				  AXP20X_FREQ_DCDC_MASK, dcdcfreq);
 }
 
-static int axp20x_regulator_parse_dt(struct platform_device *pdev)
+static int axp20x_regulator_parse_dt(struct platform_device *pdev,
+				     struct of_regulator_match *matches,
+				     int nmatches)
 {
 	struct device_node *np, *regulators;
 	int ret;
@@ -193,8 +196,8 @@ static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 	if (!regulators) {
 		dev_warn(&pdev->dev, "regulators node not found\n");
 	} else {
-		ret = of_regulator_match(&pdev->dev, regulators, axp20x_matches,
-					 ARRAY_SIZE(axp20x_matches));
+		ret = of_regulator_match(&pdev->dev, regulators, matches,
+					 nmatches);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
 			return ret;
@@ -238,7 +241,8 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 	int ret, i;
 	u32 workmode;
 
-	ret = axp20x_regulator_parse_dt(pdev);
+	ret = axp20x_regulator_parse_dt(pdev, axp20x_matches,
+					ARRAY_SIZE(axp20x_matches));
 	if (ret)
 		return ret;
 
-- 
1.8.3.2

