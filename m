Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaBDMTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:19:40 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36917 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaBDMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:19:25 -0500
From: Matt Porter <mporter@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] regulator: add bcm59056 regulator driver
Date: Tue,  4 Feb 2014 07:19:10 -0500
Message-Id: <1391516352-32359-5-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391516352-32359-1-git-send-email-mporter@linaro.org>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a regulator driver for the BCM59056 PMU voltage regulators.
The driver supports LDOs and DCDCs in normal mode only. There is
no support for low-power mode or power sequencing.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/regulator/Kconfig              |   8 +
 drivers/regulator/Makefile             |   1 +
 drivers/regulator/bcm59056-regulator.c | 445 +++++++++++++++++++++++++++++++++
 3 files changed, 454 insertions(+)
 create mode 100644 drivers/regulator/bcm59056-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 6a79328..e09c9ea5 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -139,6 +139,14 @@ config REGULATOR_AS3722
 	  AS3722 PMIC. This will enable support for all the software
 	  controllable DCDC/LDO regulators.
 
+config REGULATOR_BCM59056
+	tristate "Broadcom BCM59056 PMU Regulators"
+	depends on MFD_BCM59056
+	help
+	  This driver provides support for the voltage regulators on the
+	  BCM59056 PMU. This will enable support for the software
+	  controllable LDO/Switching regulators.
+
 config REGULATOR_DA903X
 	tristate "Dialog Semiconductor DA9030/DA9034 regulators"
 	depends on PMIC_DA903X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 979f9dd..bb65035 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
 obj-$(CONFIG_REGULATOR_AS3711) += as3711-regulator.o
 obj-$(CONFIG_REGULATOR_AS3722) += as3722-regulator.o
