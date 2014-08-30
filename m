Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaH3Mve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:51:34 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46645 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaH3Mv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:51:29 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 2/4] regulator: add driver for Ricoh RN5T618 regulators
Date: Sat, 30 Aug 2014 14:50:24 +0200
Message-Id: <1409403026-28818-3-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
References: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the 3 DCDC and 7 LDO regulators available on
Ricoh RN5T618 PMIC.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/regulator/Kconfig             |    6 ++
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/rn5t618-regulator.c |  143 +++++++++++++++++++++++++++++++++
 3 files changed, 150 insertions(+)
 create mode 100644 drivers/regulator/rn5t618-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index fb32bab..ac0e643 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -469,6 +469,12 @@ config REGULATOR_RK808
 	  through regulator interface. The device supports multiple DCDC/LDO
 	  outputs which can be controlled by i2c communication.
 
+config REGULATOR_RN5T618
+	tristate "Ricoh RN5T618 voltage regulators"
+	depends on MFD_RN5T618
+	help
+	  Say y here to support the regulators found on Ricoh RN5T618 PMIC.
+
 config REGULATOR_S2MPA01
 	tristate "Samsung S2MPA01 voltage regulator"
 	depends on MFD_SEC_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 236fdbb..3b767c6 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_RK808)   += rk808-regulator.o
+obj-$(CONFIG_REGULATOR_RN5T618) += rn5t618-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
diff --git a/drivers/regulator/rn5t618-regulator.c b/drivers/regulator/rn5t618-regulator.c
new file mode 100644
index 0000000..e58d79a
--- /dev/null
+++ b/drivers/regulator/rn5t618-regulator.c
@@ -0,0 +1,143 @@
+/*
+ * Regulator driver for Ricoh RN5T618 PMIC
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/mfd/rn5t618.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+static struct regulator_ops rn5t618_reg_ops = {
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+};
+
+#define REG(rid, ereg, emask, vreg, vmask, min, max, step)		\
+	[RN5T618_##rid] = {						\
+		.name		= #rid,					\
+		.id		= RN5T618_##rid,			\
+		.type		= REGULATOR_VOLTAGE,			\
+		.owner		= THIS_MODULE,				\
+		.ops		= &rn5t618_reg_ops,			\
+		.n_voltages	= ((max) - (min)) / (step) + 1,		\
+		.min_uV		= (min),				\
+		.uV_step	= (step),				\
+		.enable_reg	= RN5T618_##ereg,			\
+		.enable_mask	= (emask),				\
+		.vsel_reg	= RN5T618_##vreg,			\
+		.vsel_mask	= (vmask),				\
+	}
+
+static struct regulator_desc rn5t618_regulators[] = {
+	/* DCDC */
+	REG(DCDC1, DC1CTL, BIT(0), DC1DAC, 0xff, 600000, 3500000, 12500),
+	REG(DCDC2, DC2CTL, BIT(0), DC2DAC, 0xff, 600000, 3500000, 12500),
+	REG(DCDC3, DC3CTL, BIT(0), DC3DAC, 0xff, 600000, 3500000, 12500),
+	/* LDO */
+	REG(LDO1, LDOEN1, BIT(0), LDO1DAC, 0x7f, 900000, 3500000, 25000),
+	REG(LDO2, LDOEN1, BIT(1), LDO2DAC, 0x7f, 900000, 3500000, 25000),
+	REG(LDO3, LDOEN1, BIT(2), LDO3DAC, 0x7f, 600000, 3500000, 25000),
+	REG(LDO4, LDOEN1, BIT(3), LDO4DAC, 0x7f, 900000, 3500000, 25000),
+	REG(LDO5, LDOEN1, BIT(4), LDO5DAC, 0x7f, 900000, 3500000, 25000),
+	/* LDO RTC */
+	REG(LDORTC1, LDOEN2, BIT(4), LDORTCDAC, 0x7f, 1700000, 3500000, 25000),
+	REG(LDORTC2, LDOEN2, BIT(5), LDORTC2DAC, 0x7f, 900000, 3500000, 25000),
+};
+
+static struct of_regulator_match rn5t618_matches[] = {
+	[RN5T618_DCDC1]		= { .name = "DCDC1" },
+	[RN5T618_DCDC2]		= { .name = "DCDC2" },
+	[RN5T618_DCDC3]		= { .name = "DCDC3" },
+	[RN5T618_LDO1]		= { .name = "LDO1" },
+	[RN5T618_LDO2]		= { .name = "LDO2" },
+	[RN5T618_LDO3]		= { .name = "LDO3" },
+	[RN5T618_LDO4]		= { .name = "LDO4" },
+	[RN5T618_LDO5]		= { .name = "LDO5" },
+	[RN5T618_LDORTC1]	= { .name = "LDORTC1" },
+	[RN5T618_LDORTC2]	= { .name = "LDORTC2" },
+};
+
+static int rn5t618_regulator_parse_dt(struct platform_device *pdev)
+{
+	struct device_node *np, *regulators;
+	int ret;
+
+	np = of_node_get(pdev->dev.parent->of_node);
+	if (!np)
+		return 0;
+
+	regulators = of_get_child_by_name(np, "regulators");
+	if (!regulators) {
+		dev_err(&pdev->dev, "regulators node not found\n");
+		return -EINVAL;
+	}
+
+	ret = of_regulator_match(&pdev->dev, regulators, rn5t618_matches,
+				 ARRAY_SIZE(rn5t618_matches));
+	of_node_put(regulators);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "error parsing regulator init data: %d\n",
+			ret);
+	}
+
+	return 0;
+}
+
+static int rn5t618_regulator_probe(struct platform_device *pdev)
+{
+	struct rn5t618 *rn5t618 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
+	struct regulator_dev *rdev;
+	int ret, i;
+
+	ret = rn5t618_regulator_parse_dt(pdev);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < RN5T618_REG_NUM; i++) {
+		config.dev = &pdev->dev;
+		config.init_data = rn5t618_matches[i].init_data;
+		config.of_node = rn5t618_matches[i].of_node;
+		config.regmap = rn5t618->regmap;
+
+		rdev = devm_regulator_register(&pdev->dev,
+					       &rn5t618_regulators[i],
+					       &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev, "failed to register %s regulator\n",
+				rn5t618_regulators[i].name);
+			return PTR_ERR(rdev);
+		}
+	}
+
+	return 0;
+}
+
+static struct platform_driver rn5t618_regulator_driver = {
+	.probe = rn5t618_regulator_probe,
+	.driver = {
+		.name	= "rn5t618-regulator",
+	},
+};
+
+module_platform_driver(rn5t618_regulator_driver);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("RN5T618 regulator driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

