Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3F1Squ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:46:50 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.106]:19813 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729Ab3F1Sqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:46:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1372445206!4182280!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] spi: spi-ep93xx: move the clock divider calcs into ep93xx_spi_chip_setup()
Date: Fri, 28 Jun 2013 11:45:28 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281145.29079.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The divider values stored in the per chip data are only used to set the
registers in the hardware to generate the desired SPI clock. Since these
are calculated per transfer based on the t->speed_hz there is no reason
keep them in the per chip data.

Move the ep93xx_spi_calc_divisors() call into ep93xx_spi_chip_setup()
and return the dividers thru pointers. Remove the divider values from
the per chip data structure.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 58 +++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 2f2d51a..56305d3 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -137,18 +137,10 @@ struct ep93xx_spi {
 /**
  * struct ep93xx_spi_chip - SPI device hardware settings
  * @spi: back pointer to the SPI device
- * @div_cpsr: cpsr (pre-scaler) divider
- * @div_scr: scr divider
  * @ops: private chip operations
- *
- * This structure is used to store hardware register specific settings for each
- * SPI device. Settings are written to hardware by function
- * ep93xx_spi_chip_setup().
  */
 struct ep93xx_spi_chip {
 	const struct spi_device		*spi;
-	u8				div_cpsr;
-	u8				div_scr;
 	struct ep93xx_spi_chip_ops	*ops;
 };
 
@@ -200,17 +192,13 @@ static void ep93xx_spi_disable_interrupts(const struct ep93xx_spi *espi)
 /**
  * ep93xx_spi_calc_divisors() - calculates SPI clock divisors
  * @espi: ep93xx SPI controller struct
- * @chip: divisors are calculated for this chip
  * @rate: desired SPI output clock rate
- *
- * Function calculates cpsr (clock pre-scaler) and scr divisors based on
- * given @rate and places them to @chip->div_cpsr and @chip->div_scr. If,
- * for some reason, divisors cannot be calculated nothing is stored and
- * %-EINVAL is returned.
+ * @div_cpsr: pointer to return the cpsr (pre-scaler) divider
+ * @div_scr: pointer to return the scr divider
  */
 static int ep93xx_spi_calc_divisors(const struct ep93xx_spi *espi,
-				    struct ep93xx_spi_chip *chip,
-				    unsigned long rate)
+				    unsigned long rate,
+				    u8 *div_cpsr, u8 *div_scr)
 {
 	unsigned long spi_clk_rate = clk_get_rate(espi->clk);
 	int cpsr, scr;
@@ -233,8 +221,8 @@ static int ep93xx_spi_calc_divisors(const struct ep93xx_spi *espi,
 	for (cpsr = 2; cpsr <= 254; cpsr += 2) {
 		for (scr = 0; scr <= 255; scr++) {
 			if ((spi_clk_rate / (cpsr * (scr + 1))) <= rate) {
-				chip->div_scr = (u8)scr;
-				chip->div_cpsr = (u8)cpsr;
+				*div_scr = (u8)scr;
+				*div_cpsr = (u8)cpsr;
 				return 0;
 			}
 		}
@@ -365,29 +353,34 @@ static void ep93xx_spi_cleanup(struct spi_device *spi)
  * ep93xx_spi_chip_setup() - configures hardware according to given @chip
  * @espi: ep93xx SPI controller struct
  * @chip: chip specific settings
+ * @speed_hz: transfer speed
  * @bits_per_word: transfer bits_per_word
- *
- * This function sets up the actual hardware registers with settings given in
- * @chip. Note that no validation is done so make sure that callers validate
- * settings before calling this.
  */
-static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
-				  const struct ep93xx_spi_chip *chip,
-				  u8 bits_per_word)
+static int ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
+				 struct ep93xx_spi_chip *chip,
+				 u32 speed_hz, u8 bits_per_word)
 {
+	u8 div_cpsr = 0;
+	u8 div_scr = 0;
 	u16 cr0;
+	int err;
+
+	err = ep93xx_spi_calc_divisors(espi, speed_hz, &div_cpsr, &div_scr);
+	if (err)
+		return err;
 
-	cr0 = chip->div_scr << SSPCR0_SCR_SHIFT;
+	cr0 = div_scr << SSPCR0_SCR_SHIFT;
 	cr0 |= (chip->spi->mode & (SPI_CPHA|SPI_CPOL)) << SSPCR0_MODE_SHIFT;
 	cr0 |= (bits_per_word - 1);
 
 	dev_dbg(&espi->pdev->dev, "setup: mode %d, cpsr %d, scr %d, dss %d\n",
-		chip->spi->mode, chip->div_cpsr, chip->div_scr,
-		bits_per_word - 1);
+		chip->spi->mode, div_cpsr, div_scr, bits_per_word - 1);
 	dev_dbg(&espi->pdev->dev, "setup: cr0 %#x", cr0);
 
-	writeb(chip->div_cpsr, espi->regs_base + SSPCPSR);
+	writeb(div_cpsr, espi->regs_base + SSPCPSR);
 	writew(cr0, espi->regs_base + SSPCR0);
+
+	return 0;
 }
 
 static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
@@ -663,15 +656,14 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 
 	msg->state = t;
 
-	err = ep93xx_spi_calc_divisors(espi, chip, t->speed_hz);
+	err = ep93xx_spi_chip_setup(espi, chip, t->speed_hz, t->bits_per_word);
 	if (err) {
-		dev_err(&espi->pdev->dev, "failed to adjust speed\n");
+		dev_err(&espi->pdev->dev,
+			"failed to setup chip for transfer\n");
 		msg->status = err;
 		return;
 	}
 
-	ep93xx_spi_chip_setup(espi, chip, t->bits_per_word);
-
 	espi->word_xfer = (t->bits_per_word > 8) ? true : false;
 	espi->rx = 0;
 	espi->tx = 0;
-- 
1.8.1.4

