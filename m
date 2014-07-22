Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaGVHSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:18:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4654 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaGVHSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:18:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 Jul 2014 00:10:42 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 5/5] gpio: move gpio_ensure_requested() into legacy C file
Date: Tue, 22 Jul 2014 16:17:43 +0900
Message-ID: <1406013463-19218-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_ensure_requested() only makes sense when using the integer-based
GPIO API, so make sure it is called from there instead of the gpiod
API which we know cannot be called with a non-requested GPIO anyway.

The uses of gpio_ensure_requested() in the gpiod API were kind of
out-of-place anyway, so putting them in gpio-legacy.c helps clearing the
code.

Actually, considering the time this ensure_requested mechanism has been
around, maybe we should just turn this patch into "remove
gpio_ensure_requested()" if we know for sure that no user depend on it
anymore?

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-legacy.c | 106 ++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        | 129 ++----------------------------------------
 include/asm-generic/gpio.h    |  15 +----
 3 files changed, 113 insertions(+), 137 deletions(-)

diff --git a/drivers/gpio/gpiolib-legacy.c b/drivers/gpio/gpiolib-legacy.c
index c3e3823a40b9..9da5deee716c 100644
--- a/drivers/gpio/gpiolib-legacy.c
+++ b/drivers/gpio/gpiolib-legacy.c
@@ -5,6 +5,64 @@
 
 #include "gpiolib.h"
 
+/* Warn when drivers omit gpio_request() calls -- legal but ill-advised
+ * when setting direction, and otherwise illegal.  Until board setup code
+ * and drivers use explicit requests everywhere (which won't happen when
+ * those calls have no teeth) we can't avoid autorequesting.  This nag
+ * message should motivate switching to explicit requests... so should
+ * the weaker cleanup after faults, compared to gpio_request().
+ *
+ * NOTE: the autorequest mechanism is going away; at this point it's
+ * only "legal" in the sense that (old) code using it won't break yet,
+ * but instead only triggers a WARN() stack dump.
+ */
+static int gpio_ensure_requested(struct gpio_desc *desc)
+{
+	struct gpio_chip *chip = desc->chip;
+	unsigned long flags;
+	bool request = false;
+	int err = 0;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
+			"autorequest GPIO-%d\n", desc_to_gpio(desc))) {
+		if (!try_module_get(chip->owner)) {
+			gpiod_err(desc, "%s: module can't be gotten\n",
+					__func__);
+			clear_bit(FLAG_REQUESTED, &desc->flags);
+			/* lose */
+			err = -EIO;
+			goto end;
+		}
+		desc->label = "[auto]";
+		/* caller must chip->request() w/o spinlock */
+		if (chip->request)
+			request = true;
+	}
+
+end:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (request) {
+		might_sleep_if(chip->can_sleep);
+		err = chip->request(chip, gpio_chip_hwgpio(desc));
+
+		if (err < 0) {
+			gpiod_dbg(desc, "%s: chip request fail, %d\n",
+					__func__, err);
+			spin_lock_irqsave(&gpio_lock, flags);
+
+			desc->label = NULL;
+			clear_bit(FLAG_REQUESTED, &desc->flags);
+
+			spin_unlock_irqrestore(&gpio_lock, flags);
+		}
+	}
+
+	return err;
+}
+
 void gpio_free(unsigned gpio)
 {
 	gpiod_free(gpio_to_desc(gpio));
@@ -97,3 +155,51 @@ void gpio_free_array(const struct gpio *array, size_t num)
 		gpio_free((array++)->gpio);
 }
 EXPORT_SYMBOL_GPL(gpio_free_array);
+
+int gpio_direction_input(unsigned gpio)
+{
+	struct gpio_desc *desc = gpio_to_desc(gpio);
+	int err;
+
+	if (!desc)
+		return -EINVAL;
+
+	err = gpio_ensure_requested(desc);
+	if (err < 0)
+		return err;
+
+	return gpiod_direction_input(desc);
+}
+EXPORT_SYMBOL_GPL(gpio_direction_input);
+
+int gpio_direction_output(unsigned gpio, int value)
+{
+	struct gpio_desc *desc = gpio_to_desc(gpio);
+	int err;
+
+	if (!desc)
+		return -EINVAL;
+
+	err = gpio_ensure_requested(desc);
+	if (err < 0)
+		return err;
+
+	return gpiod_direction_output_raw(desc, value);
+}
+EXPORT_SYMBOL_GPL(gpio_direction_output);
+
+int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	struct gpio_desc *desc = gpio_to_desc(gpio);
+	int err;
+
+	if (!desc)
+		return -EINVAL;
+
+	err = gpio_ensure_requested(desc);
+	if (err < 0)
+		return err;
+
+	return gpiod_set_debounce(desc, debounce);
+}
+EXPORT_SYMBOL_GPL(gpio_set_debounce);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7582207c92e7..412d64e93cfb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -95,39 +95,6 @@ int desc_to_gpio(const struct gpio_desc *desc)
 EXPORT_SYMBOL_GPL(desc_to_gpio);
 
 
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
-	const struct gpio_chip *chip = desc->chip;
-	const int gpio = desc_to_gpio(desc);
-
-	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
-			"autorequest GPIO-%d\n", gpio)) {
-		if (!try_module_get(chip->owner)) {
-			gpiod_err(desc, "%s: module can't be gotten\n",
-					__func__);
-			clear_bit(FLAG_REQUESTED, &desc->flags);
-			/* lose */
-			return -EIO;
-		}
-		desc_set_label(desc, "[auto]");
-		/* caller must chip->request() w/o spinlock */
-		if (chip->request)
-			return 1;
-	}
-	return 0;
-}
-
 /**
  * gpiod_to_chip - Return the GPIO chip to which a GPIO descriptor belongs
  * @desc:	descriptor to return the chip of
@@ -964,10 +931,8 @@ void gpiochip_free_own_desc(struct gpio_desc *desc)
  */
 int gpiod_direction_input(struct gpio_desc *desc)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
