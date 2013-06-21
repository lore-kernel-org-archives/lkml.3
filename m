Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161391Ab3FUGad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:30:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335Ab3FUGab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:30:31 -0400
Date: Fri, 21 Jun 2013 08:30:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 2/2] regulators: max8973: initial DT support
In-Reply-To: <Pine.LNX.4.64.1306210825040.27277@axis700.grange>
Message-ID: <Pine.LNX.4.64.1306210827090.27277@axis700.grange>
References: <Pine.LNX.4.64.1306210825040.27277@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:eLijty8gr2PoDmi129pllcG1CZrkh6V95yBpu8IeU8K
 wL82dpGEDpvuuH3PeCkgDQiIvGdjQOFRBVM8Q8WUFsS3y6oajV
 lYYgEEA0x8/fA8hGVeQa6uN1pMsI0qxlv6aJHUlEaT1ujrFtXA
 P8bSqjlhk5PwlgNb4AwV4pHWJ5LodcGy4rwR7mDTTdfp+Hphr0
 i50F1YtB7UHzwYxJ6L4sIus1rVZfMW+ccCCB89uvu1IA+tjD7V
 zZyAkaXN5vaiGOUr3ckiMcwNNn2ILS+DieCbiwgMUpNacMur35
 lsGIKAiqySvMiwP42skkjN8WyKtubGJPuITzD4shbQZ6y+m/hz
 pRl8C+O6Ua+cWBKoHrI75jCOnCY41hCMPHcOBFUoL4DKqbAX+a
 QAmXsBnVW0TZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds primitive DT support to the max8973 regulator driver. None
of the configuration parameters, supported in the platform data are yet
available in DT, therefore no configuration is performed if booting with
no platform data. This means, that DT instantiation can only be used on
boards, where no run-time configuration of the chip is required. In such
cases the driver can be used to scale its output voltage. In the future
support for configuration parameters should be added.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 .../bindings/regulator/max8973-regulator.txt       |   25 +++++++
 drivers/regulator/max8973-regulator.c              |   73 ++++++++++++++++----
 2 files changed, 85 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8973-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/max8973-regulator.txt b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
new file mode 100644
index 0000000..c1629f3
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
@@ -0,0 +1,25 @@
+* Maxim MAX8973 Voltage Regulator
+
+Required properties:
+
+- compatible:	must be "maxium,max8973"
+- reg:		the i2c slave address of the regulator. It should be 0x1b.
+- regulators:	a subnode with a single regulator descriptor in it called "dcdc"
+
+The single dcdc regulator can use any standard regulator properties.
+
+Example:
+
+	max8973@1b {
+		compatible = "maxium,max8973";
+		reg = <0x1b>;
+
+		regulators {
+			vdd_dvfs: dcdc {
+				regulator-min-microvolt = <935000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+	};
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index b2dbdd7..ecfdea7 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -26,10 +26,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/max8973-regulator.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -353,6 +355,10 @@ static int max8973_init_dcdc(struct max8973_chip *max,
 	return ret;
 }
 
+static struct of_regulator_match max8973_regulator_match = {
+	.name = "dcdc",
+};
+
 static const struct regmap_config max8973_regmap_config = {
 	.reg_bits		= 8,
 	.val_bits		= 8,
@@ -360,6 +366,32 @@ static const struct regmap_config max8973_regmap_config = {
 	.cache_type		= REGCACHE_RBTREE,
 };
 
+static int max8973_regulator_parse_dt(struct device *dev)
+{
+	struct device_node *regulators =
+		of_find_node_by_name(dev->of_node, "regulators");
+	int ret;
+
+	if (!regulators) {
+		dev_err(dev, "regulator node not found\n");
+		return -ENODEV;
+	}
+
+	ret = of_regulator_match(dev, regulators,
+				 &max8973_regulator_match, 1);
+	of_node_put(regulators);
+	if (ret < 0) {
+		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
+		return ret;
+	}
+	if (!ret) {
+		dev_err(dev, "No regulator configuration found\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int max8973_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -370,7 +402,12 @@ static int max8973_probe(struct i2c_client *client,
 	int ret;
 
 	pdata = client->dev.platform_data;
-	if (!pdata) {
+
+	if (client->dev.of_node) {
+		ret = max8973_regulator_parse_dt(&client->dev);
+		if (ret < 0)
+			return ret;
+	} else if (!pdata) {
 		dev_err(&client->dev, "No Platform data");
 		return -EIO;
 	}
@@ -400,7 +437,7 @@ static int max8973_probe(struct i2c_client *client,
 	max->desc.uV_step = MAX8973_VOLATGE_STEP;
 	max->desc.n_voltages = MAX8973_BUCK_N_VOLTAGE;
 
-	if (!pdata->enable_ext_control) {
+	if (!pdata || !pdata->enable_ext_control) {
 		max->desc.enable_reg = MAX8973_VOUT;
 		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
 		max->ops.enable = regulator_enable_regmap;
@@ -408,12 +445,17 @@ static int max8973_probe(struct i2c_client *client,
 		max->ops.is_enabled = regulator_is_enabled_regmap;
 	}
 
-	max->enable_external_control = pdata->enable_ext_control;
-	max->dvs_gpio = pdata->dvs_gpio;
-	max->curr_gpio_val = pdata->dvs_def_state;
-	max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
+	if (pdata) {
+		max->dvs_gpio = pdata->dvs_gpio;
+		max->enable_external_control = pdata->enable_ext_control;
+		max->curr_gpio_val = pdata->dvs_def_state;
+		max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
+	} else {
+		max->dvs_gpio = -EINVAL;
+		max->curr_vout_reg = MAX8973_VOUT;
+	}
+
 	max->lru_index[0] = max->curr_vout_reg;
-	max->valid_dvs_gpio = false;
 
 	if (gpio_is_valid(max->dvs_gpio)) {
 		int gpio_flags;
@@ -439,18 +481,23 @@ static int max8973_probe(struct i2c_client *client,
 			max->lru_index[i] = i;
 		max->lru_index[0] = max->curr_vout_reg;
 		max->lru_index[max->curr_vout_reg] = 0;
+	} else {
+		max->valid_dvs_gpio = false;
 	}
 
-	ret = max8973_init_dcdc(max, pdata);
-	if (ret < 0) {
-		dev_err(max->dev, "Max8973 Init failed, err = %d\n", ret);
-		return ret;
+	if (pdata) {
+		ret = max8973_init_dcdc(max, pdata);
+		if (ret < 0) {
+			dev_err(max->dev, "Max8973 Init failed, err = %d\n", ret);
+			return ret;
+		}
 	}
 
 	config.dev = &client->dev;
-	config.init_data = pdata->reg_init_data;
+	config.init_data = pdata ? pdata->reg_init_data :
+		max8973_regulator_match.init_data;
 	config.driver_data = max;
-	config.of_node = client->dev.of_node;
+	config.of_node = max8973_regulator_match.of_node;
 	config.regmap = max->regmap;
 
 	/* Register the regulators */
-- 
1.7.2.5

