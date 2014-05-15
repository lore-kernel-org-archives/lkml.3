Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaEORwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:52:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34528 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225AbaEORwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:52:07 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH 2/3] regulator: AXP22x: add support for AXP221 regulators
Date: Thu, 15 May 2014 19:51:44 +0200
Message-Id: <1400176305-22737-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AXP221 PMIC provide 5 DC-DCs regulators and 14 LDO regulators.
This patch adds support for these regulators.

See http://linux-sunxi.org/AXP221#Regulators for detailed informations
on AXP221's regulators.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/regulator/Kconfig            |   7 +
 drivers/regulator/Makefile           |   1 +
 drivers/regulator/axp22x-regulator.c | 328 +++++++++++++++++++++++++++++++++++
 3 files changed, 336 insertions(+)
 create mode 100644 drivers/regulator/axp22x-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8cc10e2..0e6da83 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -154,6 +154,13 @@ config REGULATOR_AXP20X
 	  This driver provides support for the voltage regulators on the
 	  AXP20X PMIC.
 
+config REGULATOR_AXP22X
+	tristate "X-POWERS AXP22X PMIC Regulators"
+	depends on MFD_AXP20X
+	help
+	  This driver provides support for the voltage regulators on the
+	  AXP22X PMIC.
+
 config REGULATOR_DA903X
 	tristate "Dialog Semiconductor DA9030/DA9034 regulators"
 	depends on PMIC_DA903X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 194ee45..3d63ad5 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_REGULATOR_AS3711) += as3711-regulator.o
 obj-$(CONFIG_REGULATOR_AS3722) += as3722-regulator.o
 obj-$(CONFIG_REGULATOR_BCM590XX) += bcm590xx-regulator.o
 obj-$(CONFIG_REGULATOR_AXP20X) += axp20x-regulator.o
