Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaKGRMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:12:13 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48179 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKGRMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:12:09 -0500
From: Torsten Fleischer <torfl6749@gmail.com>
X-Google-Original-From: Torsten Fleischer
To: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Torsten Fleischer <torfl6749@gmail.com>
Subject: [PATCH 1/1] spi: spi-gpio: Fix compiler warning when building for 64 bit systems
Date: Fri,  7 Nov 2014 18:11:58 +0100
Message-Id: <1415380318-2065-1-git-send-email-torfl6749@gmail.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torsten Fleischer <torfl6749@gmail.com>

The assignment of SPI_GPIO_NO_CHIPSELECT to cs_gpios[0] causes the following
compiler warning, when building for 64 bit systems:
"warning: overflow in implicit constant conversion [-Woverflow]".

This is because the SPI_GPIO_NO_CHIPSELECT flag is a '-1' type casted to
unsigned long and cs_gpios is of the type int.

Furthermore the chip select's GPIO number is locally stored as unsigned int
and compared with SPI_GPIO_NO_CHIPSELECT. Thus the result of the comparison
is always false, if unsigned long and unsigned int have a different size.

As part of the fix this patch adds a check for the device tree's cs-gpios
property.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Torsten Fleischer <torfl6749@gmail.com>
---
 drivers/spi/spi-gpio.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index f0492c9..4b600d4 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -48,7 +48,7 @@ struct spi_gpio {
 	struct spi_bitbang		bitbang;
 	struct spi_gpio_platform_data	pdata;
 	struct platform_device		*pdev;
-	int				cs_gpios[0];
+	unsigned long			cs_gpios[0];
 };
 
 /*----------------------------------------------------------------------*/
@@ -220,7 +220,7 @@ static u32 spi_gpio_spec_txrx_word_mode3(struct spi_device *spi,
 static void spi_gpio_chipselect(struct spi_device *spi, int is_active)
 {
 	struct spi_gpio *spi_gpio = spi_to_spi_gpio(spi);
-	unsigned int cs = spi_gpio->cs_gpios[spi->chip_select];
+	unsigned long cs = spi_gpio->cs_gpios[spi->chip_select];
 
 	/* set initial clock polarity */
 	if (is_active)
@@ -234,7 +234,7 @@ static void spi_gpio_chipselect(struct spi_device *spi, int is_active)
 
 static int spi_gpio_setup(struct spi_device *spi)
 {
-	unsigned int		cs;
+	unsigned long		cs;
 	int			status = 0;
 	struct spi_gpio		*spi_gpio = spi_to_spi_gpio(spi);
 	struct device_node	*np = spi->master->dev.of_node;
@@ -249,7 +249,7 @@ static int spi_gpio_setup(struct spi_device *spi)
 		/*
 		 * ... otherwise, take it from spi->controller_data
 		 */
-		cs = (unsigned int)(uintptr_t) spi->controller_data;
+		cs = (uintptr_t) spi->controller_data;
 	}
 
 	if (!spi->controller_state) {
@@ -277,7 +277,7 @@ static int spi_gpio_setup(struct spi_device *spi)
 static void spi_gpio_cleanup(struct spi_device *spi)
 {
 	struct spi_gpio *spi_gpio = spi_to_spi_gpio(spi);
-	unsigned int cs = spi_gpio->cs_gpios[spi->chip_select];
+	unsigned long cs = spi_gpio->cs_gpios[spi->chip_select];
 
 	if (cs != SPI_GPIO_NO_CHIPSELECT)
 		gpio_free(cs);
@@ -437,7 +437,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		return status;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*spi_gpio) +
-					(sizeof(int) * num_devices));
+					(sizeof(unsigned long) * num_devices));
 	if (!master) {
 		status = -ENOMEM;
 		goto gpio_free;
@@ -470,9 +470,15 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		if (!SPI_N_CHIPSEL)
 			spi_gpio->cs_gpios[0] = SPI_GPIO_NO_CHIPSELECT;
 		else
-			for (i = 0; i < SPI_N_CHIPSEL; i++)
-				spi_gpio->cs_gpios[i] =
-					of_get_named_gpio(np, "cs-gpios", i);
+			for (i = 0; i < SPI_N_CHIPSEL; i++) {
+				status = of_get_named_gpio(np, "cs-gpios", i);
+				if (status < 0) {
+					dev_err(&pdev->dev,
+						"invalid cs-gpios property\n");
+					goto gpio_free;
+				}
+				spi_gpio->cs_gpios[i] = status;
+			}
 	}
 #endif
 
-- 
1.8.4.5

