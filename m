Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaEZJ6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:58:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36958 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaEZJ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:58:17 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 5/5] regulator: tps65917: Add Regulator driver for tps65917 PMIC
Date: Mon, 26 May 2014 15:26:37 +0530
Message-ID: <1401098197-647-6-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401098197-647-1-git-send-email-j-keerthy@ti.com>
References: <1401098197-647-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for TPS65917 PMIC regulators.

The regulators set consists of 5 SMPSs and 5 LDOs. The output
voltages are configurable and are meant to supply power to the
main processor and other components.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/regulator/Kconfig              |   12 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65917-regulator.c |  815 ++++++++++++++++++++++++++++++++
 3 files changed, 828 insertions(+)
 create mode 100644 drivers/regulator/tps65917-regulator.c

Index: linux/drivers/regulator/Kconfig
===================================================================
--- linux.orig/drivers/regulator/Kconfig	2014-05-26 15:21:12.269247638 +0530
+++ linux/drivers/regulator/Kconfig	2014-05-26 15:21:46.956121138 +0530
@@ -581,6 +581,18 @@
 	help
 	    This driver supports TPS65912 voltage regulator chip.
 
+config REGULATOR_TPS65917
+	tristate "TI TPS65917 PMIC Regulators"
+	depends on MFD_PALMAS
+	help
+	  If you wish to control the regulators on the TPS65917 series of
+	  chips say Y here. This will enable support for all the software
+	  controllable SMPS/LDO regulators.
+
+	  The regulators available on TPS65917 series chips vary depending
+	  on the muxing. This is handled automatically in the driver by
+	  reading the mux info from OTP.
+
 config REGULATOR_TPS80031
 	tristate "TI TPS80031/TPS80032 power regualtor driver"
 	depends on MFD_TPS80031
Index: linux/drivers/regulator/Makefile
===================================================================
--- linux.orig/drivers/regulator/Makefile	2014-05-26 15:21:12.269247638 +0530
+++ linux/drivers/regulator/Makefile	2014-05-26 15:21:46.956121138 +0530
@@ -76,6 +76,7 @@
 obj-$(CONFIG_REGULATOR_TPS6586X) += tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
+obj-$(CONFIG_REGULATOR_TPS65917) += tps65917-regulator.o
 obj-$(CONFIG_REGULATOR_TPS80031) += tps80031-regulator.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o
