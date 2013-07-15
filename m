Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3GOPTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:19:06 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:5348 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932364Ab3GOPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:19:04 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-10.tower-38.messagelabs.com!1373901539!15209247!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201307151518.r6FFIve6031479@swsrvapps-01.diasemi.com>
From: Steve Twiss <stwiss.opensource@diasemi.com>
Date: Mon, 15 Jul 2013 15:06:59 +0100
Subject: [PATCH V1] DA9210 driver files
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Twiss <stwiss.opensource@diasemi.com>

This patch describes the regulator driver for the DA9210 Multi-phase Buck
from Dialog Semiconductor Ltd. It has been made aginst kernel version
linux-next next-20130715

This driver is for the Dialog DA9210 Multi-phase 12A DC-DC Buck Converter
controlled only from the I2C bus. It consists of a I2C device driver which
controls a synchronous 12 Amp step down converter.

In this case, the regulator component contains all parts of the driver in a
single file. The regulator implements the functions for .set_current_limit
and .get_current_limit. It uses core functions for the rest.

This driver does not make use of regmap_range in order to control access
to paged registers. No registers past the first page are accessed using
this driver and PAGE_CON is not used.

Regards,
Steve Twiss, Dialog Semiconductor Ltd.

Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
Checks performed with next-20130715/scripts/checkpatch.pl
 Kconfig                   total: 0 errors, 0 warnings, 546 lines checked
 da9210-regulator.c        total: 0 errors, 0 warnings, 199 lines checked
 da9210-regulator.h        total: 0 errors, 0 warnings, 288 lines checked
 Makefile                  total: 0 errors, 0 warnings, 78 lines checked

This is submission attempt V1 and follows from previous RFC
discussions. The differences between this and the previous version are
as follows.

(1) Kconfig
  - capitalisation in tristate title

(2) da9210-regulator.c
  - define N_CURRENT_LIMITS removed and ARRAY_SIZE() added
  - changed to use global static data for struct regulator_desc
  - removed dev_info() at end of probe

An important thing to note about this driver is that it does not
implement regmap_range to control access of paged registers. It is
understood by the author that this could be a blocking issue for
submission to the Linux kernel.

Previous discussions on this driver:

[RFC V2] DA9210 driver files
   On Mon, 1 Jul 2013 15:10:28 +0100
   https://lkml.org/lkml/2013/7/1/300 

[RFC V1] COMMIT 1: DA9210 driver files
   On Thu, 20 Jun 2013 14:42:03 +0100
   https://lkml.org/lkml/2013/6/20/408

 drivers/regulator/Kconfig            |    9 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9210-regulator.c |  199 +++++++++++++++++++++++
 drivers/regulator/da9210-regulator.h |  288 ++++++++++++++++++++++++++++++++++
 4 files changed, 497 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/da9210-regulator.c
 create mode 100644 drivers/regulator/da9210-regulator.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f1e6ad9..4fe3a13 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -120,6 +120,15 @@ config REGULATOR_DA9055
 	  This driver can also be built as a module. If so, the module
 	  will be called da9055-regulator.
 
+config REGULATOR_DA9210
+	tristate "Dialog Semiconductor DA9210 regulator"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  Say y here to support for the Dialog Semiconductor DA9210.
+	  The DA9210 is a multi-phase synchronous step down converter
+	  controlled through an I2C interface.
+
 config REGULATOR_FAN53555
 	tristate "Fairchild FAN53555 Regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index ba4a3cf..d0da850 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_REGULATOR_AS3711) += as3711-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DA9055)	+= da9055-regulator.o
