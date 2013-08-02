Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3HBKr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:47:29 -0400
Received: from svenfoo.org ([82.94.215.22]:45178 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab3HBKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:47:26 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [PATCH v2] regulators: max8660: add DT bindings
Date: Fri,  2 Aug 2013 12:47:19 +0200
Message-Id: <1375440439-31902-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds devicetree bindings for max8660, along with some
documentation.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---

v2:
	- fixed documentation
	- use of_match_ptr
	- only pass the of_nodes internally

 .../devicetree/bindings/regulator/max8660.txt      | 47 +++++++++++++
 drivers/regulator/max8660.c                        | 81 +++++++++++++++++++++-
 include/linux/regulator/max8660.h                  |  2 +-
 3 files changed, 128 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/max8660.txt

diff --git a/Documentation/devicetree/bindings/regulator/max8660.txt b/Documentation/devicetree/bindings/regulator/max8660.txt
new file mode 100644
index 0000000..8ba994d
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max8660.txt
@@ -0,0 +1,47 @@
+Maxim MAX8660 voltage regulator
+
+Required properties:
+- compatible: must be one of "maxim,max8660", "maxim,max8661"
+- reg: I2C slave address, usually 0x34
+- any required generic properties defined in regulator.txt
+
+Example:
+
+	i2c_master {
+		max8660@34 {
+			compatible = "maxim,max8660";
+			reg = <0x34>;
+
+			regulators {
+				regulator@0 {
+					regulator-compatible= "V3(DCDC)";
+					regulator-min-microvolt = <725000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				regulator@1 {
+					regulator-compatible= "V4(DCDC)";
+					regulator-min-microvolt = <725000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				regulator@2 {
+					regulator-compatible= "V5(LDO)";
+					regulator-min-microvolt = <1700000>;
+					regulator-max-microvolt = <2000000>;
+				};
+
+				regulator@3 {
+					regulator-compatible= "V6(LDO)";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				regulator@4 {
+					regulator-compatible= "V7(LDO)";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <3300000>;
+				};
+			};
+		};
+	};
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index a5caaa0..e67a863 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -44,6 +44,9 @@
 #include <linux/regulator/driver.h>
 #include <linux/slab.h>
 #include <linux/regulator/max8660.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regulator/of_regulator.h>
 
 #define MAX8660_DCDC_MIN_UV	 725000
 #define MAX8660_DCDC_MAX_UV	1800000
@@ -310,6 +313,62 @@ enum {
 	MAX8661 = 1,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id max8660_dt_ids[] = {
+	{ .compatible = "maxim,max8660", .data = (void *) MAX8660 },
+	{ .compatible = "maxim,max8661", .data = (void *) MAX8661 },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, max8660_dt_ids);
+
+static int max8660_pdata_from_dt(struct device *dev,
+				 struct device_node **of_node,
+				 struct max8660_platform_data *pdata)
+{
+	int matched, i;
+	struct device_node *np;
+	struct max8660_subdev_data *sub;
+	struct of_regulator_match rmatch[ARRAY_SIZE(max8660_reg)];
+
+	np = of_find_node_by_name(dev->of_node, "regulators");
+	if (!np) {
+		dev_err(dev, "missing 'regulators' subnode in DT\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(rmatch); i++)
+		rmatch[i].name = max8660_reg[i].name;
+
+	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(rmatch));
+	if (matched <= 0)
+		return matched;
+
+	pdata->subdevs = devm_kzalloc(dev, sizeof(struct max8660_subdev_data) *
+						matched, GFP_KERNEL);
+	if (!pdata->subdevs)
+		return -ENOMEM;
+
+	pdata->num_subdevs = matched;
+	sub = pdata->subdevs;
+
+	for (i = 0; i < matched; i++) {
+		sub->id = i;
+		sub->name = rmatch[i].name;
+		sub->platform_data = rmatch[i].init_data;
+		of_node[i] = rmatch[i].of_node;
+		sub++;
+	}
+
+	return 0;
+}
+#else
+static inline int max8660_pdata_from_dt(struct device *dev,
+					struct max8660_platform_data **pdata)
+{
+	return 0;
+}
+#endif
+
 static int max8660_probe(struct i2c_client *client,
 				   const struct i2c_device_id *i2c_id)
 {
@@ -319,8 +378,28 @@ static int max8660_probe(struct i2c_client *client,
 	struct regulator_config config = { };
 	struct max8660 *max8660;
 	int boot_on, i, id, ret = -EINVAL;
+	struct device_node *of_node[MAX8660_V_END];
 	unsigned int type;
 
+	if (dev->of_node && !pdata) {
+		const struct of_device_id *id;
+		struct max8660_platform_data pdata_of;
+
+		id = of_match_device(of_match_ptr(max8660_dt_ids), dev);
+		if (!id)
+			return -ENODEV;
+
+		ret = max8660_pdata_from_dt(dev, of_node, &pdata_of);
+		if (ret < 0)
+			return ret;
+
+		pdata = &pdata_of;
+		type = (unsigned int) id->data;
+	} else {
+		type = i2c_id->driver_data;
+		memset(of_node, 0, sizeof(of_node));
+	}
+
 	if (pdata->num_subdevs > MAX8660_V_END) {
 		dev_err(dev, "Too many regulators found!\n");
 		return -EINVAL;
@@ -334,7 +413,6 @@ static int max8660_probe(struct i2c_client *client,
 
 	max8660->client = client;
 	rdev = max8660->rdev;
-	type = i2c_id->driver_data;
 
 	if (pdata->en34_is_high) {
 		/* Simulate always on */
@@ -407,6 +485,7 @@ static int max8660_probe(struct i2c_client *client,
 
 		config.dev = dev;
 		config.init_data = pdata->subdevs[i].platform_data;
+		config.of_node = of_node[i];
 		config.driver_data = max8660;
 
 		rdev[i] = regulator_register(&max8660_reg[id], &config);
diff --git a/include/linux/regulator/max8660.h b/include/linux/regulator/max8660.h
index 9936763..f8a6a48 100644
--- a/include/linux/regulator/max8660.h
+++ b/include/linux/regulator/max8660.h
@@ -39,7 +39,7 @@ enum {
  */
 struct max8660_subdev_data {
 	int				id;
-	char				*name;
+	const char			*name;
 	struct regulator_init_data	*platform_data;
 };
 
-- 
1.8.3.1

