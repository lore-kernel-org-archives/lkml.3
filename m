Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3IMPPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:15:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:43631 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab3IMPOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,898,1371106800"; 
   d="scan'208";a="294519574"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 1/2] gpio / ACPI: register to ACPI events automatically
Date: Fri, 13 Sep 2013 18:14:39 +0300
Message-Id: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of asking each driver to register to the ACPI events we can just
call acpi_gpiochip_register_interrupts() for each chip that has ACPI
handle. It checks chip->to_irq and if it is set to NULL (a GPIO driver that
doesn't do interrupts) the function does nothing.

Also make the event interface to be private to gpiolib-acpi and remove call
to the API from the one existing user (pinctrl-baytrail.c).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c        | 18 ++++++++++++++----
 drivers/gpio/gpiolib.c             |  3 +++
 drivers/pinctrl/pinctrl-baytrail.c |  4 ----
 include/linux/acpi_gpio.h          |  8 ++++----
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 5c1ef2b..e12a08e 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -101,7 +101,7 @@ static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
  * gpio pins have acpi event methods and assigns interrupt handlers that calls
  * the acpi event methods for those pins.
  */
-void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
+static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 {
 	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
 	struct acpi_resource *res;
@@ -199,7 +199,6 @@ void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 				irq);
 	}
 }
-EXPORT_SYMBOL(acpi_gpiochip_request_interrupts);
 
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
@@ -288,7 +287,7 @@ EXPORT_SYMBOL_GPL(acpi_get_gpio_by_index);
  * The remaining ACPI event interrupts associated with the chip are freed
  * automatically.
  */
-void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
+static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -315,4 +314,15 @@ void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 	acpi_detach_data(handle, acpi_gpio_evt_dh);
 	kfree(evt_pins);
 }
-EXPORT_SYMBOL(acpi_gpiochip_free_interrupts);
+
+void acpi_gpiochip_add(struct gpio_chip *chip)
+{
+	acpi_gpiochip_request_interrupts(chip);
+}
+EXPORT_SYMBOL_GPL(acpi_gpiochip_add);
+
+void acpi_gpiochip_remove(struct gpio_chip *chip)
+{
+	acpi_gpiochip_free_interrupts(chip);
+}
+EXPORT_SYMBOL_GPL(acpi_gpiochip_remove);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ff0fd65..5c83657 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
+#include <linux/acpi_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
 
@@ -1221,6 +1222,7 @@ int gpiochip_add(struct gpio_chip *chip)
 #endif
 
 	of_gpiochip_add(chip);
+	acpi_gpiochip_add(chip);
 
 	if (status)
 		goto fail;
@@ -1262,6 +1264,7 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
+	acpi_gpiochip_remove(chip);
 
 	for (id = 0; id < chip->ngpio; id++) {
 		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e9d735d..a49a070 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -29,7 +29,6 @@
 #include <linux/gpio.h>
 #include <linux/irqdomain.h>
 #include <linux/acpi.h>
-#include <linux/acpi_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/seq_file.h>
 #include <linux/io.h>
@@ -481,9 +480,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
 
 		irq_set_handler_data(hwirq, vg);
 		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
-
-		/* Register interrupt handlers for gpio signaled acpi events */
-		acpi_gpiochip_request_interrupts(gc);
 	}
 
 	pm_runtime_enable(dev);
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
index 4c120a1..e38af63 100644
--- a/include/linux/acpi_gpio.h
+++ b/include/linux/acpi_gpio.h
@@ -18,8 +18,8 @@ struct acpi_gpio_info {
 int acpi_get_gpio(char *path, int pin);
 int acpi_get_gpio_by_index(struct device *dev, int index,
 			   struct acpi_gpio_info *info);
-void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
-void acpi_gpiochip_free_interrupts(struct gpio_chip *chip);
+void acpi_gpiochip_add(struct gpio_chip *chip);
+void acpi_gpiochip_remove(struct gpio_chip *chip);
 
 #else /* CONFIG_GPIO_ACPI */
 
@@ -34,8 +34,8 @@ static inline int acpi_get_gpio_by_index(struct device *dev, int index,
 	return -ENODEV;
 }
 
-static inline void acpi_gpiochip_request_interrupts(struct gpio_chip *chip) { }
-static inline void acpi_gpiochip_free_interrupts(struct gpio_chip *chip) { }
+static inline void acpi_gpiochip_add(struct gpio_chip *chip) {}
+static inline void acpi_gpiochip_remove(struct gpio_chip *chip) {}
 
 #endif /* CONFIG_GPIO_ACPI */
 
-- 
1.8.4.rc3

