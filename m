Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab3JQRYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:24:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7856 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab3JQRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:23:44 -0400
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
Subject: [PATCH v3 3/3] gpiolib: add gpiod_get() and gpiod_put() functions
Date: Thu, 17 Oct 2013 10:21:38 -0700
Message-ID: <1382030498-23465-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
References: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpiod_get(), gpiod_get_index() and gpiod_put() functions that
provide safer management of GPIOs.

These functions put the GPIO framework in line with the conventions of
other frameworks in the kernel, and help ensure every GPIO is declared
properly and valid while it is used.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/devres.c         |  83 +++++++++++++++++
 drivers/gpio/gpiolib.c        | 203 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h |  15 ++++
 include/linux/gpio/driver.h   |  56 ++++++++++++
 4 files changed, 357 insertions(+)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 3e7812f..2caa257 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -19,6 +19,89 @@
 #include <linux/device.h>
 #include <linux/gfp.h>
 
+static void devm_gpiod_release(struct device *dev, void *res)
+{
+	struct gpio_desc **desc = res;
+
+	gpiod_put(*desc);
+}
+
+static int devm_gpiod_match(struct device *dev, void *res, void *data)
+{
+	struct gpio_desc **this = res, **gpio = data;
+
+	return *this == *gpio;
+}
+
+/**
+ * devm_gpiod_get - Resource-managed gpiod_get()
+ * @dev:	GPIO consumer
+ * @con_id:	function within the GPIO consumer
+ *
+ * Managed gpiod_get(). GPIO descriptors returned from this function are
+ * automatically disposed on driver detach. See gpiod_get() for detailed
+ * information about behavior and return values.
+ */
+struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
+					      const char *con_id)
+{
+	return devm_gpiod_get_index(dev, con_id, 0);
+}
+EXPORT_SYMBOL(devm_gpiod_get);
+
+/**
+ * devm_gpiod_get_index - Resource-managed gpiod_get_index()
+ * @dev:	GPIO consumer
+ * @con_id:	function within the GPIO consumer
+ * @idx:	index of the GPIO to obtain in the consumer
+ *
+ * Managed gpiod_get_index(). GPIO descriptors returned from this function are
+ * automatically disposed on driver detach. See gpiod_get_index() for detailed
+ * information about behavior and return values.
+ */
+struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
+						    const char *con_id,
+						    unsigned int idx)
+{
+	struct gpio_desc **dr;
+	struct gpio_desc *desc;
+
+	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpiod_desc *),
+			  GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	desc = gpiod_get_index(dev, con_id, idx);
+	if (IS_ERR(desc)) {
+		devres_free(dr);
+		return desc;
+	}
+
+	*dr = desc;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_gpiod_get_index);
+
+/**
+ * devm_gpiod_put - Resource-managed gpiod_put()
+ * @desc:	GPIO descriptor to dispose of
+ *
+ * Dispose of a GPIO descriptor obtained with devm_gpiod_get() or
+ * devm_gpiod_get_index(). Normally this function will not be called as the GPIO
+ * will be disposed of by the resource management code.
+ */
+void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
+{
+	WARN_ON(devres_release(dev, devm_gpiod_release, devm_gpiod_match,
+		&desc));
+}
+EXPORT_SYMBOL(devm_gpiod_put);
+
+
+
+
 static void devm_gpio_release(struct device *dev, void *res)
 {
 	unsigned *gpio = res;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 224abdc..9263c7b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -70,6 +70,8 @@ static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
 #define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
 
+static DEFINE_MUTEX(gpio_lookup_lock);
+static LIST_HEAD(gpio_lookup_list);
 static LIST_HEAD(gpio_chips);
 
 #ifdef CONFIG_GPIO_SYSFS
@@ -2192,6 +2194,207 @@ void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 }
 EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
 
