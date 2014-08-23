Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaHWLHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:07:08 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:36502 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaHWLHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:07:06 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <d4067a84603a6da93e06cb9788174b64>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v3 4/5] Regulator: RK808: Add regulator driver for RK808
Date: Sat, 23 Aug 2014 19:04:50 +0800
Message-Id: <1408791890-17328-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
The output voltages are configurable and are meant to supply power
to the main processor and other components

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v4:
Adviced by Lee Jones in v2
- modify the description in Kconfig
- remove some unnecessary header files
- remove dev from struct rk808
- use enum for define RK808_ID...

Changes in v3:
- fix compile err

Changes in v2:
Adviced by Mark Browm:
- use defines for register setting value
- remove rtc alarm disable in shutdown
- remove while(1) in shutdown
- remove read 0x2f in probe

 drivers/regulator/Kconfig           |   10 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/rk808-regulator.c |  404 +++++++++++++++++++++++++++++++++++
 3 files changed, 415 insertions(+)
 create mode 100644 drivers/regulator/rk808-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 2dc8289..fb32bab 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -459,6 +459,16 @@ config REGULATOR_RC5T583
 	  through regulator interface. The device supports multiple DCDC/LDO
 	  outputs which can be controlled by i2c communication.
 
+config REGULATOR_RK808
+	tristate "Rockchip RK808 Power regulators"
+	depends on MFD_RK808
+	help
+	  Select this option to enable the power regulator of ROCKCHIP
+	  PMIC RK808.
+	  This driver supports the control of different power rails of device
+	  through regulator interface. The device supports multiple DCDC/LDO
+	  outputs which can be controlled by i2c communication.
+
 config REGULATOR_S2MPA01
 	tristate "Samsung S2MPA01 voltage regulator"
 	depends on MFD_SEC_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index aa4a6aa..236fdbb 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_REGULATOR_PBIAS) += pbias-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
