Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3ETGv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:51:59 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44641 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3ETGv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:51:57 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH v1 2/3] spi: s3c64xx: Added provision for dedicated cs pin
Date: Mon, 20 May 2013 12:21:33 +0530
Message-Id: <1369032694-13183-3-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
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
changes in v1:
		Added the missing data structure that caused the
compilation error

 drivers/spi/spi-s3c64xx.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 0a80692..eaf9e1c 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -208,6 +208,7 @@ struct s3c64xx_spi_driver_data {
 	struct s3c64xx_spi_port_config	*port_conf;
 	unsigned int			port_id;
 	unsigned long			gpios[4];
+	bool				cs_gpio;
 };
 
 static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
@@ -570,14 +571,16 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 		if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
 			/* Deselect the last toggled device */
 			cs = sdd->tgl_spi->controller_data;
-			gpio_set_value(cs->line,
-				spi->mode & SPI_CS_HIGH ? 0 : 1);
+			if (sdd->cs_gpio)
+				gpio_set_value(cs->line,
+					spi->mode & SPI_CS_HIGH ? 0 : 1);
 		}
 		sdd->tgl_spi = NULL;
 	}
 
 	cs = spi->controller_data;
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+	if (sdd->cs_gpio)
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
 
 	/* Start the signals */
 	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
@@ -709,7 +712,8 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 	if (sdd->tgl_spi == spi)
 		sdd->tgl_spi = NULL;
 
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+	if (sdd->cs_gpio)
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
 
 	/* Quiese the signals */
 	writel(S3C64XX_SPI_SLAVE_SIG_INACT, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
@@ -997,8 +1001,10 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 {
 	struct s3c64xx_spi_csinfo *cs;
 	struct device_node *slave_np, *data_np = NULL;
+	struct s3c64xx_spi_driver_data *sdd;
 	u32 fb_delay = 0;
 
+	sdd = spi_master_get_devdata(spi->master);
 	slave_np = spi->dev.of_node;
 	if (!slave_np) {
 		dev_err(&spi->dev, "device node not found\n");
@@ -1018,7 +1024,10 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
+	/* The CS line is asserted/deasserted by the gpio pin */
+	if (sdd->cs_gpio)
+		cs->line = of_get_named_gpio(data_np, "cs-gpio", 0);
+
 	if (!gpio_is_valid(cs->line)) {
 		dev_err(&spi->dev, "chip select gpio is not specified or invalid\n");
 		kfree(cs);
@@ -1058,7 +1067,8 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	if (!spi_get_ctldata(spi)) {
+	/* Request gpio only if cs line is asserted by gpio pins */
+	if (sdd->cs_gpio) {
 		err = gpio_request_one(cs->line, GPIOF_OUT_INIT_HIGH,
 				       dev_name(&spi->dev));
 		if (err) {
@@ -1067,9 +1077,11 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
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
@@ -1147,8 +1159,10 @@ err_gpio_req:
 static void s3c64xx_spi_cleanup(struct spi_device *spi)
 {
 	struct s3c64xx_spi_csinfo *cs = spi_get_ctldata(spi);
+	struct s3c64xx_spi_driver_data *sdd;
 
-	if (cs) {
+	sdd = spi_master_get_devdata(spi->master);
+	if (cs && sdd->cs_gpio) {
 		gpio_free(cs->line);
 		if (spi->dev.of_node)
 			kfree(cs);
@@ -1325,7 +1339,11 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	sdd->cntrlr_info = sci;
 	sdd->pdev = pdev;
 	sdd->sfr_start = mem_res->start;
+	sdd->cs_gpio = false;
 	if (pdev->dev.of_node) {
+		if (of_find_property(pdev->dev.of_node, "cs-gpio", NULL))
+			sdd->cs_gpio = true;
+
 		ret = of_alias_get_id(pdev->dev.of_node, "spi");
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get alias id, errno %d\n",
-- 
1.7.5.4

