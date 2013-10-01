Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3JAO7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:59:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:38513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab3JAO7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="386261038"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/5] gpiolib / ACPI: allow passing GPIOF_ACTIVE_LOW for GpioInt resources
Date: Tue,  1 Oct 2013 17:58:56 +0300
Message-Id: <1380639537-23406-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI GpioInt resources contain polarity field that is used to specify
whether the interrupt is active high or low. Since gpiolib supports
GPIOF_ACTIVE_LOW we can pass this information in the flags field in
acpi_find_gpio(), analogous to the DeviceTree version.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c |  2 ++
 drivers/gpio/gpiolib.c      | 12 +++++++++++-
 include/linux/acpi_gpio.h   |  2 ++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 333297c..4c6df41 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -251,6 +251,8 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
 					      agpio->pin_table[0]);
 		lookup->info.gpioint =
 			agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
+		lookup->info.active_low =
+			agpio->polarity == ACPI_ACTIVE_LOW;
 	}
 
 	return 1;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 1e099de..b01a231 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2115,7 +2115,17 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *id,
 static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
 					unsigned int idx, unsigned long *flags)
 {
-	return acpi_get_gpiod_by_index(dev, idx, NULL);
+	struct acpi_gpio_info info;
+	struct gpio_desc *desc;
+
+	desc = acpi_get_gpiod_by_index(dev, idx, &info);
+	if (IS_ERR(desc))
+		return desc;
+
+	if (info.gpioint && info.active_low)
+		*flags |= GPIOF_ACTIVE_LOW;
+
+	return desc;
 }
 
 static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
index bbfa83a..af599ec 100644
--- a/include/linux/acpi_gpio.h
+++ b/include/linux/acpi_gpio.h
@@ -10,9 +10,11 @@
 /**
  * struct acpi_gpio_info - ACPI GPIO specific information
  * @gpioint: if %true this GPIO is of type GpioInt otherwise type is GpioIo
+ * @active_low: in case of @gpioint, the pin is active low
  */
 struct acpi_gpio_info {
 	bool gpioint;
+	bool active_low;
 };
 
 #ifdef CONFIG_GPIO_ACPI
-- 
1.8.4.rc3