+obj-$(CONFIG_REGULATOR_AXP22X) += axp22x-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DA9055)	+= da9055-regulator.o
diff --git a/drivers/regulator/axp22x-regulator.c b/drivers/regulator/axp22x-regulator.c
new file mode 100644
index 0000000..88abcac
--- /dev/null
+++ b/drivers/regulator/axp22x-regulator.c
@@ -0,0 +1,328 @@
+/*
+ * AXP22x regulators driver.
+ *
+ * Copyright (C) 2014 Free Electrons
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ *
+ * Derived from drivers/regulator/axp20x-regulator.c:
+ *   Author: Carlo Caione <carlo@caione.org>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/axp22x.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+#define AXP22X_IO_ENABLED		0x04
+#define AXP22X_IO_DISABLED		0x03
+
+#define AXP22X_WORKMODE_DCDC2_MASK	BIT(2)
+#define AXP22X_WORKMODE_DCDC3_MASK	BIT(1)
+
+#define AXP22X_FREQ_DCDC_MASK		0x0f
+
+#define AXP22X_DESC_IO(_id, _supply, _min, _max, _step, _vreg, _vmask, _ereg,   \
+		       _emask, _enable_val, _disable_val)			\
+	[AXP22X_##_id] = {							\
+		.name		= #_id,						\
+		.supply_name	= (_supply),					\
+		.type		= REGULATOR_VOLTAGE,				\
+		.id		= AXP22X_##_id,					\
+		.n_voltages	= (((_max) - (_min)) / (_step) + 1),		\
+		.owner		= THIS_MODULE,					\
+		.min_uV		= (_min) * 1000,				\
+		.uV_step	= (_step) * 1000,				\
+		.vsel_reg	= (_vreg),					\
+		.vsel_mask	= (_vmask),					\
+		.enable_reg	= (_ereg),					\
+		.enable_mask	= (_emask),					\
+		.enable_val	= (_enable_val),				\
+		.disable_val	= (_disable_val),				\
+		.ops		= &axp22x_ops,					\
+	}
+
+#define AXP22X_DESC(_id, _supply, _min, _max, _step, _vreg, _vmask, _ereg,	\
+		    _emask) 							\
+	[AXP22X_##_id] = {							\
+		.name		= #_id,						\
+		.supply_name	= (_supply),					\
+		.type		= REGULATOR_VOLTAGE,				\
+		.id		= AXP22X_##_id,					\
+		.n_voltages	= (((_max) - (_min)) / (_step) + 1),		\
+		.owner		= THIS_MODULE,					\
+		.min_uV		= (_min) * 1000,				\
+		.uV_step	= (_step) * 1000,				\
+		.vsel_reg	= (_vreg),					\
+		.vsel_mask	= (_vmask),					\
+		.enable_reg	= (_ereg),					\
+		.enable_mask	= (_emask),					\
+		.ops		= &axp22x_ops,					\
+	}
+
+#define AXP22X_DESC_FIXED(_id, _supply, _volt)					\
+	[AXP22X_##_id] = {							\
+		.name		= #_id,						\
+		.supply_name	= (_supply),					\
+		.type		= REGULATOR_VOLTAGE,				\
+		.id		= AXP22X_##_id,					\
+		.n_voltages	= 1,						\
+		.owner		= THIS_MODULE,					\
+		.min_uV		= (_volt) * 1000,				\
+		.ops		= &axp22x_ops_fixed				\
+	}
+
+static struct regulator_ops axp22x_ops_fixed = {
+	.list_voltage		= regulator_list_voltage_linear,
+};
+
+static struct regulator_ops axp22x_ops = {
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+};
+
+static const struct regulator_desc axp22x_regulators[] = {
+	AXP22X_DESC(DCDC1, "vin1", 1600, 3400, 100, AXP22X_DCDC1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(1)),
+	AXP22X_DESC(DCDC2, "vin2", 600, 1540, 20, AXP22X_DCDC2_V_OUT, 0x3f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(2)),
+	AXP22X_DESC(DCDC3, "vin3", 600, 1860, 20, AXP22X_DCDC3_V_OUT, 0x3f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(3)),
+	AXP22X_DESC(DCDC4, "vin4", 600, 1540, 20, AXP22X_DCDC4_V_OUT, 0x3f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(3)),
+	AXP22X_DESC(DCDC5, "vin5", 1000, 2550, 50, AXP22X_DCDC5_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(4)),
+	AXP22X_DESC(DC5LDO, "vin5", 700, 1400, 100, AXP22X_DC5LDO_V_OUT, 0x7,
+		    AXP22X_PWR_OUT_CTRL1, BIT(0)),
+	AXP22X_DESC(ALDO1, "aldoin", 700, 3300, 100, AXP22X_ALDO1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(6)),
+	AXP22X_DESC(ALDO2, "aldoin", 700, 3300, 100, AXP22X_ALDO2_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(7)),
+	AXP22X_DESC(ALDO3, "aldoin", 700, 3300, 100, AXP22X_ALDO3_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL3, BIT(7)),
+	AXP22X_DESC(DLDO1, "dldoin", 700, 3300, 100, AXP22X_DLDO1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(3)),
+	AXP22X_DESC(DLDO2, "dldoin", 700, 3300, 100, AXP22X_DLDO2_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(4)),
+	AXP22X_DESC(DLDO3, "dldoin", 700, 3300, 100, AXP22X_DLDO3_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(5)),
+	AXP22X_DESC(DLDO4, "dldoin", 700, 3300, 100, AXP22X_DLDO4_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(6)),
+	AXP22X_DESC(ELDO1, "eldoin", 700, 3300, 100, AXP22X_ELDO1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(0)),
+	AXP22X_DESC(ELDO2, "eldoin", 700, 3300, 100, AXP22X_ELDO2_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(1)),
+	AXP22X_DESC(ELDO3, "eldoin", 700, 3300, 100, AXP22X_ELDO3_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(2)),
+	AXP22X_DESC_IO(LDO_IO0, "ldoioin", 1800, 3300, 100, AXP22X_LDO_IO0_V_OUT,
+		       0x1f, AXP22X_GPIO0_CTRL, 0x07, AXP22X_IO_ENABLED,
+		       AXP22X_IO_DISABLED),
+	AXP22X_DESC_IO(LDO_IO1, "ldoioin", 1800, 3300, 100, AXP22X_LDO_IO1_V_OUT,
+		       0x1f, AXP22X_GPIO1_CTRL, 0x07, AXP22X_IO_ENABLED,
+		       AXP22X_IO_DISABLED),
+	AXP22X_DESC_FIXED(RTC_LDO, "rtcldoin", 3000),
+};
+
+#define AXP_MATCH(_name, _id) \
+	[AXP22X_##_id] = { \
+		.name		= #_name, \
+		.driver_data	= (void *) &axp22x_regulators[AXP22X_##_id], \
+	}
+
+static struct of_regulator_match axp22x_matches[] = {
+	AXP_MATCH(dcdc1, DCDC1),
+	AXP_MATCH(dcdc2, DCDC2),
+	AXP_MATCH(dcdc3, DCDC3),
+	AXP_MATCH(dcdc4, DCDC4),
+	AXP_MATCH(dcdc5, DCDC5),
+	AXP_MATCH(dc5ldo, DC5LDO),
+	AXP_MATCH(aldo1, ALDO1),
+	AXP_MATCH(aldo2, ALDO2),
+	AXP_MATCH(aldo3, ALDO3),
+	AXP_MATCH(dldo1, DLDO1),
+	AXP_MATCH(dldo2, DLDO2),
+	AXP_MATCH(dldo3, DLDO3),
+	AXP_MATCH(dldo4, DLDO4),
+	AXP_MATCH(eldo1, ELDO1),
+	AXP_MATCH(eldo2, ELDO2),
+	AXP_MATCH(eldo3, ELDO3),
+	AXP_MATCH(ldo_io0, LDO_IO0),
+	AXP_MATCH(ldo_io1, LDO_IO1),
+	AXP_MATCH(rtc_ldo, RTC_LDO),
+};
+
+static int axp22x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
+{
+	struct axp22x_dev *axp22x = dev_get_drvdata(pdev->dev.parent);
+
+	if (dcdcfreq < 750) {
+		dcdcfreq = 750;
+		dev_warn(&pdev->dev, "DCDC frequency too low. Set to 750kHz\n");
+	}
+
+	if (dcdcfreq > 1875) {
+		dcdcfreq = 1875;
+		dev_warn(&pdev->dev, "DCDC frequency too high. Set to 1875kHz\n");
+	}
+
+	dcdcfreq = (dcdcfreq - 750) / 75;
+
+	return regmap_update_bits(axp22x->regmap, AXP22X_DCDC_FREQ,
+				  AXP22X_FREQ_DCDC_MASK, dcdcfreq);
+}
+
+static int axp22x_regulator_parse_dt(struct platform_device *pdev)
+{
+	struct device_node *np, *regulators;
+	int ret;
+	u32 dcdcfreq;
+
+	np = of_node_get(pdev->dev.parent->of_node);
+	if (!np)
+		return 0;
+
+	regulators = of_find_node_by_name(np, "regulators");
+	if (!regulators) {
+		dev_warn(&pdev->dev, "regulators node not found\n");
+	} else {
+		ret = of_regulator_match(&pdev->dev, regulators, axp22x_matches,
+					 ARRAY_SIZE(axp22x_matches));
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
+			return ret;
+		}
+
+		dcdcfreq = 1500;
+		of_property_read_u32(regulators, "x-powers,dcdc-freq", &dcdcfreq);
+		ret = axp22x_set_dcdc_freq(pdev, dcdcfreq);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Error setting dcdc frequency: %d\n", ret);
+			return ret;
+		}
+
+		of_node_put(regulators);
+	}
+
+	return 0;
+}
+
+static int axp22x_set_dcdc_workmode(struct regulator_dev *rdev, int id, u32 workmode)
+{
+	unsigned int mask = BIT(id);
+
+	if (workmode)
+		workmode = mask;
+
+	return regmap_update_bits(rdev->regmap, AXP22X_DCDC_MODE, mask, workmode);
+}
+
+static int axp22x_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev;
+	struct axp22x_dev *axp22x = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
+	struct regulator_init_data *init_data;
+	bool registered[AXP22X_REG_ID_MAX];
+	int nregistered = 0;
+	int prev_nregistered = -1;
+	int ret, i;
+	u32 workmode;
+
+	ret = axp22x_regulator_parse_dt(pdev);
+	if (ret)
+		return ret;
+
+	memset(&registered, 0, sizeof(registered));
+
+	/*
+	 * Some regulators might take their power supply from other regulators
+	 * defined by the same PMIC.
+	 *
+	 * Retry regulators registration until all regulators are registered
+	 * or the last iteration didn't manage to register any new regulator
+	 * (which means there's an external dependency missing and we can thus
+	 * return EPROBE_DEFER).
+	 */
+	while (nregistered < AXP22X_REG_ID_MAX &&
+	       prev_nregistered < nregistered) {
+
+		prev_nregistered = nregistered;
+
+		for (i = 0; i < AXP22X_REG_ID_MAX; i++) {
+			if (registered[i])
+				continue;
+
+			init_data = axp22x_matches[i].init_data;
+
+			config.dev = &pdev->dev;
+			config.init_data = init_data;
+			config.regmap = axp22x->regmap;
+			config.of_node = axp22x_matches[i].of_node;
+
+			rdev = devm_regulator_register(&pdev->dev,
+						       &axp22x_regulators[i],
+						       &config);
+			if (IS_ERR(rdev)) {
+				if (PTR_ERR(rdev) == -EPROBE_DEFER)
+					continue;
+
+				dev_err(&pdev->dev, "Failed to register %s\n",
+					axp22x_regulators[i].name);
+
+				return PTR_ERR(rdev);
+			}
+
+			nregistered++;
+
+			ret = of_property_read_u32(axp22x_matches[i].of_node,
+						   "x-powers,dcdc-workmode",
+						   &workmode);
+			if (!ret &&
+			    axp22x_set_dcdc_workmode(rdev, i, workmode))
+				dev_err(&pdev->dev,
+					"Failed to set workmode on %s\n",
+					axp22x_regulators[i].name);
+
+			registered[i] = true;
+			nregistered++;
+		}
+	}
+
+	if (nregistered < AXP22X_REG_ID_MAX)
+		return -EPROBE_DEFER;
+
+	return 0;
+}
+
+static struct platform_driver axp22x_regulator_driver = {
+	.probe	= axp22x_regulator_probe,
+	.driver	= {
+		.name		= "axp22x-regulator",
+		.owner		= THIS_MODULE,
+	},
+};
+
+module_platform_driver(axp22x_regulator_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Carlo Caione <carlo@caione.org>");
+MODULE_DESCRIPTION("Regulator Driver for AXP22X PMIC");
-- 
1.8.3.2

