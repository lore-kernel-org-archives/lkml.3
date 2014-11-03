Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaKCOma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:42:30 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38836 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKCOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:23 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 03/14] regulator: of: Add regulator desc param to of_get_regulator_init_data()
Date: Mon,  3 Nov 2014 15:40:38 +0100
Message-Id: <1415025649-8119-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
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
but that is changed in a following patch.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/88pm8607.c               | 3 ++-
 drivers/regulator/anatop-regulator.c       | 2 +-
 drivers/regulator/arizona-ldo1.c           | 3 ++-
 drivers/regulator/arizona-micsupp.c        | 2 +-
 drivers/regulator/da9052-regulator.c       | 2 +-
 drivers/regulator/da9210-regulator.c       | 2 +-
 drivers/regulator/fan53555.c               | 2 +-
 drivers/regulator/fixed.c                  | 2 +-
 drivers/regulator/gpio-regulator.c         | 2 +-
 drivers/regulator/max8952.c                | 2 +-
 drivers/regulator/max8973-regulator.c      | 3 ++-
 drivers/regulator/max8997.c                | 2 +-
 drivers/regulator/max8998.c                | 4 ++--
 drivers/regulator/mc13xxx-regulator-core.c | 3 ++-
 drivers/regulator/of_regulator.c           | 9 ++++++---
 drivers/regulator/pwm-regulator.c          | 2 +-
 drivers/regulator/qcom_rpm-regulator.c     | 3 ++-
 drivers/regulator/s5m8767.c                | 2 +-
 drivers/regulator/sky81452-regulator.c     | 2 +-
 drivers/regulator/stw481x-vmmc.c           | 2 +-
 drivers/regulator/ti-abb-regulator.c       | 2 +-
 drivers/regulator/tps51632-regulator.c     | 3 ++-
 drivers/regulator/tps62360-regulator.c     | 3 ++-
 drivers/regulator/tps65218-regulator.c     | 3 ++-
 drivers/regulator/twl-regulator.c          | 2 +-
 drivers/regulator/vexpress.c               | 3 ++-
 include/linux/regulator/of_regulator.h     | 8 ++++++--
 27 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 6d77dcd..ce0343a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -330,7 +330,8 @@ static int pm8607_regulator_dt_init(struct platform_device *pdev,
 	for_each_child_of_node(nproot, np) {
 		if (!of_node_cmp(np->name, info->desc.name)) {
 			config->init_data =
-				of_get_regulator_init_data(&pdev->dev, np);
+				of_get_regulator_init_data(&pdev->dev, np,
+							   NULL);
 			config->of_node = np;
 			break;
 		}
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 542d14e..5cdce49 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -189,7 +189,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 val;
 
-	initdata = of_get_regulator_init_data(dev, np);
+	initdata = of_get_regulator_init_data(dev, np, NULL);
 	sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
 	if (!sreg)
 		return -ENOMEM;
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4c9db58..fb393c5 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -194,7 +194,8 @@ static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
 	if (init_node) {
 		config->of_node = init_node;
 
-		init_data = of_get_regulator_init_data(arizona->dev, init_node);
+		init_data = of_get_regulator_init_data(arizona->dev, init_node,
+						       NULL);
 
 		if (init_data) {
 			init_data->consumer_supplies = &ldo1->supply;
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index ce9aca5..71290bf 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -210,7 +210,7 @@ static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
 	if (np) {
 		config->of_node = np;
 
-		init_data = of_get_regulator_init_data(arizona->dev, np);
+		init_data = of_get_regulator_init_data(arizona->dev, np, NULL);
 
 		if (init_data) {
 			init_data->consumer_supplies = &micsupp->supply;
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 0003362..178343c 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -436,7 +436,7 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 			if (!of_node_cmp(np->name,
 					 regulator->info->reg_desc.name)) {
 				config.init_data = of_get_regulator_init_data(
-					&pdev->dev, np);
+					&pdev->dev, np, NULL);
 				config.of_node = np;
 				break;
 			}
diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index 7a320dd..aa9cab0 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -147,7 +147,7 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 
 	config.dev = &i2c->dev;
 	config.init_data = pdata ? &pdata->da9210_constraints :
-		of_get_regulator_init_data(dev, dev->of_node);
+		of_get_regulator_init_data(dev, dev->of_node, NULL);
 	config.driver_data = chip;
 	config.regmap = chip->regmap;
 	config.of_node = dev->of_node;
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index f8e4257..eb09c15 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -312,7 +312,7 @@ static struct fan53555_platform_data *fan53555_parse_dt(struct device *dev,
 	if (!pdata)
 		return NULL;
 
-	pdata->regulator = of_get_regulator_init_data(dev, np);
+	pdata->regulator = of_get_regulator_init_data(dev, np, NULL);
 
 	ret = of_property_read_u32(np, "fcs,suspend-voltage-selector",
 				   &tmp);
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 354105e..f8d4fe1 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -57,7 +57,7 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (!config)
 		return ERR_PTR(-ENOMEM);
 
-	config->init_data = of_get_regulator_init_data(dev, dev->of_node);
+	config->init_data = of_get_regulator_init_data(dev, dev->of_node, NULL);
 	if (!config->init_data)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 989b23b..a190ef4 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -146,7 +146,7 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	if (!config)
 		return ERR_PTR(-ENOMEM);
 
-	config->init_data = of_get_regulator_init_data(dev, np);
+	config->init_data = of_get_regulator_init_data(dev, np, NULL);
 	if (!config->init_data)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index f7f9efc..ff4ba10 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -174,7 +174,7 @@ static struct max8952_platform_data *max8952_parse_dt(struct device *dev)
 	if (of_property_read_u32(np, "max8952,ramp-speed", &pd->ramp_speed))
 		dev_warn(dev, "max8952,ramp-speed property not specified, defaulting to 32mV/us\n");
 
-	pd->reg_data = of_get_regulator_init_data(dev, np);
+	pd->reg_data = of_get_regulator_init_data(dev, np, NULL);
 	if (!pd->reg_data) {
 		dev_err(dev, "Failed to parse regulator init data\n");
 		return NULL;
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index dbedf17..eb07d04 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -458,7 +458,8 @@ static int max8973_probe(struct i2c_client *client,
 
 	config.dev = &client->dev;
 	config.init_data = pdata ? pdata->reg_init_data :
-		of_get_regulator_init_data(&client->dev, client->dev.of_node);
+		of_get_regulator_init_data(&client->dev, client->dev.of_node,
+					   NULL);
 	config.driver_data = max;
 	config.of_node = client->dev.of_node;
 	config.regmap = max->regmap;
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 9c31e21..b91526a 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -953,7 +953,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(&pdev->dev,
-							     reg_np);
+							     reg_np, NULL);
 		rdata->reg_node = reg_np;
 		rdata++;
 	}
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 961091b..5608136 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -686,8 +686,8 @@ static int max8998_pmic_dt_parse_pdata(struct max8998_dev *iodev,
 			continue;
 
 		rdata->id = regulators[i].id;
-		rdata->initdata = of_get_regulator_init_data(
-							iodev->dev, reg_np);
+		rdata->initdata = of_get_regulator_init_data(iodev->dev,
+							     reg_np, NULL);
 		rdata->reg_node = reg_np;
 		++rdata;
 	}
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index afba024..838be1d 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -194,7 +194,8 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 					 regulators[i].desc.name)) {
 				p->id = i;
 				p->init_data = of_get_regulator_init_data(
-							&pdev->dev, child);
+							&pdev->dev, child,
+							NULL);
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
index d3f55ea..dc4c678 100644
--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -149,7 +149,7 @@ static int pwm_regulator_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	config.init_data = of_get_regulator_init_data(&pdev->dev, np);
+	config.init_data = of_get_regulator_init_data(&pdev->dev, np, NULL);
 	if (!config.init_data)
 		return -ENOMEM;
 
diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index b55cd5b..f1b7f27 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -643,7 +643,8 @@ static int rpm_reg_probe(struct platform_device *pdev)
 	match = of_match_device(rpm_of_match, &pdev->dev);
 	template = match->data;
 
-	initdata = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
+	initdata = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node,
+					      NULL);
 	if (!initdata)
 		return -EINVAL;
 
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 0ab5cbe..6984e6b 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -581,7 +581,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
-						&pdev->dev, reg_np);
+						&pdev->dev, reg_np, NULL);
 		rdata->reg_node = reg_np;
 		rdata++;
 		rmode->id = i;
diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
index 476b80a..6b3d3bf 100644
--- a/drivers/regulator/sky81452-regulator.c
+++ b/drivers/regulator/sky81452-regulator.c
@@ -76,7 +76,7 @@ static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
 		return NULL;
 	}
 
