Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3FQQFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:05:17 -0400
Received: from mail.abilis.ch ([195.70.19.74]:17849 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3FQQFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:05:15 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 1/4] Make non-linear GPIO ranges accesible from gpiolib
Date: Mon, 17 Jun 2013 18:04:43 +0200
Message-Id: <1371485086-16016-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20130617160324.GA15853@ab42.lan>
References: <20130617160324.GA15853@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the infrastructure required to register non-linear gpio
ranges through gpiolib and the standard GPIO device tree bindings.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt |   44 ++++++++++++++++++
 arch/arc/boot/dts/abilis_tb100.dtsi             |   56 +++++++++++-----------
 arch/arc/boot/dts/abilis_tb101.dtsi             |   56 +++++++++++-----------
 arch/arc/boot/dts/abilis_tb10x.dtsi             |    3 +-
 drivers/gpio/gpiolib-of.c                       |   31 +++++++++---
 drivers/gpio/gpiolib.c                          |   47 +++++++++++++++++++
 drivers/pinctrl/core.c                          |   23 +++++++++
 include/asm-generic/gpio.h                      |   10 ++++
 include/linux/gpio.h                            |    9 ++++
 include/linux/pinctrl/pinctrl.h                 |    3 +
 10 files changed, 216 insertions(+), 66 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index d933af3..c8afbea 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -112,3 +112,47 @@ where,
 
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
+		gpio-ranges = <&pinctrl1 0 0 0>, <&pinctrl2 3 0 0>;
+		gpio-ranges-group-names = "foo", "bar";
+	};
+
+where,
+   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
+
+   The following value specifies the base GPIO offset of the pin range with
+   respect to the GPIO controller's base. The remaining two values must be
+   0 to indicate that a named pin group should be used for the respective
+   range. The number of pins in the range is the number of pins in the pin
+   group.
+
+   gpio-ranges-group-names defines the name of each pingroup of the
+   respective pin controller.
+
+The pinctrl node must have a "#gpio-#gpio-range-cells" property set to three
+to define the number of arguments to pass with the phandle.
+
+Both methods can be combined in the same GPIO controller, e.g.
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
diff --git a/arch/arc/boot/dts/abilis_tb100.dtsi b/arch/arc/boot/dts/abilis_tb100.dtsi
index 941ad11..1a42cf1 100644
--- a/arch/arc/boot/dts/abilis_tb100.dtsi
+++ b/arch/arc/boot/dts/abilis_tb100.dtsi
@@ -177,8 +177,8 @@
 			reg = <0xFF140000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <0>;
-			gpio-pins = <&pctl_gpio_a>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioa_pins";
 		};
 		gpiob: gpio@FF141000 {
 			compatible = "abilis,tb10x-gpio";
@@ -189,8 +189,8 @@
 			reg = <0xFF141000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <3>;
-			gpio-pins = <&pctl_gpio_b>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiob_pins";
 		};
 		gpioc: gpio@FF142000 {
 			compatible = "abilis,tb10x-gpio";
@@ -201,8 +201,8 @@
 			reg = <0xFF142000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <5>;
-			gpio-pins = <&pctl_gpio_c>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioc_pins";
 		};
 		gpiod: gpio@FF143000 {
 			compatible = "abilis,tb10x-gpio";
@@ -213,8 +213,8 @@
 			reg = <0xFF143000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <8>;
-			gpio-pins = <&pctl_gpio_d>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiod_pins";
 		};
 		gpioe: gpio@FF144000 {
 			compatible = "abilis,tb10x-gpio";
@@ -225,8 +225,8 @@
 			reg = <0xFF144000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <10>;
-			gpio-pins = <&pctl_gpio_e>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioe_pins";
 		};
 		gpiof: gpio@FF145000 {
 			compatible = "abilis,tb10x-gpio";
@@ -237,8 +237,8 @@
 			reg = <0xFF145000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <13>;
-			gpio-pins = <&pctl_gpio_f>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiof_pins";
 		};
 		gpiog: gpio@FF146000 {
 			compatible = "abilis,tb10x-gpio";
@@ -249,8 +249,8 @@
 			reg = <0xFF146000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <15>;
-			gpio-pins = <&pctl_gpio_g>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiog_pins";
 		};
 		gpioh: gpio@FF147000 {
 			compatible = "abilis,tb10x-gpio";
@@ -261,8 +261,8 @@
 			reg = <0xFF147000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <18>;
-			gpio-pins = <&pctl_gpio_h>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioh_pins";
 		};
 		gpioi: gpio@FF148000 {
 			compatible = "abilis,tb10x-gpio";
@@ -273,8 +273,8 @@
 			reg = <0xFF148000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <20>;
-			gpio-pins = <&pctl_gpio_i>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioi_pins";
 		};
 		gpioj: gpio@FF149000 {
 			compatible = "abilis,tb10x-gpio";
@@ -285,8 +285,8 @@
 			reg = <0xFF149000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <32>;
-			gpio-pins = <&pctl_gpio_j>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioj_pins";
 		};
 		gpiok: gpio@FF14a000 {
 			compatible = "abilis,tb10x-gpio";
@@ -297,8 +297,8 @@
 			reg = <0xFF14A000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <64>;
-			gpio-pins = <&pctl_gpio_k>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiok_pins";
 		};
 		gpiol: gpio@FF14b000 {
 			compatible = "abilis,tb10x-gpio";
@@ -309,8 +309,8 @@
 			reg = <0xFF14B000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <86>;
-			gpio-pins = <&pctl_gpio_l>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiol_pins";
 		};
 		gpiom: gpio@FF14c000 {
 			compatible = "abilis,tb10x-gpio";
@@ -321,8 +321,8 @@
 			reg = <0xFF14C000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <90>;
-			gpio-pins = <&pctl_gpio_m>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiom_pins";
 		};
 		gpion: gpio@FF14d000 {
 			compatible = "abilis,tb10x-gpio";
@@ -333,8 +333,8 @@
 			reg = <0xFF14D000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <94>;
-			gpio-pins = <&pctl_gpio_n>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpion_pins";
 		};
 	};
 };
