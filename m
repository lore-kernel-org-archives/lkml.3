Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3JQRXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:23:47 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7839 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab3JQRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:23:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 10:19:14 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>, <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 1/3] gpiolib: export descriptor-based GPIO interface
Date: Thu, 17 Oct 2013 10:21:36 -0700
Message-ID: <1382030498-23465-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
References: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the gpiod_* family of API functions, a safer
alternative to the legacy GPIO interface. Differences between the gpiod
and legacy gpio APIs are:

- gpio works with integers, whereas gpiod operates on opaque handlers
  which cannot be forged or used before proper acquisition
- gpiod get/set functions are aware of the active low state of a GPIO
- gpio consumers should now include <linux/gpio/consumer.h> to access
  the new interface, whereas chips drivers will use
  <linux/gpio/driver.h>

The legacy gpio API is now built as inline functions on top of gpiod.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c        | 422 ++++++++++++++++++++++--------------------
 include/asm-generic/gpio.h    | 222 +++++++---------------
 include/linux/gpio.h          |  11 +-
 include/linux/gpio/consumer.h | 238 ++++++++++++++++++++++++
 include/linux/gpio/driver.h   | 127 +++++++++++++
 5 files changed, 658 insertions(+), 362 deletions(-)
 create mode 100644 include/linux/gpio/consumer.h
 create mode 100644 include/linux/gpio/driver.h

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d66139d..224abdc 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -16,16 +16,11 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/gpio.h>
 
-/* Optional implementation infrastructure for GPIO interfaces.
+/* Implementation infrastructure for GPIO interfaces.
  *
- * Platforms may want to use this if they tend to use very many GPIOs
- * that aren't part of a System-On-Chip core; or across I2C/SPI/etc.
- *
- * When kernel footprint or instruction count is an issue, simpler
- * implementations may be preferred.  The GPIO programming interface
- * allows for inlining speed-critical get/set operations for common
- * cases, so that access to SOC-integrated GPIOs can sometimes cost
- * only an instruction or two per bit.
+ * The GPIO programming interface allows for inlining speed-critical
+ * get/set operations for common cases, so that access to SOC-integrated
+ * GPIOs can sometimes cost only an instruction or two per bit.
  */
 
 
@@ -57,7 +52,7 @@ struct gpio_desc {
 #define FLAG_SYSFS	3	/* exported via /sys/class/gpio/control */
 #define FLAG_TRIG_FALL	4	/* trigger on falling edge */
 #define FLAG_TRIG_RISE	5	/* trigger on rising edge */
-#define FLAG_ACTIVE_LOW	6	/* sysfs value has active low */
+#define FLAG_ACTIVE_LOW	6	/* value has active low */
 #define FLAG_OPEN_DRAIN	7	/* Gpio is open drain type */
 #define FLAG_OPEN_SOURCE 8	/* Gpio is open source type */
 #define FLAG_USED_AS_IRQ 9	/* GPIO is connected to an IRQ */
@@ -81,29 +76,8 @@ static LIST_HEAD(gpio_chips);
 static DEFINE_IDR(dirent_idr);
 #endif
 
-/*
- * Internal gpiod_* API using descriptors instead of the integer namespace.
- * Most of this should eventually go public.
- */
 static int gpiod_request(struct gpio_desc *desc, const char *label);
 static void gpiod_free(struct gpio_desc *desc);
-static int gpiod_direction_input(struct gpio_desc *desc);
-static int gpiod_direction_output(struct gpio_desc *desc, int value);
-static int gpiod_get_direction(const struct gpio_desc *desc);
-static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
-static int gpiod_get_value_cansleep(const struct gpio_desc *desc);
-static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
-static int gpiod_get_value(const struct gpio_desc *desc);
-static void gpiod_set_value(struct gpio_desc *desc, int value);
-static int gpiod_cansleep(const struct gpio_desc *desc);
-static int gpiod_to_irq(const struct gpio_desc *desc);
-static int gpiod_lock_as_irq(struct gpio_desc *desc);
-static void gpiod_unlock_as_irq(struct gpio_desc *desc);
-static int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
-static int gpiod_export_link(struct device *dev, const char *name,
-			     struct gpio_desc *desc);
-static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
-static void gpiod_unexport(struct gpio_desc *desc);
 
 #ifdef CONFIG_DEBUG_FS
 #define gpiod_emerg(desc, fmt, ...)			                \
@@ -157,13 +131,14 @@ static int gpio_chip_hwgpio(const struct gpio_desc *desc)
 /**
  * Convert a GPIO number to its descriptor
  */
-static struct gpio_desc *gpio_to_desc(unsigned gpio)
+struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
 	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
 		return NULL;
 	else
 		return &gpio_desc[gpio];
 }
+EXPORT_SYMBOL_GPL(gpio_to_desc);
 
 /**
  * Convert an offset on a certain chip to a corresponding descriptor
@@ -181,10 +156,11 @@ static struct gpio_desc *gpiochip_offset_to_desc(struct gpio_chip *chip,
  * This should disappear in the future but is needed since we still
  * use GPIO numbers for error messages and sysfs nodes
  */
-static int desc_to_gpio(const struct gpio_desc *desc)
+int desc_to_gpio(const struct gpio_desc *desc)
 {
 	return desc - &gpio_desc[0];
 }
+EXPORT_SYMBOL_GPL(desc_to_gpio);
 
 
 /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
@@ -219,16 +195,15 @@ static int gpio_ensure_requested(struct gpio_desc *desc)
 	return 0;
 }
 
-static struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
+/**
+ * gpiod_to_chip - Return the GPIO chip to which a GPIO descriptor belongs
+ * @desc:	descriptor to return the chip of
+ */
+struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
 {
 	return desc ? desc->chip : NULL;
 }
