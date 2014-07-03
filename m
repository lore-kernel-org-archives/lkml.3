Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaGCHbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:31:40 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:18264 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757334AbaGCHbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:31:34 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-7.tower-38.messagelabs.com!1404372660!28638167!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201407030730.s637UuCh011846@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Thu, 3 Jul 2014 16:29:03 +0900
Subject: [PATCH V4] regulator: DA9211 : new regulator driver
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
Converter regulator. It communicates via an I2C bus to the device.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140630.

Changes in V4:
- Stripped out the suspend and GPIO handling.

Changes in V3:
- Removed voltage selection in the da9211_regulator_set_suspend_voltage.

Changes in V2:
- Removed the redundant interrupt code.

 drivers/regulator/Kconfig            |   10 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9211-regulator.c |  392 ++++++++++++++++++++++++++++++++++
 drivers/regulator/da9211-regulator.h |  271 +++++++++++++++++++++++
 include/linux/regulator/da9211.h     |   32 +++
 5 files changed, 706 insertions(+)
 create mode 100644 drivers/regulator/da9211-regulator.c
 create mode 100644 drivers/regulator/da9211-regulator.h
 create mode 100644 include/linux/regulator/da9211.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 789eb46..f5040fc 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -198,6 +198,16 @@ config REGULATOR_DA9210
 	  converter 12A DC-DC Buck controlled through an I2C
 	  interface.
 
+config REGULATOR_DA9211
+	tristate "Dialog Semiconductor DA9211/DA9212 regulator"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  Say y here to support for the Dialog Semiconductor DA9211/DA9212.
+	  The DA9211/DA9212 is a multi-phase synchronous step down
+	  converter 12A DC-DC Buck controlled through an I2C
+	  interface.
+
 config REGULATOR_DBX500_PRCMU
 	bool
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d461110..aa4a6aa 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DA9055)	+= da9055-regulator.o
 obj-$(CONFIG_REGULATOR_DA9063)	+= da9063-regulator.o
 obj-$(CONFIG_REGULATOR_DA9210) += da9210-regulator.o
