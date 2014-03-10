Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaCJMzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:55:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:5795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbaCJMzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:55:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,623,1389772800"; 
   d="scan'208";a="489123992"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 3/5] gpio / ACPI: Rename acpi_gpio_evt_pin to acpi_gpio_event
Date: Mon, 10 Mar 2014 14:54:52 +0200
Message-Id: <1394456094-21671-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to consolidate _Exx, _Lxx and _EVT to use the same structure make
the structure name to reflect that we are dealing with any event, not just
_EVT.

This is just rename, no functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 5c0cf1d76c8b..be09e7526890 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -19,16 +19,16 @@
 
 #include "gpiolib.h"
 
-struct acpi_gpio_evt_pin {
+struct acpi_gpio_event {
 	struct list_head node;
-	acpi_handle *evt_handle;
+	acpi_handle handle;
 	unsigned int pin;
 	unsigned int irq;
 };
 
 struct acpi_gpio_chip {
 	struct gpio_chip *chip;
-	struct list_head evt_pins;
+	struct list_head events;
 };
 
 static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
@@ -79,9 +79,9 @@ static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
 
 static irqreturn_t acpi_gpio_irq_handler_evt(int irq, void *data)
 {
-	struct acpi_gpio_evt_pin *evt_pin = data;
+	struct acpi_gpio_event *event = data;
 
-	acpi_execute_simple_method(evt_pin->evt_handle, NULL, evt_pin->pin);
+	acpi_execute_simple_method(event->handle, NULL, event->pin);
 
 	return IRQ_HANDLED;
 }
@@ -119,7 +119,7 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *acpi_gpio)
 	if (!handle)
 		return;
 
-	INIT_LIST_HEAD(&acpi_gpio->evt_pins);
+	INIT_LIST_HEAD(&acpi_gpio->events);
 
 	/*
 	 * If a GPIO interrupt has an ACPI event handler method, or _EVT is
@@ -157,22 +157,22 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *acpi_gpio)
 			}
 		}
 		if (!handler) {
-			struct acpi_gpio_evt_pin *evt_pin;
+			struct acpi_gpio_event *event;
 
 			status = acpi_get_handle(handle, "_EVT", &evt_handle);
 			if (ACPI_FAILURE(status))
 				continue
 
-			evt_pin = kzalloc(sizeof(*evt_pin), GFP_KERNEL);
-			if (!evt_pin)
+			event = kzalloc(sizeof(*event), GFP_KERNEL);
+			if (!event)
 				continue;
 
-			list_add_tail(&evt_pin->node, &acpi_gpio->evt_pins);
-			evt_pin->evt_handle = evt_handle;
-			evt_pin->pin = pin;
-			evt_pin->irq = irq;
+			list_add_tail(&event->node, &acpi_gpio->events);
+			event->handle = evt_handle;
+			event->pin = pin;
+			event->irq = irq;
 			handler = acpi_gpio_irq_handler_evt;
-			data = evt_pin;
+			data = event;
 		}
 		if (!handler)
 			continue;
@@ -199,17 +199,16 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *acpi_gpio)
  */
 static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *acpi_gpio)
 {
-	struct acpi_gpio_evt_pin *evt_pin, *ep;
+	struct acpi_gpio_event *event, *ep;
 	struct gpio_chip *chip = acpi_gpio->chip;
 
 	if (!chip->dev || !chip->to_irq)
 		return;
 
-	list_for_each_entry_safe_reverse(evt_pin, ep, &acpi_gpio->evt_pins,
-					 node) {
-		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
-		list_del(&evt_pin->node);
-		kfree(evt_pin);
+	list_for_each_entry_safe_reverse(event, ep, &acpi_gpio->events, node) {
+		devm_free_irq(chip->dev, event->irq, event);
+		list_del(&event->node);
+		kfree(event);
 	}
 }
 
-- 
1.9.0

