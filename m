Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaIRHcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:32:15 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46108 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaIRHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:32:12 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        lee.jones@linaro.org, broonie@kernel.org,
        Chris Zhong <zyw@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 1/2] regulator: st-pwm: get voltage and duty table from dts
Date: Thu, 18 Sep 2014 15:31:44 +0800
Message-Id: <1411025505-21628-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
References: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get voltage & duty table from device tree might be better, other platforms can also use this
driver without any modify.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

eries-changes: 2
Adviced by Lee Jones
- rename the file
- remove all the prefix st_
- add depend on PWM in Kconfig
---

Changes in v2: None

 drivers/regulator/Kconfig         |    8 +-
 drivers/regulator/Makefile        |    2 +-
 drivers/regulator/pwm-regulator.c |  195 +++++++++++++++++++++++++++++++++++++
 drivers/regulator/st-pwm.c        |  190 ------------------------------------
 4 files changed, 200 insertions(+), 195 deletions(-)
 create mode 100644 drivers/regulator/pwm-regulator.c
 delete mode 100644 drivers/regulator/st-pwm.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index fb32bab..4b17d75 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -493,11 +493,11 @@ config REGULATOR_S5M8767
 	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
 	 supports DVS mode with 8bits of output voltage control.
 
-config REGULATOR_ST_PWM
-	tristate "STMicroelectronics PWM voltage regulator"
-	depends on ARCH_STI
+config REGULATOR_PWM
+	tristate "PWM voltage regulator"
+	depends on PWM
 	help
-	 This driver supports ST's PWM controlled voltage regulators.
+	 This driver supports PWM controlled voltage regulators.
 
 config REGULATOR_TI_ABB
 	tristate "TI Adaptive Body Bias on-chip LDO"
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 236fdbb..3954fbd 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -66,7 +66,7 @@ obj-$(CONFIG_REGULATOR_RK808)   += rk808-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
-obj-$(CONFIG_REGULATOR_ST_PWM) += st-pwm.o
+obj-$(CONFIG_REGULATOR_PWM) += pwm-regulator.o
 obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
 obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
