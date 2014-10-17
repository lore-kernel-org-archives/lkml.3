Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaJQMFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:05:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59130 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751664AbaJQMDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:03:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v5 04/12] misc: at25: Make use of device property API
Date: Fri, 17 Oct 2014 14:07:20 +0200
Message-ID: <2622882.aDapnxaRN0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <11223831.j9KAEfSQsY@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Make use of device property API in this driver so that both DT and ACPI
based systems can use this driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/misc/eeprom/at25.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

Index: linux-pm/drivers/misc/eeprom/at25.c
===================================================================
--- linux-pm.orig/drivers/misc/eeprom/at25.c
+++ linux-pm/drivers/misc/eeprom/at25.c
@@ -18,7 +18,7 @@
 
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
-#include <linux/of.h>
+#include <linux/property.h>
 
 /*
  * NOTE: this is an *EEPROM* driver.  The vagaries of product naming
@@ -301,35 +301,33 @@ static ssize_t at25_mem_write(struct mem
 
 /*-------------------------------------------------------------------------*/
 
-static int at25_np_to_chip(struct device *dev,
-			   struct device_node *np,
-			   struct spi_eeprom *chip)
+static int at25_fw_to_chip(struct device *dev, struct spi_eeprom *chip)
 {
 	u32 val;
 
 	memset(chip, 0, sizeof(*chip));
-	strncpy(chip->name, np->name, sizeof(chip->name));
+	strncpy(chip->name, "at25", sizeof(chip->name));
 
-	if (of_property_read_u32(np, "size", &val) == 0 ||
-	    of_property_read_u32(np, "at25,byte-len", &val) == 0) {
+	if (device_property_read_u32(dev, "size", &val) == 0 ||
+	    device_property_read_u32(dev, "at25,byte-len", &val) == 0) {
 		chip->byte_len = val;
 	} else {
 		dev_err(dev, "Error: missing \"size\" property\n");
 		return -ENODEV;
 	}
 
-	if (of_property_read_u32(np, "pagesize", &val) == 0 ||
-	    of_property_read_u32(np, "at25,page-size", &val) == 0) {
+	if (device_property_read_u32(dev, "pagesize", &val) == 0 ||
+	    device_property_read_u32(dev, "at25,page-size", &val) == 0) {
 		chip->page_size = (u16)val;
 	} else {
 		dev_err(dev, "Error: missing \"pagesize\" property\n");
 		return -ENODEV;
 	}
 
-	if (of_property_read_u32(np, "at25,addr-mode", &val) == 0) {
+	if (device_property_read_u32(dev, "at25,addr-mode", &val) == 0) {
 		chip->flags = (u16)val;
 	} else {
-		if (of_property_read_u32(np, "address-width", &val)) {
+		if (device_property_read_u32(dev, "address-width", &val)) {
 			dev_err(dev,
 				"Error: missing \"address-width\" property\n");
 			return -ENODEV;
@@ -350,7 +348,7 @@ static int at25_np_to_chip(struct device
 				val);
 			return -ENODEV;
 		}
-		if (of_find_property(np, "read-only", NULL))
+		if (device_property_present(dev, "read-only"))
 			chip->flags |= EE_READONLY;
 	}
 	return 0;
@@ -360,21 +358,15 @@ static int at25_probe(struct spi_device
 {
 	struct at25_data	*at25 = NULL;
 	struct spi_eeprom	chip;
-	struct device_node	*np = spi->dev.of_node;
 	int			err;
 	int			sr;
 	int			addrlen;
 
 	/* Chip description */
 	if (!spi->dev.platform_data) {
-		if (np) {
-			err = at25_np_to_chip(&spi->dev, np, &chip);
-			if (err)
-				return err;
-		} else {
-			dev_err(&spi->dev, "Error: no chip description\n");
-			return -ENODEV;
-		}
+		err = at25_fw_to_chip(&spi->dev, &chip);
+		if (err)
+			return err;
 	} else
 		chip = *(struct spi_eeprom *)spi->dev.platform_data;
 