+obj-$(CONFIG_REGULATOR_DA9210) += da9210-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_FAN53555) += fan53555.o
diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
new file mode 100644
index 0000000..d066b03
--- /dev/null
+++ b/drivers/regulator/da9210-regulator.c
@@ -0,0 +1,199 @@
+
+/*
+ * da9210-regulator.c - Regulator device driver for DA9210
+ * Copyright (C) 2013  Dialog Semiconductor Ltd.
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
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the
+ * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
+ * Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regmap.h>
+
+#include "da9210-regulator.h"
+
+struct da9210 {
+	struct device *dev;
+	struct regulator_dev *rdev;
+	struct regmap *regmap;
+};
+
+static const struct regmap_config da9210_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int da9210_set_current_limit(struct regulator_dev *rdev, int min_uA,
+				    int max_uA);
+static int da9210_get_current_limit(struct regulator_dev *rdev);
+
+static struct regulator_ops da9210_buck_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.list_voltage = regulator_list_voltage_linear,
+	.set_current_limit = da9210_set_current_limit,
+	.get_current_limit = da9210_get_current_limit,
+};
+
+/* Default limits measured in millivolts and milliamps */
+#define DA9210_MIN_MV		300
+#define DA9210_MAX_MV		1570
+#define DA9210_STEP_MV		10
+
+/* Current limits for buck (uA) indices corresponds with register values */
+static const int da9210_buck_limits[] = {
+	1600000, 1800000, 2000000, 2200000, 2400000, 2600000, 2800000, 3000000,
+	3200000, 3400000, 3600000, 3800000, 4000000, 4200000, 4400000, 4600000
+};
+
+static const struct regulator_desc da9210_reg = {
+	.name = "DA9210",
+	.id = 0,
+	.ops = &da9210_buck_ops,
+	.type = REGULATOR_VOLTAGE,
+	.n_voltages = ((DA9210_MAX_MV - DA9210_MIN_MV) / DA9210_STEP_MV) + 1,
+	.min_uV = (DA9210_MIN_MV * 1000),
+	.uV_step = (DA9210_STEP_MV * 1000),
+	.vsel_reg = DA9210_REG_VBUCK_A,
+	.vsel_mask = DA9210_VBUCK_MASK,
+	.enable_reg = DA9210_REG_BUCK_CONT,
+	.enable_mask = DA9210_BUCK_EN,
+	.owner = THIS_MODULE,
+};
+
+static int da9210_set_current_limit(struct regulator_dev *rdev, int min_uA,
+				    int max_uA)
+{
+	struct da9210 *chip = rdev_get_drvdata(rdev);
+	unsigned int sel;
+	int i;
+
+	/* search for closest to maximum */
+	for (i = ARRAY_SIZE(da9210_buck_limits)-1; i >= 0; i--) {
+		if (min_uA <= da9210_buck_limits[i] &&
+		    max_uA >= da9210_buck_limits[i]) {
+			sel = i;
+			sel = sel << DA9210_BUCK_ILIM_SHIFT;
+			return regmap_update_bits(chip->regmap,
+						  DA9210_REG_BUCK_ILIM,
+						  DA9210_BUCK_ILIM_MASK, sel);
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int da9210_get_current_limit(struct regulator_dev *rdev)
+{
+	struct da9210 *chip = rdev_get_drvdata(rdev);
+	unsigned int data;
+	unsigned int sel;
+	int ret;
+
+	ret = regmap_read(chip->regmap, DA9210_REG_BUCK_ILIM, &data);
+	if (ret < 0)
+		return ret;
+
+	/* select one of 16 values: 0000 (1600mA) to 1111 (4600mA) */
+	sel = (data & DA9210_BUCK_ILIM_MASK) >> DA9210_BUCK_ILIM_SHIFT;
+
+	return da9210_buck_limits[sel];
+}
+
+/*
+ * I2C driver interface functions
+ */
+static int da9210_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct da9210 *chip;
+	struct da9210_pdata *pdata = i2c->dev.platform_data;
+	struct regulator_dev *rdev = NULL;
+	struct regulator_config config = { };
+	int error;
+
+	chip = devm_kzalloc(&i2c->dev, sizeof(struct da9210), GFP_KERNEL);
+	if (NULL == chip) {
+		dev_err(&i2c->dev,
+			"Cannot kzalloc memory for regulator structure\n");
+		return -ENOMEM;
+	}
+
+	chip->regmap = devm_regmap_init_i2c(i2c, &da9210_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		error = PTR_ERR(chip->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			error);
+		return error;
+	}
+
+	config.dev = &i2c->dev;
+	if (pdata)
+		config.init_data = &pdata->da9210_constraints;
+	config.driver_data = chip;
+	config.regmap = chip->regmap;
+
+	rdev = regulator_register(&da9210_reg, &config);
+	if (IS_ERR(rdev)) {
+		dev_err(&i2c->dev, "Failed to register DA9210 regulator\n");
+		return PTR_ERR(rdev);
+	}
+
+	chip->rdev = rdev;
+
+	i2c_set_clientdata(i2c, chip);
+
+	return 0;
+}
+
+static int da9210_i2c_remove(struct i2c_client *i2c)
+{
+	struct da9210 *chip = i2c_get_clientdata(i2c);
+	regulator_unregister(chip->rdev);
+	return 0;
+}
+
+static const struct i2c_device_id da9210_i2c_id[] = {
+	{"da9210", 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, da9210_i2c_id);
+
+static struct i2c_driver da9210_regulator_driver = {
+	.driver = {
+		.name = "da9210",
+		.owner = THIS_MODULE,
+	},
+	.probe = da9210_i2c_probe,
+	.remove = da9210_i2c_remove,
+	.id_table = da9210_i2c_id,
+};
+
+module_i2c_driver(da9210_regulator_driver);
+
+MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
+MODULE_DESCRIPTION("Regulator device driver for Dialog DA9210");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform: da9210");
diff --git a/drivers/regulator/da9210-regulator.h b/drivers/regulator/da9210-regulator.h
new file mode 100644
index 0000000..749c550
--- /dev/null
+++ b/drivers/regulator/da9210-regulator.h
@@ -0,0 +1,288 @@
+
+/*
+ * da9210-regulator.h - Regulator definitions for DA9210
+ * Copyright (C) 2013  Dialog Semiconductor Ltd.
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
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the
+ * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
+ * Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __DA9210_REGISTERS_H__
+#define __DA9210_REGISTERS_H__
+
+struct da9210_pdata {
+	struct regulator_init_data da9210_constraints;
+};
+
+/* Page selection */
+#define	DA9210_REG_PAGE_CON			0x00
+
+/* System Control and Event Registers */
+#define	DA9210_REG_STATUS_A			0x50
+#define	DA9210_REG_STATUS_B			0x51
+#define	DA9210_REG_EVENT_A			0x52
+#define	DA9210_REG_EVENT_B			0x53
+#define	DA9210_REG_MASK_A			0x54
+#define	DA9210_REG_MASK_B			0x55
+#define	DA9210_REG_CONTROL_A			0x56
+
+/* GPIO Control Registers */
+#define	DA9210_REG_GPIO_0_1			0x58
+#define	DA9210_REG_GPIO_2_3			0x59
+#define	DA9210_REG_GPIO_4_5			0x5A
+#define	DA9210_REG_GPIO_6			0x5B
+
+/* Regulator Registers */
+#define	DA9210_REG_BUCK_CONT			0x5D
+#define	DA9210_REG_BUCK_ILIM			0xD0
+#define	DA9210_REG_BUCK_CONF1			0xD1
+#define	DA9210_REG_BUCK_CONF2			0xD2
+#define DA9210_REG_VBACK_AUTO			0xD4
+#define DA9210_REG_VBACK_BASE			0xD5
+#define DA9210_REG_VBACK_MAX_DVC_IF		0xD6
+#define DA9210_REG_VBACK_DVC			0xD7
+#define	DA9210_REG_VBUCK_A			0xD8
+#define	DA9210_REG_VBUCK_B			0xD9
+
+/* I2C Interface Settings */
+#define DA9210_REG_INTERFACE			0x105
+
+/* OTP */
+#define	DA9210_REG_OPT_COUNT			0x140
+#define	DA9210_REG_OPT_ADDR			0x141
+#define	DA9210_REG_OPT_DATA			0x142
+
+/* Customer Trim and Configuration */
+#define	DA9210_REG_CONFIG_A			0x143
+#define	DA9210_REG_CONFIG_B			0x144
+#define	DA9210_REG_CONFIG_C			0x145
+#define	DA9210_REG_CONFIG_D			0x146
+#define	DA9210_REG_CONFIG_E			0x147
+
+
+/*
+ * Registers bits
+ */
+/* DA9210_REG_PAGE_CON (addr=0x00) */
+#define	DA9210_PEG_PAGE_SHIFT			0
+#define	DA9210_REG_PAGE_MASK			0x0F
+/* On I2C registers 0x00 - 0xFF */
+#define	DA9210_REG_PAGE0			0
+/* On I2C registers 0x100 - 0x1FF */
+#define	DA9210_REG_PAGE2			2
+#define	DA9210_PAGE_WRITE_MODE			0x00
+#define	DA9210_REPEAT_WRITE_MODE		0x40
+#define	DA9210_PAGE_REVERT			0x80
+
+/* DA9210_REG_STATUS_A (addr=0x50) */
+#define	DA9210_GPI0				0x01
+#define	DA9210_GPI1				0x02
+#define	DA9210_GPI2				0x04
+#define	DA9210_GPI3				0x08
+#define	DA9210_GPI4				0x10
+#define	DA9210_GPI5				0x20
+#define	DA9210_GPI6				0x40
+
+/* DA9210_REG_EVENT_A (addr=0x52) */
+#define	DA9210_E_GPI0				0x01
+#define	DA9210_E_GPI1				0x02
+#define	DA9210_E_GPI2				0x04
+#define	DA9210_E_GPI3				0x08
+#define	DA9210_E_GPI4				0x10
+#define	DA9210_E_GPI5				0x20
+#define	DA9210_E_GPI6				0x40
+
+/* DA9210_REG_EVENT_B (addr=0x53) */
+#define	DA9210_E_OVCURR				0x01
+#define	DA9210_E_NPWRGOOD			0x02
+#define	DA9210_E_TEMP_WARN			0x04
+#define	DA9210_E_TEMP_CRIT			0x08
+#define	DA9210_E_VMAX				0x10
+
+/* DA9210_REG_MASK_A (addr=0x54) */
+#define	DA9210_M_GPI0				0x01
+#define	DA9210_M_GPI1				0x02
+#define	DA9210_M_GPI2				0x04
+#define	DA9210_M_GPI3				0x08
+#define	DA9210_M_GPI4				0x10
+#define	DA9210_M_GPI5				0x20
+#define	DA9210_M_GPI6				0x40
+
+/* DA9210_REG_MASK_B (addr=0x55) */
+#define	DA9210_M_OVCURR				0x01
+#define	DA9210_M_NPWRGOOD			0x02
+#define	DA9210_M_TEMP_WARN			0x04
+#define	DA9210_M_TEMP_CRIT			0x08
+#define	DA9210_M_VMAX				0x10
+
+/* DA9210_REG_CONTROL_A (addr=0x56) */
+#define	DA9210_DEBOUNCING_SHIFT			0
+#define	DA9210_DEBOUNCING_MASK			0x07
+#define	DA9210_SLEW_RATE_SHIFT			3
+#define	DA9210_SLEW_RATE_MASK			0x18
+#define	DA9210_V_LOCK				0x20
+
+/* DA9210_REG_GPIO_0_1 (addr=0x58) */
+#define	DA9210_GPIO0_PIN_SHIFT			0
+#define	DA9210_GPIO0_PIN_MASK			0x03
+#define		DA9210_GPIO0_PIN_GPI		0x00
+#define		DA9210_GPIO0_PIN_GPO_OD		0x02
+#define		DA9210_GPIO0_PIN_GPO		0x03
+#define	DA9210_GPIO0_TYPE			0x04
+#define		DA9210_GPIO0_TYPE_GPI		0x00
+#define		DA9210_GPIO0_TYPE_GPO		0x04
+#define	DA9210_GPIO0_MODE			0x08
+#define	DA9210_GPIO1_PIN_SHIFT			4
+#define	DA9210_GPIO1_PIN_MASK			0x30
+#define		DA9210_GPIO1_PIN_GPI		0x00
+#define		DA9210_GPIO1_PIN_VERROR		0x10
+#define		DA9210_GPIO1_PIN_GPO_OD		0x20
+#define		DA9210_GPIO1_PIN_GPO		0x30
+#define	DA9210_GPIO1_TYPE_SHIFT			0x40
+#define		DA9210_GPIO1_TYPE_GPI		0x00
+#define		DA9210_GPIO1_TYPE_GPO		0x40
+#define	DA9210_GPIO1_MODE			0x80
+
+/* DA9210_REG_GPIO_2_3 (addr=0x59) */
+#define	DA9210_GPIO2_PIN_SHIFT			0
+#define	DA9210_GPIO2_PIN_MASK			0x03
+#define		DA9210_GPIO2_PIN_GPI		0x00
+#define		DA9210_GPIO5_PIN_BUCK_CLK	0x10
+#define		DA9210_GPIO2_PIN_GPO_OD		0x02
+#define		DA9210_GPIO2_PIN_GPO		0x03
+#define	DA9210_GPIO2_TYPE			0x04
+#define		DA9210_GPIO2_TYPE_GPI		0x00
+#define		DA9210_GPIO2_TYPE_GPO		0x04
+#define	DA9210_GPIO2_MODE			0x08
+#define	DA9210_GPIO3_PIN_SHIFT			4
+#define	DA9210_GPIO3_PIN_MASK			0x30
+#define		DA9210_GPIO3_PIN_GPI		0x00
+#define		DA9210_GPIO3_PIN_IERROR		0x10
+#define		DA9210_GPIO3_PIN_GPO_OD		0x20
+#define		DA9210_GPIO3_PIN_GPO		0x30
+#define	DA9210_GPIO3_TYPE_SHIFT			0x40
+#define		DA9210_GPIO3_TYPE_GPI		0x00
+#define		DA9210_GPIO3_TYPE_GPO		0x40
+#define	DA9210_GPIO3_MODE			0x80
+
+/* DA9210_REG_GPIO_4_5 (addr=0x5A) */
+#define	DA9210_GPIO4_PIN_SHIFT			0
+#define	DA9210_GPIO4_PIN_MASK			0x03
+#define		DA9210_GPIO4_PIN_GPI		0x00
+#define		DA9210_GPIO4_PIN_GPO_OD		0x02
+#define		DA9210_GPIO4_PIN_GPO		0x03
+#define	DA9210_GPIO4_TYPE			0x04
+#define		DA9210_GPIO4_TYPE_GPI		0x00
+#define		DA9210_GPIO4_TYPE_GPO		0x04
+#define	DA9210_GPIO4_MODE			0x08
+#define	DA9210_GPIO5_PIN_SHIFT			4
+#define	DA9210_GPIO5_PIN_MASK			0x30
+#define		DA9210_GPIO5_PIN_GPI		0x00
+#define		DA9210_GPIO5_PIN_INTERFACE	0x01
+#define		DA9210_GPIO5_PIN_GPO_OD		0x20
+#define		DA9210_GPIO5_PIN_GPO		0x30
+#define	DA9210_GPIO5_TYPE_SHIFT			0x40
+#define		DA9210_GPIO5_TYPE_GPI		0x00
+#define		DA9210_GPIO5_TYPE_GPO		0x40
+#define	DA9210_GPIO5_MODE			0x80
+
+/* DA9210_REG_GPIO_6 (addr=0x5B) */
+#define	DA9210_GPIO6_PIN_SHIFT			0
+#define	DA9210_GPIO6_PIN_MASK			0x03
+#define		DA9210_GPIO6_PIN_GPI		0x00
+#define		DA9210_GPIO6_PIN_INTERFACE	0x01
+#define		DA9210_GPIO6_PIN_GPO_OD		0x02
+#define		DA9210_GPIO6_PIN_GPO		0x03
+#define	DA9210_GPIO6_TYPE			0x04
+#define		DA9210_GPIO6_TYPE_GPI		0x00
+#define		DA9210_GPIO6_TYPE_GPO		0x04
+#define	DA9210_GPIO6_MODE			0x08
+
+/* DA9210_REG_BUCK_CONT (addr=0x5D) */
+#define	DA9210_BUCK_EN				0x01
+#define	DA9210_BUCK_GPI_SHIFT			1
+#define DA9210_BUCK_GPI_MASK			0x06
+#define		DA9210_BUCK_GPI_OFF		0x00
+#define		DA9210_BUCK_GPI_GPIO0		0x02
+#define		DA9210_BUCK_GPI_GPIO3		0x04
+#define		DA9210_BUCK_GPI_GPIO4		0x06
+#define	DA9210_BUCK_PD_DIS			0x08
+#define	DA9210_VBUCK_SEL			0x10
+#define		DA9210_VBUCK_SEL_A		0x00
+#define		DA9210_VBUCK_SEL_B		0x10
+#define	DA9210_VBUCK_GPI_SHIFT			5
+#define	DA9210_VBUCK_GPI_MASK			0x60
+#define		DA9210_VBUCK_GPI_OFF		0x00
+#define		DA9210_VBUCK_GPI_GPIO0		0x20
+#define		DA9210_VBUCK_GPI_GPIO3		0x40
+#define		DA9210_VBUCK_GPI_GPIO4		0x60
+#define	DA9210_DVC_CTRL_EN			0x80
+
+/* DA9210_REG_BUCK_ILIM (addr=0xD0) */
+#define DA9210_BUCK_ILIM_SHIFT			0
+#define DA9210_BUCK_ILIM_MASK			0x0F
+#define DA9210_BUCK_IALARM			0x10
+
+/* DA9210_REG_BUCK_CONF1 (addr=0xD1) */
+#define DA9210_BUCK_MODE_SHIFT			0
+#define DA9210_BUCK_MODE_MASK			0x03
+#define		DA9210_BUCK_MODE_MANUAL		0x00
+#define		DA9210_BUCK_MODE_SLEEP		0x01
+#define		DA9210_BUCK_MODE_SYNC		0x02
+#define		DA9210_BUCK_MODE_AUTO		0x03
+#define DA9210_STARTUP_CTRL_SHIFT		2
+#define DA9210_STARTUP_CTRL_MASK		0x1C
+#define DA9210_PWR_DOWN_CTRL_SHIFT		5
+#define DA9210_PWR_DOWN_CTRL_MASK		0xE0
+
+/* DA9210_REG_BUCK_CONF2 (addr=0xD2) */
+#define DA9210_PHASE_SEL_SHIFT			0
+#define DA9210_PHASE_SEL_MASK			0x03
+#define DA9210_FREQ_SEL				0x40
+
+/* DA9210_REG_BUCK_AUTO (addr=0xD4) */
+#define DA9210_VBUCK_AUTO_SHIFT			0
+#define DA9210_VBUCK_AUTO_MASK			0x7F
+
+/* DA9210_REG_BUCK_BASE (addr=0xD5) */
+#define DA9210_VBUCK_BASE_SHIFT			0
+#define DA9210_VBUCK_BASE_MASK			0x7F
+
+/* DA9210_REG_VBUCK_MAX_DVC_IF (addr=0xD6) */
+#define DA9210_VBUCK_MAX_SHIFT			0
+#define DA9210_VBUCK_MAX_MASK			0x7F
+#define DA9210_DVC_STEP_SIZE			0x80
+#define		DA9210_DVC_STEP_SIZE_10MV	0x00
+#define		DA9210_DVC_STEP_SIZE_20MV	0x80
+
+/* DA9210_REG_VBUCK_DVC (addr=0xD7) */
+#define DA9210_VBUCK_DVC_SHIFT			0
+#define DA9210_VBUCK_DVC_MASK			0x7F
+
+/* DA9210_REG_VBUCK_A/B (addr=0xD8/0xD9) */
+#define DA9210_VBUCK_SHIFT			0
+#define DA9210_VBUCK_MASK			0x7F
+#define DA9210_VBUCK_BIAS			0
+#define DA9210_BUCK_SL				0x80
+
+/* DA9210_REG_INTERFACE (addr=0x105) */
+#define DA9210_IF_BASE_ADDR_SHIFT		4
+#define DA9210_IF_BASE_ADDR_MASK		0xF0
+
+/* DA9210_REG_CONFIG_E (addr=0x147) */
+#define DA9210_STAND_ALONE			0x01
+
+#endif	/* __DA9210_REGISTERS_H__ */
+
-- 
end-of-patch for PATCH V1

