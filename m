Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3ITMJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:09:11 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8129 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3ITMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:09:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Sep 2013 05:09:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <akpm@linux-foundation.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: [PATCH V2 3/5] gpio: add support for AMS AS3722 gpio driver
Date: Fri, 20 Sep 2013 18:00:12 +0530
Message-ID: <1379680214-9143-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AS3722 is a compact system PMU suitable for mobile phones, tablets etc.

Add a driver to support accessing the 8 GPIOs found on the AMS AS3722
PMIC using gpiolib.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
---
Changes from V1:
- Nit cleanups in driver and use module_platform_driver.

 .../devicetree/bindings/gpio/gpio-as3722.txt       |   62 +++
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-as3722.c                         |  435 ++++++++++++++++++++
 4 files changed, 504 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-as3722.txt
 create mode 100644 drivers/gpio/gpio-as3722.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-as3722.txt b/Documentation/devicetree/bindings/gpio/gpio-as3722.txt
new file mode 100644
index 0000000..8d46dd3
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-as3722.txt
@@ -0,0 +1,62 @@
+GPIO of AMS AS3722 PMIC.
+
+Name of GPIO subnode should be "gpio".
+Required properties:
+--------------------
+- #address-cells: Number of address of the sub node of this node. Must be 1.
+- #size-cells: Size of addess cells. Must be 1.
+
+Sub node:
+--------
+The sub nodes provides the configuration of each GPIO pins. The properties of the
+nodes are as follows:
+
+Required subnode properties:
+---------------------------
+reg: The GPIO number on which the properties need to be applied.
+
+Optional subnode properties:
+---------------------------
+bias-pull-up: The Pull-up for the pin to be enable.
+bias-pull-down: Pull down of the pins to be enable.
+bias-high-impedance: High impedance of the pin to be enable.
+open-drain: Pin is open drain type.
+function: IO functionality of the pins. The valid options are:
+	gpio, intrrupt-output, vsup-vbat-low-undeb, interrupt-input,
+	pwm-input, voltage-stby, oc-powergood-sd0, powergood-output,
+	clk32k-output, watchdog-input, soft-reset-input, pwm-output,
+	vsup-vbat-low-deb, oc-powergood-sd6
+    Missing the function property will set the pin in GPIO mode.
+
+ams,enable-gpio-invert: Enable invert of the signal on GPIO pin.
+
+Example:
+	ams3722:: ams3722 {
+		compatible = "ams,as3722";
+		...
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		gpio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			gpio@0 {
+				reg = <0>;
+				bias-pull-down;
+			};
+
+			gpio@1 {
+				reg = <1>;
+				bias-pull-up;
+				ams,enable-gpio-invert;
+			};
+
+			...
+			gpio@5 {
+				reg = <5>;
+				unction  = "clk32k-output";
+			};
+			...
+		};
+		...
+	};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b6ed304..544a612 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -368,6 +368,12 @@ config GPIO_ARIZONA
 	help
 	  Support for GPIOs on Wolfson Arizona class devices.
 
+config GPIO_AS3722
+	bool "AMS AS3722 PMICs GPIO"
+	depends on MFD_AS3722
+	help
+	  Select this option to enable GPIO driver for the AMS AS3722 PMIC.
+
 config GPIO_MAX7300
 	tristate "Maxim MAX7300 GPIO expander"
 	depends on I2C
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 98e23eb..d1715a0 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
 obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
 obj-$(CONFIG_GPIO_AMD8111)	+= gpio-amd8111.o
 obj-$(CONFIG_GPIO_ARIZONA)	+= gpio-arizona.o
