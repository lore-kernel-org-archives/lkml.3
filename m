Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3BEXK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:10:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44160 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3BEXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:10:54 -0500
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] spi: s3c64xx: add gpio quirk for controller
Date: Tue,  5 Feb 2013 15:09:43 -0800
Message-Id: <1360105784-12282-4-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for spi controllers with
dedicated clk/miso/mosi/cs pins. It skips the gpio
parsing and initialization for controllers that
have dedicated pins.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 90770bd..f06bbee 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -36,6 +36,7 @@
 
 #define MAX_SPI_PORTS		3
 #define S3C64XX_SPI_QUIRK_POLL		(1 << 0)
+#define S3C64XX_SPI_QUIRK_GPIO		(1 << 1)
 
 /* Registers and bit-fields */
 
@@ -404,14 +405,16 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 		if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
 			/* Deselect the last toggled device */
 			cs = sdd->tgl_spi->controller_data;
-			gpio_set_value(cs->line,
-				spi->mode & SPI_CS_HIGH ? 0 : 1);
+			if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
+				gpio_set_value(cs->line,
+					spi->mode & SPI_CS_HIGH ? 0 : 1);
 		}
 		sdd->tgl_spi = NULL;
 	}
 
 	cs = spi->controller_data;
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
 
 	/* Start the signals */
 	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
@@ -503,7 +506,8 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 	if (sdd->tgl_spi == spi)
 		sdd->tgl_spi = NULL;
 
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
 
 	/* Quiese the signals */
 	writel(S3C64XX_SPI_SLAVE_SIG_INACT,
@@ -842,7 +846,10 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
+	/* In case of dedicated cs pin skip the gpio initialization */
+	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
+		cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
+
 	if (!gpio_is_valid(cs->line)) {
 		dev_err(&spi->dev, "chip select gpio is not specified or "
 					"invalid\n");
@@ -883,7 +890,7 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	if (!spi_get_ctldata(spi)) {
+	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO)) {
 		err = gpio_request_one(cs->line, GPIOF_OUT_INIT_HIGH,
 				       dev_name(&spi->dev));
 		if (err) {
@@ -892,9 +899,11 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 				cs->line, err);
 			goto err_gpio_req;
 		}
-		spi_set_ctldata(spi, cs);
 	}
 
+	if (!spi_get_ctldata(spi))
+		spi_set_ctldata(spi, cs);
+
 	sci = sdd->cntrlr_info;
 
 	spin_lock_irqsave(&sdd->lock, flags);
@@ -979,8 +988,11 @@ err_gpio_req:
 static void s3c64xx_spi_cleanup(struct spi_device *spi)
 {
 	struct s3c64xx_spi_csinfo *cs = spi_get_ctldata(spi);
+	struct s3c64xx_spi_driver_data *sdd;
+
+	sdd = spi_master_get_devdata(spi->master);
 
-	if (cs) {
+	if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO) && cs) {
 		gpio_free(cs->line);
 		if (spi->dev.of_node)
 			kfree(cs);
@@ -1107,6 +1119,13 @@ static int s3c64xx_spi_parse_dt_gpio(struct s3c64xx_spi_driver_data *sdd)
 	struct device *dev = &sdd->pdev->dev;
 	int idx, gpio, ret;
 
+	/*
+	 * If cs is not controlled by gpio, and
+	 * the SoC uses internal dedicated pins
+	 */
+	if (sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO)
+		return 0;
+
 	/* find gpios for mosi, miso and clock lines */
 	for (idx = 0; idx < 3; idx++) {
 		gpio = of_get_gpio(dev->of_node, idx);
@@ -1133,6 +1152,10 @@ free_gpio:
 static void s3c64xx_spi_dt_gpio_free(struct s3c64xx_spi_driver_data *sdd)
 {
 	unsigned int idx;
+
+	if (sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO)
+		return;
+
 	for (idx = 0; idx < 3; idx++)
 		gpio_free(sdd->gpios[idx]);
 }
-- 
1.7.10.4

