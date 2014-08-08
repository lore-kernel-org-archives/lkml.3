Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaHHJKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:10:33 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61519 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaHHJKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:10:30 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, jack.yoo@skyworksinc.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Adding Skyworks SKY81452 regulator driver
Date: Fri,  8 Aug 2014 18:10:22 +0900
Message-Id: <1407489022-31130-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
 .../bindings/regulator/sky81452-regulator.txt      |  16 +++
 drivers/regulator/Kconfig                          |  11 ++
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/sky81452-regulator.c             | 130 +++++++++++++++++++++
 4 files changed, 158 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
 create mode 100644 drivers/regulator/sky81452-regulator.c

diff --git a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
new file mode 100644
index 0000000..f98b5ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
@@ -0,0 +1,16 @@
+SKY81452 voltage regulator
+
+Required properties:
+- any required generic properties defined in regulator.txt
+
+Optional properties:
+- any available generic properties defined in regulator.txt
+
+Example:
+
+	regualtor {
+		/* generic regulator properties */
+		regulator-name = "touch_en";
+		regulator-min-microvolt = <4500000>;
+		regulator-max-microvolt = <8000000>;
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 2dc8289..f6bf208 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -483,6 +483,17 @@ config REGULATOR_S5M8767
 	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
 	 supports DVS mode with 8bits of output voltage control.
 
+config REGULATOR_SKY81452
+	tristate "Skyworks Solutions SKY81452 voltage regulator"
+	depends on SKY81452
+	help
+	  This driver supports Skyworks SKY81452 voltage output regulator
+	  via I2C bus. SKY81452 has one voltage linear regulator can be
+	  programmed from 4.5V to 20V.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called sky81452-regulator.
+
 config REGULATOR_ST_PWM
 	tristate "STMicroelectronics PWM voltage regulator"
 	depends on ARCH_STI
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index aa4a6aa..d8206ec 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+obj-$(CONFIG_REGULATOR_SKY81452) += sky81452-regulator.o
 obj-$(CONFIG_REGULATOR_ST_PWM) += st-pwm.o
 obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
 obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
new file mode 100644
index 0000000..97aff0c
--- /dev/null
+++ b/drivers/regulator/sky81452-regulator.c
@@ -0,0 +1,130 @@
+/*
+ * sky81452-regulator.c	SKY81452 regulator driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+/* registers */
+#define SKY81452_REG1	0x01
+#define SKY81452_REG3	0x03
+
+/* bit mask */
+#define SKY81452_LEN	0x40
+#define SKY81452_LOUT	0x1F
+
+static struct regulator_ops sky81452_reg_ops = {
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+};
+
+static const struct regulator_linear_range sky81452_reg_ranges[] = {
+	REGULATOR_LINEAR_RANGE(4500000, 0, 14, 250000),
+	REGULATOR_LINEAR_RANGE(9000000, 15, 31, 1000000),
+};
+
+static const struct regulator_desc sky81452_reg = {
+	.name = "LOUT",
+	.ops = &sky81452_reg_ops,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+	.n_voltages = SKY81452_LOUT + 1,
+	.linear_ranges = sky81452_reg_ranges,
+	.n_linear_ranges = ARRAY_SIZE(sky81452_reg_ranges),
+	.vsel_reg = SKY81452_REG3,
+	.vsel_mask = SKY81452_LOUT,
+	.enable_reg = SKY81452_REG1,
+	.enable_mask = SKY81452_LEN,
+};
+
+#ifdef CONFIG_OF
+static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
+{
+	struct regulator_init_data *init_data;
+	struct device_node *np;
+
+	np = of_get_child_by_name(dev->parent->of_node, "regulator");
+	if (unlikely(!np)) {
+		dev_err(dev, "regulator node not found");
+		return NULL;
+	}
+
+	init_data = of_get_regulator_init_data(dev, np);
+
+	of_node_put(np);
+	return init_data;
+}
+#else
+static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
+
+static int sky81452_reg_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct regulator_init_data *init_data = dev_get_platdata(dev);
+	struct regulator_config config = { };
+	struct regulator_dev *rdev;
+
+	if (!init_data) {
+		init_data = sky81452_reg_parse_dt(dev);
+		if (IS_ERR(init_data))
+			return PTR_ERR(init_data);
+	}
+
+	config.dev = dev;
+	config.init_data = init_data;
+	config.of_node = dev->of_node;
+	config.regmap = dev_get_drvdata(dev->parent);
+
+	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	platform_set_drvdata(pdev, rdev);
+
+	return 0;
+}
+
+static struct platform_driver sky81452_reg_driver = {
+	.driver = {
+		.name = "sky81452-regulator",
+	},
+	.probe = sky81452_reg_probe,
+};
+
+module_platform_driver(sky81452_reg_driver);
+
+MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
+MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
-- 
1.9.1