+obj-$(CONFIG_GPIO_AS3722)	+= gpio-as3722.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
diff --git a/drivers/gpio/gpio-as3722.c b/drivers/gpio/gpio-as3722.c
new file mode 100644
index 0000000..44b5a75
--- /dev/null
+++ b/drivers/gpio/gpio-as3722.c
@@ -0,0 +1,435 @@
+/*
+ * gpiolib support for ams AS3722 PMICs
+ *
+ * Copyright (C) 2013 ams AG
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/as3722.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define AS3722_MAX_GPIO				8
+#define AS3722_GPIO_MODE_PROP_PULL_UP		0x1
+#define AS3722_GPIO_MODE_PROP_PULL_DOWN		0x2
+#define AS3722_GPIO_MODE_PROP_HIGH_IMPED	0x4
+#define AS3722_GPIO_MODE_PROP_OPEN_DRAIN	0x8
+
+struct as3722_gpio_control {
+	bool enable_gpio_invert;
+	unsigned mode_prop;
+	int io_function;
+};
+
+struct as3722_gpio {
+	struct gpio_chip gpio_chip;
+	struct device *dev;
+	struct as3722 *as3722;
+	struct as3722_gpio_control gpio_control[AS3722_MAX_GPIO];
+};
+
+struct as3722_gpio_mode_property {
+	const char *prop;
+	u32 prop_val;
+};
+
+static char const *as3722_gpio_iosf[] = {
+	"gpio",
+	"intrrupt-output",
+	"vsup-vbat-low-undeb",
+	"interrupt-input",
+	"pwm-input",
+	"voltage-stby",
+	"oc-powergood-sd0",
+	"powergood-output",
+	"clk32k-output",
+	"watchdog-input",
+	"unused",
+	"soft-reset-input",
+	"pwm-output",
+	"vsup-vbat-low-deb",
+	"oc-powergood-sd6",
+	"unused1"
+};
+
+static const struct as3722_gpio_mode_property const as3722_gpio_mode_props[] = {
+	{
+		.prop = "bias-pull-up",
+		.prop_val = AS3722_GPIO_MODE_PROP_PULL_UP,
+	}, {
+		.prop = "bias-pull-down",
+		.prop_val = AS3722_GPIO_MODE_PROP_PULL_DOWN,
+	}, {
+		.prop = "bias-high-impedance",
+		.prop_val = AS3722_GPIO_MODE_PROP_HIGH_IMPED,
+	}, {
+		.prop = "open-drain",
+		.prop_val = AS3722_GPIO_MODE_PROP_OPEN_DRAIN,
+	},
+};
+
+static int as3722_gpio_get_mode(unsigned gpio_mode_prop, bool input)
+{
+	if (gpio_mode_prop & AS3722_GPIO_MODE_PROP_HIGH_IMPED)
+		return -EINVAL;
+
+	if (gpio_mode_prop & AS3722_GPIO_MODE_PROP_OPEN_DRAIN) {
+		if (gpio_mode_prop & AS3722_GPIO_MODE_PROP_PULL_UP)
+			return AS3722_GPIO_MODE_IO_OPEN_DRAIN_PULL_UP;
+		return AS3722_GPIO_MODE_IO_OPEN_DRAIN;
+	}
+	if (input) {
+		if (gpio_mode_prop & AS3722_GPIO_MODE_PROP_PULL_UP)
+			return AS3722_GPIO_MODE_INPUT_PULL_UP;
+		else if (gpio_mode_prop & AS3722_GPIO_MODE_PROP_PULL_DOWN)
+			return AS3722_GPIO_MODE_INPUT_PULL_DOWN;
+		return AS3722_GPIO_MODE_INPUT;
+	}
+	if (gpio_mode_prop & AS3722_GPIO_MODE_PROP_PULL_DOWN)
+		return AS3722_GPIO_MODE_OUTPUT_VDDL;
+	return AS3722_GPIO_MODE_OUTPUT_VDDH;
+}
+
+static inline struct as3722_gpio *to_as3722_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct as3722_gpio, gpio_chip);
+}
+
+static int as3722_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct as3722_gpio *as3722_gpio = to_as3722_gpio(chip);
+	struct as3722 *as3722 = as3722_gpio->as3722;
+	int ret;
+	u32 reg;
+	u32 control;
+	u32 val;
+	int mode;
+	int invert_enable;
+
+	ret = as3722_read(as3722, AS3722_GPIOn_CONTROL_REG(offset), &control);
+	if (ret < 0) {
+		dev_err(as3722_gpio->dev,
+			"GPIO_CONTROL%d_REG read failed: %d\n", offset, ret);
+		return ret;
+	}
+
+	invert_enable = !!(control & AS3722_GPIO_INV);
+	mode = control & AS3722_GPIO_MODE_MASK;
+	switch (mode) {
+	case AS3722_GPIO_MODE_INPUT:
+	case AS3722_GPIO_MODE_INPUT_PULL_UP:
+	case AS3722_GPIO_MODE_INPUT_PULL_DOWN:
+	case AS3722_GPIO_MODE_IO_OPEN_DRAIN:
+	case AS3722_GPIO_MODE_IO_OPEN_DRAIN_PULL_UP:
+		reg = AS3722_GPIO_SIGNAL_IN_REG;
+		break;
+	case AS3722_GPIO_MODE_OUTPUT_VDDH:
+	case AS3722_GPIO_MODE_OUTPUT_VDDL:
+		reg = AS3722_GPIO_SIGNAL_OUT_REG;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = as3722_read(as3722, reg, &val);
+	if (ret < 0) {
+		dev_err(as3722_gpio->dev,
+			"GPIO_SIGNAL_IN_REG read failed: %d\n", ret);
+		return ret;
+	}
+
+	val = !!(val & AS3722_GPIOn_SIGNAL(offset));
+	return (invert_enable) ? !val : val;
+}
+
+static void as3722_gpio_set(struct gpio_chip *chip, unsigned offset,
+		int value)
+{
+	struct as3722_gpio *as3722_gpio = to_as3722_gpio(chip);
+	struct as3722 *as3722 = as3722_gpio->as3722;
+	int en_invert = as3722_gpio->gpio_control[offset].enable_gpio_invert;
+	u32 val;
+	int ret;
+
+	if (value)
+		val = (en_invert) ? 0 : AS3722_GPIOn_SIGNAL(offset);
+	else
+		val = (en_invert) ? AS3722_GPIOn_SIGNAL(offset) : 0;
+
+	ret = as3722_update_bits(as3722, AS3722_GPIO_SIGNAL_OUT_REG,
+			AS3722_GPIOn_SIGNAL(offset), val);
+	if (ret < 0)
+		dev_err(as3722_gpio->dev,
+			"GPIO_SIGNAL_OUT_REG update failed: %d\n", ret);
+}
+
+static int as3722_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct as3722_gpio *as3722_gpio = to_as3722_gpio(chip);
+	struct as3722 *as3722 = as3722_gpio->as3722;
+	int mode;
+
+	mode = as3722_gpio_get_mode(as3722_gpio->gpio_control[offset].mode_prop,
+			true);
+	if (mode < 0) {
+		dev_err(as3722_gpio->dev,
+			"Input direction for GPIO %d not supported\n", offset);
+		return mode;
+	}
+
+	if (as3722_gpio->gpio_control[offset].enable_gpio_invert)
+		mode |= AS3722_GPIO_INV;
+
+	return as3722_write(as3722, AS3722_GPIOn_CONTROL_REG(offset), mode);
+}
+
+static int as3722_gpio_direction_output(struct gpio_chip *chip,
+		unsigned offset, int value)
+{
+	struct as3722_gpio *as3722_gpio = to_as3722_gpio(chip);
+	struct as3722 *as3722 = as3722_gpio->as3722;
+	int mode;
+
+	mode = as3722_gpio_get_mode(as3722_gpio->gpio_control[offset].mode_prop,
+			false);
+	if (mode < 0) {
+		dev_err(as3722_gpio->dev,
+			"Output direction for GPIO %d not supported\n", offset);
+		return mode;
+	}
+
+	as3722_gpio_set(chip, offset, value);
+	if (as3722_gpio->gpio_control[offset].enable_gpio_invert)
+		mode |= AS3722_GPIO_INV;
+	return as3722_write(as3722, AS3722_GPIOn_CONTROL_REG(offset), mode);
+}
+
+static int as3722_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct as3722_gpio *as3722_gpio = to_as3722_gpio(chip);
+
+	return as3722_irq_get_virq(as3722_gpio->as3722, offset);
+}
+
+static int as3722_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct as3722_gpio *as3722_gpio = to_as3722_gpio(chip);
+
+	if (as3722_gpio->gpio_control[offset].io_function)
+		return -EBUSY;
+	return 0;
+}
+
+static int as3722_gpio_set_config(struct as3722_gpio *as3722_gpio,
+		unsigned int gpio)
+{
+	struct as3722 *as3722 = as3722_gpio->as3722;
+	int ret = 0;
+	u8 val = 0;
+
+	val = AS3722_GPIO_IOSF_VAL(as3722_gpio->gpio_control[gpio].io_function);
+	ret = as3722_update_bits(as3722, AS3722_GPIOn_CONTROL_REG(gpio),
+			AS3722_GPIO_IOSF_MASK, val);
+	if (ret < 0)
+		dev_err(as3722->dev,
+			"GPIO%d_CTRL_REG update failed %d\n", gpio, ret);
+	return ret;
+}
+
+static int as3722_gpio_init_configs(struct as3722_gpio *as3722_gpio)
+{
+	int ret;
+	unsigned int i;
+
+	for (i = 0; i < AS3722_MAX_GPIO; i++) {
+		if (!as3722_gpio->gpio_control[i].io_function)
+			continue;
+
+		ret = as3722_gpio_set_config(as3722_gpio, i);
+		if (ret < 0) {
+			dev_err(as3722_gpio->dev,
+				"GPIO %d config failed %d\n", i, ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int as3722_gpio_dt_subnode(struct as3722_gpio *as3722_gpio,
+		struct device_node *child, int gpio)
+{
+	const char *iosf;
+	int i;
+	int ret;
+	bool found;
+	unsigned prop_val = 0;
+
+	for (i = 0; i < ARRAY_SIZE(as3722_gpio_mode_props); ++i) {
+		found = of_property_read_bool(child,
+					as3722_gpio_mode_props[i].prop);
+		if (found)
+			prop_val |= as3722_gpio_mode_props[i].prop_val;
+	}
+	as3722_gpio->gpio_control[gpio].mode_prop = prop_val;
+
+	ret = of_property_read_string(child, "function", &iosf);
+	if (!ret) {
+		found = false;
+		for (i = 0; i < ARRAY_SIZE(as3722_gpio_iosf); ++i) {
+			if (!strcmp(as3722_gpio_iosf[i], iosf)) {
+				found = true;
+				break;
+			}
+		}
+		if (found)
+			as3722_gpio->gpio_control[gpio].io_function = i;
+		else
+			dev_warn(as3722_gpio->dev,
+				"Child %s io function is invalid\n",
+				child->name);
+	}
+
+	as3722_gpio->gpio_control[gpio].enable_gpio_invert =
+			of_property_read_bool(child, "ams,enable-gpio-invert");
+	return 0;
+}
+
+static int as3722_get_gpio_dt_data(struct platform_device *pdev,
+		struct as3722_gpio *as3722_gpio)
+{
+	struct device_node *np;
+	struct device_node *child;
+	unsigned int gpio;
+	int ret;
+
+	np = of_get_child_by_name(pdev->dev.parent->of_node, "gpio");
+	if (!np) {
+		dev_err(&pdev->dev, "Device is not having gpio node\n");
+		return -ENODEV;
+	}
+
+	for_each_child_of_node(np, child) {
+		ret = of_property_read_u32(child, "reg", &gpio);
+		if (ret < 0) {
+			dev_warn(&pdev->dev,
+				"reg property not present in node %s\n",
+				child->name);
+			continue;
+		}
+		if (gpio >=  AS3722_MAX_GPIO) {
+			dev_warn(&pdev->dev,
+			     "GPIO number %d is more than supported\n", gpio);
+			continue;
+		}
+		ret = as3722_gpio_dt_subnode(as3722_gpio, child, gpio);
+		if (ret < 0)
+			dev_warn(&pdev->dev, "gpio %s node parse failed: %d\n",
+				child->name, ret);
+	}
+	return 0;
+}
+
+static const struct gpio_chip as3722_gpio_chip = {
+	.label			= "as3722-gpio",
+	.owner			= THIS_MODULE,
+	.direction_input	= as3722_gpio_direction_input,
+	.get			= as3722_gpio_get,
+	.direction_output	= as3722_gpio_direction_output,
+	.set			= as3722_gpio_set,
+	.to_irq			= as3722_gpio_to_irq,
+	.request		= as3722_gpio_request,
+	.can_sleep		= 1,
+	.ngpio			= AS3722_MAX_GPIO,
+	.base			= -1,
+};
+
+static int as3722_gpio_probe(struct platform_device *pdev)
+{
+	struct as3722 *as3722 =  dev_get_drvdata(pdev->dev.parent);
+	struct as3722_gpio *as3722_gpio;
+	int ret;
+
+	as3722_gpio = devm_kzalloc(&pdev->dev, sizeof(*as3722_gpio),
+				GFP_KERNEL);
+	if (!as3722_gpio)
+		return -ENOMEM;
+
+	ret = as3722_get_gpio_dt_data(pdev, as3722_gpio);
+	if (ret < 0)
+		return ret;
+
+	as3722_gpio->as3722 = as3722;
+	as3722_gpio->dev = &pdev->dev;
+	as3722_gpio->gpio_chip = as3722_gpio_chip;
+	as3722_gpio->gpio_chip.dev = &pdev->dev;
+	as3722_gpio->gpio_chip.of_node = pdev->dev.parent->of_node;
+
+	platform_set_drvdata(pdev, as3722_gpio);
+
+	ret = as3722_gpio_init_configs(as3722_gpio);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "gpio_init_regs failed\n");
+		return ret;
+	}
+
+	ret = gpiochip_add(&as3722_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
+				ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int as3722_gpio_remove(struct platform_device *pdev)
+{
+	struct as3722_gpio *as3722_gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&as3722_gpio->gpio_chip);
+}
+
+static const struct of_device_id of_as3722_gpio_match[] = {
+	{ .compatible = "ams,as3722-gpio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_as3722_gpio_match);
+
+static struct platform_driver as3722_gpio_driver = {
+	.driver = {
+		.name = "as3722-gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = of_as3722_gpio_match,
+	},
+	.probe = as3722_gpio_probe,
+	.remove = as3722_gpio_remove,
+};
+
+module_platform_driver(as3722_gpio_driver);
+
+MODULE_ALIAS("platform:as3722-gpio");
+MODULE_DESCRIPTION("GPIO interface for AS3722 PMICs");
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.1.1

