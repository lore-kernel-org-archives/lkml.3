Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaCJM4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:56:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:61169 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbaCJMzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,623,1389772800"; 
   d="scan'208";a="495438838"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 2/5] gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()
Date: Mon, 10 Mar 2014 14:54:51 +0200
Message-Id: <1394456094-21671-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to add more ACPI specific data to accompany GPIO chip so
instead of allocating it per each use-case we allocate it once when
acpi_gpiochip_add() is called and release it when acpi_gpiochip_remove() is
called.

Doing this allows us to add more ACPI specific data by merely adding new
fields to struct acpi_gpio_chip.

In addition we embed evt_pins member directly to the structure instead of
having it as a pointer. This simplifies the code a bit since we don't need
to check against NULL.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 106 ++++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 42 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index b7db098ba060..5c0cf1d76c8b 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -26,6 +26,11 @@ struct acpi_gpio_evt_pin {
 	unsigned int irq;
 };
 
+struct acpi_gpio_chip {
+	struct gpio_chip *chip;
+	struct list_head evt_pins;
+};
+
 static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
 {
 	if (!gc->dev)
@@ -81,14 +86,14 @@ static irqreturn_t acpi_gpio_irq_handler_evt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
+static void acpi_gpio_chip_dh(acpi_handle handle, void *data)
 {
 	/* The address of this function is used as a key. */
 }
 
 /**
  * acpi_gpiochip_request_interrupts() - Register isr for gpio chip ACPI events
- * @chip:      gpio chip
+ * @acpi_gpio:      ACPI GPIO chip
  *
  * ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
  * handled by ACPI event methods which need to be called from the GPIO
@@ -96,12 +101,12 @@ static void acpi_gpio_evt_dh(acpi_handle handle, void *data)
  * gpio pins have acpi event methods and assigns interrupt handlers that calls
  * the acpi event methods for those pins.
  */
-static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
+static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *acpi_gpio)
 {
 	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+	struct gpio_chip *chip = acpi_gpio->chip;
 	struct acpi_resource *res;
 	acpi_handle handle, evt_handle;
-	struct list_head *evt_pins = NULL;
 	acpi_status status;
 	unsigned int pin;
 	int irq, ret;
@@ -114,23 +119,7 @@ static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 	if (!handle)
 		return;
 
-	status = acpi_get_event_resources(handle, &buf);
-	if (ACPI_FAILURE(status))
-		return;
-
-	status = acpi_get_handle(handle, "_EVT", &evt_handle);
-	if (ACPI_SUCCESS(status)) {
-		evt_pins = kzalloc(sizeof(*evt_pins), GFP_KERNEL);
-		if (evt_pins) {
-			INIT_LIST_HEAD(evt_pins);
-			status = acpi_attach_data(handle, acpi_gpio_evt_dh,
-						  evt_pins);
-			if (ACPI_FAILURE(status)) {
-				kfree(evt_pins);
-				evt_pins = NULL;
-			}
-		}
-	}
+	INIT_LIST_HEAD(&acpi_gpio->evt_pins);
 
 	/*
 	 * If a GPIO interrupt has an ACPI event handler method, or _EVT is
@@ -167,14 +156,18 @@ static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 				data = ev_handle;
 			}
 		}
-		if (!handler && evt_pins) {
+		if (!handler) {
 			struct acpi_gpio_evt_pin *evt_pin;
 
+			status = acpi_get_handle(handle, "_EVT", &evt_handle);
+			if (ACPI_FAILURE(status))
+				continue
+
 			evt_pin = kzalloc(sizeof(*evt_pin), GFP_KERNEL);
 			if (!evt_pin)
 				continue;
 
-			list_add_tail(&evt_pin->node, evt_pins);
+			list_add_tail(&evt_pin->node, &acpi_gpio->evt_pins);
 			evt_pin->evt_handle = evt_handle;
 			evt_pin->pin = pin;
 			evt_pin->irq = irq;
@@ -197,39 +190,27 @@ static void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 
 /**
  * acpi_gpiochip_free_interrupts() - Free GPIO _EVT ACPI event interrupts.
- * @chip:      gpio chip
+ * @acpi_gpio:      ACPI GPIO chip
  *
  * Free interrupts associated with the _EVT method for the given GPIO chip.
  *
  * The remaining ACPI event interrupts associated with the chip are freed
  * automatically.
  */
-static void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
+static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *acpi_gpio)
 {
-	acpi_handle handle;
-	acpi_status status;
-	struct list_head *evt_pins;
 	struct acpi_gpio_evt_pin *evt_pin, *ep;
+	struct gpio_chip *chip = acpi_gpio->chip;
 
 	if (!chip->dev || !chip->to_irq)
 		return;
 
-	handle = ACPI_HANDLE(chip->dev);
-	if (!handle)
-		return;
-
-	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
-	if (ACPI_FAILURE(status))
-		return;
-
-	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
+	list_for_each_entry_safe_reverse(evt_pin, ep, &acpi_gpio->evt_pins,
+					 node) {
 		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
 		list_del(&evt_pin->node);
 		kfree(evt_pin);
 	}
-
-	acpi_detach_data(handle, acpi_gpio_evt_dh);
-	kfree(evt_pins);
 }
 
 struct acpi_gpio_lookup {
@@ -312,10 +293,51 @@ struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 
 void acpi_gpiochip_add(struct gpio_chip *chip)
 {
-	acpi_gpiochip_request_interrupts(chip);
+	struct acpi_gpio_chip *acpi_gpio;
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = ACPI_HANDLE(chip->dev);
+	if (!handle)
+		return;
+
+	acpi_gpio = kzalloc(sizeof(*acpi_gpio), GFP_KERNEL);
+	if (!acpi_gpio) {
+		dev_err(chip->dev,
+			"Failed to allocate memory for ACPI GPIO chip\n");
+		return;
+	}
+
+	acpi_gpio->chip = chip;
+
+	status = acpi_attach_data(handle, acpi_gpio_chip_dh, acpi_gpio);
+	if (ACPI_FAILURE(status)) {
+		dev_err(chip->dev, "Failed to attach ACPI GPIO chip\n");
+		kfree(acpi_gpio);
+		return;
+	}
+
+	acpi_gpiochip_request_interrupts(acpi_gpio);
 }
 
 void acpi_gpiochip_remove(struct gpio_chip *chip)
 {
-	acpi_gpiochip_free_interrupts(chip);
+	struct acpi_gpio_chip *acpi_gpio;
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = ACPI_HANDLE(chip->dev);
+	if (!handle)
+		return;
+
+	status = acpi_get_data(handle, acpi_gpio_chip_dh, (void **)&acpi_gpio);
+	if (ACPI_FAILURE(status)) {
+		dev_warn(chip->dev, "Failed to retrieve ACPI GPIO chip\n");
+		return;
+	}
+
+	acpi_gpiochip_free_interrupts(acpi_gpio);
+
+	acpi_detach_data(handle, acpi_gpio_chip_dh);
+	kfree(acpi_gpio);
 }
-- 
1.9.0

