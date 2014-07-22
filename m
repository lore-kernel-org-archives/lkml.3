Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaGVFSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:18:32 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48869 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGVFSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:18:30 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2] gpiolib: Export gpiochip_request_own_desc and gpiochip_free_own_desc
Date: Mon, 21 Jul 2014 22:18:25 -0700
Message-Id: <1406006305-22694-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions were introduced to let gpio drivers request their own
gpio pins. Without exporting the functions, this can however only be
used by gpio drivers built into the kernel.

Secondary impact is that the functions can not currently be used by
platform initialization code associated with the gpio-pca953x driver.
This code permits auto-export of gpio pins through platform data, but
if this functionality is used, the module can no longer be unloaded due
to the problem solved with the introduction of gpiochip_request_own_desc
and gpiochip_free_own_desc.

Export both function so they can be used from modules and from
platform initialization code.

Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Move function declarations from consumer.h to driver.h.

 drivers/gpio/gpiolib.c      | 2 ++
 drivers/gpio/gpiolib.h      | 3 ---
 include/linux/gpio/driver.h | 3 +++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 43d9e34..04c647e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1953,6 +1953,7 @@ int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label)
 
 	return __gpiod_request(desc, label);
 }
+EXPORT_SYMBOL(gpiochip_request_own_desc);
 
 /**
  * gpiochip_free_own_desc - Free GPIO requested by the chip driver
@@ -1966,6 +1967,7 @@ void gpiochip_free_own_desc(struct gpio_desc *desc)
 	if (desc)
 		__gpiod_free(desc);
 }
+EXPORT_SYMBOL(gpiochip_free_own_desc);
 
 /* Drivers MUST set GPIO direction before making get/set calls.  In
  * some cases this is done in early boot, before IRQs are enabled.
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 1a4103d..2bdb69d 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -45,9 +45,6 @@ acpi_get_gpiod_by_index(struct device *dev, int index,
 }
 #endif
 
-int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
-void gpiochip_free_own_desc(struct gpio_desc *desc);
-
 struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 		   const char *list_name, int index, enum of_gpio_flags *flags);
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 573e4f3..8e07d58 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -223,6 +223,9 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
 
 #endif /* CONFIG_GPIO_IRQCHIP */
 
+int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
+void gpiochip_free_own_desc(struct gpio_desc *desc);
+
 #else /* CONFIG_GPIOLIB */
 
 static inline struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
-- 
1.9.1

