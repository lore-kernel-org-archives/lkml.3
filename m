Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaAHKlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:41:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:53163 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbaAHKlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:41:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,623,1384329600"; 
   d="scan'208";a="461907342"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] gpio / ACPI: get rid of acpi_gpio.h
Date: Wed,  8 Jan 2014 12:40:56 +0200
Message-Id: <1389177657-29266-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389177657-29266-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1389177657-29266-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users of acpi_gpio.h have been moved to use either the GPIO
descriptor interface or to the internal gpiolib.h we can get rid of
acpi_gpio.h entirely.

Once this is done the only interface to get GPIOs to drivers enumerated
from ACPI namespace is the descriptor based interface.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-acpi.c |  5 +++--
 drivers/gpio/gpiolib.c      |  1 -
 drivers/gpio/gpiolib.h      | 23 +++++++++++++++++++++++
 include/linux/acpi_gpio.h   | 45 ---------------------------------------------
 4 files changed, 26 insertions(+), 48 deletions(-)
 delete mode 100644 include/linux/acpi_gpio.h

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 739b72b6731a..716ee9843110 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -12,11 +12,13 @@
 
 #include <linux/errno.h>
 #include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 #include <linux/export.h>
-#include <linux/acpi_gpio.h>
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
 
+#include "gpiolib.h"
+
 struct acpi_gpio_evt_pin {
 	struct list_head node;
 	acpi_handle *evt_handle;
@@ -307,7 +309,6 @@ struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 
 	return lookup.desc ? lookup.desc : ERR_PTR(-ENOENT);
 }
-EXPORT_SYMBOL_GPL(acpi_get_gpiod_by_index);
 
 void acpi_gpiochip_add(struct gpio_chip *chip)
 {
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0de4069e33ab..ea0eba572333 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -10,7 +10,6 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
-#include <linux/acpi_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 2ed23ab8298c..82be586c1f90 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -12,12 +12,35 @@
 #ifndef GPIOLIB_H
 #define GPIOLIB_H
 
+#include <linux/err.h>
+#include <linux/device.h>
+
+/**
+ * struct acpi_gpio_info - ACPI GPIO specific information
+ * @gpioint: if %true this GPIO is of type GpioInt otherwise type is GpioIo
+ * @active_low: in case of @gpioint, the pin is active low
+ */
+struct acpi_gpio_info {
+	bool gpioint;
+	bool active_low;
+};
+
 #ifdef CONFIG_ACPI
 void acpi_gpiochip_add(struct gpio_chip *chip);
 void acpi_gpiochip_remove(struct gpio_chip *chip);
+
+struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
+					  struct acpi_gpio_info *info);
 #else
 static inline void acpi_gpiochip_add(struct gpio_chip *chip) { }
 static inline void acpi_gpiochip_remove(struct gpio_chip *chip) { }
+
+static inline struct gpio_desc *
+acpi_get_gpiod_by_index(struct device *dev, int index,
+			struct acpi_gpio_info *info)
+{
+	return ERR_PTR(-ENOSYS);
+}
 #endif
 
 #endif /* GPIOLIB_H */
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
deleted file mode 100644
index af96a0d452f6..000000000000
--- a/include/linux/acpi_gpio.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef _LINUX_ACPI_GPIO_H_
-#define _LINUX_ACPI_GPIO_H_
-
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/gpio.h>
-#include <linux/gpio/consumer.h>
-
-/**
- * struct acpi_gpio_info - ACPI GPIO specific information
- * @gpioint: if %true this GPIO is of type GpioInt otherwise type is GpioIo
- * @active_low: in case of @gpioint, the pin is active low
- */
-struct acpi_gpio_info {
-	bool gpioint;
-	bool active_low;
-};
-
-#ifdef CONFIG_GPIO_ACPI
-
-struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
-					  struct acpi_gpio_info *info);
-#else /* CONFIG_GPIO_ACPI */
-
-static inline struct gpio_desc *
-acpi_get_gpiod_by_index(struct device *dev, int index,
-			struct acpi_gpio_info *info)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
-#endif /* CONFIG_GPIO_ACPI */
-
-static inline int acpi_get_gpio_by_index(struct device *dev, int index,
-					 struct acpi_gpio_info *info)
-{
-	struct gpio_desc *desc = acpi_get_gpiod_by_index(dev, index, info);
-
-	if (IS_ERR(desc))
-		return PTR_ERR(desc);
-	return desc_to_gpio(desc);
-}
-
-#endif /* _LINUX_ACPI_GPIO_H_ */
-- 
1.8.5.2

