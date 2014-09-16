Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaIPLze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:55:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:36234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbaIPLxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="600313988"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH v2 15/16] misc: at25: Make use of device property API
Date: Tue, 16 Sep 2014 14:52:46 +0300
Message-Id: <1410868367-11056-16-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of device property API in this driver so that both DT and ACPI
based systems can use this driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/misc/eeprom/at25.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index 634f72929e12..58f6cdd2551c 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -18,7 +18,7 @@
 
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
-#include <linux/of.h>
+#include <linux/property.h>
 
 /*
  * NOTE: this is an *EEPROM* driver.  The vagaries of product naming
@@ -301,35 +301,33 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
 
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
@@ -350,7 +348,7 @@ static int at25_np_to_chip(struct device *dev,
 				val);
 			return -ENODEV;
 		}
-		if (of_find_property(np, "read-only", NULL))
+		if (!device_get_property(dev, "read-only", NULL))
 			chip->flags |= EE_READONLY;
 	}
 	return 0;
@@ -360,21 +358,15 @@ static int at25_probe(struct spi_device *spi)
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
 
-- 
2.1.0