-	int			offset;
 
 	if (!desc || !desc->chip) {
 		pr_warn("%s: invalid GPIO\n", __func__);
@@ -982,52 +947,20 @@ int gpiod_direction_input(struct gpio_desc *desc)
 		return -EIO;
 	}
 
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	status = gpio_ensure_requested(desc);
-	if (status < 0)
-		goto fail;
-
-	/* now we know the gpio is valid and chip won't vanish */
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	might_sleep_if(chip->can_sleep);
-
-	offset = gpio_chip_hwgpio(desc);
-	if (status) {
-		status = chip->request(chip, offset);
-		if (status < 0) {
-			gpiod_dbg(desc, "%s: chip request fail, %d\n",
-					__func__, status);
-			/* and it's not available to anyone else ...
-			 * gpio_request() is the fully clean solution.
-			 */
-			goto lose;
-		}
-	}
-
-	status = chip->direction_input(chip, offset);
+	status = chip->direction_input(chip, gpio_chip_hwgpio(desc));
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
 
 	trace_gpio_direction(desc_to_gpio(desc), 1, status);
-lose:
-	return status;
-fail:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
-		gpiod_dbg(desc, "%s: status %d\n", __func__, status);
+
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiod_direction_input);
 
 static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
-	int offset;
 
 	/* GPIOs used for IRQs shall not be set as output */
 	if (test_bit(FLAG_USED_AS_IRQ, &desc->flags)) {
@@ -1053,42 +986,11 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 		return -EIO;
 	}
 
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	status = gpio_ensure_requested(desc);
-	if (status < 0)
-		goto fail;
-
-	/* now we know the gpio is valid and chip won't vanish */
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	might_sleep_if(chip->can_sleep);
-
-	offset = gpio_chip_hwgpio(desc);
-	if (status) {
-		status = chip->request(chip, offset);
-		if (status < 0) {
-			gpiod_dbg(desc, "%s: chip request fail, %d\n",
-					__func__, status);
-			/* and it's not available to anyone else ...
-			 * gpio_request() is the fully clean solution.
-			 */
-			goto lose;
-		}
-	}
-
-	status = chip->direction_output(chip, offset, value);
+	status = chip->direction_output(chip, gpio_chip_hwgpio(desc), value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
 	trace_gpio_direction(desc_to_gpio(desc), 0, status);
-lose:
-	return status;
-fail:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
-		gpiod_dbg(desc, "%s: gpio status %d\n", __func__, status);
 	return status;
 }
 
@@ -1147,10 +1049,7 @@ EXPORT_SYMBOL_GPL(gpiod_direction_output);
  */
 int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
-	int			status = -EINVAL;
-	int			offset;
 
 	if (!desc || !desc->chip) {
 		pr_warn("%s: invalid GPIO\n", __func__);
@@ -1165,27 +1064,7 @@ int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 		return -ENOTSUPP;
 	}
 
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	status = gpio_ensure_requested(desc);
-	if (status < 0)
-		goto fail;
-
-	/* now we know the gpio is valid and chip won't vanish */
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	might_sleep_if(chip->can_sleep);
-
-	offset = gpio_chip_hwgpio(desc);
-	return chip->set_debounce(chip, offset, debounce);
-
-fail:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
-		gpiod_dbg(desc, "%s: status %d\n", __func__, status);
-
-	return status;
+	return chip->set_debounce(chip, gpio_chip_hwgpio(desc), debounce);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_debounce);
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c1d4105e1c1d..39a1d06950d9 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -63,19 +63,10 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return gpiod_direction_input(gpio_to_desc(gpio));
-}
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
-}
+extern int gpio_direction_input(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
 
-static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
-{
-	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
-}
+extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 
 static inline int gpio_get_value_cansleep(unsigned gpio)
 {
-- 
2.0.1

