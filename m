Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaBXQAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:00:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:48286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaBXQAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:00:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="461217899"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6/6] gpio / ACPI: Add support for ACPI GPIO operation regions
Date: Mon, 24 Feb 2014 18:00:11 +0200
Message-Id: <1393257611-18031-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO operation regions is a new feature introduced in ACPI 5.0
specification. This feature adds a way for platform ASL code to call back
to OS GPIO driver and toggle GPIO pins.

An example ASL code from Lenovo Miix 2 tablet with only relevant part
listed:

 Device (\_SB.GPO0)
 {
     Name (AVBL, Zero)
     Method (_REG, 2, NotSerialized)
     {
         If (LEqual (Arg0, 0x08))
         {
             // Marks the region available
             Store (Arg1, AVBL)
         }
     }

     OperationRegion (GPOP, GeneralPurposeIo, Zero, 0x0C)
     Field (GPOP, ByteAcc, NoLock, Preserve)
     {
         Connection (
             GpioIo (Exclusive, PullDefault, 0, 0, IoRestrictionOutputOnly,
                     "\\_SB.GPO0", 0x00, ResourceConsumer,,)
             {
                 0x003B
             }
         ),
         SHD3,   1,
     }
 }

 Device (SHUB)
 {
     Method (_PS0, 0, Serialized)
     {
         If (LEqual (\_SB.GPO0.AVBL, One))
         {
             Store (One, \_SB.GPO0.SHD3)
             Sleep (0x32)
         }
     }
     Method (_PS3, 0, Serialized)
     {
         If (LEqual (\_SB.GPO0.AVBL, One))
         {
             Store (Zero, \_SB.GPO0.SHD3)
         }
     }
 }

The sensor hub (SHUB) device uses GPIO connection SHD3 to power the device
whenever the GPIO operation region is available.

Implement the support by registering GPIO operation region handlers for all
GPIO devices that have an ACPI handle. First time the GPIO is used by the
ASL code we make sure that the GPIO stays requested until the GPIO chip
driver itself is unloaded. If we find out that the GPIO is already
requested we just toggle it according to the value got from ASL code.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 156 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 275735f390af..0133d38c447f 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/acpi.h>
 #include <linux/interrupt.h>
+#include <linux/mutex.h>
 
 #include "gpiolib.h"
 
@@ -26,7 +27,20 @@ struct acpi_gpio_event {
 	unsigned int irq;
 };
 
+struct acpi_gpio_connection {
+	struct list_head node;
+	struct gpio_desc *desc;
+};
+
 struct acpi_gpio_chip {
+	/*
+	 * ACPICA requires that the first field of the context parameter
+	 * passed to acpi_install_address_space_handler() is large enough
+	 * to hold struct acpi_connection_info.
+	 */
+	struct acpi_connection_info conn_info;
+	struct list_head conns;
+	struct mutex conn_lock;
 	struct gpio_chip *chip;
 	struct list_head events;
 };
@@ -334,6 +348,146 @@ struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 	return lookup.desc ? lookup.desc : ERR_PTR(-ENOENT);
 }
 
