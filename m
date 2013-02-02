Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab3BBQ2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:28:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60733 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab3BBQ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:37 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 6/9] gpiolib: use descriptors internally
Date: Sun,  3 Feb 2013 01:29:29 +0900
Message-Id: <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure gpiolib works internally with descriptors and (chip, offset)
pairs instead of using the global integer namespace. This prepares the
ground for the removal of the global gpio_desc[] array and the
introduction of the descriptor-based GPIO API.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 493 +++++++++++++++++++++++++++++++------------------
 1 file changed, 317 insertions(+), 176 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index af4c350..82c40bd 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -78,6 +78,28 @@ static LIST_HEAD(gpio_chips);
 static DEFINE_IDR(dirent_idr);
 #endif
 
+/*
+ * Internal gpiod_* API using descriptors instead of the integer namespace.
+ * Most of this should eventually go public.
+ */
+static int gpiod_request(struct gpio_desc *desc, const char *label);
+static void gpiod_free(struct gpio_desc *desc);
+static int gpiod_direction_input(struct gpio_desc *desc);
+static int gpiod_direction_output(struct gpio_desc *desc, int value);
+static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
+static int gpiod_get_value_cansleep(struct gpio_desc *desc);
+static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
+static int gpiod_get_value(struct gpio_desc *desc);
+static void gpiod_set_value(struct gpio_desc *desc, int value);
+static int gpiod_cansleep(struct gpio_desc *desc);
+static int gpiod_to_irq(struct gpio_desc *desc);
+static int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
+static int gpiod_export_link(struct device *dev, const char *name,
+			     struct gpio_desc *desc);
+static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
+static void gpiod_unexport(struct gpio_desc *desc);
+
+
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
 #ifdef CONFIG_DEBUG_FS
@@ -85,6 +107,36 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
 #endif
 }
 
+/*
+ * Return the GPIO number of the passed descriptor relative to its chip
+ */
+static int gpio_chip_hwgpio(const struct gpio_desc *desc)
+{
+	return (desc - &gpio_desc[0]) - desc->chip->base;
+}
+
+/**
+ * Convert a GPIO number to its descriptor
+ */
+static struct gpio_desc *gpio_to_desc(unsigned gpio)
+{
+	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
+		return NULL;
+	else
+		return &gpio_desc[gpio];
+}
+
+/**
+ * Convert a GPIO descriptor to the integer namespace.
+ * This should disappear in the future but is needed since we still
+ * use GPIO numbers for error messages and sysfs nodes
+ */
+static int desc_to_gpio(const struct gpio_desc *desc)
+{
+	return desc - &gpio_desc[0];
+}
+
+
 /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
  * when setting direction, and otherwise illegal.  Until board setup code
  * and drivers use explicit requests everywhere (which won't happen when
@@ -96,10 +148,10 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
  * only "legal" in the sense that (old) code using it won't break yet,
  * but instead only triggers a WARN() stack dump.
  */
-static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
+static int gpio_ensure_requested(struct gpio_desc *desc)
 {
 	const struct gpio_chip *chip = desc->chip;
-	const int gpio = chip->base + offset;
+	const int gpio = desc_to_gpio(desc);
 
 	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
 			"autorequest GPIO-%d\n", gpio)) {
@@ -118,9 +170,14 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
+static struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
+{
+	return desc->chip;
+}
+
 struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
-	return gpio_desc[gpio].chip;
+	return gpiod_to_chip(gpio_to_desc(gpio));
 }
 
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
@@ -148,19 +205,19 @@ static int gpiochip_find_base(int ngpio)
 }
 
 /* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
-static int gpio_get_direction(unsigned gpio)
+static int gpiod_get_direction(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
+	unsigned		offset;
 	int			status = -EINVAL;
 
-	chip = gpio_to_chip(gpio);
-	gpio -= chip->base;
+	chip = gpiod_to_chip(desc);
+	offset = gpio_chip_hwgpio(desc);
 
 	if (!chip->get_direction)
 		return status;
 
-	status = chip->get_direction(chip, gpio);
+	status = chip->get_direction(chip, offset);
 	if (status > 0) {
 		/* GPIOF_DIR_IN, or other positive */
 		status = 1;
