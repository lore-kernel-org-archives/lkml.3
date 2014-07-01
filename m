Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaGAFrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:47:22 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2849 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaGAFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:47:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 30 Jun 2014 22:37:06 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 3/3] gpio: move integer GPIO support to its own file
Date: Tue, 1 Jul 2014 14:45:16 +0900
Message-ID: <1404193516-4384-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404193516-4384-1-git-send-email-acourbot@nvidia.com>
References: <1404193516-4384-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old integer GPIO interface is, in effect, a privileged user of the
gpiod interface. Reflect this fact further by moving legacy GPIO support
into its own source file. This makes the code clearer and will allow us
to disable legacy GPIO support in the (far) future.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpiolib-legacy.c | 112 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        | 105 ---------------------------------------
 3 files changed, 113 insertions(+), 105 deletions(-)
 create mode 100644 drivers/gpio/gpiolib-legacy.c

diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 579be6fc5edb..17ef34796d66 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIO_DEVRES)	+= devres.o
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
+obj-$(CONFIG_GPIOLIB)		+= gpiolib-legacy.o
 obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
 obj-$(CONFIG_GPIO_SYSFS)	+= gpiolib-sysfs.o
 obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
diff --git a/drivers/gpio/gpiolib-legacy.c b/drivers/gpio/gpiolib-legacy.c
new file mode 100644
index 000000000000..66dfa68cc5ba
--- /dev/null
+++ b/drivers/gpio/gpiolib-legacy.c
@@ -0,0 +1,112 @@
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
+
+#include <linux/gpio.h>
+
+#include "gpiolib.h"
+
+void gpio_free(unsigned gpio)
+{
+	gpiod_free(gpio_to_desc(gpio));
+}
+EXPORT_SYMBOL_GPL(gpio_free);
+
+/**
+ * gpio_request_one - request a single GPIO with initial configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
+int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
+{
+	struct gpio_desc *desc;
+	int err;
+
+	desc = gpio_to_desc(gpio);
+
+	err = gpiod_request(desc, label);
+	if (err)
+		return err;
+
+	if (flags & GPIOF_OPEN_DRAIN)
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
+
+	if (flags & GPIOF_OPEN_SOURCE)
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
+
+	if (flags & GPIOF_DIR_IN)
+		err = gpiod_direction_input(desc);
+	else
+		err = gpiod_direction_output_raw(desc,
+				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
+
+	if (err)
+		goto free_gpio;
+
+	if (flags & GPIOF_EXPORT) {
+		err = gpiod_export(desc, flags & GPIOF_EXPORT_CHANGEABLE);
+		if (err)
+			goto free_gpio;
+	}
+
+	return 0;
+
+ free_gpio:
+	gpiod_free(desc);
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_one);
+
+int gpio_request(unsigned gpio, const char *label)
+{
+	return gpiod_request(gpio_to_desc(gpio), label);
+}
+EXPORT_SYMBOL_GPL(gpio_request);
+
+/**
+ * gpio_request_array - request multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
+int gpio_request_array(const struct gpio *array, size_t num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++, array++) {
+		err = gpio_request_one(array->gpio, array->flags, array->label);
+		if (err)
+			goto err_free;
+	}
+	return 0;
+
+err_free:
+	while (i--)
+		gpio_free((--array)->gpio);
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_array);
+
+/**
+ * gpio_free_array - release multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
+void gpio_free_array(const struct gpio *array, size_t num)
+{
+	while (num--)
+		gpio_free((array++)->gpio);
+}
+EXPORT_SYMBOL_GPL(gpio_free_array);
+
+int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
+{
+	return gpiod_lock_as_irq(gpiochip_get_desc(chip, offset));
+}
+EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
+
+void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
+{
+	return gpiod_unlock_as_irq(gpiochip_get_desc(chip, offset));
+}
+EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
+
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7b35e5093ef5..c5509359ba88 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -845,12 +845,6 @@ done:
 	return status;
 }
 
-int gpio_request(unsigned gpio, const char *label)
-{
-	return gpiod_request(gpio_to_desc(gpio), label);
-}
-EXPORT_SYMBOL_GPL(gpio_request);
-
 static bool __gpiod_free(struct gpio_desc *desc)
 {
 	bool			ret = false;
@@ -891,93 +885,6 @@ void gpiod_free(struct gpio_desc *desc)
 		WARN_ON(extra_checks);
 }
 
-void gpio_free(unsigned gpio)
-{
-	gpiod_free(gpio_to_desc(gpio));
-}
-EXPORT_SYMBOL_GPL(gpio_free);
-
-/**
- * gpio_request_one - request a single GPIO with initial configuration
- * @gpio:	the GPIO number
- * @flags:	GPIO configuration as specified by GPIOF_*
- * @label:	a literal description string of this GPIO
- */
-int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
-{
-	struct gpio_desc *desc;
-	int err;
-
-	desc = gpio_to_desc(gpio);
-
-	err = gpiod_request(desc, label);
-	if (err)
-		return err;
-
-	if (flags & GPIOF_OPEN_DRAIN)
-		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
-
-	if (flags & GPIOF_OPEN_SOURCE)
-		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
-
-	if (flags & GPIOF_DIR_IN)
-		err = gpiod_direction_input(desc);
-	else
-		err = gpiod_direction_output_raw(desc,
-				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
-
-	if (err)
-		goto free_gpio;
-
-	if (flags & GPIOF_EXPORT) {
-		err = gpiod_export(desc, flags & GPIOF_EXPORT_CHANGEABLE);
-		if (err)
-			goto free_gpio;
-	}
-
-	return 0;
-
- free_gpio:
-	gpiod_free(desc);
-	return err;
-}
-EXPORT_SYMBOL_GPL(gpio_request_one);
-
-/**
- * gpio_request_array - request multiple GPIOs in a single call
- * @array:	array of the 'struct gpio'
- * @num:	how many GPIOs in the array
- */
-int gpio_request_array(const struct gpio *array, size_t num)
-{
-	int i, err;
-
-	for (i = 0; i < num; i++, array++) {
-		err = gpio_request_one(array->gpio, array->flags, array->label);
-		if (err)
-			goto err_free;
-	}
-	return 0;
-
-err_free:
-	while (i--)
-		gpio_free((--array)->gpio);
-	return err;
-}
-EXPORT_SYMBOL_GPL(gpio_request_array);
-
-/**
- * gpio_free_array - release multiple GPIOs in a single call
- * @array:	array of the 'struct gpio'
- * @num:	how many GPIOs in the array
- */
-void gpio_free_array(const struct gpio *array, size_t num)
-{
-	while (num--)
-		gpio_free((array++)->gpio);
-}
-EXPORT_SYMBOL_GPL(gpio_free_array);
-
 /**
  * gpiochip_is_requested - return string iff signal was requested
  * @chip: controller managing the signal
@@ -1545,12 +1452,6 @@ int gpiod_lock_as_irq(struct gpio_desc *desc)
 }
 EXPORT_SYMBOL_GPL(gpiod_lock_as_irq);
 
-int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
-{
-	return gpiod_lock_as_irq(gpiochip_get_desc(chip, offset));
-}
-EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
-
 /**
  * gpiod_unlock_as_irq() - unlock a GPIO used as IRQ
  * @gpio: the GPIO line to unlock from IRQ usage
@@ -1567,12 +1468,6 @@ void gpiod_unlock_as_irq(struct gpio_desc *desc)
 }
 EXPORT_SYMBOL_GPL(gpiod_unlock_as_irq);
 
-void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
-{
-	return gpiod_unlock_as_irq(gpiochip_get_desc(chip, offset));
-}
-EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
-
 /**
  * gpiod_get_raw_value_cansleep() - return a gpio's raw value
  * @desc: gpio whose value will be returned
-- 
2.0.0

