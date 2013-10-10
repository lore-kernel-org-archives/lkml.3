Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3JJIB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:01:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:13269 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab3JJIBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="306008321"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/5] gpiolib / ACPI: move acpi_gpiochip_free_interrupts next to the request function
Date: Thu, 10 Oct 2013 11:01:07 +0300
Message-Id: <1381392071-21407-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes more sense to have these functions close to each other. No
functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 76 ++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index f2beb72..1745ce5 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -194,6 +194,44 @@ void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 }
 EXPORT_SYMBOL(acpi_gpiochip_request_interrupts);
 
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
+
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
 	int index;
@@ -271,41 +309,3 @@ int acpi_get_gpio_by_index(struct device *dev, int index,
 	return lookup.gpio;
 }
 EXPORT_SYMBOL_GPL(acpi_get_gpio_by_index);
-
-/**
- * acpi_gpiochip_free_interrupts() - Free GPIO _EVT ACPI event interrupts.
- * @chip:      gpio chip
- *
- * Free interrupts associated with the _EVT method for the given GPIO chip.
- *
- * The remaining ACPI event interrupts associated with the chip are freed
- * automatically.
- */
-void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
-{
-	acpi_handle handle;
-	acpi_status status;
-	struct list_head *evt_pins;
-	struct acpi_gpio_evt_pin *evt_pin, *ep;
-
-	if (!chip->dev || !chip->to_irq)
-		return;
-
-	handle = ACPI_HANDLE(chip->dev);
-	if (!handle)
-		return;
-
-	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
-	if (ACPI_FAILURE(status))
-		return;
-
-	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
-		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
-		list_del(&evt_pin->node);
-		kfree(evt_pin);
-	}
-
-	acpi_detach_data(handle, acpi_gpio_evt_dh);
-	kfree(evt_pins);
-}
-EXPORT_SYMBOL(acpi_gpiochip_free_interrupts);
-- 
1.8.4.rc3

