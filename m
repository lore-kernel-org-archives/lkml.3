Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaKJNoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:44:20 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48079 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaKJNoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:44:13 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 3/5] regulator: of: Add regulator desc param to of_get_regulator_init_data()
Date: Mon, 10 Nov 2014 14:43:53 +0100
Message-Id: <1415627035-3088-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415627035-3088-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415627035-3088-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_get_regulator_init_data() function is used to extract the regulator
init_data but information on how to extract certain data is defined in the
static regulator descriptor (e.g: how to map the hardware operating modes).

Add a const struct regulator_desc * parameter to the function signature so
the parsing logic could use the information in the struct regulator_desc.

of_get_regulator_init_data() relies on of_get_regulation_constraints() to
actually extract the init_data so it has to pass the struct regulator_desc
but that is modified on a later patch.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

The of_regulator_match() function still passes NULL as regulator_desc to
of_get_regulator_init_data() since but a following patch adds a struct
regulator_desc pointer to struct of_regulator_match so callers can pass
the regulator description.

Changes in v6:
 - Always use const modifier. Suggested by Krzysztof Kozlowski.
 - Don't use the regulator descriptor before is completely initialised.
   Suggested by Mark Brown.
 - Use forward declaration instead including linux/regulator/driver.h.
   Suggested by Mark Brown.

Changes in v5:
 - Pass the descriptor struct regulator_desc to of_get_regulator_init_data()
   for all drivers even if won't be currently used. Suggested by Mark Brown.

 drivers/regulator/88pm8607.c               |  3 ++-
 drivers/regulator/anatop-regulator.c       |  5 ++--
 drivers/regulator/arizona-ldo1.c           |  8 +++---
 drivers/regulator/arizona-micsupp.c        |  8 +++---
 drivers/regulator/da9052-regulator.c       |  3 ++-
 drivers/regulator/da9210-regulator.c       |  2 +-
 drivers/regulator/fan53555.c               | 17 ++++++------
 drivers/regulator/fixed.c                  | 19 +++++++------
 drivers/regulator/gpio-regulator.c         | 18 +++++++------
 drivers/regulator/max8952.c                |  2 +-
 drivers/regulator/max8973-regulator.c      |  3 ++-
 drivers/regulator/max8997.c                |  3 ++-
 drivers/regulator/max8998.c                |  5 ++--
 drivers/regulator/mc13xxx-regulator-core.c |  3 ++-
 drivers/regulator/of_regulator.c           |  9 ++++---
 drivers/regulator/pwm-regulator.c          |  3 ++-
 drivers/regulator/qcom_rpm-regulator.c     |  9 ++++---
 drivers/regulator/s5m8767.c                |  3 ++-
 drivers/regulator/sky81452-regulator.c     |  2 +-
 drivers/regulator/stw481x-vmmc.c           |  3 ++-
 drivers/regulator/ti-abb-regulator.c       |  3 ++-
 drivers/regulator/tps51632-regulator.c     | 43 ++++++++++++++++--------------
 drivers/regulator/tps62360-regulator.c     | 31 +++++++++++----------
 drivers/regulator/tps65218-regulator.c     |  3 ++-
 drivers/regulator/twl-regulator.c          |  3 ++-
 drivers/regulator/vexpress.c               |  3 ++-
 include/linux/regulator/of_regulator.h     |  8 ++++--
 27 files changed, 130 insertions(+), 92 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 6d77dcd..3fe47bd 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -330,7 +330,8 @@ static int pm8607_regulator_dt_init(struct platform_device *pdev,
 	for_each_child_of_node(nproot, np) {
 		if (!of_node_cmp(np->name, info->desc.name)) {
 			config->init_data =
-				of_get_regulator_init_data(&pdev->dev, np);
+				of_get_regulator_init_data(&pdev->dev, np,
+							   &info->desc);
 			config->of_node = np;
 			break;
 		}
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 542d14e..3586571 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -189,17 +189,18 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 val;
 
-	initdata = of_get_regulator_init_data(dev, np);
 	sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
 	if (!sreg)
 		return -ENOMEM;
-	sreg->initdata = initdata;
 	sreg->name = of_get_property(np, "regulator-name", NULL);
 	rdesc = &sreg->rdesc;
 	rdesc->name = sreg->name;
 	rdesc->type = REGULATOR_VOLTAGE;
 	rdesc->owner = THIS_MODULE;
 
+	initdata = of_get_regulator_init_data(dev, np, rdesc);
+	sreg->initdata = initdata;
+
 	anatop_np = of_get_parent(np);
 	if (!anatop_np)
 		return -ENODEV;
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4c9db58..b1eea7f 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -179,7 +179,8 @@ static const struct regulator_init_data arizona_ldo1_default = {
 };
 
 static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
-				     struct regulator_config *config)
+				     struct regulator_config *config,
+				     const struct regulator_desc *desc)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
 	struct arizona_ldo1 *ldo1 = config->driver_data;