-
-/* caller holds gpio_lock *OR* gpio is marked as requested */
-struct gpio_chip *gpio_to_chip(unsigned gpio)
-{
-	return gpiod_to_chip(gpio_to_desc(gpio));
-}
+EXPORT_SYMBOL_GPL(gpiod_to_chip);
 
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
 static int gpiochip_find_base(int ngpio)
@@ -254,8 +229,15 @@ static int gpiochip_find_base(int ngpio)
 	}
 }
 
-/* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
-static int gpiod_get_direction(const struct gpio_desc *desc)
+/**
+ * gpiod_get_direction - return the current direction of a GPIO
+ * @desc:	GPIO to get the direction of
+ *
+ * Return GPIOF_DIR_IN or GPIOF_DIR_OUT, or an error code in case of error.
+ *
+ * This function may sleep if gpiod_cansleep() is true.
+ */
+int gpiod_get_direction(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	unsigned		offset;
@@ -281,6 +263,7 @@ static int gpiod_get_direction(const struct gpio_desc *desc)
 	}
 	return status;
 }
+EXPORT_SYMBOL_GPL(gpiod_get_direction);
 
 #ifdef CONFIG_GPIO_SYSFS
 
@@ -365,17 +348,10 @@ static ssize_t gpio_value_show(struct device *dev,
 
 	mutex_lock(&sysfs_lock);
 
-	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
-	} else {
-		int value;
-
-		value = !!gpiod_get_value_cansleep(desc);
-		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
-			value = !value;
-
-		status = sprintf(buf, "%d\n", value);
-	}
+	else
+		status = sprintf(buf, "%d\n", gpiod_get_value_cansleep(desc));
 
 	mutex_unlock(&sysfs_lock);
 	return status;
@@ -398,9 +374,7 @@ static ssize_t gpio_value_store(struct device *dev,
 
 		status = kstrtol(buf, 0, &value);
 		if (status == 0) {
-			if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
-				value = !value;
-			gpiod_set_value_cansleep(desc, value != 0);
+			gpiod_set_value_cansleep(desc, value);
 			status = size;
 		}
 	}
@@ -790,7 +764,7 @@ static struct class gpio_class = {
 
 
 /**
- * gpio_export - export a GPIO through sysfs
+ * gpiod_export - export a GPIO through sysfs
  * @gpio: gpio to make available, already requested
  * @direction_may_change: true if userspace may change gpio direction
  * Context: arch_initcall or later
@@ -804,7 +778,7 @@ static struct class gpio_class = {
  *
  * Returns zero on success, else an error.
  */
-static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
+int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 {
 	unsigned long		flags;
 	int			status;
@@ -882,12 +856,7 @@ fail_unlock:
 		 status);
 	return status;
 }
-
-int gpio_export(unsigned gpio, bool direction_may_change)
-{
-	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
-}
-EXPORT_SYMBOL_GPL(gpio_export);
+EXPORT_SYMBOL_GPL(gpiod_export);
 
 static int match_export(struct device *dev, const void *data)
 {
@@ -895,7 +864,7 @@ static int match_export(struct device *dev, const void *data)
 }
 
 /**
- * gpio_export_link - create a sysfs link to an exported GPIO node
+ * gpiod_export_link - create a sysfs link to an exported GPIO node
  * @dev: device under which to create symlink
  * @name: name of the symlink
  * @gpio: gpio to create symlink to, already exported
@@ -905,8 +874,8 @@ static int match_export(struct device *dev, const void *data)
  *
  * Returns zero on success, else an error.
  */
-static int gpiod_export_link(struct device *dev, const char *name,
-			     struct gpio_desc *desc)
+int gpiod_export_link(struct device *dev, const char *name,
+		      struct gpio_desc *desc)
 {
 	int			status = -EINVAL;
 
@@ -937,15 +906,10 @@ static int gpiod_export_link(struct device *dev, const char *name,
 
 	return status;
 }
-
-int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
-{
-	return gpiod_export_link(dev, name, gpio_to_desc(gpio));
-}
-EXPORT_SYMBOL_GPL(gpio_export_link);
+EXPORT_SYMBOL_GPL(gpiod_export_link);
 
 /**
- * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
+ * gpiod_sysfs_set_active_low - set the polarity of gpio sysfs value
  * @gpio: gpio to change
  * @value: non-zero to use active low, i.e. inverted values
  *
@@ -956,7 +920,7 @@ EXPORT_SYMBOL_GPL(gpio_export_link);
  *
  * Returns zero on success, else an error.
  */
-static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
+int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
 {
 	struct device		*dev = NULL;
 	int			status = -EINVAL;
@@ -987,20 +951,15 @@ unlock:
 
 	return status;
 }
-
-int gpio_sysfs_set_active_low(unsigned gpio, int value)
-{
-	return gpiod_sysfs_set_active_low(gpio_to_desc(gpio), value);
-}
-EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
+EXPORT_SYMBOL_GPL(gpiod_sysfs_set_active_low);
 
 /**
- * gpio_unexport - reverse effect of gpio_export()
+ * gpiod_unexport - reverse effect of gpio_export()
  * @gpio: gpio to make unavailable
  *
  * This is implicit on gpio_free().
  */
-static void gpiod_unexport(struct gpio_desc *desc)
+void gpiod_unexport(struct gpio_desc *desc)
 {
 	int			status = 0;
 	struct device		*dev = NULL;
@@ -1033,12 +992,7 @@ static void gpiod_unexport(struct gpio_desc *desc)
 		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
 			 status);
 }
