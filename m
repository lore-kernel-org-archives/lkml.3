Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaGVHSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:18:32 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4649 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaGVHS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:18:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 Jul 2014 00:10:40 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 4/5] gpio: remove gpiod_lock/unlock_as_irq()
Date: Tue, 22 Jul 2014 16:17:42 +0900
Message-ID: <1406013463-19218-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_lock/unlock_as_irq() are working with (chip, offset) arguments and
are thus not using the old integer namespace. Therefore, there is no
reason to have gpiod variants of these functions working with
descriptors, especially since the (chip, offset) tuple is more suitable
to the users of these functions (GPIO drivers, whereas GPIO descriptors
are targeted at GPIO consumers).

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/gpio/driver.txt |  4 ++--
 drivers/gpio/gpiolib-acpi.c   |  6 +++---
 drivers/gpio/gpiolib-legacy.c | 12 ------------
 drivers/gpio/gpiolib-sysfs.c  |  4 ++--
 drivers/gpio/gpiolib.c        | 30 ++++++++++++++++--------------
 include/asm-generic/gpio.h    |  3 ---
 include/linux/gpio/driver.h   |  4 ++--
 7 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/Documentation/gpio/driver.txt b/Documentation/gpio/driver.txt
index fa9a0a8b3734..224dbbcd1804 100644
--- a/Documentation/gpio/driver.txt
+++ b/Documentation/gpio/driver.txt
@@ -157,12 +157,12 @@ Locking IRQ usage
 Input GPIOs can be used as IRQ signals. When this happens, a driver is requested
 to mark the GPIO as being used as an IRQ:
 
-	int gpiod_lock_as_irq(struct gpio_desc *desc)
+	int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 
 This will prevent the use of non-irq related GPIO APIs until the GPIO IRQ lock
 is released:
 
-	void gpiod_unlock_as_irq(struct gpio_desc *desc)
+	void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 
 When implementing an irqchip inside a GPIO driver, these two functions should
 typically be called in the .startup() and .shutdown() callbacks from the
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 4a987917c186..d2e8600df02c 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -157,7 +157,7 @@ static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
 
 	gpiod_direction_input(desc);
 
-	ret = gpiod_lock_as_irq(desc);
+	ret = gpio_lock_as_irq(chip, pin);
 	if (ret) {
 		dev_err(chip->dev, "Failed to lock GPIO as interrupt\n");
 		goto fail_free_desc;
@@ -212,7 +212,7 @@ static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
 fail_free_event:
 	kfree(event);
 fail_unlock_irq:
-	gpiod_unlock_as_irq(desc);
+	gpio_unlock_as_irq(chip, pin);
 fail_free_desc:
 	gpiochip_free_own_desc(desc);
 
@@ -263,7 +263,7 @@ static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *acpi_gpio)
 		desc = gpiochip_get_desc(chip, event->pin);
 		if (WARN_ON(IS_ERR(desc)))
 			continue;
-		gpiod_unlock_as_irq(desc);
+		gpio_unlock_as_irq(chip, event->pin);
 		gpiochip_free_own_desc(desc);
 		list_del(&event->node);
 		kfree(event);
diff --git a/drivers/gpio/gpiolib-legacy.c b/drivers/gpio/gpiolib-legacy.c
index eb5a4e2cee85..c3e3823a40b9 100644
--- a/drivers/gpio/gpiolib-legacy.c
+++ b/drivers/gpio/gpiolib-legacy.c
@@ -97,15 +97,3 @@ void gpio_free_array(const struct gpio *array, size_t num)
 		gpio_free((array++)->gpio);
 }
 EXPORT_SYMBOL_GPL(gpio_free_array);
-
-int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
-{
-	return gpiod_lock_as_irq(gpiochip_get_desc(chip, offset));
-}
-EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
-
-void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
-{
-	return gpiod_unlock_as_irq(gpiochip_get_desc(chip, offset));
-}
-EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index f150aa288fa1..be45a9283c28 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -161,7 +161,7 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	desc->flags &= ~GPIO_TRIGGER_MASK;
 
 	if (!gpio_flags) {
-		gpiod_unlock_as_irq(desc);
+		gpio_unlock_as_irq(desc->chip, gpio_chip_hwgpio(desc));
 		ret = 0;
 		goto free_id;
 	}
