Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab3CMGoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:44:19 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46523 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3CMGoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:44:08 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH V3 4/5] spi: s3c64xx: Added provision for dedicated cs pin
Date: Wed, 13 Mar 2013 12:13:33 +0530
Message-Id: <1363157014-9615-5-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Girish K S <girishks2000@gmail.com>

The existing driver supports gpio based /cs signal.
For controller's that have one device per controller,
the slave device's /cs signal might be internally controlled
by the chip select bit of slave select register. They are not
externally asserted/deasserted using gpio pin.

This patch adds support for controllers with dedicated /cs pin.
if "cs-gpio" property doesnt exist in a spi dts node, the controller
would treat the /cs pin as dedicated.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c                 | 27 +++++++++++++++++++--------
 include/linux/platform_data/spi-s3c64xx.h |  3 +++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 94716d1..ac557f8 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -414,14 +414,16 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 		if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
 			/* Deselect the last toggled device */
 			cs = sdd->tgl_spi->controller_data;
-			gpio_set_value(cs->line,
-				spi->mode & SPI_CS_HIGH ? 0 : 1);
+			if (cs->cs_gpio)
+				gpio_set_value(cs->line,
+					spi->mode & SPI_CS_HIGH ? 0 : 1);
 		}
 		sdd->tgl_spi = NULL;
 	}
 
 	cs = spi->controller_data;
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+	if (cs->cs_gpio)
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
 
 	/* Start the signals */
 	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
@@ -550,7 +552,8 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 	if (sdd->tgl_spi == spi)
 		sdd->tgl_spi = NULL;
 
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+	if (cs->cs_gpio)
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
 
 	/* Quiese the signals */
 	writel(S3C64XX_SPI_SLAVE_SIG_INACT,
@@ -889,7 +892,12 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
+	if (of_find_property(data_np, "cs-gpio", NULL)) {
+		/* The CS line is asserted/deasserted by the gpio pin */
+		cs->cs_gpio = true;
+		cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
+	}
+
 	if (!gpio_is_valid(cs->line)) {
 		dev_err(&spi->dev, "chip select gpio is not specified or invalid\n");
 		kfree(cs);
@@ -929,7 +937,8 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	if (!spi_get_ctldata(spi)) {
+	/* Request gpio only if cs line is asserted by gpio pins */
+	if (cs->cs_gpio) {
 		err = gpio_request_one(cs->line, GPIOF_OUT_INIT_HIGH,
 				       dev_name(&spi->dev));
 		if (err) {
@@ -938,9 +947,11 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
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
@@ -1028,7 +1039,7 @@ static void s3c64xx_spi_cleanup(struct spi_device *spi)
 {
 	struct s3c64xx_spi_csinfo *cs = spi_get_ctldata(spi);
 
-	if (cs) {
+	if (cs && cs->cs_gpio) {
 		gpio_free(cs->line);
 		if (spi->dev.of_node)
 			kfree(cs);
diff --git a/include/linux/platform_data/spi-s3c64xx.h b/include/linux/platform_data/spi-s3c64xx.h
index ceba18d..0343d8d 100644
--- a/include/linux/platform_data/spi-s3c64xx.h
+++ b/include/linux/platform_data/spi-s3c64xx.h
@@ -17,6 +17,8 @@ struct platform_device;
  * struct s3c64xx_spi_csinfo - ChipSelect description
  * @fb_delay: Slave specific feedback delay.
  *            Refer to FB_CLK_SEL register definition in SPI chapter.
+ * @cs_gpio: CS line status, 'true' if CS line is asserted by gpio.
+ * 	     'false' if asserted by internal dedicated pin.
  * @line: Custom 'identity' of the CS line.
  *
  * This is per SPI-Slave Chipselect information.
@@ -25,6 +27,7 @@ struct platform_device;
  */
 struct s3c64xx_spi_csinfo {
 	u8 fb_delay;
+	bool cs_gpio;
 	unsigned line;
 };
 
-- 
1.8.0