@@ -194,7 +195,8 @@ static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
 	if (init_node) {
 		config->of_node = init_node;
 
-		init_data = of_get_regulator_init_data(arizona->dev, init_node);
+		init_data = of_get_regulator_init_data(arizona->dev, init_node,
+						       desc);
 
 		if (init_data) {
 			init_data->consumer_supplies = &ldo1->supply;
@@ -257,7 +259,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 
 	if (IS_ENABLED(CONFIG_OF)) {
 		if (!dev_get_platdata(arizona->dev)) {
-			ret = arizona_ldo1_of_get_pdata(arizona, &config);
+			ret = arizona_ldo1_of_get_pdata(arizona, &config, desc);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index ce9aca5..c313ef4 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -198,7 +198,8 @@ static const struct regulator_init_data arizona_micsupp_ext_default = {
 };
 
 static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
-					struct regulator_config *config)
+					struct regulator_config *config,
+					const struct regulator_desc *desc)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
 	struct arizona_micsupp *micsupp = config->driver_data;
@@ -210,7 +211,7 @@ static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
 	if (np) {
 		config->of_node = np;
 
-		init_data = of_get_regulator_init_data(arizona->dev, np);
+		init_data = of_get_regulator_init_data(arizona->dev, np, desc);
 
 		if (init_data) {
 			init_data->consumer_supplies = &micsupp->supply;
@@ -264,7 +265,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 
 	if (IS_ENABLED(CONFIG_OF)) {
 		if (!dev_get_platdata(arizona->dev)) {
-			ret = arizona_micsupp_of_get_pdata(arizona, &config);
+			ret = arizona_micsupp_of_get_pdata(arizona, &config,
+							   desc);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 0003362..3945f10 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -436,7 +436,8 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 			if (!of_node_cmp(np->name,
 					 regulator->info->reg_desc.name)) {
 				config.init_data = of_get_regulator_init_data(
-					&pdev->dev, np);
+					&pdev->dev, np,
+					&regulator->info->reg_desc);
 				config.of_node = np;
 				break;
 			}
diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index 7a320dd..bc61001 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -147,7 +147,7 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 
 	config.dev = &i2c->dev;
 	config.init_data = pdata ? &pdata->da9210_constraints :
-		of_get_regulator_init_data(dev, dev->of_node);
+		of_get_regulator_init_data(dev, dev->of_node, &da9210_reg);
 	config.driver_data = chip;
 	config.regmap = chip->regmap;
 	config.of_node = dev->of_node;
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index f8e4257..6c43ab2 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -302,7 +302,8 @@ static struct regmap_config fan53555_regmap_config = {
 };
 
 static struct fan53555_platform_data *fan53555_parse_dt(struct device *dev,
-							struct device_node *np)
+					      struct device_node *np,
+					      const struct regulator_desc *desc)
 {
 	struct fan53555_platform_data *pdata;
 	int ret;
@@ -312,7 +313,7 @@ static struct fan53555_platform_data *fan53555_parse_dt(struct device *dev,
 	if (!pdata)
 		return NULL;
 
-	pdata->regulator = of_get_regulator_init_data(dev, np);
+	pdata->regulator = of_get_regulator_init_data(dev, np, desc);
 
 	ret = of_property_read_u32(np, "fcs,suspend-voltage-selector",
 				   &tmp);
@@ -347,20 +348,20 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 	unsigned int val;
 	int ret;
 
+	di = devm_kzalloc(&client->dev, sizeof(struct fan53555_device_info),
+					GFP_KERNEL);
+	if (!di)
+		return -ENOMEM;
+
 	pdata = dev_get_platdata(&client->dev);
 	if (!pdata)
-		pdata = fan53555_parse_dt(&client->dev, np);
+		pdata = fan53555_parse_dt(&client->dev, np, &di->desc);
 
 	if (!pdata || !pdata->regulator) {
 		dev_err(&client->dev, "Platform data not found!\n");
 		return -ENODEV;
 	}
 
-	di = devm_kzalloc(&client->dev, sizeof(struct fan53555_device_info),
-					GFP_KERNEL);
-	if (!di)
-		return -ENOMEM;
-
 	di->regulator = pdata->regulator;
 	if (client->dev.of_node) {
 		const struct of_device_id *match;
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 354105e..6cfcbc8 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -40,13 +40,15 @@ struct fixed_voltage_data {
 /**
  * of_get_fixed_voltage_config - extract fixed_voltage_config structure info
  * @dev: device requesting for fixed_voltage_config
+ * @desc: regulator description
  *
  * Populates fixed_voltage_config structure by extracting data from device
  * tree node, returns a pointer to the populated structure of NULL if memory
  * alloc fails.
  */
 static struct fixed_voltage_config *
-of_get_fixed_voltage_config(struct device *dev)
+of_get_fixed_voltage_config(struct device *dev,
+			    const struct regulator_desc *desc)
 {
 	struct fixed_voltage_config *config;
 	struct device_node *np = dev->of_node;
@@ -57,7 +59,7 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (!config)
 		return ERR_PTR(-ENOMEM);
 
-	config->init_data = of_get_regulator_init_data(dev, dev->of_node);
+	config->init_data = of_get_regulator_init_data(dev, dev->of_node, desc);
 	if (!config->init_data)
 		return ERR_PTR(-EINVAL);
 
@@ -112,8 +114,14 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	struct regulator_config cfg = { };
 	int ret;
 
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
+			       GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
 	if (pdev->dev.of_node) {
-		config = of_get_fixed_voltage_config(&pdev->dev);
+		config = of_get_fixed_voltage_config(&pdev->dev,
+						     &drvdata->desc);
 		if (IS_ERR(config))
 			return PTR_ERR(config);
 	} else {
@@ -123,11 +131,6 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	if (!config)
 		return -ENOMEM;
 
-	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
-			       GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
 	drvdata->desc.name = devm_kstrdup(&pdev->dev,
 					  config->supply_name,
 					  GFP_KERNEL);
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 989b23b..5c3bcae 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -133,7 +133,8 @@ static struct regulator_ops gpio_regulator_voltage_ops = {
 };
 
 static struct gpio_regulator_config *
-of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
+of_get_gpio_regulator_config(struct device *dev, struct device_node *np,
+			     const struct regulator_desc *desc)
 {
 	struct gpio_regulator_config *config;
 	const char *regtype;
@@ -146,7 +147,7 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	if (!config)
 		return ERR_PTR(-ENOMEM);
 
-	config->init_data = of_get_regulator_init_data(dev, np);
+	config->init_data = of_get_regulator_init_data(dev, np, desc);
 	if (!config->init_data)
 		return ERR_PTR(-EINVAL);
 
@@ -243,17 +244,18 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 	struct regulator_config cfg = { };
 	int ptr, ret, state;
 
-	if (np) {
-		config = of_get_gpio_regulator_config(&pdev->dev, np);
-		if (IS_ERR(config))
-			return PTR_ERR(config);
-	}
-
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
 			       GFP_KERNEL);
 	if (drvdata == NULL)
 		return -ENOMEM;
 
+	if (np) {
+		config = of_get_gpio_regulator_config(&pdev->dev, np,
+						      &drvdata->desc);
+		if (IS_ERR(config))
+			return PTR_ERR(config);
+	}
+
 	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
 	if (drvdata->desc.name == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate supply name\n");
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index f7f9efc..6e54d78 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -174,7 +174,7 @@ static struct max8952_platform_data *max8952_parse_dt(struct device *dev)
 	if (of_property_read_u32(np, "max8952,ramp-speed", &pd->ramp_speed))
 		dev_warn(dev, "max8952,ramp-speed property not specified, defaulting to 32mV/us\n");
 
-	pd->reg_data = of_get_regulator_init_data(dev, np);
+	pd->reg_data = of_get_regulator_init_data(dev, np, &regulator);
 	if (!pd->reg_data) {
 		dev_err(dev, "Failed to parse regulator init data\n");
 		return NULL;
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index dbedf17..c3d55c2 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -458,7 +458,8 @@ static int max8973_probe(struct i2c_client *client,
 
 	config.dev = &client->dev;
 	config.init_data = pdata ? pdata->reg_init_data :
-		of_get_regulator_init_data(&client->dev, client->dev.of_node);
+		of_get_regulator_init_data(&client->dev, client->dev.of_node,
+					   &max->desc);
 	config.driver_data = max;
 	config.of_node = client->dev.of_node;
 	config.regmap = max->regmap;
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 9c31e21..726fde1 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -953,7 +953,8 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(&pdev->dev,
-							     reg_np);
+							     reg_np,
+							     &regulators[i]);
 		rdata->reg_node = reg_np;
 		rdata++;
 	}
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 961091b..59e34a0 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -686,8 +686,9 @@ static int max8998_pmic_dt_parse_pdata(struct max8998_dev *iodev,
 			continue;
 
 		rdata->id = regulators[i].id;
-		rdata->initdata = of_get_regulator_init_data(
-							iodev->dev, reg_np);
+		rdata->initdata = of_get_regulator_init_data(iodev->dev,
+							     reg_np,
+							     &regulators[i]);
 		rdata->reg_node = reg_np;
 		++rdata;
 	}
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index afba024..0281c31 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -194,7 +194,8 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 					 regulators[i].desc.name)) {
 				p->id = i;
 				p->init_data = of_get_regulator_init_data(
-							&pdev->dev, child);
+							&pdev->dev, child,
+							&regulators[i].desc);
 				p->node = child;
 				p++;
 
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 03edb17..945486f 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -120,13 +120,16 @@ static void of_get_regulation_constraints(struct device_node *np,
 /**
  * of_get_regulator_init_data - extract regulator_init_data structure info
  * @dev: device requesting for regulator_init_data
+ * @node: regulator device node
+ * @desc: regulator description
  *
  * Populates regulator_init_data structure by extracting data from device
  * tree node, returns a pointer to the populated struture or NULL if memory
  * alloc fails.
  */
 struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
-						struct device_node *node)
+					  struct device_node *node,
+					  const struct regulator_desc *desc)
 {
 	struct regulator_init_data *init_data;
 
@@ -218,7 +221,7 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 				continue;
 
 			match->init_data =
-				of_get_regulator_init_data(dev, child);
+				of_get_regulator_init_data(dev, child, NULL);
 			if (!match->init_data) {
 				dev_err(dev,
 					"failed to parse DT for regulator %s\n",
@@ -266,7 +269,7 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 		if (strcmp(desc->of_match, name))
 			continue;
 
-		init_data = of_get_regulator_init_data(dev, child);
+		init_data = of_get_regulator_init_data(dev, child, desc);
 		if (!init_data) {
 			dev_err(dev,
 				"failed to parse DT for regulator %s\n",
diff --git a/drivers/regulator/pwm-regulator.c b/drivers/regulator/pwm-regulator.c
index d3f55ea..91f34ca 100644
--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -149,7 +149,8 @@ static int pwm_regulator_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	config.init_data = of_get_regulator_init_data(&pdev->dev, np);
+	config.init_data = of_get_regulator_init_data(&pdev->dev, np,
+						      &drvdata->desc);
 	if (!config.init_data)
 		return -ENOMEM;
 
diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index b55cd5b..dabd28a 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -643,10 +643,6 @@ static int rpm_reg_probe(struct platform_device *pdev)
 	match = of_match_device(rpm_of_match, &pdev->dev);
 	template = match->data;
 
-	initdata = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
-	if (!initdata)
-		return -EINVAL;
-
 	vreg = devm_kmalloc(&pdev->dev, sizeof(*vreg), GFP_KERNEL);
 	if (!vreg) {
 		dev_err(&pdev->dev, "failed to allocate vreg\n");
@@ -666,6 +662,11 @@ static int rpm_reg_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	initdata = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node,
+					      &vreg->desc);
+	if (!initdata)
+		return -EINVAL;
+
 	key = "reg";
 	ret = of_property_read_u32(pdev->dev.of_node, key, &val);
 	if (ret) {
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 0ab5cbe..26932fe 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -581,7 +581,8 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
-						&pdev->dev, reg_np);
+						&pdev->dev, reg_np,
+						&regulators[i]);
 		rdata->reg_node = reg_np;
 		rdata++;
 		rmode->id = i;
diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
index 476b80a..e68e13f 100644
--- a/drivers/regulator/sky81452-regulator.c
+++ b/drivers/regulator/sky81452-regulator.c
@@ -76,7 +76,7 @@ static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
 		return NULL;
 	}
 
-	init_data = of_get_regulator_init_data(dev, np);
+	init_data = of_get_regulator_init_data(dev, np, &sky81452_reg);
 
 	of_node_put(np);
 	return init_data;
diff --git a/drivers/regulator/stw481x-vmmc.c b/drivers/regulator/stw481x-vmmc.c
index a7e1526..b4f1696 100644
--- a/drivers/regulator/stw481x-vmmc.c
+++ b/drivers/regulator/stw481x-vmmc.c
@@ -72,7 +72,8 @@ static int stw481x_vmmc_regulator_probe(struct platform_device *pdev)
 	config.regmap = stw481x->map;
 	config.of_node = pdev->dev.of_node;
 	config.init_data = of_get_regulator_init_data(&pdev->dev,
-						      pdev->dev.of_node);
+						      pdev->dev.of_node,
+						      &vmmc_regulator);
 
 	stw481x->vmmc_regulator = devm_regulator_register(&pdev->dev,
 						&vmmc_regulator, &config);
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index a2dabb5..1ef5aba 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -837,7 +837,8 @@ skip_opt:
 		return -EINVAL;
 	}
 
-	initdata = of_get_regulator_init_data(dev, pdev->dev.of_node);
+	initdata = of_get_regulator_init_data(dev, pdev->dev.of_node,
+					      &abb->rdesc);
 	if (!initdata) {
 		dev_err(dev, "%s: Unable to alloc regulator init data\n",
 			__func__);
diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index f31f22e..c213e37 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -221,7 +221,8 @@ static const struct of_device_id tps51632_of_match[] = {
 MODULE_DEVICE_TABLE(of, tps51632_of_match);
 
 static struct tps51632_regulator_platform_data *
-	of_get_tps51632_platform_data(struct device *dev)
+	of_get_tps51632_platform_data(struct device *dev,
+				      const struct regulator_desc *desc)
 {
 	struct tps51632_regulator_platform_data *pdata;
 	struct device_node *np = dev->of_node;
@@ -230,7 +231,8 @@ static struct tps51632_regulator_platform_data *
 	if (!pdata)
 		return NULL;
 
-	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
+	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node,
+							  desc);
 	if (!pdata->reg_init_data) {
 		dev_err(dev, "Not able to get OF regulator init data\n");
 		return NULL;
@@ -248,7 +250,8 @@ static struct tps51632_regulator_platform_data *
 }
 #else
 static struct tps51632_regulator_platform_data *
-	of_get_tps51632_platform_data(struct device *dev)
+	of_get_tps51632_platform_data(struct device *dev,
+				      const struct regulator_desc *desc)
 {
 	return NULL;
 }
@@ -273,9 +276,25 @@ static int tps51632_probe(struct i2c_client *client,
 		}
 	}
 
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
+	if (!tps)
+		return -ENOMEM;
+
+	tps->dev = &client->dev;
+	tps->desc.name = client->name;
+	tps->desc.id = 0;
+	tps->desc.ramp_delay = TPS51632_DEFAULT_RAMP_DELAY;
+	tps->desc.min_uV = TPS51632_MIN_VOLTAGE;
+	tps->desc.uV_step = TPS51632_VOLTAGE_STEP_10mV;
+	tps->desc.linear_min_sel = TPS51632_MIN_VSEL;
+	tps->desc.n_voltages = TPS51632_MAX_VSEL + 1;
+	tps->desc.ops = &tps51632_dcdc_ops;
+	tps->desc.type = REGULATOR_VOLTAGE;
+	tps->desc.owner = THIS_MODULE;
+
 	pdata = dev_get_platdata(&client->dev);
 	if (!pdata && client->dev.of_node)
-		pdata = of_get_tps51632_platform_data(&client->dev);
+		pdata = of_get_tps51632_platform_data(&client->dev, &tps->desc);
 	if (!pdata) {
 		dev_err(&client->dev, "No Platform data\n");
 		return -EINVAL;
@@ -296,22 +315,6 @@ static int tps51632_probe(struct i2c_client *client,
 		}
 	}
 
-	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
-	if (!tps)
-		return -ENOMEM;
-
-	tps->dev = &client->dev;
-	tps->desc.name = client->name;
-	tps->desc.id = 0;
-	tps->desc.ramp_delay = TPS51632_DEFAULT_RAMP_DELAY;
-	tps->desc.min_uV = TPS51632_MIN_VOLTAGE;
-	tps->desc.uV_step = TPS51632_VOLTAGE_STEP_10mV;
-	tps->desc.linear_min_sel = TPS51632_MIN_VSEL;
-	tps->desc.n_voltages = TPS51632_MAX_VSEL + 1;
-	tps->desc.ops = &tps51632_dcdc_ops;
-	tps->desc.type = REGULATOR_VOLTAGE;
-	tps->desc.owner = THIS_MODULE;
-
 	if (pdata->enable_pwm_dvfs)
 		tps->desc.vsel_reg = TPS51632_VOLTAGE_BASE_REG;
 	else
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index a167204..a1fd626 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -293,7 +293,8 @@ static const struct regmap_config tps62360_regmap_config = {
 };
 
 static struct tps62360_regulator_platform_data *
-	of_get_tps62360_platform_data(struct device *dev)
+	of_get_tps62360_platform_data(struct device *dev,
+				      const struct regulator_desc *desc)
 {
 	struct tps62360_regulator_platform_data *pdata;
 	struct device_node *np = dev->of_node;
@@ -302,7 +303,8 @@ static struct tps62360_regulator_platform_data *
 	if (!pdata)
 		return NULL;
 
-	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
+	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node,
+							  desc);
 	if (!pdata->reg_init_data) {
 		dev_err(dev, "Not able to get OF regulator init data\n");
 		return NULL;
@@ -350,6 +352,17 @@ static int tps62360_probe(struct i2c_client *client,
 
 	pdata = dev_get_platdata(&client->dev);
 
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
+	if (!tps)
+		return -ENOMEM;
+
+	tps->desc.name = client->name;
+	tps->desc.id = 0;
+	tps->desc.ops = &tps62360_dcdc_ops;
+	tps->desc.type = REGULATOR_VOLTAGE;
+	tps->desc.owner = THIS_MODULE;
+	tps->desc.uV_step = 10000;
+
 	if (client->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_device(of_match_ptr(tps62360_of_match),
@@ -360,7 +373,8 @@ static int tps62360_probe(struct i2c_client *client,
 		}
 		chip_id = (int)(long)match->data;
 		if (!pdata)
-			pdata = of_get_tps62360_platform_data(&client->dev);
+			pdata = of_get_tps62360_platform_data(&client->dev,
+							      &tps->desc);
 	} else if (id) {
 		chip_id = id->driver_data;
 	} else {
@@ -374,10 +388,6 @@ static int tps62360_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
-	if (!tps)
-		return -ENOMEM;
-
 	tps->en_discharge = pdata->en_discharge;
 	tps->en_internal_pulldn = pdata->en_internal_pulldn;
 	tps->vsel0_gpio = pdata->vsel0_gpio;
@@ -401,13 +411,6 @@ static int tps62360_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	tps->desc.name = client->name;
-	tps->desc.id = 0;
-	tps->desc.ops = &tps62360_dcdc_ops;
-	tps->desc.type = REGULATOR_VOLTAGE;
-	tps->desc.owner = THIS_MODULE;
-	tps->desc.uV_step = 10000;
-
 	tps->regmap = devm_regmap_init_i2c(client, &tps62360_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		ret = PTR_ERR(tps->regmap);
diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index f0a4028..263cc85 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -231,7 +231,8 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
 
 	template = match->data;
 	id = template->id;
-	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
+	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node,
+					       &regulators[id]);
 
 	platform_set_drvdata(pdev, tps);
 
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 0b4f866..dd727bc 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1104,7 +1104,8 @@ static int twlreg_probe(struct platform_device *pdev)
 		template = match->data;
 		id = template->desc.id;
 		initdata = of_get_regulator_init_data(&pdev->dev,
-						      pdev->dev.of_node);
+						      pdev->dev.of_node,
+						      &template->desc);
 		drvdata = NULL;
 	} else {
 		id = pdev->id;
diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index 02e7267..5e7c789 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -74,7 +74,8 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	reg->desc.owner = THIS_MODULE;
 	reg->desc.continuous_voltage_range = true;
 
-	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
+	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node,
+					       &reg->desc);
 	if (!init_data)
 		return -EINVAL;
 
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index f921796..8d1d136 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -6,6 +6,8 @@
 #ifndef __LINUX_OF_REG_H
 #define __LINUX_OF_REG_H
 
+struct regulator_desc;
+
 struct of_regulator_match {
 	const char *name;
 	void *driver_data;
@@ -16,14 +18,16 @@ struct of_regulator_match {
 #if defined(CONFIG_OF)
 extern struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
-				    struct device_node *node);
+				    struct device_node *node,
+				    const struct regulator_desc *desc);
 extern int of_regulator_match(struct device *dev, struct device_node *node,
 			      struct of_regulator_match *matches,
 			      unsigned int num_matches);
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
-				    struct device_node *node)
+				    struct device_node *node,
+				    const struct regulator_desc *desc)
 {
 	return NULL;
 }
-- 
2.1.0

