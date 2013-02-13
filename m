Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3BMNUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:20:43 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:45962 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756892Ab3BMNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:20:42 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH] spi: Initialize cs_gpio and cs_gpios with -ENOENT
Date: Wed, 13 Feb 2013 14:20:25 +0100
Message-Id: <1360761625-15562-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value from of_get_named_gpio is -ENOENT when the given index
matches a hole in the "cs-gpios" property phandle list. However, the
default value of cs_gpio in struct spi_device and entries of cs_gpios in
struct spi_master is -EINVAL, which is documented to indicate that a
GPIO line should not be used for the given spi_device.

This sets the default value of cs_gpio in struct spi_device and entries
of cs_gpios in struct spi_master to -ENOENT. Thus, -ENOENT is the only
value used to indicate that no GPIO line should be used.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

To be applied to spi/next

 drivers/spi/spi.c       |    4 ++--
 include/linux/spi/spi.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4bca50c..b730a50 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -334,7 +334,7 @@ struct spi_device *spi_alloc_device(struct spi_master *master)
 	spi->dev.parent = &master->dev;
 	spi->dev.bus = &spi_bus_type;
 	spi->dev.release = spidev_release;
-	spi->cs_gpio = -EINVAL;
+	spi->cs_gpio = -ENOENT;
 	device_initialize(&spi->dev);
 	return spi;
 }
@@ -1083,7 +1083,7 @@ static int of_spi_register_master(struct spi_master *master)
 		return -ENOMEM;
 
 	for (i = 0; i < master->num_chipselect; i++)
-		cs[i] = -EINVAL;
+		cs[i] = -ENOENT;
 
 	for (i = 0; i < nb; i++)
 		cs[i] = of_get_named_gpio(np, "cs-gpios", i);
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 30e9c50..b0ae8b8 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -57,7 +57,7 @@ extern struct bus_type spi_bus_type;
  * @modalias: Name of the driver to use with this device, or an alias
  *	for that name.  This appears in the sysfs "modalias" attribute
  *	for driver coldplugging, and in uevents used for hotplugging
- * @cs_gpio: gpio number of the chipselect line (optional, -EINVAL when
+ * @cs_gpio: gpio number of the chipselect line (optional, -ENOENT when
  *	when not using a GPIO line)
  *
  * A @spi_device is used to interchange data between an SPI slave
@@ -261,7 +261,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  *	queue so the subsystem notifies the driver that it may relax the
  *	hardware by issuing this call
  * @cs_gpios: Array of GPIOs to use as chip select lines; one per CS
- *	number. Any individual value may be -EINVAL for CS lines that
+ *	number. Any individual value may be -ENOENT for CS lines that
  *	are not GPIOs (driven by the SPI controller itself).
  *
  * Each SPI master controller can communicate with one or more @spi_device
-- 
1.7.0.4