@@ -200,7 +200,7 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	if (ret < 0)
 		goto free_id;
 
-	ret = gpiod_lock_as_irq(desc);
+	ret = gpio_lock_as_irq(desc->chip, gpio_chip_hwgpio(desc));
 	if (ret < 0) {
 		gpiod_warn(desc, "failed to flag the GPIO for IRQ\n");
 		goto free_id;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 38d176e31379..7582207c92e7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1428,44 +1428,46 @@ int gpiod_to_irq(const struct gpio_desc *desc)
 EXPORT_SYMBOL_GPL(gpiod_to_irq);
 
 /**
- * gpiod_lock_as_irq() - lock a GPIO to be used as IRQ
- * @gpio: the GPIO line to lock as used for IRQ
+ * gpio_lock_as_irq() - lock a GPIO to be used as IRQ
+ * @chip: the chip the GPIO to lock belongs to
+ * @offset: the offset of the GPIO to lock as IRQ
  *
  * This is used directly by GPIO drivers that want to lock down
  * a certain GPIO line to be used for IRQs.
  */
-int gpiod_lock_as_irq(struct gpio_desc *desc)
+int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
-	if (!desc)
+	if (offset >= chip->ngpio)
 		return -EINVAL;
 
-	if (test_bit(FLAG_IS_OUT, &desc->flags)) {
-		gpiod_err(desc,
+	if (test_bit(FLAG_IS_OUT, &chip->desc[offset].flags)) {
+		chip_err(chip,
 			  "%s: tried to flag a GPIO set as output for IRQ\n",
 			  __func__);
 		return -EIO;
 	}
 
-	set_bit(FLAG_USED_AS_IRQ, &desc->flags);
+	set_bit(FLAG_USED_AS_IRQ, &chip->desc[offset].flags);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(gpiod_lock_as_irq);
+EXPORT_SYMBOL_GPL(gpio_lock_as_irq);
 
 /**
- * gpiod_unlock_as_irq() - unlock a GPIO used as IRQ
- * @gpio: the GPIO line to unlock from IRQ usage
+ * gpio_unlock_as_irq() - unlock a GPIO used as IRQ
+ * @chip: the chip the GPIO to lock belongs to
+ * @offset: the offset of the GPIO to lock as IRQ
  *
  * This is used directly by GPIO drivers that want to indicate
  * that a certain GPIO is no longer used exclusively for IRQ.
  */
-void gpiod_unlock_as_irq(struct gpio_desc *desc)
+void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset)
 {
-	if (!desc)
+	if (offset >= chip->ngpio)
 		return;
 
-	clear_bit(FLAG_USED_AS_IRQ, &desc->flags);
+	clear_bit(FLAG_USED_AS_IRQ, &chip->desc[offset].flags);
 }
-EXPORT_SYMBOL_GPL(gpiod_unlock_as_irq);
+EXPORT_SYMBOL_GPL(gpio_unlock_as_irq);
 
 /**
  * gpiod_get_raw_value_cansleep() - return a gpio's raw value
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 23e364538ab5..c1d4105e1c1d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -110,9 +110,6 @@ static inline int __gpio_to_irq(unsigned gpio)
 	return gpiod_to_irq(gpio_to_desc(gpio));
 }
 
-extern int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset);
-extern void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset);
-
 extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
 extern int gpio_request_array(const struct gpio *array, size_t num);
 extern void gpio_free_array(const struct gpio *array, size_t num);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 4dc79714c136..7b8b00235d29 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -146,8 +146,8 @@ extern struct gpio_chip *gpiochip_find(void *data,
 			      int (*match)(struct gpio_chip *chip, void *data));
 
 /* lock/unlock as IRQ */
-int gpiod_lock_as_irq(struct gpio_desc *desc);
-void gpiod_unlock_as_irq(struct gpio_desc *desc);
+int gpio_lock_as_irq(struct gpio_chip *chip, unsigned int offset);
+void gpio_unlock_as_irq(struct gpio_chip *chip, unsigned int offset);
 
 struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc);
 
-- 
2.0.1

