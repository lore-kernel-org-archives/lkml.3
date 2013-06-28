Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3F1SpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:45:12 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.112]:56437 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984Ab3F1SpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:45:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1372445103!6819060!8
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] spi: spi-ep93xx: remove 'dss' from per chip private data
Date: Fri, 28 Jun 2013 11:44:33 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281144.34074.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This value is only needed to set the bits per word for each transfer
of a message. There is no reason to set the value in ep93xx_spi_enable()
because ep93xx_spi_process_transfer() sets it again for each transfer.

Just pass the t->bits_per_word directly to ep93xx_spi_chip_setup() in
ep93xx_spi_process_transfer() and remove 'dss' from the per chip private
data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 4fab3bb..cb22c89 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -140,7 +140,6 @@ struct ep93xx_spi {
  * @rate: max rate in hz this chip supports
  * @div_cpsr: cpsr (pre-scaler) divider
  * @div_scr: scr divider
- * @dss: bits per word (4 - 16 bits)
  * @ops: private chip operations
  *
  * This structure is used to store hardware register specific settings for each
@@ -152,13 +151,9 @@ struct ep93xx_spi_chip {
 	unsigned long			rate;
 	u8				div_cpsr;
 	u8				div_scr;
-	u8				dss;
 	struct ep93xx_spi_chip_ops	*ops;
 };
 
-/* converts bits per word to CR0.DSS value */
-#define bits_per_word_to_dss(bpw)	((bpw) - 1)
-
 static int ep93xx_spi_enable(const struct ep93xx_spi *espi)
 {
 	u8 regval;
@@ -308,8 +303,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
 		chip->rate = spi->max_speed_hz;
 	}
 
-	chip->dss = bits_per_word_to_dss(spi->bits_per_word);
-
 	ep93xx_spi_cs_control(spi, false);
 	return 0;
 }
@@ -386,22 +379,25 @@ static void ep93xx_spi_cleanup(struct spi_device *spi)
  * ep93xx_spi_chip_setup() - configures hardware according to given @chip
  * @espi: ep93xx SPI controller struct
  * @chip: chip specific settings
+ * @bits_per_word: transfer bits_per_word
  *
  * This function sets up the actual hardware registers with settings given in
  * @chip. Note that no validation is done so make sure that callers validate
  * settings before calling this.
  */
 static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
-				  const struct ep93xx_spi_chip *chip)
+				  const struct ep93xx_spi_chip *chip,
+				  u8 bits_per_word)
 {
 	u16 cr0;
 
 	cr0 = chip->div_scr << SSPCR0_SCR_SHIFT;
 	cr0 |= (chip->spi->mode & (SPI_CPHA|SPI_CPOL)) << SSPCR0_MODE_SHIFT;
-	cr0 |= chip->dss;
+	cr0 |= (bits_per_word - 1);
 
 	dev_dbg(&espi->pdev->dev, "setup: mode %d, cpsr %d, scr %d, dss %d\n",
-		chip->spi->mode, chip->div_cpsr, chip->div_scr, chip->dss);
+		chip->spi->mode, chip->div_cpsr, chip->div_scr,
+		bits_per_word - 1);
 	dev_dbg(&espi->pdev->dev, "setup: cr0 %#x", cr0);
 
 	writeb(chip->div_cpsr, espi->regs_base + SSPCPSR);
@@ -688,9 +684,7 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 		return;
 	}
 
-	chip->dss = bits_per_word_to_dss(t->bits_per_word);
-
-	ep93xx_spi_chip_setup(espi, chip);
+	ep93xx_spi_chip_setup(espi, chip, t->bits_per_word);
 
 	espi->word_xfer = (t->bits_per_word > 8) ? true : false;
 	espi->rx = 0;
-- 
1.8.1.4

