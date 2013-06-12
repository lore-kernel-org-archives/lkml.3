Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3FLQot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:44:49 -0400
Received: from mail.abilis.ch ([195.70.19.74]:23631 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab3FLQor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:44:47 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>
Subject: [RFC] Allow GPIO ranges based on pinctl pin groups
Date: Wed, 12 Jun 2013 18:44:09 +0200
Message-Id: <1371055449-15828-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20130522094958.GA4789@ab42.lan>
References: <20130522094958.GA4789@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus and Stephen,

I have tried to satisfy your request to make this as generic to the
GPIO/pinctrl frameworks as possible. The patch cleanly applies to
Linux-3.10rc5 and compiles. I satisfies several of the requests in reply
to the original post, e.g. no more driver cross-calling, directly use
gpio ranges in device tree etc. I haven't sent the new drivers based on
this modifications since many of the other comments aren't cleaned up
yet but they will follow with a cleaned up version of this RFC as soon
as we agree on the principle.

This patch allows the definition of GPIO ranges based on pin groups in
addition to the traditional linear pin ranges. GPIO ranges based on pin
groups have the following advantages over traditional pin ranges:
. Previously, pins associated to a given functionality were defined
  inside the pin controller (e.g. a pin controller can define a group
  spi0_pins defining which pins are used by SPI port 0). This mechanism
  did not apply to GPIO controllers, however, which had to define GPIO
  ranges based on pin numbers otherwise confined to the pin controller.
  With the possibility to use pin groups for pin ranges, the pins
  associated to any functionality, including GPIO, can now be entirely
  defined inside the pin controller. Everything that needs to be known
  to the outside world is the name of the pin group.
. Non-consecutive pin ranges and arbitrary pin ordering is now possible
  in GPIO ranges.
. Linux internal pin numbers now no longer leak out of the kernel, e.g.
  to device tree. If the pinctrl driver author chooses to, GPIO range
  management can now entirely be based on symbolic names of pin groups.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt |   36 ++++++++++++
 drivers/gpio/gpiolib-of.c                       |   20 +++++++-
 drivers/gpio/gpiolib.c                          |   48 ++++++++++++++++
 drivers/pinctrl/core.c                          |   67 +++++++++++++++++++----
 include/asm-generic/gpio.h                      |   10 ++++
 include/linux/gpio.h                            |    9 +++
 include/linux/pinctrl/pinctrl.h                 |    9 +++-
 7 files changed, 187 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index d933af3..f8237c0 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -112,3 +112,39 @@ where,
 
 The pinctrl node must have "#gpio-range-cells" property to show number of
 arguments to pass with phandle from gpio controllers node.
+
+In addition, gpio ranges can be mapped to pin groups of a given pin
+controller (see Documentation/pinctrl.txt):
+
+	gpio_pio_g: gpio-controller@1480 {
+		#gpio-cells = <2>;
+		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
+		reg = <0x1480 0x18>;
+		gpio-controller;
+		gpio-pingrps = <&pinctrl1 0>, <&pinctrl2 3>;
+		gpio-pingrp-names = "pctl1_gpio_g", "pctl2_gpio_g";
+	}
+where,
+   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
+
+   Next values specify the base GPIO offset of the pin range with respect to
+   the GPIO controller's base. The number of pins in the range is the number
+   of pins in the pin group.
+
+   gpio-pingrp-names defines the name of each pingroup of the respective pin
+   controller.
+
+The pinctrl node msut have a "#gpio-pingrp-cells" property set to one to
+define the number of arguments to pass with the phandle.
+
+Both methods can be combined in the same GPIO controller, e.g.
+
+	gpio_pio_i: gpio-controller@14B0 {
+		#gpio-cells = <2>;
+		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
+		reg = <0x1480 0x18>;
+		gpio-controller;
+		gpio-ranges = <&pinctrl1 0 20 10>;
+		gpio-pingrps = <&pinctrl2 10>;
+		gpio-pingrp-names = "gpio_g_pins";
+	}
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 665f953..337dfc7 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -188,7 +188,9 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	struct device_node *np = chip->of_node;
 	struct of_phandle_args pinspec;
 	struct pinctrl_dev *pctldev;
-	int index = 0, ret;
+	struct property *prop;
+	int index = 0, ret, namecnt;
+	const char *name;
 
 	if (!np)
 		return;
@@ -212,6 +214,22 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 		if (ret)
 			break;
 	}