-
-void gpio_unexport(unsigned gpio)
-{
-	gpiod_unexport(gpio_to_desc(gpio));
-}
-EXPORT_SYMBOL_GPL(gpio_unexport);
+EXPORT_SYMBOL_GPL(gpiod_unexport);
 
 static int gpiochip_export(struct gpio_chip *chip)
 {
@@ -1145,27 +1099,6 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 {
 }
 
-static inline int gpiod_export(struct gpio_desc *desc,
-			       bool direction_may_change)
-{
-	return -ENOSYS;
-}
-
-static inline int gpiod_export_link(struct device *dev, const char *name,
-				    struct gpio_desc *desc)
-{
-	return -ENOSYS;
-}
-
-static inline int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
-{
-	return -ENOSYS;
-}
-
-static inline void gpiod_unexport(struct gpio_desc *desc)
-{
-}
-
 #endif /* CONFIG_GPIO_SYSFS */
 
 /*
@@ -1677,7 +1610,16 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
  * rely on gpio_request() having been called beforehand.
  */
 
-static int gpiod_direction_input(struct gpio_desc *desc)
+/**
+ * gpiod_direction_input - set the GPIO direction to input
+ * @desc:	GPIO to set to input
+ *
+ * Set the direction of the passed GPIO to input, such as gpiod_get_value() can
+ * be called safely on it.
+ *
+ * Return 0 in case of success, else an error code.
+ */
+int gpiod_direction_input(struct gpio_desc *desc)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
@@ -1734,14 +1676,19 @@ fail:
 		gpiod_dbg(desc, "%s status %d\n", __func__, status);
 	return status;
 }
+EXPORT_SYMBOL_GPL(gpiod_direction_input);
 
-int gpio_direction_input(unsigned gpio)
-{
-	return gpiod_direction_input(gpio_to_desc(gpio));
-}
-EXPORT_SYMBOL_GPL(gpio_direction_input);
-
-static int gpiod_direction_output(struct gpio_desc *desc, int value)
+/**
+ * gpiod_direction_output - set the GPIO direction to input
+ * @desc:	GPIO to set to output
+ * @value:	initial output value of the GPIO
+ *
+ * Set the direction of the passed GPIO to output, such as gpiod_set_value() can
+ * be called safely on it. The initial value of the output must be specified.
+ *
+ * Return 0 in case of success, else an error code.
+ */
+int gpiod_direction_output(struct gpio_desc *desc, int value)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
@@ -1814,22 +1761,17 @@ fail:
 		gpiod_dbg(desc, "%s: gpio status %d\n", __func__, status);
 	return status;
 }
-
-int gpio_direction_output(unsigned gpio, int value)
-{
-	return gpiod_direction_output(gpio_to_desc(gpio), value);
-}
-EXPORT_SYMBOL_GPL(gpio_direction_output);
+EXPORT_SYMBOL_GPL(gpiod_direction_output);
 
 /**
- * gpio_set_debounce - sets @debounce time for a @gpio
+ * gpiod_set_debounce - sets @debounce time for a @gpio
  * @gpio: the gpio to set debounce time
  * @debounce: debounce time is microseconds
  *
  * returns -ENOTSUPP if the controller does not support setting
  * debounce.
  */
-static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
+int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
@@ -1871,12 +1813,19 @@ fail:
 
 	return status;
 }
+EXPORT_SYMBOL_GPL(gpiod_set_debounce);
 
-int gpio_set_debounce(unsigned gpio, unsigned debounce)
+/**
+ * gpiod_is_active_low - test whether a GPIO is active-low or not
+ * @desc: the gpio descriptor to test
+ *
+ * Returns 1 if the GPIO is active-low, 0 otherwise.
+ */
+int gpiod_is_active_low(const struct gpio_desc *desc)
 {
-	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
+	return test_bit(FLAG_ACTIVE_LOW, &desc->flags);
 }
-EXPORT_SYMBOL_GPL(gpio_set_debounce);
+EXPORT_SYMBOL_GPL(gpiod_is_active_low);
 
 /* I/O calls are only valid after configuration completed; the relevant
  * "is this a valid GPIO" error checks should already have been done.
@@ -1900,7 +1849,7 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
  * that the GPIO was actually requested.
  */
 
-static int _gpiod_get_value(const struct gpio_desc *desc)
+static int _gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
@@ -1914,33 +1863,54 @@ static int _gpiod_get_value(const struct gpio_desc *desc)
 }
 
 /**
- * __gpio_get_value() - return a gpio's value
- * @gpio: gpio whose value will be returned
- * Context: any
+ * gpiod_get_raw_value() - return a gpio's raw value
+ * @desc: gpio whose value will be returned
  *
- * This is used directly or indirectly to implement gpio_get_value().
- * It returns the zero or nonzero value provided by the associated
- * gpio_chip.get() method; or zero if no such method is provided.
+ * Return the GPIO's raw value, i.e. the value of the physical line disregarding
+ * its ACTIVE_LOW status.
+ *
+ * This function should be called from contexts where we cannot sleep, and will
+ * complain if the GPIO chip functions potentially sleep.
  */
-static int gpiod_get_value(const struct gpio_desc *desc)
+int gpiod_get_raw_value(const struct gpio_desc *desc)
 {
 	if (!desc)
 		return 0;
 	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
-	return _gpiod_get_value(desc);
+	return _gpiod_get_raw_value(desc);
 }
+EXPORT_SYMBOL_GPL(gpiod_get_raw_value);
 
-int __gpio_get_value(unsigned gpio)
+/**
+ * gpiod_get_value() - return a gpio's value
+ * @desc: gpio whose value will be returned
+ *
+ * Return the GPIO's logical value, i.e. taking the ACTIVE_LOW status into
+ * account.
+ *
+ * This function should be called from contexts where we cannot sleep, and will
+ * complain if the GPIO chip functions potentially sleep.
+ */
+int gpiod_get_value(const struct gpio_desc *desc)
 {
-	return gpiod_get_value(gpio_to_desc(gpio));
+	int value;
+	if (!desc)
+		return 0;
+	/* Should be using gpio_get_value_cansleep() */
+	WARN_ON(desc->chip->can_sleep);
+
+	value = _gpiod_get_raw_value(desc);
+	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+		value = !value;
+
+	return value;
 }