+obj-$(CONFIG_REGULATOR_BCM59056) += bcm59056-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DA9055)	+= da9055-regulator.o
diff --git a/drivers/regulator/bcm59056-regulator.c b/drivers/regulator/bcm59056-regulator.c
new file mode 100644
index 0000000..3fbc1d5
--- /dev/null
+++ b/drivers/regulator/bcm59056-regulator.c
@@ -0,0 +1,445 @@
+/*
+ * Broadcom BCM59056 regulator driver
+ *
+ * Copyright 2014 Linaro Limited
+ * Author: Matt Porter <mporter@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mfd/bcm59056.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/slab.h>
+
+/* Register defs */
+#define BCM59056_RFLDOPMCTRL1	0x60
+#define BCM59056_IOSR1PMCTRL1	0x7a
+#define BCM59056_IOSR2PMCTRL1	0x7c
+#define BCM59056_CSRPMCTRL1	0x7e
+#define BCM59056_SDSR1PMCTRL1	0x82
+#define BCM59056_SDSR2PMCTRL1	0x86
+#define BCM59056_MSRPMCTRL1	0x8a
+#define BCM59056_VSRPMCTRL1	0x8e
+#define BCM59056_REG_ENABLE	BIT(7)
+
+#define BCM59056_RFLDOCTRL	0x96
+#define BCM59056_CSRVOUT1	0xc0
+#define BCM59056_LDO_VSEL_MASK	GENMASK(5, 3)
+#define BCM59056_SR_VSEL_MASK	GENMASK(5, 0)
+
+/* LDO regulator IDs */
+#define BCM59056_REG_RFLDO	0
+#define BCM59056_REG_CAMLDO1	1
+#define BCM59056_REG_CAMLDO2	2
+#define BCM59056_REG_SIMLDO1	3
+#define BCM59056_REG_SIMLDO2	4
+#define BCM59056_REG_SDLDO	5
+#define BCM59056_REG_SDXLDO	6
+#define BCM59056_REG_MMCLDO1	7
+#define BCM59056_REG_MMCLDO2	8
+#define BCM59056_REG_AUDLDO	9
+#define BCM59056_REG_MICLDO	10
+#define BCM59056_REG_USBLDO	11
+#define BCM59056_REG_VIBLDO	12
+
+/* DCDC regulator IDs */
+#define BCM59056_REG_CSR	13
+#define BCM59056_REG_IOSR1	14
+#define BCM59056_REG_IOSR2	15
+#define BCM59056_REG_MSR	16
+#define BCM59056_REG_SDSR1	17
+#define BCM59056_REG_SDSR2	18
+#define BCM59056_REG_VSR	19
+
+#define BCM59056_NUM_REGS	20
+
+#define BCM59056_REG_IS_LDO(n)	(n < BCM59056_REG_CSR)
+
+struct bcm59056_board {
+	struct regulator_init_data *bcm59056_pmu_init_data[BCM59056_NUM_REGS];
+};
+
+/* LDO group A: supported voltages in microvolts */
+static const unsigned int ldo_a_table[] = {
+	1200000, 1800000, 2500000, 2700000, 2800000,
+	2900000, 3000000, 3300000,
+};
+
+/* LDO group C: supported voltages in microvolts */
+static const unsigned int ldo_c_table[] = {
+	3100000, 1800000, 2500000, 2700000, 2800000,
+	2900000, 3000000, 3300000,
+};
+
+/* DCDC group CSR: supported voltages in microvolts */
+static const struct regulator_linear_range dcdc_csr_ranges[] = {
+	REGULATOR_LINEAR_RANGE(860000, 2, 50, 10000),
+	REGULATOR_LINEAR_RANGE(1360000, 51, 55, 20000),
+	REGULATOR_LINEAR_RANGE(900000, 56, 63, 0),
+};
+
+/* DCDC group IOSR1: supported voltages in microvolts */
+static const struct regulator_linear_range dcdc_iosr1_ranges[] = {
+	REGULATOR_LINEAR_RANGE(860000, 2, 51, 10000),
+	REGULATOR_LINEAR_RANGE(1500000, 52, 52, 0),
+	REGULATOR_LINEAR_RANGE(1800000, 53, 53, 0),
+	REGULATOR_LINEAR_RANGE(900000, 54, 63, 0),
+};
+
+/* DCDC group SDSR1: supported voltages in microvolts */
+static const struct regulator_linear_range dcdc_sdsr1_ranges[] = {
+	REGULATOR_LINEAR_RANGE(860000, 2, 50, 10000),
+	REGULATOR_LINEAR_RANGE(1340000, 51, 51, 0),
+	REGULATOR_LINEAR_RANGE(900000, 52, 63, 0),
+};
+
+struct bcm59056_info {
+	const char *name;
+	const char *vin_name;
+	u8 n_voltages;
+	const unsigned int *volt_table;
+	u8 n_linear_ranges;
+	const struct regulator_linear_range *linear_ranges;
+};
+
+#define BCM59056_REG_TABLE(_name, _table) \
+	{ \
+		.name = #_name, \
+		.n_voltages = ARRAY_SIZE(_table), \
+		.volt_table = _table, \
+	}
+
+#define BCM59056_REG_RANGES(_name, _ranges) \
+	{ \
+		.name = #_name, \
+		.n_linear_ranges = ARRAY_SIZE(_ranges), \
+		.linear_ranges = _ranges, \
+	}
+
+static struct bcm59056_info bcm59056_regs[] = {
+	BCM59056_REG_TABLE(rfldo, ldo_a_table),
+	BCM59056_REG_TABLE(camldo1, ldo_c_table),
+	BCM59056_REG_TABLE(camldo2, ldo_c_table),
+	BCM59056_REG_TABLE(simldo1, ldo_a_table),
+	BCM59056_REG_TABLE(simldo2, ldo_a_table),
+	BCM59056_REG_TABLE(sdldo, ldo_c_table),
+	BCM59056_REG_TABLE(sdxldo, ldo_a_table),
+	BCM59056_REG_TABLE(mmcldo1, ldo_a_table),
+	BCM59056_REG_TABLE(mmcldo2, ldo_a_table),
+	BCM59056_REG_TABLE(audldo, ldo_a_table),
+	BCM59056_REG_TABLE(micldo, ldo_a_table),
+	BCM59056_REG_TABLE(usbldo, ldo_a_table),
+	BCM59056_REG_TABLE(vibldo, ldo_c_table),
+	BCM59056_REG_RANGES(csr, dcdc_csr_ranges),
+	BCM59056_REG_RANGES(iosr1, dcdc_iosr1_ranges),
+	BCM59056_REG_RANGES(iosr2, dcdc_iosr1_ranges),
+	BCM59056_REG_RANGES(msr, dcdc_iosr1_ranges),
+	BCM59056_REG_RANGES(sdsr1, dcdc_sdsr1_ranges),
+	BCM59056_REG_RANGES(sdsr2, dcdc_iosr1_ranges),
+	BCM59056_REG_RANGES(vsr, dcdc_iosr1_ranges),
+};
+
+struct bcm59056_reg {
+	struct regulator_desc *desc;
+	struct bcm59056 *mfd;
+	struct regulator_dev **rdev;
+	struct bcm59056_info **info;
+};
+
+static int bcm59056_get_vsel_register(int id)
+{
+	if (BCM59056_REG_IS_LDO(id))
+		return BCM59056_RFLDOCTRL + id;
+	else
+		return BCM59056_CSRVOUT1 + (id - BCM59056_REG_CSR) * 3;
+}
+
+static int bcm59056_get_enable_register(int id)
+{
+	int reg = 0;
+
+	if (BCM59056_REG_IS_LDO(id))
+		reg = BCM59056_RFLDOPMCTRL1 + id * 2;
+	else
+		switch (id) {
+		case BCM59056_REG_CSR:
+			reg = BCM59056_CSRPMCTRL1;
+			break;
+		case BCM59056_REG_IOSR1:
+			reg = BCM59056_IOSR1PMCTRL1;
+			break;
+		case BCM59056_REG_IOSR2:
+			reg = BCM59056_IOSR2PMCTRL1;
+			break;
+		case BCM59056_REG_MSR:
+			reg = BCM59056_MSRPMCTRL1;
+			break;
+		case BCM59056_REG_SDSR1:
+			reg = BCM59056_SDSR1PMCTRL1;
+			break;
+		case BCM59056_REG_SDSR2:
+			reg = BCM59056_SDSR2PMCTRL1;
+			break;
+		};
+
+	return reg;
+}
+
+static unsigned int bcm59056_get_mode(struct regulator_dev *dev)
+{
+	return REGULATOR_MODE_NORMAL;
+}
+
+static int bcm59056_set_mode(struct regulator_dev *dev, unsigned int mode)
+{
+	if (mode == REGULATOR_MODE_NORMAL)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static struct regulator_ops bcm59056_ops_ldo = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.set_mode		= bcm59056_set_mode,
+	.get_mode		= bcm59056_get_mode,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_iterate,
+};
+
+static struct regulator_ops bcm59056_ops_dcdc = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.set_mode		= bcm59056_set_mode,
+	.get_mode		= bcm59056_get_mode,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+};
+
+#define BCM59056_MATCH(_name, _id) \
+	{ \
+		.name = #_name, \
+		.driver_data = (void *)&bcm59056_regs[BCM59056_REG_##_id], \
+	}
+
+static struct of_regulator_match bcm59056_matches[] = {
+	BCM59056_MATCH(rfldo, RFLDO),
+	BCM59056_MATCH(camldo1, CAMLDO1),
+	BCM59056_MATCH(camldo2, CAMLDO2),
+	BCM59056_MATCH(simldo1, SIMLDO1),
+	BCM59056_MATCH(simldo2, SIMLDO2),
+	BCM59056_MATCH(sdldo, SDLDO),
+	BCM59056_MATCH(sdxldo, SDXLDO),
+	BCM59056_MATCH(mmcldo1, MMCLDO1),
+	BCM59056_MATCH(mmcldo2, MMCLDO2),
+	BCM59056_MATCH(audldo, AUDLDO),
+	BCM59056_MATCH(micldo, MICLDO),
+	BCM59056_MATCH(usbldo, USBLDO),
+	BCM59056_MATCH(vibldo, VIBLDO),
+	BCM59056_MATCH(csr, CSR),
+	BCM59056_MATCH(iosr1, IOSR1),
+	BCM59056_MATCH(iosr2, IOSR2),
+	BCM59056_MATCH(msr, MSR),
+	BCM59056_MATCH(sdsr1, SDSR1),
+	BCM59056_MATCH(sdsr2, SDSR2),
+	BCM59056_MATCH(vsr, VSR),
+};
+
+static struct bcm59056_board *bcm59056_parse_dt_reg_data(
+		struct platform_device *pdev,
+		struct of_regulator_match **bcm59056_reg_matches)
+{
+	struct bcm59056_board *data;
+	struct device_node *np, *regulators;
+	struct of_regulator_match *matches = bcm59056_matches;
+	int count = ARRAY_SIZE(bcm59056_matches);
+	int idx = 0;
+	int ret;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate regulator board data\n");
+		return NULL;
+	}
+
+	np = of_node_get(pdev->dev.parent->of_node);
+	regulators = of_get_child_by_name(np, "regulators");
+	if (!regulators) {
+		dev_err(&pdev->dev, "regulator node not found\n");
+		return NULL;
+	}
+
+	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
+	of_node_put(regulators);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
+			ret);
+		return NULL;
+	}
+
+	*bcm59056_reg_matches = matches;
+
+	for (idx = 0; idx < count; idx++) {
+		if (!matches[idx].init_data || !matches[idx].of_node)
+			continue;
+
+		data->bcm59056_pmu_init_data[idx] = matches[idx].init_data;
+	}
+
+	return data;
+}
+
+static int bcm59056_probe(struct platform_device *pdev)
+{
+	struct bcm59056 *bcm59056 = dev_get_drvdata(pdev->dev.parent);
+	struct bcm59056_board *pmu_data = NULL;
+	struct bcm59056_reg *pmu;
+	struct regulator_config config = { };
+	struct bcm59056_info *info;
+	struct regulator_init_data *reg_data;
+	struct regulator_dev *rdev;
+	struct of_regulator_match *bcm59056_reg_matches = NULL;
+	int i;
+
+	if (bcm59056->dev->of_node)
+		pmu_data = bcm59056_parse_dt_reg_data(pdev,
+						      &bcm59056_reg_matches);
+
+	if (!pmu_data) {
+		dev_err(&pdev->dev, "Platform data not found\n");
+		return -EINVAL;
+	}
+
+	pmu = devm_kzalloc(&pdev->dev, sizeof(*pmu), GFP_KERNEL);
+	if (!pmu) {
+		dev_err(&pdev->dev, "Memory allocation failed for pmu\n");
+		return -ENOMEM;
+	}
+
+	pmu->mfd = bcm59056;
+
+	platform_set_drvdata(pdev, pmu);
+
+	pmu->desc = devm_kzalloc(&pdev->dev, BCM59056_NUM_REGS *
+			sizeof(struct regulator_desc), GFP_KERNEL);
+	if (!pmu->desc) {
+		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
+		return -ENOMEM;
+	}
+
+	pmu->info = devm_kzalloc(&pdev->dev, BCM59056_NUM_REGS *
+			sizeof(struct bcm59056_info *), GFP_KERNEL);
+	if (!pmu->info) {
+		dev_err(&pdev->dev, "Memory alloc fails for info\n");
+		return -ENOMEM;
+	}
+
+	pmu->rdev = devm_kzalloc(&pdev->dev, BCM59056_NUM_REGS *
+			sizeof(struct regulator_dev *), GFP_KERNEL);
+	if (!pmu->rdev) {
+		dev_err(&pdev->dev, "Memory alloc fails for rdev\n");
+		return -ENOMEM;
+	}
+
+	info = bcm59056_regs;
+
+	for (i = 0; i < BCM59056_NUM_REGS; i++, info++) {
+		reg_data = pmu_data->bcm59056_pmu_init_data[i];
+
+		/*
+		 * Regulator API handles empty constraints but not NULL
+		 * constraints
+		 */
+		if (!reg_data)
+			continue;
+
+		/* Register the regulators */
+		pmu->info[i] = info;
+
+		pmu->desc[i].name = info->name;
+		pmu->desc[i].supply_name = info->vin_name;
+		pmu->desc[i].id = i;
+		pmu->desc[i].volt_table = info->volt_table;
+		pmu->desc[i].n_voltages = info->n_voltages;
+		pmu->desc[i].linear_ranges = info->linear_ranges;
+		pmu->desc[i].n_linear_ranges = info->n_linear_ranges;
+
+		if (BCM59056_REG_IS_LDO(i)) {
+			pmu->desc[i].ops = &bcm59056_ops_ldo;
+			pmu->desc[i].vsel_mask = BCM59056_LDO_VSEL_MASK;
+		} else {
+			pmu->desc[i].ops = &bcm59056_ops_dcdc;
+			pmu->desc[i].vsel_mask = BCM59056_SR_VSEL_MASK;
+		}
+
+		pmu->desc[i].vsel_reg = bcm59056_get_vsel_register(i);
+		pmu->desc[i].enable_is_inverted = true;
+		pmu->desc[i].enable_mask = BCM59056_REG_ENABLE;
+		pmu->desc[i].enable_reg = bcm59056_get_enable_register(i);
+		pmu->desc[i].type = REGULATOR_VOLTAGE;
+		pmu->desc[i].owner = THIS_MODULE;
+
+		config.dev = bcm59056->dev;
+		config.init_data = reg_data;
+		config.driver_data = pmu;
+		config.regmap = bcm59056->regmap;
+
+		if (bcm59056_reg_matches)
+			config.of_node = bcm59056_reg_matches[i].of_node;
+
+		rdev = devm_regulator_register(&pdev->dev, &pmu->desc[i],
+					       &config);
+		if (IS_ERR(rdev)) {
+			dev_err(bcm59056->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
+			return PTR_ERR(rdev);
+		}
+
+		pmu->rdev[i] = rdev;
+	}
+
+	return 0;
+}
+
+static struct platform_driver bcm59056_regulator_driver = {
+	.driver = {
+		.name = "bcm59056-pmu",
+		.owner = THIS_MODULE,
+	},
+	.probe = bcm59056_probe,
+};
+
+static int __init bcm59056_regulator_init(void)
+{
+	return platform_driver_register(&bcm59056_regulator_driver);
+}
+subsys_initcall(bcm59056_regulator_init);
+
+static void __exit bcm59056_regulator_exit(void)
+{
+	platform_driver_unregister(&bcm59056_regulator_driver);
+}
+module_exit(bcm59056_regulator_exit);
+
+MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
+MODULE_DESCRIPTION("BCM59056 voltage regulator driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:bcm59056-regulator");
-- 
1.8.4

