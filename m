Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaE1MrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:47:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36026 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaE1MrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:47:13 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v5 7/9] of: spi: Export single device registration method and accessors
Date: Wed, 28 May 2014 15:46:31 +0300
Message-Id: <1401281193-27146-8-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically inserting spi device nodes requires the use of a single
device registration method. Rework and export it.

Methods to lookup a device/master using a device node are added
as well, of_find_spi_master_by_node() & of_find_spi_device_by_node().

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/spi/spi.c | 259 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 156 insertions(+), 103 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index d4f9670..a98d236 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1200,6 +1200,121 @@ err_init_queue:
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_OF)
+
+static struct spi_device *
+of_register_spi_device(struct spi_master *master, struct device_node *node)
+{
+	struct spi_device *spi;
+	struct device_node *nc;
+	int err;
+	u32 value;
+
+	/* Alloc an spi_device */
+	spi = spi_alloc_device(master);
+	if (!spi) {
+		dev_err(&master->dev, "spi_device alloc error for %s\n",
+			nc->full_name);
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* Select device driver */
+	err = of_modalias_node(nc, spi->modalias,
+				sizeof(spi->modalias));
+	if (err) {
+		dev_err(&master->dev, "cannot find modalias for %s\n",
+			nc->full_name);
+		goto err_out;
+	}
+
+	/* Device address */
+	err = of_property_read_u32(nc, "reg", &value);
+	if (err) {
+		dev_err(&master->dev, "%s has no valid 'reg' property (%d)\n",
+			nc->full_name, err);
+		goto err_out;
+	}
+	spi->chip_select = value;
+
+	/* Mode (clock phase/polarity/etc.) */
+	if (of_find_property(nc, "spi-cpha", NULL))
+		spi->mode |= SPI_CPHA;
+	if (of_find_property(nc, "spi-cpol", NULL))
+		spi->mode |= SPI_CPOL;
+	if (of_find_property(nc, "spi-cs-high", NULL))
+		spi->mode |= SPI_CS_HIGH;
+	if (of_find_property(nc, "spi-3wire", NULL))
+		spi->mode |= SPI_3WIRE;
+
+	/* Device DUAL/QUAD mode */
+	if (!of_property_read_u32(nc, "spi-tx-bus-width", &value)) {
+		switch (value) {
+		case 1:
+			break;
+		case 2:
+			spi->mode |= SPI_TX_DUAL;
+			break;
+		case 4:
+			spi->mode |= SPI_TX_QUAD;
+			break;
+		default:
+			dev_warn(&master->dev,
+				"spi-tx-bus-width %d not supported\n",
+				value);
+			break;
+		}
+	}
+
+	if (!of_property_read_u32(nc, "spi-rx-bus-width", &value)) {
+		switch (value) {
+		case 1:
+			break;
+		case 2:
+			spi->mode |= SPI_RX_DUAL;
+			break;
+		case 4:
+			spi->mode |= SPI_RX_QUAD;
+			break;
+		default:
+			dev_warn(&master->dev,
+				"spi-rx-bus-width %d not supported\n",
+				value);
+			break;
+		}
+	}
+
+	/* Device speed */
+	err = of_property_read_u32(nc, "spi-max-frequency", &value);
+	if (err) {
+		dev_err(&master->dev, "%s has no valid 'spi-max-frequency' property (%d)\n",
+			nc->full_name, err);
+		goto err_out;
+	}
+	spi->max_speed_hz = value;
+
+	/* IRQ */
+	spi->irq = irq_of_parse_and_map(nc, 0);
+
+	/* Store a pointer to the node in the device structure */
+	of_node_get(nc);
+	spi->dev.of_node = nc;
+
+	/* Register the new device */
+	request_module("%s%s", SPI_MODULE_PREFIX, spi->modalias);
+	err = spi_add_device(spi);
+	if (err) {
+		dev_err(&master->dev, "spi_device register error %s\n",
+			nc->full_name);
+		goto err_out;
+	}
+
+	return spi;
+
+err_out:
+	spi_dev_put(spi);
+	return ERR_PTR(err);
+}
+
 /**
  * of_register_spi_devices() - Register child devices onto the SPI bus
  * @master:	Pointer to spi_master device
@@ -1209,120 +1324,58 @@ err_init_queue:
  */
 static void of_register_spi_devices(struct spi_master *master)
 {
-	struct spi_device *spi;
 	struct device_node *nc;
-	int rc;
-	u32 value;
 
 	if (!master->dev.of_node)
 		return;
 
-	for_each_available_child_of_node(master->dev.of_node, nc) {
-		/* Alloc an spi_device */
-		spi = spi_alloc_device(master);
-		if (!spi) {
-			dev_err(&master->dev, "spi_device alloc error for %s\n",
-				nc->full_name);
-			spi_dev_put(spi);
-			continue;
-		}
+	for_each_available_child_of_node(master->dev.of_node, nc)
+		of_register_spi_device(master, nc);
+}
 
-		/* Select device driver */
-		if (of_modalias_node(nc, spi->modalias,
-				     sizeof(spi->modalias)) < 0) {
-			dev_err(&master->dev, "cannot find modalias for %s\n",
-				nc->full_name);
-			spi_dev_put(spi);
-			continue;
-		}
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
 
-		/* Device address */
-		rc = of_property_read_u32(nc, "reg", &value);
-		if (rc) {
-			dev_err(&master->dev, "%s has no valid 'reg' property (%d)\n",
-				nc->full_name, rc);
-			spi_dev_put(spi);
-			continue;
-		}
-		spi->chip_select = value;
-
-		/* Mode (clock phase/polarity/etc.) */
-		if (of_find_property(nc, "spi-cpha", NULL))
-			spi->mode |= SPI_CPHA;
-		if (of_find_property(nc, "spi-cpol", NULL))
-			spi->mode |= SPI_CPOL;
-		if (of_find_property(nc, "spi-cs-high", NULL))
-			spi->mode |= SPI_CS_HIGH;
-		if (of_find_property(nc, "spi-3wire", NULL))
-			spi->mode |= SPI_3WIRE;
-		if (of_find_property(nc, "spi-lsb-first", NULL))
-			spi->mode |= SPI_LSB_FIRST;
-
-		/* Device DUAL/QUAD mode */
-		if (!of_property_read_u32(nc, "spi-tx-bus-width", &value)) {
-			switch (value) {
-			case 1:
-				break;
-			case 2:
-				spi->mode |= SPI_TX_DUAL;
-				break;
-			case 4:
-				spi->mode |= SPI_TX_QUAD;
-				break;
-			default:
-				dev_warn(&master->dev,
-					 "spi-tx-bus-width %d not supported\n",
-					 value);
-				break;
-			}
-		}
+/* bah; the match functions differ just by const-ness */
+static int of_dev_node_match_const(struct device *dev, const void *data)
+{
+	return dev->of_node == data;
+}
 
-		if (!of_property_read_u32(nc, "spi-rx-bus-width", &value)) {
-			switch (value) {
-			case 1:
-				break;
-			case 2:
-				spi->mode |= SPI_RX_DUAL;
-				break;
-			case 4:
-				spi->mode |= SPI_RX_QUAD;
-				break;
-			default:
-				dev_warn(&master->dev,
-					 "spi-rx-bus-width %d not supported\n",
-					 value);
-				break;
-			}
-		}
+/* must call put_device() when done with returned spi_device device */
+struct spi_device *of_find_spi_device_by_node(struct device_node *node)
+{
+	struct device *dev;
 
-		/* Device speed */
-		rc = of_property_read_u32(nc, "spi-max-frequency", &value);
-		if (rc) {
-			dev_err(&master->dev, "%s has no valid 'spi-max-frequency' property (%d)\n",
-				nc->full_name, rc);
-			spi_dev_put(spi);
-			continue;
-		}
-		spi->max_speed_hz = value;
-
-		/* IRQ */
-		spi->irq = irq_of_parse_and_map(nc, 0);
-
-		/* Store a pointer to the node in the device structure */
-		of_node_get(nc);
-		spi->dev.of_node = nc;
-
-		/* Register the new device */
-		request_module("%s%s", SPI_MODULE_PREFIX, spi->modalias);
-		rc = spi_add_device(spi);
-		if (rc) {
-			dev_err(&master->dev, "spi_device register error %s\n",
-				nc->full_name);
-			spi_dev_put(spi);
-		}
+	dev = bus_find_device(&spi_bus_type, NULL, node,
+					 of_dev_node_match);
+	if (!dev)
+		return NULL;
 
-	}
+	return to_spi_device(dev);
 }
+EXPORT_SYMBOL(of_find_spi_device_by_node);
+
+/* forward decl */
+static struct class spi_master_class;
+
+/* the spi masters are not using spi_bus, so we find it with another way */
+struct spi_master *of_find_spi_master_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = class_find_device(&spi_master_class, NULL, node,
+				of_dev_node_match_const);
+	if (!dev)
+		return NULL;
+
+	/* reference got in class_find_device */
+	return container_of(dev, struct spi_master, dev);
+}
+EXPORT_SYMBOL(of_find_spi_master_by_node);
+
 #else
 static void of_register_spi_devices(struct spi_master *master) { }
 #endif
-- 
1.7.12

