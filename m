Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaHRQvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:51:12 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12377 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaHRQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:51:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Aug 2014 09:41:34 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/2] gpio: acpi: normalize use of gpiochip_get_desc()
Date: Mon, 18 Aug 2014 09:50:56 -0700
Message-ID: <1408380657-6718-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408380657-6718-1-git-send-email-acourbot@nvidia.com>
References: <1408380657-6718-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO descriptors are changing from unique and permanent tokens to
allocated resources. Therefore gpiochip_get_desc() cannot be used as a
way to obtain a global GPIO descriptor anymore.

This patch updates the gpiolib ACPI support code to keep and use the
descriptor returned by a centralized call to gpiochip_get_desc().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-acpi.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index d62eaaa75397..9596a1023579 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -25,10 +25,12 @@ struct acpi_gpio_event {
 	acpi_handle handle;
 	unsigned int pin;
 	unsigned int irq;
+	gpio_desc *desc;
 };
 
 struct acpi_gpio_connection {
 	struct list_head node;
+	unsigned int pin;
 	struct gpio_desc *desc;
 };
 
@@ -197,6 +199,7 @@ static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
 	event->handle = evt_handle;
 	event->irq = irq;
 	event->pin = pin;
+	event->desc = desc;
 
 	ret = request_threaded_irq(event->irq, NULL, handler, irqflags,
 				   "ACPI:Event", event);
@@ -280,7 +283,7 @@ void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 		struct gpio_desc *desc;
 
 		free_irq(event->irq, event);
-		desc = gpiochip_get_desc(chip, event->pin);
+		desc = event->desc;
 		if (WARN_ON(IS_ERR(desc)))
 			continue;
 		gpio_unlock_as_irq(chip, event->pin);
@@ -406,24 +409,26 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
 		struct gpio_desc *desc;
 		bool found;
 
-		desc = gpiochip_get_desc(chip, pin);
-		if (IS_ERR(desc)) {
-			status = AE_ERROR;
-			goto out;
-		}
-
 		mutex_lock(&achip->conn_lock);
 
 		found = false;
 		list_for_each_entry(conn, &achip->conns, node) {
-			if (conn->desc == desc) {
+			if (conn->pin == pin) {
 				found = true;
+				desc = conn->desc;
 				break;
 			}
 		}
 		if (!found) {
 			int ret;
 
+			desc = gpiochip_get_desc(chip, pin);
+			if (IS_ERR(desc)) {
+				status = AE_ERROR;
+				mutex_unlock(&achip->conn_lock);
+				goto out;
+			}
+
 			ret = gpiochip_request_own_desc(desc, "ACPI:OpRegion");
 			if (ret) {
 				status = AE_ERROR;
@@ -462,6 +467,7 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
 				goto out;
 			}
 
+			conn->pin = pin;
 			conn->desc = desc;
 			list_add_tail(&conn->node, &achip->conns);
 		}
-- 
2.0.4

