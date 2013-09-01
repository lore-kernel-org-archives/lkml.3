Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3IAUBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:01:08 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:35927 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3IAUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:01:06 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] regulator: add STw481x VMMC driver
Date: Sun,  1 Sep 2013 22:00:59 +0200
Message-Id: <1378065659-18135-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ST Microelectronics STw481x PMIC used for the Nomadik
has one single software-controlled regulator for VMMC.
This driver registers directly to the compatible string
as there is just one regulator.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Mark, I'm seeking an ACK for this driver eventually, to
take it through the ARM SoC tree with the dependency MFD
driver and the enablement patches.
---
 drivers/regulator/Kconfig        |   8 ++
 drivers/regulator/Makefile       |   1 +
 drivers/regulator/stw481x-vmmc.c | 195 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+)
 create mode 100644 drivers/regulator/stw481x-vmmc.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f1e6ad9..7e424fc 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -374,6 +374,14 @@ config REGULATOR_PALMAS
 	  on the muxing. This is handled automatically in the driver by
 	  reading the mux info from OTP.
 
+config REGULATOR_STW481X_VMMC
+	bool "ST Microelectronics STW481X VMMC regulator"
+	depends on MFD_STW481X
+	default y if MFD_STW481X
+	help
+	  This driver supports the VMMC regulator in the STw481x
+	  PMIC chips.
+
 config REGULATOR_TPS51632
 	tristate "TI TPS51632 Power Regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index ba4a3cf..6d53bd4 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