+/**
+ * gpiod_add_table() - register GPIO device consumers
+ * @table: array of consumers to register
+ * @num: number of consumers in table
+ */
+void gpiod_add_table(struct gpiod_lookup *table, size_t size)
+{
+	mutex_lock(&gpio_lookup_lock);
+
+	while (size--) {
+		list_add_tail(&table->list, &gpio_lookup_list);
+		table++;
+	}
+
+	mutex_unlock(&gpio_lookup_lock);
+}
+
+/*
+ * Caller must have a acquired gpio_lookup_lock
+ */
+static struct gpio_chip *find_chip_by_name(const char *name)
+{
+	struct gpio_chip *chip = NULL;
+
+	list_for_each_entry(chip, &gpio_lookup_list, list) {
+		if (chip->label == NULL)
+			continue;
+		if (!strcmp(chip->label, name))
+			break;
+	}
+
+	return chip;
+}
+
+#ifdef CONFIG_OF
+static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
+				      unsigned int idx, unsigned long *flags)
+{
+	char prop_name[32]; /* 32 is max size of property name */
+	enum of_gpio_flags of_flags;
+	struct gpio_desc *desc;
+
+	if (con_id)
+		snprintf(prop_name, 32, "%s-gpios", con_id);
+	else
+		snprintf(prop_name, 32, "gpios");
+
+	desc = of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
+					&of_flags);
+
+	if (IS_ERR(desc))
+		return desc;
+
+	if (of_flags & OF_GPIO_ACTIVE_LOW)
+		*flags |= GPIOF_ACTIVE_LOW;
+
+	return desc;
+}
+#else
+static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
+				      unsigned int idx, unsigned long *flags)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
+static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
+				    unsigned int idx, unsigned long *flags)
+{
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	unsigned int match, best = 0;
+	struct gpiod_lookup *p;
+
+	mutex_lock(&gpio_lookup_lock);
+
+	list_for_each_entry(p, &gpio_lookup_list, list) {
+		match = 0;
+
+		if (p->dev_id) {
+			if (!dev_id || strcmp(p->dev_id, dev_id))
+				continue;
+
+			match += 2;
+		}
+
+		if (p->con_id) {
+			if (!con_id || strcmp(p->con_id, con_id))
+				continue;
+
+			match += 1;
+		}
+
+		if (p->idx != idx)
+			continue;
+
+		if (match > best) {
+			struct gpio_chip *chip;
+
+			chip = find_chip_by_name(p->chip_label);
+
+			if (!chip) {
+				dev_warn(dev, "cannot find GPIO chip %s\n",
+					 p->chip_label);
+				continue;
+			}
+
+			if (chip->ngpio >= p->chip_hwnum) {
+				dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
+					 chip->label, chip->ngpio);
+				continue;
+			}
+
+			desc = gpio_to_desc(chip->base + p->chip_hwnum);
+			*flags = p->flags;
+
+			if (match != 3)
+				best = match;
+			else
+				break;
+		}
+	}
+
+	mutex_unlock(&gpio_lookup_lock);
+
+	return desc;
+}
+
+/**
+ * gpio_get - obtain a GPIO for a given GPIO function
+ * @dev:	GPIO consumer
+ * @con_id:	function within the GPIO consumer
+ *
+ * Return the GPIO descriptor corresponding to the function con_id of device
+ * dev, or an IS_ERR() condition if an error occured.
+ */
+struct gpio_desc *__must_check gpiod_get(struct device *dev, const char *con_id)
+{
+	return gpiod_get_index(dev, con_id, 0);
+}
+EXPORT_SYMBOL_GPL(gpiod_get);
+
+/**
+ * gpiod_get_index - obtain a GPIO from a multi-index GPIO function
+ * @dev:	GPIO consumer
+ * @con_id:	function within the GPIO consumer
+ * @idx:	index of the GPIO to obtain in the consumer
+ *
+ * This variant of gpiod_get() allows to access GPIOs other than the first
+ * defined one for functions that define several GPIOs.
+ *
+ * Return a valid GPIO descriptor, or an IS_ERR() condition in case of error.
+ */
+struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
+					       const char *con_id,
+					       unsigned int idx)
+{
+	struct gpio_desc *desc;
+	int status;
+	unsigned long flags = 0;
+
+	dev_dbg(dev, "GPIO lookup for consumer %s\n", con_id);
+
+	/* Using device tree? */
+	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node) {
+		dev_dbg(dev, "using device tree for GPIO lookup\n");
+		desc = of_find_gpio(dev, con_id, idx, &flags);
+	} else {
+		dev_dbg(dev, "using lookup tables for GPIO lookup");
+		desc = gpiod_find(dev, con_id, idx, &flags);
+	}
+
+	if (IS_ERR(desc)) {
+		dev_warn(dev, "lookup for GPIO %s failed\n", con_id);
+		return desc;
+	}
+
+	status = gpiod_request(desc, con_id);
+
+	if (status < 0)
+		return ERR_PTR(status);
+
+	if (flags & GPIOF_ACTIVE_LOW)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+
+	return desc;
+}
+EXPORT_SYMBOL_GPL(gpiod_get_index);
+
+/**
+ * gpiod_put - dispose of a GPIO descriptor
+ * @desc:	GPIO descriptor to dispose of
+ *
+ * No descriptor can be used after gpiod_put() has been called on it.
+ */
+void gpiod_put(struct gpio_desc *desc)
+{
+	gpiod_free(desc);
+}
+EXPORT_SYMBOL_GPL(gpiod_put);
+
 #ifdef CONFIG_DEBUG_FS
 
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 2088eb5..4d34dbb 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -18,6 +18,21 @@ struct gpio_chip;
  */
 struct gpio_desc;
 
