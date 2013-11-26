Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3KZKGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:06:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:16473 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab3KZKGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:06:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,773,1378882800"; 
   d="scan'208";a="442073178"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] gpio / ACPI: register to ACPI events automatically
Date: Tue, 26 Nov 2013 12:05:48 +0200
Message-Id: <1385460350-17543-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of asking each driver to register to ACPI events we can just call
acpi_gpiochip_register_interrupts() for each chip that has an ACPI handle.
The function checks chip->to_irq and if it is set to NULL (a GPIO driver
that doesn't do interrupts) the function does nothing.

We also add the a new header drivers/gpio/gpiolib.h that is used for
functions internal to gpiolib and add ACPI GPIO chip registering functions
to that header.

Once that is done we can remove call to acpi_gpiochip_register_interrupts()
from its only user, pinctrl-baytrail.c

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/gpio/gpiolib-acpi.c        | 16 ++++++++++++----
 drivers/gpio/gpiolib.c             |  4 ++++
 drivers/gpio/gpiolib.h             | 23 +++++++++++++++++++++++
 drivers/pinctrl/pinctrl-baytrail.c |  4 ----
 include/linux/acpi_gpio.h          |  6 ------
 5 files changed, 39 insertions(+), 14 deletions(-)
 create mode 100644 drivers/gpio/gpiolib.h

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index ae0ffdce8bd5..cb2da66fbbfe 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -94,7 +94,7 @@ static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
  * gpio pins have acpi event methods and assigns interrupt handlers that calls
  * the acpi event methods for those pins.
  */
-void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
+static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 {
 	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
 	struct acpi_resource *res;
@@ -192,7 +192,6 @@ void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 				irq);
 	}
 }
-EXPORT_SYMBOL(acpi_gpiochip_request_interrupts);
 
 /**
  * acpi_gpiochip_free_interrupts() - Free GPIO _EVT ACPI event interrupts.
@@ -203,7 +202,7 @@ EXPORT_SYMBOL(acpi_gpiochip_request_interrupts);
  * The remaining ACPI event interrupts associated with the chip are freed
  * automatically.
  */
-void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
+static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -230,7 +229,6 @@ void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 	acpi_detach_data(handle, acpi_gpio_evt_dh);
 	kfree(evt_pins);
 }
-EXPORT_SYMBOL(acpi_gpiochip_free_interrupts);
 
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
@@ -310,3 +308,13 @@ struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 	return lookup.desc ? lookup.desc : ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL_GPL(acpi_get_gpiod_by_index);
+
+void acpi_gpiochip_add(struct gpio_chip *chip)
+{
+	acpi_gpiochip_request_interrupts(chip);
+}
+
+void acpi_gpiochip_remove(struct gpio_chip *chip)
+{
+	acpi_gpiochip_free_interrupts(chip);
+}
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 4e10b10d3ddd..70abccf0d144 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -15,6 +15,8 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 
+#include "gpiolib.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/gpio.h>
 
@@ -1212,6 +1214,7 @@ int gpiochip_add(struct gpio_chip *chip)
 #endif
 
 	of_gpiochip_add(chip);
+	acpi_gpiochip_add(chip);
 
 	if (status)
 		goto fail;
@@ -1253,6 +1256,7 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
+	acpi_gpiochip_remove(chip);
 
 	for (id = 0; id < chip->ngpio; id++) {
 		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
new file mode 100644
index 000000000000..2ed23ab8298c
--- /dev/null
+++ b/drivers/gpio/gpiolib.h
@@ -0,0 +1,23 @@
+/*
+ * Internal GPIO functions.
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GPIOLIB_H
+#define GPIOLIB_H
+
+#ifdef CONFIG_ACPI
+void acpi_gpiochip_add(struct gpio_chip *chip);
+void acpi_gpiochip_remove(struct gpio_chip *chip);
+#else
+static inline void acpi_gpiochip_add(struct gpio_chip *chip) { }
+static inline void acpi_gpiochip_remove(struct gpio_chip *chip) { }
+#endif
+
+#endif /* GPIOLIB_H */
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 2832576d8b12..98b87a59df2d 100644
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
@@ -485,9 +484,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
 
 		irq_set_handler_data(hwirq, vg);
 		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
-
-		/* Register interrupt handlers for gpio signaled acpi events */
-		acpi_gpiochip_request_interrupts(gc);
 	}
 
 	pm_runtime_enable(dev);
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
index d875bc3dba3c..af96a0d452f6 100644
--- a/include/linux/acpi_gpio.h
+++ b/include/linux/acpi_gpio.h
@@ -21,9 +21,6 @@ struct acpi_gpio_info {
 
 struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 					  struct acpi_gpio_info *info);
-void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
-void acpi_gpiochip_free_interrupts(struct gpio_chip *chip);
-
 #else /* CONFIG_GPIO_ACPI */
 
 static inline struct gpio_desc *
@@ -33,9 +30,6 @@ acpi_get_gpiod_by_index(struct device *dev, int index,
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline void acpi_gpiochip_request_interrupts(struct gpio_chip *chip) { }
-static inline void acpi_gpiochip_free_interrupts(struct gpio_chip *chip) { }
-
 #endif /* CONFIG_GPIO_ACPI */
 
 static inline int acpi_get_gpio_by_index(struct device *dev, int index,
-- 
1.8.4.3

