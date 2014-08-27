Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaH0Ecw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:32:52 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:55503 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbaH0Ecv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:32:51 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 00:32:50 EDT
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-3.tower-178.messagelabs.com!1409113571!34264746!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201408270426.s7R4Q6Ov001133@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Wed, 27 Aug 2014 11:47:07 +0900
Subject: [PATCH V2] regulator: DA9211 : support device tree
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for supporting device tree of DA9211/DA9213.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140826.

Changes in V2:
- defined what the valid regulators for the device and
  where their configuration should be specified in the device tree.
  
 .../devicetree/bindings/regulator/da9211.txt       |   63 +++++++++++++++
 drivers/regulator/da9211-regulator.c               |   85 ++++++++++++++++++--
 include/linux/regulator/da9211.h                   |    2 +-
 3 files changed, 142 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/da9211.txt

diff --git a/Documentation/devicetree/bindings/regulator/da9211.txt b/Documentation/devicetree/bindings/regulator/da9211.txt
new file mode 100644
index 0000000..240019a
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/da9211.txt
@@ -0,0 +1,63 @@
+* Dialog Semiconductor DA9211/DA9213 Voltage Regulator
+
+Required properties:
+- compatible: "dlg,da9211" or "dlg,da9213".
+- reg: I2C slave address, usually 0x68.
+- interrupts: the interrupt outputs of the controller
+- regulators: A node that houses a sub-node for each regulator within the
+  device. Each sub-node is identified using the node's name, with valid
+  values listed below. The content of each sub-node is defined by the
+  standard binding for regulators; see regulator.txt.
+  BUCKA and BUCKB.
+
+Optional properties:
+- Any optional property defined in regulator.txt
+
+Example 1) DA9211
+
+	pmic: da9211@68 {
+		compatible = "dlg,da9211";
+		reg = <0x68>;
+		interrupts = <3 27>;
+
+		regulators {
+			BUCKA {
+				regulator-name = "VBUCKA";
+				regulator-min-microvolt = < 300000>;
+				regulator-max-microvolt = <1570000>;
+				regulator-min-microamp 	= <2000000>;
+				regulator-max-microamp 	= <5000000>;
+			};
+			BUCKB {
+				regulator-name = "VBUCKB";
+				regulator-min-microvolt = < 300000>;
+				regulator-max-microvolt = <1570000>;
+				regulator-min-microamp 	= <2000000>;
+				regulator-max-microamp 	= <5000000>;
+			};
+		};
+	};
+
+Example 2) DA92113
+	pmic: da9213@68 {
+		compatible = "dlg,da9213";
+		reg = <0x68>;
+		interrupts = <3 27>;
+
+		regulators {
+			BUCKA {
+				regulator-name = "VBUCKA";
+				regulator-min-microvolt = < 300000>;
+				regulator-max-microvolt = <1570000>;
+				regulator-min-microamp 	= <3000000>;
+				regulator-max-microamp 	= <6000000>;
+			};
+			BUCKB {
+				regulator-name = "VBUCKB";
+				regulator-min-microvolt = < 300000>;
+				regulator-max-microvolt = <1570000>;
+				regulator-min-microamp 	= <3000000>;
+				regulator-max-microamp 	= <6000000>;
+			};
+		};
+	};
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index a26f1d2..5aabbac 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -24,6 +24,7 @@
 #include <linux/regmap.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/regulator/da9211.h>
 #include "da9211-regulator.h"
 
@@ -236,6 +237,59 @@ static struct regulator_desc da9211_regulators[] = {
 	DA9211_BUCK(BUCKB),
 };
 
+#ifdef CONFIG_OF
+static struct of_regulator_match da9211_matches[] = {
+	[DA9211_ID_BUCKA] = { .name = "BUCKA" },
+	[DA9211_ID_BUCKB] = { .name = "BUCKB" },
+	};
+
+static struct da9211_pdata *da9211_parse_regulators_dt(
+		struct device *dev)
+{
+	struct da9211_pdata *pdata;
+	struct device_node *node;
+	int i, num, n;
+
+	node = of_get_child_by_name(dev->of_node, "regulators");
+	if (!node) {
+		dev_err(dev, "regulators node not found\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	num = of_regulator_match(dev, node, da9211_matches,
+				 ARRAY_SIZE(da9211_matches));
+	of_node_put(node);
+	if (num < 0) {
+		dev_err(dev, "Failed to match regulators\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->num_buck = num;
+
+	n = 0;
+	for (i = 0; i < ARRAY_SIZE(da9211_matches); i++) {
+		if (!da9211_matches[i].init_data)
+			continue;
+
+		pdata->init_data[n] = da9211_matches[i].init_data;
+
+		n++;
+	};
+
+	return pdata;
+}
+#else
+static struct da9211_pdata *da9211_parse_regulators_dt(
+		struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
 static irqreturn_t da9211_irq_handler(int irq, void *data)
 {
 	struct da9211 *chip = data;
@@ -306,7 +360,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 	}
 
 	for (i = 0; i < chip->num_regulator; i++) {
-		config.init_data = &(chip->pdata->init_data[i]);
+		config.init_data = chip->pdata->init_data[i];
 		config.dev = chip->dev;
 		config.driver_data = chip;
 		config.regmap = chip->regmap;
@@ -332,6 +386,21 @@ static int da9211_regulator_init(struct da9211 *chip)
 
 	return 0;
 }
+
+static const struct i2c_device_id da9211_i2c_id[] = {
+	{"da9211", DA9211},
+	{"da9213", DA9213},
+	{},
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id da9211_dt_ids[] = {
+	{ .compatible = "dlg,da9211", .data = &da9211_i2c_id[0] },
+	{ .compatible = "dlg,da9213", .data = &da9211_i2c_id[1] },
+	{},
+};
+#endif
+
 /*
  * I2C driver interface functions
  */
@@ -377,6 +446,14 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 		return -ENODEV;
 	}
 
+	if (!chip->pdata)
+		chip->pdata = da9211_parse_regulators_dt(chip->dev);
+
+	if (IS_ERR(chip->pdata)) {
+		dev_err(chip->dev, "No regulators defined for the platform\n");
+		return PTR_ERR(chip->pdata);
+	}
+
 	chip->chip_irq = i2c->irq;
 
 	if (chip->chip_irq != 0) {
@@ -401,12 +478,6 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	return ret;
 }
 
-static const struct i2c_device_id da9211_i2c_id[] = {
-	{"da9211", DA9211},
-	{"da9213", DA9213},
-	{},
-};
-
 MODULE_DEVICE_TABLE(i2c, da9211_i2c_id);
 
 static struct i2c_driver da9211_regulator_driver = {
diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
index 658c3c3..5479394 100644
--- a/include/linux/regulator/da9211.h
+++ b/include/linux/regulator/da9211.h
@@ -32,6 +32,6 @@ struct da9211_pdata {
 	 * 2 : 2 phase 2 buck
 	 */
 	int num_buck;
-	struct regulator_init_data *init_data;
+	struct regulator_init_data *init_data[DA9211_MAX_REGULATORS];
 };
 #endif
-- 
end-of-patch for regulator: DA9211 : support device tree V2

