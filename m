Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3K1Ir3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:47:29 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8095 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3K1Ir0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:47:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 28 Nov 2013 00:44:53 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: better lookup method for platform GPIOs
Date: Thu, 28 Nov 2013 17:46:28 +0900
Message-ID: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the format of the platform GPIO lookup tables to make them less
confusing and improve lookup efficiency.

The previous format was a single linked-list that required to compare
the device name and function ID of every single GPIO defined for each
lookup. Switch that to a list of per-device tables, so that the lookup
can be done in two steps, omitting the GPIOs that are not relevant for a
particular device.

The matching rules are now defined as follows:
- The device name must match *exactly*, and can be NULL for GPIOs not
  assigned to a particular device,
- If the function ID in the lookup table is NULL, the con_id argument of
  gpiod_get() will not be used for lookup. However, if it is defined, it
  must match exactly.
- The index must always match.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Let's change this bad design before more users start using it. ;)

 Documentation/gpio/board.txt | 25 ++++++-----
 drivers/gpio/gpiolib.c       | 99 ++++++++++++++++++++++----------------------
 include/linux/gpio/driver.h  | 22 +++++-----
 3 files changed, 76 insertions(+), 70 deletions(-)

diff --git a/Documentation/gpio/board.txt b/Documentation/gpio/board.txt
index 0d03506f2cc5..630d37b21934 100644
--- a/Documentation/gpio/board.txt
+++ b/Documentation/gpio/board.txt
@@ -72,10 +72,11 @@ where
 
   - chip_label is the label of the gpiod_chip instance providing the GPIO
   - chip_hwnum is the hardware number of the GPIO within the chip
-  - dev_id is the identifier of the device that will make use of this GPIO. If
-	NULL, the GPIO will be available to all devices.
+  - dev_id is the identifier of the device that will make use of this GPIO. It
+	can be NULL, in which case it will be matched for calls to gpiod_get()
+	with a NULL device.
   - con_id is the name of the GPIO function from the device point of view. It
-	can be NULL.
+	can be NULL, in which case it will match any function.
   - idx is the index of the GPIO within the function.
   - flags is defined to specify the following properties:
 	* GPIOF_ACTIVE_LOW	- to configure the GPIO as active-low
@@ -88,16 +89,20 @@ Note that GPIO_LOOKUP() is just a shortcut to GPIO_LOOKUP_IDX() where idx = 0.
 
 A lookup table can then be defined as follows:
 
-	struct gpiod_lookup gpios_table[] = {
-	GPIO_LOOKUP_IDX("gpio.0", 15, "foo.0", "led", 0, GPIO_ACTIVE_HIGH),
-	GPIO_LOOKUP_IDX("gpio.0", 16, "foo.0", "led", 1, GPIO_ACTIVE_HIGH),
-	GPIO_LOOKUP_IDX("gpio.0", 17, "foo.0", "led", 2, GPIO_ACTIVE_HIGH),
-	GPIO_LOOKUP("gpio.0", 1, "foo.0", "power", GPIO_ACTIVE_LOW),
-	};
+struct gpiod_lookup_table gpios_table = {
+	.dev_id = "foo.0",
+	.size = 4,
+	.table = {
+	GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
+	GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
+	GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
+	GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),
+	},
+};
 
 And the table can be added by the board code as follows:
 
-	gpiod_add_table(gpios_table, ARRAY_SIZE(gpios_table));
+	gpiod_add_lookup_table(&gpios_table);
 
 The driver controlling "foo.0" will then be able to obtain its GPIOs as follows:
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f72618ba716a..568db6ab7d04 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2259,18 +2259,14 @@ void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
 
 /**
- * gpiod_add_table() - register GPIO device consumers
- * @table: array of consumers to register
- * @num: number of consumers in table
+ * gpiod_add_lookup_table() - register GPIO device consumers
+ * @table: table of consumers to register
  */
-void gpiod_add_table(struct gpiod_lookup *table, size_t size)
+void gpiod_add_lookup_table(struct gpiod_lookup_table *table)
 {
 	mutex_lock(&gpio_lookup_lock);
 
-	while (size--) {
-		list_add_tail(&table->list, &gpio_lookup_list);
-		table++;
-	}
+	list_add_tail(&table->list, &gpio_lookup_list);
 
 	mutex_unlock(&gpio_lookup_lock);
 }
@@ -2326,72 +2322,77 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
 	return desc;
 }
 
