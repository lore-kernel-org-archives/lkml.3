Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaA1MTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:19:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20320 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaA1MTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:14 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-72-52e7a03d3233
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 15/18] regulator: max14577: Add support for max77836 regulators
Date: Tue, 28 Jan 2014 13:18:39 +0100
Message-id: <1390911522-28209-16-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xa7q2C54HGUw5Y2Mx9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6MS4feMRWcnsFY
	cfX/XcYGxiUNjF2MnBwSAiYSixc9YYawxSQu3FvP1sXIxSEksJRRYvXVCewQTh+TxIrnd8A6
	2ASMJTYvXwJWJSKwmklizYKpLCAJZoFeRombuz1AbGEBf4mX3fOZQGwWAVWJfc0fwZp5BTwk
	Li5/BTSVA2idgsScSTYgYU6g8KurjWDlQgLuEqeOv2OZwMi7gJFhFaNoamlyQXFSeq6hXnFi
	bnFpXrpecn7uJkZIOH7Zwbj4mNUhRgEORiUe3o7OZ0FCrIllxZW5hxglOJiVRHgTZz8PEuJN
	SaysSi3Kjy8qzUktPsTIxMEp1cDo6tX9kJk34VKM6EzREq9t0YURH97HPutsD593/bD9ae9z
	N579PjdR9wwTf945yWdCPq5ztxsqrRXZb1J+5vfflRzLvr/6GLt/+jVhsQkXcsVPLRRLuXV4
	MUsC2/ViW//YlvWzmOrl2yZLuv5u1ZZ4cT9XKSjzS4IDp8+qRfarv8ns/yQYZtSjxFKckWio
	xVxUnAgA49WkeCUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MAX77836 chipset and its additional two LDO regulators.
These LDO regulators are controlled by the PMIC block with additional
regmap (different I2C slave address).

