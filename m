Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3HFKEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:04:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33894 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3HFKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:04:40 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Tue,  6 Aug 2013 11:04:26 +0100
Message-Id: <1375783466-24722-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Move helpers for drivers out into a separate file
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Reduce the size of core.c a bit.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/Makefile  |   2 +-
 drivers/regulator/core.c    | 341 -----------------------------------------
 drivers/regulator/helpers.c | 364 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 365 insertions(+), 342 deletions(-)
 create mode 100644 drivers/regulator/helpers.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 8c14d29..4b57deb 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -3,7 +3,7 @@
 #
 
 
-obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
+obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o helpers.o
 obj-$(CONFIG_OF) += of_regulator.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f24f401..78b8dea 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1964,77 +1964,6 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
 }
 EXPORT_SYMBOL_GPL(regulator_disable_deferred);
 
-/**
- * regulator_is_enabled_regmap - standard is_enabled() for regmap users
- *
- * @rdev: regulator to operate on
- *
- * Regulators that use regmap for their register I/O can set the
- * enable_reg and enable_mask fields in their descriptor and then use
- * this as their is_enabled operation, saving some code.
- */
-int regulator_is_enabled_regmap(struct regulator_dev *rdev)
-{
-	unsigned int val;
-	int ret;
-
-	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
-	if (ret != 0)
-		return ret;
-
-	if (rdev->desc->enable_is_inverted)
-		return (val & rdev->desc->enable_mask) == 0;
-	else
-		return (val & rdev->desc->enable_mask) != 0;
-}
-EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
-
-/**
- * regulator_enable_regmap - standard enable() for regmap users
- *
- * @rdev: regulator to operate on
- *
- * Regulators that use regmap for their register I/O can set the
- * enable_reg and enable_mask fields in their descriptor and then use
- * this as their enable() operation, saving some code.
- */
-int regulator_enable_regmap(struct regulator_dev *rdev)
-{
-	unsigned int val;
-
-	if (rdev->desc->enable_is_inverted)
-		val = 0;
-	else
-		val = rdev->desc->enable_mask;
-
-	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask, val);
-}
-EXPORT_SYMBOL_GPL(regulator_enable_regmap);
-
-/**
- * regulator_disable_regmap - standard disable() for regmap users
- *
- * @rdev: regulator to operate on
- *
- * Regulators that use regmap for their register I/O can set the
- * enable_reg and enable_mask fields in their descriptor and then use
- * this as their disable() operation, saving some code.
- */
-int regulator_disable_regmap(struct regulator_dev *rdev)
-{
-	unsigned int val;
-
-	if (rdev->desc->enable_is_inverted)
-		val = rdev->desc->enable_mask;
-	else
-		val = 0;
-
-	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-				  rdev->desc->enable_mask, val);
-}
-EXPORT_SYMBOL_GPL(regulator_disable_regmap);
-
 static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
 	/* A GPIO control always takes precedence */
@@ -2299,235 +2228,6 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 }
 EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
 
