Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3IMTB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:01:29 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:49532 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3IMTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:01:28 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Wang Shilong <wangshilong1991@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4 v2] regulator: add STw481x VMMC driver
Date: Fri, 13 Sep 2013 21:01:15 +0200
Message-Id: <1379098875-9959-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ST Microelectronics STw481x PMIC used for the Nomadik
has one single software-controlled regulator for VMMC.
This driver registers directly to the compatible string
as there is just one regulator.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Use core regmap regulator helpers cutting half of the
  code.
- Fix checkpatch moanings.
- Move default-disable of the external regulator to probe()
- Cut the pointless sysfs debug node.
- Use module_platform_driver() macro.
---
 drivers/regulator/Kconfig        |   8 +++
 drivers/regulator/Makefile       |   1 +
 drivers/regulator/stw481x-vmmc.c | 110 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)
 create mode 100644 drivers/regulator/stw481x-vmmc.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index dfe5809..d957010 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -429,6 +429,14 @@ config REGULATOR_TI_ABB
 	  on TI SoCs may be unstable without enabling this as it provides
 	  device specific optimized bias to allow/optimize functionality.
 
+config REGULATOR_STW481X_VMMC
+	bool "ST Microelectronics STW481X VMMC regulator"
+	depends on MFD_STW481X
+	default y if MFD_STW481X
+	help
+	  This driver supports the internal VMMC regulator in the STw481x
+	  PMIC chips.
+
 config REGULATOR_TPS51632
 	tristate "TI TPS51632 Power Regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 185cce2..f2cfc45 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
 obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
diff --git a/drivers/regulator/stw481x-vmmc.c b/drivers/regulator/stw481x-vmmc.c
new file mode 100644
index 0000000..5ae72a8
--- /dev/null
+++ b/drivers/regulator/stw481x-vmmc.c
@@ -0,0 +1,110 @@
+/*
+ * Regulator driver for STw4810/STw4811 VMMC regulator.
+ *
+ * Copyright (C) 2013 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/mfd/stw481x.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+static const unsigned int stw481x_vmmc_voltages[] = {
+	1800000,
+	1800000,
+	2850000,
+	3000000,
+	1850000,
+	2600000,
+	2700000,
+	3300000,
+};
+
+static struct regulator_ops stw481x_vmmc_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.enable      = regulator_enable_regmap,
+	.disable     = regulator_disable_regmap,
+	.is_enabled  = regulator_is_enabled_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+};
+
+static struct regulator_desc vmmc_regulator = {
+	.name = "VMMC",
+	.id   = 0,
+	.ops  = &stw481x_vmmc_ops,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+	.n_voltages = ARRAY_SIZE(stw481x_vmmc_voltages),
+	.volt_table = stw481x_vmmc_voltages,
+	.enable_time = 200, /* FIXME: look this up */
+	.enable_reg = STW_CONF1,
+	.enable_mask = STW_CONF1_PDN_VMMC,
+	.vsel_reg = STW_CONF1,
+	.vsel_mask = STW_CONF1_VMMC_MASK,
+};
+
+static int stw481x_vmmc_regulator_probe(struct platform_device *pdev)
+{
+	struct stw481x *stw481x = dev_get_platdata(&pdev->dev);
+	struct regulator_config config = { };
+	int ret;
+
+	/* First disable the external VMMC if it's active */
+	ret = regmap_update_bits(stw481x->map, STW_CONF2,
+				 STW_CONF2_VMMC_EXT, 0);
+	if (ret) {
+		dev_err(&pdev->dev, "could not disable external VMMC\n");
+		return ret;
+	}
+
+	/* Register VMMC regulator */
+	config.dev = &pdev->dev;
+	config.driver_data = stw481x;
+	config.regmap = stw481x->map;
+	config.of_node = pdev->dev.of_node;
+	config.init_data = of_get_regulator_init_data(&pdev->dev,
+						      pdev->dev.of_node);
+
+	stw481x->vmmc_regulator = regulator_register(&vmmc_regulator, &config);
+	if (IS_ERR(stw481x->vmmc_regulator)) {
+		dev_err(&pdev->dev,
+			"error initializing STw481x VMMC regulator\n");
+		return PTR_ERR(stw481x->vmmc_regulator);
+	}
+
+	dev_info(&pdev->dev, "initialized STw481x VMMC regulator\n");
+	return 0;
+}
+
+static int stw481x_vmmc_regulator_remove(struct platform_device *pdev)
+{
+	struct stw481x *stw481x = dev_get_platdata(&pdev->dev);
+
+	regulator_unregister(stw481x->vmmc_regulator);
+	return 0;
+}
+
+static const struct of_device_id stw481x_vmmc_match[] = {
+	{ .compatible = "st,stw481x-vmmc", },
+	{},
+};
+
+static struct platform_driver stw481x_vmmc_regulator_driver = {
+	.driver = {
+		.name  = "stw481x-vmmc-regulator",
+		.owner = THIS_MODULE,
+	},
+	.probe = stw481x_vmmc_regulator_probe,
+	.remove = stw481x_vmmc_regulator_remove,
+};
+
+module_platform_driver(stw481x_vmmc_regulator_driver);
-- 
1.8.1.4

