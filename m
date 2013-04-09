Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab3DINuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:50:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54768 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760686Ab3DINtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:49:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, grant.likely@secretlab.ca,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio / ACPI: Handle ACPI events in accordance with the spec
Date: Tue, 09 Apr 2013 15:57:25 +0200
Message-ID: <3043137.BtEKcMiXSu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 0d1c28a (gpiolib-acpi: Add ACPI5 event model support to gpio.)
that added support for ACPI events signalled through GPIO interrupts
covered only GPIO pins whose numbers are less than or equal to 255.
However, there may be GPIO pins with numbers greater than 255 and
the ACPI spec (ACPI 5.0, Section 5.6.5.1) requires the _EVT method
to be used for handling events corresponding to those pins.

Moreover, according to the spec, _EVT is the default mechanism
for handling all ACPI events signalled through GPIO interrupts,
so if the _Exx/_Lxx method is not present for the given pin,
_EVT should be used instead.  If present, though, _Exx/_Lxx take
precedence over _EVT which shouldn't be executed in that case
(ACPI 5.0, Section 5.6.5.3).

Modify acpi_gpiochip_request_interrupts() to follow the spec as
described above and add acpi_gpiochip_free_interrupts() needed
to free interrupts associated with _EVT.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/gpio/gpiolib-acpi.c |  140 +++++++++++++++++++++++++++++++++++++-------
 include/linux/acpi_gpio.h   |    2 
 2 files changed, 122 insertions(+), 20 deletions(-)

Index: linux-pm/drivers/gpio/gpiolib-acpi.c
===================================================================
--- linux-pm.orig/drivers/gpio/gpiolib-acpi.c
+++ linux-pm/drivers/gpio/gpiolib-acpi.c
@@ -17,6 +17,13 @@
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
 
+struct acpi_gpio_evt_pin {
+	struct list_head node;
+	acpi_handle *evt_handle;
+	unsigned int pin;
+	unsigned int irq;
+};
+
 static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
 {
 	if (!gc->dev)
@@ -54,7 +61,6 @@ int acpi_get_gpio(char *path, int pin)
 }
 EXPORT_SYMBOL_GPL(acpi_get_gpio);
 
