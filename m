Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaBIIqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:46:20 -0500
Received: from gnurou.org ([207.192.72.5]:35635 "EHLO mail.gnurou.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751469AbaBIIqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:46:18 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] gpiolib: add gpiochip_get_desc() driver function
Date: Sun,  9 Feb 2014 17:43:54 +0900
Message-Id: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers dealing with a gpio_chip might need to act on its
descriptors directly; one example is pinctrl drivers that need to lock a
GPIO for being used as IRQ using gpiod_lock_as_irq().

This patch exports a gpiochip_get_desc() function that returns the
GPIO descriptor at the requested index. It also sweeps the
gpio_to_chip() function out of the consumer interface since any holder
of a gpio_chip reference can manipulate its GPIOs way beyond what a
consumer should be allowed to do.

As a result, gpio_chip is not visible anymore to simple GPIO consumers.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Jean-Jacques, I think you will want to use this function for locking GPIOs
in the AT91 pinctrl driver. Mika, we talked about this a while ago already,
but here it is finally. Next patch uses it in the GPIO ACPI driver.

 drivers/gpio/gpiolib.c        | 17 +++++++++--------
 include/linux/gpio/consumer.h |  8 --------
 include/linux/gpio/driver.h   | 18 ++++++++++++++++++
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50c4922..f60d74b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -164,16 +164,17 @@ struct gpio_desc *gpio_to_desc(unsigned gpio)
 EXPORT_SYMBOL_GPL(gpio_to_desc);
 
 /**
- * Convert an offset on a certain chip to a corresponding descriptor
+ * Get the GPIO descriptor corresponding to the given hw number for this chip.
  */
-static struct gpio_desc *gpiochip_offset_to_desc(struct gpio_chip *chip,
-						 unsigned int offset)
+struct gpio_desc *gpiochip_get_desc(struct gpio_chip *chip,
+				    u16 hwnum)
 {
-	if (offset >= chip->ngpio)
+	if (hwnum >= chip->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return &chip->desc[offset];
+	return &chip->desc[hwnum];
 }
+EXPORT_SYMBOL_GPL(gpiochip_get_desc);
 
 /**
  * Convert a GPIO descriptor to the integer namespace.
@@ -2161,7 +2162,7 @@ EXPORT_SYMBOL_GPL(gpiod_lock_as_irq);
 
 int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
-	return gpiod_lock_as_irq(gpiochip_offset_to_desc(chip, offset));
+	return gpiod_lock_as_irq(gpiochip_get_desc(chip, offset));
 }
 EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
 
@@ -2183,7 +2184,7 @@ EXPORT_SYMBOL_GPL(gpiod_unlock_as_irq);
 
 void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
-	return gpiod_unlock_as_irq(gpiochip_offset_to_desc(chip, offset));
+	return gpiod_unlock_as_irq(gpiochip_get_desc(chip, offset));
 }
 EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
 
@@ -2404,7 +2405,7 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 			return ERR_PTR(-EINVAL);
 		}
 
-		desc = gpiochip_offset_to_desc(chip, p->chip_hwnum);
+		desc = gpiochip_get_desc(chip, p->chip_hwnum);
 		*flags = p->flags;
 
 		return desc;
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 7a8144f..f6a9cc3 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -5,7 +5,6 @@
 #include <linux/kernel.h>
 
 struct device;
-struct gpio_chip;
 
 /**
  * Opaque descriptor for a GPIO. These are obtained using gpiod_get() and are
@@ -59,7 +58,6 @@ int gpiod_to_irq(const struct gpio_desc *desc);
 /* Convert between the old gpio_ and new gpiod_ interfaces */
 struct gpio_desc *gpio_to_desc(unsigned gpio);
 int desc_to_gpio(const struct gpio_desc *desc);
-struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc);
 
 #else /* CONFIG_GPIOLIB */
 
@@ -207,12 +205,6 @@ static inline int desc_to_gpio(const struct gpio_desc *desc)
 	WARN_ON(1);
 	return -EINVAL;
 }
-static inline struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
-{
-	/* GPIO can never have been requested */
-	WARN_ON(1);
-	return ERR_PTR(-ENODEV);
-}
 
 
 #endif /* CONFIG_GPIOLIB */
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index a3e181e..9fe2836 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -10,6 +10,8 @@ struct of_phandle_args;
 struct device_node;
 struct seq_file;
 
+#ifdef CONFIG_GPIOLIB
+
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
@@ -129,6 +131,11 @@ extern struct gpio_chip *gpiochip_find(void *data,
 int gpiod_lock_as_irq(struct gpio_desc *desc);
 void gpiod_unlock_as_irq(struct gpio_desc *desc);
 
+struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc);
+
+struct gpio_desc *gpiochip_get_desc(struct gpio_chip *chip,
+				    u16 hwnum);
+
 enum gpio_lookup_flags {
 	GPIO_ACTIVE_HIGH = (0 << 0),
 	GPIO_ACTIVE_LOW = (1 << 0),
@@ -183,4 +190,15 @@ struct gpiod_lookup_table {
 
 void gpiod_add_lookup_table(struct gpiod_lookup_table *table);
 
+#else /* CONFIG_GPIOLIB */
+
+static inline struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return ERR_PTR(-ENODEV);
+}
+
+#endif /* CONFIG_GPIOLIB */
+
 #endif
-- 
1.8.5.4

