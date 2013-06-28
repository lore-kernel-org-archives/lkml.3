Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3F1Snt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:43:49 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:33987 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729Ab3F1Snr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:43:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1372445015!8563127!23
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] spi: spi-ep93xx: use bits_per_word_mask
Date: Fri, 28 Jun 2013 11:43:07 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281143.07615.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports 16 to 4 bits per work. Set the bits_per_word_mask
to allows the spi core to handle validation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index c633cd0..93ae7b6 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -272,12 +272,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
 	struct ep93xx_spi *espi = spi_master_get_devdata(spi->master);
 	struct ep93xx_spi_chip *chip;
 
-	if (spi->bits_per_word < 4 || spi->bits_per_word > 16) {
-		dev_err(&espi->pdev->dev, "invalid bits per word %d\n",
-			spi->bits_per_word);
-		return -EINVAL;
-	}
-
 	chip = spi_get_ctldata(spi);
 	if (!chip) {
 		dev_dbg(&espi->pdev->dev, "initial setup for %s\n",
@@ -341,10 +335,6 @@ static int ep93xx_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 
 	/* first validate each transfer */
 	list_for_each_entry(t, &msg->transfers, transfer_list) {
-		if (t->bits_per_word) {
-			if (t->bits_per_word < 4 || t->bits_per_word > 16)
-				return -EINVAL;
-		}
 		if (t->speed_hz && t->speed_hz < espi->min_rate)
 				return -EINVAL;
 	}
@@ -1022,6 +1012,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = info->num_chipselect;
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+	master->bits_per_word_mask = 0xfff8;	/* 16 to 4 bits per word */
 
 	platform_set_drvdata(pdev, master);
 
-- 
1.8.1.4

