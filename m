Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaAINYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:24:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:34187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaAINX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:23:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,630,1384329600"; 
   d="scan'208";a="462586549"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-spi@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi: Check conflicting CS based on spi->chip_select instead of device name
Date: Thu,  9 Jan 2014 15:23:55 +0200
Message-Id: <1389273835-8615-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e13ac47bec20 (spi: Use stable dev_name for ACPI enumerated SPI
slaves) changed the SPI device naming to be based on ACPI device name
instead of carrying bus number and chip select for devices enumerated
from ACPI namespace.

In case of a buggy BIOS that lists multiple SPI devices sharing the same
chip select (even though they should use different) the current code fails
to detect that and allows the devices to be added to the bus.

Fix this by walking through the bus and comparing spi->chip_select instead
of device name. This should work regardless what the device name will be in
future.

Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 349ebba4b199..13dcc360bde6 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -370,6 +370,17 @@ static void spi_dev_set_name(struct spi_device *spi)
 		     spi->chip_select);
 }
 
+static int spi_dev_check(struct device *dev, void *data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct spi_device *new_spi = data;
+
+	if (spi->master == new_spi->master &&
+	    spi->chip_select == new_spi->chip_select)
+		return -EBUSY;
+	return 0;
+}
+
 /**
  * spi_add_device - Add spi_device allocated with spi_alloc_device
  * @spi: spi_device to register
@@ -384,7 +395,6 @@ int spi_add_device(struct spi_device *spi)
 	static DEFINE_MUTEX(spi_add_lock);
 	struct spi_master *master = spi->master;
 	struct device *dev = master->dev.parent;
-	struct device *d;
 	int status;
 
 	/* Chipselects are numbered 0..max; validate. */
@@ -404,12 +414,10 @@ int spi_add_device(struct spi_device *spi)
 	 */
 	mutex_lock(&spi_add_lock);
 
-	d = bus_find_device_by_name(&spi_bus_type, NULL, dev_name(&spi->dev));
-	if (d != NULL) {
+	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
+	if (status) {
 		dev_err(dev, "chipselect %d already in use\n",
 				spi->chip_select);
-		put_device(d);
-		status = -EBUSY;
 		goto done;
 	}
 
-- 
1.8.5.2

