Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaIFLmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 07:42:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53044 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaIFLmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 07:42:32 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@kernel.org>
Date: Sat,  6 Sep 2014 12:42:11 +0100
Message-Id: <1410003731-32276-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: isl9305: Add Intersil ISL9305/H driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISL9305 and ISL9305H are mini-PMICs offering two DCDC regulators and
two LDO regulators. While there are some register differences between them
these do not affect the current Linux driver as the relevant features are
not yet supported.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 .../devicetree/bindings/regulator/isl9305.txt      |  36 +++
 drivers/regulator/Kconfig                          |   6 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/isl9305.c                        | 247 +++++++++++++++++++++
 include/linux/platform_data/isl9305.h              |  30 +++
 5 files changed, 320 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/isl9305.txt
 create mode 100644 drivers/regulator/isl9305.c
 create mode 100644 include/linux/platform_data/isl9305.h

diff --git a/Documentation/devicetree/bindings/regulator/isl9305.txt b/Documentation/devicetree/bindings/regulator/isl9305.txt
new file mode 100644
index 000000000000..a626fc1bbf0d
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/isl9305.txt
@@ -0,0 +1,36 @@
+Intersil ISL9305/ISL9305H voltage regulator
+
+Required properties:
+
+- compatible: "isl,isl9305" or "isl,isl9305h"
+- reg: I2C slave address, usually 0x68.
+- regulators: A node that houses a sub-node for each regulator within the
+  device. Each sub-node is identified using the node's name, with valid
+  values being "dcd1", "dcd2", "ldo1" and "ldo2". The content of each sub-node
+  is defined by the standard binding for regulators; see regulator.txt.
+- VINDCD1-supply: A phandle to a regulator node supplying VINDCD1.
+  VINDCD2-supply: A phandle to a regulator node supplying VINDCD2.
+  VINLDO1-supply: A phandle to a regulator node supplying VINLDO1.
+  VINLDO2-supply: A phandle to a regulator node supplying VINLDO2.
+
+Optional properties:
+- Per-regulator optional properties are defined in regulator.txt
+
+Example
+
+	pmic: isl9305@68 {
+		compatible = "isl,isl9305";
+		reg = <0x68>;
+
+		VINDCD1-supply = <&system_power>;
+		VINDCD2-supply = <&system_power>;
+		VINLDO1-supply = <&system_power>;
+		VINLDO2-supply = <&system_power>;
+
+		regulators {
+			dcd1 {
+			        regulator-name = "VDD_DSP";
+				regulator-always-on;
+                        };
+		};
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index a5ed328ab324..7a3a0614d573 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -251,6 +251,12 @@ config REGULATOR_HI6421
 	  21 general purpose LDOs, 3 dedicated LDOs, and 5 BUCKs. All
 	  of them come with support to either ECO (idle) or sleep mode.
 
+config REGULATOR_ISL9305
+	tristate "Intersil ISL9305 regulator"
+	depends on I2C
+	help
+	  This driver supports ISL9305 voltage regulator chip.
+
 config REGULATOR_ISL6271A
 	tristate "Intersil ISL6271A Power regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 271fe1e8ad18..25271f80f098 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_REGULATOR_FAN53555) += fan53555.o
 obj-$(CONFIG_REGULATOR_GPIO) += gpio-regulator.o
 obj-$(CONFIG_REGULATOR_HI6421) += hi6421-regulator.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
+obj-$(CONFIG_REGULATOR_ISL9305) += isl9305.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_LP3972) += lp3972.o
 obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