Index: linux/drivers/regulator/tps65917-regulator.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/regulator/tps65917-regulator.c	2014-05-26 15:22:25.994853307 +0530
@@ -0,0 +1,814 @@
+/*
+ * Driver for Regulator part of TPS65917 PMIC
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether expressed or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License version 2 for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/mfd/palmas.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/regulator/of_regulator.h>
+
+static const struct regulator_linear_range smps_low_ranges[] = {
+	REGULATOR_LINEAR_RANGE(500000, 0x1, 0x6, 0),
+	REGULATOR_LINEAR_RANGE(510000, 0x7, 0x79, 10000),
+	REGULATOR_LINEAR_RANGE(1650000, 0x7A, 0x7f, 0),
+};
+
+static const struct regulator_linear_range smps_high_ranges[] = {
+	REGULATOR_LINEAR_RANGE(1000000, 0x1, 0x6, 0),
+	REGULATOR_LINEAR_RANGE(1020000, 0x7, 0x79, 20000),
+	REGULATOR_LINEAR_RANGE(3300000, 0x7A, 0x7f, 0),
+};
+
+struct regs_info {
+	char	*name;
+	char	*sname;
+	u8	vsel_addr;
+	u8	ctrl_addr;
+	int	sleep_id;
+};
+
+static const struct regs_info tps65917_regs_info[] = {
+	{
+		.name		= "SMPS1",
+		.sname		= "smps1-in",
+		.vsel_addr	= TPS65917_SMPS1_VOLTAGE,
+		.ctrl_addr	= TPS65917_SMPS1_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_SMPS1,
+	},
+	{
+		.name		= "SMPS2",
+		.sname		= "smps2-in",
+		.vsel_addr	= TPS65917_SMPS2_VOLTAGE,
+		.ctrl_addr	= TPS65917_SMPS2_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_SMPS2,
+	},
+	{
+		.name		= "SMPS3",
+		.sname		= "smps3-in",
+		.vsel_addr	= TPS65917_SMPS3_VOLTAGE,
+		.ctrl_addr	= TPS65917_SMPS3_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_SMPS3,
+	},
+	{
+		.name		= "SMPS4",
+		.sname		= "smps4-in",
+		.vsel_addr	= TPS65917_SMPS4_VOLTAGE,
+		.ctrl_addr	= TPS65917_SMPS4_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_SMPS4,
+	},
+	{
+		.name		= "SMPS5",
+		.sname		= "smps5-in",
+		.vsel_addr	= TPS65917_SMPS5_VOLTAGE,
+		.ctrl_addr	= TPS65917_SMPS5_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_SMPS5,
+	},
+	{
+		.name		= "LDO1",
+		.sname		= "ldo1-in",
+		.vsel_addr	= TPS65917_LDO1_VOLTAGE,
+		.ctrl_addr	= TPS65917_LDO1_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_LDO1,
+	},
+	{
+		.name		= "LDO2",
+		.sname		= "ldo2-in",
+		.vsel_addr	= TPS65917_LDO2_VOLTAGE,
+		.ctrl_addr	= TPS65917_LDO2_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_LDO2,
+	},
+	{
+		.name		= "LDO3",
+		.sname		= "ldo3-in",
+		.vsel_addr	= TPS65917_LDO3_VOLTAGE,
+		.ctrl_addr	= TPS65917_LDO3_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_LDO3,
+	},
+	{
+		.name		= "LDO4",
+		.sname		= "ldo4-in",
+		.vsel_addr	= TPS65917_LDO4_VOLTAGE,
+		.ctrl_addr	= TPS65917_LDO4_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_LDO4,
+	},
+	{
+		.name		= "LDO5",
+		.sname		= "ldo5-in",
+		.vsel_addr	= TPS65917_LDO5_VOLTAGE,
+		.ctrl_addr	= TPS65917_LDO5_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_LDO5,
+	},
+	{
+		.name		= "REGEN1",
+		.ctrl_addr	= TPS65917_REGEN1_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_REGEN1,
+	},
+	{
+		.name		= "REGEN2",
+		.ctrl_addr	= TPS65917_REGEN2_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_REGEN2,
+	},
+	{
+		.name		= "REGEN3",
+		.ctrl_addr	= TPS65917_REGEN3_CTRL,
+		.sleep_id	= TPS65917_EXTERNAL_REQSTR_ID_REGEN3,
+	},
+};
+
+#define SMPS_CTRL_MODE_OFF		0x00
+#define SMPS_CTRL_MODE_ON		0x01
+#define SMPS_CTRL_MODE_ECO		0x02
+#define SMPS_CTRL_MODE_PWM		0x03
+
+#define PALMAS_SMPS_NUM_VOLTAGES	122
+#define PALMAS_LDO_NUM_VOLTAGES		50
+
+#define REGULATOR_SLAVE			0
+
+static int tps65917_smps_read(struct palmas *palmas, unsigned int reg,
+			      unsigned int *dest)
+{
+	unsigned int addr;
+
+	addr = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, reg);
+
+	return regmap_read(palmas->regmap[REGULATOR_SLAVE], addr, dest);
+}
+
+static int tps65917_smps_write(struct palmas *palmas, unsigned int reg,
+			       unsigned int value)
+{
+	unsigned int addr;
+
+	addr = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, reg);
+
+	return regmap_write(palmas->regmap[REGULATOR_SLAVE], addr, value);
+}
+
+static int tps65917_ldo_read(struct palmas *palmas, unsigned int reg,
+			     unsigned int *dest)
+{
+	unsigned int addr;
+
+	addr = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE, reg);
+
+	return regmap_read(palmas->regmap[REGULATOR_SLAVE], addr, dest);
+}
+
+static int tps65917_ldo_write(struct palmas *palmas, unsigned int reg,
+			      unsigned int value)
+{
+	unsigned int addr;
+
+	addr = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE, reg);
+
+	return regmap_write(palmas->regmap[REGULATOR_SLAVE], addr, value);
+}
+
+static int tps65917_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+	bool rail_enable = true;
+
+	tps65917_smps_read(pmic->palmas, tps65917_regs_info[id].ctrl_addr,
+			   &reg);
+	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+
+	if (reg == SMPS_CTRL_MODE_OFF)
+		rail_enable = false;
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		reg |= SMPS_CTRL_MODE_ON;
+		break;
+	case REGULATOR_MODE_IDLE:
+		reg |= SMPS_CTRL_MODE_ECO;
+		break;
+	case REGULATOR_MODE_FAST:
+		reg |= SMPS_CTRL_MODE_PWM;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pmic->current_reg_mode[id] = reg & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+	if (rail_enable)
+		tps65917_smps_write(pmic->palmas,
+				    tps65917_regs_info[id].ctrl_addr, reg);
+	return 0;
+}
+
+static unsigned int tps65917_get_mode_smps(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	reg = pmic->current_reg_mode[id] & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+
+	switch (reg) {
+	case SMPS_CTRL_MODE_ON:
+		return REGULATOR_MODE_NORMAL;
+	case SMPS_CTRL_MODE_ECO:
+		return REGULATOR_MODE_IDLE;
+	case SMPS_CTRL_MODE_PWM:
+		return REGULATOR_MODE_FAST;
+	}
+
+	return 0;
+}
+
+static struct regulator_ops tps65917_ops_smps = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.set_mode		= tps65917_set_mode_smps,
+	.get_mode		= tps65917_get_mode_smps,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+};
+
+static struct regulator_ops tps65917_ops_ext_control_smps = {
+	.set_mode		= tps65917_set_mode_smps,
+	.get_mode		= tps65917_get_mode_smps,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+};
+
+static int tps65917_is_enabled_ldo(struct regulator_dev *dev)
+{
+	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
+	int id = rdev_get_id(dev);
+	unsigned int reg;
+
+	tps65917_ldo_read(pmic->palmas, tps65917_regs_info[id].ctrl_addr,
+			  &reg);
+
+	reg &= TPS65917_LDO1_CTRL_STATUS;
+
+	return !!(reg);
+}
+
+static struct regulator_ops tps65917_ops_ldo = {
+	.is_enabled		= tps65917_is_enabled_ldo,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+};
+
+static struct regulator_ops tps65917_ops_ext_control_ldo = {
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+};
+
+static struct regulator_ops tps65917_ops_extreg = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+};
+
+static struct regulator_ops tps65917_ops_ext_control_extreg = {
+};
+
+static int tps65917_regulator_config_external(struct palmas *palmas, int id,
+					      struct palmas_reg_init *reg_init)
+{
+	int sleep_id = tps65917_regs_info[id].sleep_id;
+	int ret;
+
+	ret = palmas_ext_control_req_config(palmas, sleep_id,
+					    reg_init->roof_floor, true);
+	if (ret < 0)
+		dev_err(palmas->dev,
+			"Ext control config for regulator %d failed %d\n",
+			id, ret);
+	return ret;
+}
+
+/*
+ * setup the hardware based sleep configuration of the SMPS/LDO regulators
+ * from the platform data. This is different to the software based control
+ * supported by the regulator framework as it is controlled by toggling
+ * pins on the PMIC such as PREQ, SYSEN, ...
+ */
+static int tps65917_smps_init(struct palmas *palmas, int id,
+			      struct palmas_reg_init *reg_init)
+{
+	unsigned int reg;
+	unsigned int addr;
+	int ret;
+
+	addr = tps65917_regs_info[id].ctrl_addr;
+
+	ret = tps65917_smps_read(palmas, addr, &reg);
+	if (ret)
+		return ret;
+
+	if (reg_init->warm_reset)
+		reg |= PALMAS_SMPS12_CTRL_WR_S;
+	else
+		reg &= ~PALMAS_SMPS12_CTRL_WR_S;
+
+	if (reg_init->roof_floor)
+		reg |= PALMAS_SMPS12_CTRL_ROOF_FLOOR_EN;
+	else
+		reg &= ~PALMAS_SMPS12_CTRL_ROOF_FLOOR_EN;
+
+	reg &= ~PALMAS_SMPS12_CTRL_MODE_SLEEP_MASK;
+	if (reg_init->mode_sleep)
+		reg |= reg_init->mode_sleep <<
+				PALMAS_SMPS12_CTRL_MODE_SLEEP_SHIFT;
+
+
+	ret = tps65917_smps_write(palmas, addr, reg);
+	if (ret)
+		return ret;
+
+	if (tps65917_regs_info[id].vsel_addr && reg_init->vsel) {
+		addr = tps65917_regs_info[id].vsel_addr;
+
+		reg = reg_init->vsel;
+
+		ret = tps65917_smps_write(palmas, addr, reg);
+		if (ret)
+			return ret;
+	}
+
+	if (reg_init->roof_floor) {
+		/* Enable externally controlled regulator */
+		addr = tps65917_regs_info[id].ctrl_addr;
+		ret = tps65917_smps_read(palmas, addr, &reg);
+		if (ret < 0)
+			return ret;
+
+		if (!(reg & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK)) {
+			reg |= SMPS_CTRL_MODE_ON;
+			ret = tps65917_smps_write(palmas, addr, reg);
+			if (ret < 0)
+				return ret;
+		}
+		return tps65917_regulator_config_external(palmas, id,
+							  reg_init);
+	}
+	return 0;
+}
+
+static int tps65917_ldo_init(struct palmas *palmas, int id,
+			     struct palmas_reg_init *reg_init)
+{
+	unsigned int reg;
+	unsigned int addr;
+	int ret;
+
+	addr = tps65917_regs_info[id].ctrl_addr;
+
+	ret = tps65917_ldo_read(palmas, addr, &reg);
+	if (ret)
+		return ret;
+
+	if (reg_init->warm_reset)
+		reg |= TPS65917_LDO1_CTRL_WR_S;
+	else
+		reg &= ~TPS65917_LDO1_CTRL_WR_S;
+
+	if (reg_init->mode_sleep)
+		reg |= TPS65917_LDO1_CTRL_MODE_SLEEP;
+	else
+		reg &= ~TPS65917_LDO1_CTRL_MODE_SLEEP;
+
+	ret = tps65917_ldo_write(palmas, addr, reg);
+	if (ret)
+		return ret;
+
+	if (reg_init->roof_floor) {
+		/* Enable externally controlled regulator */
+		addr = tps65917_regs_info[id].ctrl_addr;
+		ret = palmas_update_bits(palmas, PALMAS_LDO_BASE,
+					 addr, PALMAS_LDO1_CTRL_MODE_ACTIVE,
+					 PALMAS_LDO1_CTRL_MODE_ACTIVE);
+		if (ret < 0) {
+			dev_err(palmas->dev,
+				"LDO Register 0x%02x update failed %d\n",
+				addr, ret);
+			return ret;
+		}
+		return tps65917_regulator_config_external(palmas, id,
+							  reg_init);
+	}
+	return 0;
+}
+
+static int tps65917_extreg_init(struct palmas *palmas, int id,
+				struct palmas_reg_init *reg_init)
+{
+	unsigned int addr;
+	int ret;
+	unsigned int val = 0;
+
+	addr = tps65917_regs_info[id].ctrl_addr;
+
+	if (reg_init->mode_sleep)
+		val = PALMAS_REGEN1_CTRL_MODE_SLEEP;
+
+	ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
+				 addr, PALMAS_REGEN1_CTRL_MODE_SLEEP, val);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Resource reg 0x%02x update failed %d\n",
+			addr, ret);
+		return ret;
+	}
+
+	if (reg_init->roof_floor) {
+		/* Enable externally controlled regulator */
+		addr = tps65917_regs_info[id].ctrl_addr;
+		ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
+					 addr, PALMAS_REGEN1_CTRL_MODE_ACTIVE,
+					 PALMAS_REGEN1_CTRL_MODE_ACTIVE);
+		if (ret < 0) {
+			dev_err(palmas->dev,
+				"Resource Register 0x%02x update failed %d\n",
+				addr, ret);
+			return ret;
+		}
+		return tps65917_regulator_config_external(palmas, id,
+							  reg_init);
+	}
+	return 0;
+}
+
+static struct of_regulator_match tps65917_matches[] = {
+	{ .name = "smps1", },
+	{ .name = "smps2", },
+	{ .name = "smps3", },
+	{ .name = "smps4", },
+	{ .name = "smps5", },
+	{ .name = "ldo1", },
+	{ .name = "ldo2", },
+	{ .name = "ldo3", },
+	{ .name = "ldo4", },
+	{ .name = "ldo5", },
+	{ .name = "regen1", },
+	{ .name = "regen2", },
+	{ .name = "regen3", },
+	{ .name = "sysen1", },
+	{ .name = "sysen2", },
+};
+
+static void tps65917_dt_to_pdata(struct device *dev,
+				 struct device_node *node,
+				 struct palmas_pmic_platform_data *pdata)
+{
+	struct device_node *regulators;
+	u32 prop;
+	int idx, ret;
+
+	node = of_node_get(node);
+	regulators = of_get_child_by_name(node, "regulators");
+	if (!regulators) {
+		dev_info(dev, "regulator node not found\n");
+		return;
+	}
+
+	ret = of_regulator_match(dev, regulators, tps65917_matches,
+				 TPS65917_NUM_REGS);
+	of_node_put(regulators);
+	if (ret < 0) {
+		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
+		return;
+	}
+
+	for (idx = 0; idx < TPS65917_NUM_REGS; idx++) {
+		if (!tps65917_matches[idx].init_data ||
+		    !tps65917_matches[idx].of_node)
+			continue;
+
+		pdata->reg_data[idx] = tps65917_matches[idx].init_data;
+
+		pdata->reg_init[idx] = devm_kzalloc(dev,
+						    sizeof(struct palmas_reg_init), GFP_KERNEL);
+
+		pdata->reg_init[idx]->warm_reset =
+			of_property_read_bool(tps65917_matches[idx].of_node,
+					      "ti,warm-reset");
+
+		ret = of_property_read_u32(tps65917_matches[idx].of_node,
+					   "ti,roof-floor", &prop);
+		/* EINVAL: Property not found */
+		if (ret != -EINVAL) {
+			int econtrol;
+
+			/* use default value, when no value is specified */
+			econtrol = PALMAS_EXT_CONTROL_NSLEEP;
+			if (!ret) {
+				switch (prop) {
+				case 1:
+					econtrol = PALMAS_EXT_CONTROL_ENABLE1;
+					break;
+				case 2:
+					econtrol = PALMAS_EXT_CONTROL_ENABLE2;
+					break;
+				case 3:
+					econtrol = PALMAS_EXT_CONTROL_NSLEEP;
+					break;
+				default:
+					WARN_ON(1);
+					dev_warn(dev,
+						 "%s: Invalid roof-floor option: %u\n",
+						 tps65917_matches[idx].name, prop);
+					break;
+				}
+			}
+			pdata->reg_init[idx]->roof_floor = econtrol;
+		}
+
+		ret = of_property_read_u32(tps65917_matches[idx].of_node,
+					   "ti,mode-sleep", &prop);
+		if (!ret)
+			pdata->reg_init[idx]->mode_sleep = prop;
+
+		ret = of_property_read_bool(tps65917_matches[idx].of_node,
+					    "ti,smps-range");
+		if (ret)
+			pdata->reg_init[idx]->vsel =
+				PALMAS_SMPS12_VOLTAGE_RANGE;
+	}
+}
+
+static int tps65917_regulators_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct palmas_pmic_platform_data *pdata;
+	struct device_node *node = pdev->dev.of_node;
+	struct regulator_dev *rdev;
+	struct regulator_config config = { };
+	struct palmas_pmic *pmic;
+	struct palmas_reg_init *reg_init;
+	int id = 0, ret;
+	unsigned int addr, reg;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+
+	if (!pdata)
+		return -ENOMEM;
+
+	tps65917_dt_to_pdata(&pdev->dev, node, pdata);
+
+	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
+	if (!pmic)
+		return -ENOMEM;
+
+	pmic->dev = &pdev->dev;
+	pmic->palmas = palmas;
+	palmas->pmic = pmic;
+	platform_set_drvdata(pdev, pmic);
+
+	ret = tps65917_smps_read(palmas, PALMAS_SMPS_CTRL, &reg);
+	if (ret)
+		return ret;
+
+	if (reg & TPS65917_SMPS_CTRL_SMPS1_SMPS12_EN)
+		pmic->smps12 = 1;
+
+	config.regmap = palmas->regmap[REGULATOR_SLAVE];
+	config.dev = &pdev->dev;
+	config.driver_data = pmic;
+
+	for (id = 0; id < TPS65917_REG_LDO1; id++) {
+		/*
+		 * Miss out regulators which are not available due
+		 * to slaving configurations.
+		 */
+		pmic->desc[id].n_linear_ranges = 3;
+		if ((id == TPS65917_REG_SMPS2) && pmic->smps12)
+			continue;
+
+		/* Initialise sleep/init values from platform data */
+		if (pdata && pdata->reg_init[id]) {
+			reg_init = pdata->reg_init[id];
+			ret = tps65917_smps_init(palmas, id, reg_init);
+			if (ret)
+				return ret;
+		} else {
+			reg_init = NULL;
+		}
+
+		/* Register the regulators */
+		pmic->desc[id].name = tps65917_regs_info[id].name;
+		pmic->desc[id].id = id;
+
+		/*
+		 * Read and store the RANGE bit for later use
+		 * This must be done before regulator is probed,
+		 * otherwise we error in probe with unsupportable
+		 * ranges. Read the current smps mode for later use.
+		 */
+		addr = tps65917_regs_info[id].vsel_addr;
+
+		ret = tps65917_smps_read(pmic->palmas, addr, &reg);
+		if (ret)
+			return ret;
+		if (reg & TPS65917_SMPS1_VOLTAGE_RANGE)
+			pmic->range[id] = 1;
+
+		if (pmic->range[id])
+				pmic->desc[id].linear_ranges = smps_high_ranges;
+			else
+				pmic->desc[id].linear_ranges = smps_low_ranges;
+
+
+		if (reg_init && reg_init->roof_floor)
+			pmic->desc[id].ops =
+					&tps65917_ops_ext_control_smps;
+		else
+			pmic->desc[id].ops = &tps65917_ops_smps;
+		pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
+		pmic->desc[id].vsel_reg =
+				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+						   tps65917_regs_info[id].vsel_addr);
+		pmic->desc[id].vsel_mask =
+				PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
+
+		pmic->desc[id].ramp_delay = 2500;
+
+		/* Read the smps mode for later use. */
+		addr = tps65917_regs_info[id].ctrl_addr;
+		ret = tps65917_smps_read(pmic->palmas, addr, &reg);
+		if (ret)
+			return ret;
+		pmic->current_reg_mode[id] = reg &
+				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+
+		pmic->desc[id].type = REGULATOR_VOLTAGE;
+		pmic->desc[id].owner = THIS_MODULE;
+
+		if (pdata)
+			config.init_data = pdata->reg_data[id];
+		else
+			config.init_data = NULL;
+
+		pmic->desc[id].supply_name = tps65917_regs_info[id].sname;
+		config.of_node = tps65917_matches[id].of_node;
+
+		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[id],
+					       &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
+			return PTR_ERR(rdev);
+		}
+
+		/* Save regulator for cleanup */
+		pmic->rdev[id] = rdev;
+	}
+
+	/* Start this loop from the id left from previous loop */
+	for (; id < TPS65917_NUM_REGS; id++) {
+		if (pdata && pdata->reg_init[id])
+			reg_init = pdata->reg_init[id];
+		else
+			reg_init = NULL;
+
+		/* Miss out regulators which are not available due
+		 * to alternate functions.
+		 */
+
+		/* Register the regulators */
+		pmic->desc[id].name = tps65917_regs_info[id].name;
+		pmic->desc[id].id = id;
+		pmic->desc[id].type = REGULATOR_VOLTAGE;
+		pmic->desc[id].owner = THIS_MODULE;
+
+		if (id < TPS65917_REG_REGEN1) {
+			pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
+			if (reg_init && reg_init->roof_floor)
+				pmic->desc[id].ops =
+					&tps65917_ops_ext_control_ldo;
+			else
+				pmic->desc[id].ops = &tps65917_ops_ldo;
+			pmic->desc[id].min_uV = 900000;
+			pmic->desc[id].uV_step = 50000;
+			pmic->desc[id].linear_min_sel = 1;
+			pmic->desc[id].enable_time = 500;
+			pmic->desc[id].vsel_reg =
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+							   tps65917_regs_info[id].vsel_addr);
+			pmic->desc[id].vsel_mask =
+					PALMAS_LDO1_VOLTAGE_VSEL_MASK;
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+							   tps65917_regs_info[id].ctrl_addr);
+			pmic->desc[id].enable_mask =
+					PALMAS_LDO1_CTRL_MODE_ACTIVE;
+			/*
+			 * To be confirmed. Discussion on going with PMIC Team.
+			 * It is of the order of ~60mV/uS.
+			 */
+			pmic->desc[id].ramp_delay = 2500;
+		} else {
+			pmic->desc[id].n_voltages = 1;
+			if (reg_init && reg_init->roof_floor)
+				pmic->desc[id].ops =
+					&tps65917_ops_ext_control_extreg;
+			else
+				pmic->desc[id].ops = &tps65917_ops_extreg;
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
+							   tps65917_regs_info[id].ctrl_addr);
+			pmic->desc[id].enable_mask =
+					PALMAS_REGEN1_CTRL_MODE_ACTIVE;
+		}
+
+		if (pdata)
+			config.init_data = pdata->reg_data[id];
+		else
+			config.init_data = NULL;
+
+		pmic->desc[id].supply_name = tps65917_regs_info[id].sname;
+		config.of_node = tps65917_matches[id].of_node;
+
+		rdev = devm_regulator_register(&pdev->dev, &pmic->desc[id],
+					       &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
+			return PTR_ERR(rdev);
+		}
+
+		/* Save regulator for cleanup */
+		pmic->rdev[id] = rdev;
+
+		/* Initialise sleep/init values from platform data */
+		if (pdata) {
+			reg_init = pdata->reg_init[id];
+			if (reg_init) {
+				if (id < TPS65917_REG_REGEN1)
+					ret = tps65917_ldo_init(palmas,
+								id, reg_init);
+				else
+					ret = tps65917_extreg_init(palmas,
+								   id, reg_init);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static struct of_device_id of_tps65917_match_tbl[] = {
+	{ .compatible = "ti,tps65917-pmic", },
+	{ },
+};
+
+static struct platform_driver tps65917_driver = {
+	.driver = {
+		.name = "tps65917-pmic",
+		.of_match_table = of_match_ptr(of_tps65917_match_tbl),
+		.owner = THIS_MODULE,
+	},
+	.probe = tps65917_regulators_probe,
+};
+
+module_platform_driver(tps65917_driver);
+
+MODULE_AUTHOR("J Keerthy <j-keerthy@ti.com>");
+MODULE_DESCRIPTION("TPS65917 voltage regulator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:tps65917-pmic");
+MODULE_DEVICE_TABLE(of, of_tps65917_match_tbl);