-
 static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
 {
 	acpi_handle handle = data;
@@ -64,6 +70,27 @@ static irqreturn_t acpi_gpio_irq_handler
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t acpi_gpio_irq_handler_evt(int irq, void *data)
+{
+	struct acpi_gpio_evt_pin *evt_pin = data;
+	struct acpi_object_list args;
+	union acpi_object arg;
+
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = evt_pin->pin;
+	args.count = 1;
+	args.pointer = &arg;
+
+	acpi_evaluate_object(evt_pin->evt_handle, NULL, &args, NULL);
+
+	return IRQ_HANDLED;
+}
+
+static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
+{
+	/* The address of this function is used as a key. */
+}
+
 /**
  * acpi_gpiochip_request_interrupts() - Register isr for gpio chip ACPI events
  * @chip:      gpio chip
@@ -73,15 +100,13 @@ static irqreturn_t acpi_gpio_irq_handler
  * chip's interrupt handler. acpi_gpiochip_request_interrupts finds out which
  * gpio pins have acpi event methods and assigns interrupt handlers that calls
  * the acpi event methods for those pins.
- *
- * Interrupts are automatically freed on driver detach
  */
-
 void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 {
 	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
 	struct acpi_resource *res;
-	acpi_handle handle, ev_handle;
+	acpi_handle handle, evt_handle;
+	struct list_head *evt_pins = NULL;
 	acpi_status status;
 	unsigned int pin;
 	int irq, ret;
@@ -98,13 +123,30 @@ void acpi_gpiochip_request_interrupts(st
 	if (ACPI_FAILURE(status))
 		return;
 
-	/* If a gpio interrupt has an acpi event handler method, then
-	 * set up an interrupt handler that calls the acpi event handler
-	 */
+	status = acpi_get_handle(handle, "_EVT", &evt_handle);
+	if (ACPI_SUCCESS(status)) {
+		evt_pins = kzalloc(sizeof(*evt_pins), GFP_KERNEL);
+		if (evt_pins) {
+			INIT_LIST_HEAD(evt_pins);
+			status = acpi_attach_data(handle, acpi_gpio_evt_dh,
+						  evt_pins);
+			if (ACPI_FAILURE(status)) {
+				kfree(evt_pins);
+				evt_pins = NULL;
+			}
+		}
+	}
 
+	/*
+	 * If a GPIO interrupt has an ACPI event handler method, or _EVT is
+	 * present, set up an interrupt handler that calls the ACPI event
+	 * handler.
+	 */
 	for (res = buf.pointer;
 	     res && (res->type != ACPI_RESOURCE_TYPE_END_TAG);
 	     res = ACPI_NEXT_RESOURCE(res)) {
+		irq_handler_t handler = NULL;
+		void *data;
 
 		if (res->type != ACPI_RESOURCE_TYPE_GPIO ||
 		    res->data.gpio.connection_type !=
@@ -115,23 +157,42 @@ void acpi_gpiochip_request_interrupts(st
 		if (pin > chip->ngpio)
 			continue;
 
-		sprintf(ev_name, "_%c%02X",
-		res->data.gpio.triggering ? 'E' : 'L', pin);
-
-		status = acpi_get_handle(handle, ev_name, &ev_handle);
-		if (ACPI_FAILURE(status))
-			continue;
-
 		irq = chip->to_irq(chip, pin);
 		if (irq < 0)
 			continue;
 
+		if (pin <= 255) {
+			acpi_handle ev_handle;
+
+			sprintf(ev_name, "_%c%02X",
+				res->data.gpio.triggering ? 'E' : 'L', pin);
+			status = acpi_get_handle(handle, ev_name, &ev_handle);
+			if (ACPI_SUCCESS(status)) {
+				handler = acpi_gpio_irq_handler;
+				data = ev_handle;
+			}
+		}
+		if (!handler && evt_pins) {
+			struct acpi_gpio_evt_pin *evt_pin;
+
+			evt_pin = kzalloc(sizeof(*evt_pin), GFP_KERNEL);
+			if (!evt_pin)
+				continue;
+
+			list_add_tail(&evt_pin->node, evt_pins);
+			evt_pin->evt_handle = evt_handle;
+			evt_pin->pin = pin;
+			evt_pin->irq = irq;
+			handler = acpi_gpio_irq_handler_evt;
+			data = evt_pin;
+		}
+		if (!handler)
+			continue;
+
 		/* Assume BIOS sets the triggering, so no flags */
-		ret = devm_request_threaded_irq(chip->dev, irq, NULL,
-					  acpi_gpio_irq_handler,
-					  0,
-					  "GPIO-signaled-ACPI-event",
-					  ev_handle);
+		ret = devm_request_threaded_irq(chip->dev, irq, NULL, handler,
+						0, "GPIO-signaled-ACPI-event",
+						data);
 		if (ret)
 			dev_err(chip->dev,
 				"Failed to request IRQ %d ACPI event handler\n",
@@ -139,3 +200,42 @@ void acpi_gpiochip_request_interrupts(st
 	}
 }
 EXPORT_SYMBOL(acpi_gpiochip_request_interrupts);
+
+
+/**
+ * acpi_gpiochip_free_interrupts() - Free GPIO _EVT ACPI event interrupts.
+ * @chip:      gpio chip
+ *
+ * Free interrupts associated with the _EVT method for the given GPIO chip.
+ *
+ * The remaining ACPI event interrupts associated with the chip are freed
+ * automatically.
+ */
+void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct list_head *evt_pins;
+	struct acpi_gpio_evt_pin *evt_pin, *ep;
+
+	if (!chip->dev || !chip->to_irq)
+		return;
+
+	handle = ACPI_HANDLE(chip->dev);
+	if (!handle)
+		return;
+
+	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
+	if (ACPI_FAILURE(status))
+		return;
+
+	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
+		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
+		list_del(&evt_pin->node);
+		kfree(evt_pin);
+	}
+
+	acpi_detach_data(handle, acpi_gpio_evt_dh);
+	kfree(evt_pins);
+}
+EXPORT_SYMBOL(acpi_gpiochip_free_interrupts);
Index: linux-pm/include/linux/acpi_gpio.h
===================================================================
--- linux-pm.orig/include/linux/acpi_gpio.h
+++ linux-pm/include/linux/acpi_gpio.h
@@ -8,6 +8,7 @@
 
 int acpi_get_gpio(char *path, int pin);
 void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
+void acpi_gpiochip_free_interrupts(struct gpio_chip *chip);
 
 #else /* CONFIG_GPIO_ACPI */
 
@@ -17,6 +18,7 @@ static inline int acpi_get_gpio(char *pa
 }
 
 static inline void acpi_gpiochip_request_interrupts(struct gpio_chip *chip) { }
+static inline void acpi_gpiochip_free_interrupts(struct gpio_chip *chip) { }
 
 #endif /* CONFIG_GPIO_ACPI */
 

