Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3LXCfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:35:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:7584 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3LXCfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:35:46 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenyou.yang@atmel.com>
Subject: [PATCH v5 1/3] regulator: act8865: add PMIC act8865 driver
Date: Tue, 24 Dec 2013 10:34:28 +0800
Message-ID: <1387852468-18073-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387852421-18033-1-git-send-email-wenyou.yang@atmel.com>
References: <1387852421-18033-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/regulator/Kconfig             |    8 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/act8865-regulator.c |  368 +++++++++++++++++++++++++++++++++
 include/linux/regulator/act8865.h     |   53 +++++
 4 files changed, 430 insertions(+)
 create mode 100644 drivers/regulator/act8865-regulator.c
 create mode 100644 include/linux/regulator/act8865.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 11ee053..dab2e3c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -70,6 +70,14 @@ config REGULATOR_88PM8607
 	help
 	  This driver supports 88PM8607 voltage regulator chips.
 
+config REGULATOR_ACT8865
+	tristate "Active-semi act8865 voltage regulator"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  This driver controls a active-semi act8865 voltage output
+	  regulator via I2C bus.
+
 config REGULATOR_AD5398
 	tristate "Analog Devices AD5398/AD5821 regulators"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 654bd43..979f9dd 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500-ext.o ab8500.o
