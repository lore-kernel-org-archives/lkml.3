Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3FMM4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:56:14 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27218 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab3FMM4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:56:11 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
Date: Thu, 13 Jun 2013 14:55:32 +0200
Message-Id: <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the infrastructure required to register non-linear gpio
ranges through gpiolib and the standard GPIO device tree bindings.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt |   37 ++++++++++++++++++
 drivers/gpio/gpiolib-of.c                       |   18 +++++++++
 drivers/gpio/gpiolib.c                          |   47 +++++++++++++++++++++++
 drivers/pinctrl/core.c                          |   23 +++++++++++
 include/asm-generic/gpio.h                      |   10 +++++
 include/linux/gpio.h                            |    9 ++++
 include/linux/pinctrl/pinctrl.h                 |    3 +
 7 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index d933af3..ad1cef3 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -112,3 +112,40 @@ where,
 
 The pinctrl node must have "#gpio-range-cells" property to show number of
 arguments to pass with phandle from gpio controllers node.
+
+In addition, named groups of pins can be mapped to pin groups of a given
+pin controller:
+
+	gpio_pio_g: gpio-controller@1480 {
+		#gpio-cells = <2>;
+		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
+		reg = <0x1480 0x18>;
+		gpio-controller;
+		gpio-pingrps = <&pinctrl1 0>, <&pinctrl2 3>;
+		gpio-pingrp-names = "pctl1_gpio_g", "pctl2_gpio_g";
+	};
+
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
+The pinctrl node must have a "#gpio-pingrp-cells" property set to one to
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
+	};
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 665f953..5cd16a1 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -188,7 +188,9 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	struct device_node *np = chip->of_node;
 	struct of_phandle_args pinspec;
 	struct pinctrl_dev *pctldev;
+	struct property *prop;
 	int index = 0, ret;
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
index c2534d6..b2dc810 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1318,6 +1318,53 @@ EXPORT_SYMBOL_GPL(gpiochip_find);
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
index 25bb17e..3730c4f 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -452,6 +452,29 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
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
index 176a6c1..286c5e5 100644
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

