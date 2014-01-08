Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaAHGaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:30:52 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45011 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbaAHGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:30:34 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, broonie@kernel.org, lee.jones@linaro.org,
        robh+dt@kernel.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        sbkim73@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] regulator: Add support for S2MPA01 regulator
Date: Wed,  8 Jan 2014 11:56:29 +0530
Message-Id: <1389162390-4582-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
References: <1389162390-4582-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for S2MPA01 voltage and current regulator.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/Kconfig   |    7 +
 drivers/regulator/Makefile  |    1 +
 drivers/regulator/s2mpa01.c |  497 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 505 insertions(+)
 create mode 100644 drivers/regulator/s2mpa01.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 6a7932822e37..8f8e6710bb45 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -416,6 +416,13 @@ config REGULATOR_RC5T583
 	  through regulator interface. The device supports multiple DCDC/LDO
 	  outputs which can be controlled by i2c communication.
 
+config REGULATOR_S2MPA01
+	tristate "Samsung S2MPA01 voltage regulator"
+	depends on MFD_SEC_CORE
+	help
+	 This driver controls Samsung S2MPA01 voltage output regulator
+	 via I2C bus. S2MPA01 has 10 Bucks and 26 LDO outputs.
+
 config REGULATOR_S2MPS11
 	tristate "Samsung S2MPS11 voltage regulator"
 	depends on MFD_SEC_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 979f9ddcf259..b3ece84289cf 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
+obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
 obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
