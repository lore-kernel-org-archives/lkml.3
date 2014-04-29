Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaD2FfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:35:05 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45412 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaD2FfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:35:02 -0400
From: Inderpal Singh <inderpal.s@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, dianders@chromium.org
Subject: [RFC PATCH] regulator: virtual: Introduce a new virtual locker regulator type
Date: Tue, 29 Apr 2014 11:05:04 +0530
Message-Id: <1398749704-10196-1-git-send-email-inderpal.s@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some SoCs there could be requirements that two or more voltage
regulators need to maintain certain skew for proper functioning.

This patch implements a new vitual locker type regulator which can
have multiple output and input regulators. The real regulators will
be hidden under the virtual output regulators. The consumer of the
real regulators need not change anything. Only the name of the real
regulators need to be changed.

This patch has been tested on exynos5420 based smdk5420.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
---
 .../bindings/regulator/locker-regulator.txt        |  36 ++
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/locker.c                         | 472 +++++++++++++++++++++
 include/linux/regulator/locker.h                   |  35 ++
 5 files changed, 553 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/locker-regulator.txt
 create mode 100644 drivers/regulator/locker.c
 create mode 100644 include/linux/regulator/locker.h

diff --git a/Documentation/devicetree/bindings/regulator/locker-regulator.txt b/Documentation/devicetree/bindings/regulator/locker-regulator.txt
new file mode 100644
index 0000000..1ddba0a
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/locker-regulator.txt
@@ -0,0 +1,36 @@
+Locker Voltage regulators
+
+Required properties:
+- compatible: Must be "regulator-locker";
+- Must have atleast 2 vinX-supply nodes
+- Must have atleast 2 vout nodes
+- Must have maximum-spread
+- The counting for vout and vinX-supplies starts from 1 as shown below
+
+Any property defined as part of the core regulator
+binding, defined in regulator.txt, can also be used.
+
+Example:
+
+       int-voltage-locker {
+               compatible = "regulator-locker";
+               vin1-supply = <&buck2_reg>; /* real vdd_arm */
+               vin2-supply = <&buck3_reg>; /* real vdd_int */
+               maximum-spread = <300000>;
+               locker-regulators {
+                       vout1 {
+                               regulator-name = "vdd_arm";
+                               regulator-min-microvolt = <800000>;
+                               regulator-max-microvolt = <1500000>;
+                               regulator-always-on;
+                               regulator-boot-on;
+                       };
+                       vout2 {
+                               regulator-name = "vdd_int";
+                               regulator-min-microvolt = <800000>;
+                               regulator-max-microvolt = <1400000>;
+                               regulator-always-on;
+                               regulator-boot-on;
+                       };
+               };
+       };
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 65e5d7d..9efc4b8 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -54,6 +54,15 @@ config REGULATOR_USERSPACE_CONSUMER
 
 	  If unsure, say no.
 
+config REGULATOR_LOCKER_VOLTAGE
+	tristate "Locker voltage regulator support"
+	help
+	  This driver provides support for virtual voltage regulators,
+	  useful for systems which has requirements to maintain a skew
+	  between 2 or more regulators.
+
+	  If unsure, say no.
+
 config REGULATOR_88PM800
 	tristate "Marvell 88PM800 Power regulators"
 	depends on MFD_88PM800
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index c14696b2..6cde7af 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_OF) += of_regulator.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
+obj-$(CONFIG_REGULATOR_LOCKER_VOLTAGE) += locker.o
 
 obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