-EXPORT_SYMBOL_GPL(__gpio_get_value);
+EXPORT_SYMBOL_GPL(gpiod_get_value);
 
 /*
  *  _gpio_set_open_drain_value() - Set the open drain gpio's value.
- * @gpio: Gpio whose state need to be set.
- * @chip: Gpio chip.
+ * @desc: gpio descriptor whose state need to be set.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
 static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
@@ -1966,9 +1936,8 @@ static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
 }
 
 /*
- *  _gpio_set_open_source() - Set the open source gpio's value.
- * @gpio: Gpio whose state need to be set.
- * @chip: Gpio chip.
+ *  _gpio_set_open_source_value() - Set the open source gpio's value.
+ * @desc: gpio descriptor whose state need to be set.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
 static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
@@ -1993,7 +1962,7 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 			  __func__, err);
 }
 
-static void _gpiod_set_value(struct gpio_desc *desc, int value)
+static void _gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
@@ -2008,62 +1977,70 @@ static void _gpiod_set_value(struct gpio_desc *desc, int value)
 }
 
 /**
- * __gpio_set_value() - assign a gpio's value
- * @gpio: gpio whose value will be assigned
+ * gpiod_set_raw_value() - assign a gpio's raw value
+ * @desc: gpio whose value will be assigned
  * @value: value to assign
- * Context: any
  *
- * This is used directly or indirectly to implement gpio_set_value().
- * It invokes the associated gpio_chip.set() method.
+ * Set the raw value of the GPIO, i.e. the value of its physical line without
+ * regard for its ACTIVE_LOW status.
+ *
+ * This function should be called from contexts where we cannot sleep, and will
+ * complain if the GPIO chip functions potentially sleep.
  */
-static void gpiod_set_value(struct gpio_desc *desc, int value)
+void gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
-
 	if (!desc)
 		return;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(desc->chip->can_sleep);
-	_gpiod_set_value(desc, value);
+	_gpiod_set_raw_value(desc, value);
 }
+EXPORT_SYMBOL_GPL(gpiod_set_raw_value);
 
-void __gpio_set_value(unsigned gpio, int value)
+/**
+ * gpiod_set_value() - assign a gpio's value
+ * @desc: gpio whose value will be assigned
+ * @value: value to assign
+ *
+ * Set the logical value of the GPIO, i.e. taking its ACTIVE_LOW status into
+ * account
+ *
+ * This function should be called from contexts where we cannot sleep, and will
+ * complain if the GPIO chip functions potentially sleep.
+ */
+void gpiod_set_value(struct gpio_desc *desc, int value)
 {
-	return gpiod_set_value(gpio_to_desc(gpio), value);
+	if (!desc)
+		return;
+	/* Should be using gpio_set_value_cansleep() */
+	WARN_ON(desc->chip->can_sleep);
+	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+		value = !value;
+	_gpiod_set_raw_value(desc, value);
 }
-EXPORT_SYMBOL_GPL(__gpio_set_value);
+EXPORT_SYMBOL_GPL(gpiod_set_value);
 
 /**
- * __gpio_cansleep() - report whether gpio value access will sleep
- * @gpio: gpio in question
- * Context: any
+ * gpiod_cansleep() - report whether gpio value access may sleep
+ * @desc: gpio to check
  *
- * This is used directly or indirectly to implement gpio_cansleep().  It
- * returns nonzero if access reading or writing the GPIO value can sleep.
  */
-static int gpiod_cansleep(const struct gpio_desc *desc)
+int gpiod_cansleep(const struct gpio_desc *desc)
 {
 	if (!desc)
 		return 0;
-	/* only call this on GPIOs that are valid! */
 	return desc->chip->can_sleep;
 }
-
-int __gpio_cansleep(unsigned gpio)
-{
-	return gpiod_cansleep(gpio_to_desc(gpio));
-}
-EXPORT_SYMBOL_GPL(__gpio_cansleep);
+EXPORT_SYMBOL_GPL(gpiod_cansleep);
 
 /**
- * __gpio_to_irq() - return the IRQ corresponding to a GPIO
- * @gpio: gpio whose IRQ will be returned (already requested)
- * Context: any
+ * gpiod_to_irq() - return the IRQ corresponding to a GPIO
+ * @desc: gpio whose IRQ will be returned (already requested)
  *
- * This is used directly or indirectly to implement gpio_to_irq().
- * It returns the number of the IRQ signaled by this (input) GPIO,
- * or a negative errno.
+ * Return the IRQ corresponding to the passed GPIO, or an error code in case of
+ * error.
  */
-static int gpiod_to_irq(const struct gpio_desc *desc)
+int gpiod_to_irq(const struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int			offset;
@@ -2074,12 +2051,7 @@ static int gpiod_to_irq(const struct gpio_desc *desc)
 	offset = gpio_chip_hwgpio(desc);
 	return chip->to_irq ? chip->to_irq(chip, offset) : -ENXIO;
 }
-
-int __gpio_to_irq(unsigned gpio)
-{
-	return gpiod_to_irq(gpio_to_desc(gpio));
-}
-EXPORT_SYMBOL_GPL(__gpio_to_irq);
+EXPORT_SYMBOL_GPL(gpiod_to_irq);
 
 /**
  * gpiod_lock_as_irq() - lock a GPIO to be used as IRQ
@@ -2091,7 +2063,7 @@ EXPORT_SYMBOL_GPL(__gpio_to_irq);
  * of its irq_chip implementation if the GPIO is known from that
  * code.
  */
