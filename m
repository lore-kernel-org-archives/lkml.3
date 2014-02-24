Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaBXQBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:01:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:58402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbaBXQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="480863491"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5/6] gpio / ACPI: Rework ACPI GPIO event handling
Date: Mon, 24 Feb 2014 18:00:10 +0200
Message-Id: <1393257611-18031-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ACPI GPIO event handling code was never tested against real
hardware with functioning GPIO triggered events (at the time such hardware
wasn't available). Thus it misses certain things like requesting the GPIOs
properly, passing correct flags to the interrupt handler and so on.

This patch reworks ACPI GPIO event handling so that we:

 1) Use struct acpi_gpio_event for all GPIO signaled events.
 2) Switch to use GPIO descriptor API and request GPIOs by calling
    gpiochip_request_own_desc() that we added in a previous patch.
 3) Pass proper flags from ACPI GPIO resource to request_threaded_irq().

Also instead of open-coding the _AEI iteration loop we can use
acpi_walk_resources(). This simplifies the code a bit and fixes memory leak
that was caused by missing kfree() for buffer returned by
acpi_get_event_resources().

Since the remove path now calls gpiochip_free_own_desc() which takes GPIO
spinlock we need to call acpi_gpiochip_remove() outside of that lock
(analogous to acpi_gpiochip_add() path where the lock is released before
those funtions are called).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 221 ++++++++++++++++++++++++++------------------
 drivers/gpio/gpiolib.c      |   3 +-
 2 files changed, 132 insertions(+), 92 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index c60db4ddc166..275735f390af 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -21,7 +21,7 @@
 
 struct acpi_gpio_event {
 	struct list_head node;
-	acpi_handle *evt_handle;
+	acpi_handle evt_handle;
 	unsigned int pin;
 	unsigned int irq;
 };
@@ -70,9 +70,9 @@ static struct gpio_desc *acpi_get_gpiod(char *path, int pin)
 
 static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
 {
-	acpi_handle handle = data;
+	struct acpi_gpio_event *event = data;
 
-	acpi_evaluate_object(handle, NULL, NULL, NULL);
+	acpi_evaluate_object(event->evt_handle, NULL, NULL, NULL);
 
 	return IRQ_HANDLED;
 }
@@ -91,6 +91,120 @@ static void acpi_gpio_chip_dh(acpi_handle handle, void *data)
 	/* The address of this function is used as a key. */
 }
 
