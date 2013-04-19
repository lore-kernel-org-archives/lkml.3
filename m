Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3DSRHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:07:00 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:33767 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3DSRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:06:59 -0400
Message-Id: <201304191705.r3JH5oxp017581@latitude>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Fri, 19 Apr 2013 17:56:28 +0100
Subject: [NEW DRIVER V6 7/7] drivers/regulator: DA9058 REGULATOR driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lgirdwood@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: David Dajun Chen <david.chen@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is relative to next-20130419 of linux-next

This is the REGULATOR component driver of the Dialog DA9058 PMIC.
This driver is just one component of the whole DA9058 PMIC driver.
It depends on the CORE component driver of the DA9058 MFD.

There are 4 CamelCase warnings from scripts/checkpatch.pl, but they
are due to struture field names in the regulator core not due to
names created in this driver

Changes relative to V5 of this patch:
- rebased to next-20130419 in git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
- removed redundant #include <linux/mfd/da9058/version.h>
- reverted regulator_desc.min_uv to min_uV
- reverted regulator_desc.uv_step to uV_step
- reverted regulation_constraints.min_uv to min_uV
- reverted regulation_constraints.max_uv to max_uV
- corrected dates on copyright statements
- removed system specific regulator consumer
- use multiple exit points in functions when no common code
  is to be executed.
- embedded a regulator_init_data in the platform data

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 drivers/regulator/Kconfig            |   11 ++
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9058-regulator.c |  199 ++++++++++++++++++++++++++++++++++
 3 files changed, 211 insertions(+)
 create mode 100644 drivers/regulator/da9058-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8bb2644..0e36ef6 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -64,6 +64,17 @@ config REGULATOR_USERSPACE_CONSUMER
 
 	  If unsure, say no.
 
+config REGULATOR_DA9058
+	tristate "Support regulators on Dialog Semiconductor DA9058 PMIC"
+	depends on MFD_DA9058
+	help
+	  Say y here to support the BUCKs and LDOs regulators found on
+	  Dialog Semiconductor DA9058 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called da9058-regulator.
+
+
 config REGULATOR_GPIO
 	tristate "GPIO regulator support"
 	depends on GPIOLIB
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 47a34ff..d3a1dc4 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_FAN53555) += fan53555.o
 obj-$(CONFIG_REGULATOR_GPIO) += gpio-regulator.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
+obj-$(CONFIG_REGULATOR_DA9058) += da9058-regulator.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_LP3972) += lp3972.o
 obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
