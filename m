Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3JAO7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:59:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:17567 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3JAO7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:59:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="368267925"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/5] gpiolib / ACPI: convert to gpiod interfaces
Date: Tue,  1 Oct 2013 17:58:54 +0300
Message-Id: <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new GPIO descriptor based interface is now preferred over the old
integer based one. This patch converts the ACPI GPIO helpers to use this
new interface internally. In addition to that provide compatibility
functions acpi_get_gpio() and acpi_get_gpio_by_index() that convert the
returned GPIO descriptors to integers.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 51 +++++++++++++++++++++------------------------
 include/linux/acpi_gpio.h   | 38 ++++++++++++++++++++++++++-------
 2 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 1745ce5..333297c 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/errno.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/export.h>
 #include <linux/acpi_gpio.h>
 #include <linux/acpi.h>
@@ -33,14 +33,15 @@ static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
 }
 
 /**
- * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
+ * acpi_get_gpiod() - Translate ACPI GPIO pin to GPIO descriptor usable with GPIO API
  * @path:	ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
  * @pin:	ACPI GPIO pin number (0-based, controller-relative)
  *
- * Returns GPIO number to use with Linux generic GPIO API, or errno error value
+ * Returns GPIO descriptor to use with Linux generic GPIO API, or ERR_PTR
+ * error value
  */
 
-int acpi_get_gpio(char *path, int pin)
+struct gpio_desc *acpi_get_gpiod(char *path, int pin)
 {
 	struct gpio_chip *chip;
 	acpi_handle handle;
@@ -48,18 +49,15 @@ int acpi_get_gpio(char *path, int pin)
 
 	status = acpi_get_handle(NULL, path, &handle);
 	if (ACPI_FAILURE(status))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	chip = gpiochip_find(handle, acpi_gpiochip_find);
 	if (!chip)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
-	if (!gpio_is_valid(chip->base + pin))
-		return -EINVAL;
-
-	return chip->base + pin;
+	return gpio_to_desc(chip->base + pin);
 }
-EXPORT_SYMBOL_GPL(acpi_get_gpio);
+EXPORT_SYMBOL_GPL(acpi_get_gpiod);
 
 static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
 {
@@ -235,7 +233,7 @@ EXPORT_SYMBOL(acpi_gpiochip_free_interrupts);
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
 	int index;
-	int gpio;
+	struct gpio_desc *desc;
 	int n;
 };
 
@@ -246,11 +244,11 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
 	if (ares->type != ACPI_RESOURCE_TYPE_GPIO)
 		return 1;
 
-	if (lookup->n++ == lookup->index && lookup->gpio < 0) {
+	if (lookup->n++ == lookup->index && !lookup->desc) {
 		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
 
-		lookup->gpio = acpi_get_gpio(agpio->resource_source.string_ptr,
-					     agpio->pin_table[0]);
+		lookup->desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
+					      agpio->pin_table[0]);
 		lookup->info.gpioint =
 			agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
 	}
@@ -259,24 +257,24 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
 }
 
 /**
- * acpi_get_gpio_by_index() - get a GPIO number from device resources
+ * acpi_get_gpiod_by_index() - get a GPIO descriptor from device resources
  * @dev: pointer to a device to get GPIO from
  * @index: index of GpioIo/GpioInt resource (starting from %0)
  * @info: info pointer to fill in (optional)
  *
  * Function goes through ACPI resources for @dev and based on @index looks
- * up a GpioIo/GpioInt resource, translates it to the Linux GPIO number,
+ * up a GpioIo/GpioInt resource, translates it to the Linux GPIO descriptor,
  * and returns it. @index matches GpioIo/GpioInt resources only so if there
  * are total %3 GPIO resources, the index goes from %0 to %2.
  *
- * If the GPIO cannot be translated or there is an error, negative errno is
+ * If the GPIO cannot be translated or there is an error an ERR_PTR is
  * returned.
  *
  * Note: if the GPIO resource has multiple entries in the pin list, this
  * function only returns the first.
  */