+static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
+						   void *context)
+{
+	struct acpi_gpio_chip *achip = context;
+	struct gpio_chip *chip = achip->chip;
+	struct acpi_resource_gpio *agpio;
+	acpi_handle handle, evt_handle;
+	struct acpi_gpio_event *event;
+	irq_handler_t handler = NULL;
+	struct gpio_desc *desc;
+	unsigned long irqflags;
+	int ret, pin, irq;
+
+	if (ares->type != ACPI_RESOURCE_TYPE_GPIO)
+		return AE_OK;
+
+	agpio = &ares->data.gpio;
+	if (agpio->connection_type != ACPI_RESOURCE_GPIO_TYPE_INT)
+		return AE_OK;
+
+	handle = ACPI_HANDLE(chip->dev);
+	pin = agpio->pin_table[0];
+
+	if (pin <= 255) {
+		char ev_name[5];
+		sprintf(ev_name, "_%c%02X",
+			agpio->triggering == ACPI_EDGE_SENSITIVE ? 'E' : 'L',
+			pin);
+		if (ACPI_SUCCESS(acpi_get_handle(handle, ev_name, &evt_handle)))
+			handler = acpi_gpio_irq_handler;
+	}
+	if (!handler) {
+		if (ACPI_SUCCESS(acpi_get_handle(handle, "_EVT", &evt_handle)))
+			handler = acpi_gpio_irq_handler_evt;
+	}
+	if (!handler)
+		return AE_BAD_PARAMETER;
+
+	desc = gpiochip_get_desc(chip, pin);
+	if (IS_ERR(desc)) {
+		dev_err(chip->dev, "Failed to get GPIO descriptor\n");
+		return AE_ERROR;
+	}
+
+	ret = gpiochip_request_own_desc(desc, "ACPI:Event");
+	if (ret) {
+		dev_err(chip->dev, "Failed to request GPIO\n");
+		return AE_ERROR;
+	}
+
+	gpiod_direction_input(desc);
+
+	ret = gpiod_lock_as_irq(desc);
+	if (ret) {
+		dev_err(chip->dev, "Failed to lock GPIO as interrupt\n");
+		goto fail_free_desc;
+	}
+
+	irq = gpiod_to_irq(desc);
+	if (irq < 0) {
+		dev_err(chip->dev, "Failed to translate GPIO to IRQ\n");
+		goto fail_unlock_irq;
+	}
+
+	irqflags = IRQF_ONESHOT;
+	if (agpio->triggering == ACPI_LEVEL_SENSITIVE) {
+		if (agpio->polarity == ACPI_ACTIVE_HIGH)
+			irqflags |= IRQF_TRIGGER_HIGH;
+		else
+			irqflags |= IRQF_TRIGGER_LOW;
+	} else {
+		switch (agpio->polarity) {
+		case ACPI_ACTIVE_HIGH:
+			irqflags |= IRQF_TRIGGER_RISING;
+			break;
+		case ACPI_ACTIVE_LOW:
+			irqflags |= IRQF_TRIGGER_FALLING;
+			break;
+		default:
+			irqflags |= IRQF_TRIGGER_RISING |
+				    IRQF_TRIGGER_FALLING;
+			break;
+		}
+	}
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		goto fail_unlock_irq;
+
+	event->evt_handle = evt_handle;
+	event->irq = irq;
+	event->pin = pin;
+
+	ret = request_threaded_irq(event->irq, NULL, handler, irqflags,
+				   "ACPI:Event", event);
+	if (ret) {
+		dev_err(chip->dev, "Failed to setup interrupt handler for %d\n",
+			event->irq);
+		goto fail_free_event;
+	}
+
+	list_add_tail(&event->node, &achip->events);
+	return AE_OK;
+
+fail_free_event:
+	kfree(event);
+fail_unlock_irq:
+	gpiod_unlock_as_irq(desc);
+fail_free_desc:
+	gpiochip_free_own_desc(desc);
+
+	return AE_ERROR;
+}
+
 /**
  * acpi_gpiochip_request_interrupts() - Register isr for gpio chip ACPI events
  * @achip:      ACPI GPIO chip
@@ -103,104 +217,22 @@ static void acpi_gpio_chip_dh(acpi_handle handle, void *data)
  */
 static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *achip)
 {
-	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
 	struct gpio_chip *chip = achip->chip;
-	struct acpi_resource *res;
-	acpi_handle handle;
-	acpi_status status;
-	unsigned int pin;
-	int irq, ret;
-	char ev_name[5];
 
 	if (!chip->dev || !chip->to_irq)
 		return;
 
-	handle = ACPI_HANDLE(chip->dev);
-	if (!handle)
-		return;
-
 	INIT_LIST_HEAD(&achip->events);
-
-	status = acpi_get_event_resources(handle, &buf);
-	if (ACPI_FAILURE(status))
-		return;
-
-	/*
-	 * If a GPIO interrupt has an ACPI event handler method, or _EVT is
-	 * present, set up an interrupt handler that calls the ACPI event
-	 * handler.
-	 */
-	for (res = buf.pointer;
-	     res && (res->type != ACPI_RESOURCE_TYPE_END_TAG);
-	     res = ACPI_NEXT_RESOURCE(res)) {
-		irq_handler_t handler = NULL;
-		void *data;
-
-		if (res->type != ACPI_RESOURCE_TYPE_GPIO ||
-		    res->data.gpio.connection_type !=
-		    ACPI_RESOURCE_GPIO_TYPE_INT)
-			continue;
-
-		pin = res->data.gpio.pin_table[0];
-		if (pin > chip->ngpio)
-			continue;
-
-		irq = chip->to_irq(chip, pin);
-		if (irq < 0)
-			continue;
-
-		if (pin <= 255) {
-			acpi_handle ev_handle;
-
-			sprintf(ev_name, "_%c%02X",
-				res->data.gpio.triggering ? 'E' : 'L', pin);
-			status = acpi_get_handle(handle, ev_name, &ev_handle);
-			if (ACPI_SUCCESS(status)) {
-				handler = acpi_gpio_irq_handler;
-				data = ev_handle;
-			}
-		}
-		if (!handler) {
-			struct acpi_gpio_event *event;
-			acpi_handle evt_handle;
-
-			status = acpi_get_handle(handle, "_EVT", &evt_handle);
-			if (ACPI_FAILURE(status))
-				continue;
-
-			event = kzalloc(sizeof(*event), GFP_KERNEL);
-			if (!event)
-				continue;
-
-			list_add_tail(&event->node, &achip->events);
-			event->evt_handle = evt_handle;
-			event->pin = pin;
-			event->irq = irq;
-			handler = acpi_gpio_irq_handler_evt;
-			data = event;
-		}
-		if (!handler)
-			continue;
-
-		/* Assume BIOS sets the triggering, so no flags */
-		ret = devm_request_threaded_irq(chip->dev, irq, NULL, handler,
-						0, "GPIO-signaled-ACPI-event",
-						data);
-		if (ret)
-			dev_err(chip->dev,
-				"Failed to request IRQ %d ACPI event handler\n",
-				irq);
-	}
+	acpi_walk_resources(ACPI_HANDLE(chip->dev), "_AEI",
+			    acpi_gpiochip_request_interrupt, achip);
 }
 
 /**
- * acpi_gpiochip_free_interrupts() - Free GPIO _EVT ACPI event interrupts.
+ * acpi_gpiochip_free_interrupts() - Free GPIO ACPI event interrupts.
  * @achip:      ACPI GPIO chip
  *
- * Free interrupts associated with the _EVT method for the given GPIO chip.
- *
- * The remaining ACPI event interrupts associated with the chip are freed
- * automatically.
+ * Free interrupts associated with GPIO ACPI event method for the given
+ * GPIO chip.
  */
 static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *achip)
 {
@@ -211,7 +243,14 @@ static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *achip)
 		return;
 
 	list_for_each_entry_safe_reverse(event, ep, &achip->events, node) {
-		devm_free_irq(chip->dev, event->irq, event);
+		struct gpio_desc *desc;
+
+		free_irq(event->irq, event);
+		desc = gpiochip_get_desc(chip, event->pin);
+		if (WARN_ON(IS_ERR(desc)))
+			continue;
+		gpiod_unlock_as_irq(desc);
+		gpiochip_free_own_desc(desc);
 		list_del(&event->node);
 		kfree(event);
 	}
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 489a63524eb6..474f7d1eb7d7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1266,11 +1266,12 @@ int gpiochip_remove(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
+	acpi_gpiochip_remove(chip);
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
-	acpi_gpiochip_remove(chip);
 
 	for (id = 0; id < chip->ngpio; id++) {
 		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
-- 
1.9.0.rc3