diff --git a/arch/arc/boot/dts/abilis_tb101.dtsi b/arch/arc/boot/dts/abilis_tb101.dtsi
index fd25c21..08986cd 100644
--- a/arch/arc/boot/dts/abilis_tb101.dtsi
+++ b/arch/arc/boot/dts/abilis_tb101.dtsi
@@ -186,8 +186,8 @@
 			reg = <0xFF140000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <0>;
-			gpio-pins = <&pctl_gpio_a>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioa_pins";
 		};
 		gpiob: gpio@FF141000 {
 			compatible = "abilis,tb10x-gpio";
@@ -198,8 +198,8 @@
 			reg = <0xFF141000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <3>;
-			gpio-pins = <&pctl_gpio_b>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiob_pins";
 		};
 		gpioc: gpio@FF142000 {
 			compatible = "abilis,tb10x-gpio";
@@ -210,8 +210,8 @@
 			reg = <0xFF142000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <5>;
-			gpio-pins = <&pctl_gpio_c>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioc_pins";
 		};
 		gpiod: gpio@FF143000 {
 			compatible = "abilis,tb10x-gpio";
@@ -222,8 +222,8 @@
 			reg = <0xFF143000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <8>;
-			gpio-pins = <&pctl_gpio_d>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiod_pins";
 		};
 		gpioe: gpio@FF144000 {
 			compatible = "abilis,tb10x-gpio";
@@ -234,8 +234,8 @@
 			reg = <0xFF144000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <10>;
-			gpio-pins = <&pctl_gpio_e>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioe_pins";
 		};
 		gpiof: gpio@FF145000 {
 			compatible = "abilis,tb10x-gpio";
@@ -246,8 +246,8 @@
 			reg = <0xFF145000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <13>;
-			gpio-pins = <&pctl_gpio_f>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiof_pins";
 		};
 		gpiog: gpio@FF146000 {
 			compatible = "abilis,tb10x-gpio";
@@ -258,8 +258,8 @@
 			reg = <0xFF146000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <15>;
-			gpio-pins = <&pctl_gpio_g>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiog_pins";
 		};
 		gpioh: gpio@FF147000 {
 			compatible = "abilis,tb10x-gpio";
@@ -270,8 +270,8 @@
 			reg = <0xFF147000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <18>;
-			gpio-pins = <&pctl_gpio_h>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioh_pins";
 		};
 		gpioi: gpio@FF148000 {
 			compatible = "abilis,tb10x-gpio";
@@ -282,8 +282,8 @@
 			reg = <0xFF148000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <20>;
-			gpio-pins = <&pctl_gpio_i>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioi_pins";
 		};
 		gpioj: gpio@FF149000 {
 			compatible = "abilis,tb10x-gpio";
@@ -294,8 +294,8 @@
 			reg = <0xFF149000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <32>;
-			gpio-pins = <&pctl_gpio_j>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpioj_pins";
 		};
 		gpiok: gpio@FF14a000 {
 			compatible = "abilis,tb10x-gpio";
@@ -306,8 +306,8 @@
 			reg = <0xFF14A000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <64>;
-			gpio-pins = <&pctl_gpio_k>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiok_pins";
 		};
 		gpiol: gpio@FF14b000 {
 			compatible = "abilis,tb10x-gpio";
@@ -318,8 +318,8 @@
 			reg = <0xFF14B000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <86>;
-			gpio-pins = <&pctl_gpio_l>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiol_pins";
 		};
 		gpiom: gpio@FF14c000 {
 			compatible = "abilis,tb10x-gpio";
@@ -330,8 +330,8 @@
 			reg = <0xFF14C000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <90>;
-			gpio-pins = <&pctl_gpio_m>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpiom_pins";
 		};
 		gpion: gpio@FF14d000 {
 			compatible = "abilis,tb10x-gpio";
@@ -342,8 +342,8 @@
 			reg = <0xFF14D000 0x1000>;
 			gpio-controller;
 			#gpio-cells = <1>;
-			gpio-base  = <94>;
-			gpio-pins = <&pctl_gpio_n>;
+			gpio-ranges = <&iomux 0 0 0>;
+			gpio-ranges-group-names = "gpion_pins";
 		};
 	};
 };
diff --git a/arch/arc/boot/dts/abilis_tb10x.dtsi b/arch/arc/boot/dts/abilis_tb10x.dtsi
index b97e305..62bc952 100644
--- a/arch/arc/boot/dts/abilis_tb10x.dtsi
+++ b/arch/arc/boot/dts/abilis_tb10x.dtsi
@@ -66,9 +66,8 @@
 		};
 
 		iomux: iomux@FF10601c {
-			#address-cells = <1>;
-			#size-cells = <1>;
 			compatible = "abilis,tb10x-iomux";
+			#gpio-range-cells = <3>;
 			reg = <0xFF10601c 0x4>;
 		};
 
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 665f953..e29cc71 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -189,6 +189,7 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	struct of_phandle_args pinspec;
 	struct pinctrl_dev *pctldev;
 	int index = 0, ret;
+	const char *name;
 
 	if (!np)
 		return;
@@ -203,14 +204,28 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
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
+			/* npins == 0: pin group based range */
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