+
+	index = 0;
+	of_property_for_each_string(np, "gpio-pingrp-names", prop, name) {
+		ret = of_parse_phandle_with_args(np, "gpio-pingrps",
+							"#gpio-pingrp-cells",
+							index, &pinspec);
+		if (ret < 0)
+			break;
+
+		index ++;
+
+		pctldev = of_pinctrl_get(pinspec.np);
+
+		gpiochip_add_pingroup_range(chip, pctldev,
+					pinspec.args[0], name);
+	}
 }
 
 #else
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c2534d6..bc899f0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1318,6 +1318,54 @@ EXPORT_SYMBOL_GPL(gpiochip_find);
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
+	pin_range->range.pin_base = 0;
+	ret = pinctrl_get_group_pins(pctldev, pin_group,
+					&pin_range->range.pins,
+					&pin_range->range.npins);
+	if (ret < 0) {
+		pr_err("%s: GPIO chip: could not create pin range %s\n",
+		       chip->label, pin_group);
+	}
+	pin_range->pctldev = pctldev;
+	pinctrl_add_gpio_range(pctldev, &pin_range->range);
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
index 5327f35..cdb070c 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -279,6 +279,15 @@ static int pinctrl_register_pins(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+static inline int gpio2pin(struct pinctrl_gpio_range *range, unsigned int gpio)
+{
+	unsigned int offset = gpio - range->base;
+	if (range->pins)
+		return range->pins[offset];
+	else
+		return range->pin_base + offset;
+}
+
 /**
  * pinctrl_match_gpio_range() - check if a certain GPIO pin is in range
  * @pctldev: pin controller device to check
@@ -444,8 +453,14 @@ pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 	/* Loop over the ranges */
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 		/* Check if we're in the valid range */
-		if (pin >= range->pin_base &&
-		    pin < range->pin_base + range->npins) {
+		if (range->pins) {
+			int a;
+			for (a = 0; a < range->npins; a++) {
+				if (range->pins[a] == pin)
+					return range;
+			}
+		} else if (pin >= range->pin_base &&
+			   pin < range->pin_base + range->npins) {
 			mutex_unlock(&pctldev->mutex);
 			return range;
 		}
@@ -503,6 +518,28 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 }
 
 /**
+ * pinctrl_get_group_pins() - returns a pin group
+ * @pctldev: the pin controller handling the group
+ * @pin_group: the pin group to look up
+ * @pins: returns a pointer to an array of pin numbers in the group
+ * @npins: returns the number of pins in the group
+ */
+int pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+			const char *pin_group,
+			unsigned const **pins, unsigned * const npins)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	unsigned group_selector;
+
+	group_selector = pinctrl_get_group_selector(pctldev, pin_group);
+	if (group_selector < 0)
+		return group_selector;
+
+	return pctlops->get_group_pins(pctldev, group_selector, pins, npins);
+}
+EXPORT_SYMBOL_GPL(pinctrl_get_group_pins);
+
+/**
  * pinctrl_request_gpio() - request a single pin to be used in as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
  *
@@ -528,7 +565,7 @@ int pinctrl_request_gpio(unsigned gpio)
 	}
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base + range->pin_base;
+	pin = gpio2pin(range, gpio);
 
 	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
 
@@ -562,7 +599,7 @@ void pinctrl_free_gpio(unsigned gpio)
 	mutex_lock(&pctldev->mutex);
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base + range->pin_base;
+	pin = gpio2pin(range, gpio);
 
 	pinmux_free_gpio(pctldev, pin, range);
 
@@ -589,7 +626,7 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 	mutex_lock(&pctldev->mutex);
 
 	/* Convert to the pin controllers number space */
-	pin = gpio - range->base + range->pin_base;
+	pin = gpio2pin(range, gpio);
 	ret = pinmux_gpio_direction(pctldev, range, pin, input);
 
 	mutex_unlock(&pctldev->mutex);
@@ -1296,11 +1333,21 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 
 	/* Loop over the ranges */
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
-		seq_printf(s, "%u: %s GPIOS [%u - %u] PINS [%u - %u]\n",
-			   range->id, range->name,
-			   range->base, (range->base + range->npins - 1),
-			   range->pin_base,
-			   (range->pin_base + range->npins - 1));
+		if (range->pins) {
+			int a;
+			seq_printf(s, "%u: %s GPIOS [%u - %u] PINS {",
+				range->id, range->name,
+				range->base, (range->base + range->npins - 1));
+			for (a = 0; a < range->npins - 1; a++)
+				seq_printf(s, "%u, ", range->pins[a]);
+			seq_printf(s, "%u}\n", range->pins[a]);
+		}
+		else
+			seq_printf(s, "%u: %s GPIOS [%u - %u] PINS [%u - %u]\n",
+				range->id, range->name,
+				range->base, (range->base + range->npins - 1),
+				range->pin_base,
+				(range->pin_base + range->npins - 1));
 	}
 
 	mutex_unlock(&pctldev->mutex);
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
index 2c2a9e8..e3ba2bb 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -49,7 +49,8 @@ struct pinctrl_pin_desc {
  * @name: a name for the chip in this range
  * @id: an ID number for the chip in this range
  * @base: base offset of the GPIO range
- * @pin_base: base pin number of the GPIO range
+ * @pin_base: base pin number of the GPIO range if pins != NULL
+ * @pins: enumeration of pins in GPIO range or NULL
  * @npins: number of pins in the GPIO range, including the base number
  * @gc: an optional pointer to a gpio_chip
  */
@@ -59,6 +60,7 @@ struct pinctrl_gpio_range {
 	unsigned int id;
 	unsigned int base;
 	unsigned int pin_base;
+	unsigned const *pins;
 	unsigned int npins;
 	struct gpio_chip *gc;
 };
@@ -142,6 +144,11 @@ extern struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 extern struct pinctrl_gpio_range *
 pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 				 unsigned int pin);
+extern int pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+				const char *pin_group,
+				unsigned const **pins,
+				unsigned * const npins);
+
 
 #ifdef CONFIG_OF
 extern struct pinctrl_dev *of_pinctrl_get(struct device_node *np);
-- 
1.7.1

