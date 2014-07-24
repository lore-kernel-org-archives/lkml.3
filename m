Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbaGXFvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 01:51:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18422 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaGXFvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 01:51:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 23 Jul 2014 22:39:18 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: remove gpio_ensure_requested()
Date: Thu, 24 Jul 2014 14:51:02 +0900
Message-ID: <1406181062-29596-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_ensure_requested() has been introduced in Feb. 2008 by commit
d2876d08d86f2 to force users of the GPIO API to explicitly request GPIOs
before using them.

Hopefully by now all GPIOs are correctly requested and this extra check
can be omitted ; in any case the GPIO maintainers won't feel bad if
machines start failing after 6 years of warnings.

This patch removes that function from the dark ages.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-legacy.c | 106 ------------------------------------------
 include/asm-generic/gpio.h    |  15 ++++--
 2 files changed, 12 insertions(+), 109 deletions(-)

diff --git a/drivers/gpio/gpiolib-legacy.c b/drivers/gpio/gpiolib-legacy.c
index 0f9429b2522a..078ae6c2df79 100644
--- a/drivers/gpio/gpiolib-legacy.c
+++ b/drivers/gpio/gpiolib-legacy.c
@@ -5,64 +5,6 @@
 
 #include "gpiolib.h"
 
-/* Warn when drivers omit gpio_request() calls -- legal but ill-advised
- * when setting direction, and otherwise illegal.  Until board setup code
- * and drivers use explicit requests everywhere (which won't happen when
- * those calls have no teeth) we can't avoid autorequesting.  This nag
- * message should motivate switching to explicit requests... so should
- * the weaker cleanup after faults, compared to gpio_request().
- *
- * NOTE: the autorequest mechanism is going away; at this point it's
- * only "legal" in the sense that (old) code using it won't break yet,
- * but instead only triggers a WARN() stack dump.
- */
-static int gpio_ensure_requested(struct gpio_desc *desc)
-{
-	struct gpio_chip *chip = desc->chip;
-	unsigned long flags;
-	bool request = false;
-	int err = 0;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
-			"autorequest GPIO-%d\n", desc_to_gpio(desc))) {
-		if (!try_module_get(chip->owner)) {
-			gpiod_err(desc, "%s: module can't be gotten\n",
-					__func__);
-			clear_bit(FLAG_REQUESTED, &desc->flags);
-			/* lose */
-			err = -EIO;
-			goto end;
-		}
-		desc->label = "[auto]";
-		/* caller must chip->request() w/o spinlock */
-		if (chip->request)
-			request = true;
-	}
-
-end:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	if (request) {
-		might_sleep_if(chip->can_sleep);
-		err = chip->request(chip, gpio_chip_hwgpio(desc));
-
-		if (err < 0) {
-			gpiod_dbg(desc, "%s: chip request fail, %d\n",
-					__func__, err);
-			spin_lock_irqsave(&gpio_lock, flags);
-
-			desc->label = NULL;
-			clear_bit(FLAG_REQUESTED, &desc->flags);
-
-			spin_unlock_irqrestore(&gpio_lock, flags);
-		}
-	}
-
-	return err;
-}
-
 void gpio_free(unsigned gpio)
 {
 	gpiod_free(gpio_to_desc(gpio));
@@ -158,51 +100,3 @@ void gpio_free_array(const struct gpio *array, size_t num)
 		gpio_free((array++)->gpio);
 }
 EXPORT_SYMBOL_GPL(gpio_free_array);
-
-int gpio_direction_input(unsigned gpio)
-{
-	struct gpio_desc *desc = gpio_to_desc(gpio);
-	int err;
-
-	if (!desc)
-		return -EINVAL;
-
-	err = gpio_ensure_requested(desc);
-	if (err < 0)
-		return err;
-
-	return gpiod_direction_input(desc);
-}
-EXPORT_SYMBOL_GPL(gpio_direction_input);
-
-int gpio_direction_output(unsigned gpio, int value)
-{
-	struct gpio_desc *desc = gpio_to_desc(gpio);
-	int err;
-
-	if (!desc)
-		return -EINVAL;
-
-	err = gpio_ensure_requested(desc);
-	if (err < 0)
-		return err;
-
-	return gpiod_direction_output_raw(desc, value);
-}
-EXPORT_SYMBOL_GPL(gpio_direction_output);
-
-int gpio_set_debounce(unsigned gpio, unsigned debounce)
-{
-	struct gpio_desc *desc = gpio_to_desc(gpio);
-	int err;
-
-	if (!desc)
-		return -EINVAL;
-
-	err = gpio_ensure_requested(desc);
-	if (err < 0)
-		return err;
-
-	return gpiod_set_debounce(desc, debounce);
-}
-EXPORT_SYMBOL_GPL(gpio_set_debounce);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 39a1d06950d9..c1d4105e1c1d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -63,10 +63,19 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return gpiod_direction_input(gpio_to_desc(gpio));
+}
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
+}
 
-extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
+static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
+}
 
 static inline int gpio_get_value_cansleep(unsigned gpio)
 {
-- 
2.0.2