diff --git a/drivers/regulator/da9058-regulator.c b/drivers/regulator/da9058-regulator.c
new file mode 100644
index 0000000..2e8672f
--- /dev/null
+++ b/drivers/regulator/da9058-regulator.c
@@ -0,0 +1,199 @@
+/*
+ *  Copyright (C) 2012, 2013 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/driver.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9058/registers.h>
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/regulator.h>
+
+struct da9058_regulator {
+	struct da9058 *da9058;
+	int ramp_register;
+	int ramp_enable_mask;
+	struct platform_device *pdev;
+	struct regulator_dev *reg_dev;
+	struct regulator_desc desc;
+};
+
+static struct regulator_ops da9058_buck_regulator_ops = {
+	.map_voltage = regulator_map_voltage_linear,
+	.list_voltage = regulator_list_voltage_linear,
+	.set_voltage_time_sel = regulator_set_voltage_time_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+};
+
+static struct regulator_ops da9058_ldo_regulator_ops = {
+	.map_voltage = regulator_map_voltage_linear,
+	.list_voltage = regulator_list_voltage_linear,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+};
+
+static int da9058_regulator_probe(struct platform_device *pdev)
+{
+	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct da9058_regulator_pdata *rpdata;
+	struct da9058_regulator *reg;
+	struct regulator_dev *rdev;
+	struct regulator_config config = { };
+	int ret;
+	unsigned int val;
+	const char *regulator_name;
+	int min_uv;
+	int max_uv;
+
+	if (cell == NULL)
+		return -ENODEV;
+
+	rpdata = cell->platform_data;
+
+	if (rpdata == NULL)
+		return -EINVAL;
+
+	if (rpdata->control_register == 0)
+		return -EINVAL;
+
+	if (rpdata->control_enable_mask == 0)
+		return -EINVAL;
+
+	regulator_name = rpdata->init.constraints.name;
+
+	if (!regulator_name)
+		return -EINVAL;
+
+	min_uv = rpdata->init.constraints.min_uV;
+	max_uv = rpdata->init.constraints.max_uV;
+
+	reg = devm_kzalloc(&pdev->dev, sizeof(struct da9058_regulator),
+			   GFP_KERNEL);
+	if (!reg)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, reg);
+
+	reg->da9058 = da9058;
+	reg->pdev = pdev;
+	reg->ramp_register = rpdata->ramp_register;
+	reg->ramp_enable_mask = rpdata->ramp_enable_mask;
+
+	reg->desc.name = regulator_name;
+	reg->desc.id = rpdata->regulator_id;
+	reg->desc.type = REGULATOR_VOLTAGE;
+	reg->desc.n_voltages = 1;
+
+	if (rpdata->control_voltage_step > 0)
+		reg->desc.n_voltages += (max_uv - min_uv) /
+					rpdata->control_voltage_step;
+
+	reg->desc.owner = THIS_MODULE;
+	reg->desc.enable_reg = rpdata->control_register;
+	reg->desc.enable_mask = rpdata->control_enable_mask;
+
+	reg->desc.vsel_reg = rpdata->control_register;
+	reg->desc.vsel_mask = rpdata->control_step_mask;
+
+	reg->desc.min_uV = min_uv;
+	reg->desc.uV_step = rpdata->control_voltage_step;
+
+	if (reg->ramp_register) {
+		reg->desc.apply_reg = rpdata->ramp_register;
+		reg->desc.apply_bit = rpdata->ramp_enable_mask;
+		reg->desc.ramp_delay = 1000;
+		reg->desc.ops = &da9058_buck_regulator_ops;
+	} else {
+		reg->desc.ops = &da9058_ldo_regulator_ops;
+	}
+
+	config.dev = pdev->dev.parent;
+	config.init_data = &rpdata->init;
+	config.driver_data = reg;
+	config.regmap = da9058->regmap;
+
+	rdev = regulator_register(&reg->desc, &config);
+
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(&pdev->dev, "failed %d to register %s\n",
+			ret, regulator_name);
+		goto failed_to_register;
+	}
+	reg->reg_dev = rdev;
+
+	/* before we do anything check the lock bit */
+	ret = da9058_reg_read(da9058, DA9058_SUPPLY_REG, &val);
+	if (ret)
+		goto unlock_failed;
+
+	if (val & DA9058_SUPPLY_VLOCK)
+		ret = da9058_clear_bits(da9058, DA9058_SUPPLY_REG,
+					DA9058_SUPPLY_VLOCK);
+	if (ret)
+		goto unlock_failed;
+
+	goto exit;
+
+unlock_failed:
+	regulator_unregister(rdev);
+failed_to_register:
+	platform_set_drvdata(pdev, NULL);
+exit:
+	return ret;
+}
+
+static int da9058_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+
+	return 0;
+}
+
+static struct platform_driver da9058_regulator_driver = {
+	.probe = da9058_regulator_probe,
+	.remove = da9058_regulator_remove,
+	.driver = {
+		.name = "da9058-regulator",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9058_regulator_init(void)
+{
+	return platform_driver_register(&da9058_regulator_driver);
+}
+
+subsys_initcall(da9058_regulator_init);
+
+static void __exit da9058_regulator_exit(void)
+{
+	platform_driver_unregister(&da9058_regulator_driver);
+}
+
+module_exit(da9058_regulator_exit);
+
+MODULE_DESCRIPTION("Dialog DA9058 PMIC voltage and current regulator");
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9058-regulator");
-- 
end-of-patch for NEW DRIVER V6

