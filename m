Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaIVCxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:53:23 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47624 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaIVCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:53:19 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, lee.jones@linaro.org,
        broonie@kernel.org, Chris Zhong <zyw@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v4 1/2] regulator: st-pwm: get voltage and duty table from dts
Date: Mon, 22 Sep 2014 10:52:59 +0800
Message-Id: <1411354380-14326-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411354380-14326-1-git-send-email-zyw@rock-chips.com>
References: <1411354380-14326-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get voltage & duty table from device tree might be better, other platforms can also use this
driver without any modify.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

Reviewed-by: Doug Anderson <dianders@chromium.org>
---

Changes in v4:
Adviced by Doug Anderson
- improve kconfig
- add const for desc structure

Changes in v3:
Adviced by Doug Anderson
- Make Kconfig & Makefile alphabetical
- remove pwm_reg_period from pwm_regulator_data
- modify the calculation in pwm_regulator_set_voltage_sel
- add length validity check

Changes in v2:
Adviced by Lee Jones
- rename the file
- remove all the prefix st_
- add depend on PWM in Kconfig

 drivers/regulator/Kconfig         |   13 +--
 drivers/regulator/Makefile        |    2 +-
 drivers/regulator/pwm-regulator.c |  197 +++++++++++++++++++++++++++++++++++++
 drivers/regulator/st-pwm.c        |  190 -----------------------------------
 4 files changed, 205 insertions(+), 197 deletions(-)
 create mode 100644 drivers/regulator/pwm-regulator.c
 delete mode 100644 drivers/regulator/st-pwm.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index fb32bab..b927cab 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -449,6 +449,13 @@ config REGULATOR_PFUZE100
 	  Say y here to support the regulators found on the Freescale
 	  PFUZE100/PFUZE200 PMIC.
 
+config REGULATOR_PWM
+	tristate "PWM voltage regulator"
+	depends on PWM
+	help
+	  This driver supports PWM controlled voltage regulators. PWM
+	  duty cycle can increase or decrease the voltage.
+
 config REGULATOR_RC5T583
 	tristate "RICOH RC5T583 Power regulators"
 	depends on MFD_RC5T583
@@ -493,12 +500,6 @@ config REGULATOR_S5M8767
 	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
 	 supports DVS mode with 8bits of output voltage control.
 
-config REGULATOR_ST_PWM
-	tristate "STMicroelectronics PWM voltage regulator"
-	depends on ARCH_STI
-	help
-	 This driver supports ST's PWM controlled voltage regulators.
-
 config REGULATOR_TI_ABB
 	tristate "TI Adaptive Body Bias on-chip LDO"
 	depends on ARCH_OMAP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 236fdbb..f3cf5a5 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
 obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
+obj-$(CONFIG_REGULATOR_PWM) += pwm-regulator.o
 obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
 obj-$(CONFIG_REGULATOR_PBIAS) += pbias-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
@@ -66,7 +67,6 @@ obj-$(CONFIG_REGULATOR_RK808)   += rk808-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
-obj-$(CONFIG_REGULATOR_ST_PWM) += st-pwm.o
 obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
 obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
diff --git a/drivers/regulator/pwm-regulator.c b/drivers/regulator/pwm-regulator.c
new file mode 100644
index 0000000..d3f55ea
--- /dev/null
+++ b/drivers/regulator/pwm-regulator.c
@@ -0,0 +1,197 @@
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
+	struct regulator_desc desc;
+	struct pwm_voltages *duty_cycle_table;
+	struct pwm_device *pwm;
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
+	unsigned int pwm_reg_period;
+	int dutycycle;
+	int ret;
+
+	pwm_reg_period = pwm_get_period(drvdata->pwm);
+
+	dutycycle = (pwm_reg_period *
+		    drvdata->duty_cycle_table[selector].dutycycle) / 100;
+
+	ret = pwm_config(drvdata->pwm, dutycycle, pwm_reg_period);
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
+	if (selector >= drvdata->desc.n_voltages)
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
+static const struct regulator_desc pwm_regulator_desc = {
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
+	memcpy(&drvdata->desc, &pwm_regulator_desc, sizeof(pwm_regulator_desc));
+
+	/* determine the number of voltage-table */
+	prop = of_find_property(np, "voltage-table", &length);
+	if (!prop) {
+		dev_err(&pdev->dev, "No voltage-table\n");
+		return -EINVAL;
+	}
+
+	if ((length < sizeof(*drvdata->duty_cycle_table)) ||
+	    (length % sizeof(*drvdata->duty_cycle_table))) {
+		dev_err(&pdev->dev, "voltage-table length(%d) is invalid\n",
+			length);
+		return -EINVAL;
+	}
+
+	drvdata->desc.n_voltages = length / sizeof(*drvdata->duty_cycle_table);
+
+	drvdata->duty_cycle_table = devm_kzalloc(&pdev->dev,
+						 length, GFP_KERNEL);
+	if (!drvdata->duty_cycle_table)
+		return -ENOMEM;
+
+	/* read voltage table from DT property */
+	ret = of_property_read_u32_array(np, "voltage-table",
+					 (u32 *)drvdata->duty_cycle_table,
+					 length / sizeof(u32));
+	if (ret < 0) {
+		dev_err(&pdev->dev, "read voltage-table failed\n");
+		return ret;
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
+	regulator = devm_regulator_register(&pdev->dev,
+					    &drvdata->desc, &config);
+	if (IS_ERR(regulator)) {
+		dev_err(&pdev->dev, "Failed to register regulator %s\n",
+			drvdata->desc.name);
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

