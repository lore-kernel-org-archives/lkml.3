Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3KVMPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:15:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:59658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab3KVMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:14:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,751,1378882800"; 
   d="scan'208";a="439827944"
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
Subject: [PATCH v2 6/7] gpio / ACPI: get rid of acpi_gpio.h
Date: Fri, 22 Nov 2013 14:14:33 +0200
Message-Id: <1385122474-14926-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users of acpi_gpio.h have been moved to user either the GPIO
descriptor interface or to the internal gpiolib.h we can get rid of
acpi_gpio.h entirely.

Once this is done the only interface to get GPIOs to drivers enumerated
from ACPI namespace is the descriptor based interface.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c |  4 +++-
 drivers/gpio/gpiolib.c      |  1 -
 drivers/gpio/gpiolib.h      | 23 +++++++++++++++++++++++
 include/linux/acpi_gpio.h   | 45 ---------------------------------------------
 4 files changed, 26 insertions(+), 47 deletions(-)
 delete mode 100644 include/linux/acpi_gpio.h

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index cb2da66fbbfe..6c158d9a6efa 100644
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
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 70abccf0d144..a6b82413c290 100644
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
1.8.4.3

