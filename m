Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaKDGvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:51:00 -0500
Received: from atl4mhob19.myregisteredsite.com ([209.17.115.112]:35865 "EHLO
	atl4mhob19.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbaKDGu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:50:59 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v3] Add ltc3562 voltage regulator driver
Date: Tue,  4 Nov 2014 07:50:45 +0100
Message-Id: <1415083845-27079-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ltc3562 is an I2C controlled regulator supporting 4 independent
outputs.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---

v3: Add .of_match_table and prefix lltc
    Clarify why regmap cannot be used
    Add lltc,operating-mode (0..3) DT property
    regulator child nodes are optional


 .../devicetree/bindings/regulator/ltc3562.txt      |   57 ++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/ltc3562.c                        |  337 ++++++++++++++++++++
 4 files changed, 402 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/ltc3562.txt
 create mode 100644 drivers/regulator/ltc3562.c

diff --git a/Documentation/devicetree/bindings/regulator/ltc3562.txt b/Documentation/devicetree/bindings/regulator/ltc3562.txt
new file mode 100644
index 0000000..d73c865
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/ltc3562.txt
@@ -0,0 +1,57 @@
+Linear Technology LTC3562 I2C controlled 4-output regulator
+
+Required properties:
+- compatible: "lltc,ltc3562"
+- reg: I2C slave address
+
+Required child node:
+- regulators: Contains optional regulator child nodes R400B, R600B, R400A
+  and R600A specifying the initialization data as documented in
+  Documentation/devicetree/bindings/regulator/regulator.txt.
+
+Each regulator is defined using the standard binding for regulators. The
+nodes for R400A and R600A additionally need to specify the resistor values of
+their external feedback voltage dividers:
+
+Required properties (A-type only):
+- lltc,fb-voltage-divider: An array of two integers containing the resistor
+  values R1 and R2 of the feedback voltage divider. Both values must remain in
+  the range 1..1000, only their quotient matters.
+
+Optional properties:
+- lltc,operating-mode: Operating mode as specified in table 3 of the datasheet.
+  This value is passed as the lower two bits of the first data byte, and sets
+  the operating mode: 0=Pulse-skip (default), 1=LDO, 2=Forced-burst, 3=Burst.
+
+Example:
+
+	ltc3562: ltc3562@65 {
+		compatible = "ltc3562";
+		reg = <0x65>;
+		regulators {
+			R400B_reg: R400B {
+				regulator-min-microvolt = <600000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			R600B_reg: R600B {
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			R400A_reg: R400A {
+				regulator-min-microvolt = <425000>;
+				regulator-max-microvolt = <8000000>;
+				lltc,fb-voltage-divider = <1, 1>;
+			};
+			R600A_reg: R600A {
+				regulator-min-microvolt = <425000>;
+				regulator-max-microvolt = <1800000>;
+				lltc,fb-voltage-divider = <316, 100>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 55d7b7b..4012601 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -300,6 +300,13 @@ config REGULATOR_LP8788
 	help
 	  This driver supports LP8788 voltage regulator chip.
 
+config REGULATOR_LTC3562
+	tristate "LCT3562 quad output voltage regulator"
+	depends on I2C
+	help
+	  This enables support for the LCT3562 quad output voltage regulator
+	  controlled via I2C.
+
 config REGULATOR_LTC3589
 	tristate "LTC3589 8-output voltage regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 1029ed3..9a15146 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-buck.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-ldo.o
 obj-$(CONFIG_REGULATOR_LP8755) += lp8755.o
+obj-$(CONFIG_REGULATOR_LTC3562) += ltc3562.o
 obj-$(CONFIG_REGULATOR_LTC3589) += ltc3589.o
 obj-$(CONFIG_REGULATOR_MAX14577) += max14577.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
diff --git a/drivers/regulator/ltc3562.c b/drivers/regulator/ltc3562.c
new file mode 100644
index 0000000..69963f8
--- /dev/null
+++ b/drivers/regulator/ltc3562.c
@@ -0,0 +1,337 @@
+/*
+ * Regulator driver for Linear Technology LTC3562
+ *
+ *  Copyright (C) 2014 Topic Embedded Products
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/slab.h>
+#include <linux/regulator/of_regulator.h>
+
+#define LTC3562_NUM_REGULATORS	4
+
+#define REGULATOR_TYPE_A_NUM_VOLTAGES	16
+#define REGULATOR_TYPE_A_MIN_UV	425000
+#define REGULATOR_TYPE_A_UV_STEP	25000
+
+#define REGULATOR_TYPE_B_NUM_VOLTAGES	128
+#define REGULATOR_TYPE_B_MIN_UV	600000
+#define REGULATOR_TYPE_B_UV_STEP	25000
+
+/* the LTC3562 does not have a register map, instead it receives a two-byte
+ * command set. The first byte sets the mask for the output(s) to be programmed
+ * and the second byte hold the "enable" bit and the DAC code. */
+struct ltc3562_status {
+	u8 addr_mode;	/* sub-address byte: program mask an operating mode */
+	u8 enable_daccode;	/* data byte: Enable bit and DAC code  */
+};
+
+struct ltc3562 {
+	struct device *dev;
+	struct i2c_client *i2c;
+	struct mutex mutex;
+	struct regulator_dev *rdev[LTC3562_NUM_REGULATORS];
+	struct ltc3562_status rstatus[LTC3562_NUM_REGULATORS];
+};
+
+#define LTC3562_R400B_ID	0x00
+#define LTC3562_R600B_ID	0x01
+#define LTC3562_R400A_ID	0x02
+#define LTC3562_R600A_ID	0x03
+
+#define OPERATING_MODE_MASK	0x03
+
+#define PROGRAM_R400B_MASK	0x10
+#define PROGRAM_R600B_MASK	0x20
+#define PROGRAM_R400A_MASK	0x40
+#define PROGRAM_R600A_MASK	0x80
+
+#define OPERATING_MODE_PULSE_SKIP	0x00
+#define OPERATING_MODE_LDO		0x01
+#define OPERATING_MODE_FOCED_BURST	0x02
+#define OPERATING_MODE_BURST		0x03
+
+#define REGULATOR_ENABLE_BIT	0x80
+
+static int ltc3562_update(struct ltc3562 *ltc3562,
+	struct ltc3562_status *status)
+{
+	return i2c_smbus_write_byte_data(
+		ltc3562->i2c, status->addr_mode, status->enable_daccode);
+}
+
+static int ltc3562_regulator_enable(struct regulator_dev *dev)
+{
+	int ret;
+	struct ltc3562 *ltc3562 = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	struct ltc3562_status *status = &ltc3562->rstatus[id];
+
+	mutex_lock(&ltc3562->mutex);
+
+	status->enable_daccode |= REGULATOR_ENABLE_BIT;
+	ret = ltc3562_update(ltc3562, status);
+
+	mutex_unlock(&ltc3562->mutex);
+
+	return ret;
+}
+
+static int ltc3562_regulator_disable(struct regulator_dev *dev)
+{
+	int ret;
+	struct ltc3562 *ltc3562 = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	struct ltc3562_status *status = &ltc3562->rstatus[id];
+
+	mutex_lock(&ltc3562->mutex);
+
+	status->enable_daccode &= ~(REGULATOR_ENABLE_BIT);
+	ret = ltc3562_update(ltc3562, status);
+
+	mutex_unlock(&ltc3562->mutex);
+
+	return ret;
+}
+
+static int ltc3562_regulator_is_enabled(struct regulator_dev *dev)
+{
+	int ret;
+	struct ltc3562 *ltc3562 = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	struct ltc3562_status *status = &ltc3562->rstatus[id];
+
+	mutex_lock(&ltc3562->mutex);
+
+	ret = (status->enable_daccode & REGULATOR_ENABLE_BIT) ? 1 : 0;
+
+	mutex_unlock(&ltc3562->mutex);
+
+	return ret;
+}
+
+static int ltc3562_set_voltage_sel(struct regulator_dev *dev,
+	unsigned int selector)
+{
+	int ret;
+	struct ltc3562 *ltc3562 = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	struct ltc3562_status *status = &ltc3562->rstatus[id];
+
+	mutex_lock(&ltc3562->mutex);
+
+	status->enable_daccode =
+		(status->enable_daccode & REGULATOR_ENABLE_BIT) | selector;
+	ret = ltc3562_update(ltc3562, status);
+
+	mutex_unlock(&ltc3562->mutex);
+
+	return ret;
+}
+
+static int ltc3562_get_voltage_sel(struct regulator_dev *dev)
+{
+	int ret;
+	struct ltc3562 *ltc3562 = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	struct ltc3562_status *status = &ltc3562->rstatus[id];
+
+	mutex_lock(&ltc3562->mutex);
+
+	ret = status->enable_daccode & ~(REGULATOR_ENABLE_BIT);
+
+	mutex_unlock(&ltc3562->mutex);
+
+	return ret;
+}
+
+static struct regulator_ops ltc3562_regulator_ops = {
+	.is_enabled = ltc3562_regulator_is_enabled,
+	.enable = ltc3562_regulator_enable,
+	.disable = ltc3562_regulator_disable,
+	.set_voltage_sel = ltc3562_set_voltage_sel,
+	.get_voltage_sel = ltc3562_get_voltage_sel,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
+};
+
+static struct regulator_desc ltc3562_regulators[] = {
+	{
+		.name = "R400B",
+		.id = LTC3562_R400B_ID,
+		.ops = &ltc3562_regulator_ops,
+		.min_uV = REGULATOR_TYPE_B_MIN_UV,
+		.uV_step = REGULATOR_TYPE_B_UV_STEP,
+		.n_voltages = REGULATOR_TYPE_B_NUM_VOLTAGES,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "R600B",
+		.id = LTC3562_R600B_ID,
+		.ops = &ltc3562_regulator_ops,
+		.min_uV = REGULATOR_TYPE_B_MIN_UV,
+		.uV_step = REGULATOR_TYPE_B_UV_STEP,
+		.n_voltages = REGULATOR_TYPE_B_NUM_VOLTAGES,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "R400A",
+		.id = LTC3562_R400A_ID,
+		.ops = &ltc3562_regulator_ops,
+		.min_uV = REGULATOR_TYPE_A_MIN_UV,
+		.uV_step = REGULATOR_TYPE_A_UV_STEP,
+		.n_voltages = REGULATOR_TYPE_A_NUM_VOLTAGES,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "R600A",
+		.id = LTC3562_R600A_ID,
+		.ops = &ltc3562_regulator_ops,
+		.min_uV = REGULATOR_TYPE_A_MIN_UV,
+		.uV_step = REGULATOR_TYPE_A_UV_STEP,
+		.n_voltages = REGULATOR_TYPE_A_NUM_VOLTAGES,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+};
+
+/* Write dummy data to detect presence of the physical device. */
+static int ltc3562_dummy_write(struct i2c_client *i2c)
+{
+	return i2c_smbus_write_byte_data(i2c, 0, 0);
+}
+
+static int ltc3562_i2c_probe(struct i2c_client *i2c,
+	const struct i2c_device_id *id)
+{
+	int i, error;
+	unsigned long uV;
+	struct ltc3562 *ltc3562;
+	struct regulator_config rconfig = { };
+	struct device_node *np_regulators, *np;
+	struct device_node *np_child;
+	u32 value;
+
+	ltc3562 = devm_kzalloc(&i2c->dev,
+		sizeof(struct ltc3562), GFP_KERNEL);
+	if (ltc3562 == NULL)
+		return -ENOMEM;
+
+	ltc3562->i2c = i2c;
+	i2c_set_clientdata(i2c, ltc3562);
+
+	mutex_init(&ltc3562->mutex);
+
+	if (ltc3562_dummy_write(i2c) < 0) {
+		dev_err(&i2c->dev,
+			"Could not find device LTC3562 on i2c bus\n");
+		return -ENODEV;
+	}
+
+	np = of_node_get(i2c->dev.of_node);
+	np_regulators = of_get_child_by_name(np, "regulators");
+
+	if (np_regulators == NULL) {
+		dev_err(&i2c->dev, "Could not find regulators node\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < LTC3562_NUM_REGULATORS; ++i) {
+		np_child = of_get_child_by_name(np_regulators,
+			ltc3562_regulators[i].name);
+		if (np_child == NULL)
+			continue;
+
+		if ((ltc3562_regulators[i].id == LTC3562_R400A_ID) ||
+			(ltc3562_regulators[i].id == LTC3562_R600A_ID)) {
+			/* If regulator is A type get resistor values */
+			u32 vdiv[2];
+
+			error = of_property_read_u32_array(np_child,
+				"lltc,fb-voltage-divider", vdiv, 2);
+			if (error) {
+				dev_err(&i2c->dev,
+					"Failed to parse voltage divider: %d\n",
+					error);
+				return error;
+			}
+
+			uV = ltc3562_regulators[i].min_uV / 1000;
+			ltc3562_regulators[i].min_uV =
+				(uV + mult_frac(uV, vdiv[0], vdiv[1])) * 1000;
+
+			uV = ltc3562_regulators[i].uV_step / 1000;
+			ltc3562_regulators[i].uV_step =
+				(uV + mult_frac(uV, vdiv[0], vdiv[1])) * 1000;
+		}
+
+		/* Set operating mode and address mask */
+		error = of_property_read_u32(np_child,
+				"lltc,operating-mode", &value);
+		if (error || (value > OPERATING_MODE_BURST))
+			value = OPERATING_MODE_PULSE_SKIP;
+		ltc3562->rstatus[i].addr_mode =
+			(PROGRAM_R400B_MASK << i) | value;
+
+		rconfig.dev = &i2c->dev;
+		rconfig.init_data =
+			of_get_regulator_init_data(&i2c->dev, np_child);
+		rconfig.driver_data = ltc3562;
+		rconfig.of_node = np_child;
+
+		ltc3562->rdev[i] = devm_regulator_register(&i2c->dev,
+			&ltc3562_regulators[i], &rconfig);
+
+		if (IS_ERR(ltc3562->rdev[i])) {
+			error = PTR_ERR(ltc3562->rdev[i]);
+			dev_err(&i2c->dev,
+				"could not register regulator, Error %d\n",
+				error);
+		}
+	}
+
+	dev_dbg(&i2c->dev, "LTC3562 Driver loaded\n");
+
+	return 0;
+}
+
+static const struct of_device_id ltc3562_match_id[] = {
+	{ .compatible = "lltc,ltc3562", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ltc3562_match_id);
+
+static const struct i2c_device_id ltc3562_i2c_id[] = {
+	{ "ltc3562", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ltc3562_i2c_id);
+
+static struct i2c_driver ltc3562_i2c_driver = {
+	.driver = {
+		.name = "LTC3562",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(ltc3562_match_id),
+	},
+	.probe    = ltc3562_i2c_probe,
+	.id_table = ltc3562_i2c_id,
+};
+
+module_i2c_driver(ltc3562_i2c_driver);
+
+MODULE_DESCRIPTION("LTC3562 Regulator Driver");
+MODULE_AUTHOR("auryn.verwegen@topic.nl");
+MODULE_AUTHOR("mike.looijmans@topic.nl");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

