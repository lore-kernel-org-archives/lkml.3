Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3BBQ1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:27:52 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:40855 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab3BBQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:39 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 7/9] gpiolib: let gpio_chip reference its descriptors
Date: Sun,  3 Feb 2013 01:29:30 +0900
Message-Id: <1359822572-26009-9-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pointer to the gpio_chip structure that references the array of
GPIO descriptors belonging to the chip, and update gpiolib code to use
this pointer instead of the global gpio_desc[] array. This is another
step towards the removal of the gpio_desc[] global array.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c     | 39 +++++++++++++++++++++++----------------
 include/asm-generic/gpio.h |  3 +++
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 82c40bd..9599b9a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -72,6 +72,8 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+#define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
+
 static LIST_HEAD(gpio_chips);
 
 #ifdef CONFIG_GPIO_SYSFS
@@ -112,7 +114,7 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
  */
 static int gpio_chip_hwgpio(const struct gpio_desc *desc)
 {
-	return (desc - &gpio_desc[0]) - desc->chip->base;
+	return desc - &desc->chip->desc[0];
 }
 
 /**
@@ -133,7 +135,7 @@ static struct gpio_desc *gpio_to_desc(unsigned gpio)
  */
 static int desc_to_gpio(const struct gpio_desc *desc)
 {
-	return desc - &gpio_desc[0];
+	return desc->chip->base + gpio_chip_hwgpio(desc);
 }
 
 
@@ -1006,9 +1008,9 @@ static int gpiochip_export(struct gpio_chip *chip)
 		unsigned	gpio;
 
 		spin_lock_irqsave(&gpio_lock, flags);
-		gpio = chip->base;
-		while (gpio_desc[gpio].chip == chip)
-			gpio_desc[gpio++].chip = NULL;
+		gpio = 0;
+		while (gpio < chip->ngpio)
+			chip->desc[gpio++].chip = NULL;
 		spin_unlock_irqrestore(&gpio_lock, flags);
 
 		pr_debug("%s: chip %s status %d\n", __func__,
@@ -1164,8 +1166,11 @@ int gpiochip_add(struct gpio_chip *chip)
 	status = gpiochip_add_to_list(chip);
 
 	if (status == 0) {
-		for (id = base; id < base + chip->ngpio; id++) {
-			gpio_desc[id].chip = chip;
+		chip->desc = &gpio_desc[chip->base];
+
+		for (id = 0; id < chip->ngpio; id++) {
+			struct gpio_desc *desc = &chip->desc[id];
+			desc->chip = chip;
 
 			/* REVISIT:  most hardware initializes GPIOs as
 			 * inputs (often with pullups enabled) so power
@@ -1174,7 +1179,7 @@ int gpiochip_add(struct gpio_chip *chip)
 			 * and in case chip->get_direction is not set,
 			 * we may expose the wrong direction in sysfs.
 			 */
-			gpio_desc[id].flags = !chip->direction_input
+			desc->flags = !chip->direction_input
 				? (1 << FLAG_IS_OUT)
 				: 0;
 		}
@@ -1227,15 +1232,15 @@ int gpiochip_remove(struct gpio_chip *chip)
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
 
-	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
-		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
+	for (id = 0; id < chip->ngpio; id++) {
+		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
 			status = -EBUSY;
 			break;
 		}
 	}
 	if (status == 0) {
-		for (id = chip->base; id < chip->base + chip->ngpio; id++)
-			gpio_desc[id].chip = NULL;
+		for (id = 0; id < chip->ngpio; id++)
+			chip->desc[id].chip = NULL;
 
 		list_del(&chip->list);
 	}
@@ -1560,11 +1565,13 @@ EXPORT_SYMBOL_GPL(gpio_free_array);
  */
 const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
-	unsigned gpio = chip->base + offset;
-	struct gpio_desc *desc = &gpio_desc[gpio];
+	struct gpio_desc *desc;
 
-	if (!gpio_is_valid(gpio) || desc->chip != chip)
+	if (!GPIO_OFFSET_VALID(chip, offset))
 		return NULL;
+
+	desc = &chip->desc[offset];
+
 	if (test_bit(FLAG_REQUESTED, &desc->flags) == 0)
 		return NULL;
 #ifdef CONFIG_DEBUG_FS
@@ -2003,7 +2010,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	unsigned		i;
 	unsigned		gpio = chip->base;
-	struct gpio_desc	*gdesc = &gpio_desc[gpio];
+	struct gpio_desc	*gdesc = &chip->desc[0];
 	int			is_out;
 
 	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index b562f95..bde6469 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -47,6 +47,7 @@ struct gpio;
 struct seq_file;
 struct module;
 struct device_node;
+struct gpio_desc;
 
 /**
  * struct gpio_chip - abstract a GPIO controller
@@ -76,6 +77,7 @@ struct device_node;
  *	negative during registration, requests dynamic ID allocation.
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
  *	handled is (base + ngpio - 1).
+ * @desc: array of ngpio descriptors. Private.
  * @can_sleep: flag must be set iff get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
  * @names: if set, must be an array of strings to use as alternative
@@ -126,6 +128,7 @@ struct gpio_chip {
 						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
+	struct gpio_desc	*desc;
 	const char		*const *names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
-- 
1.8.1.1

