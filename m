Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaKAHNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 03:13:17 -0400
Received: from gnurou.org ([207.192.72.5]:49926 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaKAHNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 03:13:15 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2014 03:13:15 EDT
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC] gpio: remove gpio_descs global array
Date: Sat,  1 Nov 2014 16:03:00 +0900
Message-Id: <1414825380-15322-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ARCH_NR_GPIOS-sized static array of GPIO descriptors by
dynamically-allocated arrays for each GPIO chip.

This change makes gpio_to_desc() perform in O(n) (where n is the number
of GPIO chips registered) instead of O(1), however since n is rarely
bigger than 1 or 2 no noticeable performance issue should be expected.
Besides this provides more incentive for GPIO consumers to move to the
gpiod interface. One could use a O(log(n)) structure to link the GPIO
chips together, but considering the low limit of n the hypothetical
performance benefit is probably not worth the added complexity.

The issue with this patch is its use of kzalloc() in gpiochip_add(), a
function potentially called during early boot, before kzalloc() becomes
usable. Hence its [RFC] status until we can find a solution for this or
agree that this issue is actually never ran into (from which point can
one use kzalloc()?)

While writing this I noticed a couple of weird things done in
gpiochip_add()/gpiochip_remove() and I suspect other people will find
them as well, but for now I'd like to focus on the kzalloc() issue and
see if we can push this forward. :)

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50e18a4..013e01e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -47,8 +47,6 @@
  */
 DEFINE_SPINLOCK(gpio_lock);
 
-static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
-
 #define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
 
 static DEFINE_MUTEX(gpio_lookup_lock);
@@ -65,10 +63,23 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
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
+	pr_warn("invalid GPIO %d\n", gpio);
+	dump_stack();
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(gpio_to_desc);
 
@@ -91,7 +102,7 @@ struct gpio_desc *gpiochip_get_desc(struct gpio_chip *chip,
  */
 int desc_to_gpio(const struct gpio_desc *desc)
 {
-	return desc - &gpio_desc[0];
+	return desc->chip->base + (desc - &desc->chip->desc[0]);
 }
 EXPORT_SYMBOL_GPL(desc_to_gpio);
 
@@ -226,12 +237,13 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 	int		base = chip->base;
+	struct gpio_desc *descs;
 
-	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
-			&& base >= 0) {
-		status = -EINVAL;
-		goto fail;
-	}
+	/* TODO context is potentially before kmalloc will work - how can we */
+	/* workaround this? */
+	descs = kzalloc(sizeof(descs[0] * chip->ngpio, GFP_KERNEL);
+	if (!descs)
+		return -ENOMEM;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
@@ -247,10 +259,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	status = gpiochip_add_to_list(chip);
 
 	if (status == 0) {
-		chip->desc = &gpio_desc[chip->base];
-
 		for (id = 0; id < chip->ngpio; id++) {
-			struct gpio_desc *desc = &chip->desc[id];
+			struct gpio_desc *desc = &descs[id];
 			desc->chip = chip;
 
 			/* REVISIT:  most hardware initializes GPIOs as
@@ -266,6 +276,8 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 	}
 
+	chip->desc = descs;
+
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 #ifdef CONFIG_PINCTRL
@@ -291,6 +303,9 @@ int gpiochip_add(struct gpio_chip *chip)
 unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
+	chip->desc = NULL;
+	kfree(descs);
+
 	/* failures here can mean systems won't boot... */
 	pr_err("%s: GPIOs %d..%d (%s) failed to register\n", __func__,
 		chip->base, chip->base + chip->ngpio - 1,
@@ -331,6 +346,9 @@ void gpiochip_remove(struct gpio_chip *chip)
 	list_del(&chip->list);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	gpiochip_unexport(chip);
+
+	kfree(chip->desc);
+	chip->descs = NULL;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
-- 
2.1.3

