Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab3BBOmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:42:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45987 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab3BBOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:42:06 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Dirk Opfer <dirk@opfer-online.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] gpiolib: remove gpiochip_reserve()
Date: Sat,  2 Feb 2013 23:44:06 +0900
Message-Id: <1359816246-3979-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
References: <1359816246-3979-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiochip_reserve() has no user and stands in the way of the removal of
the static gpio_desc[] array. Remove this function as well as the now
unneeded RESERVED flag of struct gpio_desc.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c     | 58 +++++++---------------------------------------
 include/asm-generic/gpio.h |  1 -
 2 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 199fca1..e27877a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -52,14 +52,13 @@ struct gpio_desc {
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
-#define FLAG_RESERVED	2
-#define FLAG_EXPORT	3	/* protected by sysfs_lock */
-#define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
-#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
-#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
-#define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
-#define FLAG_OPEN_DRAIN	8	/* Gpio is open drain type */
-#define FLAG_OPEN_SOURCE 9	/* Gpio is open source type */
+#define FLAG_EXPORT	2	/* protected by sysfs_lock */
+#define FLAG_SYSFS	3	/* exported via /sys/class/gpio/control */
+#define FLAG_TRIG_FALL	4	/* trigger on falling edge */
+#define FLAG_TRIG_RISE	5	/* trigger on rising edge */
+#define FLAG_ACTIVE_LOW	6	/* sysfs value has active low */
+#define FLAG_OPEN_DRAIN	7	/* Gpio is open drain type */
+#define FLAG_OPEN_SOURCE 8	/* Gpio is open source type */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
@@ -132,7 +131,7 @@ static int gpiochip_find_base(int ngpio)
 		struct gpio_desc *desc = &gpio_desc[i];
 		struct gpio_chip *chip = desc->chip;
 
-		if (!chip && !test_bit(FLAG_RESERVED, &desc->flags)) {
+		if (!chip) {
 			spare++;
 			if (spare == ngpio) {
 				base = i;
@@ -150,47 +149,6 @@ static int gpiochip_find_base(int ngpio)
 	return base;
 }
 
-/**
- * gpiochip_reserve() - reserve range of gpios to use with platform code only
- * @start: starting gpio number
- * @ngpio: number of gpios to reserve
- * Context: platform init, potentially before irqs or kmalloc will work
- *
- * Returns a negative errno if any gpio within the range is already reserved
- * or registered, else returns zero as a success code.  Use this function
- * to mark a range of gpios as unavailable for dynamic gpio number allocation,
- * for example because its driver support is not yet loaded.
- */
-int __init gpiochip_reserve(int start, int ngpio)
-{
-	int ret = 0;
-	unsigned long flags;
-	int i;
-
-	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio - 1))
-		return -EINVAL;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	for (i = start; i < start + ngpio; i++) {
-		struct gpio_desc *desc = &gpio_desc[i];
-
-		if (desc->chip || test_bit(FLAG_RESERVED, &desc->flags)) {
-			ret = -EBUSY;
-			goto err;
-		}
-
-		set_bit(FLAG_RESERVED, &desc->flags);
-	}
-
-	pr_debug("%s: reserved gpios from %d to %d\n",
-		 __func__, start, start + ngpio - 1);
-err:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	return ret;
-}
-
 /* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
 static int gpio_get_direction(unsigned gpio)
 {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 45b8916..2034e69 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -152,7 +152,6 @@ struct gpio_chip {
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
 extern struct gpio_chip *gpio_to_chip(unsigned gpio);
-extern int __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
-- 
1.8.1.1