-static int gpiod_lock_as_irq(struct gpio_desc *desc)
+int gpiod_lock_as_irq(struct gpio_desc *desc)
 {
 	if (!desc)
 		return -EINVAL;
@@ -2106,6 +2078,7 @@ static int gpiod_lock_as_irq(struct gpio_desc *desc)
 	set_bit(FLAG_USED_AS_IRQ, &desc->flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(gpiod_lock_as_irq);
 
 int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
@@ -2120,13 +2093,14 @@ EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
  * This is used directly by GPIO drivers that want to indicate
  * that a certain GPIO is no longer used exclusively for IRQ.
  */
-static void gpiod_unlock_as_irq(struct gpio_desc *desc)
+void gpiod_unlock_as_irq(struct gpio_desc *desc)
 {
 	if (!desc)
 		return;
 
 	clear_bit(FLAG_USED_AS_IRQ, &desc->flags);
 }
+EXPORT_SYMBOL_GPL(gpiod_unlock_as_irq);
 
 void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
@@ -2134,37 +2108,89 @@ void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 }
 EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
 
-/* There's no value in making it easy to inline GPIO calls that may sleep.
- * Common examples include ones connected to I2C or SPI chips.
+/**
+ * gpiod_get_raw_value_cansleep() - return a gpio's raw value
+ * @desc: gpio whose value will be returned
+ *
+ * Return the GPIO's raw value, i.e. the value of the physical line disregarding
+ * its ACTIVE_LOW status.
+ *
+ * This function is to be called from contexts that can sleep.
  */
-
-static int gpiod_get_value_cansleep(const struct gpio_desc *desc)
+int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc)
 {
 	might_sleep_if(extra_checks);
 	if (!desc)
 		return 0;
-	return _gpiod_get_value(desc);
+	return _gpiod_get_raw_value(desc);
 }
+EXPORT_SYMBOL_GPL(gpiod_get_raw_value_cansleep);
 
-int gpio_get_value_cansleep(unsigned gpio)
+/**
+ * gpiod_get_value_cansleep() - return a gpio's value
+ * @desc: gpio whose value will be returned
+ *
+ * Return the GPIO's logical value, i.e. taking the ACTIVE_LOW status into
+ * account.
+ *
+ * This function is to be called from contexts that can sleep.
+ */
+int gpiod_get_value_cansleep(const struct gpio_desc *desc)
 {
-	return gpiod_get_value_cansleep(gpio_to_desc(gpio));
+	int value;
+
+	might_sleep_if(extra_checks);
+	if (!desc)
+		return 0;
+
+	value = _gpiod_get_raw_value(desc);
+	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+		value = !value;
+
+	return value;
 }
-EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
+EXPORT_SYMBOL_GPL(gpiod_get_value_cansleep);
 
-static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
+/**
+ * gpiod_set_raw_value_cansleep() - assign a gpio's raw value
+ * @desc: gpio whose value will be assigned
+ * @value: value to assign
+ *
+ * Set the raw value of the GPIO, i.e. the value of its physical line without
+ * regard for its ACTIVE_LOW status.
+ *
+ * This function is to be called from contexts that can sleep.
+ */
+void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value)
 {
 	might_sleep_if(extra_checks);
 	if (!desc)
 		return;
-	_gpiod_set_value(desc, value);
+	_gpiod_set_raw_value(desc, value);
 }
+EXPORT_SYMBOL_GPL(gpiod_set_raw_value_cansleep);
 
-void gpio_set_value_cansleep(unsigned gpio, int value)
+/**
+ * gpiod_set_value_cansleep() - assign a gpio's value
+ * @desc: gpio whose value will be assigned
+ * @value: value to assign
+ *
+ * Set the logical value of the GPIO, i.e. taking its ACTIVE_LOW status into
+ * account
+ *
+ * This function is to be called from contexts that can sleep.
+ */
+void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
-	return gpiod_set_value_cansleep(gpio_to_desc(gpio), value);
+	might_sleep_if(extra_checks);
+	if (!desc)
+		return;
+
+	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+		value = !value;
+	_gpiod_set_raw_value(desc, value);
 }
-EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
+EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
 
 #ifdef CONFIG_DEBUG_FS
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index b309a5c..00f8f0a 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -10,6 +10,8 @@
 #ifdef CONFIG_GPIOLIB
 
 #include <linux/compiler.h>
+#include <linux/gpio/driver.h>
+#include <linux/gpio/consumer.h>
 
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
@@ -49,122 +51,11 @@ struct module;
 struct device_node;
 struct gpio_desc;
 
