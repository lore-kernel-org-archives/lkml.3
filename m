Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaLDVCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:02:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45249 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaLDVCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:02:32 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v3 1/2] gpio: add GPIO hogging mechanism
Date: Thu, 4 Dec 2014 15:02:01 -0600
Message-ID: <1417726922-10376-2-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1417726922-10376-1-git-send-email-bparrot@ti.com>
References: <1417726922-10376-1-git-send-email-bparrot@ti.com>
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
Changes since v2:
 * Refactor the gpio-hog mechanism to split the DT related action
   from the actual "hogging" operation.
 * This allows non-DT providers to implement hogs as well.
 * Added FLAG_IS_HOGGED to mark hogged gpio and make gpiochip removal
   able to release hogged gpio.
 * Similarly to the hogging, the cleanup is performed as part of
   of_gpiochip_remove
 * Refactor the gpio-hog mechanism as private functions meant to
   be to invoked from of_gpiochip_add().

Changes since v1:
 * Refactor the gpio-hog mechanism as private functions meant to
   be to invoked from of_gpiochip_add().

 drivers/gpio/gpiolib-of.c     | 127 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        | 118 ++++++++++++++++++++++++++++++---------
 drivers/gpio/gpiolib.h        |   1 +
 include/linux/gpio/consumer.h |   9 +++
 4 files changed, 229 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 604dbe6..e13134d 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -22,6 +22,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
+#include <linux/gpio/machine.h>
 
 #include "gpiolib.h"
 
@@ -111,6 +112,128 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
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
+	const char *dir_val;
+	struct gg_data gg_data = {
+		.flags = &xlate_flags,
+		.out_gpio = NULL,
+	};
+	u32 tmp;
+	int i, ret;
+
+	chip_np = np->parent;
+	if (!chip_np)
+		return ERR_PTR(-EINVAL);
+
+	xlate_flags = 0;
+	*lflags = 0;
+	*dflags = 0;
+
+	ret = of_property_read_u32(chip_np, "#gpio-cells", &tmp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (tmp > MAX_PHANDLE_ARGS)
+		return ERR_PTR(-EINVAL);
+
+	gg_data.gpiospec.args_count = tmp;
+	gg_data.gpiospec.np = chip_np;
+	for (i = 0; i < tmp; i++) {
+		ret = of_property_read_u32_index(np, "gpios", i,
+					   &gg_data.gpiospec.args[i]);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+	if (!gg_data.out_gpio) {
+		if (np->parent == np)
+			return ERR_PTR(-ENXIO);
+		else
+			return ERR_PTR(-EPROBE_DEFER);
+	}
+
+	if (xlate_flags & OF_GPIO_ACTIVE_LOW)
+		*lflags |= GPIO_ACTIVE_LOW;
+
+	if (!of_property_read_string(np, "direction", &dir_val)) {
+		if (!strcmp(dir_val, "input"))
+			*dflags |= GPIOD_IN;
+		else if (!strcmp(dir_val, "output-low"))
+			*dflags |= GPIOD_OUT_LOW;
+		else if (!strcmp(dir_val, "output-high"))
+			*dflags |= GPIOD_OUT_HIGH;
+	}
+
+	if (name && of_property_read_string(np, "line-name", name))
+		*name = np->name;
+
+	desc = gg_data.out_gpio;
+
+	return desc;
+}
+
+/**
+ * _gpiochip_hog - Scan gpio-controller and apply GPIO hog as requested
+ * @chip:	gpio chip to act on
+ *
+ * This is only used by of_gpiochip_add to request/set GPIO initial
+ * configuration.
+ */
+static void _gpiochip_hog(struct gpio_chip *chip)
+{
+	struct gpio_desc *desc = NULL;
+	struct device_node *np;
+	const char *name;
+	enum gpio_lookup_flags lflags;
+	enum gpiod_flags dflags;
+
+	for_each_child_of_node(chip->dev->of_node, np) {
+		if (!of_property_read_bool(np, "gpio-hog"))
+			continue;
+
+		desc = of_get_gpio_hog(np, &name, &lflags, &dflags);
+		if (IS_ERR(desc))
+			continue;
+
+		__gpiod_hog(desc, name, lflags, dflags);
+	}
+}
+
+/**
+ * _gpiochip_unhog - Scan gpio-controller and apply GPIO hog as requested
+ * @chip:	gpio chip to act on
+ *
+ * This is only used by of_gpiochip_remove to free hogged gpios
+ *
+ */
+static void _gpiochip_unhog(struct gpio_chip *chip)
+{
+	int id;
+
+	for (id = 0; id < chip->ngpio; id++) {
+		if (test_bit(FLAG_IS_HOGGED, &chip->desc[id].flags))
+			gpiod_put(&chip->desc[id]);
+	}
+}
+
+/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
@@ -302,10 +425,14 @@ void of_gpiochip_add(struct gpio_chip *chip)
 
 	of_gpiochip_add_pin_range(chip);
 	of_node_get(chip->of_node);
+
+	_gpiochip_hog(chip);
 }
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
 	gpiochip_remove_pin_ranges(chip);
 	of_node_put(chip->of_node);