diff --git a/drivers/regulator/isl9305.c b/drivers/regulator/isl9305.c
new file mode 100644
index 000000000000..b0d12d186b68
--- /dev/null
+++ b/drivers/regulator/isl9305.c
@@ -0,0 +1,247 @@
+/*
+ * isl9305 - Intersil ISL9305 DCDC regulator
+ *
+ * Copyright 2014 Linaro Ltd
+ *
+ * Author: Mark Brown <broonie@kernel.org>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/of.h>
+#include <linux/platform_data/isl9305.h>
+#include <linux/regmap.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/slab.h>
+
+/*
+ * Registers
+ */
+#define ISL9305_DCD1OUT          0x0
+#define ISL9305_DCD2OUT          0x1
+#define ISL9305_LDO1OUT          0x2
+#define ISL9305_LDO2OUT          0x3
+#define ISL9305_DCD_PARAMETER    0x4
+#define ISL9305_SYSTEM_PARAMETER 0x5
+#define ISL9305_DCD_SRCTL        0x6
+
+#define ISL9305_MAX_REG ISL9305_DCD_SRCTL
+
+/*
+ * DCD_PARAMETER
+ */
+#define ISL9305_DCD_PHASE   0x40
+#define ISL9305_DCD2_ULTRA  0x20
+#define ISL9305_DCD1_ULTRA  0x10
+#define ISL9305_DCD2_BLD    0x08
+#define ISL9305_DCD1_BLD    0x04
+#define ISL9305_DCD2_MODE   0x02
+#define ISL9305_DCD1_MODE   0x01
+
+/*
+ * SYSTEM_PARAMETER
+ */
+#define ISL9305_I2C_EN      0x40
+#define ISL9305_DCDPOR_MASK 0x30
+#define ISL9305_LDO2_EN     0x08
+#define ISL9305_LDO1_EN     0x04
+#define ISL9305_DCD2_EN     0x02
+#define ISL9305_DCD1_EN     0x01
+
+/*
+ * DCD_SRCTL
+ */
+#define ISL9305_DCD2SR_MASK 0xc0
+#define ISL9305_DCD1SR_MASK 0x07
+
+static const struct regulator_ops isl9305_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.list_voltage = regulator_list_voltage_linear,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+};
+
+static const struct regulator_desc isl9305_regulators[] = {
+	[ISL9305_DCD1] = {
+		.name =		"DCD1",
+		.n_voltages =	0x70,
+		.min_uV =	825000,
+		.uV_step =	25000,
+		.vsel_reg =	ISL9305_DCD1OUT,
+		.vsel_mask =	0x7f,
+		.enable_reg =	ISL9305_SYSTEM_PARAMETER,
+		.enable_mask =	ISL9305_DCD1_EN,
+		.supply_name =	"VINDCD1",
+		.ops =		&isl9305_ops,
+	},
+	[ISL9305_DCD2] = {
+		.name =		"DCD2",
+		.n_voltages =	0x70,
+		.min_uV =	825000,
+		.uV_step =	25000,
+		.vsel_reg =	ISL9305_DCD2OUT,
+		.vsel_mask =	0x7f,
+		.enable_reg =	ISL9305_SYSTEM_PARAMETER,
+		.enable_mask =	ISL9305_DCD2_EN,
+		.supply_name =	"VINDCD2",
+		.ops =		&isl9305_ops,
+	},
+	[ISL9305_LDO1] = {
+		.name =		"LDO1",
+		.n_voltages =	0x37,
+		.min_uV =	900000,
+		.uV_step =	50000,
+		.vsel_reg =	ISL9305_LDO1OUT,
+		.vsel_mask =	0x3f,
+		.enable_reg =	ISL9305_SYSTEM_PARAMETER,
+		.enable_mask =	ISL9305_LDO1_EN,
+		.supply_name =	"VINLDO1",
+		.ops =		&isl9305_ops,
+	},
+	[ISL9305_LDO2] = {
+		.name =		"LDO2",
+		.n_voltages =	0x37,
+		.min_uV =	900000,
+		.uV_step =	50000,
+		.vsel_reg =	ISL9305_LDO2OUT,
+		.vsel_mask =	0x3f,
+		.enable_reg =	ISL9305_SYSTEM_PARAMETER,
+		.enable_mask =	ISL9305_LDO2_EN,
+		.supply_name =	"VINLDO2",
+		.ops =		&isl9305_ops,
+	},
+};
+
+#ifdef CONFIG_OF
+static struct of_regulator_match isl9305_reg_matches[] = {
+	[ISL9305_DCD1] = { .name = "dcd1" },
+	[ISL9305_DCD2] = { .name = "dcd2" },
+	[ISL9305_LDO1] = { .name = "ldo1" },
+	[ISL9305_LDO2] = { .name = "ldo2" },
+};
+
+static struct of_regulator_match *isl9305_parse_dt(struct i2c_client *i2c)
+{
+	struct device_node *node = i2c->dev.of_node;
+	struct of_regulator_match *matches;
+	struct device_node *regs;
+	int count;
+
+	regs = of_get_child_by_name(node, "regulators");
+	if (!regs)
+		return NULL;
+
+	matches = devm_kmemdup(&i2c->dev, isl9305_reg_matches,
+			       sizeof(isl9305_reg_matches), GFP_KERNEL);
+	if (!matches)
+		return NULL;
+
+	count = of_regulator_match(&i2c->dev, regs, matches,
+				   ARRAY_SIZE(isl9305_reg_matches));
+	of_node_put(regs);
+	if ((count < 0) || (count > ARRAY_SIZE(isl9305_reg_matches)))
+		return NULL;
+
+	return matches;
+}
+#else
+static struct of_regulator_match *isl9305_parse_dt(struct i2c_client *i2c)
+{
+	return NULL;
+}
+#endif
+
+static const struct regmap_config isl9305_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = ISL9305_MAX_REG,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int isl9305_i2c_probe(struct i2c_client *i2c,
+			     const struct i2c_device_id *id)
+{
+	struct regulator_config config = { };
+	struct isl9305_pdata *pdata = i2c->dev.platform_data;
+	struct of_regulator_match *of_matches;
+	struct regulator_dev *rdev;
+	struct regmap *regmap;
+	int i, ret;
+
+	of_matches = isl9305_parse_dt(i2c);
+
+	regmap = devm_regmap_init_i2c(i2c, &isl9305_regmap);
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		dev_err(&i2c->dev, "Failed to create regmap: %d\n", ret);
+		return ret;
+	}
+
+	config.dev = &i2c->dev;
+
+	for (i = 0; i < ARRAY_SIZE(isl9305_regulators); i++) {
+		config.of_node = NULL;
+		config.init_data = NULL;
+
+		if (of_matches) {
+			config.init_data = of_matches[i].init_data;
+			config.of_node = of_matches[i].of_node;
+		}
+
+		if (!config.init_data && pdata)
+			config.init_data = pdata->init_data[i];
+
+		rdev = devm_regulator_register(&i2c->dev,
+					       &isl9305_regulators[i],
+					       &config);
+		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
+			dev_err(&i2c->dev, "Failed to register %s: %d\n",
+				isl9305_regulators[i].name, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id isl9305_dt_ids[] = {
+	{ .compatible = "isl,isl9305" },
+	{ .compatible = "isl,isl9305h" },
+	{},
+};
+#endif
+
+static const struct i2c_device_id isl9305_i2c_id[] = {
+	{ "isl9305", },
+	{ "isl9305h", },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, isl9305_i2c_id);
+
+static struct i2c_driver isl9305_regulator_driver = {
+	.driver = {
+		.name = "isl9305",
+		.owner = THIS_MODULE,
+		.of_match_table	= of_match_ptr(isl9305_dt_ids),
+	},
+	.probe = isl9305_i2c_probe,
+	.id_table = isl9305_i2c_id,
+};
+
+module_i2c_driver(isl9305_regulator_driver);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("Intersil ISL9305 DCDC regulator");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/isl9305.h b/include/linux/platform_data/isl9305.h
new file mode 100644
index 000000000000..1419133fa69e
--- /dev/null
+++ b/include/linux/platform_data/isl9305.h
@@ -0,0 +1,30 @@
+/*
+ * isl9305 - Intersil ISL9305 DCDC regulator
+ *
+ * Copyright 2014 Linaro Ltd
+ *
+ * Author: Mark Brown <broonie@kernel.org>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#ifndef __ISL9305_H
+#define __ISL9305_H
+
+#define ISL9305_DCD1 0
+#define ISL9305_DCD2 1
+#define ISL9305_LDO1 2
+#define ISL9305_LDO2 3
+
+#define ISL9305_MAX_REGULATOR ISL9305_LDO2
+
+struct regulator_init_data;
+
+struct isl9305_pdata {
+	struct regulator_init_data *init_data[ISL9305_MAX_REGULATOR];
+};
+
+#endif
-- 
2.1.0