-	init_data = of_get_regulator_init_data(dev, np);
+	init_data = of_get_regulator_init_data(dev, np, NULL);
 
 	of_node_put(np);
 	return init_data;
diff --git a/drivers/regulator/stw481x-vmmc.c b/drivers/regulator/stw481x-vmmc.c
index a7e1526..51ff1869 100644
--- a/drivers/regulator/stw481x-vmmc.c
+++ b/drivers/regulator/stw481x-vmmc.c
@@ -72,7 +72,7 @@ static int stw481x_vmmc_regulator_probe(struct platform_device *pdev)
 	config.regmap = stw481x->map;
 	config.of_node = pdev->dev.of_node;
 	config.init_data = of_get_regulator_init_data(&pdev->dev,
-						      pdev->dev.of_node);
+						      pdev->dev.of_node, NULL);
 
 	stw481x->vmmc_regulator = devm_regulator_register(&pdev->dev,
 						&vmmc_regulator, &config);
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index a2dabb5..04f2421 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -837,7 +837,7 @@ skip_opt:
 		return -EINVAL;
 	}
 
-	initdata = of_get_regulator_init_data(dev, pdev->dev.of_node);
+	initdata = of_get_regulator_init_data(dev, pdev->dev.of_node, NULL);
 	if (!initdata) {
 		dev_err(dev, "%s: Unable to alloc regulator init data\n",
 			__func__);
diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index f31f22e..65f63c4 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -230,7 +230,8 @@ static struct tps51632_regulator_platform_data *
 	if (!pdata)
 		return NULL;
 
-	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
+	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node,
+							  NULL);
 	if (!pdata->reg_init_data) {
 		dev_err(dev, "Not able to get OF regulator init data\n");
 		return NULL;
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index a167204..45c6b4c 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -302,7 +302,8 @@ static struct tps62360_regulator_platform_data *
 	if (!pdata)
 		return NULL;
 
-	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
+	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node,
+							  NULL);
 	if (!pdata->reg_init_data) {
 		dev_err(dev, "Not able to get OF regulator init data\n");
 		return NULL;
diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index f0a4028..f3f56ea 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -231,7 +231,8 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
 
 	template = match->data;
 	id = template->id;
-	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
+	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node,
+					       NULL);
 
 	platform_set_drvdata(pdev, tps);
 
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 0b4f866..5d4fcb8 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1104,7 +1104,7 @@ static int twlreg_probe(struct platform_device *pdev)
 		template = match->data;
 		id = template->desc.id;
 		initdata = of_get_regulator_init_data(&pdev->dev,
-						      pdev->dev.of_node);
+						      pdev->dev.of_node, NULL);
 		drvdata = NULL;
 	} else {
 		id = pdev->id;
diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index 02e7267..b88e0ca 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -74,7 +74,8 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	reg->desc.owner = THIS_MODULE;
 	reg->desc.continuous_voltage_range = true;
 
-	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
+	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node,
+					       NULL);
 	if (!init_data)
 		return -EINVAL;
 
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index f921796..3bbfb1b 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -6,6 +6,8 @@
 #ifndef __LINUX_OF_REG_H
 #define __LINUX_OF_REG_H
 
+#include <linux/regulator/driver.h>
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

