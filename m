Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3JHN0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:26:36 -0400
Received: from mail.abilis.ch ([195.70.19.74]:16807 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3JHNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:25:10 -0400
X-Greylist: delayed 3775 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 09:25:06 EDT
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 01/03] Make non-linear GPIO ranges accesible from gpiolib
Date: Tue,  8 Oct 2013 14:25:20 +0200
Message-Id: <1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20131008122145.GA21985@ab42.lan>
References: <20131008122145.GA21985@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the infrastructure required to register non-linear gpio
ranges through gpiolib and the standard GPIO device tree bindings.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt |   40 +++++++++++++++++++
 drivers/gpio/gpiolib-of.c                       |   36 +++++++++++++----
 drivers/gpio/gpiolib.c                          |   47 +++++++++++++++++++++++
 drivers/pinctrl/core.c                          |   23 +++++++++++
 include/asm-generic/gpio.h                      |   10 +++++
 include/linux/gpio.h                            |    9 ++++
 include/linux/pinctrl/pinctrl.h                 |    3 +
 7 files changed, 160 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index d933af3..da0e7fb 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -112,3 +112,43 @@ where,
 Here, a single GPIO controller has GPIOs 0..9 routed to pin controller
 pinctrl1's pins 20..29, and GPIOs 10..19 routed to pin controller pinctrl2's
 pins 50..59.
+
+In addition, named groups of pins can be mapped to pin groups of a given
+pin controller using the gpio-ranges property as described below:
+
+	gpio-range-list ::= <single-gpio-range> [gpio-range-list]
+	single-gpio-range ::= <numeric-gpio-range> | <named-gpio-range>
+	numeric-gpio-range ::=
+			<pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
+	named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
+	pinctrl-phanle : phandle to pin controller node.
+	gpio-base : Base GPIO ID in the GPIO controller
+	pinctrl-base : Base pinctrl pin ID in the pin controller
+	count : The number of GPIOs/pins in this range
+
+In this case, the property gpio-ranges-group-names contains one string for
+every single-gpio-range in gpio-ranges:
+	gpiorange-names-list ::= <gpiorange-name> [gpiorange-names-list]
+	gpiorange-name : Name of the pingroup associated to the GPIO range in
+			the respective pin controller.
+
+Example:
+
+	gpio_pio_i: gpio-controller@14B0 {
+		#gpio-cells = <2>;
+		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
+		reg = <0x1480 0x18>;
+		gpio-controller;
+		gpio-ranges =			<&pinctrl1 0 20 10>,
+						<&pinctrl2 10 0 0>,
+						<&pinctrl1 15 0 10>,
+						<&pinctrl2 25 0 0>;
+		gpio-ranges-group-names =	"",
+						"foo",
+						"",
+						"bar";
+	};
+
+Here, three GPIO ranges are defined wrt. two pin controllers. pinctrl1 GPIO
+ranges are defined using pin numbers whereas the GPIO ranges wrt. pinctrl2
+are named "foo" and "bar".
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 665f953..07a7b81 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -189,6 +189,7 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	struct of_phandle_args pinspec;
 	struct pinctrl_dev *pctldev;
 	int index = 0, ret;
+	const char *name;
 
 	if (!np)
 		return;
@@ -203,14 +204,33 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 		if (!pctldev)
 			break;
 