-/**
- * struct gpio_chip - abstract a GPIO controller
- * @label: for diagnostics
- * @dev: optional device providing the GPIOs
- * @owner: helps prevent removal of modules exporting active GPIOs
- * @list: links gpio_chips together for traversal
- * @request: optional hook for chip-specific activation, such as
- *	enabling module power and clock; may sleep
- * @free: optional hook for chip-specific deactivation, such as
- *	disabling module power and clock; may sleep
- * @get_direction: returns direction for signal "offset", 0=out, 1=in,
- *	(same as GPIOF_DIR_XXX), or negative error
- * @direction_input: configures signal "offset" as input, or returns error
- * @get: returns value for signal "offset"; for output signals this
- *	returns either the value actually sensed, or zero
- * @direction_output: configures signal "offset" as output, or returns error
- * @set_debounce: optional hook for setting debounce time for specified gpio in
- *      interrupt triggered gpio chips
- * @set: assigns output value for signal "offset"
- * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
- *	implementation may not sleep
- * @dbg_show: optional routine to show contents in debugfs; default code
- *	will be used when this is omitted, but custom code can show extra
- *	state (such as pullup/pulldown configuration).
- * @base: identifies the first GPIO number handled by this chip; or, if
- *	negative during registration, requests dynamic ID allocation.
- * @ngpio: the number of GPIOs handled by this controller; the last GPIO
- *	handled is (base + ngpio - 1).
- * @desc: array of ngpio descriptors. Private.
- * @can_sleep: flag must be set iff get()/set() methods sleep, as they
- *	must while accessing GPIO expander chips over I2C or SPI
- * @names: if set, must be an array of strings to use as alternative
- *      names for the GPIOs in this chip. Any entry in the array
- *      may be NULL if there is no alias for the GPIO, however the
- *      array must be @ngpio entries long.  A name can include a single printk
- *      format specifier for an unsigned int.  It is substituted by the actual
- *      number of the gpio.
- *
- * A gpio_chip can help platforms abstract various sources of GPIOs so
- * they can all be accessed through a common programing interface.
- * Example sources would be SOC controllers, FPGAs, multifunction
- * chips, dedicated GPIO expanders, and so on.
- *
- * Each chip controls a number of signals, identified in method calls
- * by "offset" values in the range 0..(@ngpio - 1).  When those signals
- * are referenced through calls like gpio_get_value(gpio), the offset
- * is calculated by subtracting @base from the gpio number.
- */
-struct gpio_chip {
-	const char		*label;
-	struct device		*dev;
-	struct module		*owner;
-	struct list_head        list;
-
-	int			(*request)(struct gpio_chip *chip,
-						unsigned offset);
-	void			(*free)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*get_direction)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*direction_input)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*get)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*direction_output)(struct gpio_chip *chip,
-						unsigned offset, int value);
-	int			(*set_debounce)(struct gpio_chip *chip,
-						unsigned offset, unsigned debounce);
-
-	void			(*set)(struct gpio_chip *chip,
-						unsigned offset, int value);
-
-	int			(*to_irq)(struct gpio_chip *chip,
-						unsigned offset);
-
-	void			(*dbg_show)(struct seq_file *s,
-						struct gpio_chip *chip);
-	int			base;
-	u16			ngpio;
-	struct gpio_desc	*desc;
-	const char		*const *names;
-	unsigned		can_sleep:1;
-	unsigned		exported:1;
-
-#if defined(CONFIG_OF_GPIO)
-	/*
-	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
-	 * device tree automatically may have an OF translation
-	 */
-	struct device_node *of_node;
-	int of_gpio_n_cells;
-	int (*of_xlate)(struct gpio_chip *gc,
-		        const struct of_phandle_args *gpiospec, u32 *flags);
-#endif
-#ifdef CONFIG_PINCTRL
-	/*
-	 * If CONFIG_PINCTRL is enabled, then gpio controllers can optionally
-	 * describe the actual pin range which they serve in an SoC. This
-	 * information would be used by pinctrl subsystem to configure
-	 * corresponding pins for gpio usage.
-	 */
-	struct list_head pin_ranges;
-#endif
-};
-
-extern const char *gpiochip_is_requested(struct gpio_chip *chip,
-			unsigned offset);
-extern struct gpio_chip *gpio_to_chip(unsigned gpio);
-
-/* add/remove chips */
-extern int gpiochip_add(struct gpio_chip *chip);
-extern int __must_check gpiochip_remove(struct gpio_chip *chip);
-extern struct gpio_chip *gpiochip_find(void *data,
-					int (*match)(struct gpio_chip *chip,
-						     void *data));
-
+/* caller holds gpio_lock *OR* gpio is marked as requested */
+static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+{
+	return gpiod_to_chip(gpio_to_desc(gpio));
+}
 
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
@@ -172,25 +63,52 @@ extern struct gpio_chip *gpiochip_find(void *data,
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return gpiod_direction_input(gpio_to_desc(gpio));
+}
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return gpiod_direction_output(gpio_to_desc(gpio), value);
+}
 
-extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
+static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
+}
 
-extern int gpio_get_value_cansleep(unsigned gpio);
-extern void gpio_set_value_cansleep(unsigned gpio, int value);
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	return gpiod_get_raw_value_cansleep(gpio_to_desc(gpio));
+}
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	return gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
+}
 
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,
  * giving direct access to chip registers and tight bitbanging loops.
  */
-extern int __gpio_get_value(unsigned gpio);
-extern void __gpio_set_value(unsigned gpio, int value);
+static inline int __gpio_get_value(unsigned gpio)
+{
+	return gpiod_get_raw_value(gpio_to_desc(gpio));
+}
+static inline void __gpio_set_value(unsigned gpio, int value)
+{
+	return gpiod_set_raw_value(gpio_to_desc(gpio), value);
+}
 
-extern int __gpio_cansleep(unsigned gpio);
+static inline int __gpio_cansleep(unsigned gpio)
+{
+	return gpiod_cansleep(gpio_to_desc(gpio));
+}
 
-extern int __gpio_to_irq(unsigned gpio);
+static inline int __gpio_to_irq(unsigned gpio)
+{
+	return gpiod_to_irq(gpio_to_desc(gpio));
+}
 
 extern int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset);
 extern void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset);
@@ -199,19 +117,30 @@ extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *labe
 extern int gpio_request_array(const struct gpio *array, size_t num);
 extern void gpio_free_array(const struct gpio *array, size_t num);
 
-#ifdef CONFIG_GPIO_SYSFS
-
 /*
  * A sysfs interface can be exported by individual drivers if they want,
  * but more typically is configured entirely from userspace.
  */
-extern int gpio_export(unsigned gpio, bool direction_may_change);
-extern int gpio_export_link(struct device *dev, const char *name,
-			unsigned gpio);
-extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
-extern void gpio_unexport(unsigned gpio);
+static inline int gpio_export(unsigned gpio, bool direction_may_change)
+{
+	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
+}
 