-/**
- * regulator_get_voltage_sel_regmap - standard get_voltage_sel for regmap users
- *
- * @rdev: regulator to operate on
- *
- * Regulators that use regmap for their register I/O can set the
- * vsel_reg and vsel_mask fields in their descriptor and then use this
- * as their get_voltage_vsel operation, saving some code.
- */
-int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev)
-{
-	unsigned int val;
-	int ret;
-
-	ret = regmap_read(rdev->regmap, rdev->desc->vsel_reg, &val);
-	if (ret != 0)
-		return ret;
-
-	val &= rdev->desc->vsel_mask;
-	val >>= ffs(rdev->desc->vsel_mask) - 1;
-
-	return val;
-}
-EXPORT_SYMBOL_GPL(regulator_get_voltage_sel_regmap);
-
-/**
- * regulator_set_voltage_sel_regmap - standard set_voltage_sel for regmap users
- *
- * @rdev: regulator to operate on
- * @sel: Selector to set
- *
- * Regulators that use regmap for their register I/O can set the
- * vsel_reg and vsel_mask fields in their descriptor and then use this
- * as their set_voltage_vsel operation, saving some code.
- */
-int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel)
-{
-	int ret;
-
-	sel <<= ffs(rdev->desc->vsel_mask) - 1;
-
-	ret = regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
-				  rdev->desc->vsel_mask, sel);
-	if (ret)
-		return ret;
-
-	if (rdev->desc->apply_bit)
-		ret = regmap_update_bits(rdev->regmap, rdev->desc->apply_reg,
-					 rdev->desc->apply_bit,
-					 rdev->desc->apply_bit);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(regulator_set_voltage_sel_regmap);
-
-/**
- * regulator_map_voltage_iterate - map_voltage() based on list_voltage()
- *
- * @rdev: Regulator to operate on
- * @min_uV: Lower bound for voltage
- * @max_uV: Upper bound for voltage
- *
- * Drivers implementing set_voltage_sel() and list_voltage() can use
- * this as their map_voltage() operation.  It will find a suitable
- * voltage by calling list_voltage() until it gets something in bounds
- * for the requested voltages.
- */
-int regulator_map_voltage_iterate(struct regulator_dev *rdev,
-				  int min_uV, int max_uV)
-{
-	int best_val = INT_MAX;
-	int selector = 0;
-	int i, ret;
-
-	/* Find the smallest voltage that falls within the specified
-	 * range.
-	 */
-	for (i = 0; i < rdev->desc->n_voltages; i++) {
-		ret = rdev->desc->ops->list_voltage(rdev, i);
-		if (ret < 0)
-			continue;
-
-		if (ret < best_val && ret >= min_uV && ret <= max_uV) {
-			best_val = ret;
-			selector = i;
-		}
-	}
-
-	if (best_val != INT_MAX)
-		return selector;
-	else
-		return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(regulator_map_voltage_iterate);
-
-/**
- * regulator_map_voltage_ascend - map_voltage() for ascendant voltage list
- *
- * @rdev: Regulator to operate on
- * @min_uV: Lower bound for voltage
- * @max_uV: Upper bound for voltage
- *
- * Drivers that have ascendant voltage list can use this as their
- * map_voltage() operation.
- */
-int regulator_map_voltage_ascend(struct regulator_dev *rdev,
-				 int min_uV, int max_uV)
-{
-	int i, ret;
-
-	for (i = 0; i < rdev->desc->n_voltages; i++) {
-		ret = rdev->desc->ops->list_voltage(rdev, i);
-		if (ret < 0)
-			continue;
-
-		if (ret > max_uV)
-			break;
-
-		if (ret >= min_uV && ret <= max_uV)
-			return i;
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(regulator_map_voltage_ascend);
-
-/**
- * regulator_map_voltage_linear - map_voltage() for simple linear mappings
- *
- * @rdev: Regulator to operate on
- * @min_uV: Lower bound for voltage
- * @max_uV: Upper bound for voltage
- *
- * Drivers providing min_uV and uV_step in their regulator_desc can
- * use this as their map_voltage() operation.
- */
-int regulator_map_voltage_linear(struct regulator_dev *rdev,
-				 int min_uV, int max_uV)
-{
-	int ret, voltage;
-
-	/* Allow uV_step to be 0 for fixed voltage */
-	if (rdev->desc->n_voltages == 1 && rdev->desc->uV_step == 0) {
-		if (min_uV <= rdev->desc->min_uV && rdev->desc->min_uV <= max_uV)
-			return 0;
-		else
-			return -EINVAL;
-	}
-
-	if (!rdev->desc->uV_step) {
-		BUG_ON(!rdev->desc->uV_step);
-		return -EINVAL;
-	}
-
-	if (min_uV < rdev->desc->min_uV)
-		min_uV = rdev->desc->min_uV;
-
-	ret = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
-	if (ret < 0)
-		return ret;
-
-	ret += rdev->desc->linear_min_sel;
-
-	/* Map back into a voltage to verify we're still in bounds */
-	voltage = rdev->desc->ops->list_voltage(rdev, ret);
-	if (voltage < min_uV || voltage > max_uV)
-		return -EINVAL;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(regulator_map_voltage_linear);
-
-/**
- * regulator_map_voltage_linear - map_voltage() for multiple linear ranges
- *
- * @rdev: Regulator to operate on
- * @min_uV: Lower bound for voltage
- * @max_uV: Upper bound for voltage
- *
- * Drivers providing linear_ranges in their descriptor can use this as
- * their map_voltage() callback.
- */
-int regulator_map_voltage_linear_range(struct regulator_dev *rdev,
-				       int min_uV, int max_uV)
-{
-	const struct regulator_linear_range *range;
-	int ret = -EINVAL;
-	int voltage, i;
-
-	if (!rdev->desc->n_linear_ranges) {
-		BUG_ON(!rdev->desc->n_linear_ranges);
-		return -EINVAL;
-	}
-
-	for (i = 0; i < rdev->desc->n_linear_ranges; i++) {
-		range = &rdev->desc->linear_ranges[i];
-
-		if (!(min_uV <= range->max_uV && max_uV >= range->min_uV))
-			continue;
-
-		if (min_uV <= range->min_uV)
-			min_uV = range->min_uV;
-
-		/* range->uV_step == 0 means fixed voltage range */
-		if (range->uV_step == 0) {
-			ret = 0;
-		} else {
-			ret = DIV_ROUND_UP(min_uV - range->min_uV,
-					   range->uV_step);
-			if (ret < 0)
-				return ret;
-		}
-
-		ret += range->min_sel;
-
-		break;
-	}
-
-	if (i == rdev->desc->n_linear_ranges)
-		return -EINVAL;
-
-	/* Map back into a voltage to verify we're still in bounds */
-	voltage = rdev->desc->ops->list_voltage(rdev, ret);
-	if (voltage < min_uV || voltage > max_uV)
-		return -EINVAL;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(regulator_map_voltage_linear_range);
-
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
@@ -3131,47 +2831,6 @@ out:
 EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
 
 /**
- * regulator_set_bypass_regmap - Default set_bypass() using regmap
- *
- * @rdev: device to operate on.
- * @enable: state to set.
- */
-int regulator_set_bypass_regmap(struct regulator_dev *rdev, bool enable)
-{
-	unsigned int val;
-
-	if (enable)
-		val = rdev->desc->bypass_mask;
-	else
-		val = 0;
-
-	return regmap_update_bits(rdev->regmap, rdev->desc->bypass_reg,
-				  rdev->desc->bypass_mask, val);
-}
-EXPORT_SYMBOL_GPL(regulator_set_bypass_regmap);
-
-/**
- * regulator_get_bypass_regmap - Default get_bypass() using regmap
- *
- * @rdev: device to operate on.
- * @enable: current state.
- */
-int regulator_get_bypass_regmap(struct regulator_dev *rdev, bool *enable)
-{
-	unsigned int val;
-	int ret;
-
-	ret = regmap_read(rdev->regmap, rdev->desc->bypass_reg, &val);
-	if (ret != 0)
-		return ret;
-
-	*enable = val & rdev->desc->bypass_mask;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(regulator_get_bypass_regmap);
-
-/**
  * regulator_allow_bypass - allow the regulator to go into bypass mode
  *
  * @regulator: Regulator to configure
diff --git a/drivers/regulator/helpers.c b/drivers/regulator/helpers.c
new file mode 100644
index 0000000..85c474b
--- /dev/null
+++ b/drivers/regulator/helpers.c
@@ -0,0 +1,364 @@
+/*
+ * helpers.c  --  Voltage/Current Regulator framework helper functions.
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ * Copyright 2008 SlimLogic Ltd.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/driver.h>
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/regulator.h>
+
+/**
+ * regulator_is_enabled_regmap - standard is_enabled() for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their descriptor and then use
+ * this as their is_enabled operation, saving some code.
+ */
+int regulator_is_enabled_regmap(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	if (rdev->desc->enable_is_inverted)
+		return (val & rdev->desc->enable_mask) == 0;
+	else
+		return (val & rdev->desc->enable_mask) != 0;
+}
+EXPORT_SYMBOL_GPL(regulator_is_enabled_regmap);
+
+/**
+ * regulator_enable_regmap - standard enable() for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their descriptor and then use
+ * this as their enable() operation, saving some code.
+ */
+int regulator_enable_regmap(struct regulator_dev *rdev)
+{
+	unsigned int val;
+
+	if (rdev->desc->enable_is_inverted)
+		val = 0;
+	else
+		val = rdev->desc->enable_mask;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask, val);
+}
+EXPORT_SYMBOL_GPL(regulator_enable_regmap);
+
+/**
+ * regulator_disable_regmap - standard disable() for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their descriptor and then use
+ * this as their disable() operation, saving some code.
+ */
+int regulator_disable_regmap(struct regulator_dev *rdev)
+{
+	unsigned int val;
+
+	if (rdev->desc->enable_is_inverted)
+		val = rdev->desc->enable_mask;
+	else
+		val = 0;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+				  rdev->desc->enable_mask, val);
+}
+EXPORT_SYMBOL_GPL(regulator_disable_regmap);
+
+/**
+ * regulator_get_voltage_sel_regmap - standard get_voltage_sel for regmap users
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * vsel_reg and vsel_mask fields in their descriptor and then use this
+ * as their get_voltage_vsel operation, saving some code.
+ */
+int regulator_get_voltage_sel_regmap(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->vsel_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	val &= rdev->desc->vsel_mask;
+	val >>= ffs(rdev->desc->vsel_mask) - 1;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(regulator_get_voltage_sel_regmap);
+
+/**
+ * regulator_set_voltage_sel_regmap - standard set_voltage_sel for regmap users
+ *
+ * @rdev: regulator to operate on
+ * @sel: Selector to set
+ *
+ * Regulators that use regmap for their register I/O can set the
+ * vsel_reg and vsel_mask fields in their descriptor and then use this
+ * as their set_voltage_vsel operation, saving some code.
+ */
+int regulator_set_voltage_sel_regmap(struct regulator_dev *rdev, unsigned sel)
+{
+	int ret;
+
+	sel <<= ffs(rdev->desc->vsel_mask) - 1;
+
+	ret = regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
+				  rdev->desc->vsel_mask, sel);
+	if (ret)
+		return ret;
+
+	if (rdev->desc->apply_bit)
+		ret = regmap_update_bits(rdev->regmap, rdev->desc->apply_reg,
+					 rdev->desc->apply_bit,
+					 rdev->desc->apply_bit);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_voltage_sel_regmap);
+
+/**
+ * regulator_map_voltage_iterate - map_voltage() based on list_voltage()
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers implementing set_voltage_sel() and list_voltage() can use
+ * this as their map_voltage() operation.  It will find a suitable
+ * voltage by calling list_voltage() until it gets something in bounds
+ * for the requested voltages.
+ */
+int regulator_map_voltage_iterate(struct regulator_dev *rdev,
+				  int min_uV, int max_uV)
+{
+	int best_val = INT_MAX;
+	int selector = 0;
+	int i, ret;
+
+	/* Find the smallest voltage that falls within the specified
+	 * range.
+	 */
+	for (i = 0; i < rdev->desc->n_voltages; i++) {
+		ret = rdev->desc->ops->list_voltage(rdev, i);
+		if (ret < 0)
+			continue;
+
+		if (ret < best_val && ret >= min_uV && ret <= max_uV) {
+			best_val = ret;
+			selector = i;
+		}
+	}
+
+	if (best_val != INT_MAX)
+		return selector;
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_iterate);
+
+/**
+ * regulator_map_voltage_ascend - map_voltage() for ascendant voltage list
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers that have ascendant voltage list can use this as their
+ * map_voltage() operation.
+ */
+int regulator_map_voltage_ascend(struct regulator_dev *rdev,
+				 int min_uV, int max_uV)
+{
+	int i, ret;
+
+	for (i = 0; i < rdev->desc->n_voltages; i++) {
+		ret = rdev->desc->ops->list_voltage(rdev, i);
+		if (ret < 0)
+			continue;
+
+		if (ret > max_uV)
+			break;
+
+		if (ret >= min_uV && ret <= max_uV)
+			return i;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_ascend);
+
+/**
+ * regulator_map_voltage_linear - map_voltage() for simple linear mappings
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers providing min_uV and uV_step in their regulator_desc can
+ * use this as their map_voltage() operation.
+ */
+int regulator_map_voltage_linear(struct regulator_dev *rdev,
+				 int min_uV, int max_uV)
+{
+	int ret, voltage;
+
+	/* Allow uV_step to be 0 for fixed voltage */
+	if (rdev->desc->n_voltages == 1 && rdev->desc->uV_step == 0) {
+		if (min_uV <= rdev->desc->min_uV && rdev->desc->min_uV <= max_uV)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
+	if (!rdev->desc->uV_step) {
+		BUG_ON(!rdev->desc->uV_step);
+		return -EINVAL;
+	}
+
+	if (min_uV < rdev->desc->min_uV)
+		min_uV = rdev->desc->min_uV;
+
+	ret = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
+	if (ret < 0)
+		return ret;
+
+	ret += rdev->desc->linear_min_sel;
+
+	/* Map back into a voltage to verify we're still in bounds */
+	voltage = rdev->desc->ops->list_voltage(rdev, ret);
+	if (voltage < min_uV || voltage > max_uV)
+		return -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_linear);
+
+/**
+ * regulator_map_voltage_linear - map_voltage() for multiple linear ranges
+ *
+ * @rdev: Regulator to operate on
+ * @min_uV: Lower bound for voltage
+ * @max_uV: Upper bound for voltage
+ *
+ * Drivers providing linear_ranges in their descriptor can use this as
+ * their map_voltage() callback.
+ */
+int regulator_map_voltage_linear_range(struct regulator_dev *rdev,
+				       int min_uV, int max_uV)
+{
+	const struct regulator_linear_range *range;
+	int ret = -EINVAL;
+	int voltage, i;
+
+	if (!rdev->desc->n_linear_ranges) {
+		BUG_ON(!rdev->desc->n_linear_ranges);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < rdev->desc->n_linear_ranges; i++) {
+		range = &rdev->desc->linear_ranges[i];
+
+		if (!(min_uV <= range->max_uV && max_uV >= range->min_uV))
+			continue;
+
+		if (min_uV <= range->min_uV)
+			min_uV = range->min_uV;
+
+		/* range->uV_step == 0 means fixed voltage range */
+		if (range->uV_step == 0) {
+			ret = 0;
+		} else {
+			ret = DIV_ROUND_UP(min_uV - range->min_uV,
+					   range->uV_step);
+			if (ret < 0)
+				return ret;
+		}
+
+		ret += range->min_sel;
+
+		break;
+	}
+
+	if (i == rdev->desc->n_linear_ranges)
+		return -EINVAL;
+
+	/* Map back into a voltage to verify we're still in bounds */
+	voltage = rdev->desc->ops->list_voltage(rdev, ret);
+	if (voltage < min_uV || voltage > max_uV)
+		return -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_map_voltage_linear_range);
+
+/**
+ * regulator_set_bypass_regmap - Default set_bypass() using regmap
+ *
+ * @rdev: device to operate on.
+ * @enable: state to set.
+ */
+int regulator_set_bypass_regmap(struct regulator_dev *rdev, bool enable)
+{
+	unsigned int val;
+
+	if (enable)
+		val = rdev->desc->bypass_mask;
+	else
+		val = 0;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->bypass_reg,
+				  rdev->desc->bypass_mask, val);
+}
+EXPORT_SYMBOL_GPL(regulator_set_bypass_regmap);
+
+/**
+ * regulator_get_bypass_regmap - Default get_bypass() using regmap
+ *
+ * @rdev: device to operate on.
+ * @enable: current state.
+ */
+int regulator_get_bypass_regmap(struct regulator_dev *rdev, bool *enable)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rdev->regmap, rdev->desc->bypass_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	*enable = val & rdev->desc->bypass_mask;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_get_bypass_regmap);
-- 
1.8.4.rc1

