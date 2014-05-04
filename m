Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaEDDxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 23:53:43 -0400
Received: from gnurou.org ([207.192.72.5]:50651 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbaEDDxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 23:53:42 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 May 2014 23:53:42 EDT
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: make of_get_named_gpiod_flags() private
Date: Sun,  4 May 2014 12:45:25 +0900
Message-Id: <1399175125-6430-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpiod_flags() is visible and directly usable by GPIO
consumers, but it really should not as the gpiod interface relies
on the simpler gpiod_get() to provide properly-configured GPIOs.

of_get_named_gpiod_flags() is just used internally by gpiolib to
implement gpiod_get(), and by the old of_get_named_gpio_flags()
function, therefore it makes sense to make it gpiolib-private.

As a side-effect, the unused (and unneeded) of_get_gpiod_flags()
inline function is also removed, and of_get_named_gpio_flags() is moved
from a static inline function to a regular one in gpiolib-of.c

This results in all references to gpiod_* functions in of_gpio.h being
gone, which is the way it should be since this file is part of the old
integer GPIO interface.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-of.c | 14 ++++++++++++++
 drivers/gpio/gpiolib.h    |  3 +++
 include/linux/of_gpio.h   | 39 ++-------------------------------------
 3 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index db98d3a..af7e25c 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -96,6 +96,20 @@ struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 }
 EXPORT_SYMBOL(of_get_named_gpiod_flags);
 
+int of_get_named_gpio_flags(struct device_node *np, const char *list_name,
+			    int index, enum of_gpio_flags *flags)
+{
+	struct gpio_desc *desc;
+
+	desc = of_get_named_gpiod_flags(np, list_name, index, flags);
+
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+	else
+		return desc_to_gpio(desc);
+}
+EXPORT_SYMBOL(of_get_named_gpio_flags);
+
 /**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index cf09294..f75c82e 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -46,4 +46,7 @@ acpi_get_gpiod_by_index(struct device *dev, int index,
 int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
 void gpiochip_free_own_desc(struct gpio_desc *desc);
 
+struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
+		   const char *list_name, int index, enum of_gpio_flags *flags);
+
 #endif /* GPIOLIB_H */
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index f14123a..123883c 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -19,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
-#include <linux/gpio/consumer.h>
 
 struct device_node;
 
@@ -48,9 +47,6 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 	return container_of(gc, struct of_mm_gpio_chip, gc);
 }
 
-extern struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
-		const char *list_name, int index, enum of_gpio_flags *flags);
-
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 
@@ -63,12 +59,6 @@ extern int of_gpio_simple_xlate(struct gpio_chip *gc,
 #else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
-static inline struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
-		const char *list_name, int index, enum of_gpio_flags *flags)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
 static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
 				       const struct of_phandle_args *gpiospec,
 				       u32 *flags)
@@ -81,17 +71,8 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 
 #endif /* CONFIG_OF_GPIO */
 
-static inline int of_get_named_gpio_flags(struct device_node *np,
-		const char *list_name, int index, enum of_gpio_flags *flags)
-{
-	struct gpio_desc *desc;
-	desc = of_get_named_gpiod_flags(np, list_name, index, flags);
-
-	if (IS_ERR(desc))
-		return PTR_ERR(desc);
-	else
-		return desc_to_gpio(desc);
-}
+extern int of_get_named_gpio_flags(struct device_node *np,
+		const char *list_name, int index, enum of_gpio_flags *flags);
 
 /**
  * of_gpio_named_count() - Count GPIOs for a device
@@ -129,22 +110,6 @@ static inline int of_gpio_count(struct device_node *np)
 	return of_gpio_named_count(np, "gpios");
 }
 
-/**
- * of_get_gpiod_flags() - Get a GPIO descriptor and flags to use with GPIO API
- * @np:		device node to get GPIO from
- * @index:	index of the GPIO
- * @flags:	a flags pointer to fill in
- *
- * Returns GPIO descriptor to use with Linux generic GPIO API, or a errno
- * value on the error condition. If @flags is not NULL the function also fills
- * in flags for the GPIO.
- */
-static inline struct gpio_desc *of_get_gpiod_flags(struct device_node *np,
-					int index, enum of_gpio_flags *flags)
-{
-	return of_get_named_gpiod_flags(np, "gpios", index, flags);
-}
-
 static inline int of_get_gpio_flags(struct device_node *np, int index,
 		      enum of_gpio_flags *flags)
 {
-- 
1.9.2

