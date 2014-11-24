Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaKXNCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:02:37 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51636 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaKXNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:02:33 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Alban Bedel <alban.bedel@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 2/4] regulator: add a regulator that constrain its supply
Date: Mon, 24 Nov 2014 14:02:01 +0100
Message-Id: <1416834123-23139-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:mgXjN3QS+gEt6FmJ+qzXQsbPS65N9RpxCt2HhtRFtdd
 oWBPOoV4T74+iYAmMPDMBeEKVGF55BSUAUXuHUdZvDVrFcxKPv
 VbZnYm7Ro9rwulvTrVHZ7+9II1CwVREGmpIyEDdVYrTlKVGccf
 9JTUwvzxlJ1GRVQ4E6jIii9sP2GcMy6hn5+Z7vQDPwizvLpx3C
 TFgg7KsDgvRj62nunrFXRSJJB2YMf6G7AdslCFvN0kyqc0m9GJ
 HNzLkUUdLcXWyx5vXGR4DzwwIX4QpbuIVWAmBZUv2WvRmTz7bV
 wYzGgs61x8aJJxk1LeSxe1s5sjZ3i5RnVzBfVqiO4HRf66nFeE
 tPmY9IgQWdp8dbraLBArrjY+TFKF/CiELBMkxotLinSBR/XZlR
 iraKx0uwOFWy5uL1dPo6cGiNxffVbSrOKRbOzZylUkQqY/gjQ+
 0FDBXGJi2U9WvjMmHNO8mJRMsFg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is meant for devices that are supplied by a settable
regulator but that don't set their supply voltage explicitly.
With this reglator those simple driver can just get and enable the
regulator and they will get the correct voltage.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/regulator/Kconfig              |   8 +++
 drivers/regulator/Makefile             |   1 +
 drivers/regulator/constrained-supply.c | 126 +++++++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+)
 create mode 100644 drivers/regulator/constrained-supply.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c8767b7..ebfd9a7 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -54,6 +54,14 @@ config REGULATOR_USERSPACE_CONSUMER
 
 	  If unsure, say no.
 
+config REGULATOR_CONSTRAINED_SUPPLY
+	tristate "Voltage regulator that constrain its supply"
+	depends on OF
+	help
+	  This driver provides a virtual regulator that constrains its supply.
+	  This is mostly useful to use drivers that don't explicitly set a
+	  voltage on boards that use variable regulators.
+
 config REGULATOR_88PM800
 	tristate "Marvell 88PM800 Power regulators"
 	depends on MFD_88PM800
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 37bb4b7..99c7979 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_OF) += of_regulator.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
+obj-$(CONFIG_REGULATOR_CONSTRAINED_SUPPLY) += constrained-supply.o
 
 obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
diff --git a/drivers/regulator/constrained-supply.c b/drivers/regulator/constrained-supply.c
new file mode 100644
index 0000000..1ab94b0
--- /dev/null
+++ b/drivers/regulator/constrained-supply.c
@@ -0,0 +1,126 @@
+/*
+ * Regulator driver that constrain its supply
+ *
+ * Copyright (C) 2014 - Alban Bedel
+ *
+ * Author: Alban Bedel <alban.bedel@avionic-design.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+/* Here we can't use rdev->supply as these functions are also
+ * called before the supply is set.
+ */
+static int constrained_supply_set_voltage(struct regulator_dev *rdev,
+					int min_uV, int max_uV,
+					unsigned *selector)
+{
+	struct regulator *supply = rdev_get_drvdata(rdev);
+
+	return regulator_set_voltage(supply, min_uV, max_uV);
+}
+
+static int constrained_supply_get_voltage(struct regulator_dev *rdev)
+{
+	struct regulator *supply = rdev_get_drvdata(rdev);
+
+	return regulator_get_voltage(supply);
+}
+
+static int constrained_supply_regulator_enable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
+static int constrained_supply_regulator_disable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
+static int constrained_supply_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	return rdev->use_count > 0;
+}
+
+static struct regulator_ops constrained_supply_regulator_ops = {
+	.get_voltage	= constrained_supply_get_voltage,
+	.set_voltage	= constrained_supply_set_voltage,
+	.enable		= constrained_supply_regulator_enable,
+	.disable	= constrained_supply_regulator_disable,
+	.is_enabled	= constrained_supply_regulator_is_enabled,
+};
+
+static const struct regulator_desc constrained_supply_regulator_desc = {
+	.name		= "constrained-supply",
+	.ops		= &constrained_supply_regulator_ops,
+	.type		= REGULATOR_VOLTAGE,
+	.owner		= THIS_MODULE,
+	.supply_name    = "vin",
+};
+
+static int constrained_supply_regulator_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct regulator_config config = {};
+	struct regulator_dev *regulator;
+	struct regulator *supply;
+
+	if (!np)
+		return -EINVAL;
+
+	/* We need the supply to be available */
+	supply = devm_regulator_get(&pdev->dev,
+				constrained_supply_regulator_desc.supply_name);
+	if (IS_ERR(supply)) {
+		dev_err(&pdev->dev, "Failed to get supply regulator\n");
+		return PTR_ERR(supply);
+	}
+
+	config.init_data = of_get_regulator_init_data(&pdev->dev, np);
+	if (!config.init_data)
+		return -ENOMEM;
+
+	config.of_node = np;
+	config.dev = &pdev->dev;
+	config.driver_data = supply;
+
+	regulator = devm_regulator_register(
+		&pdev->dev, &constrained_supply_regulator_desc, &config);
+	if (IS_ERR(regulator)) {
+		dev_err(&pdev->dev, "Failed to register regulator\n");
+		return PTR_ERR(regulator);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id constrained_supply_of_match[] = {
+	{ .compatible = "regulator-constrained-supply" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, constrained_supply_of_match);
+
+static struct platform_driver constrained_supply_regulator_driver = {
+	.driver = {
+		.name		= "constrained-supply-regulator",
+		.owner		= THIS_MODULE,
+		.of_match_table = of_match_ptr(constrained_supply_of_match),
+	},
+	.probe = constrained_supply_regulator_probe,
+};
+module_platform_driver(constrained_supply_regulator_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Alban Bedel <alban.bedel@avionic-design.de>");
+MODULE_DESCRIPTION("Constrained Supply Regulator Driver");
+MODULE_ALIAS("platform:-regulator");
-- 
2.1.3

