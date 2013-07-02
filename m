Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3GBRKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:10:32 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.11]:33816 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab3GBRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:10:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1372785007!6212267!31
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 08/11] spi: spi-ep93xx: don't bother calculating the divisors in ep93xx_spi_setup()
Date: Tue, 2 Jul 2013 10:10:00 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307021010.00977.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The divisors needed to generate the SPI clock are calculated per
transfer based on the t->speed_hz. There is no reason to calculate
them in ep93xx_spi_setup().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index cc2a240..6cdfc40 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -136,7 +136,6 @@ struct ep93xx_spi {
 /**
  * struct ep93xx_spi_chip - SPI device hardware settings
  * @spi: back pointer to the SPI device
- * @rate: max rate in hz this chip supports
  * @div_cpsr: cpsr (pre-scaler) divider
  * @div_scr: scr divider
  * @ops: private chip operations
@@ -147,7 +146,6 @@ struct ep93xx_spi {
  */
 struct ep93xx_spi_chip {
 	const struct spi_device		*spi;
-	unsigned long			rate;
 	u8				div_cpsr;
 	u8				div_scr;
 	struct ep93xx_spi_chip_ops	*ops;
@@ -315,18 +313,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
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