+static acpi_status
+acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
+			    u32 bits, u64 *value, void *handler_context,
+			    void *region_context)
+{
+	struct acpi_gpio_chip *achip = region_context;
+	struct gpio_chip *chip = achip->chip;
+	struct acpi_resource_gpio *agpio;
+	struct acpi_resource *ares;
+	acpi_status status;
+	bool pull;
+	int i;
+
+	status = acpi_buffer_to_resource(achip->conn_info.connection,
+					 achip->conn_info.length, &ares);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (WARN_ON(ares->type != ACPI_RESOURCE_TYPE_GPIO)) {
+		ACPI_FREE(ares);
+		return AE_BAD_PARAMETER;
+	}
+
+	agpio = &ares->data.gpio;
+	pull = agpio->pin_config == ACPI_PIN_CONFIG_PULLUP;
+
+	if (WARN_ON(agpio->io_restriction == ACPI_IO_RESTRICT_INPUT &&
+	    function == ACPI_WRITE)) {
+		ACPI_FREE(ares);
+		return AE_BAD_PARAMETER;
+	}
+
+	for (i = 0; i < agpio->pin_table_length; i++) {
+		unsigned pin = agpio->pin_table[i];
+		struct acpi_gpio_connection *conn;
+		struct gpio_desc *desc;
+		bool found;
+
+		desc = gpiochip_get_desc(chip, pin);
+		if (IS_ERR(desc)) {
+			status = AE_ERROR;
+			goto out;
+		}
+
+		mutex_lock(&achip->conn_lock);
+
+		found = false;
+		list_for_each_entry(conn, &achip->conns, node) {
+			if (conn->desc == desc) {
+				found = true;
+				break;
+			}
+		}
+		if (!found) {
+			int ret;
+
+			ret = gpiochip_request_own_desc(desc, "ACPI:OpRegion");
+			if (ret) {
+				status = AE_ERROR;
+				mutex_unlock(&achip->conn_lock);
+				goto out;
+			}
+
+			switch (agpio->io_restriction) {
+			case ACPI_IO_RESTRICT_INPUT:
+				gpiod_direction_input(desc);
+				break;
+			case ACPI_IO_RESTRICT_OUTPUT:
+				gpiod_direction_output(desc, pull);
+				break;
+			default:
+				/*
+				 * Assume that the BIOS has configured the
+				 * direction and pull accordingly.
+				 */
+				break;
+			}
+
+			conn = kzalloc(sizeof(*conn), GFP_KERNEL);
+			if (!conn) {
+				status = AE_NO_MEMORY;
+				mutex_unlock(&achip->conn_lock);
+				goto out;
+			}
+
+			conn->desc = desc;
+
+			list_add_tail(&conn->node, &achip->conns);
+		}
+
+		mutex_unlock(&achip->conn_lock);
+
+
+		if (function == ACPI_WRITE)
+			gpiod_set_raw_value(desc, !!((1 << i) & *value));
+		else
+			*value |= gpiod_get_raw_value(desc) << i;
+	}
+
+out:
+	ACPI_FREE(ares);
+	return status;
+}
+
+static void acpi_gpiochip_request_regions(struct acpi_gpio_chip *achip)
+{
+	struct gpio_chip *chip = achip->chip;
+	acpi_handle handle = ACPI_HANDLE(chip->dev);
+	acpi_status status;
+
+	INIT_LIST_HEAD(&achip->conns);
+	mutex_init(&achip->conn_lock);
+	status = acpi_install_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
+						    acpi_gpio_adr_space_handler,
+						    NULL, achip);
+	if (ACPI_FAILURE(status))
+		dev_err(chip->dev, "Failed to install GPIO OpRegion handler\n");
+}
+
+static void acpi_gpiochip_free_regions(struct acpi_gpio_chip *achip)
+{
+	struct gpio_chip *chip = achip->chip;
+	acpi_handle handle = ACPI_HANDLE(chip->dev);
+	struct acpi_gpio_connection *conn, *tmp;
+	acpi_status status;
+
+	status = acpi_remove_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
+						   acpi_gpio_adr_space_handler);
+	if (ACPI_FAILURE(status)) {
+		dev_err(chip->dev, "Failed to remove GPIO OpRegion handler\n");
+		return;
+	}
+
+	list_for_each_entry_safe_reverse(conn, tmp, &achip->conns, node) {
+		gpiochip_free_own_desc(conn->desc);
+		list_del(&conn->node);
+		kfree(conn);
+	}
+}
+
 void acpi_gpiochip_add(struct gpio_chip *chip)
 {
 	struct acpi_gpio_chip *achip;
@@ -361,6 +515,7 @@ void acpi_gpiochip_add(struct gpio_chip *chip)
 	}
 
 	acpi_gpiochip_request_interrupts(achip);
+	acpi_gpiochip_request_regions(achip);
 }
 
 void acpi_gpiochip_remove(struct gpio_chip *chip)
@@ -379,6 +534,7 @@ void acpi_gpiochip_remove(struct gpio_chip *chip)
 		return;
 	}
 
+	acpi_gpiochip_free_regions(achip);
 	acpi_gpiochip_free_interrupts(achip);
 
 	acpi_detach_data(handle, acpi_gpio_chip_dh);
-- 
1.9.0.rc3