+
+	_gpiochip_unhog(chip);
 }
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e8e98ca..4ef6eb8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -849,6 +849,7 @@ static bool __gpiod_free(struct gpio_desc *desc)
 		clear_bit(FLAG_REQUESTED, &desc->flags);
 		clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
 		clear_bit(FLAG_OPEN_SOURCE, &desc->flags);
+		clear_bit(FLAG_IS_HOGGED, &desc->flags);
 		ret = true;
 	}
 
@@ -1631,6 +1632,58 @@ struct gpio_desc *__must_check __gpiod_get_optional(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(__gpiod_get_optional);
 
+
+/**
+ * __gpiod_get_helper - helper function to request and configure a given GPIO
+ * @desc:	gpio whose value will be assigned
+ * @con_id:	unction within the GPIO consumer
+ * @lflags:	gpio_lookup_flags - returned from of_find_gpio() or
+ *		of_get_gpio_hog()
+ * @dflags:	gpiod_flags - optional GPIO initialization flags
+ *
+ * Return 0 on success, -ENOENT if no GPIO has been assigned to the
+ * requested function and/or index, or another IS_ERR() code if an error
+ * occurred while trying to acquire the GPIO.
+ */
+static int __gpiod_get_helper(struct gpio_desc *desc, const char *con_id,
+		unsigned long lflags, enum gpiod_flags dflags)
+{
+	int status;
+
+	status = gpiod_request(desc, con_id);
+
+	if (status < 0)
+		return status;
+
+	if (lflags & GPIO_ACTIVE_LOW)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+	if (lflags & GPIO_OPEN_DRAIN)
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
+	if (lflags & GPIO_OPEN_SOURCE)
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
+
+	/* No particular flag request, return here... */
+	if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
+		pr_debug("no flags found for %s\n", con_id);
+		return 0;
+	}
+	/* Process flags */
+	if (dflags & GPIOD_FLAGS_BIT_DIR_OUT)
+		status = gpiod_direction_output(desc,
+					      dflags & GPIOD_FLAGS_BIT_DIR_VAL);
+	else
+		status = gpiod_direction_input(desc);
+
+	if (status < 0) {
+		pr_debug("setup of GPIO %s failed\n", con_id);
+		gpiod_put(desc);
+		return status;
+	}
+
+	return 0;
+}
+
+
 /**
  * gpiod_get_index - obtain a GPIO from a multi-index GPIO function
  * @dev:	GPIO consumer, can be NULL for system-global GPIOs
@@ -1679,35 +1732,10 @@ struct gpio_desc *__must_check __gpiod_get_index(struct device *dev,
 		return desc;
 	}
 
-	status = gpiod_request(desc, con_id);
-
+	status = __gpiod_get_helper(desc, con_id, lookupflags, flags);
 	if (status < 0)
 		return ERR_PTR(status);
 
-	if (lookupflags & GPIO_ACTIVE_LOW)
-		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
-	if (lookupflags & GPIO_OPEN_DRAIN)
-		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
-	if (lookupflags & GPIO_OPEN_SOURCE)
-		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
-
-	/* No particular flag request, return here... */
-	if (!(flags & GPIOD_FLAGS_BIT_DIR_SET))
-		return desc;
-
-	/* Process flags */
-	if (flags & GPIOD_FLAGS_BIT_DIR_OUT)
-		status = gpiod_direction_output(desc,
-					      flags & GPIOD_FLAGS_BIT_DIR_VAL);
-	else
-		status = gpiod_direction_input(desc);
-
-	if (status < 0) {
-		dev_dbg(dev, "setup of GPIO %s failed\n", con_id);
-		gpiod_put(desc);
-		return ERR_PTR(status);
-	}
-
 	return desc;
 }
 EXPORT_SYMBOL_GPL(__gpiod_get_index);