new file mode 100644
index 000000000000..f1c831d5fc87
--- /dev/null
+++ b/drivers/regulator/s2mpa01.c
@@ -0,0 +1,497 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ *		http://www.samsung.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/regmap.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/mfd/samsung/core.h>
+#include <linux/mfd/samsung/s2mpa01.h>
+
+#define S2MPA01_REGULATOR_CNT ARRAY_SIZE(regulators)
+
+struct s2mpa01_info {
+	struct regulator_dev *rdev[S2MPA01_REGULATOR_MAX];
+
+	int ramp_delay24;
+	int ramp_delay3;
+	int ramp_delay5;
+	int ramp_delay16;
+	int ramp_delay7;
+	int ramp_delay8910;
+};
+
+static int get_ramp_delay(int ramp_delay)
+{
+	unsigned char cnt = 0;
+
+	ramp_delay /= 6250;
+
+	while (true) {
+		ramp_delay = ramp_delay >> 1;
+		if (ramp_delay == 0)
+			break;
+		cnt++;
+	}
+
+	if (cnt > 3)
+		cnt = 3;
+
+	return cnt;
+}
+
+static int s2mpa01_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+				   unsigned int old_selector,
+				   unsigned int new_selector)
+{
+	struct s2mpa01_info *s2mpa01 = rdev_get_drvdata(rdev);
+	unsigned int ramp_delay = 0;
+	int old_volt, new_volt;
+
+	switch (rdev->desc->id) {
+	case S2MPA01_BUCK2:
+	case S2MPA01_BUCK4:
+		ramp_delay = s2mpa01->ramp_delay24;
+		break;
+	case S2MPA01_BUCK3:
+		ramp_delay = s2mpa01->ramp_delay3;
+		break;
+	case S2MPA01_BUCK5:
+		ramp_delay = s2mpa01->ramp_delay5;
+		break;
+	case S2MPA01_BUCK1:
+	case S2MPA01_BUCK6:
+		ramp_delay = s2mpa01->ramp_delay16;
+		break;
+	case S2MPA01_BUCK7:
+		ramp_delay = s2mpa01->ramp_delay7;
+		break;
+	case S2MPA01_BUCK8:
+	case S2MPA01_BUCK9:
+	case S2MPA01_BUCK10:
+		ramp_delay = s2mpa01->ramp_delay8910;
+		break;
+	}
+
+	if (ramp_delay == 0)
+		ramp_delay = rdev->desc->ramp_delay;
+
+	old_volt = rdev->desc->min_uV + (rdev->desc->uV_step * old_selector);
+	new_volt = rdev->desc->min_uV + (rdev->desc->uV_step * new_selector);
+
+	return DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);
+}
+
+static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
+{
+	struct s2mpa01_info *s2mpa01 = rdev_get_drvdata(rdev);
+	unsigned int ramp_val, ramp_shift, ramp_reg = S2MPA01_REG_RAMP2;
+	unsigned int ramp_enable = 1, enable_shift = 0;
+	int ret;
+
+	switch (rdev->desc->id) {
+	case S2MPA01_BUCK1:
+		enable_shift = S2MPA01_BUCK1_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		if (ramp_delay > s2mpa01->ramp_delay16)
+			s2mpa01->ramp_delay16 = ramp_delay;
+		else
+			ramp_delay = s2mpa01->ramp_delay16;
+
+		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
+		ramp_reg = S2MPA01_REG_RAMP1;
+		break;
+	case S2MPA01_BUCK2:
+		enable_shift = S2MPA01_BUCK2_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		if (ramp_delay > s2mpa01->ramp_delay24)
+			s2mpa01->ramp_delay24 = ramp_delay;
+		else
+			ramp_delay = s2mpa01->ramp_delay24;
+
+		ramp_shift = S2MPA01_BUCK24_RAMP_SHIFT;
+		ramp_reg = S2MPA01_REG_RAMP1;
+		break;
+	case S2MPA01_BUCK3:
+		enable_shift = S2MPA01_BUCK3_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		s2mpa01->ramp_delay3 = ramp_delay;
+		ramp_shift = S2MPA01_BUCK3_RAMP_SHIFT;
+		ramp_reg = S2MPA01_REG_RAMP1;
+		break;
+	case S2MPA01_BUCK4:
+		enable_shift = S2MPA01_BUCK4_RAMP_EN_SHIFT;
+		if (!ramp_delay) {
+			ramp_enable = 0;
+			break;
+		}
+
+		if (ramp_delay > s2mpa01->ramp_delay24)
+			s2mpa01->ramp_delay24 = ramp_delay;
+		else
+			ramp_delay = s2mpa01->ramp_delay24;
+
+		ramp_shift = S2MPA01_BUCK24_RAMP_SHIFT;
+		ramp_reg = S2MPA01_REG_RAMP1;
+		break;
+	case S2MPA01_BUCK5:
+		s2mpa01->ramp_delay5 = ramp_delay;
+		ramp_shift = S2MPA01_BUCK5_RAMP_SHIFT;
+		break;
+	case S2MPA01_BUCK6:
+		if (ramp_delay > s2mpa01->ramp_delay16)
+			s2mpa01->ramp_delay16 = ramp_delay;
+		else
+			ramp_delay = s2mpa01->ramp_delay16;
+
+		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
+		break;
+	case S2MPA01_BUCK7:
+		s2mpa01->ramp_delay7 = ramp_delay;
+		ramp_shift = S2MPA01_BUCK7_RAMP_SHIFT;
+		break;
+	case S2MPA01_BUCK8:
+	case S2MPA01_BUCK9:
+	case S2MPA01_BUCK10:
+		if (ramp_delay > s2mpa01->ramp_delay8910)
+			s2mpa01->ramp_delay8910 = ramp_delay;
+		else
+			ramp_delay = s2mpa01->ramp_delay8910;
+
+		ramp_shift = S2MPA01_BUCK8910_RAMP_SHIFT;
+		break;
+	default:
+		return 0;
+	}
+
+	if (!ramp_enable)
+		goto ramp_disable;
+
+	if (enable_shift) {
+		ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
+					1 << enable_shift, 1 << enable_shift);
+		if (ret) {
+			dev_err(&rdev->dev, "failed to enable ramp rate\n");
+			return ret;
+		}
+	}
+
+	ramp_val = get_ramp_delay(ramp_delay);
+
+	return regmap_update_bits(rdev->regmap, ramp_reg, 0x3 << ramp_shift,
+				  ramp_val << ramp_shift);
+
+ramp_disable:
+	return regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
+				  1 << enable_shift, 0);
+}
+
+static struct regulator_ops s2mpa01_ldo_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+};
+
+static struct regulator_ops s2mpa01_buck_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= s2mpa01_regulator_set_voltage_time_sel,
+	.set_ramp_delay		= s2mpa01_set_ramp_delay,
+};
+
+#define regulator_desc_ldo1(num)	{		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPA01_LDO##num,		\
+	.ops		= &s2mpa01_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPA01_LDO_MIN,		\
+	.uV_step	= S2MPA01_LDO_STEP1,		\
+	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
+	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
+	.enable_mask	= S2MPA01_ENABLE_MASK		\
+}
+#define regulator_desc_ldo2(num)	{		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPA01_LDO##num,		\
+	.ops		= &s2mpa01_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPA01_LDO_MIN,		\
+	.uV_step	= S2MPA01_LDO_STEP2,		\
+	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
+	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
+	.enable_mask	= S2MPA01_ENABLE_MASK		\
+}
+
+#define regulator_desc_buck1_4(num)	{			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPA01_BUCK##num,			\
+	.ops		= &s2mpa01_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPA01_BUCK_MIN1,			\
+	.uV_step	= S2MPA01_BUCK_STEP1,			\
+	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
+	.vsel_reg	= S2MPA01_REG_B1CTRL2 + (num - 1) * 2,	\
+	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPA01_REG_B1CTRL1 + (num - 1) * 2,	\
+	.enable_mask	= S2MPA01_ENABLE_MASK			\
+}
+
+#define regulator_desc_buck5	{				\
+	.name		= "BUCK5",				\
+	.id		= S2MPA01_BUCK5,			\
+	.ops		= &s2mpa01_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPA01_BUCK_MIN2,			\
+	.uV_step	= S2MPA01_BUCK_STEP1,			\
+	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
+	.vsel_reg	= S2MPA01_REG_B5CTRL2,			\
+	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPA01_REG_B5CTRL1,			\
+	.enable_mask	= S2MPA01_ENABLE_MASK			\
+}
+
+#define regulator_desc_buck6_7(num)	{			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPA01_BUCK##num,			\
+	.ops		= &s2mpa01_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPA01_BUCK_MIN1,			\
+	.uV_step	= S2MPA01_BUCK_STEP1,			\
+	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
+	.vsel_reg	= S2MPA01_REG_B6CTRL2 + (num - 6) * 2,	\
+	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPA01_REG_B6CTRL1 + (num - 6) * 2,	\
+	.enable_mask	= S2MPA01_ENABLE_MASK			\
+}
+
+#define regulator_desc_buck8	{				\
+	.name		= "BUCK8",				\
+	.id		= S2MPA01_BUCK8,			\
+	.ops		= &s2mpa01_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPA01_BUCK_MIN2,			\
+	.uV_step	= S2MPA01_BUCK_STEP2,			\
+	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
+	.vsel_reg	= S2MPA01_REG_B8CTRL2,			\
+	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPA01_REG_B8CTRL1,			\
+	.enable_mask	= S2MPA01_ENABLE_MASK			\
+}
+
+#define regulator_desc_buck9	{				\
+	.name		= "BUCK9",				\
+	.id		= S2MPA01_BUCK9,			\
+	.ops		= &s2mpa01_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPA01_BUCK_MIN4,			\
+	.uV_step	= S2MPA01_BUCK_STEP2,			\
+	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
+	.vsel_reg	= S2MPA01_REG_B9CTRL2,			\
+	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPA01_REG_B9CTRL1,			\
+	.enable_mask	= S2MPA01_ENABLE_MASK			\
+}
+
+#define regulator_desc_buck10	{				\
+	.name		= "BUCK10",				\
+	.id		= S2MPA01_BUCK10,			\
+	.ops		= &s2mpa01_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPA01_BUCK_MIN3,			\
+	.uV_step	= S2MPA01_BUCK_STEP2,			\
+	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
+	.vsel_reg	= S2MPA01_REG_B10CTRL2,			\
+	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPA01_REG_B10CTRL1,			\
+	.enable_mask	= S2MPA01_ENABLE_MASK			\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_ldo2(1),
+	regulator_desc_ldo1(2),
+	regulator_desc_ldo1(3),
+	regulator_desc_ldo1(4),
+	regulator_desc_ldo1(5),
+	regulator_desc_ldo2(6),
+	regulator_desc_ldo1(7),
+	regulator_desc_ldo1(8),
+	regulator_desc_ldo1(9),
+	regulator_desc_ldo1(10),
+	regulator_desc_ldo2(11),
+	regulator_desc_ldo1(12),
+	regulator_desc_ldo1(13),
+	regulator_desc_ldo1(14),
+	regulator_desc_ldo1(15),
+	regulator_desc_ldo1(16),
+	regulator_desc_ldo1(17),
+	regulator_desc_ldo1(18),
+	regulator_desc_ldo1(19),
+	regulator_desc_ldo1(20),
+	regulator_desc_ldo1(21),
+	regulator_desc_ldo2(22),
+	regulator_desc_ldo2(23),
+	regulator_desc_ldo1(24),
+	regulator_desc_ldo1(25),
+	regulator_desc_ldo1(26),
+	regulator_desc_buck1_4(1),
+	regulator_desc_buck1_4(2),
+	regulator_desc_buck1_4(3),
+	regulator_desc_buck1_4(4),
+	regulator_desc_buck5,
+	regulator_desc_buck6_7(6),
+	regulator_desc_buck6_7(7),
+	regulator_desc_buck8,
+	regulator_desc_buck9,
+	regulator_desc_buck10,
+};
+
+static int s2mpa01_pmic_probe(struct platform_device *pdev)
+{
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct of_regulator_match rdata[S2MPA01_REGULATOR_MAX];
+	struct device_node *reg_np = NULL;
+	struct regulator_config config = { };
+	struct s2mpa01_info *s2mpa01;
+	int i, ret;
+
+	s2mpa01 = devm_kzalloc(&pdev->dev, sizeof(*s2mpa01), GFP_KERNEL);
+	if (!s2mpa01)
+		return -ENOMEM;
+
+	if (!iodev->dev->of_node) {
+		if (pdata) {
+			goto common_reg;
+		} else {
+			dev_err(pdev->dev.parent,
+				"Platform data or DT node not supplied\n");
+			return -ENODEV;
+		}
+	}
+
+	for (i = 0; i < S2MPA01_REGULATOR_CNT; i++)
+		rdata[i].name = regulators[i].name;
+
+	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
+	if (!reg_np) {
+		dev_err(&pdev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	of_regulator_match(&pdev->dev, reg_np, rdata, S2MPA01_REGULATOR_MAX);
+
+common_reg:
+	platform_set_drvdata(pdev, s2mpa01);
+
+	config.dev = &pdev->dev;
+	config.regmap = iodev->regmap_pmic;
+	config.driver_data = s2mpa01;
+
+	for (i = 0; i < S2MPA01_REGULATOR_MAX; i++) {
+		if (!reg_np) {
+			config.init_data = pdata->regulators[i].initdata;
+		} else {
+			config.init_data = rdata[i].init_data;
+			config.of_node = rdata[i].of_node;
+		}
+
+		s2mpa01->rdev[i] = devm_regulator_register(&pdev->dev,
+						&regulators[i], &config);
+		if (IS_ERR(s2mpa01->rdev[i])) {
+			ret = PTR_ERR(s2mpa01->rdev[i]);
+			dev_err(&pdev->dev, "regulator init failed for %d\n",
+				i);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct platform_device_id s2mpa01_pmic_id[] = {
+	{ "s2mpa01-pmic", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, s2mpa01_pmic_id);
+
+static struct platform_driver s2mpa01_pmic_driver = {
+	.driver = {
+		.name = "s2mpa01-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = s2mpa01_pmic_probe,
+	.id_table = s2mpa01_pmic_id,
+};
+
+static int __init s2mpa01_pmic_init(void)
+{
+	return platform_driver_register(&s2mpa01_pmic_driver);
+}
+subsys_initcall(s2mpa01_pmic_init);
+
+static void __exit s2mpa01_pmic_exit(void)
+{
+	platform_driver_unregister(&s2mpa01_pmic_driver);
+}
+module_exit(s2mpa01_pmic_exit);
+
+/* Module information */
+MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
+MODULE_AUTHOR("Sachin Kamat <sachin.kamat@samsung.com>");
+MODULE_DESCRIPTION("SAMSUNG S2MPA01 Regulator Driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

