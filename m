Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab3JONiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:38:23 -0400
Received: from mail.abilis.ch ([195.70.19.74]:11419 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664Ab3JONiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:38:18 -0400
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
Subject: [PATCH V2] Make non-linear GPIO ranges accesible from gpiolib
Date: Tue, 15 Oct 2013 15:37:54 +0200
Message-Id: <1381844274-12486-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20131015133621.GA7461@ab42.lan>
References: <20131015133621.GA7461@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the infrastructure required to register non-linear gpio
ranges through gpiolib and the standard GPIO device tree bindings.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt |   40 ++++++++++++++-
 drivers/gpio/gpiolib-of.c                       |   63 ++++++++++++++++++++---
 drivers/gpio/gpiolib.c                          |   47 +++++++++++++++++
 drivers/pinctrl/core.c                          |   14 +++++
 include/asm-generic/gpio.h                      |   10 ++++
 include/linux/gpio.h                            |    9 +++
 include/linux/pinctrl/pinctrl.h                 |    3 +
 7 files changed, 176 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 6cec6ff..0c85bb6 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -87,8 +87,10 @@ controllers. The gpio-ranges property described below represents this, and
 contains information structures as follows:
 
 	gpio-range-list ::= <single-gpio-range> [gpio-range-list]
-	single-gpio-range ::=
+	single-gpio-range ::= <numeric-gpio-range> | <named-gpio-range>
+	numeric-gpio-range ::=
 			<pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
+	named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
 	gpio-phandle : phandle to pin controller node.
 	gpio-base : Base GPIO ID in the GPIO controller
 	pinctrl-base : Base pinctrl pin ID in the pin controller
@@ -97,6 +99,19 @@ contains information structures as follows:
 The "pin controller node" mentioned above must conform to the bindings
 described in ../pinctrl/pinctrl-bindings.txt.
 
+In case named gpio ranges are used (ranges with both <pinctrl-base> and
+<count> set to 0), the property gpio-ranges-group-names contains one string
+for every single-gpio-range in gpio-ranges:
+	gpiorange-names-list ::= <gpiorange-name> [gpiorange-names-list]
+	gpiorange-name : Name of the pingroup associated to the GPIO range in
+			the respective pin controller.
+
+Elements of gpiorange-names-list corresponding to numeric ranges contain
+the empty string. Elements of gpiorange-names-list corresponding to named
+ranges contain the name of a pin group defined in the respective pin
+controller. The number of pins/GPIOs in the range is the number of pins in
+that pin group.
+
 Previous versions of this binding required all pin controller nodes that
 were referenced by any gpio-ranges property to contain a property named
 #gpio-range-cells with value <3>. This requirement is now deprecated.
@@ -104,7 +119,7 @@ However, that property may still exist in older device trees for
 compatibility reasons, and would still be required even in new device
 trees that need to be compatible with older software.
 
-Example:
+Example 1:
 
 	qe_pio_e: gpio-controller@1460 {
 		#gpio-cells = <2>;
@@ -117,3 +132,24 @@ Example:
 Here, a single GPIO controller has GPIOs 0..9 routed to pin controller
 pinctrl1's pins 20..29, and GPIOs 10..19 routed to pin controller pinctrl2's
 pins 50..59.
+
+Example 2:
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
index 0dfaf20..e787609 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -190,10 +190,15 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	struct of_phandle_args pinspec;
 	struct pinctrl_dev *pctldev;
 	int index = 0, ret;
+	const char *name;
+	static const char group_names_propname[] = "gpio-ranges-group-names";
+	struct property *group_names;
 
 	if (!np)
 		return;
 
+	group_names = of_find_property(np, group_names_propname, NULL);
+
 	for (;; index++) {
 		ret = of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3,
 				index, &pinspec);
@@ -204,14 +209,56 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
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
+			if (group_names) {
+				ret = of_property_read_string_index(np,
+						group_names_propname,
+						index, &name);
+				if (strlen(name)) {
+					pr_err("%s: Group name of numeric GPIO ranges must be the empty string.\n",
+						np->full_name);
+					break;
+				}
+			}
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
+
+			if (!group_names) {
+				pr_err("%s: GPIO group range requested but no %s property.\n",
+					np->full_name, group_names_propname);
+				break;
+			}
+
+			ret = of_property_read_string_index(np,
+						group_names_propname,
+						index, &name);
+			if (ret)
+				break;
+
+			if (!strlen(name)) {
+				pr_err("%s: Group name of GPIO group range cannot be the empty string.\n",
+				np->full_name);
+				break;
+			}
+
+			ret = gpiochip_add_pingroup_range(chip, pctldev,
+						pinspec.args[0], name);
+			if (ret)
+				break;
+		}
 	}
 }
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 86ef346..b83b7e4 100644
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
+	ret = pinctrl_get_group_pins(pctldev, pin_group,
+					&pin_range->range.pins,
+					&pin_range->range.npins);
+	if (ret < 0)
+		return ret;
+
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
index 92f86ab..5ee61a4 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -462,6 +462,20 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 }
 EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
 
+int pinctrl_get_group_pins(struct pinctrl_dev *pctldev, const char *pin_group,
+				const unsigned **pins, unsigned *num_pins)
+{
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	int gs;
+
+	gs = pinctrl_get_group_selector(pctldev, pin_group);
+	if (gs < 0)
+		return gs;
+
+	return pctlops->get_group_pins(pctldev, gs, pins, num_pins);
+}
+EXPORT_SYMBOL_GPL(pinctrl_get_group_pins);
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
index 5979147..fefb886 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -144,6 +144,9 @@ extern struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 extern struct pinctrl_gpio_range *
 pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 				 unsigned int pin);
+extern int pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+				const char *pin_group, const unsigned **pins,
+				unsigned *num_pins);
 
 #ifdef CONFIG_OF
 extern struct pinctrl_dev *of_pinctrl_get(struct device_node *np);
-- 
1.7.1