+obj-$(CONFIG_REGULATOR_ACT8865) += act8865-regulator.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
new file mode 100644
index 0000000..db048f2
--- /dev/null
+++ b/drivers/regulator/act8865-regulator.c
@@ -0,0 +1,368 @@
+/*
+ * act8865-regulator.c - Voltage regulation for the active-semi ACT8865
+ * http://www.active-semi.com/sheets/ACT8865_Datasheet.pdf
+ *
+ * Copyright (C) 2013 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/act8865.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regmap.h>
+
+/*
+ * ACT8865 Global Register Map.
+ */
+#define	ACT8865_SYS_MODE	0x00
+#define	ACT8865_SYS_CTRL	0x01
+#define	ACT8865_DCDC1_VSET1	0x20
+#define	ACT8865_DCDC1_VSET2	0x21
+#define	ACT8865_DCDC1_CTRL	0x22
+#define	ACT8865_DCDC2_VSET1	0x30
+#define	ACT8865_DCDC2_VSET2	0x31
+#define	ACT8865_DCDC2_CTRL	0x32
+#define	ACT8865_DCDC3_VSET1	0x40
+#define	ACT8865_DCDC3_VSET2	0x41
+#define	ACT8865_DCDC3_CTRL	0x42
+#define	ACT8865_LDO1_VSET	0x50
+#define	ACT8865_LDO1_CTRL	0x51
+#define	ACT8865_LDO2_VSET	0x54
+#define	ACT8865_LDO2_CTRL	0x55
+#define	ACT8865_LDO3_VSET	0x60
+#define	ACT8865_LDO3_CTRL	0x61
+#define	ACT8865_LDO4_VSET	0x64
+#define	ACT8865_LDO4_CTRL	0x65
+
+/*
+ * Field Definitions.
+ */
+#define	ACT8865_ENA		0x80	/* ON - [7] */
+#define	ACT8865_VSEL_MASK	0x3F	/* VSET - [5:0] */
+
+/*
+ * ACT8865 voltage number
+ */
+#define	ACT8865_VOLTAGE_NUM	64
+
+struct act8865 {
+	struct regulator_dev *rdev[ACT8865_REG_NUM];
+	struct regmap *regmap;
+};
+
+static const struct regmap_config act8865_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static const struct regulator_linear_range act8865_volatge_ranges[] = {
+	REGULATOR_LINEAR_RANGE(600000, 0, 23, 25000),
+	REGULATOR_LINEAR_RANGE(1200000, 24, 47, 50000),
+	REGULATOR_LINEAR_RANGE(2400000, 48, 63, 100000),
+};
+
+static struct regulator_ops act8865_ops = {
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.set_suspend_enable	= regulator_enable_regmap,
+	.set_suspend_disable	= regulator_disable_regmap,
+};
+
+static const struct regulator_desc act8865_reg[] = {
+	{
+		.name = "DCDC_REG1",
+		.id = ACT8865_ID_DCDC1,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_DCDC1_VSET1,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_DCDC1_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "DCDC_REG2",
+		.id = ACT8865_ID_DCDC2,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_DCDC2_VSET1,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_DCDC2_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "DCDC_REG3",
+		.id = ACT8865_ID_DCDC3,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_DCDC3_VSET1,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_DCDC3_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG1",
+		.id = ACT8865_ID_LDO1,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_LDO1_VSET,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_LDO1_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG2",
+		.id = ACT8865_ID_LDO2,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_LDO2_VSET,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_LDO2_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG3",
+		.id = ACT8865_ID_LDO3,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_LDO3_VSET,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_LDO3_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG4",
+		.id = ACT8865_ID_LDO4,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ACT8865_VOLTAGE_NUM,
+		.linear_ranges = act8865_volatge_ranges,
+		.n_linear_ranges = ARRAY_SIZE(act8865_volatge_ranges),
+		.vsel_reg = ACT8865_LDO4_VSET,
+		.vsel_mask = ACT8865_VSEL_MASK,
+		.enable_reg = ACT8865_LDO4_CTRL,
+		.enable_mask = ACT8865_ENA,
+		.owner = THIS_MODULE,
+	},
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id act8865_dt_ids[] = {
+	{ .compatible = "active-semi,act8865" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, act8865_dt_ids);
+
+static struct of_regulator_match act8865_matches[] = {
+	[ACT8865_ID_DCDC1]	= { .name = "DCDC_REG1"},
+	[ACT8865_ID_DCDC2]	= { .name = "DCDC_REG2"},
+	[ACT8865_ID_DCDC3]	= { .name = "DCDC_REG3"},
+	[ACT8865_ID_LDO1]	= { .name = "LDO_REG1"},
+	[ACT8865_ID_LDO2]	= { .name = "LDO_REG2"},
+	[ACT8865_ID_LDO3]	= { .name = "LDO_REG3"},
+	[ACT8865_ID_LDO4]	= { .name = "LDO_REG4"},
+};
+
+static int act8865_pdata_from_dt(struct device *dev,
+				 struct device_node **of_node,
+				 struct act8865_platform_data *pdata)
+{
+	int matched, i;
+	struct device_node *np;
+	struct act8865_regulator_data *regulator;
+
+	np = of_find_node_by_name(dev->of_node, "regulators");
+	if (!np) {
+		dev_err(dev, "missing 'regulators' subnode in DT\n");
+		return -EINVAL;
+	}
+
+	matched = of_regulator_match(dev, np,
+				act8865_matches, ARRAY_SIZE(act8865_matches));
+	if (matched <= 0)
+		return matched;
+
+	pdata->regulators = devm_kzalloc(dev,
+				sizeof(struct act8865_regulator_data) * matched,
+				GFP_KERNEL);
+	if (!pdata->regulators) {
+		dev_err(dev, "%s: failed to allocate act8865 registor\n",
+						__func__);
+		return -ENOMEM;
+	}
+
+	pdata->num_regulators = matched;
+	regulator = pdata->regulators;
+
+	for (i = 0; i < matched; i++) {
+		if (!act8865_matches[i].init_data)
+			continue;
+
+		regulator->id = i;
+		regulator->name = act8865_matches[i].name;
+		regulator->platform_data = act8865_matches[i].init_data;
+		of_node[i] = act8865_matches[i].of_node;
+		regulator++;
+	}
+
+	return 0;
+}
+#else
+static inline int act8865_pdata_from_dt(struct device *dev,
+					struct device_node **of_node,
+					struct act8865_platform_data *pdata)
+{
+	return 0;
+}
+#endif
+
+static int act8865_pmic_probe(struct i2c_client *client,
+			   const struct i2c_device_id *i2c_id)
+{
+	struct regulator_dev **rdev;
+	struct device *dev = &client->dev;
+	struct act8865_platform_data *pdata = dev_get_platdata(dev);
+	struct regulator_config config = { };
+	struct act8865 *act8865;
+	struct device_node *of_node[ACT8865_REG_NUM];
+	int i, id;
+	int ret = -EINVAL;
+	int error;
+
+	if (dev->of_node && !pdata) {
+		const struct of_device_id *id;
+		struct act8865_platform_data pdata_of;
+
+		id = of_match_device(of_match_ptr(act8865_dt_ids), dev);
+		if (!id)
+			return -ENODEV;
+
+		ret = act8865_pdata_from_dt(dev, of_node, &pdata_of);
+		if (ret < 0)
+			return ret;
+
+		pdata = &pdata_of;
+	}
+
+	if (pdata->num_regulators > ACT8865_REG_NUM) {
+		dev_err(dev, "Too many regulators found!\n");
+		return -EINVAL;
+	}
+
+	act8865 = devm_kzalloc(dev, sizeof(struct act8865) +
+			sizeof(struct regulator_dev *) * ACT8865_REG_NUM,
+			GFP_KERNEL);
+	if (!act8865)
+		return -ENOMEM;
+
+	rdev = act8865->rdev;
+
+	act8865->regmap = devm_regmap_init_i2c(client, &act8865_regmap_config);
+	if (IS_ERR(act8865->regmap)) {
+		error = PTR_ERR(act8865->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			error);
+		return error;
+	}
+
+	/* Finally register devices */
+	for (i = 0; i < pdata->num_regulators; i++) {
+
+		id = pdata->regulators[i].id;
+
+		config.dev = dev;
+		config.init_data = pdata->regulators[i].platform_data;
+		config.of_node = of_node[i];
+		config.driver_data = act8865;
+		config.regmap = act8865->regmap;
+
+		rdev[i] = devm_regulator_register(&client->dev,
+						&act8865_reg[i], &config);
+		if (IS_ERR(rdev[i])) {
+			dev_err(dev, "failed to register %s\n",
+				act8865_reg[id].name);
+			return PTR_ERR(rdev[i]);
+		}
+	}
+
+	i2c_set_clientdata(client, act8865);
+
+	return 0;
+}
+
+static int act8865_pmic_remove(struct i2c_client *client)
+{
+	struct act8865 *act8865 = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < ACT8865_REG_NUM; i++)
+		regulator_unregister(act8865->rdev[i]);
+
+	return 0;
+}
+
+static const struct i2c_device_id act8865_ids[] = {
+	{ "act8865", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, act8865_ids);
+
+static struct i2c_driver act8865_pmic_driver = {
+	.driver	= {
+		.name	= "act8865",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= act8865_pmic_probe,
+	.remove		= act8865_pmic_remove,
+	.id_table	= act8865_ids,
+};
+
+module_i2c_driver(act8865_pmic_driver);
+
+MODULE_DESCRIPTION("active-semi act8865 voltage regulator driver");
+MODULE_AUTHOR("Wenyou Yang <wenyou.yang@atmel.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/act8865.h b/include/linux/regulator/act8865.h
new file mode 100644
index 0000000..49206c1
--- /dev/null
+++ b/include/linux/regulator/act8865.h
@@ -0,0 +1,53 @@
+/*
+ * act8865.h  --  Voltage regulation for the active-semi act8865
+ *
+ * Copyright (C) 2013 Atmel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_REGULATOR_ACT8865_H
+#define __LINUX_REGULATOR_ACT8865_H
+
+#include <linux/regulator/machine.h>
+
+enum {
+	ACT8865_ID_DCDC1,
+	ACT8865_ID_DCDC2,
+	ACT8865_ID_DCDC3,
+	ACT8865_ID_LDO1,
+	ACT8865_ID_LDO2,
+	ACT8865_ID_LDO3,
+	ACT8865_ID_LDO4,
+	ACT8865_REG_NUM,
+};
+
+/**
+ * act8865_regulator_data - regulator data
+ * @id: regulator id
+ * @name: regulator name
+ * @platform_data: regulator init data
+ */
+struct act8865_regulator_data {
+	int id;
+	const char *name;
+	struct regulator_init_data *platform_data;
+};
+
+/**
+ * act8865_platform_data - platform data for act8865
+ * @num_regulators: number of regulators used
+ * @regulators: pointer to regulators used
+ */
+struct act8865_platform_data {
+	int num_regulators;
+	struct act8865_regulator_data *regulators;
+};
+#endif
-- 
1.7.9.5

