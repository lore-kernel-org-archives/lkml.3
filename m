Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3F1Spm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:45:42 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:30829 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab3F1Spk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:45:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1372445126!23361819!21
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] spi: spi-ep93xx: don't bother calculating the divisors in ep93xx_spi_setup()
Date: Fri, 28 Jun 2013 11:45:02 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281145.02815.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The divisors needed to generate the SPI clock are calculated per
transfer based on the t->speed_hz. There is no reason to calculate
them in ep93xx_spi_setup().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index cb22c89..2f2d51a 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -137,7 +137,6 @@ struct ep93xx_spi {
 /**
  * struct ep93xx_spi_chip - SPI device hardware settings
  * @spi: back pointer to the SPI device
- * @rate: max rate in hz this chip supports
  * @div_cpsr: cpsr (pre-scaler) divider
  * @div_scr: scr divider
  * @ops: private chip operations
@@ -148,7 +147,6 @@ struct ep93xx_spi {
  */
 struct ep93xx_spi_chip {
 	const struct spi_device		*spi;
-	unsigned long			rate;
 	u8				div_cpsr;
 	u8				div_scr;
 	struct ep93xx_spi_chip_ops	*ops;
@@ -291,18 +289,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
 		spi_set_ctldata(spi, chip);
 	}
 
-	if (spi->max_speed_hz != chip->rate) {
-		int err;
-
-		err = ep93xx_spi_calc_divisors(espi, chip, spi->max_speed_hz);
-		if (err != 0) {
-			spi_set_ctldata(spi, NULL);
-			kfree(chip);
-			return err;
-		}
-		chip->rate = spi->max_speed_hz;
-	}
-
 	ep93xx_spi_cs_control(spi, false);
 	return 0;
 }
-- 
1.8.1.4