@@ -1742,6 +1770,44 @@ struct gpio_desc *__must_check __gpiod_get_index_optional(struct device *dev,
 EXPORT_SYMBOL_GPL(__gpiod_get_index_optional);
 
 /**
+ * __gpiod_hog - Hog the specified GPIO desc given the provided flags
+ * @desc:	gpio whose value will be assigned
+ * @name:	gpio line name
+ * @lflags:	gpio_lookup_flags - returned from of_find_gpio() or
+ *		of_get_gpio_hog()
+ * @dflags:	gpiod_flags - optional GPIO initialization flags
+ *
+ */
+int __gpiod_hog(struct gpio_desc *desc, const char *name,
+		unsigned long lflags, enum gpiod_flags dflags)
+{
+	int status;
+
+	/* No particular flag request, not really hogging then... */
+	if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
+		pr_warn("%s: GPIO:%d (%s): no hogging direction specified, bailing out\n",
+			 __func__, desc_to_gpio(desc), name);
+		return -EINVAL;
+	}
+
+	status = __gpiod_get_helper(desc, name, lflags, dflags);
+	if (status < 0)
+		return status;
+
+	/* Mark GPIO as hogged so it can be identified and removed later */
+	set_bit(FLAG_IS_HOGGED, &desc->flags);
+
+	pr_debug("%s: GPIO:%d (%s) as %s%s\n", __func__,
+		desc_to_gpio(desc), name,
+		(dflags&GPIOD_FLAGS_BIT_DIR_OUT) ? "output" : "input",
+		(dflags&GPIOD_FLAGS_BIT_DIR_OUT) ?
+			(dflags&GPIOD_FLAGS_BIT_DIR_VAL) ? "/high" : "/low":"");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__gpiod_hog);
+
+/**
  * gpiod_put - dispose of a GPIO descriptor
  * @desc:	GPIO descriptor to dispose of
  *
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 9db2b6a..e3c8a1f 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -76,6 +76,7 @@ struct gpio_desc {
 #define FLAG_OPEN_DRAIN	7	/* Gpio is open drain type */
 #define FLAG_OPEN_SOURCE 8	/* Gpio is open source type */
 #define FLAG_USED_AS_IRQ 9	/* GPIO is connected to an IRQ */
+#define FLAG_IS_HOGGED	10	/* GPIO is hogged */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 12f146f..626f93d 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -64,6 +64,8 @@ struct gpio_desc *__must_check __devm_gpiod_get_optional(struct device *dev,
 struct gpio_desc *__must_check
 __devm_gpiod_get_index_optional(struct device *dev, const char *con_id,
 			      unsigned int index, enum gpiod_flags flags);
+int __gpiod_hog(struct gpio_desc *desc, const char *name,
+		unsigned long lflags, enum gpiod_flags dflags);
 void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
 
 int gpiod_get_direction(const struct gpio_desc *desc);
@@ -125,6 +127,13 @@ __gpiod_get_index_optional(struct device *dev, const char *con_id,
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline int __gpiod_hog(struct gpio_desc *desc, const char *name,
+				unsigned long lflags,
+				enum gpiod_flags dflags);
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void gpiod_put(struct gpio_desc *desc)
 {
 	might_sleep();
-- 
1.8.5.1