-		ret = gpiochip_add_pin_range(chip,
-					     pinctrl_dev_get_devname(pctldev),
-					     pinspec.args[0],
-					     pinspec.args[1],
-					     pinspec.args[2]);
-
-		if (ret)
-			break;
+		if (pinspec.args[2]) {
+			/* npins != 0: linear range */
+			ret = gpiochip_add_pin_range(chip,
+					pinctrl_dev_get_devname(pctldev),
+					pinspec.args[0],
+					pinspec.args[1],
+					pinspec.args[2]);
+			if (ret)
+				break;
+		} else {
+			/* npins == 0: special range */
+			if (pinspec.args[1]) {
+				pr_err("%s: Illegal gpio-range format.\n",
+					np->full_name);
+				break;
+			}
+			ret = of_property_read_string_index(np,
+						"gpio-ranges-group-names",
+						index, &name);
+			if (ret)
+				break;
+
+			ret = gpiochip_add_pingroup_range(chip, pctldev,
+						pinspec.args[0], name);
+			if (ret)
+				break;
+		}
 	}
 }
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ff0fd65..c75002b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1320,6 +1320,53 @@ EXPORT_SYMBOL_GPL(gpiochip_find);
 #ifdef CONFIG_PINCTRL
 
 /**
+ * gpiochip_add_pingroup_range() - add a range for GPIO <-> pin mapping
+ * @chip: the gpiochip to add the range for
+ * @pinctrl: the dev_name() of the pin controller to map to
+ * @gpio_offset: the start offset in the current gpio_chip number space
+ * @pin_group: name of the pin group inside the pin controller
+ */
+int gpiochip_add_pingroup_range(struct gpio_chip *chip,
+			struct pinctrl_dev *pctldev,
+			unsigned int gpio_offset, const char *pin_group)
+{
+	struct gpio_pin_range *pin_range;
+	int ret;
+
+	pin_range = kzalloc(sizeof(*pin_range), GFP_KERNEL);
+	if (!pin_range) {
+		pr_err("%s: GPIO chip: failed to allocate pin ranges\n",
+				chip->label);
+		return -ENOMEM;
+	}
+
+	/* Use local offset as range ID */
+	pin_range->range.id = gpio_offset;
+	pin_range->range.gc = chip;
+	pin_range->range.name = chip->label;
+	pin_range->range.base = chip->base + gpio_offset;
+	pin_range->pctldev = pctldev;
+
+	ret = pinctrl_add_gpio_pingrp_range(pctldev, &pin_range->range,
+						pin_group);
+	if (ret < 0) {
+		pr_err("%s: GPIO chip: could not create pin range %s\n",
+		       chip->label, pin_group);
+		return ret;
+	}
+
+	pr_debug("GPIO chip %s: created GPIO range %d->%d ==> %s PINGRP %s\n",
+		 chip->label, gpio_offset,
+		 gpio_offset + pin_range->range.npins - 1,
+		 pinctrl_dev_get_devname(pctldev), pin_group);
+
+	list_add_tail(&pin_range->node, &chip->pin_ranges);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gpiochip_add_pingroup_range);
+
+/**
  * gpiochip_add_pin_range() - add a range for GPIO <-> pin mapping
  * @chip: the gpiochip to add the range for
  * @pinctrl_name: the dev_name() of the pin controller to map to
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2a00239..52e2e6f 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -456,6 +456,29 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 }
 EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
 
+int pinctrl_add_gpio_pingrp_range(struct pinctrl_dev *pctldev,
+				struct pinctrl_gpio_range *range,
+				char *pin_group)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	int group_selector, ret;
+
+	group_selector = pinctrl_get_group_selector(pctldev, pin_group);
+	if (group_selector < 0)
+		return group_selector;
+
+	ret = pctlops->get_group_pins(pctldev, group_selector,
+				&range->pins,
+				&range->npins);
+	if (ret < 0)
+		return ret;
+
+	pinctrl_add_gpio_range(pctldev, range);
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(pinctrl_add_gpio_pingrp_range);
+
 /**
  * pinctrl_find_gpio_range_from_pin() - locate the GPIO range for a pin
  * @pctldev: the pin controller device to look in
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index bde6469..523f405 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -228,6 +228,9 @@ struct gpio_pin_range {
 int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 			   unsigned int gpio_offset, unsigned int pin_offset,
 			   unsigned int npins);
+int gpiochip_add_pingroup_range(struct gpio_chip *chip,
+			struct pinctrl_dev *pctldev,
+			unsigned int gpio_offset, const char *pin_group);
 void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
 
 #else
@@ -239,6 +242,13 @@ gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 {
 	return 0;
 }
+static inline int
+gpiochip_add_pingroup_range(struct gpio_chip *chip,
+			struct pinctrl_dev *pctldev,
+			unsigned int gpio_offset, const char *pin_group)
+{
+	return 0;
+}
 
 static inline void
 gpiochip_remove_pin_ranges(struct gpio_chip *chip)
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 552e3f4..234b32f 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -220,6 +220,15 @@ gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 	return -EINVAL;
 }
 
+static inline int
+gpiochip_add_pingroup_range(struct gpio_chip *chip,
+			struct pinctrl_dev *pctldev,
+			unsigned int gpio_offset, const char *pin_group)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
 static inline void
 gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 {
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 5979147..47ab2fb 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -141,6 +141,9 @@ extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 
 extern struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 		struct pinctrl_gpio_range *range);
+extern int pinctrl_add_gpio_pingrp_range(struct pinctrl_dev *pctldev,
+					struct pinctrl_gpio_range *range,
+					char *pin_group);
 extern struct pinctrl_gpio_range *
 pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 				 unsigned int pin);
-- 
1.7.1

