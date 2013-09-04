Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467Ab3IDLap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:30:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9017 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934565Ab3IDLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:30:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Sep 2013 04:30:38 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 4/5] gpiolib: add gpiod_get() and gpiod_put() functions
Date: Wed, 4 Sep 2013 20:29:28 +0900
Message-ID: <1378294169-22661-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpiod_get() and gpiod_put() functions that provide safer handling of
GPIOs.

These functions put the GPIO framework in line with the conventions of
other frameworks in the kernel, and help ensure every GPIO is declared
properly and valid while it is used.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c        | 166 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h |   8 ++
 include/linux/gpio/driver.h   |  38 ++++++++++
 3 files changed, 212 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e255eee..4a91e03 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -69,6 +69,8 @@ static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
 #define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
 
+static DEFINE_MUTEX(gpio_lookup_lock);
+static LIST_HEAD(gpio_lookup_list);
 static LIST_HEAD(gpio_chips);
 
 #ifdef CONFIG_GPIO_SYSFS
@@ -1997,6 +1999,170 @@ void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
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
+				      unsigned long *flags)
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
+	desc = of_get_named_gpiod_flags(dev->of_node, prop_name, 0, &of_flags);
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
+static struct device_node *of_find_gpio(struct device *dev, const char *id
+					unsigned long flags)
+{
+	return NULL;
+}
+#endif
+
+static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
+				    unsigned long *flags)
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
+struct gpio_desc *__must_check gpiod_get(struct device *dev, const char *con_id)
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
+		desc = of_find_gpio(dev, con_id, &flags);
+	} else {
+		dev_dbg(dev, "using lookup tables for GPIO lookup");
+		desc = gpiod_find(dev, con_id, &flags);
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
+EXPORT_SYMBOL_GPL(gpiod_get);
+
+void gpiod_put(struct gpio_desc *desc)
+{
+	gpiod_free(desc);
+}
+EXPORT_SYMBOL_GPL(gpiod_put);
+
 #ifdef CONFIG_DEBUG_FS
 
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index ba39e09..da9cdb2 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -18,6 +18,14 @@ struct gpio_chip;
  */
 struct gpio_desc;
 
+struct gpio_desc *__must_check gpiod_get(struct device *dev,
+					 const char *con_id);
+void gpiod_put(struct gpio_desc *desc);
+
+struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
+					      const char *con_id);
+void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
+
 struct gpio_desc *gpio_to_desc(unsigned gpio);
 int desc_to_gpio(const struct gpio_desc *desc);
 struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index b84ca26..5aa26b5 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -121,5 +121,43 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 extern struct gpio_chip *gpiochip_find(void *data,
 			      int (*match)(struct gpio_chip *chip, void *data));
 
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
+	 * mask of GPIOF_* values
+	 */
+	unsigned long flags;
+};
+
+#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _dev_id, _con_id, flags) \
+{                                                                      \
+	.chip_label = _chip_label,                                     \
+	.chip_hwnum = _chip_hwnum,                                     \
+	.dev_id = _dev_id,                                             \
+	.con_id = _con_id,                                             \
+	.flags = flags,                                                \
+}
+
+void gpiod_add_table(struct gpiod_lookup *table, size_t size);
 
 #endif
-- 
1.8.4

