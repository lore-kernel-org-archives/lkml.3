Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbaJUUKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:10:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41077 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbaJUUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:10:18 -0400
From: Benoit Parrot <bparrot@ti.com>
To: <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [RFC Patch] gpio: add GPIO hogging mechanism
Date: Tue, 21 Oct 2014 15:09:58 -0500
Message-ID: <1413922198-29373-1-git-send-email-bparrot@ti.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Boris Brezillion work this is a reworked patch
of his initial GPIO hogging mechanism.
This patch provides a way to initally configure specific GPIO
when the gpio controller is probe.

The actual DT scanning to collect the GPIO specific data is performed
as part of the gpiochip_add().

The purpose of this is to allows specific GPIOs to be configured
without any driver specific code.
This particularly usueful because board design are getting
increassingly complex and given SoC pins can now have upward
of 10 mux values a lot of connections are now dependent on
external IO muxes to switch various modes and combination.

Specific drivers should not necessarily need to be aware of
what accounts to a specific board implementation. This board level
"description" should be best kept as part of the dts file.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt | 33 +++++++++
 drivers/gpio/gpiolib-of.c                       | 99 +++++++++++++++++++++++++
 drivers/gpio/gpiolib.c                          | 81 ++++++++++++++++++++
 include/linux/of_gpio.h                         | 11 +++
 4 files changed, 224 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 3fb8f53..a9700d8 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -103,6 +103,26 @@ Every GPIO controller node must contain both an empty "gpio-controller"
 property, and a #gpio-cells integer property, which indicates the number of
 cells in a gpio-specifier.
 
+It might contain GPIO hog definitions. GPIO hogging is a mechanism providing
+automatic GPIO request and configuration as part of the gpio-controller's
+driver probe function.
+
+Each GPIO hog definition is represented as a child node of the GPIO controller.
+Required properties:
+- gpios: store the gpio information (id, flags, ...). Shall contain the
+  number of cells specified in its parent node (GPIO controller node).
+- input: a property specifying to set the GPIO direction as input.
+- output-high: a property specifying to set the GPIO direction to output with
+  the value high.
+- output-low: a property specifying to set the GPIO direction to output with
+  the value low.
+
+Optional properties:
+- line-name: the GPIO label name. If not present the node name is used.
+
+A GPIO controller can request GPIO hogs using the "gpio-hogs" property, which
+encodes a list of requested GPIO hogs.
+
 Example of two SOC GPIO banks defined as gpio-controller nodes:
 
 	qe_pio_a: gpio-controller@1400 {
@@ -110,6 +130,19 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
 		reg = <0x1400 0x18>;
 		gpio-controller;
 		#gpio-cells = <2>;
+		gpio-hogs = <&line_b>;
+
+		/* line_a hog is defined but not enabled in this example*/
+		line_a: line_a {
+			gpios = <5 0>;
+			input;
+		};
+
+		line_b: line_b {
+			gpios = <6 0>;
+			output-low;
+			line-name = "foo-bar-gpio";
+		};
 	};
 
 	qe_pio_e: gpio-controller@1460 {
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 604dbe6..7308dfc 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -111,6 +111,105 @@ int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
 EXPORT_SYMBOL(of_get_named_gpio_flags);
 
 /**
+ * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
+ * @np:		device node to get GPIO from
+ * @index:	index of the GPIO
+ * @name:	GPIO line name
+ * @flags:	a flags pointer to fill in
+ *
+ * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
+ * value on the error condition.
+ */
+struct gpio_desc *of_get_gpio_hog(struct device_node *np, int index,
+				  const char **name, unsigned long *flags)
+{
+	struct device_node *cfg_np, *chip_np;
+	enum of_gpio_flags xlate_flags;
+	unsigned long req_flags = 0;
+	struct gpio_desc *desc;
+	struct gg_data gg_data = {
+		.flags = &xlate_flags,
+		.out_gpio = NULL,
+	};
+	u32 tmp;
+	int i;
+	int ret;
+
+	cfg_np = of_parse_phandle(np, "gpio-hogs", index);
+	if (!cfg_np)
+		return ERR_PTR(-EINVAL);
+
+	chip_np = cfg_np->parent;
+	if (!chip_np) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
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
+		ret = of_property_read_u32(cfg_np, "gpios",
+					   &gg_data.gpiospec.args[i]);
+		if (ret) {
+			desc = ERR_PTR(ret);
+			goto out;
+		}
+	}
+
+	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+	if (!gg_data.out_gpio) {
+		if (cfg_np->parent == np)
+			desc = ERR_PTR(-ENXIO);
+		else
+			desc = ERR_PTR(-EPROBE_DEFER);
+
+		goto out;
+	}
+
+	if (xlate_flags & OF_GPIO_ACTIVE_LOW)
+		req_flags |= GPIOF_ACTIVE_LOW;
+
+	if (of_property_read_bool(cfg_np, "input")) {
+		req_flags |= GPIOF_DIR_IN;
+	} else if (of_property_read_bool(cfg_np, "output-high")) {
+		req_flags |= GPIOF_INIT_HIGH;
+	} else if (!of_property_read_bool(cfg_np, "output-low")) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	if (of_property_read_bool(cfg_np, "open-drain-line"))
+		req_flags |= GPIOF_OPEN_DRAIN;
+
+	if (of_property_read_bool(cfg_np, "open-source-line"))
+		req_flags |= GPIOF_OPEN_DRAIN;
+
+	if (name && of_property_read_string(cfg_np, "line-name", name))
+		*name = cfg_np->name;
+
+	if (flags)
+		*flags = req_flags;
+
+	desc = gg_data.out_gpio;
+
+out:
+	of_node_put(cfg_np);
+
+	return desc;
+}
+
+/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e8e98ca..b6f5bdb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -55,6 +55,9 @@ static DEFINE_MUTEX(gpio_lookup_lock);
 static LIST_HEAD(gpio_lookup_list);
 LIST_HEAD(gpio_chips);
 