+obj-$(CONFIG_REGULATOR_DA9211) += da9211-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_FAN53555) += fan53555.o
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
new file mode 100644
index 0000000..ff694b4
--- /dev/null
+++ b/drivers/regulator/da9211-regulator.c
@@ -0,0 +1,392 @@
+/*
+ * da9211-regulator.c - Regulator device driver for DA9211
+ * Copyright (C) 2014  Dialog Semiconductor Ltd.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regmap.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/regulator/da9211.h>
+#include "da9211-regulator.h"
+
+#define DA9211_BUCK_MODE_SLEEP	1
+#define DA9211_BUCK_MODE_SYNC	2
+#define DA9211_BUCK_MODE_AUTO	3
+
+/* DA9211 REGULATOR IDs */
+#define DA9211_ID_BUCKA	0
+#define DA9211_ID_BUCKB	1
+
+struct da9211 {
+	struct device *dev;
+	struct regmap *regmap;
+	struct da9211_pdata *pdata;
+	struct regulator_dev *rdev[DA9211_MAX_REGULATORS];
+	int num_regulator;
+	int chip_irq;
+};
+
+static const struct regmap_config da9211_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+/* Default limits measured in millivolts and milliamps */
+#define DA9211_MIN_MV		300
+#define DA9211_MAX_MV		1570
+#define DA9211_STEP_MV		10
+
+/* Current limits for buck (uA) indices corresponds with register values */
+static const int da9211_current_limits[] = {
+	2000000, 2200000, 2400000, 2600000, 2800000, 3000000, 3200000, 3400000,
+	3600000, 3800000, 4000000, 4200000, 4400000, 4600000, 4800000, 5000000
+};
+
+static unsigned int da9211_buck_get_mode(struct regulator_dev *rdev)
+{
+	int id = rdev_get_id(rdev);
+	struct da9211 *chip = rdev_get_drvdata(rdev);
+	unsigned int data;
+	int ret, mode = 0;
+
+	ret = regmap_read(chip->regmap, DA9211_REG_BUCKA_CONF+id, &data);
+	if (ret < 0)
+		return ret;
+
+	switch (data & 0x03) {
+	case DA9211_BUCK_MODE_SYNC:
+		mode = REGULATOR_MODE_FAST;
+		break;
+	case DA9211_BUCK_MODE_AUTO:
+		mode = REGULATOR_MODE_NORMAL;
+		break;
+	case DA9211_BUCK_MODE_SLEEP:
+		mode = REGULATOR_MODE_STANDBY;
+		break;
+	}
+
+	return mode;
+}
+
+static int da9211_buck_set_mode(struct regulator_dev *rdev,
+					unsigned int mode)
+{
+	int id = rdev_get_id(rdev);
+	struct da9211 *chip = rdev_get_drvdata(rdev);
+	int val = 0;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = DA9211_BUCK_MODE_SYNC;
+		break;
+	case REGULATOR_MODE_NORMAL:
+		val = DA9211_BUCK_MODE_AUTO;
+		break;
+	case REGULATOR_MODE_STANDBY:
+		val = DA9211_BUCK_MODE_SLEEP;
+		break;
+	}
+
+	return regmap_update_bits(chip->regmap, DA9211_REG_BUCKA_CONF+id,
+					0x03, val);
+}
+
+static int da9211_set_current_limit(struct regulator_dev *rdev, int min,
+				    int max)
+{
+	int id = rdev_get_id(rdev);
+	struct da9211 *chip = rdev_get_drvdata(rdev);
+	int i;
+
+	/* search for closest to maximum */
+	for (i = ARRAY_SIZE(da9211_current_limits)-1; i >= 0; i--) {
+		if (min <= da9211_current_limits[i] &&
+		    max >= da9211_current_limits[i]) {
+				return regmap_update_bits(chip->regmap,
+					DA9211_REG_BUCK_ILIM,
+					(0x0F << id*4), (i << id*4));
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int da9211_get_current_limit(struct regulator_dev *rdev)
+{
+	int id = rdev_get_id(rdev);
+	struct da9211 *chip = rdev_get_drvdata(rdev);
+	unsigned int data;
+	int ret;
+
+	ret = regmap_read(chip->regmap, DA9211_REG_BUCK_ILIM, &data);
+	if (ret < 0)
+		return ret;
+
+	/* select one of 16 values: 0000 (2000mA) to 1111 (5000mA) */
+	data = (data >> id*4) & 0x0F;
+	return da9211_current_limits[data];
+}
+
+static struct regulator_ops da9211_buck_ops = {
+	.get_mode = da9211_buck_get_mode,
+	.set_mode = da9211_buck_set_mode,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.list_voltage = regulator_list_voltage_linear,
+	.set_current_limit = da9211_set_current_limit,
+	.get_current_limit = da9211_get_current_limit,
+};
+
+#define DA9211_BUCK(_id) \
+{\
+	.name = #_id,\
+	.ops = &da9211_buck_ops,\
+	.type = REGULATOR_VOLTAGE,\
+	.id = DA9211_ID_##_id,\
+	.n_voltages = (DA9211_MAX_MV - DA9211_MIN_MV) / DA9211_STEP_MV + 1,\
+	.min_uV = (DA9211_MIN_MV * 1000),\
+	.uV_step = (DA9211_STEP_MV * 1000),\
+	.enable_reg = DA9211_REG_BUCKA_CONT + DA9211_ID_##_id,\
+	.enable_mask = 1,\
+	.vsel_reg = DA9211_REG_VBUCKA_A + DA9211_ID_##_id * 2,\
+	.vsel_mask = DA9211_VBUCK_MASK,\
+	.owner = THIS_MODULE,\
+}
+
+static struct regulator_desc da9211_regulators[] = {
+	DA9211_BUCK(BUCKA),
+	DA9211_BUCK(BUCKB),
+};
+
+static irqreturn_t da9211_irq_handler(int irq, void *data)
+{
+	struct da9211 *chip = data;
+	int reg_val, ret;
+
+	ret = regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
+	if (ret < 0)
+		goto error_i2c;
+
+	if (reg_val & DA9211_E_OV_CURR_A) {
+		regulator_notifier_call_chain(chip->rdev[0],
+			REGULATOR_EVENT_OVER_CURRENT,
+			rdev_get_drvdata(chip->rdev[0]));
+
+		ret = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
+			DA9211_E_OV_CURR_A);
+		if (ret < 0)
+			goto error_i2c;
+	}
+
+	if (reg_val & DA9211_E_OV_CURR_B) {
+		regulator_notifier_call_chain(chip->rdev[1],
+			REGULATOR_EVENT_OVER_CURRENT,
+			rdev_get_drvdata(chip->rdev[1]));
+
+		ret = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
+			DA9211_E_OV_CURR_B);
+		if (ret < 0)
+			goto error_i2c;
+	}
+
+	return IRQ_HANDLED;
+
+error_i2c:
+	dev_err(chip->dev, "I2C error : %d\n", ret);
+	return IRQ_NONE;
+}
+
+static int da9211_regulator_init(struct da9211 *chip)
+{
+	struct regulator_config config = { };
+	int i, ret;
+	unsigned int data;
+
+	ret = regmap_update_bits(chip->regmap, DA9211_REG_PAGE_CON,
+			DA9211_REG_PAGE_MASK, DA9211_REG_PAGE2);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to update PAGE reg: %d\n", ret);
+		goto err;
+	}
+
+	ret = regmap_read(chip->regmap, DA9211_REG_CONTROL_E, &data);
+	if (ret < 0) {
+		ret = regmap_update_bits(chip->regmap, DA9211_REG_PAGE_CON,
+			DA9211_REG_PAGE_MASK, DA9211_REG_PAGE0);
+		ret = -EINVAL;
+		dev_err(chip->dev, "Failed to read CONTROL_E reg: %d\n", ret);
+		goto err;
+	}
+
+	data &= DA9211_SLAVE_SEL;
+	/* If configuration for 1/2 bucks is different between platform data
+	 * and the register, driver should exit.
+	 */
+	if ((chip->pdata->num_buck == 2 && data == 0x40)
+		|| (chip->pdata->num_buck == 1 && data == 0x00)) {
+		if (data == 0)
+			chip->num_regulator = 1;
+		else
+			chip->num_regulator = 2;
+	} else {
+		ret = regmap_update_bits(chip->regmap, DA9211_REG_PAGE_CON,
+			DA9211_REG_PAGE_MASK, DA9211_REG_PAGE0);
+		ret = -EINVAL;
+		dev_err(chip->dev, "Configuration is mismatched\n");
+		goto err;
+	}
+
+	ret = regmap_update_bits(chip->regmap, DA9211_REG_PAGE_CON,
+			DA9211_REG_PAGE_MASK, DA9211_REG_PAGE0);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to update PAGE reg: %d\n", ret);
+		goto err;
+	}
+
+	for (i = 0; i < chip->num_regulator; i++) {
+		if (chip->pdata)
+			config.init_data =
+				&(chip->pdata->init_data[i]);
+
+		config.dev = chip->dev;
+		config.driver_data = chip;
+		config.regmap = chip->regmap;
+
+		chip->rdev[i] = regulator_register(&da9211_regulators[i],
+			&config);
+		if (IS_ERR(chip->rdev[i])) {
+			dev_err(chip->dev,
+				"Failed to register DA9211 regulator\n");
+			ret = PTR_ERR(chip->rdev[i]);
+			goto err_regulator;
+		}
+
+		if (chip->chip_irq != 0) {
+			ret = regmap_update_bits(chip->regmap,
+				DA9211_REG_MASK_B, DA9211_M_OV_CURR_A << i, 1);
+			if (ret < 0) {
+				dev_err(chip->dev,
+					"Failed to update mask reg: %d\n", ret);
+				goto err_regulator;
+			}
+		}
+	}
+
+	return 0;
+
+err_regulator:
+	while (--i >= 0)
+		regulator_unregister(chip->rdev[i]);
+err:
+	return ret;
+}
+/*
+ * I2C driver interface functions
+ */
+static int da9211_i2c_probe(struct i2c_client *i2c,
+		const struct i2c_device_id *id)
+{
+	struct da9211 *chip;
+	int error, ret;
+
+	chip = devm_kzalloc(&i2c->dev, sizeof(struct da9211), GFP_KERNEL);
+
+	chip->dev = &i2c->dev;
+	chip->regmap = devm_regmap_init_i2c(i2c, &da9211_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		error = PTR_ERR(chip->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			error);
+		return error;
+	}
+
+	i2c_set_clientdata(i2c, chip);
+
+	chip->pdata = i2c->dev.platform_data;
+	if (!chip->pdata) {
+		dev_err(&i2c->dev, "No platform init data supplied\n");
+		return -ENODEV;
+	}
+
+	chip->chip_irq = i2c->irq;
+
+	if (chip->chip_irq != 0) {
+		ret = request_threaded_irq(chip->chip_irq, NULL,
+					da9211_irq_handler,
+					IRQF_TRIGGER_LOW|IRQF_ONESHOT,
+					"da9211", chip);
+		if (ret != 0) {
+			dev_err(chip->dev, "Failed to request IRQ: %d\n",
+				chip->chip_irq);
+			return ret;
+		}
+		dev_info(chip->dev, "# IRQ configured [%d]\n", chip->chip_irq);
+	} else {
+		dev_warn(chip->dev, "No IRQ configured\n");
+	}
+
+	ret = da9211_regulator_init(chip);
+
+	if (ret < 0)
+		dev_err(&i2c->dev, "Failed to initialize regulator: %d\n", ret);
+
+	return ret;
+}
+
+static int da9211_i2c_remove(struct i2c_client *i2c)
+{
+	struct da9211 *chip = i2c_get_clientdata(i2c);
+	int i;
+
+	for (i = 0; i < chip->num_regulator; i++)
+		regulator_unregister(chip->rdev[i]);
+
+	if (chip->chip_irq != 0)
+		free_irq(chip->chip_irq, chip);
+
+	return 0;
+}
+
+static const struct i2c_device_id da9211_i2c_id[] = {
+	{"da9211", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, da9211_i2c_id);
+
+static struct i2c_driver da9211_regulator_driver = {
+	.driver = {
+		.name = "da9211",
+		.owner = THIS_MODULE,
+	},
+	.probe = da9211_i2c_probe,
+	.remove = da9211_i2c_remove,
+	.id_table = da9211_i2c_id,
+};
+
+module_i2c_driver(da9211_regulator_driver);
+
+MODULE_AUTHOR("James Ban <James.Ban.opensource@diasemi.com>");
+MODULE_DESCRIPTION("Regulator device driver for Dialog DA9211");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/regulator/da9211-regulator.h b/drivers/regulator/da9211-regulator.h
new file mode 100644
index 0000000..afba596
--- /dev/null
+++ b/drivers/regulator/da9211-regulator.h
@@ -0,0 +1,271 @@
+/*
+ * da9211-regulator.h - Regulator definitions for DA9211
+ * Copyright (C) 2014  Dialog Semiconductor Ltd.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ */
+
+#ifndef __DA9211_REGISTERS_H__
+#define __DA9211_REGISTERS_H__
+
+/* Page selection */
+#define	DA9211_REG_PAGE_CON			0x00
+
+/* System Control and Event Registers */
+#define	DA9211_REG_STATUS_A			0x50
+#define	DA9211_REG_STATUS_B			0x51
+#define	DA9211_REG_EVENT_A			0x52
+#define	DA9211_REG_EVENT_B			0x53
+#define	DA9211_REG_MASK_A			0x54
+#define	DA9211_REG_MASK_B			0x55
+#define	DA9211_REG_CONTROL_A		0x56
+
+/* GPIO Control Registers */
+#define	DA9211_REG_GPIO_0_1			0x58
+#define	DA9211_REG_GPIO_2_3			0x59
+#define	DA9211_REG_GPIO_4			0x5A
+
+/* Regulator Registers */
+#define	DA9211_REG_BUCKA_CONT			0x5D
+#define	DA9211_REG_BUCKB_CONT			0x5E
+#define	DA9211_REG_BUCK_ILIM			0xD0
+#define	DA9211_REG_BUCKA_CONF			0xD1
+#define	DA9211_REG_BUCKB_CONF			0xD2
+#define	DA9211_REG_BUCK_CONF			0xD3
+#define	DA9211_REG_VBACKA_MAX			0xD5
+#define	DA9211_REG_VBACKB_MAX			0xD6
+#define	DA9211_REG_VBUCKA_A				0xD7
+#define	DA9211_REG_VBUCKA_B				0xD8
+#define	DA9211_REG_VBUCKB_A				0xD9
+#define	DA9211_REG_VBUCKB_B				0xDA
+
+/* I2C Interface Settings */
+#define DA9211_REG_INTERFACE			(0x105 - 0x100)
+
+/* BUCK Phase Selection*/
+#define DA9211_REG_CONTROL_E			(0x147 - 0x100)
+
+/*
+ * Registers bits
+ */
+/* DA9211_REG_PAGE_CON (addr=0x00) */
+#define	DA9211_REG_PAGE_SHIFT			0
+#define	DA9211_REG_PAGE_MASK			0x0F
+/* On I2C registers 0x00 - 0xFF */
+#define	DA9211_REG_PAGE0			0
+/* On I2C registers 0x100 - 0x1FF */
+#define	DA9211_REG_PAGE2			2
+#define	DA9211_PAGE_WRITE_MODE			0x00
+#define	DA9211_REPEAT_WRITE_MODE		0x40
+#define	DA9211_PAGE_REVERT			0x80
+
+/* DA9211_REG_STATUS_A (addr=0x50) */
+#define	DA9211_GPI0				0x01
+#define	DA9211_GPI1				0x02
+#define	DA9211_GPI2				0x04
+#define	DA9211_GPI3				0x08
+#define	DA9211_GPI4				0x10
+
+/* DA9211_REG_EVENT_A (addr=0x52) */
+#define	DA9211_E_GPI0				0x01
+#define	DA9211_E_GPI1				0x02
+#define	DA9211_E_GPI2				0x04
+#define	DA9211_E_GPI3				0x08
+#define	DA9211_E_GPI4				0x10
+#define	DA9211_E_UVLO_IO			0x40
+
+/* DA9211_REG_EVENT_B (addr=0x53) */
+#define	DA9211_E_PWRGOOD_A			0x01
+#define	DA9211_E_PWRGOOD_B			0x02
+#define	DA9211_E_TEMP_WARN			0x04
+#define	DA9211_E_TEMP_CRIT			0x08
+#define	DA9211_E_OV_CURR_A			0x10
+#define	DA9211_E_OV_CURR_B			0x20
+
+/* DA9211_REG_MASK_A (addr=0x54) */
+#define	DA9211_M_GPI0				0x01
+#define	DA9211_M_GPI1				0x02
+#define	DA9211_M_GPI2				0x04
+#define	DA9211_M_GPI3				0x08
+#define	DA9211_M_GPI4				0x10
+#define	DA9211_M_UVLO_IO			0x40
+
+/* DA9211_REG_MASK_B (addr=0x55) */
+#define	DA9211_M_PWRGOOD_A			0x01
+#define	DA9211_M_PWRGOOD_B			0x02
+#define	DA9211_M_TEMP_WARN			0x04
+#define	DA9211_M_TEMP_CRIT			0x08
+#define	DA9211_M_OV_CURR_A			0x10
+#define	DA9211_M_OV_CURR_B			0x20
+
+/* DA9211_REG_CONTROL_A (addr=0x56) */
+#define	DA9211_DEBOUNCING_SHIFT		0
+#define	DA9211_DEBOUNCING_MASK		0x07
+#define	DA9211_SLEW_RATE_SHIFT		3
+#define	DA9211_SLEW_RATE_A_MASK		0x18
+#define	DA9211_SLEW_RATE_B_SHIFT	5
+#define	DA9211_SLEW_RATE_B_MASK		0x60
+#define	DA9211_V_LOCK				0x80
+
+/* DA9211_REG_GPIO_0_1 (addr=0x58) */
+#define	DA9211_GPIO0_PIN_SHIFT		0
+#define	DA9211_GPIO0_PIN_MASK		0x03
+#define	DA9211_GPIO0_PIN_GPI		0x00
+#define	DA9211_GPIO0_PIN_GPO_OD		0x02
+#define	DA9211_GPIO0_PIN_GPO		0x03
+#define	DA9211_GPIO0_TYPE			0x04
+#define	DA9211_GPIO0_TYPE_GPI		0x00
+#define	DA9211_GPIO0_TYPE_GPO		0x04
+#define	DA9211_GPIO0_MODE			0x08
+#define	DA9211_GPIO1_PIN_SHIFT		4
+#define	DA9211_GPIO1_PIN_MASK		0x30
+#define	DA9211_GPIO1_PIN_GPI		0x00
+#define	DA9211_GPIO1_PIN_VERROR		0x10
+#define	DA9211_GPIO1_PIN_GPO_OD		0x20
+#define	DA9211_GPIO1_PIN_GPO		0x30
+#define	DA9211_GPIO1_TYPE_SHIFT		0x40
+#define	DA9211_GPIO1_TYPE_GPI		0x00
+#define	DA9211_GPIO1_TYPE_GPO		0x40
+#define	DA9211_GPIO1_MODE			0x80
+
+/* DA9211_REG_GPIO_2_3 (addr=0x59) */
+#define	DA9211_GPIO2_PIN_SHIFT		0
+#define	DA9211_GPIO2_PIN_MASK		0x03
+#define	DA9211_GPIO2_PIN_GPI		0x00
+#define	DA9211_GPIO5_PIN_BUCK_CLK	0x10
+#define	DA9211_GPIO2_PIN_GPO_OD		0x02
+#define	DA9211_GPIO2_PIN_GPO		0x03
+#define	DA9211_GPIO2_TYPE			0x04
+#define	DA9211_GPIO2_TYPE_GPI		0x00
+#define	DA9211_GPIO2_TYPE_GPO		0x04
+#define	DA9211_GPIO2_MODE			0x08
+#define	DA9211_GPIO3_PIN_SHIFT		4
+#define	DA9211_GPIO3_PIN_MASK		0x30
+#define	DA9211_GPIO3_PIN_GPI		0x00
+#define	DA9211_GPIO3_PIN_IERROR		0x10
+#define	DA9211_GPIO3_PIN_GPO_OD		0x20
+#define	DA9211_GPIO3_PIN_GPO		0x30
+#define	DA9211_GPIO3_TYPE_SHIFT		0x40
+#define	DA9211_GPIO3_TYPE_GPI		0x00
+#define	DA9211_GPIO3_TYPE_GPO		0x40
+#define	DA9211_GPIO3_MODE			0x80
+
+/* DA9211_REG_GPIO_4 (addr=0x5A) */
+#define	DA9211_GPIO4_PIN_SHIFT		0
+#define	DA9211_GPIO4_PIN_MASK		0x03
+#define	DA9211_GPIO4_PIN_GPI		0x00
+#define	DA9211_GPIO4_PIN_GPO_OD		0x02
+#define	DA9211_GPIO4_PIN_GPO		0x03
+#define	DA9211_GPIO4_TYPE			0x04
+#define	DA9211_GPIO4_TYPE_GPI		0x00
+#define	DA9211_GPIO4_TYPE_GPO		0x04
+#define	DA9211_GPIO4_MODE			0x08
+
+/* DA9211_REG_BUCKA_CONT (addr=0x5D) */
+#define	DA9211_BUCKA_EN				0x01
+#define	DA9211_BUCKA_GPI_SHIFT		1
+#define DA9211_BUCKA_GPI_MASK		0x06
+#define	DA9211_BUCKA_GPI_OFF		0x00
+#define	DA9211_BUCKA_GPI_GPIO0		0x02
+#define	DA9211_BUCKA_GPI_GPIO1		0x04
+#define	DA9211_BUCKA_GPI_GPIO3		0x06
+#define	DA9211_BUCKA_PD_DIS			0x08
+#define	DA9211_VBUCKA_SEL			0x10
+#define	DA9211_VBUCKA_SEL_A			0x00
+#define	DA9211_VBUCKA_SEL_B			0x10
+#define	DA9211_VBUCKA_GPI_SHIFT		5
+#define	DA9211_VBUCKA_GPI_MASK		0x60
+#define	DA9211_VBUCKA_GPI_OFF		0x00
+#define	DA9211_VBUCKA_GPI_GPIO1		0x20
+#define	DA9211_VBUCKA_GPI_GPIO2		0x40
+#define	DA9211_VBUCKA_GPI_GPIO4		0x60
+
+/* DA9211_REG_BUCKB_CONT (addr=0x5E) */
+#define	DA9211_BUCKB_EN				0x01
+#define	DA9211_BUCKB_GPI_SHIFT		1
+#define DA9211_BUCKB_GPI_MASK		0x06
+#define	DA9211_BUCKB_GPI_OFF		0x00
+#define	DA9211_BUCKB_GPI_GPIO0		0x02
+#define	DA9211_BUCKB_GPI_GPIO1		0x04
+#define	DA9211_BUCKB_GPI_GPIO3		0x06
+#define	DA9211_BUCKB_PD_DIS			0x08
+#define	DA9211_VBUCKB_SEL			0x10
+#define	DA9211_VBUCKB_SEL_A			0x00
+#define	DA9211_VBUCKB_SEL_B			0x10
+#define	DA9211_VBUCKB_GPI_SHIFT		5
+#define	DA9211_VBUCKB_GPI_MASK		0x60
+#define	DA9211_VBUCKB_GPI_OFF		0x00
+#define	DA9211_VBUCKB_GPI_GPIO1		0x20
+#define	DA9211_VBUCKB_GPI_GPIO2		0x40
+#define	DA9211_VBUCKB_GPI_GPIO4		0x60
+
+/* DA9211_REG_BUCK_ILIM (addr=0xD0) */
+#define DA9211_BUCKA_ILIM_SHIFT			0
+#define DA9211_BUCKA_ILIM_MASK			0x0F
+#define DA9211_BUCKB_ILIM_SHIFT			4
+#define DA9211_BUCKB_ILIM_MASK			0xF0
+
+/* DA9211_REG_BUCKA_CONF (addr=0xD1) */
+#define DA9211_BUCKA_MODE_SHIFT			0
+#define DA9211_BUCKA_MODE_MASK			0x03
+#define	DA9211_BUCKA_MODE_MANUAL		0x00
+#define	DA9211_BUCKA_MODE_SLEEP			0x01
+#define	DA9211_BUCKA_MODE_SYNC			0x02
+#define	DA9211_BUCKA_MODE_AUTO			0x03
+#define DA9211_BUCKA_UP_CTRL_SHIFT		2
+#define DA9211_BUCKA_UP_CTRL_MASK		0x1C
+#define DA9211_BUCKA_DOWN_CTRL_SHIFT	5
+#define DA9211_BUCKA_DOWN_CTRL_MASK		0xE0
+
+/* DA9211_REG_BUCKB_CONF (addr=0xD2) */
+#define DA9211_BUCKB_MODE_SHIFT			0
+#define DA9211_BUCKB_MODE_MASK			0x03
+#define	DA9211_BUCKB_MODE_MANUAL		0x00
+#define	DA9211_BUCKB_MODE_SLEEP			0x01
+#define	DA9211_BUCKB_MODE_SYNC			0x02
+#define	DA9211_BUCKB_MODE_AUTO			0x03
+#define DA9211_BUCKB_UP_CTRL_SHIFT		2
+#define DA9211_BUCKB_UP_CTRL_MASK		0x1C
+#define DA9211_BUCKB_DOWN_CTRL_SHIFT	5
+#define DA9211_BUCKB_DOWN_CTRL_MASK		0xE0
+
+/* DA9211_REG_BUCK_CONF (addr=0xD3) */
+#define DA9211_PHASE_SEL_A_SHIFT		0
+#define DA9211_PHASE_SEL_A_MASK			0x03
+#define DA9211_PHASE_SEL_B_SHIFT		2
+#define DA9211_PHASE_SEL_B_MASK			0x04
+#define DA9211_PH_SH_EN_A_SHIFT			3
+#define DA9211_PH_SH_EN_A_MASK			0x08
+#define DA9211_PH_SH_EN_B_SHIFT			4
+#define DA9211_PH_SH_EN_B_MASK			0x10
+
+/* DA9211_REG_VBUCKA_MAX (addr=0xD5) */
+#define DA9211_VBUCKA_BASE_SHIFT		0
+#define DA9211_VBUCKA_BASE_MASK			0x7F
+
+/* DA9211_REG_VBUCKB_MAX (addr=0xD6) */
+#define DA9211_VBUCKB_BASE_SHIFT		0
+#define DA9211_VBUCKB_BASE_MASK			0x7F
+
+/* DA9211_REG_VBUCKA/B_A/B (addr=0xD7/0xD8/0xD9/0xDA) */
+#define DA9211_VBUCK_SHIFT			0
+#define DA9211_VBUCK_MASK			0x7F
+#define DA9211_VBUCK_BIAS			0
+#define DA9211_BUCK_SL				0x80
+
+/* DA9211_REG_INTERFACE (addr=0x105) */
+#define DA9211_IF_BASE_ADDR_SHIFT		4
+#define DA9211_IF_BASE_ADDR_MASK		0xF0
+
+/* DA9211_REG_CONFIG_E (addr=0x147) */
+#define DA9211_SLAVE_SEL			0x40
+
+#endif	/* __DA9211_REGISTERS_H__ */
diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
new file mode 100644
index 0000000..0981ce0
--- /dev/null
+++ b/include/linux/regulator/da9211.h
@@ -0,0 +1,32 @@
+/*
+ * da9211.h - Regulator device driver for DA9211
+ * Copyright (C) 2014  Dialog Semiconductor Ltd.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ */
+
+#ifndef __LINUX_REGULATOR_DA9211_H
+#define __LINUX_REGULATOR_DA9211_H
+
+#include <linux/regulator/machine.h>
+
+#define DA9211_MAX_REGULATORS	2
+
+struct da9211_pdata {
+	/*
+	 * Number of buck
+	 * 1 : 4 phase 1 buck
+	 * 2 : 2 phase 2 buck
+	 */
+	int num_buck;
+	struct regulator_init_data *init_data;
+};
+#endif
-- 
end-of-patch for regulator: DA9211 : new regulator driver V4