-#endif	/* CONFIG_GPIO_SYSFS */
+static inline int gpio_export_link(struct device *dev, const char *name,
+				   unsigned gpio)
+{
+	return gpiod_export_link(dev, name, gpio_to_desc(gpio));
+}
+
+static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
+{
+	return gpiod_sysfs_set_active_low(gpio_to_desc(gpio), value);
+}
+
+static inline void gpio_unexport(unsigned gpio)
+{
+	gpiod_unexport(gpio_to_desc(gpio));
+}
 
 #ifdef CONFIG_PINCTRL
 
@@ -281,31 +210,4 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 
 #endif /* !CONFIG_GPIOLIB */
 
-#ifndef CONFIG_GPIO_SYSFS
-
-struct device;
-
-/* sysfs support is only available with gpiolib, where it's optional */
-
-static inline int gpio_export(unsigned gpio, bool direction_may_change)
-{
-	return -ENOSYS;
-}
-
-static inline int gpio_export_link(struct device *dev, const char *name,
-				unsigned gpio)
-{
-	return -ENOSYS;
-}
-
-static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
-{
-	return -ENOSYS;
-}
-
-static inline void gpio_unexport(unsigned gpio)
-{
-}
-#endif	/* CONFIG_GPIO_SYSFS */
-
 #endif /* _ASM_GENERIC_GPIO_H */
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index a06ec3e..c691df0 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -16,14 +16,17 @@
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+/* Gpio pin is active-low */
+#define GPIOF_ACTIVE_LOW        (1 << 2)
+
 /* Gpio pin is open drain */
-#define GPIOF_OPEN_DRAIN	(1 << 2)
+#define GPIOF_OPEN_DRAIN	(1 << 3)
 
 /* Gpio pin is open source */
-#define GPIOF_OPEN_SOURCE	(1 << 3)
+#define GPIOF_OPEN_SOURCE	(1 << 4)
 
