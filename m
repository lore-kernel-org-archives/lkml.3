Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbaGYGyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:54:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:29274 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGYGyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:54:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="461221464"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhu Lejun <lejun.zhu@linux.intel.com>, Yang Bin <bin.yang@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] gpio / ACPI: Move event handling registration to gpiolib irqchip helpers
Date: Fri, 25 Jul 2014 09:54:48 +0300
Message-Id: <1406271288-15995-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have irqchip helpers that the GPIO chip drivers are supposed
to use if possible, we can move the registration of ACPI events to happen
in these helpers. This seems to be more natural place and might encourage
GPIO chip driver writers to take advantage of the irqchip helpers.

We make the functions available to GPIO chip drivers via private gpiolib.h,
just in case generic irqchip helpers are not suitable.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 38 ++++++++++++++++++++++++++++----------
 drivers/gpio/gpiolib.c      |  4 ++++
 drivers/gpio/gpiolib.h      |  9 +++++++++
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 4a987917c186..f3edaeaf3b64 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -221,7 +221,7 @@ fail_free_desc:
 
 /**
  * acpi_gpiochip_request_interrupts() - Register isr for gpio chip ACPI events
- * @acpi_gpio:      ACPI GPIO chip
+ * @chip:      GPIO chip
  *
  * ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
  * handled by ACPI event methods which need to be called from the GPIO
@@ -229,11 +229,21 @@ fail_free_desc:
  * gpio pins have acpi event methods and assigns interrupt handlers that calls
  * the acpi event methods for those pins.
  */
-static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *acpi_gpio)
+void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 {
-	struct gpio_chip *chip = acpi_gpio->chip;
+	struct acpi_gpio_chip *acpi_gpio;
+	acpi_handle handle;
+	acpi_status status;
+
+	if (!chip->dev || !chip->to_irq)
+		return;
 
-	if (!chip->to_irq)
+	handle = ACPI_HANDLE(chip->dev);
+	if (!handle)
+		return;
+
+	status = acpi_get_data(handle, acpi_gpio_chip_dh, (void **)&acpi_gpio);
+	if (ACPI_FAILURE(status))
 		return;
 
 	INIT_LIST_HEAD(&acpi_gpio->events);
@@ -243,17 +253,27 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *acpi_gpio)
 
 /**
  * acpi_gpiochip_free_interrupts() - Free GPIO ACPI event interrupts.
- * @acpi_gpio:      ACPI GPIO chip
+ * @chip:      GPIO chip
  *
  * Free interrupts associated with GPIO ACPI event method for the given
  * GPIO chip.
  */
-static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *acpi_gpio)
+void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 {
+	struct acpi_gpio_chip *acpi_gpio;
 	struct acpi_gpio_event *event, *ep;
-	struct gpio_chip *chip = acpi_gpio->chip;
+	acpi_handle handle;
+	acpi_status status;
+
+	if (!chip->dev || !chip->to_irq)
+		return;
 
-	if (!chip->to_irq)
+	handle = ACPI_HANDLE(chip->dev);
+	if (!handle)
+		return;
+
+	status = acpi_get_data(handle, acpi_gpio_chip_dh, (void **)&acpi_gpio);
+	if (ACPI_FAILURE(status))
 		return;
 
 	list_for_each_entry_safe_reverse(event, ep, &acpi_gpio->events, node) {
@@ -525,7 +545,6 @@ void acpi_gpiochip_add(struct gpio_chip *chip)
 		return;
 	}
 
-	acpi_gpiochip_request_interrupts(acpi_gpio);
 	acpi_gpiochip_request_regions(acpi_gpio);
 }
 
@@ -549,7 +568,6 @@ void acpi_gpiochip_remove(struct gpio_chip *chip)
 	}
 
 	acpi_gpiochip_free_regions(acpi_gpio);
-	acpi_gpiochip_free_interrupts(acpi_gpio);
 
 	acpi_detach_data(handle, acpi_gpio_chip_dh);
 	kfree(acpi_gpio);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2ebc9071e354..5a543969ad40 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1474,6 +1474,8 @@ static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip)
 {
 	unsigned int offset;
 
+	acpi_gpiochip_free_interrupts(gpiochip);
+
 	/* Remove all IRQ mappings and delete the domain */
 	if (gpiochip->irqdomain) {
 		for (offset = 0; offset < gpiochip->ngpio; offset++)
@@ -1567,6 +1569,8 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
 			gpiochip->irq_base = irq_base;
 	}
 
+	acpi_gpiochip_request_interrupts(gpiochip);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gpiochip_irqchip_add);
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 1a4103dd38df..6c45cef6620c 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -31,12 +31,21 @@ struct acpi_gpio_info {
 void acpi_gpiochip_add(struct gpio_chip *chip);
 void acpi_gpiochip_remove(struct gpio_chip *chip);
 
+void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
+void acpi_gpiochip_free_interrupts(struct gpio_chip *chip);
+
 struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 					  struct acpi_gpio_info *info);
 #else
 static inline void acpi_gpiochip_add(struct gpio_chip *chip) { }
 static inline void acpi_gpiochip_remove(struct gpio_chip *chip) { }
 
+static inline void
+acpi_gpiochip_request_interrupts(struct gpio_chip *chip) { }
+
+static inline void
+acpi_gpiochip_free_interrupts(struct gpio_chip *chip) { }
+
 static inline struct gpio_desc *
 acpi_get_gpiod_by_index(struct device *dev, int index,
 			struct acpi_gpio_info *info)
-- 
2.0.1