The MAX77836 charger and safeout regulators are almost identical to
MAX14577. The registry layout is the same, except values for charger's
current. The patch adds simple mapping between device type and supported
current by the charger regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/max14577.c         |  275 +++++++++++++++++++++++++++++-----
 include/linux/mfd/max14577-private.h |   32 +++-
 include/linux/mfd/max14577.h         |   10 ++
 3 files changed, 281 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 8856c660a5da..7150606ac482 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -1,5 +1,5 @@
 /*
- * max14577.c - Regulator driver for the Maxim 14577
+ * max14577.c - Regulator driver for the Maxim 14577/77836
  *
  * Copyright (C) 2013,2014 Samsung Electronics
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
@@ -22,6 +22,42 @@
 #include <linux/mfd/max14577-private.h>
 #include <linux/regulator/of_regulator.h>
 
+/*
+ * Valid limits of current for max14577 and max77836 chargers.
+ * They must correspond to MBCICHWRCL and MBCICHWRCH fields in CHGCTRL4
+ * register for given chipset.
+ */
+struct maxim_charger_current {
+	/* Minimal current, set in CHGCTRL4/MBCICHWRCL, uA */
+	unsigned int min;
+	/*
+	 * Minimal current when high setting is active,
+	 * set in CHGCTRL4/MBCICHWRCH, uA
+	 */
+	unsigned int high_start;
+	/* Value of one step in high setting, uA */
+	unsigned int high_step;
+	/* Maximum current of high setting, uA */
+	unsigned int max;
+};
+
+/* Table of valid charger currents for different Maxim chipsets */
+static const struct maxim_charger_current maxim_charger_currents[] = {
+	[MAXIM_DEVICE_TYPE_UNKNOWN] = { 0, 0, 0, 0 },
+	[MAXIM_DEVICE_TYPE_MAX14577] = {
+		.min		= MAX14577_REGULATOR_CURRENT_LIMIT_MIN,
+		.high_start	= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START,
+		.high_step	= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP,
+		.max		= MAX14577_REGULATOR_CURRENT_LIMIT_MAX,
+	},
+	[MAXIM_DEVICE_TYPE_MAX77836] = {
+		.min		= MAX77836_REGULATOR_CURRENT_LIMIT_MIN,
+		.high_start	= MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START,
+		.high_step	= MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP,
+		.max		= MAX77836_REGULATOR_CURRENT_LIMIT_MAX,
+	},
+};
+
 static int max14577_reg_is_enabled(struct regulator_dev *rdev)
 {
 	int rid = rdev_get_id(rdev);
@@ -47,6 +83,9 @@ static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
 {
 	u8 reg_data;
 	struct regmap *rmap = rdev->regmap;
+	struct maxim_core *maxim_core = rdev_get_drvdata(rdev);
+	const struct maxim_charger_current *limits =
+		&maxim_charger_currents[maxim_core->dev_type];
 
 	if (rdev_get_id(rdev) != MAX14577_CHARGER)
 		return -EINVAL;
@@ -54,12 +93,11 @@ static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
 	max14577_read_reg(rmap, MAXIM_CHG_REG_CHGCTRL4, &reg_data);
 
 	if ((reg_data & MAXIM_CHGCTRL4_MBCICHWRCL_MASK) == 0)
-		return MAX14577_REGULATOR_CURRENT_LIMIT_MIN;
+		return limits->min;
 
 	reg_data = ((reg_data & MAXIM_CHGCTRL4_MBCICHWRCH_MASK) >>
 			MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT);
-	return MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
-		reg_data * MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP;
+	return limits->high_start + reg_data * limits->high_step;
 }
 
 static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
@@ -67,33 +105,35 @@ static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 {
 	int i, current_bits = 0xf;
 	u8 reg_data;
+	struct maxim_core *maxim_core = rdev_get_drvdata(rdev);
+	const struct maxim_charger_current *limits =
+		&maxim_charger_currents[maxim_core->dev_type];
 
 	if (rdev_get_id(rdev) != MAX14577_CHARGER)
 		return -EINVAL;
 
-	if (min_uA > MAX14577_REGULATOR_CURRENT_LIMIT_MAX ||
-			max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_MIN)
+	if (min_uA > limits->max || max_uA < limits->min)
 		return -EINVAL;
 
-	if (max_uA < MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START) {
-		/* Less than 200 mA, so set 90mA (turn only Low Bit off) */
+	if (max_uA < limits->high_start) {
+		/* Less than high_start,
+		 * so set the minimal current (turn only Low Bit off) */
 		u8 reg_data = 0x0 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
 		return max14577_update_reg(rdev->regmap,
 				MAXIM_CHG_REG_CHGCTRL4,
 				MAXIM_CHGCTRL4_MBCICHWRCL_MASK, reg_data);
 	}
 
-	/* max_uA is in range: <LIMIT_HIGH_START, inifinite>, so search for
-	 * valid current starting from LIMIT_MAX. */
-	for (i = MAX14577_REGULATOR_CURRENT_LIMIT_MAX;
-			i >= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START;
-			i -= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP) {
+	/* max_uA is in range: <high_start, inifinite>, so search for
+	 * valid current starting from maximum current. */
+	for (i = limits->max; i >= limits->high_start; i -= limits->high_step) {
 		if (i <= max_uA)
 			break;
 		current_bits--;
 	}
 	BUG_ON(current_bits < 0); /* Cannot happen */
-	/* Turn Low Bit on (use range 200mA-950 mA) */
+
+	/* Turn Low Bit on (use range high_start-max)... */
 	reg_data = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
 	/* and set proper High Bits */
 	reg_data |= current_bits << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
@@ -118,7 +158,7 @@ static struct regulator_ops max14577_charger_ops = {
 	.set_current_limit	= max14577_reg_set_current_limit,
 };
 
-static const struct regulator_desc supported_regulators[] = {
+static const struct regulator_desc max14577_supported_regulators[] = {
 	[MAX14577_SAFEOUT] = {
 		.name		= "SAFEOUT",
 		.id		= MAX14577_SAFEOUT,
@@ -141,16 +181,88 @@ static const struct regulator_desc supported_regulators[] = {
 	},
 };
 
+static struct regulator_ops max77836_ldo_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	/* TODO: add .set_suspend_mode */
+};
+
+static const struct regulator_desc max77836_supported_regulators[] = {
+	[MAX14577_SAFEOUT] = {
+		.name		= "SAFEOUT",
+		.id		= MAX14577_SAFEOUT,
+		.ops		= &max14577_safeout_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+		.n_voltages	= 1,
+		.min_uV		= MAX14577_REGULATOR_SAFEOUT_VOLTAGE,
+		.enable_reg	= MAXIM_MUIC_REG_CONTROL2,
+		.enable_mask	= MAXIM_CONTROL2_SFOUTORD_MASK,
+	},
+	[MAX14577_CHARGER] = {
+		.name		= "CHARGER",
+		.id		= MAX14577_CHARGER,
+		.ops		= &max14577_charger_ops,
+		.type		= REGULATOR_CURRENT,
+		.owner		= THIS_MODULE,
+		.enable_reg	= MAXIM_CHG_REG_CHGCTRL2,
+		.enable_mask	= MAXIM_CHGCTRL2_MBCHOSTEN_MASK,
+	},
+	[MAX77836_LDO1] = {
+		.name		= "LDO1",
+		.id		= MAX77836_LDO1,
+		.ops		= &max77836_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+		.n_voltages	= MAX77836_REGULATOR_LDO_VOLTAGE_STEPS_NUM,
+		.min_uV		= MAX77836_REGULATOR_LDO_VOLTAGE_MIN,
+		.uV_step	= MAX77836_REGULATOR_LDO_VOLTAGE_STEP,
+		.enable_reg	= MAX77836_LDO_REG_CNFG1_LDO1,
+		.enable_mask	= MAX77836_CNFG1_LDO_PWRMD_MASK,
+		.vsel_reg	= MAX77836_LDO_REG_CNFG1_LDO1,
+		.vsel_mask	= MAX77836_CNFG1_LDO_TV_MASK,
+	},
+	[MAX77836_LDO2] = {
+		.name		= "LDO2",
+		.id		= MAX77836_LDO2,
+		.ops		= &max77836_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+		.n_voltages	= MAX77836_REGULATOR_LDO_VOLTAGE_STEPS_NUM,
+		.min_uV		= MAX77836_REGULATOR_LDO_VOLTAGE_MIN,
+		.uV_step	= MAX77836_REGULATOR_LDO_VOLTAGE_STEP,
+		.enable_reg	= MAX77836_LDO_REG_CNFG1_LDO2,
+		.enable_mask	= MAX77836_CNFG1_LDO_PWRMD_MASK,
+		.vsel_reg	= MAX77836_LDO_REG_CNFG1_LDO2,
+		.vsel_mask	= MAX77836_CNFG1_LDO_TV_MASK,
+	},
+};
+
 #ifdef CONFIG_OF
 static struct of_regulator_match max14577_regulator_matches[] = {
 	{ .name	= "SAFEOUT", },
 	{ .name = "CHARGER", },
 };
 
-static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
+static struct of_regulator_match max77836_regulator_matches[] = {
+	{ .name	= "SAFEOUT", },
+	{ .name = "CHARGER", },
+	{ .name = "LDO1", },
+	{ .name = "LDO2", },
+};
+
+static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
+		enum maxim_device_type dev_type)
 {
 	int ret;
 	struct device_node *np;
+	struct of_regulator_match *regulator_matches;
+	unsigned int regulator_matches_size;
 
 	np = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!np) {
@@ -158,8 +270,19 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ret = of_regulator_match(&pdev->dev, np, max14577_regulator_matches,
-			ARRAY_SIZE(max14577_regulator_matches));
+	switch (dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		regulator_matches = max77836_regulator_matches;
+		regulator_matches_size = ARRAY_SIZE(max77836_regulator_matches);
+		break;
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		regulator_matches = max14577_regulator_matches;
+		regulator_matches_size = ARRAY_SIZE(max14577_regulator_matches);
+	}
+
+	ret = of_regulator_match(&pdev->dev, np, regulator_matches,
+			regulator_matches_size);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
 		return ret;
@@ -168,31 +291,74 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
 	return 0;
 }
 
-static inline struct regulator_init_data *match_init_data(int index)
+static inline struct regulator_init_data *match_init_data(int index,
+		enum maxim_device_type dev_type)
 {
-	return max14577_regulator_matches[index].init_data;
+	switch (dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		return max77836_regulator_matches[index].init_data;
+
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		return max14577_regulator_matches[index].init_data;
+	}
 }
 
-static inline struct device_node *match_of_node(int index)
+static inline struct device_node *match_of_node(int index,
+		enum maxim_device_type dev_type)
 {
-	return max14577_regulator_matches[index].of_node;
+	switch (dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		return max77836_regulator_matches[index].of_node;
+
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		return max14577_regulator_matches[index].of_node;
+	}
 }
 #else /* CONFIG_OF */
-static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
+static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
+		enum maxim_device_type dev_type)
 {
 	return 0;
 }
-static inline struct regulator_init_data *match_init_data(int index)
+static inline struct regulator_init_data *match_init_data(int index,
+		enum maxim_device_type dev_type)
 {
 	return NULL;
 }
 
-static inline struct device_node *match_of_node(int index)
+static inline struct device_node *match_of_node(int index,
+		enum maxim_device_type dev_type)
 {
 	return NULL;
 }
 #endif /* CONFIG_OF */
 
+/**
+ * Registers for regulators of max77836 use different I2C slave addresses so
+ * different regmaps must be used for them.
+ *
+ * Returns proper regmap for accessing regulator passed by id.
+ */
+static struct regmap *max14577_get_regmap(struct maxim_core *maxim_core,
+		int reg_id)
+{
+	switch (maxim_core->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		switch (reg_id) {
+		case MAX77836_SAFEOUT ... MAX77836_CHARGER:
+			return maxim_core->regmap_muic;
+		default:
+			/* MAX77836_LDO1 ... MAX77836_LDO2 */
+			return maxim_core->regmap_pmic;
+		}
+
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		return maxim_core->regmap_muic;
+	}
+}
 
 static int max14577_regulator_probe(struct platform_device *pdev)
 {
@@ -200,15 +366,29 @@ static int max14577_regulator_probe(struct platform_device *pdev)
 	struct max14577_platform_data *pdata = dev_get_platdata(maxim_core->dev);
 	int i, ret;
 	struct regulator_config config = {};
+	const struct regulator_desc *supported_regulators;
+	unsigned int supported_regulators_size;
+	enum maxim_device_type dev_type = maxim_core->dev_type;
 
-	ret = max14577_regulator_dt_parse_pdata(pdev);
+	ret = max14577_regulator_dt_parse_pdata(pdev, dev_type);
 	if (ret)
 		return ret;
 
+	switch (dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		supported_regulators = max77836_supported_regulators;
+		supported_regulators_size = ARRAY_SIZE(max77836_supported_regulators);
+		break;
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		supported_regulators = max14577_supported_regulators;
+		supported_regulators_size = ARRAY_SIZE(max14577_supported_regulators);
+	}
+
 	config.dev = &pdev->dev;
-	config.regmap = maxim_core->regmap_muic;
+	config.driver_data = maxim_core;
 
-	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
+	for (i = 0; i < supported_regulators_size; i++) {
 		struct regulator_dev *regulator;
 		/*
 		 * Index of supported_regulators[] is also the id and must
@@ -218,38 +398,63 @@ static int max14577_regulator_probe(struct platform_device *pdev)
 			config.init_data = pdata->regulators[i].initdata;
 			config.of_node = pdata->regulators[i].of_node;
 		} else {
-			config.init_data = match_init_data(i);
-			config.of_node = match_of_node(i);
+			config.init_data = match_init_data(i, dev_type);
+			config.of_node = match_of_node(i, dev_type);
 		}
+		config.regmap = max14577_get_regmap(maxim_core,
+				supported_regulators[i].id);
 
 		regulator = devm_regulator_register(&pdev->dev,
 				&supported_regulators[i], &config);
 		if (IS_ERR(regulator)) {
 			ret = PTR_ERR(regulator);
 			dev_err(&pdev->dev,
-					"Regulator init failed for ID %d with error: %d\n",
-					i, ret);
+					"Regulator init failed for %d/%s with error: %d\n",
+					i, supported_regulators[i].name, ret);
 			return ret;
 		}
+		dev_dbg(&pdev->dev, "Registered regulator %d/%s\n", i,
+				supported_regulators[i].name);
 	}
 
 	return ret;
 }
 
+static const struct platform_device_id max14577_regulator_id[] = {
+	{ "max14577-regulator", MAXIM_DEVICE_TYPE_MAX14577, },
+	{ "max77836-regulator", MAXIM_DEVICE_TYPE_MAX77836, },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max14577_regulator_id);
+
 static struct platform_driver max14577_regulator_driver = {
 	.driver = {
 		   .owner = THIS_MODULE,
 		   .name = "max14577-regulator",
 		   },
-	.probe	= max14577_regulator_probe,
+	.probe		= max14577_regulator_probe,
+	.id_table	= max14577_regulator_id,
 };
 
 static int __init max14577_regulator_init(void)
 {
+	/* Check for valid values for charger */
 	BUILD_BUG_ON(MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
 			MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
 			MAX14577_REGULATOR_CURRENT_LIMIT_MAX);
-	BUILD_BUG_ON(ARRAY_SIZE(supported_regulators) != MAX14577_REG_NUM);
+	BUILD_BUG_ON(MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START +
+			MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX77836_REGULATOR_CURRENT_LIMIT_MAX);
+	/* Valid charger current values must be provided for each chipset */
+	BUILD_BUG_ON(ARRAY_SIZE(maxim_charger_currents) != MAXIM_DEVICE_TYPE_NUM);
+
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_supported_regulators) != MAX14577_REG_NUM);
+	BUILD_BUG_ON(ARRAY_SIZE(max77836_supported_regulators) != MAX77836_REG_NUM);
+
+	BUILD_BUG_ON(MAX77836_REGULATOR_LDO_VOLTAGE_MIN +
+			(MAX77836_REGULATOR_LDO_VOLTAGE_STEP *
+			  (MAX77836_REGULATOR_LDO_VOLTAGE_STEPS_NUM - 1)) !=
+			MAX77836_REGULATOR_LDO_VOLTAGE_MAX);
 
 	return platform_driver_register(&max14577_regulator_driver);
 }
@@ -262,6 +467,6 @@ static void __exit max14577_regulator_exit(void)
 module_exit(max14577_regulator_exit);
 
 MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-MODULE_DESCRIPTION("MAXIM 14577 regulator driver");
+MODULE_DESCRIPTION("Maxim 14577/77836 regulator driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:max14577-regulator");
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index f08fb59a21a0..621e24fc45df 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -238,10 +238,20 @@ enum maxim_muic_charger_type {
 #define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 50000
 #define MAX14577_REGULATOR_CURRENT_LIMIT_MAX		950000
 
+/* MAX77836 regulator current limits (as in MAXIM_CHGCTRL4 register), uA */
+#define MAX77836_REGULATOR_CURRENT_LIMIT_MIN		 45000
+#define MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START	100000
+#define MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 25000
+#define MAX77836_REGULATOR_CURRENT_LIMIT_MAX		475000
+
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
 
-
+/* MAX77836 regulator LDOx voltage, uV */
+#define MAX77836_REGULATOR_LDO_VOLTAGE_MIN		800000
+#define MAX77836_REGULATOR_LDO_VOLTAGE_MAX		3950000
+#define MAX77836_REGULATOR_LDO_VOLTAGE_STEP		50000
+#define MAX77836_REGULATOR_LDO_VOLTAGE_STEPS_NUM	64
 
 /* Slave addr = 0x46: PMIC */
 enum max77836_pmic_reg {
@@ -277,6 +287,26 @@ enum max77836_pmic_reg {
 #define MAX77836_TOPSYS_INT_T120C_MASK		(0x1 << MAX77836_TOPSYS_INT_T120C_SHIFT)
 #define MAX77836_TOPSYS_INT_T140C_MASK		(0x1 << MAX77836_TOPSYS_INT_T140C_SHIFT)
 
+/* LDO1/LDO2 CONFIG1 register */
+#define MAX77836_CNFG1_LDO_PWRMD_SHIFT		6
+#define MAX77836_CNFG1_LDO_TV_SHIFT		0
+#define MAX77836_CNFG1_LDO_PWRMD_MASK		(0x3 << MAX77836_CNFG1_LDO_PWRMD_SHIFT)
+#define MAX77836_CNFG1_LDO_TV_MASK		(0x3f << MAX77836_CNFG1_LDO_TV_SHIFT)
+
+/* LDO1/LDO2 CONFIG2 register */
+#define MAX77836_CNFG2_LDO_OVCLMPEN_SHIFT	7
+#define MAX77836_CNFG2_LDO_ALPMEN_SHIFT		6
+#define MAX77836_CNFG2_LDO_COMP_SHIFT		4
+#define MAX77836_CNFG2_LDO_POK_SHIFT		3
+#define MAX77836_CNFG2_LDO_ADE_SHIFT		1
+#define MAX77836_CNFG2_LDO_SS_SHIFT		0
+#define MAX77836_CNFG2_LDO_OVCLMPEN_MASK	(0x1 << MAX77836_CNFG2_LDO_OVCLMPEN_SHIFT)
+#define MAX77836_CNFG2_LDO_ALPMEN_MASK		(0x1 << MAX77836_CNFG2_LDO_ALPMEN_SHIFT)
+#define MAX77836_CNFG2_LDO_COMP_MASK		(0x3 << MAX77836_CNFG2_LDO_COMP_SHIFT)
+#define MAX77836_CNFG2_LDO_POK_MASK		(0x1 << MAX77836_CNFG2_LDO_POK_SHIFT)
+#define MAX77836_CNFG2_LDO_ADE_MASK		(0x1 << MAX77836_CNFG2_LDO_ADE_SHIFT)
+#define MAX77836_CNFG2_LDO_SS_MASK		(0x1 << MAX77836_CNFG2_LDO_SS_SHIFT)
+
 /* Slave addr = 0x6C: Fuel-Gauge/Battery */
 enum max77836_fg_reg {
 	MAX77836_FG_REG_VCELL_MSB	= 0x02,
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 5e5fc77db977..178384dcfed8 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -38,6 +38,16 @@ enum max14577_regulators {
 	MAX14577_REG_NUM,
 };
 
+/* MAX77836 regulator IDs */
+enum max77836_regulators {
+	MAX77836_SAFEOUT = 0,
+	MAX77836_CHARGER,
+	MAX77836_LDO1,
+	MAX77836_LDO2,
+
+	MAX77836_REG_NUM,
+};
+
 struct max14577_regulator_platform_data {
 	int id;
 	struct regulator_init_data *initdata;
-- 
1.7.9.5

