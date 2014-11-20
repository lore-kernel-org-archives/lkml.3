Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaKTXy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:54:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35139 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbaKTXyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:54:55 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 1/2] gpio: add GPIO hogging mechanism
Date: Thu, 20 Nov 2014 17:54:43 -0600
Message-ID: <1416527684-19017-2-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1416527684-19017-1-git-send-email-bparrot@ti.com>
References: <1416527684-19017-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Boris Brezillion's work this is a reworked patch
of his initial GPIO hogging mechanism.
This patch provides a way to initally configure specific GPIO
when the gpio controller is probed.

The actual DT scanning to collect the GPIO specific data is performed
as part of the gpiochip_add().

The purpose of this is to allows specific GPIOs to be configured
without any driver specific code.
This particularly useful because board design are getting
increasingly complex and given SoC pins can now have upward
of 10 mux values a lot of connections are now dependent on
external IO muxes to switch various modes and combination.

Specific drivers should not necessarily need to be aware of
what accounts to a specific board implementation. This board level
"description" should be best kept as part of the dts file.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
Changes since v1:
 * Refactor the gpio-hog mechanism as private functions meant to
   be to invoked from of_gpiochip_add().

 drivers/gpio/gpiolib-of.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 604dbe6..3caed76 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -22,6 +22,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
+#include <linux/gpio/machine.h>
 
 #include "gpiolib.h"
 
@@ -111,6 +112,184 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
 EXPORT_SYMBOL(of_get_named_gpio_flags);
 
 /**
+ * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
+ * @np:		device node to get GPIO from
+ * @name:	GPIO line name
+ * @flags:	a flags pointer to fill in
+ *
+ * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
+ * value on the error condition.
+ */
+
+static struct gpio_desc *of_get_gpio_hog(struct device_node *np,
+				  const char **name,
+				  enum gpio_lookup_flags *lflags,
+				  enum gpiod_flags *dflags)
+{
+	struct device_node *chip_np;
+	enum of_gpio_flags xlate_flags;
+	struct gpio_desc *desc;
+	struct gg_data gg_data = {
+		.flags = &xlate_flags,
+		.out_gpio = NULL,
+	};
+	u32 tmp;
+	int i, in, outlo, outhi;
+	int ret;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	chip_np = np->parent;
+	if (!chip_np) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	if (!lflags || !dflags) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	*lflags = 0;
+	*dflags = 0;
+	in = 0;
+	outlo = 0;
+	outhi = 0;
+
+	ret = of_property_read_u32(chip_np, "#gpio-cells", &tmp);
+	if (ret) {
+		desc = ERR_PTR(ret);
+		goto out;
+	}
+
+	if (tmp > MAX_PHANDLE_ARGS) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	gg_data.gpiospec.args_count = tmp;
+	gg_data.gpiospec.np = chip_np;
+	for (i = 0; i < tmp; i++) {
+		ret = of_property_read_u32(np, "gpios",
+					   &gg_data.gpiospec.args[i]);
+		if (ret) {
+			desc = ERR_PTR(ret);
+			goto out;
+		}
+	}
+
+	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+	if (!gg_data.out_gpio) {
+		if (np->parent == np)
+			desc = ERR_PTR(-ENXIO);
+		else
+			desc = ERR_PTR(-EPROBE_DEFER);
+		goto out;
+	}
+
+	if (xlate_flags & OF_GPIO_ACTIVE_LOW)
+		*lflags |= GPIOF_ACTIVE_LOW;
+
+	if (of_property_read_bool(np, "input")) {
+		*dflags |= GPIOD_IN;
+		in = 1;
+	}
+	if (of_property_read_bool(np, "output-low")) {
+		*dflags |= GPIOD_OUT_LOW;
+		outlo = 1;
+	}
+	if (of_property_read_bool(np, "output-high")) {
+		*dflags |= GPIOD_OUT_HIGH;
+		outhi = 1;
+	}
+	if ((in + outlo + outhi) > 1) {
+		pr_warn("%s: GPIO %s: more than one direction/value selected, assuming: %s.\n",
+			 __func__, np->name,
+			 (outhi)?"output-high":(outlo)?"output-low":"input");
+	}
+
+	if (of_property_read_bool(np, "open-drain-line"))
+		*lflags |= GPIO_OPEN_DRAIN;
+	if (of_property_read_bool(np, "open-source-line"))
+		*lflags |= GPIO_OPEN_SOURCE;
+	if (name && of_property_read_string(np, "line-name", name))
+		*name = np->name;
+
+	desc = gg_data.out_gpio;
+
+out:
+	return desc;
+}
+
+
+/**
+ * do_gpio_hog - Given node is a GPIO hog configuration, handle it
+ * @np:		device node to get GPIO from
+ *
+ * This is only used by of_gpiochip_add to request/set GPIO initial
+ * configuration.
+ */
+static int do_gpio_hog(struct device_node *np)
+{
+	struct gpio_desc *desc = NULL;
+	int err;
+	const char *name;
+	enum gpio_lookup_flags lflags;
+	enum gpiod_flags dflags;
+
+	desc = of_get_gpio_hog(np, &name, &lflags, &dflags);
+	if (!desc)
+		return -ENOTSUPP;
+	else if (IS_ERR(desc))
+		return PTR_ERR(desc);
+
+	err = gpiod_request(desc, name);
+	if (err < 0)
+		return err;
+
+	if (lflags & GPIO_ACTIVE_LOW)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+	if (lflags & GPIO_OPEN_DRAIN)
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
+	if (lflags & GPIO_OPEN_SOURCE)
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
+
+	/* No particular flag request, not really hogging then... */
+	if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
+		pr_warn("%s: GPIO %s: no hogging direction specified, bailing out\n",
+			 __func__, name);
+		err = -EINVAL;
+		goto free_gpio;
+	}
+
+	/* Process flags */
+	if (dflags & GPIOD_FLAGS_BIT_DIR_OUT)
+		err = gpiod_direction_output(desc,
+					     dflags & GPIOD_FLAGS_BIT_DIR_VAL);
+	else
+		err = gpiod_direction_input(desc);
+
+	if (err < 0) {
+		pr_warn("%s: GPIO %s setting direction/value failed\n",
+			 __func__, name);
+		goto free_gpio;
+	}
+
+	pr_debug("%s: gpio-hog: GPIO:%d (%s) as %s%s\n", __func__,
+		desc_to_gpio(desc), name,
+		(dflags&GPIOD_FLAGS_BIT_DIR_OUT) ? "output" : "input",
+		(dflags&GPIOD_FLAGS_BIT_DIR_OUT) ?
+			(dflags&GPIOD_FLAGS_BIT_DIR_VAL) ? "/high" : "/low":"");
+
+	return 0;
+
+free_gpio:
+	gpiod_put(desc);
+	return err;
+}
+
+/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
@@ -289,6 +468,8 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip) {}
 
 void of_gpiochip_add(struct gpio_chip *chip)
 {
+	struct device_node *np;
+
 	if ((!chip->of_node) && (chip->dev))
 		chip->of_node = chip->dev->of_node;
 
@@ -302,6 +483,13 @@ void of_gpiochip_add(struct gpio_chip *chip)
 
 	of_gpiochip_add_pin_range(chip);
 	of_node_get(chip->of_node);
+
+	for_each_child_of_node(chip->dev->of_node, np) {
+		if (!of_property_read_bool(np, "gpio-hog"))
+			continue;
+		/* Hog this GPIO */
+		do_gpio_hog(np);
+	}
 }
 
 void of_gpiochip_remove(struct gpio_chip *chip)
-- 
1.8.5.1

