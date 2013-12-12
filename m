Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LLBZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:25:04 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:60706 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300Ab3LLBY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:24:59 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <lgirdwood@gmail.com>
CC: <broonie@kernel.org>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <vpalatin@chromium.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <wenyou.yang@atmel.com>
Subject: [PATCH 1/3] regulator: act8865: add PMIC(Power Management IC) driver
Date: Thu, 12 Dec 2013 09:18:49 +0800
Message-ID: <1386811131-2720-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
References: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/regulator/Kconfig             |    7 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/act8865-regulator.c |  516 +++++++++++++++++++++++++++++++++
 include/linux/regulator/act8865.h     |   56 ++++
 4 files changed, 580 insertions(+)
 create mode 100644 drivers/regulator/act8865-regulator.c
 create mode 100644 include/linux/regulator/act8865.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ce785f4..e13bcf1 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -577,5 +577,12 @@ config REGULATOR_WM8994
 	  This driver provides support for the voltage regulators on the
 	  WM8994 CODEC.
 
+config REGULATOR_ACT8865
+	tristate "Active-semi act8865 voltage regulator"
+	depends on I2C
+	help
+	  This driver controls a active-semi act8865 voltage output
+	  regulator via I2C bus.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 01c597e..8bc485f 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
+obj-$(CONFIG_REGULATOR_ACT8865) += act8865-regulator.o
 
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
new file mode 100644
index 0000000..d616a28
--- /dev/null
+++ b/drivers/regulator/act8865-regulator.c
@@ -0,0 +1,516 @@
+/*
+ * act8865-regulator.c - Voltage regulation for the active-semi ACT8865
+ * http://www.active-semi.com/sheets/ACT8865_Datasheet.pdf
+ *
+ * Copyright (C) 2013 Atmel Corporation
+ * Wenyou Yang <wenyou.yang@atmel.com>
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
+
+/*
+ * ACT8865 Global Register Map
+ */
+#define	ACT8865_SYS_MODE	0x00
+#define ACT8865_SYS_CTRL	0x01
+#define ACT8865_REG1_VSET1	0x20
+#define	ACT8865_REG1_VSET2	0x21
+#define	ACT8865_REG1_CTRL	0x22
+#define	ACT8865_REG2_VSET1	0x30
+#define	ACT8865_REG2_VSET2	0x31
+#define	ACT8865_REG2_CTRL	0x32
+#define	ACT8865_REG3_VSET1	0x40
+#define	ACT8865_REG3_VSET2	0x41
+#define	ACT8865_REG3_CTRL	0x42
+#define	ACT8865_REG4_VSET	0x50
+#define	ACT8865_REG4_CTRL	0x51
+#define	ACT8865_REG5_VSET	0x54
+#define	ACT8865_REG5_CTRL	0x55
+#define	ACT8865_REG6_VSET	0x60
+#define	ACT8865_REG6_CTRL	0x61
+#define	ACT8865_REG7_VSET	0x64
+#define	ACT8865_REG7_CTRL	0x65
+
+struct act8865_data {
+	u8	vsel_is_low:1;
+	struct i2c_client	*client;
+	struct regulator_dev	*rdev[];
+};
+
+/* ACt8865 voltage table */
+static const u32 act8865_voltages_table[] = {
+	600000,		625000,		650000,		675000,
+	700000,		725000,		750000,		775000,
+	800000,		825000,		850000,		875000,
+	900000,		925000,		950000,		975000,
+	1000000,	1025000,	1050000,	1075000,
+	1100000,	1125000,	1150000,	1175000,
+	1200000,	1250000,	1300000,	1350000,
+	1400000,	1450000,	1500000,	1550000,
+	1600000,	1650000,	1700000,	1750000,
+	1800000,	1850000,	1900000,	1950000,
+	2000000,	2050000,	2010000,	2150000,
+	2200000,	2250000,	2300000,	2350000,
+	2400000,	2500000,	2600000,	2700000,
+	2800000,	2900000,	3000000,	3100000,
+	3200000,	3300000,	3400000,	3500000,
+	3600000,	3700000,	3800000,	3900000,
+};
+
+static int act8865_read_reg(struct act8865_data *act8865, u8 reg)
+{
+	int ret = i2c_smbus_read_byte_data(act8865->client, reg);
+	if (ret > 0)
+		ret &= 0xff;
+
+	return ret;
+}
+
+static int act8865_write_reg(struct act8865_data *act8865, u8 reg, u8 value)
+{
+	return i2c_smbus_write_byte_data(act8865->client, reg, value);
+}
+
+/*
+ * operation functions
+ */
+
+static u32 act8865_ctrl_reg_addr(int id)
+{
+	u32	reg = 0;
+
+	switch (id) {
+	case ACT8865_ID_REG1:
+		reg = ACT8865_REG1_CTRL;
+		break;
+
+	case ACT8865_ID_REG2:
+		reg = ACT8865_REG2_CTRL;
+		break;
+
+	case ACT8865_ID_REG3:
+		reg = ACT8865_REG3_CTRL;
+		break;
+
+	case ACT8865_ID_REG4:
+		reg = ACT8865_REG4_CTRL;
+		break;
+
+	case ACT8865_ID_REG5:
+		reg = ACT8865_REG5_CTRL;
+		break;
+
+	case ACT8865_ID_REG6:
+		reg = ACT8865_REG6_CTRL;
+		break;
+
+	case ACT8865_ID_REG7:
+		reg = ACT8865_REG7_CTRL;
+		break;
+	};
+
+	return reg;
+}
+
+static u32 act8865_vset_reg_addr(struct act8865_data *act8865, int id)
+{
+	u32	reg = 0;
+
+	switch (id) {
+	case ACT8865_ID_REG1:
+		if (act8865->vsel_is_low)
+			reg = ACT8865_REG1_VSET1;
+		else
+			reg = ACT8865_REG1_VSET2;
+		break;
+
+	case ACT8865_ID_REG2:
+		if (act8865->vsel_is_low)
+			reg = ACT8865_REG2_VSET1;
+		else
+			reg = ACT8865_REG2_VSET2;
+		break;
+
+	case ACT8865_ID_REG3:
+		if (act8865->vsel_is_low)
+			reg = ACT8865_REG3_VSET1;
+		else
+			reg = ACT8865_REG3_VSET2;
+		break;
+
+	case ACT8865_ID_REG4:
+		reg = ACT8865_REG4_VSET;
+		break;
+
+	case ACT8865_ID_REG5:
+		reg = ACT8865_REG5_VSET;
+		break;
+
+	case ACT8865_ID_REG6:
+		reg = ACT8865_REG6_VSET;
+		break;
+
+	case ACT8865_ID_REG7:
+		reg = ACT8865_REG7_VSET;
+		break;
+	};
+
+	return reg;
+}
+
+static int act88665_is_enabled(struct regulator_dev *rdev)
+{
+	struct act8865_data *act8865 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	u32	reg;
+	u8	mask = 0x80;
+
+	reg = act8865_ctrl_reg_addr(id);
+
+	return (act8865_read_reg(act8865, reg) & mask) == mask;
+}
+
+static int act8865_enable(struct regulator_dev *rdev)
+{
+	struct act8865_data *act8865 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	u32	reg;
+	u8	val;
+	u8	mask = 0x80;
+
+	reg = act8865_ctrl_reg_addr(id);
+	val = act8865_read_reg(act8865, reg);
+	val |= mask;
+
+	return act8865_write_reg(act8865, reg, val);
+}
+
+static int act8865_disable(struct regulator_dev *rdev)
+{
+	struct act8865_data *act8865 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	u32	reg;
+	u8	val;
+	u8	mask = 0x80;
+
+	reg = act8865_ctrl_reg_addr(id);
+	val = act8865_read_reg(act8865, reg);
+	val &= ~mask;
+
+	return act8865_write_reg(act8865, reg, val);
+}
+
+static int act8865_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct act8865_data *act8865 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	u32	reg = act8865_vset_reg_addr(act8865, id);
+
+	return act8865_read_reg(act8865, reg);
+}
+
+static int act8865_set_voltage_sel(struct regulator_dev *rdev, u32 selector)
+{
+	struct act8865_data *act8865 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	u32	reg = act8865_vset_reg_addr(act8865, id);
+
+	return act8865_write_reg(act8865, reg, selector);
+}
+
+static int act8865_set_suspend_voltage(struct regulator_dev *rdev, int uV)
+{
+	struct act8865_data *act8865 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	u32	reg = act8865_vset_reg_addr(act8865, id);
+	u32	selector;
+
+	pr_info("%s: suspend voltage %dmV\n", rdev->desc->name, uV / 1000);
+
+	selector = regulator_map_voltage_iterate(rdev, uV, uV);
+
+	return act8865_write_reg(act8865, reg, selector);
+}
+
+static struct regulator_ops act8865_ops = {
+	.list_voltage		= regulator_list_voltage_table,
+	.set_voltage_sel	= act8865_set_voltage_sel,
+	.get_voltage_sel	= act8865_get_voltage_sel,
+	.enable			= act8865_enable,
+	.disable		= act8865_disable,
+	.is_enabled		= act88665_is_enabled,
+	.set_suspend_voltage	= act8865_set_suspend_voltage,
+	.set_suspend_enable	= act8865_enable,
+	.set_suspend_disable	= act8865_disable,
+};
+
+static const struct regulator_desc act8865_reg[] = {
+	{
+		.name = "DCDC_REG1",
+		.id = ACT8865_ID_REG1,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "DCDC_REG2",
+		.id = ACT8865_ID_REG2,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "DCDC_REG3",
+		.id = ACT8865_ID_REG3,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG4",
+		.id = ACT8865_ID_REG4,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG5",
+		.id = ACT8865_ID_REG5,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG6",
+		.id = ACT8865_ID_REG6,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO_REG7",
+		.id = ACT8865_ID_REG7,
+		.ops = &act8865_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = ARRAY_SIZE(act8865_voltages_table),
+		.volt_table = act8865_voltages_table,
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
+static int act8865_pdata_from_dt(struct device *dev,
+				 struct device_node **of_node,
+				 struct act8865_platform_data *pdata)
+{
+	int matched, i;
+	struct device_node *np;
+	struct act8865_regulator_data *regulator;
+	struct of_regulator_match rmatch[ARRAY_SIZE(act8865_reg)];
+
+	if (of_find_property(dev->of_node, "vsel-state-low", NULL))
+		pdata->vsel_is_low = 1;
+
+	np = of_find_node_by_name(dev->of_node, "regulators");
+	if (!np) {
+		dev_err(dev, "missing 'regulators' subnode in DT\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(rmatch); i++)
+		rmatch[i].name = act8865_reg[i].name;
+
+	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(rmatch));
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
+		regulator->id = i;
+		regulator->name = rmatch[i].name;
+		regulator->platform_data = rmatch[i].init_data;
+		of_node[i] = rmatch[i].of_node;
+		regulator++;
+	}
+
+	return 0;
+}
+
+#else
+
+static inline int act8865_pdata_from_dt(struct device *dev,
+					struct device_node **of_node,
+					struct act8865_platform_data *pdata)
+{
+	return 0;
+}
+#endif
+
+static int act8865_pmu_probe(struct i2c_client *client,
+			   const struct i2c_device_id *i2c_id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct regulator_dev **rdev;
+	struct device *dev = &client->dev;
+	struct act8865_platform_data *pdata = dev_get_platdata(dev);
+	struct regulator_config config = { };
+	struct act8865_data *act8865;
+	int i, id;
+	int ret = -EINVAL;
+	struct device_node *of_node[ACT8865_REG_NUM];
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
+		return -EIO;
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
+	} else {
+		memset(of_node, 0, sizeof(of_node));
+	}
+
+	if (pdata->num_regulators > ACT8865_REG_NUM) {
+		dev_err(dev, "Too many regulators found!\n");
+		return -EINVAL;
+	}
+
+	act8865 = devm_kzalloc(dev, sizeof(struct act8865_data) +
+			sizeof(struct regulator_dev *) * ACT8865_REG_NUM,
+			GFP_KERNEL);
+	if (!act8865)
+		return -ENOMEM;
+
+	act8865->client = client;
+	act8865->vsel_is_low = pdata->vsel_is_low;
+	rdev = act8865->rdev;
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
+
+		rdev[i] = regulator_register(&act8865_reg[id], &config);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(dev, "failed to register %s\n",
+				act8865_reg[id].name);
+			goto err_unregister;
+		}
+	}
+
+	i2c_set_clientdata(client, act8865);
+
+	return 0;
+
+err_unregister:
+	while (--i >= 0)
+		regulator_unregister(rdev[i]);
+
+	return ret;
+}
+
+static int act8865_pmu_remove(struct i2c_client *client)
+{
+	struct act8865_data *act8865 = i2c_get_clientdata(client);
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
+static struct i2c_driver act8865_pmu_driver = {
+	.probe		= act8865_pmu_probe,
+	.remove		= act8865_pmu_remove,
+	.driver		= {
+		.name	= "act8865",
+		.owner	= THIS_MODULE,
+	},
+	.id_table	= act8865_ids,
+};
+
+static int __init act8865_pmu_init(void)
+{
+	return i2c_add_driver(&act8865_pmu_driver);
+}
+subsys_initcall(act8865_pmu_init);
+
+static void __exit act8865_pmu_exit(void)
+{
+	i2c_del_driver(&act8865_pmu_driver);
+}
+module_exit(act8865_pmu_exit);
+
+MODULE_DESCRIPTION("active-semi act8865 voltage regulator driver");
+MODULE_AUTHOR("Wenyou Yang <wenyou.yang@atmel.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/act8865.h b/include/linux/regulator/act8865.h
new file mode 100644
index 0000000..202544f
--- /dev/null
+++ b/include/linux/regulator/act8865.h
@@ -0,0 +1,56 @@
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
+	ACT8865_ID_REG1,
+	ACT8865_ID_REG2,
+	ACT8865_ID_REG3,
+	ACT8865_ID_REG4,
+	ACT8865_ID_REG5,
+	ACT8865_ID_REG6,
+	ACT8865_ID_REG7,
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
+	int				id;
+	const char				*name;
+	struct regulator_init_data	*platform_data;
+};
+
+/**
+ * act8865_platform_data - platform data for act8865
+ * @num_regulators: number of regulators used
+ * @regulators: pointer to regulators used
+ * @vsel_is_low: VSEL pin, drive to logic low to select default output voltage,
+ *			drive to logic high to select secondary output voltage.
+ */
+struct act8865_platform_data {
+	int num_regulators;
+	struct act8865_regulator_data *regulators;
+	unsigned vsel_is_low:1;
+};
+#endif
-- 
1.7.9.5