-#define GPIOF_EXPORT		(1 << 4)
-#define GPIOF_EXPORT_CHANGEABLE	(1 << 5)
+#define GPIOF_EXPORT		(1 << 5)
+#define GPIOF_EXPORT_CHANGEABLE	(1 << 6)
 #define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
 #define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)
 
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
new file mode 100644
index 0000000..2088eb5
--- /dev/null
+++ b/include/linux/gpio/consumer.h
@@ -0,0 +1,238 @@
+#ifndef __LINUX_GPIO_CONSUMER_H
+#define __LINUX_GPIO_CONSUMER_H
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+
+#ifdef CONFIG_GPIOLIB
+
+struct device;
+struct gpio_chip;
+
+/**
+ * Opaque descriptor for a GPIO. These are obtained using gpiod_get() and are
+ * preferable to the old integer-based handles.
+ *
+ * Contrary to integers, a pointer to a gpio_desc is guaranteed to be valid
+ * until the GPIO is released.
+ */
+struct gpio_desc;
+
+int gpiod_get_direction(const struct gpio_desc *desc);
+int gpiod_direction_input(struct gpio_desc *desc);
+int gpiod_direction_output(struct gpio_desc *desc, int value);
+
+/* Value get/set from non-sleeping context */
+int gpiod_get_value(const struct gpio_desc *desc);
+void gpiod_set_value(struct gpio_desc *desc, int value);
+int gpiod_get_raw_value(const struct gpio_desc *desc);
+void gpiod_set_raw_value(struct gpio_desc *desc, int value);
+
+/* Value get/set from sleeping context */
+int gpiod_get_value_cansleep(const struct gpio_desc *desc);
+void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
+int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc);
+void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value);
+
+int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
+
+int gpiod_is_active_low(const struct gpio_desc *desc);
+int gpiod_cansleep(const struct gpio_desc *desc);
+
+int gpiod_to_irq(const struct gpio_desc *desc);
+
+/* Convert between the old gpio_ and new gpiod_ interfaces */
+struct gpio_desc *gpio_to_desc(unsigned gpio);
+int desc_to_gpio(const struct gpio_desc *desc);
+struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc);
+
+#else /* CONFIG_GPIOLIB */
+
+static inline struct gpio_desc *__must_check gpiod_get(struct device *dev,
+						       const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
+							     const char *con_id,
+							     unsigned int idx)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline void gpiod_put(struct gpio_desc *desc)
+{
+	might_sleep();
+
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
+							    const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline
+struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
+						    const char *con_id,
+						    unsigned int idx)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
+{
+	might_sleep();
+
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+
+static inline int gpiod_get_direction(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -ENOSYS;
+}
+static inline int gpiod_direction_input(struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -ENOSYS;
+}
+static inline int gpiod_direction_output(struct gpio_desc *desc, int value)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -ENOSYS;
+}
+
+
+static inline int gpiod_get_value(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return 0;
+}
+static inline void gpiod_set_value(struct gpio_desc *desc, int value)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+static inline int gpiod_get_raw_value(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return 0;
+}
+static inline void gpiod_set_raw_value(struct gpio_desc *desc, int value)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline int gpiod_get_value_cansleep(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return 0;
+}
+static inline void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+static inline int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return 0;
+}
+static inline void gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
+						int value)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -ENOSYS;
+}
+
+static inline int gpiod_is_active_low(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return 0;
+}
+static inline int gpiod_cansleep(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline int gpiod_to_irq(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static inline struct gpio_desc *gpio_to_desc(unsigned gpio)
+{
+	return ERR_PTR(-EINVAL);
+}
+static inline int desc_to_gpio(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -EINVAL;
+}
+static inline struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return ERR_PTR(-ENODEV);
+}
+
+
+#endif /* CONFIG_GPIOLIB */
+
+#if IS_ENABLED(CONFIG_GPIOLIB) && IS_ENABLED(CONFIG_GPIO_SYSFS)
+
+int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
+int gpiod_export_link(struct device *dev, const char *name,
+		      struct gpio_desc *desc);
+int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
+void gpiod_unexport(struct gpio_desc *desc);
+
+#else  /* CONFIG_GPIOLIB && CONFIG_GPIO_SYSFS */
+
+static inline int gpiod_export(struct gpio_desc *desc,
+			       bool direction_may_change)
+{
+	return -ENOSYS;
+}
+
+static inline int gpiod_export_link(struct device *dev, const char *name,
+				    struct gpio_desc *desc)
+{
+	return -ENOSYS;
+}
+
+static inline int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
+{
+	return -ENOSYS;
+}
+
+static inline void gpiod_unexport(struct gpio_desc *desc)
+{
+}
+
+#endif /* CONFIG_GPIOLIB && CONFIG_GPIO_SYSFS */
+
+#endif
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
new file mode 100644
index 0000000..5dc172c
--- /dev/null
+++ b/include/linux/gpio/driver.h
@@ -0,0 +1,127 @@
+#ifndef __LINUX_GPIO_DRIVER_H
+#define __LINUX_GPIO_DRIVER_H
+
+#include <linux/types.h>
+
+struct device;
+struct gpio_desc;
+
+/**
+ * struct gpio_chip - abstract a GPIO controller
+ * @label: for diagnostics
+ * @dev: optional device providing the GPIOs
+ * @owner: helps prevent removal of modules exporting active GPIOs
+ * @list: links gpio_chips together for traversal
+ * @request: optional hook for chip-specific activation, such as
+ *	enabling module power and clock; may sleep
+ * @free: optional hook for chip-specific deactivation, such as
+ *	disabling module power and clock; may sleep
+ * @get_direction: returns direction for signal "offset", 0=out, 1=in,
+ *	(same as GPIOF_DIR_XXX), or negative error
+ * @direction_input: configures signal "offset" as input, or returns error
+ * @direction_output: configures signal "offset" as output, or returns error
+ * @get: returns value for signal "offset"; for output signals this
+ *	returns either the value actually sensed, or zero
+ * @set: assigns output value for signal "offset"
+ * @set_debounce: optional hook for setting debounce time for specified gpio in
+ *      interrupt triggered gpio chips
+ * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
+ *	implementation may not sleep
+ * @dbg_show: optional routine to show contents in debugfs; default code
+ *	will be used when this is omitted, but custom code can show extra
+ *	state (such as pullup/pulldown configuration).
+ * @base: identifies the first GPIO number handled by this chip; or, if
+ *	negative during registration, requests dynamic ID allocation.
+ * @ngpio: the number of GPIOs handled by this controller; the last GPIO
+ *	handled is (base + ngpio - 1).
+ * @desc: array of ngpio descriptors. Private.
+ * @can_sleep: flag must be set iff get()/set() methods sleep, as they
+ *	must while accessing GPIO expander chips over I2C or SPI
+ * @names: if set, must be an array of strings to use as alternative
+ *      names for the GPIOs in this chip. Any entry in the array
+ *      may be NULL if there is no alias for the GPIO, however the
+ *      array must be @ngpio entries long.  A name can include a single printk
+ *      format specifier for an unsigned int.  It is substituted by the actual
+ *      number of the gpio.
+ *
+ * A gpio_chip can help platforms abstract various sources of GPIOs so
+ * they can all be accessed through a common programing interface.
+ * Example sources would be SOC controllers, FPGAs, multifunction
+ * chips, dedicated GPIO expanders, and so on.
+ *
+ * Each chip controls a number of signals, identified in method calls
+ * by "offset" values in the range 0..(@ngpio - 1).  When those signals
+ * are referenced through calls like gpio_get_value(gpio), the offset
+ * is calculated by subtracting @base from the gpio number.
+ */
+struct gpio_chip {
+	const char		*label;
+	struct device		*dev;
+	struct module		*owner;
+	struct list_head        list;
+
+	int			(*request)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*free)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*get_direction)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_input)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_output)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	int			(*get)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*set)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	int			(*set_debounce)(struct gpio_chip *chip,
+						unsigned offset,
+						unsigned debounce);
+
+	int			(*to_irq)(struct gpio_chip *chip,
+						unsigned offset);
+
+	void			(*dbg_show)(struct seq_file *s,
+						struct gpio_chip *chip);
+	int			base;
+	u16			ngpio;
+	struct gpio_desc	*desc;
+	const char		*const *names;
+	unsigned		can_sleep:1;
+	unsigned		exported:1;
+
+#if defined(CONFIG_OF_GPIO)
+	/*
+	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
+	 * device tree automatically may have an OF translation
+	 */
+	struct device_node *of_node;
+	int of_gpio_n_cells;
+	int (*of_xlate)(struct gpio_chip *gc,
+			const struct of_phandle_args *gpiospec, u32 *flags);
+#endif
+#ifdef CONFIG_PINCTRL
+	/*
+	 * If CONFIG_PINCTRL is enabled, then gpio controllers can optionally
+	 * describe the actual pin range which they serve in an SoC. This
+	 * information would be used by pinctrl subsystem to configure
+	 * corresponding pins for gpio usage.
+	 */
+	struct list_head pin_ranges;
+#endif
+};
+
+extern const char *gpiochip_is_requested(struct gpio_chip *chip,
+			unsigned offset);
+
+/* add/remove chips */
+extern int gpiochip_add(struct gpio_chip *chip);
+extern int __must_check gpiochip_remove(struct gpio_chip *chip);
+extern struct gpio_chip *gpiochip_find(void *data,
+			      int (*match)(struct gpio_chip *chip, void *data));
+
+/* lock/unlock as IRQ */
+int gpiod_lock_as_irq(struct gpio_desc *desc);
+void gpiod_unlock_as_irq(struct gpio_desc *desc);
+
+#endif
-- 
1.8.4

