Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaCRV4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:56:45 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45629 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162AbaCRV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:56:38 -0400
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
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v3 6/7] OF: spi: Add overlay bus handler
Date: Tue, 18 Mar 2014 23:56:05 +0200
Message-Id: <1395179766-31575-7-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the bus handler registration needed for performing overlays
containing spi devices.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/spi/spi.c | 345 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 242 insertions(+), 103 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index d0b28bb..2d7037b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -993,6 +993,123 @@ err_init_queue:
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
+			dev_err(&master->dev,
+				"spi-tx-bus-width %d not supported\n",
+				value);
+			err = -EINVAL;
+			goto err_out;
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
+			dev_err(&master->dev,
+				"spi-rx-bus-width %d not supported\n",
+				value);
+			err = -EINVAL;
+			goto err_out;
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
@@ -1002,124 +1119,140 @@ err_init_queue:
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
-				dev_err(&master->dev,
-					"spi-tx-bus-width %d not supported\n",
-					value);
-				spi_dev_put(spi);
-				continue;
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
-				dev_err(&master->dev,
-					"spi-rx-bus-width %d not supported\n",
-					value);
-				spi_dev_put(spi);
-				continue;
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
+
+	return to_spi_device(dev);
+}
+EXPORT_SYMBOL(of_find_spi_device_by_node);
 
+/* forward decl */
+static struct class spi_master_class;
+
+/* the spi masters are not using spi_bus, so we have to find it some other way */
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
+#ifdef CONFIG_OF_OVERLAY
+static int spi_handler_create(struct of_overlay_device_entry *de,
+		int revert)
+{
+	struct device_node *dn;
+	struct spi_master *master;
+	struct spi_device *spi;
+
+	if (!de || !de->np)
+		return -ENOTSUPP;
+
+	dn = de->np;
+
+	master = of_find_spi_master_by_node(dn->parent);
+	if (master == NULL)
+		return -ENOTSUPP;
+
+	spi = of_register_spi_device(master, dn);
+	put_device(&master->dev);
+
+	if (spi == NULL) {
+		pr_err("%s: failed to create spi device "
+				"for '%s'\n",
+				__func__, dn->full_name);
+		/* of_register_spi_device tosses the real error code */
+		return -EINVAL;
 	}
+
+	return 0;
 }
+
+static int spi_handler_remove(struct of_overlay_device_entry *de,
+		int revert)
+{
+	struct device_node *dn;
+	struct spi_device *spi;
+
+	if (!de || !de->np)
+		return -ENOTSUPP;
+
+	dn = de->np;
+
+	spi = of_find_spi_device_by_node(dn);
+	if (spi == NULL)
+		return -ENOTSUPP;
+
+	/* unregister takes one ref away */
+	spi_unregister_device(spi);
+
+	/* and put the reference of the find */
+	put_device(&spi->dev);
+
+	return 0;
+}
+
+static const struct of_overlay_handler_ops spi_handler_ops = {
+	.create	= spi_handler_create,
+	.remove = spi_handler_remove,
+};
+
+static struct of_overlay_handler spi_handler = {
+	.name = "spi",
+	.ops = &spi_handler_ops,
+};
+
+static int __init spi_bus_handler_register(void)
+{
+	return of_overlay_handler_register(&spi_handler);
+}
+#endif
+
 #else
 static void of_register_spi_devices(struct spi_master *master) { }
 #endif
 
+#if !defined(CONFIG_OF) || !defined(CONFIG_OF_OVERLAY)
+static inline int spi_bus_handler_register(void)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_ACPI
 static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 {
@@ -2067,8 +2200,14 @@ static int __init spi_init(void)
 	status = class_register(&spi_master_class);
 	if (status < 0)
 		goto err2;
-	return 0;
 
+	status = spi_bus_handler_register();
+	if (status < 0)
+		goto err3;
+
+	return 0;
+err3:
+	class_unregister(&spi_master_class);
 err2:
 	bus_unregister(&spi_bus_type);
 err1:
-- 
1.7.12

