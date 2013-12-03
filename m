Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3LCDUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:20:22 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6373 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LCDUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:20:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Dec 2013 19:13:43 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3] gpio: better lookup method for platform GPIOs
Date: Tue, 3 Dec 2013 12:20:11 +0900
Message-ID: <1386040811-27946-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <CAAVeFu+LLR-EwiRskE_VBQwPrnXAdt-ahfcH08mOXsFuStFMJg@mail.gmail.com>
References: <CAAVeFu+LLR-EwiRskE_VBQwPrnXAdt-ahfcH08mOXsFuStFMJg@mail.gmail.com>
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
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Changes since v2:
- Removed size member of the gpiod_lookup_table struct (thanks Heikki!)
- Added Andy's reviewed-by

 Documentation/gpio/board.txt |  28 ++++++-----
 drivers/gpio/gpiolib.c       | 108 +++++++++++++++++++++++--------------------
 include/linux/gpio/driver.h  |  21 ++++-----
 3 files changed, 85 insertions(+), 72 deletions(-)

diff --git a/Documentation/gpio/board.txt b/Documentation/gpio/board.txt
index 0d03506f2cc5..ba169faad5c6 100644
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
@@ -86,18 +87,23 @@ In the future, these flags might be extended to support more properties.
 
 Note that GPIO_LOOKUP() is just a shortcut to GPIO_LOOKUP_IDX() where idx = 0.
 
-A lookup table can then be defined as follows:
+A lookup table can then be defined as follows, with an empty entry defining its
+end:
 
-	struct gpiod_lookup gpios_table[] = {
-	GPIO_LOOKUP_IDX("gpio.0", 15, "foo.0", "led", 0, GPIO_ACTIVE_HIGH),
-	GPIO_LOOKUP_IDX("gpio.0", 16, "foo.0", "led", 1, GPIO_ACTIVE_HIGH),
-	GPIO_LOOKUP_IDX("gpio.0", 17, "foo.0", "led", 2, GPIO_ACTIVE_HIGH),
-	GPIO_LOOKUP("gpio.0", 1, "foo.0", "power", GPIO_ACTIVE_LOW),
-	};
+struct gpiod_lookup_table gpios_table = {
+	.dev_id = "foo.0",
+	.table = {
+		GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),
+		{ },
+	},
+};
 
 And the table can be added by the board code as follows:
 
-	gpiod_add_table(gpios_table, ARRAY_SIZE(gpios_table));
+	gpiod_add_lookup_table(&gpios_table);
 
 The driver controlling "foo.0" will then be able to obtain its GPIOs as follows:
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f72618ba716a..ea95b42c6154 100644
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
@@ -2326,72 +2322,84 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
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
+		if (table->dev_id && dev_id) {
+			/*
+			 * Valid strings on both ends, must be identical to have
+			 * a match
+			 */
+			if (!strcmp(table->dev_id, dev_id))
+				goto found;
+		} else {
+			/*
+			 * One of the pointers is NULL, so both must be to have
+			 * a match
+			 */
+			if (dev_id == table->dev_id)
+				goto found;
+		}
+	}
+	table = NULL;
 
-		if (p->dev_id) {
-			if (!dev_id || strcmp(p->dev_id, dev_id))
-				continue;
+found:
+	mutex_unlock(&gpio_lookup_lock);
+	return table;
+}
 
-			match += 2;
-		}
+static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
+				    unsigned int idx,
+				    enum gpio_lookup_flags *flags)
+{
+	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	struct gpiod_lookup_table *table;
+	struct gpiod_lookup *p;
 
-		if (p->con_id) {
-			if (!con_id || strcmp(p->con_id, con_id))
-				continue;
+	table = gpiod_find_lookup_table(dev);
+	if (!table)
+		return desc;
 
-			match += 1;
-		}
+	for (p = &table->table[0]; p->chip_label; p++) {
+		struct gpio_chip *chip;
 
+		/* idx must always match exactly */
 		if (p->idx != idx)
 			continue;
 
-		if (match > best) {
-			struct gpio_chip *chip;
-
-			chip = find_chip_by_name(p->chip_label);
-
-			if (!chip) {
-				dev_warn(dev, "cannot find GPIO chip %s\n",
-					 p->chip_label);
-				continue;
-			}
+		/* If the lookup entry has a con_id, require exact match */
+		if (p->con_id && (!con_id || strcmp(p->con_id, con_id)))
+			continue;
 
-			if (chip->ngpio <= p->chip_hwnum) {
-				dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
-					 chip->label, chip->ngpio);
-				continue;
-			}
+		chip = find_chip_by_name(p->chip_label);
 
-			desc = gpio_to_desc(chip->base + p->chip_hwnum);
-			*flags = p->flags;
+		if (!chip) {
+			dev_warn(dev, "cannot find GPIO chip %s\n",
+				 p->chip_label);
+			continue;
+		}
 
-			if (match != 3)
-				best = match;
-			else
-				break;
+		if (chip->ngpio <= p->chip_hwnum) {
+			dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
+				 chip->label, chip->ngpio);
+			continue;
 		}
-	}
 
-	mutex_unlock(&gpio_lookup_lock);
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
index 3ea2cf6b0e6c..7193f43d0764 100644
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
@@ -167,28 +162,32 @@ struct gpiod_lookup {
 	enum gpio_lookup_flags flags;
 };
 
+struct gpiod_lookup_table {
+	struct list_head list;
+	const char *dev_id;
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