-int acpi_get_gpio_by_index(struct device *dev, int index,
-			   struct acpi_gpio_info *info)
+struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
+					  struct acpi_gpio_info *info)
 {
 	struct acpi_gpio_lookup lookup;
 	struct list_head resource_list;
@@ -285,27 +283,26 @@ int acpi_get_gpio_by_index(struct device *dev, int index,
 	int ret;
 
 	if (!dev)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	handle = ACPI_HANDLE(dev);
 	if (!handle || acpi_bus_get_device(handle, &adev))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	memset(&lookup, 0, sizeof(lookup));
 	lookup.index = index;
-	lookup.gpio = -ENODEV;
 
 	INIT_LIST_HEAD(&resource_list);
 	ret = acpi_dev_get_resources(adev, &resource_list, acpi_find_gpio,
 				     &lookup);
 	if (ret < 0)
-		return ret;
+		return ERR_PTR(ret);
 
 	acpi_dev_free_resource_list(&resource_list);
 
-	if (lookup.gpio >= 0 && info)
+	if (lookup.desc && info)
 		*info = lookup.info;
 
-	return lookup.gpio;
+	return lookup.desc ? lookup.desc : ERR_PTR(-ENODEV);
 }
-EXPORT_SYMBOL_GPL(acpi_get_gpio_by_index);
+EXPORT_SYMBOL_GPL(acpi_get_gpiod_by_index);
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
index 4c120a1..bbfa83a 100644
--- a/include/linux/acpi_gpio.h
+++ b/include/linux/acpi_gpio.h
@@ -2,8 +2,10 @@
 #define _LINUX_ACPI_GPIO_H_
 
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 
 /**
  * struct acpi_gpio_info - ACPI GPIO specific information
@@ -15,23 +17,24 @@ struct acpi_gpio_info {
 
 #ifdef CONFIG_GPIO_ACPI
 
-int acpi_get_gpio(char *path, int pin);
-int acpi_get_gpio_by_index(struct device *dev, int index,
-			   struct acpi_gpio_info *info);
+struct gpio_desc *acpi_get_gpiod(char *path, int pin);
+struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
+					  struct acpi_gpio_info *info);
 void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
 void acpi_gpiochip_free_interrupts(struct gpio_chip *chip);
 
 #else /* CONFIG_GPIO_ACPI */
 
-static inline int acpi_get_gpio(char *path, int pin)
+static inline struct gpio_desc *acpi_get_gpiod(char *path, int pin)
 {
-	return -ENODEV;
+	return ERR_PTR(-ENOSYS);
 }
 
-static inline int acpi_get_gpio_by_index(struct device *dev, int index,
-					 struct acpi_gpio_info *info)
+static inline struct gpio_desc *
+acpi_get_gpiod_by_index(struct device *dev, int index,
+			struct acpi_gpio_info *info)
 {
-	return -ENODEV;
+	return ERR_PTR(-ENOSYS);
 }
 
 static inline void acpi_gpiochip_request_interrupts(struct gpio_chip *chip) { }
@@ -39,4 +42,23 @@ static inline void acpi_gpiochip_free_interrupts(struct gpio_chip *chip) { }
 
 #endif /* CONFIG_GPIO_ACPI */
 
+static inline int acpi_get_gpio(char *path, int pin)
+{
+	struct gpio_desc *desc = acpi_get_gpiod(path, pin);
+
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+	return desc_to_gpio(desc);
+}
+
+static inline int acpi_get_gpio_by_index(struct device *dev, int index,
+					 struct acpi_gpio_info *info)
+{
+	struct gpio_desc *desc = acpi_get_gpiod_by_index(dev, index, info);
+
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+	return desc_to_gpio(desc);
+}
+
 #endif /* _LINUX_ACPI_GPIO_H_ */
-- 
1.8.4.rc3

