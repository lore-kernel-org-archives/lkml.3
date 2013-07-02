Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3GBWwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:52:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48311 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3GBWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:52:06 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Tue,  2 Jul 2013 23:51:51 +0100
Message-Id: <1372805514-11498-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/4] regulator: core: Add helpers for multiple linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Many regulators have several linear ranges of selector with different
step sizes, for example offering better resolution at lower voltages.
Provide regulator_{map,list}_voltage_linear_range() allowing these
regulators to use generic code. To do so a table of regulator_linear_range
structs needs to be pointed to from the descriptor.

This was inspired by similar code included in a driver submission from
Chao Xie and Yi Zhang at Marvell.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c         | 87 ++++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h | 25 ++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 288c75a..e8604be 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2079,6 +2079,43 @@ int regulator_list_voltage_linear(struct regulator_dev *rdev,
 EXPORT_SYMBOL_GPL(regulator_list_voltage_linear);
 
 /**
+ * regulator_list_voltage_linear_range - List voltages for linear ranges
+ *
+ * @rdev: Regulator device
+ * @selector: Selector to convert into a voltage
+ *
+ * Regulators with a series of simple linear mappings between voltages
+ * and selectors can set linear_ranges in the regulator descriptor and
+ * then use this function as their list_voltage() operation,
+ */
+int regulator_list_voltage_linear_range(struct regulator_dev *rdev,
+					unsigned int selector)
+{
+	const struct regulator_linear_range *range;
+	int i;
+
+	if (!rdev->desc->n_linear_ranges) {
+		BUG_ON(!rdev->desc->n_linear_ranges);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < rdev->desc->n_linear_ranges; i++) {
+		range = &rdev->desc->linear_ranges[i];
+
+		if (!(selector >= range->min_sel &&
+		      selector <= range->max_sel))
+			continue;
+
+		selector -= range->min_sel;
+
+		return range->min_uV + (range->uV_step * selector);
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regulator_list_voltage_linear_range);
+
+/**
  * regulator_list_voltage_table - List voltages with table based mapping
  *
  * @rdev: Regulator device
@@ -2368,6 +2405,56 @@ int regulator_map_voltage_linear(struct regulator_dev *rdev,
 }
 EXPORT_SYMBOL_GPL(regulator_map_voltage_linear);
 
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
+		ret = DIV_ROUND_UP(min_uV - range->min_uV, range->uV_step);
+		if (ret < 0)
+			return ret;
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
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 6700cc9..67e13aa 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -40,6 +40,24 @@ enum regulator_status {
 };
 
 /**
+ * Specify a range of voltages for regulator_map_linar_range() and
+ * regulator_list_linear_range().
+ *
+ * @min_uV:  Lowest voltage in range
+ * @max_uV:  Highest voltage in range
+ * @min_sel: Lowest selector for range
+ * @max_sel: Highest selector for range
+ * @uV_step: Step size
+ */
+struct regulator_linear_range {
+	unsigned int min_uV;
+	unsigned int max_uV;
+	unsigned int min_sel;
+	unsigned int max_sel;
+	unsigned int uV_step;
+};
+
+/**
  * struct regulator_ops - regulator operations.
  *
  * @enable: Configure the regulator as enabled.
@@ -223,6 +241,9 @@ struct regulator_desc {
 	unsigned int linear_min_sel;
 	unsigned int ramp_delay;
 
+	const struct regulator_linear_range *linear_ranges;
+	int n_linear_ranges;
+
 	const unsigned int *volt_table;
 
 	unsigned int vsel_reg;
@@ -326,10 +347,14 @@ int regulator_mode_to_status(unsigned int);
 
 int regulator_list_voltage_linear(struct regulator_dev *rdev,
 				  unsigned int selector);
+int regulator_list_voltage_linear_range(struct regulator_dev *rdev,
+					unsigned int selector);
 int regulator_list_voltage_table(struct regulator_dev *rdev,
 				  unsigned int selector);
 int regulator_map_voltage_linear(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
+int regulator_map_voltage_linear_range(struct regulator_dev *rdev,
+				       int min_uV, int max_uV);
 int regulator_map_voltage_iterate(struct regulator_dev *rdev,
 				  int min_uV, int max_uV);
 int regulator_map_voltage_ascend(struct regulator_dev *rdev,
-- 
1.8.3.1

