Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3JKSPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:15:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15714 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JKSOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:14:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Oct 2013 11:10:38 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>, <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 2/3] gpiolib: port of_ functions to use gpiod
Date: Fri, 11 Oct 2013 11:14:32 -0700
Message-ID: <1381515273-25466-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381515273-25466-1-git-send-email-acourbot@nvidia.com>
References: <1381515273-25466-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the of_ functions of gpiolib to use the now public gpiod
interface, and export of_get_named_gpiod_flags() and
of_get_gpiod_flags() functions.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-of.c | 28 +++++++++++++++++-----------
 include/linux/of_gpio.h   | 29 ++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 0dfaf20..32a396d 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -15,19 +15,21 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/io.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
 
+struct gpio_desc;
+
 /* Private data structure for of_gpiochip_find_and_xlate */
 struct gg_data {
 	enum of_gpio_flags *flags;
 	struct of_phandle_args gpiospec;
 
-	int out_gpio;
+	struct gpio_desc *out_gpio;
 };
 
 /* Private function for resolving node pointer to gpio_chip */
@@ -45,28 +47,31 @@ static int of_gpiochip_find_and_xlate(struct gpio_chip *gc, void *data)
 	if (ret < 0)
 		return false;
 
-	gg_data->out_gpio = ret + gc->base;
+	gg_data->out_gpio = gpio_to_desc(ret + gc->base);
 	return true;
 }
 
 /**
- * of_get_named_gpio_flags() - Get a GPIO number and flags to use with GPIO API
+ * of_get_named_gpiod_flags() - Get a GPIO descriptor and flags for GPIO API
  * @np:		device node to get GPIO from
  * @propname:	property name containing gpio specifier(s)
  * @index:	index of the GPIO
  * @flags:	a flags pointer to fill in
  *
- * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
+ * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
  * value on the error condition. If @flags is not NULL the function also fills
  * in flags for the GPIO.
  */
-int of_get_named_gpio_flags(struct device_node *np, const char *propname,
-			   int index, enum of_gpio_flags *flags)
+struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
+		     const char *propname, int index, enum of_gpio_flags *flags)
 {
 	/* Return -EPROBE_DEFER to support probe() functions to be called
 	 * later when the GPIO actually becomes available
 	 */
-	struct gg_data gg_data = { .flags = flags, .out_gpio = -EPROBE_DEFER };
+	struct gg_data gg_data = {
+		.flags = flags,
+		.out_gpio = ERR_PTR(-EPROBE_DEFER)
+	};
 	int ret;
 
 	/* .of_xlate might decide to not fill in the flags, so clear it. */
@@ -78,16 +83,17 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
 	if (ret) {
 		pr_debug("%s: can't parse gpios property of node '%s[%d]'\n",
 			__func__, np->full_name, index);
-		return ret;
+		return ERR_PTR(ret);
 	}
 
 	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
 
 	of_node_put(gg_data.gpiospec.np);
-	pr_debug("%s exited with status %d\n", __func__, gg_data.out_gpio);
+	pr_debug("%s exited with status %d\n", __func__,
+		 PTR_RET(gg_data.out_gpio));
 	return gg_data.out_gpio;
 }
-EXPORT_SYMBOL(of_get_named_gpio_flags);
+EXPORT_SYMBOL(of_get_named_gpiod_flags);
 
 /**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index a83dc6f..d71f2cc 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 
 struct device_node;
+struct gpio_desc;
 
 /*
  * This is Linux-specific flags. By default controllers' and Linux' mapping
@@ -47,7 +48,7 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 	return container_of(gc, struct of_mm_gpio_chip, gc);
 }
 
-extern int of_get_named_gpio_flags(struct device_node *np,
+extern struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags);
 
 extern int of_mm_gpiochip_add(struct device_node *np,
@@ -62,10 +63,10 @@ extern int of_gpio_simple_xlate(struct gpio_chip *gc,
 #else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
-static inline int of_get_named_gpio_flags(struct device_node *np,
+static inline struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags)
 {
-	return -ENOSYS;
+	return ERR_PTR(-ENOSYS);
 }
 
 static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
@@ -80,6 +81,18 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 
 #endif /* CONFIG_OF_GPIO */
 
+static inline int of_get_named_gpio_flags(struct device_node *np,
+		const char *list_name, int index, enum of_gpio_flags *flags)
+{
+	struct gpio_desc *desc;
+	desc = of_get_named_gpiod_flags(np, list_name, index, flags);
+
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+	else
+		return desc_to_gpio(desc);
+}
+
 /**
  * of_gpio_named_count() - Count GPIOs for a device
  * @np:		device node to count GPIOs for
@@ -117,15 +130,21 @@ static inline int of_gpio_count(struct device_node *np)
 }
 
 /**
- * of_get_gpio_flags() - Get a GPIO number and flags to use with GPIO API
+ * of_get_gpiod_flags() - Get a GPIO descriptor and flags to use with GPIO API
  * @np:		device node to get GPIO from
  * @index:	index of the GPIO
  * @flags:	a flags pointer to fill in
  *
- * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
+ * Returns GPIO descriptor to use with Linux generic GPIO API, or a errno
  * value on the error condition. If @flags is not NULL the function also fills
  * in flags for the GPIO.
  */
+static inline struct gpio_desc *of_get_gpiod_flags(struct device_node *np,
+					int index, enum of_gpio_flags *flags)
+{
+	return of_get_named_gpiod_flags(np, "gpios", index, flags);
+}
+
 static inline int of_get_gpio_flags(struct device_node *np, int index,
 		      enum of_gpio_flags *flags)
 {
-- 
1.8.4