diff --git a/drivers/regulator/locker.c b/drivers/regulator/locker.c
new file mode 100644
index 0000000..4a39f78
--- /dev/null
+++ b/drivers/regulator/locker.c
@@ -0,0 +1,472 @@
+/*
+ * locker.c
+ *
+ * Copyright  (C) 2014 Samsung Electronics
+ * Inderpal Singh <inderpal.s@samsung.com>
+ * Doug Anderson <dianders@chromium.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/locker.h>
+#include <linux/of.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/machine.h>
+
+#define CHECK_ALGO_ERRORS 1
+
+/* Assume <= 99 MAX_REGULATORS */
+#define VIN_SUPPLY_TEMPLATE "vin%d-supply"
+#define VIN_TEMPLATE "vin%d"
+#define VOUT_TEMPLATE "vout%d"
+
+#define VIN_SUPPLY_SIZE (sizeof(VIN_SUPPLY_TEMPLATE))
+#define VIN_SIZE (sizeof(VIN_TEMPLATE))
+#define VOUT_SIZE (sizeof(VOUT_TEMPLATE))
+
+#define MAX_REGULATORS 2
+
+struct locker_voltage_data {
+	struct mutex lock;
+	int num_regs;
+	int max_spread;
+	struct regulator_dev *rdevs[MAX_REGULATORS];
+	int desired_voltages[MAX_REGULATORS];
+	int actual_voltages[MAX_REGULATORS];
+};
+
+struct locker_vreg_data {
+	int index;
+	struct regulator_desc desc;
+};
+
+/**
+ * of_get_locker_voltage_config - extract locker_voltage_config structure info
+ * @dev: device requesting for locker_voltage_config
+ *
+ * Populates locker_voltage_config structure by extracting data from device
+ * tree node, returns a pointer to the populated structure or NULL if memory
+ * alloc fails.
+ */
+static struct locker_voltage_config *
+of_get_locker_voltage_config(struct device *dev)
+{
+	struct locker_voltage_config *config;
+	struct locker_voltage_regulator_config *regulator_configs;
+	struct device_node *np = dev->of_node;
+	struct device_node *vout_np, *regulators_np, *reg_np;
+	const __be32 *spread;
+	struct regulator_init_data *init_data;
+	char name[100];
+	char *vin_strs;
+	int i;
+
+	config = devm_kzalloc(dev, sizeof(*config), GFP_KERNEL);
+	if (!config)
+		return ERR_PTR(-ENOMEM);
+
+	regulators_np = of_find_node_by_name(np, "locker-regulators");
+	if (!regulators_np) {
+		dev_err(dev, "could not find locker regulators sub-node\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* count the number of regulators to be supported */
+	for_each_child_of_node(regulators_np, reg_np)
+		config->num_regs++;
+
+	if (config->num_regs < 2 || config->num_regs > MAX_REGULATORS)
+		return ERR_PTR(-EINVAL);
+
+
+	spread  = of_get_property(np, "maximum-spread", NULL);
+	if (spread)
+		config->max_spread = be32_to_cpu(*spread);
+	else
+		return ERR_PTR(-EINVAL);
+
+	regulator_configs = devm_kzalloc(dev, sizeof(*regulator_configs) *
+						config->num_regs, GFP_KERNEL);
+	if (!regulator_configs)
+		return ERR_PTR(-ENOMEM);
+
+	config->regulator_configs = regulator_configs;
+
+	vin_strs = devm_kzalloc(dev, sizeof(*vin_strs) * config->num_regs *
+						VIN_SIZE, GFP_KERNEL);
+	if (!vin_strs)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < config->num_regs; i++) {
+
+		snprintf(name, VOUT_SIZE, VOUT_TEMPLATE, i + 1);
+		vout_np = of_find_node_by_name(np, name);
+		if (!vout_np) {
+			dev_err(dev, "could not find vout sub-node\n");
+			return ERR_PTR(-EINVAL);
+		}
+
+		regulator_configs[i].init_data = of_get_regulator_init_data(dev,
+								vout_np);
+		if (!regulator_configs[i].init_data)
+			return ERR_PTR(-EINVAL);
+
+		init_data = regulator_configs[i].init_data;
+		regulator_configs[i].supply_name = init_data->constraints.name;
+
+		snprintf(name, VIN_SUPPLY_SIZE, VIN_SUPPLY_TEMPLATE, i + 1);
+		if (of_find_property(np, name, NULL)) {
+			snprintf(vin_strs, VIN_SIZE, VIN_TEMPLATE, i + 1);
+			regulator_configs[i].input_supply = vin_strs;
+		} else
+			return ERR_PTR(-EINVAL);
+
+		vin_strs += VIN_SIZE;
+	}
+
+	return config;
+}
+
+static int find_min(int volt[], int ignore_idx, int num_regs)
+{
+	int i;
+	int min_volt = INT_MAX;
+
+	for (i = 0; i < num_regs; i++) {
+		if (i != ignore_idx && volt[i] < min_volt)
+			min_volt = volt[i];
+	}
+
+	return min_volt;
+}
+
+static int find_max(int volt[], int ignore_idx, int num_regs)
+{
+	int i;
+	int max_volt = 0;
+
+	for (i = 0; i < num_regs; i++) {
+		if (i != ignore_idx && volt[i] > max_volt)
+			max_volt = volt[i];
+	}
+
+	return max_volt;
+}
+
+#if CHECK_ALGO_ERRORS
+static void error_check_partial(struct locker_voltage_data *drvdata)
+{
+	int i, j;
+	int max_spread = drvdata->max_spread;
+	int num_regs = drvdata->num_regs;
+	int *actual_voltages = drvdata->actual_voltages;
+
+	for (i = 0; i < num_regs; i++) {
+		for (j = 0; j < num_regs; j++) {
+			if (abs(actual_voltages[i] - actual_voltages[j]) >
+								max_spread) {
+				pr_err("ERROR: %d vs %d: %d vs. %d\n", i, j,
+				actual_voltages[i], actual_voltages[j]);
+			}
+		}
+	}
+}
+
+static void error_check_final(int best_voltages[], struct locker_voltage_data
+								*drvdata)
+{
+	int i;
+	int num_regs = drvdata->num_regs;
+	int *actual_voltages = drvdata->actual_voltages;
+
+	/* Make sure we're where we thought we should be */
+	for (i = 0; i < num_regs; i++) {
+		if (actual_voltages[i] != best_voltages[i]) {
+			pr_err("ERROR: %d: %d != %d\n", i,
+			actual_voltages[i], best_voltages[i]);
+		}
+	}
+}
+#else
+static void error_check_partial(struct locker_voltage_data *drvdata) {}
+static void error_check_final(int best_voltages[], struct locker_voltage_data
+								*drvdata) {}
+#endif
+
+static int set_real_voltage(int reg_idx, int to_voltage,
+					struct locker_voltage_data *drvdata)
+{
+	int min_voltage, max_voltage;
+	int max_spread, best_voltages[MAX_REGULATORS];
+	int *desired_voltages, *actual_voltages;
+	bool is_rising;
+	int num_regs, i, err = 0;
+
+	max_spread = drvdata->max_spread;
+	num_regs = drvdata->num_regs;
+	desired_voltages = drvdata->desired_voltages;
+	actual_voltages = drvdata->actual_voltages;
+
+	mutex_lock(&drvdata->lock);
+
+	/* All voltage changes will follow the trend of this one */
+	is_rising = to_voltage > desired_voltages[reg_idx];
+
+	desired_voltages[reg_idx] = to_voltage;
+
+	/* Figure out the best we're going to end up with */
+	max_voltage = find_max(desired_voltages, -1, num_regs);
+	min_voltage = find_min(desired_voltages, -1, num_regs);
+	min_voltage = max(min_voltage, max_voltage - max_spread);
+
+	for (i = 0; i < num_regs; i++)
+		best_voltages[i] = max(desired_voltages[i], min_voltage);
+
+	/* Loop around, trying to make the best change per loop */
+	while (1) {
+		int best_idx = -1;
+		int best_voltage = 0;
+
+		error_check_partial(drvdata);
+
+		for (i = 0; i < num_regs; i++) {
+			int max_possible;
+			int min_possible;
+			int volt_possible;
+
+			if (actual_voltages[i] == best_voltages[i])
+				continue;
+
+			/* We'll need to keep between these values this loop */
+			max_possible = find_min(actual_voltages, i, num_regs) +
+								max_spread;
+			min_possible = find_max(actual_voltages, i, num_regs) -
+								max_spread;
+
+			/* Try to move towards the best if we can */
+			volt_possible = max(best_voltages[i], min_possible);
+			volt_possible = min(volt_possible, max_possible);
+
+			if (volt_possible == actual_voltages[i])
+				continue;
+
+			/* Move lowest voltage if rising; highest if falling */
+			if ((best_idx == -1) ||
+				(is_rising && volt_possible < best_voltage) ||
+				(!is_rising && volt_possible > best_voltage)) {
+					best_idx = i;
+					best_voltage = volt_possible;
+			}
+		}
+
+		if (best_idx == -1)
+			break;
+
+		err = regulator_set_voltage(drvdata->rdevs[best_idx]->supply,
+						best_voltage, best_voltage);
+		if (err)
+			break;
+
+		actual_voltages[best_idx] = best_voltage;
+	}
+
+	/* Error check */
+	error_check_final(best_voltages, drvdata);
+
+	mutex_unlock(&drvdata->lock);
+
+	return err;
+}
+
+static int locker_voltage_set_voltage(struct regulator_dev *rdev, int min_uV,
+						int max_uV, unsigned *selector)
+{
+	struct locker_vreg_data *vreg_data = rdev_get_drvdata(rdev);
+	struct locker_voltage_data *drvdata = dev_get_drvdata(rdev->dev.parent);
+	int index = vreg_data->index;
+
+	return set_real_voltage(index, min_uV, drvdata);
+}
+
+static int locker_voltage_get_voltage(struct regulator_dev *rdev)
+{
+	struct locker_vreg_data *vreg_data = rdev_get_drvdata(rdev);
+	struct locker_voltage_data *drvdata = dev_get_drvdata(rdev->dev.parent);
+	int index = vreg_data->index;
+	int voltage;
+
+	mutex_lock(&drvdata->lock);
+	voltage = drvdata->actual_voltages[index];
+	mutex_unlock(&drvdata->lock);
+
+	return voltage;
+}
+
+static struct regulator_ops locker_voltage_ops = {
+	.set_voltage = locker_voltage_set_voltage,
+	.get_voltage = locker_voltage_get_voltage,
+};
+
+static int locker_voltage_probe(struct platform_device *pdev)
+{
+	struct locker_voltage_config *config;
+	struct locker_voltage_data *drvdata;
+	struct locker_vreg_data *vreg_data;
+	int ret, i, j;
+	int *actual_voltages, *desired_voltages;
+
+	if (pdev->dev.of_node) {
+		config = of_get_locker_voltage_config(&pdev->dev);
+		if (IS_ERR(config))
+			return PTR_ERR(config);
+	} else {
+		config = pdev->dev.platform_data;
+	}
+
+	if (!config)
+		return -ENOMEM;
+
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (drvdata == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate device data\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	mutex_init(&drvdata->lock);
+	drvdata->num_regs = config->num_regs;
+	drvdata->max_spread = config->max_spread;
+	actual_voltages = drvdata->actual_voltages;
+	desired_voltages = drvdata->desired_voltages;
+
+	vreg_data = devm_kzalloc(&pdev->dev, sizeof(*vreg_data) *
+						config->num_regs, GFP_KERNEL);
+	if (vreg_data == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate vreg data\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	platform_set_drvdata(pdev, drvdata);
+
+	for (i = 0; i < config->num_regs; i++) {
+		struct regulator_config cfg = { };
+		struct regulator *real_vdd;
+
+		vreg_data[i].desc.name = devm_kstrdup(&pdev->dev,
+			config->regulator_configs[i].supply_name, GFP_KERNEL);
+		if (vreg_data[i].desc.name == NULL) {
+			dev_err(&pdev->dev, "Failed to allocate supply name\n");
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		vreg_data[i].desc.type = REGULATOR_VOLTAGE;
+		vreg_data[i].desc.owner = THIS_MODULE;
+		vreg_data[i].desc.ops = &locker_voltage_ops;
+		vreg_data[i].index = i;
+
+		if (config->regulator_configs[i].input_supply) {
+			vreg_data[i].desc.supply_name = devm_kstrdup(&pdev->dev,
+			config->regulator_configs[i].input_supply, GFP_KERNEL);
+			if (!vreg_data[i].desc.supply_name) {
+				dev_err(&pdev->dev,
+				"Failed to allocate input supply\n");
+				ret = -ENOMEM;
+				goto err;
+			}
+		}
+
+		cfg.dev = &pdev->dev;
+		cfg.init_data = config->regulator_configs[i].init_data;
+		cfg.driver_data = &vreg_data[i];
+		cfg.of_node = pdev->dev.of_node;
+
+		drvdata->rdevs[i] = regulator_register(&vreg_data[i].desc,
+									&cfg);
+		if (IS_ERR(drvdata->rdevs[i])) {
+			ret = PTR_ERR(drvdata->rdevs[i]);
+			dev_err(&pdev->dev, "Failed to register regulator: %d\n"
+									, ret);
+			goto err;
+		}
+
+		real_vdd = drvdata->rdevs[i]->supply;
+		actual_voltages[i] = regulator_get_voltage(real_vdd);
+		desired_voltages[i] = actual_voltages[i];
+	}
+
+	for (i = 0; i < config->num_regs; i++) {
+		for (j = 0; j < config->num_regs; j++) {
+			if (abs(actual_voltages[i] - actual_voltages[j]) >
+							config->max_spread) {
+				pr_warn("WARN: %d vs %d: %d vs. %d\n", i, j,
+				actual_voltages[i], actual_voltages[j]);
+			}
+		}
+	}
+
+	return 0;
+
+err:
+	while (--i >= 0)
+		regulator_unregister(drvdata->rdevs[i]);
+err_out:
+	return ret;
+}
+
+static int locker_voltage_remove(struct platform_device *pdev)
+{
+	struct locker_voltage_data *drvdata = platform_get_drvdata(pdev);
+	int i, num_regs = drvdata->num_regs;
+
+	for (i = 0; i < num_regs; i++)
+		regulator_unregister(drvdata->rdevs[i]);
+
+	return 0;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id locker_of_match[] = {
+	{ .compatible = "regulator-locker", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, locker_of_match);
+#endif
+
+static struct platform_driver regulator_locker_voltage_driver = {
+	.probe		= locker_voltage_probe,
+	.remove		= locker_voltage_remove,
+	.driver		= {
+		.name           = "reg-locker-voltage",
+		.owner		= THIS_MODULE,
+		.of_match_table = of_match_ptr(locker_of_match),
+	},
+};
+
+static int __init regulator_locker_voltage_init(void)
+{
+	return platform_driver_register(&regulator_locker_voltage_driver);
+}
+subsys_initcall_sync(regulator_locker_voltage_init);
+
+static void __exit regulator_locker_voltage_exit(void)
+{
+	platform_driver_unregister(&regulator_locker_voltage_driver);
+}
+module_exit(regulator_locker_voltage_exit);
+
+MODULE_DESCRIPTION("Locker voltage regulator");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:reg-locker-voltage");
+MODULE_AUTHOR("Inderpal Singh <inderpal.s@samsung.com>");
+MODULE_AUTHOR("Doug Anderson <dianders@chromium.org>");
diff --git a/include/linux/regulator/locker.h b/include/linux/regulator/locker.h
new file mode 100644
index 0000000..21c254f
--- /dev/null
+++ b/include/linux/regulator/locker.h
@@ -0,0 +1,35 @@
+/*
+ * locker.h
+ *
+ * Copyright 2014 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#ifndef __REGULATOR_LOCKER_H
+#define __REGULATOR_LOCKER_H
+
+struct regulator_init_data;
+
+/**
+ * struct locker_voltage_config - locker_voltage_config structure
+ * @supply_name:	Name of the regulator supply
+ * @input_supply:	Name of the input regulator supply
+ * @init_data:		regulator_init_data
+ *
+ */
+struct locker_voltage_regulator_config {
+	const char *supply_name;
+	const char *input_supply;
+	struct regulator_init_data *init_data;
+};
+
+struct locker_voltage_config {
+	struct locker_voltage_regulator_config *regulator_configs;
+	int num_regs;
+	int max_spread;
+};
+#endif
-- 
1.8.3.2

