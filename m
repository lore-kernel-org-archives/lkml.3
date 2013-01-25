Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab3AYLoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:44:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:46126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3AYLoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:44:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208";a="252332623"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus <linus.walleij@linaro.org>
Cc: <grant.likely@secretlab.ca>, <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, <tianyu.lan@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC PATCH] gpiolib-acpi: Add ACPI5 event model support to gpio.
Date: Fri, 25 Jan 2013 13:48:25 +0200
Message-Id: <1359114505-4473-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ability to handle ACPI events signalled by GPIO interrupts.

ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
handled by ACPI event methods which need to be called from the GPIO
controller's interrupt handler. acpi_gpio_request_interrupt() finds out which
gpio pins have acpi event methods and assigns interrupt handlers that calls
the acpi event methods for those pins.

Partially based on work by Rui Zhang <rui.zhang@intel.com>

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c |   80 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi_gpio.h   |    4 ++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index cbad6e9..b6ab041 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -15,6 +15,7 @@
 #include <linux/export.h>
 #include <linux/acpi_gpio.h>
 #include <linux/acpi.h>
+#include <linux/interrupt.h>
 
 static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
 {
@@ -52,3 +53,82 @@ int acpi_get_gpio(char *path, int pin)
 	return chip->base + pin;
 }
 EXPORT_SYMBOL_GPL(acpi_get_gpio);
+
+
+static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
+{
+	acpi_handle handle = data;
+
+	acpi_evaluate_object(handle, NULL, NULL, NULL);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * acpi_gpio_request_interrupt() - Register isr for gpio controller ACPI events
+ * @chip:      gpio chip representation of the gpio controller
+ *
+ * ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
+ * handled by ACPI event methods which need to be called from the GPIO
+ * controller's interrupt handler. acpi_gpio_request_interrupt finds out which
+ * gpio pins have acpi event methods and assigns interrupt handlers that calls
+ * the acpi event methods for those pins.
+ */
+
+void acpi_gpio_request_interrupt(struct gpio_chip *chip)
+{
+	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+	struct acpi_resource *res;
+	acpi_handle handle, ev_handle;
+	acpi_status status;
+	unsigned int pin, irq;
+	char ev_name[5];
+
+	if (!chip->dev || !chip->to_irq)
+		return;
+
+	handle = ACPI_HANDLE(chip->dev);
+	if (!handle)
+		return;
+
+	status = acpi_get_event_resources(handle, &buf);
+	if (ACPI_FAILURE(status))
+		return;
+
+	/* If a gpio interrupt has an acpi event handler method, then
+	 * set up an interrupt handler that calls the acpi event handler
+	 */
+
+	for (res = buf.pointer;
+	     res && (res->type != ACPI_RESOURCE_TYPE_END_TAG);
+	     res = ACPI_NEXT_RESOURCE(res)) {
+
+		if (res->type != ACPI_RESOURCE_TYPE_GPIO ||
+		    res->data.gpio.connection_type !=
+		    ACPI_RESOURCE_GPIO_TYPE_INT)
+			continue;
+
+		pin = res->data.gpio.pin_table[0];
+		if (pin > chip->ngpio)
+			continue;
+
+		sprintf(ev_name, "_%c%02X",
+		res->data.gpio.triggering ? 'E' : 'L', pin);
+
+		status = acpi_get_handle(handle, ev_name, &ev_handle);
+		if (ACPI_FAILURE(status))
+			continue;
+
+		irq = chip->to_irq(chip, pin);
+		if (irq < 0)
+			continue;
+
+		/* Assume BIOS sets the triggering, so no flags */
+		devm_request_threaded_irq(chip->dev, irq, NULL,
+					  acpi_gpio_irq_handler,
+					  0,
+					  "GPIO-signaled-ACPI-event",
+					  ev_handle);
+	}
+}
+EXPORT_SYMBOL(acpi_gpio_request_interrupt);
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
index 91615a3..43c541d 100644
--- a/include/linux/acpi_gpio.h
+++ b/include/linux/acpi_gpio.h
@@ -2,10 +2,12 @@
 #define _LINUX_ACPI_GPIO_H_
 
 #include <linux/errno.h>
+#include <linux/gpio.h>
 
 #ifdef CONFIG_GPIO_ACPI
 
 int acpi_get_gpio(char *path, int pin);
+void acpi_gpio_request_interrupt(struct gpio_chip *chip);
 
 #else /* CONFIG_GPIO_ACPI */
 
@@ -14,6 +16,8 @@ static inline int acpi_get_gpio(char *path, int pin)
 	return -ENODEV;
 }
 
+static inline void acpi_gpio_request_interrupt(struct gpio_chip *chip) { }
+
 #endif /* CONFIG_GPIO_ACPI */
 
 #endif /* _LINUX_ACPI_GPIO_H_ */
-- 
1.7.4.1