@@ -204,8 +261,7 @@ static DEFINE_MUTEX(sysfs_lock);
 static ssize_t gpio_direction_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -213,7 +269,7 @@ static ssize_t gpio_direction_show(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else
-		gpio_get_direction(gpio);
+		gpiod_get_direction(desc);
 		status = sprintf(buf, "%s\n",
 			test_bit(FLAG_IS_OUT, &desc->flags)
 				? "out" : "in");
@@ -225,8 +281,7 @@ static ssize_t gpio_direction_show(struct device *dev,
 static ssize_t gpio_direction_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -234,11 +289,11 @@ static ssize_t gpio_direction_store(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else if (sysfs_streq(buf, "high"))
-		status = gpio_direction_output(gpio, 1);
+		status = gpiod_direction_output(desc, 1);
 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
-		status = gpio_direction_output(gpio, 0);
+		status = gpiod_direction_output(desc, 0);
 	else if (sysfs_streq(buf, "in"))
-		status = gpio_direction_input(gpio);
+		status = gpiod_direction_input(desc);
 	else
 		status = -EINVAL;
 
@@ -252,8 +307,7 @@ static /* const */ DEVICE_ATTR(direction, 0644,
 static ssize_t gpio_value_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -263,7 +317,7 @@ static ssize_t gpio_value_show(struct device *dev,
 	} else {
 		int value;
 
-		value = !!gpio_get_value_cansleep(gpio);
+		value = !!gpiod_get_value_cansleep(desc);
 		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 			value = !value;
 
@@ -277,8 +331,7 @@ static ssize_t gpio_value_show(struct device *dev,
 static ssize_t gpio_value_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -294,7 +347,7 @@ static ssize_t gpio_value_store(struct device *dev,
 		if (status == 0) {
 			if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 				value = !value;
-			gpio_set_value_cansleep(gpio, value != 0);
+			gpiod_set_value_cansleep(desc, value != 0);
 			status = size;
 		}
 	}
@@ -324,7 +377,7 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
 		return 0;
 
-	irq = gpio_to_irq(desc - gpio_desc);
+	irq = gpiod_to_irq(desc);
 	if (irq < 0)
 		return -EIO;
 
@@ -594,29 +647,32 @@ static ssize_t export_store(struct class *class,
 				struct class_attribute *attr,
 				const char *buf, size_t len)
 {
-	long	gpio;
-	int	status;
+	long			gpio;
+	struct gpio_desc	*desc;
+	int			status;
 
 	status = strict_strtol(buf, 0, &gpio);
 	if (status < 0)
 		goto done;
 
+	desc = gpio_to_desc(gpio);
+
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
 	 * they may be undone on its behalf too.
 	 */
 
-	status = gpio_request(gpio, "sysfs");
+	status = gpiod_request(desc, "sysfs");
 	if (status < 0) {
 		if (status == -EPROBE_DEFER)
 			status = -ENODEV;
 		goto done;
 	}
-	status = gpio_export(gpio, true);
+	status = gpiod_export(desc, true);
 	if (status < 0)
-		gpio_free(gpio);
+		gpiod_free(desc);
 	else
-		set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
+		set_bit(FLAG_SYSFS, &desc->flags);
 
 done:
 	if (status)
@@ -628,8 +684,9 @@ static ssize_t unexport_store(struct class *class,
 				struct class_attribute *attr,
 				const char *buf, size_t len)
 {
-	long	gpio;
-	int	status;
+	long			gpio;
+	struct gpio_desc	*desc;
+	int			status;
 
 	status = strict_strtol(buf, 0, &gpio);
 	if (status < 0)
@@ -637,17 +694,18 @@ static ssize_t unexport_store(struct class *class,
 
 	status = -EINVAL;
 
+	desc = gpio_to_desc(gpio);
 	/* reject bogus commands (gpio_unexport ignores them) */
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto done;
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
 	 * they may be undone on its behalf too.
 	 */
-	if (test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags)) {
+	if (test_and_clear_bit(FLAG_SYSFS, &desc->flags)) {
 		status = 0;
-		gpio_free(gpio);
+		gpiod_free(desc);
 	}
 done:
 	if (status)
@@ -684,13 +742,13 @@ static struct class gpio_class = {
  *
  * Returns zero on success, else an error.
  */
-int gpio_export(unsigned gpio, bool direction_may_change)
+static int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 {
 	unsigned long		flags;
-	struct gpio_desc	*desc;
 	int			status;
 	const char		*ioname = NULL;
 	struct device		*dev;
+	int			offset;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
@@ -698,20 +756,19 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		return -ENOENT;
 	}
 
-	if (!gpio_is_valid(gpio)) {
-		pr_debug("%s: gpio %d is not valid\n", __func__, gpio);
+	if (!desc) {
+		pr_debug("%s: invalid gpio descriptor\n", __func__);
 		return -EINVAL;
 	}
 
 	mutex_lock(&sysfs_lock);
 
 	spin_lock_irqsave(&gpio_lock, flags);
-	desc = &gpio_desc[gpio];
 	if (!test_bit(FLAG_REQUESTED, &desc->flags) ||
 	     test_bit(FLAG_EXPORT, &desc->flags)) {
 		spin_unlock_irqrestore(&gpio_lock, flags);
 		pr_debug("%s: gpio %d unavailable (requested=%d, exported=%d)\n",
-				__func__, gpio,
+				__func__, desc_to_gpio(desc),
 				test_bit(FLAG_REQUESTED, &desc->flags),
 				test_bit(FLAG_EXPORT, &desc->flags));
 		status = -EPERM;
@@ -722,11 +779,13 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		direction_may_change = false;
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
-		ioname = desc->chip->names[gpio - desc->chip->base];
+	offset = gpio_chip_hwgpio(desc);
+	if (desc->chip->names && desc->chip->names[offset])
+		ioname = desc->chip->names[offset];
 
 	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-			    desc, ioname ? ioname : "gpio%u", gpio);
+			    desc, ioname ? ioname : "gpio%u",
+			    desc_to_gpio(desc));
 	if (IS_ERR(dev)) {
 		status = PTR_ERR(dev);
 		goto fail_unlock;
@@ -742,7 +801,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			goto fail_unregister_device;
 	}
 
-	if (gpio_to_irq(gpio) >= 0 && (direction_may_change ||
+	if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
 				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
 		status = device_create_file(dev, &dev_attr_edge);
 		if (status)
@@ -757,9 +816,15 @@ fail_unregister_device:
 	device_unregister(dev);
 fail_unlock:
 	mutex_unlock(&sysfs_lock);
-	pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+	pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+		 status);
 	return status;
 }
+
+int gpio_export(unsigned gpio, bool direction_may_change)
+{
+	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
+}
 EXPORT_SYMBOL_GPL(gpio_export);
 
 static int match_export(struct device *dev, void *data)
@@ -778,18 +843,16 @@ static int match_export(struct device *dev, void *data)
  *
  * Returns zero on success, else an error.
  */
-int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
+static int gpiod_export_link(struct device *dev, const char *name,
+			     struct gpio_desc *desc)
 {
-	struct gpio_desc	*desc;
 	int			status = -EINVAL;
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto done;
 
 	mutex_lock(&sysfs_lock);
 
-	desc = &gpio_desc[gpio];
-
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		struct device *tdev;
 
@@ -806,12 +869,17 @@ int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+			 status);
 
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_export_link);
 
+int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
+{
+	return gpiod_export_link(dev, name, gpio_to_desc(gpio));
+}
+EXPORT_SYMBOL_GPL(gpio_export_link);
 
 /**
  * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
@@ -825,19 +893,16 @@ EXPORT_SYMBOL_GPL(gpio_export_link);
  *
  * Returns zero on success, else an error.
  */
-int gpio_sysfs_set_active_low(unsigned gpio, int value)
+static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
 {
-	struct gpio_desc	*desc;
 	struct device		*dev = NULL;
 	int			status = -EINVAL;
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto done;
 
 	mutex_lock(&sysfs_lock);
 
-	desc = &gpio_desc[gpio];
-
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev == NULL) {
@@ -853,10 +918,16 @@ unlock:
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+			 status);
 
 	return status;
 }
+
+int gpio_sysfs_set_active_low(unsigned gpio, int value)
+{
+	return gpiod_sysfs_set_active_low(gpio_to_desc(gpio), value);
+}
 EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
 
 /**
@@ -865,21 +936,18 @@ EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
  *
  * This is implicit on gpio_free().
  */
-void gpio_unexport(unsigned gpio)
+static void gpiod_unexport(struct gpio_desc *desc)
 {
-	struct gpio_desc	*desc;
 	int			status = 0;
 	struct device		*dev = NULL;
 
-	if (!gpio_is_valid(gpio)) {
+	if (!desc) {
 		status = -EINVAL;
 		goto done;
 	}
 
 	mutex_lock(&sysfs_lock);
 
-	desc = &gpio_desc[gpio];
-
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
@@ -891,13 +959,20 @@ void gpio_unexport(unsigned gpio)
 	}
 
 	mutex_unlock(&sysfs_lock);
+
 	if (dev) {
 		device_unregister(dev);
 		put_device(dev);
 	}
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+			 status);
+}
+
+void gpio_unexport(unsigned gpio)
+{
+	gpiod_unexport(gpio_to_desc(gpio));
 }
 EXPORT_SYMBOL_GPL(gpio_unexport);
 
@@ -1281,20 +1356,18 @@ EXPORT_SYMBOL_GPL(gpiochip_remove_pin_ranges);
  * on each other, and help provide better diagnostics in debugfs.
  * They're called even less than the "set direction" calls.
  */
-int gpio_request(unsigned gpio, const char *label)
+static int gpiod_request(struct gpio_desc *desc, const char *label)
 {
-	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
 	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio)) {
+	if (!desc) {
 		status = -EINVAL;
 		goto done;
 	}
-	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip == NULL)
 		goto done;
@@ -1318,7 +1391,7 @@ int gpio_request(unsigned gpio, const char *label)
 	if (chip->request) {
 		/* chip->request may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
-		status = chip->request(chip, gpio - chip->base);
+		status = chip->request(chip, gpio_chip_hwgpio(desc));
 		spin_lock_irqsave(&gpio_lock, flags);
 
 		if (status < 0) {
@@ -1331,42 +1404,46 @@ int gpio_request(unsigned gpio, const char *label)
 	if (chip->get_direction) {
 		/* chip->get_direction may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
-		gpio_get_direction(gpio);
+		gpiod_get_direction(desc);
 		spin_lock_irqsave(&gpio_lock, flags);
 	}
 done:
 	if (status)
-		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
-			gpio, label ? : "?", status);
+		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
+			 desc ? desc_to_gpio(desc) : -1,
+			 label ? : "?", status);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
+
+int gpio_request(unsigned gpio, const char *label)
+{
+	return gpiod_request(gpio_to_desc(gpio), label);
+}
 EXPORT_SYMBOL_GPL(gpio_request);
 
-void gpio_free(unsigned gpio)
+static void gpiod_free(struct gpio_desc *desc)
 {
 	unsigned long		flags;
-	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
 
 	might_sleep();
 
-	if (!gpio_is_valid(gpio)) {
+	if (!desc) {
 		WARN_ON(extra_checks);
 		return;
 	}
 
-	gpio_unexport(gpio);
+	gpiod_unexport(desc);
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip && test_bit(FLAG_REQUESTED, &desc->flags)) {
 		if (chip->free) {
 			spin_unlock_irqrestore(&gpio_lock, flags);
 			might_sleep_if(chip->can_sleep);
-			chip->free(chip, gpio - chip->base);
+			chip->free(chip, gpio_chip_hwgpio(desc));
 			spin_lock_irqsave(&gpio_lock, flags);
 		}
 		desc_set_label(desc, NULL);
@@ -1380,6 +1457,11 @@ void gpio_free(unsigned gpio)
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 }
+
+void gpio_free(unsigned gpio)
+{
+	gpiod_free(gpio_to_desc(gpio));
+}
 EXPORT_SYMBOL_GPL(gpio_free);
 
 /**
@@ -1390,29 +1472,32 @@ EXPORT_SYMBOL_GPL(gpio_free);
  */
 int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 {
+	struct gpio_desc *desc;
 	int err;
 
-	err = gpio_request(gpio, label);
+	desc = gpio_to_desc(gpio);
+
+	err = gpiod_request(desc, label);
 	if (err)
 		return err;
 
 	if (flags & GPIOF_OPEN_DRAIN)
-		set_bit(FLAG_OPEN_DRAIN, &gpio_desc[gpio].flags);
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
 
 	if (flags & GPIOF_OPEN_SOURCE)
-		set_bit(FLAG_OPEN_SOURCE, &gpio_desc[gpio].flags);
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
 
 	if (flags & GPIOF_DIR_IN)
-		err = gpio_direction_input(gpio);
+		err = gpiod_direction_input(desc);
 	else
-		err = gpio_direction_output(gpio,
+		err = gpiod_direction_output(desc,
 				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
 
 	if (err)
 		goto free_gpio;
 
 	if (flags & GPIOF_EXPORT) {
-		err = gpio_export(gpio, flags & GPIOF_EXPORT_CHANGEABLE);
+		err = gpiod_export(desc, flags & GPIOF_EXPORT_CHANGEABLE);
 		if (err)
 			goto free_gpio;
 	}
@@ -1420,7 +1505,7 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 	return 0;
 
  free_gpio:
-	gpio_free(gpio);
+	gpiod_free(desc);
 	return err;
 }
 EXPORT_SYMBOL_GPL(gpio_request_one);
@@ -1476,13 +1561,14 @@ EXPORT_SYMBOL_GPL(gpio_free_array);
 const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
 	unsigned gpio = chip->base + offset;
+	struct gpio_desc *desc = &gpio_desc[gpio];
 
-	if (!gpio_is_valid(gpio) || gpio_desc[gpio].chip != chip)
+	if (!gpio_is_valid(gpio) || desc->chip != chip)
 		return NULL;
-	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
+	if (test_bit(FLAG_REQUESTED, &desc->flags) == 0)
 		return NULL;
 #ifdef CONFIG_DEBUG_FS
-	return gpio_desc[gpio].label;
+	return desc->label;
 #else
 	return "?";
 #endif
@@ -1499,24 +1585,21 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
  * rely on gpio_request() having been called beforehand.
  */
 
-int gpio_direction_input(unsigned gpio)
+static int gpiod_direction_input(struct gpio_desc *desc)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
+	int			offset;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
+	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
 
@@ -1526,11 +1609,12 @@ int gpio_direction_input(unsigned gpio)
 
 	might_sleep_if(chip->can_sleep);
 
+	offset = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, gpio);
+		status = chip->request(chip, offset);
 		if (status < 0) {
 			pr_debug("GPIO-%d: chip request fail, %d\n",
-				chip->base + gpio, status);
+				desc_to_gpio(desc), status);
 			/* and it's not available to anyone else ...
 			 * gpio_request() is the fully clean solution.
 			 */
@@ -1538,48 +1622,54 @@ int gpio_direction_input(unsigned gpio)
 		}
 	}
 
-	status = chip->direction_input(chip, gpio);
+	status = chip->direction_input(chip, offset);
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
 
-	trace_gpio_direction(chip->base + gpio, 1, status);
+	trace_gpio_direction(desc_to_gpio(desc), 1, status);
 lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
+	if (status) {
+		int gpio = -1;
+		if (desc)
+			gpio = desc_to_gpio(desc);
 		pr_debug("%s: gpio-%d status %d\n",
 			__func__, gpio, status);
+	}
 	return status;
 }
+
+int gpio_direction_input(unsigned gpio)
+{
+	return gpiod_direction_input(gpio_to_desc(gpio));
+}
 EXPORT_SYMBOL_GPL(gpio_direction_input);
 
-int gpio_direction_output(unsigned gpio, int value)
+static int gpiod_direction_output(struct gpio_desc *desc, int value)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
+	int offset;
 
 	/* Open drain pin should not be driven to 1 */
 	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
-		return gpio_direction_input(gpio);
+		return gpiod_direction_input(desc);
 
 	/* Open source pin should not be driven to 0 */
 	if (!value && test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
-		return gpio_direction_input(gpio);
+		return gpiod_direction_input(desc);
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
+	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
 
@@ -1589,11 +1679,12 @@ int gpio_direction_output(unsigned gpio, int value)
 
 	might_sleep_if(chip->can_sleep);
 
+	offset = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, gpio);
+		status = chip->request(chip, offset);
 		if (status < 0) {
 			pr_debug("GPIO-%d: chip request fail, %d\n",
-				chip->base + gpio, status);
+				desc_to_gpio(desc), status);
 			/* and it's not available to anyone else ...
 			 * gpio_request() is the fully clean solution.
 			 */
@@ -1601,20 +1692,29 @@ int gpio_direction_output(unsigned gpio, int value)
 		}
 	}
 
-	status = chip->direction_output(chip, gpio, value);
+	status = chip->direction_output(chip, offset, value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
-	trace_gpio_value(chip->base + gpio, 0, value);
-	trace_gpio_direction(chip->base + gpio, 0, status);
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	trace_gpio_direction(desc_to_gpio(desc), 0, status);
 lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
+	if (status) {
+		int gpio = -1;
+		if (desc)
+			gpio = desc_to_gpio(desc);
 		pr_debug("%s: gpio-%d status %d\n",
 			__func__, gpio, status);
+	}
 	return status;
 }
+
+int gpio_direction_output(unsigned gpio, int value)
+{
+	return gpiod_direction_output(gpio_to_desc(gpio), value);
+}
 EXPORT_SYMBOL_GPL(gpio_direction_output);
 
 /**
@@ -1622,24 +1722,22 @@ EXPORT_SYMBOL_GPL(gpio_direction_output);
  * @gpio: the gpio to set debounce time
  * @debounce: debounce time is microseconds
  */
-int gpio_set_debounce(unsigned gpio, unsigned debounce)
+static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
+	int			offset;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->set_debounce)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
+
+	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
 
@@ -1649,16 +1747,26 @@ int gpio_set_debounce(unsigned gpio, unsigned debounce)
 
 	might_sleep_if(chip->can_sleep);
 
-	return chip->set_debounce(chip, gpio, debounce);
+	offset = gpio_chip_hwgpio(desc);
+	return chip->set_debounce(chip, offset, debounce);
 
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
+	if (status) {
+		int gpio = -1;
+		if (desc)
+			gpio = desc_to_gpio(desc);
 		pr_debug("%s: gpio-%d status %d\n",
 			__func__, gpio, status);
+	}
 
 	return status;
 }
+
+int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
+}
 EXPORT_SYMBOL_GPL(gpio_set_debounce);
 
 /* I/O calls are only valid after configuration completed; the relevant
@@ -1692,18 +1800,25 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
  * It returns the zero or nonzero value provided by the associated
  * gpio_chip.get() method; or zero if no such method is provided.
  */