-static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
-				    unsigned int idx,
-				    enum gpio_lookup_flags *flags)
+static struct gpiod_lookup_table *gpiod_find_lookup_table(struct device *dev)
 {
 	const char *dev_id = dev ? dev_name(dev) : NULL;
-	struct gpio_desc *desc = ERR_PTR(-ENODEV);
-	unsigned int match, best = 0;
-	struct gpiod_lookup *p;
+	struct gpiod_lookup_table *table;
 
 	mutex_lock(&gpio_lookup_lock);
 
-	list_for_each_entry(p, &gpio_lookup_list, list) {
-		match = 0;
+	list_for_each_entry(table, &gpio_lookup_list, list) {
+		if (table->dev_id && dev_id && strcmp(table->dev_id, dev_id))
+			continue;
 
-		if (p->dev_id) {
-			if (!dev_id || strcmp(p->dev_id, dev_id))
-				continue;
+		if (dev_id != table->dev_id)
+			continue;
 
-			match += 2;
-		}
+		return table;
+	}
 
-		if (p->con_id) {
-			if (!con_id || strcmp(p->con_id, con_id))
-				continue;
+	mutex_unlock(&gpio_lookup_lock);
 
-			match += 1;
-		}
+	return NULL;
+}
 
-		if (p->idx != idx)
-			continue;
+static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
+				    unsigned int idx,
+				    enum gpio_lookup_flags *flags)
+{
+	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	struct gpiod_lookup_table *table;
+	int i;
 
-		if (match > best) {
-			struct gpio_chip *chip;
 
-			chip = find_chip_by_name(p->chip_label);
+	table = gpiod_find_lookup_table(dev);
+	if (!table)
+		return desc;
 
-			if (!chip) {
-				dev_warn(dev, "cannot find GPIO chip %s\n",
-					 p->chip_label);
-				continue;
-			}
+	for (i = 0; i < table->size; i++) {
+		struct gpio_chip *chip;
+		struct gpiod_lookup *p = &table->table[i];
 
-			if (chip->ngpio <= p->chip_hwnum) {
-				dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
-					 chip->label, chip->ngpio);
+		if (p->idx != idx)
+			continue;
+
+		if (p->con_id) {
+			if (!con_id || strcmp(p->con_id, con_id))
 				continue;
-			}
+		}
 
-			desc = gpio_to_desc(chip->base + p->chip_hwnum);
-			*flags = p->flags;
+		chip = find_chip_by_name(p->chip_label);
 
-			if (match != 3)
-				best = match;
-			else
-				break;
+		if (!chip) {
+			dev_warn(dev, "cannot find GPIO chip %s\n",
+				 p->chip_label);
+			continue;
 		}
-	}
 
-	mutex_unlock(&gpio_lookup_lock);
+		if (chip->ngpio <= p->chip_hwnum) {
+			dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
+				 chip->label, chip->ngpio);
+			continue;
+		}
+
+		desc = gpiochip_offset_to_desc(chip, p->chip_hwnum);
+		*flags = p->flags;
+	}
 
 	return desc;
 }
 
 /**
  * gpio_get - obtain a GPIO for a given GPIO function
- * @dev:	GPIO consumer
+ * @dev:	GPIO consumer, can be NULL for system-global GPIOs
  * @con_id:	function within the GPIO consumer
  *
  * Return the GPIO descriptor corresponding to the function con_id of device
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 3ea2cf6b0e6c..44893ef40817 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -140,7 +140,6 @@ enum gpio_lookup_flags {
  * platform data.
  */
 struct gpiod_lookup {
-	struct list_head list;
 	/*
 	 * name of the chip the GPIO belongs to
 	 */
@@ -150,10 +149,6 @@ struct gpiod_lookup {
 	 */
 	u16 chip_hwnum;
 	/*
-	 * name of device that can claim this GPIO
-	 */
-	const char *dev_id;
-	/*
 	 * name of the GPIO from the device's point of view
 	 */
 	const char *con_id;
@@ -167,28 +162,33 @@ struct gpiod_lookup {
 	enum gpio_lookup_flags flags;
 };
 
+struct gpiod_lookup_table {
+	struct list_head list;
+	const char *dev_id;
+	unsigned int size;
+	struct gpiod_lookup table[];
+};
+
 /*
  * Simple definition of a single GPIO under a con_id
  */
-#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _dev_id, _con_id, _flags) \
-	GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _dev_id, _con_id, 0, _flags)
+#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _con_id, _flags) \
+	GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _con_id, 0, _flags)
 
 /*
  * Use this macro if you need to have several GPIOs under the same con_id.
  * Each GPIO needs to use a different index and can be accessed using
  * gpiod_get_index()
  */
-#define GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _dev_id, _con_id, _idx, \
-			_flags)                                           \
+#define GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _con_id, _idx, _flags)  \
 {                                                                         \
 	.chip_label = _chip_label,                                        \
 	.chip_hwnum = _chip_hwnum,                                        \
-	.dev_id = _dev_id,                                                \
 	.con_id = _con_id,                                                \
 	.idx = _idx,                                                      \
 	.flags = _flags,                                                  \
 }
 
-void gpiod_add_table(struct gpiod_lookup *table, size_t size);
+void gpiod_add_lookup_table(struct gpiod_lookup_table *table);
 
 #endif
-- 
1.8.4.2

