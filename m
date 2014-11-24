Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaKXWfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:35:04 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56757 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaKXWeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:15 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, <linux-spi@vger.kernel.org>
Subject: [PATCH v2 13/14] spi/of: Create new device registration method and accessors
Date: Mon, 24 Nov 2014 22:33:41 +0000
Message-Id: <1416868422-22103-14-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Dynamically inserting spi device nodes requires the use of a single
device registration method. Refactor the existing
of_register_spi_devices() to split out the core functionality for a
single device into a separate function; of_register_spi_device(). This
function will be used by the OF_DYNAMIC overlay code to make live
modifications to the tree.

Methods to lookup a device/master using a device node are added
as well, of_find_spi_master_by_node() & of_find_spi_device_by_node().

Changes since v1:
* Brown paper bug with parameter on of_register_spi_device().

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
[grant.likely] Split patch into two pieces for clarity
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: <linux-spi@vger.kernel.org>
---
 drivers/spi/spi.c | 222 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 118 insertions(+), 104 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index ebcb33df2eb2..a3557c57d4f7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1220,6 +1220,121 @@ err_init_queue:
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_OF)
+static struct spi_device *
+of_register_spi_device(struct spi_master *master, struct device_node *nc)
+{
+	struct spi_device *spi;
+	int rc;
+	u32 value;
+
+	/* Alloc an spi_device */
+	spi = spi_alloc_device(master);
+	if (!spi) {
+		dev_err(&master->dev, "spi_device alloc error for %s\n",
+			nc->full_name);
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	/* Select device driver */
+	rc = of_modalias_node(nc, spi->modalias,
+				sizeof(spi->modalias));
+	if (rc < 0) {
+		dev_err(&master->dev, "cannot find modalias for %s\n",
+			nc->full_name);
+		goto err_out;
+	}
+
+	/* Device address */
+	rc = of_property_read_u32(nc, "reg", &value);
+	if (rc) {
+		dev_err(&master->dev, "%s has no valid 'reg' property (%d)\n",
+			nc->full_name, rc);
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
+	if (of_find_property(nc, "spi-lsb-first", NULL))
+		spi->mode |= SPI_LSB_FIRST;
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
+	rc = of_property_read_u32(nc, "spi-max-frequency", &value);
+	if (rc) {
+		dev_err(&master->dev, "%s has no valid 'spi-max-frequency' property (%d)\n",
+			nc->full_name, rc);
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
+	rc = spi_add_device(spi);
+	if (rc) {
+		dev_err(&master->dev, "spi_device register error %s\n",
+			nc->full_name);
+		goto err_out;
+	}
+
+	return spi;
+
+err_out:
+	spi_dev_put(spi);
+	return ERR_PTR(rc);
+}
+
 /**
  * of_register_spi_devices() - Register child devices onto the SPI bus
  * @master:	Pointer to spi_master device
@@ -1231,116 +1346,15 @@ static void of_register_spi_devices(struct spi_master *master)
 {
 	struct spi_device *spi;
 	struct device_node *nc;
-	int rc;
-	u32 value;
 
 	if (!master->dev.of_node)
 		return;
 
 	for_each_available_child_of_node(master->dev.of_node, nc) {
-		/* Alloc an spi_device */
-		spi = spi_alloc_device(master);
-		if (!spi) {
-			dev_err(&master->dev, "spi_device alloc error for %s\n",
+		spi = of_register_spi_device(master, nc);
+		if (IS_ERR(spi))
+			dev_warn(&master->dev, "Failed to create SPI device for %s\n",
 				nc->full_name);
-			spi_dev_put(spi);
-			continue;
-		}
-
-		/* Select device driver */
-		if (of_modalias_node(nc, spi->modalias,
-				     sizeof(spi->modalias)) < 0) {
-			dev_err(&master->dev, "cannot find modalias for %s\n",
-				nc->full_name);
-			spi_dev_put(spi);
-			continue;
-		}
-
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
-
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
-
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
-
 	}
 }
 #else
-- 
1.9.1