-int __gpio_get_value(unsigned gpio)
+static int gpiod_get_value(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
+	int offset;
 
-	chip = gpio_to_chip(gpio);
+	chip = desc->chip;
+	offset = gpio_chip_hwgpio(desc);
 	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(chip->can_sleep);
-	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
-	trace_gpio_value(gpio, 1, value);
+	value = chip->get ? chip->get(chip, offset) : 0;
+	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
+
+int __gpio_get_value(unsigned gpio)
+{
+	return gpiod_get_value(gpio_to_desc(gpio));
+}
 EXPORT_SYMBOL_GPL(__gpio_get_value);
 
 /*
@@ -1712,23 +1827,25 @@ EXPORT_SYMBOL_GPL(__gpio_get_value);
  * @chip: Gpio chip.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
-static void _gpio_set_open_drain_value(unsigned gpio,
-			struct gpio_chip *chip, int value)
+static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
 {
 	int err = 0;
+	struct gpio_chip *chip = desc->chip;
+	int offset = gpio_chip_hwgpio(desc);
+
 	if (value) {
-		err = chip->direction_input(chip, gpio - chip->base);
+		err = chip->direction_input(chip, offset);
 		if (!err)
-			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_output(chip, gpio - chip->base, 0);
+		err = chip->direction_output(chip, offset, 0);
 		if (!err)
-			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			set_bit(FLAG_IS_OUT, &desc->flags);
 	}
-	trace_gpio_direction(gpio, value, err);
+	trace_gpio_direction(desc_to_gpio(desc), value, err);
 	if (err < 0)
 		pr_err("%s: Error in set_value for open drain gpio%d err %d\n",
-					__func__, gpio, err);
+					__func__, desc_to_gpio(desc), err);
 }
 
 /*
@@ -1737,26 +1854,27 @@ static void _gpio_set_open_drain_value(unsigned gpio,
  * @chip: Gpio chip.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
-static void _gpio_set_open_source_value(unsigned gpio,
-			struct gpio_chip *chip, int value)
+static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 {
 	int err = 0;
+	struct gpio_chip *chip = desc->chip;
+	int offset = gpio_chip_hwgpio(desc);
+
 	if (value) {
-		err = chip->direction_output(chip, gpio - chip->base, 1);
+		err = chip->direction_output(chip, offset, 1);
 		if (!err)
-			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_input(chip, gpio - chip->base);
+		err = chip->direction_input(chip, offset);
 		if (!err)
-			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
-	trace_gpio_direction(gpio, !value, err);
+	trace_gpio_direction(desc_to_gpio(desc), !value, err);
 	if (err < 0)
 		pr_err("%s: Error in set_value for open source gpio%d err %d\n",
-					__func__, gpio, err);
+					__func__, desc_to_gpio(desc), err);
 }
 
-
 /**
  * __gpio_set_value() - assign a gpio's value
  * @gpio: gpio whose value will be assigned
@@ -1766,20 +1884,25 @@ static void _gpio_set_open_source_value(unsigned gpio,
  * This is used directly or indirectly to implement gpio_set_value().
  * It invokes the associated gpio_chip.set() method.
  */
-void __gpio_set_value(unsigned gpio, int value)
+static void gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
-	chip = gpio_to_chip(gpio);
+	chip = desc->chip;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(chip->can_sleep);
-	trace_gpio_value(gpio, 0, value);
-	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
-		_gpio_set_open_drain_value(gpio, chip, value);
-	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
-		_gpio_set_open_source_value(gpio, chip, value);
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
+		_gpio_set_open_drain_value(desc, value);
+	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
+		_gpio_set_open_source_value(desc, value);
 	else
-		chip->set(chip, gpio - chip->base, value);
+		chip->set(chip, gpio_chip_hwgpio(desc), value);
+}
+
+void __gpio_set_value(unsigned gpio, int value)
+{
+	return gpiod_set_value(gpio_to_desc(gpio), value);
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
@@ -1791,14 +1914,15 @@ EXPORT_SYMBOL_GPL(__gpio_set_value);
  * This is used directly or indirectly to implement gpio_cansleep().  It
  * returns nonzero if access reading or writing the GPIO value can sleep.
  */
-int __gpio_cansleep(unsigned gpio)
+static int gpiod_cansleep(struct gpio_desc *desc)
 {
-	struct gpio_chip	*chip;
-
 	/* only call this on GPIOs that are valid! */
-	chip = gpio_to_chip(gpio);
+	return desc->chip->can_sleep;
+}
 
-	return chip->can_sleep;
+int __gpio_cansleep(unsigned gpio)
+{
+	return gpiod_cansleep(gpio_to_desc(gpio));
 }
 EXPORT_SYMBOL_GPL(__gpio_cansleep);
 
@@ -1811,50 +1935,67 @@ EXPORT_SYMBOL_GPL(__gpio_cansleep);
  * It returns the number of the IRQ signaled by this (input) GPIO,
  * or a negative errno.
  */
-int __gpio_to_irq(unsigned gpio)
+static int gpiod_to_irq(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
+	int			offset;
 
-	chip = gpio_to_chip(gpio);
-	return chip->to_irq ? chip->to_irq(chip, gpio - chip->base) : -ENXIO;
+	chip = desc->chip;
+	offset = gpio_chip_hwgpio(desc);
+	return chip->to_irq ? chip->to_irq(chip, offset) : -ENXIO;
 }
-EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
+int __gpio_to_irq(unsigned gpio)
+{
+	return gpiod_to_irq(gpio_to_desc(gpio));
+}
+EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
 
 /* There's no value in making it easy to inline GPIO calls that may sleep.
  * Common examples include ones connected to I2C or SPI chips.
  */
 
-int gpio_get_value_cansleep(unsigned gpio)
+static int gpiod_get_value_cansleep(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
+	int offset;
 
 	might_sleep_if(extra_checks);
-	chip = gpio_to_chip(gpio);
-	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
-	trace_gpio_value(gpio, 1, value);
+	chip = desc->chip;
+	offset = gpio_chip_hwgpio(desc);
+	value = chip->get ? chip->get(chip, offset) : 0;
+	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
+
+int gpio_get_value_cansleep(unsigned gpio)
+{
+	return gpiod_get_value_cansleep(gpio_to_desc(gpio));
+}
 EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
 
-void gpio_set_value_cansleep(unsigned gpio, int value)
+static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
 	might_sleep_if(extra_checks);
-	chip = gpio_to_chip(gpio);
-	trace_gpio_value(gpio, 0, value);
-	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
-		_gpio_set_open_drain_value(gpio, chip, value);
-	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
-		_gpio_set_open_source_value(gpio, chip, value);
+	chip = desc->chip;
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	if (test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
+		_gpio_set_open_drain_value(desc, value);
+	else if (test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
+		_gpio_set_open_source_value(desc, value);
 	else
-		chip->set(chip, gpio - chip->base, value);
+		chip->set(chip, gpio_chip_hwgpio(desc), value);
 }
-EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 
+void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	return gpiod_set_value_cansleep(gpio_to_desc(gpio), value);
+}
+EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 
 #ifdef CONFIG_DEBUG_FS
 
@@ -1869,7 +2010,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
 			continue;
 
-		gpio_get_direction(gpio);
+		gpiod_get_direction(gdesc);
 		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
 		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
 			gpio, gdesc->label,
-- 
1.8.1.1

