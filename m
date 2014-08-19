Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaHSRGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:06:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6229 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaHSRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:06:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Aug 2014 09:56:44 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 2/2] gpio: change gpiochip_request_own_desc() prototype
Date: Tue, 19 Aug 2014 10:06:09 -0700
Message-ID: <1408467969-21226-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408467969-21226-1-git-send-email-acourbot@nvidia.com>
References: <1408467969-21226-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current prototype of gpiochip_request_own_desc() requires to obtain
a pointer to a descriptor. This is in contradiction to all other GPIO
request schemes, and imposes an extra step of obtaining a descriptor to
drivers. Most drivers actually cannot even perform that step since the
function that does it (gpichip_get_desc()) is gpiolib-private.

Change gpiochip_request_own_desc() to return a descriptor from a
(chip, hwnum) tuple and update users of this function (currently
gpiolib-acpi only).

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 Documentation/gpio/driver.txt |  3 ++-
 drivers/gpio/gpiolib-acpi.c   | 20 +++-----------------
 drivers/gpio/gpiolib.c        | 18 ++++++++++++++----
 include/linux/gpio/driver.h   |  3 ++-
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/Documentation/gpio/driver.txt b/Documentation/gpio/driver.txt
index 18790c237977..23b751a10d7b 100644
--- a/Documentation/gpio/driver.txt
+++ b/Documentation/gpio/driver.txt
@@ -178,7 +178,8 @@ does not help since it pins the module to the kernel forever (it calls
 try_module_get()). A GPIO driver can use the following functions instead
 to request and free descriptors without being pinned to the kernel forever.
 
-	int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label)
+	struct gpio_desc *gpiochip_request_own_desc(struct gpio_desc *desc,
+						    const char *label)
 
 	void gpiochip_free_own_desc(struct gpio_desc *desc)
 
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 84540025aa08..f9103e72e2a4 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -145,14 +145,8 @@ static acpi_status acpi_gpiochip_request_interrupt(struct acpi_resource *ares,
 	if (!handler)
 		return AE_BAD_PARAMETER;
 
-	desc = gpiochip_get_desc(chip, pin);
+	desc = gpiochip_request_own_desc(chip, pin, "ACPI:Event");
 	if (IS_ERR(desc)) {
-		dev_err(chip->dev, "Failed to get GPIO descriptor\n");
-		return AE_ERROR;
-	}
-
-	ret = gpiochip_request_own_desc(desc, "ACPI:Event");
-	if (ret) {
 		dev_err(chip->dev, "Failed to request GPIO\n");
 		return AE_ERROR;
 	}
@@ -420,22 +414,14 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
 			}
 		}
 		if (!found) {
-			int ret;
-
-			desc = gpiochip_get_desc(chip, pin);
+			desc = gpiochip_request_own_desc(chip, pin,
+							 "ACPI:OpRegion");
 			if (IS_ERR(desc)) {
 				status = AE_ERROR;
 				mutex_unlock(&achip->conn_lock);
 				goto out;
 			}
 
-			ret = gpiochip_request_own_desc(desc, "ACPI:OpRegion");
-			if (ret) {
-				status = AE_ERROR;
-				mutex_unlock(&achip->conn_lock);
-				goto out;
-			}
-
 			switch (agpio->io_restriction) {
 			case ACPI_IO_RESTRICT_INPUT:
 				gpiod_direction_input(desc);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 15cc0bb65dda..a5831d6a9b91 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -895,12 +895,22 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
  * allows the GPIO chip module to be unloaded as needed (we assume that the
  * GPIO chip driver handles freeing the GPIOs it has requested).
  */
-int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label)
+struct gpio_desc *gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum,
+					    const char *label)
 {
-	if (!desc || !desc->chip)
-		return -EINVAL;
+	struct gpio_desc *desc = gpiochip_get_desc(chip, hwnum);
+	int err;
+
+	if (IS_ERR(desc)) {
+		chip_err(chip, "failed to get GPIO descriptor\n");
+		return desc;
+	}
+
+	err = __gpiod_request(desc, label);
+	if (err < 0)
+		return ERR_PTR(err);
 
-	return __gpiod_request(desc, label);
+	return desc;
 }
 EXPORT_SYMBOL_GPL(gpiochip_request_own_desc);
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index e78a2373e374..a2de58fffd19 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -166,7 +166,8 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
 
 #endif /* CONFIG_GPIO_IRQCHIP */
 
-int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
+struct gpio_desc *gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum,
+					    const char *label);
 void gpiochip_free_own_desc(struct gpio_desc *desc);
 
 #else /* CONFIG_GPIOLIB */
-- 
2.0.4