+obj-$(CONFIG_REGULATOR_RK808)   += rk808-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
new file mode 100644
index 0000000..e098efc
--- /dev/null
+++ b/drivers/regulator/rk808-regulator.c
@@ -0,0 +1,404 @@
+/*
+ * Regulator driver for Rockchip RK808
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * Author: Chris Zhong <zyw@rock-chips.com>
+ * Author: Zhang Qing <zhangqing@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/rk808.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+/*
+ * Field Definitions.
+ */
+#define RK808_BUCK_VSEL_MASK	0x3f
+#define RK808_BUCK4_VSEL_MASK	0xf
+#define RK808_LDO_VSEL_MASK	0x1f
+
+static const int buck_set_vol_base_addr[] = {
+	RK808_BUCK1_ON_VSEL_REG,
+	RK808_BUCK2_ON_VSEL_REG,
+	RK808_BUCK3_CONFIG_REG,
+	RK808_BUCK4_ON_VSEL_REG,
+};
+
+static const int buck_contr_base_addr[] = {
+	RK808_BUCK1_CONFIG_REG,
+	RK808_BUCK2_CONFIG_REG,
+	RK808_BUCK3_CONFIG_REG,
+	RK808_BUCK4_CONFIG_REG,
+};
+
+#define rk808_BUCK_SET_VOL_REG(x) (buck_set_vol_base_addr[x])
+#define rk808_BUCK_CONTR_REG(x) (buck_contr_base_addr[x])
+#define rk808_LDO_SET_VOL_REG(x) (ldo_set_vol_base_addr[x])
+
+static const int ldo_set_vol_base_addr[] = {
+	RK808_LDO1_ON_VSEL_REG,
+	RK808_LDO2_ON_VSEL_REG,
+	RK808_LDO3_ON_VSEL_REG,
+	RK808_LDO4_ON_VSEL_REG,
+	RK808_LDO5_ON_VSEL_REG,
+	RK808_LDO6_ON_VSEL_REG,
+	RK808_LDO7_ON_VSEL_REG,
+	RK808_LDO8_ON_VSEL_REG,
+};
+
+/*
+ * rk808 voltage number
+ */
+static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
+	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
+};
+
+static const struct regulator_linear_range rk808_buck4_voltage_ranges[] = {
+	REGULATOR_LINEAR_RANGE(1800000, 0, 15, 100000),
+};
+
+static const struct regulator_linear_range rk808_ldo_voltage_ranges[] = {
+	REGULATOR_LINEAR_RANGE(1800000, 0, 16, 100000),
+};
+
+static const struct regulator_linear_range rk808_ldo3_voltage_ranges[] = {
+	REGULATOR_LINEAR_RANGE(800000, 0, 13, 100000),
+	REGULATOR_LINEAR_RANGE(2500000, 15, 15, 0),
+};
+
+static const struct regulator_linear_range rk808_ldo6_voltage_ranges[] = {
+	REGULATOR_LINEAR_RANGE(800000, 0, 17, 100000),
+};
+
+static struct regulator_ops rk808_reg_ops = {
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+};
+
+static struct regulator_ops rk808_switch_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+};
+
+static const struct regulator_desc rk808_reg[] = {
+	{
+		.name = "DCDC_REG1",
+		.id = RK808_ID_DCDC1,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 64,
+		.linear_ranges = rk808_buck_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_buck_voltage_ranges),
+		.vsel_reg = RK808_BUCK1_ON_VSEL_REG,
+		.vsel_mask = RK808_BUCK_VSEL_MASK,
+		.enable_reg = RK808_DCDC_EN_REG,
+		.enable_mask = BIT(0),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "DCDC_REG2",
+		.id = RK808_ID_DCDC2,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 64,
+		.linear_ranges = rk808_buck_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_buck_voltage_ranges),
+		.vsel_reg = RK808_BUCK2_ON_VSEL_REG,
+		.vsel_mask = RK808_BUCK_VSEL_MASK,
+		.enable_reg = RK808_DCDC_EN_REG,
+		.enable_mask = BIT(1),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "DCDC_REG3",
+		.id = RK808_ID_DCDC3,
+		.ops = &rk808_switch_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 1,
+		.enable_reg = RK808_DCDC_EN_REG,
+		.enable_mask = BIT(2),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "DCDC_REG4",
+		.id = RK808_ID_DCDC4,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 17,
+		.linear_ranges = rk808_buck4_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_buck4_voltage_ranges),
+		.vsel_reg = RK808_BUCK4_ON_VSEL_REG,
+		.vsel_mask = RK808_BUCK4_VSEL_MASK,
+		.enable_reg = RK808_DCDC_EN_REG,
+		.enable_mask = BIT(3),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG1",
+		.id = RK808_ID_LDO1,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 17,
+		.linear_ranges = rk808_ldo_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo_voltage_ranges),
+		.vsel_reg = RK808_LDO1_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(0),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG2",
+		.id = RK808_ID_LDO2,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 17,
+		.linear_ranges = rk808_ldo_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo_voltage_ranges),
+		.vsel_reg = RK808_LDO2_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(1),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG3",
+		.id = RK808_ID_LDO3,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 16,
+		.linear_ranges = rk808_ldo3_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo3_voltage_ranges),
+		.vsel_reg = RK808_LDO3_ON_VSEL_REG,
+		.vsel_mask = RK808_BUCK4_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(2),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG4",
+		.id = RK808_ID_LDO4,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 17,
+		.linear_ranges = rk808_ldo_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo_voltage_ranges),
+		.vsel_reg = RK808_LDO4_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(3),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG5",
+		.id = RK808_ID_LDO5,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 17,
+		.linear_ranges = rk808_ldo_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo_voltage_ranges),
+		.vsel_reg = RK808_LDO5_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(4),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG6",
+		.id = RK808_ID_LDO6,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 18,
+		.linear_ranges = rk808_ldo6_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo6_voltage_ranges),
+		.vsel_reg = RK808_LDO6_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(5),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG7",
+		.id = RK808_ID_LDO7,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 18,
+		.linear_ranges = rk808_ldo6_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo6_voltage_ranges),
+		.vsel_reg = RK808_LDO7_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(6),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "LDO_REG8",
+		.id = RK808_ID_LDO8,
+		.ops = &rk808_reg_ops,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 17,
+		.linear_ranges = rk808_ldo_voltage_ranges,
+		.n_linear_ranges = ARRAY_SIZE(rk808_ldo_voltage_ranges),
+		.vsel_reg = RK808_LDO8_ON_VSEL_REG,
+		.vsel_mask = RK808_LDO_VSEL_MASK,
+		.enable_reg = RK808_LDO_EN_REG,
+		.enable_mask = BIT(7),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "SWITCH_REG1",
+		.id = RK808_ID_SWITCH1,
+		.ops = &rk808_switch_ops,
+		.type = REGULATOR_VOLTAGE,
+		.enable_reg = RK808_DCDC_EN_REG,
+		.enable_mask = BIT(5),
+		.owner = THIS_MODULE,
+	}, {
+		.name = "SWITCH_REG2",
+		.id = RK808_ID_SWITCH2,
+		.ops = &rk808_switch_ops,
+		.type = REGULATOR_VOLTAGE,
+		.enable_reg = RK808_DCDC_EN_REG,
+		.enable_mask = BIT(6),
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct of_regulator_match rk808_reg_matches[] = {
+	[RK808_ID_DCDC1]	= { .name = "DCDC_REG1" },
+	[RK808_ID_DCDC2]	= { .name = "DCDC_REG2" },
+	[RK808_ID_DCDC3]	= { .name = "DCDC_REG3" },
+	[RK808_ID_DCDC4]	= { .name = "DCDC_REG4" },
+	[RK808_ID_LDO1]		= { .name = "LDO_REG1" },
+	[RK808_ID_LDO2]		= { .name = "LDO_REG2" },
+	[RK808_ID_LDO3]		= { .name = "LDO_REG3" },
+	[RK808_ID_LDO4]		= { .name = "LDO_REG4" },
+	[RK808_ID_LDO5]		= { .name = "LDO_REG5" },
+	[RK808_ID_LDO6]		= { .name = "LDO_REG6" },
+	[RK808_ID_LDO7]		= { .name = "LDO_REG7" },
+	[RK808_ID_LDO8]		= { .name = "LDO_REG8" },
+	[RK808_ID_SWITCH1]	= { .name = "SWITCH_REG1" },
+	[RK808_ID_SWITCH2]	= { .name = "SWITCH_REG2" },
+};
+
+static int rk808_regulator_dts(struct rk808 *rk808)
+{
+	struct device_node *np, *reg_np;
+	struct i2c_client *client = rk808->i2c;
+	struct rk808_board *pdata = rk808->pdata;
+	int i, ret;
+
+	np = client->dev.of_node;
+	if (!np) {
+		dev_err(&client->dev, "could not find pmic sub-node\n");
+		return -ENXIO;
+	}
+
+	reg_np = of_get_child_by_name(np, "regulators");
+	if (!reg_np)
+		return -ENXIO;
+
+	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
+				 RK808_NUM_REGULATORS);
+	if (ret < 0) {
+		dev_err(&client->dev,
+			"failed to parse regulator data: %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
+		if (!rk808_reg_matches[i].init_data ||
+		    !rk808_reg_matches[i].of_node)
+			continue;
+
+		pdata->rk808_init_data[i] = rk808_reg_matches[i].init_data;
+		pdata->of_node[i] = rk808_reg_matches[i].of_node;
+	}
+
+	return 0;
+}
+
+static int rk808_regulator_probe(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct i2c_client *client = rk808->i2c;
+	struct rk808_board *pdata = rk808->pdata;
+	struct regulator_config config;
+	struct regulator_dev *rk808_rdev;
+	struct regulator_init_data *reg_data;
+	int i = 0;
+	int ret = 0;
+
+	if (!pdata) {
+		dev_warn(&client->dev, "%s no pdata, create it\n", __func__);
+		pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+	}
+
+	ret = rk808_regulator_dts(rk808);
+	if (ret)
+		return ret;
+
+	rk808->num_regulators = RK808_NUM_REGULATORS;
+	rk808->rdev = devm_kzalloc(&pdev->dev, RK808_NUM_REGULATORS *
+				   sizeof(struct regulator_dev *), GFP_KERNEL);
+	if (!rk808->rdev)
+		return -ENOMEM;
+
+	/* Instantiate the regulators */
+	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
+		reg_data = pdata->rk808_init_data[i];
+		if (!reg_data)
+			continue;
+
+		config.dev = &client->dev;
+		config.driver_data = rk808;
+		config.regmap = rk808->regmap;
+
+		if (client->dev.of_node)
+			config.of_node = pdata->of_node[i];
+
+		reg_data->supply_regulator = rk808_reg[i].name;
+		config.init_data = reg_data;
+
+		rk808_rdev = devm_regulator_register(&pdev->dev,
+						     &rk808_reg[i], &config);
+		if (IS_ERR(rk808_rdev)) {
+			dev_err(&client->dev,
+				"failed to register %d regulator\n", i);
+			return PTR_ERR(rk808_rdev);
+		}
+		rk808->rdev[i] = rk808_rdev;
+	}
+	return 0;
+}
+
+static struct platform_driver rk808_regulator_driver = {
+	.probe = rk808_regulator_probe,
+	.driver = {
+		.name = "rk808-regulator",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(rk808_regulator_driver);
+
+MODULE_DESCRIPTION("regulator driver for the rk808 series PMICs");
+MODULE_AUTHOR("Chris Zhong<zyw@rock-chips.com>");
+MODULE_AUTHOR("Zhang Qing<zhanqging@rock-chips.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk808-regulator");
-- 
1.7.9.5