diff --git a/drivers/regulator/stw481x-vmmc.c b/drivers/regulator/stw481x-vmmc.c
new file mode 100644
index 0000000..e53916e
--- /dev/null
+++ b/drivers/regulator/stw481x-vmmc.c
@@ -0,0 +1,195 @@
+/*
+ * Regulator driver for STw4810/STw4811 VMMC regulator.
+ *
+ * Copyright (C) 2013 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/mfd/stw481x.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+static int stw481x_vmmc_enable(struct regulator_dev *reg)
+{
+	struct stw481x *stw481x = rdev_get_drvdata(reg);
+	int ret;
+
+	/* First disable the external VMMC if it's active */
+	ret = regmap_update_bits(stw481x->map, STW_CONF2,
+				 STW_CONF2_VMMC_EXT, 0);
+	if (ret)
+		return ret;
+
+	return regmap_update_bits(stw481x->map, STW_CONF1,
+				  0, STW_CONF1_PDN_VMMC);
+}
+
+static int stw481x_vmmc_disable(struct regulator_dev *reg)
+{
+	struct stw481x *stw481x = rdev_get_drvdata(reg);
+
+	return regmap_update_bits(stw481x->map, STW_CONF1,
+				  STW_CONF1_PDN_VMMC, 0);
+}
+
+static int stw481x_vmmc_is_enabled(struct regulator_dev *reg)
+{
+	struct stw481x *stw481x = rdev_get_drvdata(reg);
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(stw481x->map, STW_CONF1, &val);
+	if (ret)
+		return ret;
+	return !!(val & STW_CONF1_PDN_VMMC);
+}
+
+static int stw481x_vmmc_get_voltage_sel(struct regulator_dev *reg)
+{
+	struct stw481x *stw481x = rdev_get_drvdata(reg);
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(stw481x->map, STW_CONF1, &val);
+	if (ret)
+		return ret;
+	val &= STW_CONF1_VMMC_MASK;
+	return (val >> 1);
+}
+
+static int stw481x_vmmc_set_voltage_sel(struct regulator_dev *reg,
+					unsigned selector)
+{
+	struct stw481x *stw481x = rdev_get_drvdata(reg);
+
+	return regmap_update_bits(stw481x->map, STW_CONF1,
+				  STW_CONF1_VMMC_MASK,
+				  (selector << 1) & STW_CONF1_VMMC_MASK);
+}
+
+static const unsigned int stw481x_vmmc_voltages[] = {
+	1800000,
+	1800000,
+	2850000,
+	3000000,
+	1850000,
+	2600000,
+	2700000,
+	3300000,
+};
+
+static struct regulator_ops stw481x_vmmc_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.enable      = stw481x_vmmc_enable,
+	.disable     = stw481x_vmmc_disable,
+	.is_enabled  = stw481x_vmmc_is_enabled,
+	.get_voltage_sel = stw481x_vmmc_get_voltage_sel,
+	.set_voltage_sel = stw481x_vmmc_set_voltage_sel,
+};
+
+static struct regulator_desc vmmc_regulator = {
+	.name = "VMMC",
+	.id   = 0,
+	.ops  = &stw481x_vmmc_ops,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+	.n_voltages = ARRAY_SIZE(stw481x_vmmc_voltages),
+	.volt_table = stw481x_vmmc_voltages,
+	.enable_time = 200, /* FIXME: look this up */
+};
+
+static ssize_t show_ctrl1(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	int ret;
+	unsigned int val;
+	struct stw481x *stw481x = dev_get_platdata(dev);
+
+	ret = regmap_read(stw481x->map, STW_CONF1, &val);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%#x\n", val);
+};
+
+static DEVICE_ATTR(ctrl1, S_IRUGO, show_ctrl1, NULL);
+
+static struct attribute *stw481x_vmmc_sysfs_entries[] = {
+	&dev_attr_ctrl1.attr,
+	NULL,
+};
+
+static struct attribute_group stw481x_vmmc_attr_group = {
+        .attrs  = stw481x_vmmc_sysfs_entries,
+};
+
+static int stw481x_vmmc_regulator_probe(struct platform_device *pdev)
+{
+	struct stw481x *stw481x = dev_get_platdata(&pdev->dev);
+	struct regulator_config config = { };
+	int ret;
+
+	/* Register VMMC regulator */
+	config.dev = &pdev->dev;
+	config.driver_data = stw481x;
+	config.of_node = pdev->dev.of_node;
+	config.init_data = of_get_regulator_init_data(&pdev->dev,
+						      pdev->dev.of_node);
+
+	stw481x->vmmc_regulator = regulator_register(&vmmc_regulator, &config);
+	if (IS_ERR(stw481x->vmmc_regulator)) {
+		dev_err(&pdev->dev,
+			"error initializing STw481x VMMC regulator\n");
+		return PTR_ERR(stw481x->vmmc_regulator);
+	}
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &stw481x_vmmc_attr_group);
+	if (ret)
+		dev_err(&pdev->dev, "could not create sysfs group\n");
+
+	dev_info(&pdev->dev, "initialized STw481x VMMC regulator\n");
+	return 0;
+}
+
+static int stw481x_vmmc_regulator_remove(struct platform_device *pdev)
+{
+	struct stw481x *stw481x = dev_get_platdata(&pdev->dev);
+
+	regulator_unregister(stw481x->vmmc_regulator);
+	return 0;
+}
+
+static const struct of_device_id stw481x_vmmc_match[] = {
+	{ .compatible = "st,stw481x-vmmc", },
+        {},
+};
+
+static struct platform_driver stw481x_vmmc_regulator_driver = {
+	.driver = {
+		.name  = "stw481x-vmmc-regulator",
+		.owner = THIS_MODULE,
+	},
+	.probe = stw481x_vmmc_regulator_probe,
+	.remove = stw481x_vmmc_regulator_remove,
+};
+
+static __init int stw481x_vmmc_regulator_init(void)
+{
+	return platform_driver_register(&stw481x_vmmc_regulator_driver);
+}
+
+static __exit void stw481x_vmmc_regulator_exit(void)
+{
+	platform_driver_unregister(&stw481x_vmmc_regulator_driver);
+}
+
+subsys_initcall(stw481x_vmmc_regulator_init);
+module_exit(stw481x_vmmc_regulator_exit);
-- 
1.8.1.4