+/* Acquire and dispose GPIOs */
+struct gpio_desc *__must_check gpiod_get(struct device *dev,
+					 const char *con_id);
+struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
+					       const char *con_id,
+					       unsigned int idx);
+void gpiod_put(struct gpio_desc *desc);
+
+struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
+					      const char *con_id);
+struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
+						    const char *con_id,
+						    unsigned int idx);
+void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
+
 int gpiod_get_direction(const struct gpio_desc *desc);
 int gpiod_direction_input(struct gpio_desc *desc);
 int gpiod_direction_output(struct gpio_desc *desc, int value);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 5dc172c..cd9da38 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -124,4 +124,60 @@ extern struct gpio_chip *gpiochip_find(void *data,
 int gpiod_lock_as_irq(struct gpio_desc *desc);
 void gpiod_unlock_as_irq(struct gpio_desc *desc);
 
+/**
+ * Lookup table for associating GPIOs to specific devices and functions using
+ * platform data.
+ */
+struct gpiod_lookup {
+	struct list_head list;
+	/*
+	 * name of the chip the GPIO belongs to
+	 */
+	const char *chip_label;
+	/*
+	 * hardware number (i.e. relative to the chip) of the GPIO
+	 */
+	u16 chip_hwnum;
+	/*
+	 * name of device that can claim this GPIO
+	 */
+	const char *dev_id;
+	/*
+	 * name of the GPIO from the device's point of view
+	 */
+	const char *con_id;
+	/*
+	 * index of the GPIO in case several GPIOs share the same name
+	 */
+	unsigned int idx;
+	/*
+	 * mask of GPIOF_* values
+	 */
+	unsigned long flags;
+};
+
+/*
+ * Simple definition of a single GPIO under a con_id
+ */
+#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _dev_id, _con_id, _flags) \
+	GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _dev_id, _con_id, 0, _flags)
+
+/*
+ * Use this macro if you need to have several GPIOs under the same con_id.
+ * Each GPIO needs to use a different index and can be accessed using
+ * gpiod_get_index()
+ */
+#define GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _dev_id, _con_id, _idx, \
+			_flags)                                           \
+{                                                                         \
+	.chip_label = _chip_label,                                        \
+	.chip_hwnum = _chip_hwnum,                                        \
+	.dev_id = _dev_id,                                                \
+	.con_id = _con_id,                                                \
+	.idx = _idx,                                                      \
+	.flags = _flags,                                                  \
+}
+
+void gpiod_add_table(struct gpiod_lookup *table, size_t size);
+
 #endif
-- 
1.8.4