+struct gpio_desc *__must_check gpiod_get_hog_index(struct device *dev,
+						   unsigned int idx);
+
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
 	d->label = label;
@@ -226,6 +229,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 	int		base = chip->base;
+	struct gpio_desc	*desc;
+	int		i;
 
 	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
 			&& base >= 0) {
@@ -275,6 +280,16 @@ int gpiochip_add(struct gpio_chip *chip)
 	of_gpiochip_add(chip);
 	acpi_gpiochip_add(chip);
 
+	/*
+	 * Instantiate GPIO hogs
+	 * There shouldn't be mores hogs then gpio available on this chip
+	 */
+	for (i = 0; i < chip->ngpio; i++) {
+		desc = gpiod_get_hog_index(chip->dev, i);
+		if (IS_ERR(desc))
+			break;
+	}
+
 	if (status)
 		goto fail;
 
@@ -1742,6 +1757,72 @@ struct gpio_desc *__must_check __gpiod_get_index_optional(struct device *dev,
 EXPORT_SYMBOL_GPL(__gpiod_get_index_optional);
 
 /**
+ * gpiod_get_hog_index - obtain a GPIO from a multi-index GPIO hog
+ * @dev:	GPIO consumer
+ * @idx:	index of the GPIO to obtain
+ *
+ * This should only be used by the gpiochip_add to request/set GPIO initial
+ * configuration.
+ *
+ * Return a valid GPIO descriptor, or an IS_ERR() condition in case of error.
+ */
+struct gpio_desc *__must_check gpiod_get_hog_index(struct device *dev,
+						   unsigned int idx)
+{
+	struct gpio_desc *desc = NULL;
+	int err;
+	unsigned long flags;
+	const char *name;
+
+	/* Using device tree? */
+	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
+		desc = of_get_gpio_hog(dev->of_node, idx, &name, &flags);
+
+	if (!desc)
+		return ERR_PTR(-ENOTSUPP);
+	else if (IS_ERR(desc))
+		return desc;
+
+	dev_dbg(dev, "gpio-hog: GPIO:%d (%s) as %s%s\n",
+		desc_to_gpio(desc), name, (flags&GPIOF_DIR_IN)?"input":"output",
+		(flags&GPIOF_DIR_IN)?"":(flags&GPIOF_INIT_HIGH)?"/high":"/low");
+
+	err = gpiod_request(desc, name);
+	if (err)
+		return ERR_PTR(err);
+
+	if (flags & GPIOF_OPEN_DRAIN)
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
+
+	if (flags & GPIOF_OPEN_SOURCE)
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
+
+	if (flags & GPIOF_ACTIVE_LOW)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+
+	if (flags & GPIOF_DIR_IN)
+		err = gpiod_direction_input(desc);
+	else
+		err = gpiod_direction_output_raw(desc,
+				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
+
+	if (err)
+		goto free_gpio;
+
+	if (flags & GPIOF_EXPORT) {
+		err = gpiod_export(desc, flags & GPIOF_EXPORT_CHANGEABLE);
+		if (err)
+			goto free_gpio;
+	}
+
+	return desc;
+
+free_gpio:
+	gpiod_free(desc);
+	return ERR_PTR(err);
+}
+
+/**
  * gpiod_put - dispose of a GPIO descriptor
  * @desc:	GPIO descriptor to dispose of
  *
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 38fc050..52d154c 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -59,6 +59,9 @@ extern int of_gpio_simple_xlate(struct gpio_chip *gc,
 				const struct of_phandle_args *gpiospec,
 				u32 *flags);
 
+extern struct gpio_desc *of_get_gpio_hog(struct device_node *np, int index,
+					 const char **name,
+					 unsigned long *flags);
 #else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
@@ -78,6 +81,14 @@ static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
 static inline void of_gpiochip_add(struct gpio_chip *gc) { }
 static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 
+static inline struct gpio_desc *of_get_gpio_hog(struct device_node *np,
+						int index,
+						const char **name,
+						unsigned long *flags)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 #endif /* CONFIG_OF_GPIO */
 
 /**
-- 
1.8.5.1