diff --git a/drivers/regulator/pwm-regulator.c b/drivers/regulator/pwm-regulator.c
new file mode 100644
index 0000000..ea5b3d4
--- /dev/null
+++ b/drivers/regulator/pwm-regulator.c
@@ -0,0 +1,195 @@
+/*
+ * Regulator driver for PWM Regulators
+ *
+ * Copyright (C) 2014 - STMicroelectronics Inc.
+ *
+ * Author: Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pwm.h>
+
+struct pwm_regulator_data {
+	struct regulator_desc *desc;
+	struct pwm_voltages *duty_cycle_table;
+	struct pwm_device *pwm;
+	int pwm_reg_period;
+	bool enabled;
+	int state;
+};
+
+struct pwm_voltages {
+	unsigned int uV;
+	unsigned int dutycycle;
+};
+
+static int pwm_regulator_get_voltage_sel(struct regulator_dev *dev)
+{
+	struct pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
+
+	return drvdata->state;
+}
+
+static int pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
+					 unsigned selector)
+{
+	struct pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
+	int dutycycle;
+	int ret;
+
+	dutycycle = (drvdata->pwm_reg_period / 100) *
+		    drvdata->duty_cycle_table[selector].dutycycle;
+
+	ret = pwm_config(drvdata->pwm, dutycycle, drvdata->pwm_reg_period);
+	if (ret) {
+		dev_err(&dev->dev, "Failed to configure PWM\n");
+		return ret;
+	}
+
+	drvdata->state = selector;
+
+	if (!drvdata->enabled) {
+		ret = pwm_enable(drvdata->pwm);
+		if (ret) {
+			dev_err(&dev->dev, "Failed to enable PWM\n");
+			return ret;
+		}
+		drvdata->enabled = true;
+	}
+
+	return 0;
+}
+
+static int pwm_regulator_list_voltage(struct regulator_dev *dev,
+				      unsigned selector)
+{
+	struct pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
+
+	if (selector >= dev->desc->n_voltages)
+		return -EINVAL;
+
+	return drvdata->duty_cycle_table[selector].uV;
+}
+
+static struct regulator_ops pwm_regulator_voltage_ops = {
+	.set_voltage_sel = pwm_regulator_set_voltage_sel,
+	.get_voltage_sel = pwm_regulator_get_voltage_sel,
+	.list_voltage    = pwm_regulator_list_voltage,
+	.map_voltage     = regulator_map_voltage_iterate,
+};
+
+static struct regulator_desc pwm_regulator_desc = {
+	.name		= "pwm-regulator",
+	.ops		= &pwm_regulator_voltage_ops,
+	.type		= REGULATOR_VOLTAGE,
+	.owner		= THIS_MODULE,
+	.supply_name    = "pwm",
+};
+
+static int pwm_regulator_probe(struct platform_device *pdev)
+{
+	struct pwm_regulator_data *drvdata;
+	struct property *prop;
+	struct regulator_dev *regulator;
+	struct regulator_config config = { };
+	struct device_node *np = pdev->dev.of_node;
+	int length, ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "Device Tree node missing\n");
+		return -EINVAL;
+	}
+
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->desc = &pwm_regulator_desc;
+
+	/* determine the number of voltage-table */
+	prop = of_find_property(np, "voltage-table", &length);
+	if (!prop)
+		return -EINVAL;
+
+	drvdata->desc->n_voltages = length / sizeof(*drvdata->duty_cycle_table);
+
+	/* read voltage table from DT property */
+	if (length > 0) {
+		size_t size = sizeof(*drvdata->duty_cycle_table) *
+			      drvdata->desc->n_voltages;
+
+		drvdata->duty_cycle_table = devm_kzalloc(&pdev->dev,
+							 size, GFP_KERNEL);
+		if (!drvdata->duty_cycle_table)
+			return -ENOMEM;
+
+		ret = of_property_read_u32_array(np, "voltage-table",
+				(u32 *)drvdata->duty_cycle_table,
+				length / sizeof(u32));
+		if (ret < 0)
+			return ret;
+	}
+
+	config.init_data = of_get_regulator_init_data(&pdev->dev, np);
+	if (!config.init_data)
+		return -ENOMEM;
+
+	config.of_node = np;
+	config.dev = &pdev->dev;
+	config.driver_data = drvdata;
+
+	drvdata->pwm = devm_pwm_get(&pdev->dev, NULL);
+	if (IS_ERR(drvdata->pwm)) {
+		dev_err(&pdev->dev, "Failed to get PWM\n");
+		return PTR_ERR(drvdata->pwm);
+	}
+
+	drvdata->pwm_reg_period = pwm_get_period(drvdata->pwm);
+	if (!drvdata->pwm_reg_period) {
+		dev_err(&pdev->dev, "get pwm peeriod failed\n");
+		return -EINVAL;
+	}
+
+	regulator = devm_regulator_register(&pdev->dev,
+					    drvdata->desc, &config);
+	if (IS_ERR(regulator)) {
+		dev_err(&pdev->dev, "Failed to register regulator %s\n",
+			drvdata->desc->name);
+		return PTR_ERR(regulator);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id pwm_of_match[] = {
+	{ .compatible = "pwm-regulator" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pwm_of_match);
+
+static struct platform_driver pwm_regulator_driver = {
+	.driver = {
+		.name		= "pwm-regulator",
+		.owner		= THIS_MODULE,
+		.of_match_table = of_match_ptr(pwm_of_match),
+	},
+	.probe = pwm_regulator_probe,
+};
+
+module_platform_driver(pwm_regulator_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Lee Jones <lee.jones@linaro.org>");
+MODULE_DESCRIPTION("PWM Regulator Driver");
+MODULE_ALIAS("platform:pwm-regulator");
diff --git a/drivers/regulator/st-pwm.c b/drivers/regulator/st-pwm.c
deleted file mode 100644
index 5ea78df..0000000
--- a/drivers/regulator/st-pwm.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * Regulator driver for ST's PWM Regulators
- *
- * Copyright (C) 2014 - STMicroelectronics Inc.
- *
- * Author: Lee Jones <lee.jones@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/regulator/driver.h>
-#include <linux/regulator/machine.h>
-#include <linux/regulator/of_regulator.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/pwm.h>
-
-#define ST_PWM_REG_PERIOD 8448
-
-struct st_pwm_regulator_pdata {
-	const struct regulator_desc *desc;
-	struct st_pwm_voltages *duty_cycle_table;
-};
-
-struct st_pwm_regulator_data {
-	const struct st_pwm_regulator_pdata *pdata;
-	struct pwm_device *pwm;
-	bool enabled;
-	int state;
-};
-
-struct st_pwm_voltages {
-	unsigned int uV;
-	unsigned int dutycycle;
-};
-
-static int st_pwm_regulator_get_voltage_sel(struct regulator_dev *dev)
-{
-	struct st_pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
-
-	return drvdata->state;
-}
-
-static int st_pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
-					    unsigned selector)
-{
-	struct st_pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
-	int dutycycle;
-	int ret;
-
-	dutycycle = (ST_PWM_REG_PERIOD / 100) *
-		drvdata->pdata->duty_cycle_table[selector].dutycycle;
-
-	ret = pwm_config(drvdata->pwm, dutycycle, ST_PWM_REG_PERIOD);
-	if (ret) {
-		dev_err(&dev->dev, "Failed to configure PWM\n");
-		return ret;
-	}
-
-	drvdata->state = selector;
-
-	if (!drvdata->enabled) {
-		ret = pwm_enable(drvdata->pwm);
-		if (ret) {
-			dev_err(&dev->dev, "Failed to enable PWM\n");
-			return ret;
-		}
-		drvdata->enabled = true;
-	}
-
-	return 0;
-}
-
-static int st_pwm_regulator_list_voltage(struct regulator_dev *dev,
-					 unsigned selector)
-{
-	struct st_pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
-
-	if (selector >= dev->desc->n_voltages)
-		return -EINVAL;
-
-	return drvdata->pdata->duty_cycle_table[selector].uV;
-}
-
-static struct regulator_ops st_pwm_regulator_voltage_ops = {
-	.set_voltage_sel = st_pwm_regulator_set_voltage_sel,
-	.get_voltage_sel = st_pwm_regulator_get_voltage_sel,
-	.list_voltage    = st_pwm_regulator_list_voltage,
-	.map_voltage     = regulator_map_voltage_iterate,
-};
-
-static struct st_pwm_voltages b2105_duty_cycle_table[] = {
-	{ .uV = 1114000, .dutycycle = 0,  },
-	{ .uV = 1095000, .dutycycle = 10, },
-	{ .uV = 1076000, .dutycycle = 20, },
-	{ .uV = 1056000, .dutycycle = 30, },
-	{ .uV = 1036000, .dutycycle = 40, },
-	{ .uV = 1016000, .dutycycle = 50, },
-	/* WARNING: Values above 50% duty-cycle cause boot failures. */
-};
-
-static const struct regulator_desc b2105_desc = {
-	.name		= "b2105-pwm-regulator",
-	.ops		= &st_pwm_regulator_voltage_ops,
-	.type		= REGULATOR_VOLTAGE,
-	.owner		= THIS_MODULE,
-	.n_voltages	= ARRAY_SIZE(b2105_duty_cycle_table),
-	.supply_name    = "pwm",
-};
-
-static const struct st_pwm_regulator_pdata b2105_info = {
-	.desc		  = &b2105_desc,
-	.duty_cycle_table = b2105_duty_cycle_table,
-};
-
-static const struct of_device_id st_pwm_of_match[] = {
-	{ .compatible = "st,b2105-pwm-regulator", .data = &b2105_info, },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, st_pwm_of_match);
-
-static int st_pwm_regulator_probe(struct platform_device *pdev)
-{
-	struct st_pwm_regulator_data *drvdata;
-	struct regulator_dev *regulator;
-	struct regulator_config config = { };
-	struct device_node *np = pdev->dev.of_node;
-	const struct of_device_id *of_match;
-
-	if (!np) {
-		dev_err(&pdev->dev, "Device Tree node missing\n");
-		return -EINVAL;
-	}
-
-	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-
-	of_match = of_match_device(st_pwm_of_match, &pdev->dev);
-	if (!of_match) {
-		dev_err(&pdev->dev, "failed to match of device\n");
-		return -ENODEV;
-	}
-	drvdata->pdata = of_match->data;
-
-	config.init_data = of_get_regulator_init_data(&pdev->dev, np);
-	if (!config.init_data)
-		return -ENOMEM;
-
-	config.of_node = np;
-	config.dev = &pdev->dev;
-	config.driver_data = drvdata;
-
-	drvdata->pwm = devm_pwm_get(&pdev->dev, NULL);
-	if (IS_ERR(drvdata->pwm)) {
-		dev_err(&pdev->dev, "Failed to get PWM\n");
-		return PTR_ERR(drvdata->pwm);
-	}
-
-	regulator = devm_regulator_register(&pdev->dev,
-					    drvdata->pdata->desc, &config);
-	if (IS_ERR(regulator)) {
-		dev_err(&pdev->dev, "Failed to register regulator %s\n",
-			drvdata->pdata->desc->name);
-		return PTR_ERR(regulator);
-	}
-
-	return 0;
-}
-
-static struct platform_driver st_pwm_regulator_driver = {
-	.driver = {
-		.name		= "st-pwm-regulator",
-		.owner		= THIS_MODULE,
-		.of_match_table = of_match_ptr(st_pwm_of_match),
-	},
-	.probe = st_pwm_regulator_probe,
-};
-
-module_platform_driver(st_pwm_regulator_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Lee Jones <lee.jones@linaro.org>");
-MODULE_DESCRIPTION("ST PWM Regulator Driver");
-MODULE_ALIAS("platform:st_pwm-regulator");
-- 
1.7.9.5

