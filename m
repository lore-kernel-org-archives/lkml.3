Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaKSHvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:51:43 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3231 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbaKSHvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:51:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Nov 2014 23:50:01 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: remove gpio_descs global array
Date: Wed, 19 Nov 2014 16:51:27 +0900
Message-ID: <1416383487-15993-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ARCH_NR_GPIOS-sized static array of GPIO descriptors by
dynamically-allocated arrays for each GPIO chip.

This change makes gpio_to_desc() perform in O(n) (where n is the number
of GPIO chips registered) instead of O(1), however since n is rarely
bigger than 1 or 2 no noticeable performance issue is expected.
Besides this provides more incentive for GPIO consumers to move to the
gpiod interface. One could use a O(log(n)) structure to link the GPIO
chips together, but considering the low limit of n the hypothetical
performance benefit is probably not worth the added complexity.

This patch uses kcalloc() in gpiochip_add(), which removes the ability
to add a chip before kcalloc() can operate. I am not aware of such
cases, but if someone bisects up to this patch then I will be proven
wrong...

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index eb739a51e774..5619922ebf44 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -47,8 +47,6 @@
  */
 DEFINE_SPINLOCK(gpio_lock);
 
-static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
-
 #define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
 
 static DEFINE_MUTEX(gpio_lookup_lock);
@@ -65,10 +63,22 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
  */
 struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
-	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
-		return NULL;
-	else
-		return &gpio_desc[gpio];
+	struct gpio_chip *chip;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	list_for_each_entry(chip, &gpio_chips, list) {
+		if (chip->base <= gpio && chip->base + chip->ngpio > gpio) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			return &chip->desc[gpio - chip->base];
+		}
+	}
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	WARN(1, "invalid GPIO %d\n", gpio);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(gpio_to_desc);
 
@@ -91,7 +101,7 @@ struct gpio_desc *gpiochip_get_desc(struct gpio_chip *chip,
  */
 int desc_to_gpio(const struct gpio_desc *desc)
 {
-	return desc - &gpio_desc[0];
+	return desc->chip->base + (desc - &desc->chip->desc[0]);
 }
 EXPORT_SYMBOL_GPL(desc_to_gpio);
 
@@ -206,7 +216,7 @@ static int gpiochip_add_to_list(struct gpio_chip *chip)
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
- * Context: potentially before irqs or kmalloc will work
+ * Context: potentially before irqs will work
  *
  * Returns a negative errno if the chip can't be registered, such as
  * because the chip->base is invalid or already associated with a
@@ -226,12 +236,11 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 	int		base = chip->base;
+	struct gpio_desc *descs;
 
-	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
-			&& base >= 0) {
-		status = -EINVAL;
-		goto fail;
-	}
+	descs = kcalloc(chip->ngpio, sizeof(descs[0]), GFP_KERNEL);
+	if (!descs)
+		return -ENOMEM;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
@@ -247,10 +256,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	status = gpiochip_add_to_list(chip);
 
 	if (status == 0) {
-		chip->desc = &gpio_desc[chip->base];
-
 		for (id = 0; id < chip->ngpio; id++) {
-			struct gpio_desc *desc = &chip->desc[id];
+			struct gpio_desc *desc = &descs[id];
 			desc->chip = chip;
 
 			/* REVISIT:  most hardware initializes GPIOs as
@@ -266,6 +273,8 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 	}
 
+	chip->desc = descs;
+
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 #ifdef CONFIG_PINCTRL
@@ -291,6 +300,9 @@ int gpiochip_add(struct gpio_chip *chip)
 unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
+	kfree(descs);
+	chip->desc = NULL;
+
 	/* failures here can mean systems won't boot... */
 	pr_err("%s: GPIOs %d..%d (%s) failed to register\n", __func__,
 		chip->base, chip->base + chip->ngpio - 1,
@@ -331,6 +343,9 @@ void gpiochip_remove(struct gpio_chip *chip)
 	list_del(&chip->list);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	gpiochip_unexport(chip);
+
+	kfree(chip->desc);
+	chip->desc = NULL;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
-- 
2.1.3

