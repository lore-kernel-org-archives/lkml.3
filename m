Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3KPMqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 07:46:18 -0500
Received: from gnurou.org ([207.192.72.5]:53219 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3KPMqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 07:46:12 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: use dedicated flags for GPIO properties
Date: Sat, 16 Nov 2013 21:44:52 +0900
Message-Id: <1384605892-10072-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO mapping properties were defined using the GPIOF_* flags, which are
declared in linux/gpio.h. This file is not included when using the
GPIO descriptor interface.

This patch declares the flags that can be used as GPIO mappings
properties in linux/gpio/driver.h, and uses them in gpiolib, so that no
deprecated declarations are used by the GPIO descriptor interface.

This patch also allows GPIO_OPEN_DRAIN and GPIO_OPEN_SOURCE to be
specified as GPIO mapping properties.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
--
The new GPIO interface documentation already uses these new declarations.
It would be nice to have this merged in a 3.13-rc since it is necessary
to properly declare GPIO mappings as platform data.
---
 drivers/gpio/gpiolib.c      | 22 +++++++++++++++-------
 include/linux/gpio/driver.h | 11 +++++++++--
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 63bbf5b..be5dbc2 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -13,6 +13,7 @@
 #include <linux/acpi_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/gpio/driver.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/gpio.h>
@@ -2226,7 +2227,8 @@ void gpiod_add_table(struct gpiod_lookup *table, size_t size)
 
 #ifdef CONFIG_OF
 static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
-				      unsigned int idx, unsigned long *flags)
+				      unsigned int idx,
+				      enum gpio_lookup_flags *flags)
 {
 	char prop_name[32]; /* 32 is max size of property name */
 	enum of_gpio_flags of_flags;
@@ -2244,7 +2246,7 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 		return desc;
 
 	if (of_flags & OF_GPIO_ACTIVE_LOW)
-		*flags |= GPIOF_ACTIVE_LOW;
+		*flags |= GPIO_ACTIVE_LOW;
 
 	return desc;
 }
@@ -2257,7 +2259,8 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 #endif
 
 static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
-					unsigned int idx, unsigned long *flags)
+					unsigned int idx,
+					enum gpio_lookup_flags *flags)
 {
 	struct acpi_gpio_info info;
 	struct gpio_desc *desc;
@@ -2267,13 +2270,14 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
 		return desc;
 
 	if (info.gpioint && info.active_low)
-		*flags |= GPIOF_ACTIVE_LOW;
+		*flags |= GPIO_ACTIVE_LOW;
 
 	return desc;
 }
 
 static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
-				    unsigned int idx, unsigned long *flags)
+				    unsigned int idx,
+				    enum gpio_lookup_flags *flags)
 {
 	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct gpio_desc *desc = ERR_PTR(-ENODEV);
@@ -2365,7 +2369,7 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 {
 	struct gpio_desc *desc;
 	int status;
-	unsigned long flags = 0;
+	enum gpio_lookup_flags flags = 0;
 
 	dev_dbg(dev, "GPIO lookup for consumer %s\n", con_id);
 
@@ -2391,8 +2395,12 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 	if (status < 0)
 		return ERR_PTR(status);
 
-	if (flags & GPIOF_ACTIVE_LOW)
+	if (flags & GPIO_ACTIVE_LOW)
 		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+	if (flags & GPIO_OPEN_DRAIN)
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
+	if (flags & GPIO_OPEN_SOURCE)
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
 
 	return desc;
 }
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 656a27e..82eac61 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -125,6 +125,13 @@ extern struct gpio_chip *gpiochip_find(void *data,
 int gpiod_lock_as_irq(struct gpio_desc *desc);
 void gpiod_unlock_as_irq(struct gpio_desc *desc);
 
+enum gpio_lookup_flags {
+	GPIO_ACTIVE_HIGH = (0 << 0),
+	GPIO_ACTIVE_LOW = (1 << 0),
+	GPIO_OPEN_DRAIN = (1 << 1),
+	GPIO_OPEN_SOURCE = (1 << 2),
+};
+
 /**
  * Lookup table for associating GPIOs to specific devices and functions using
  * platform data.
@@ -152,9 +159,9 @@ struct gpiod_lookup {
 	 */
 	unsigned int idx;
 	/*
-	 * mask of GPIOF_* values
+	 * mask of GPIO_* values
 	 */
-	unsigned long flags;
+	enum gpio_lookup_flags flags;
 };
 
 /*
-- 
1.8.4.2

