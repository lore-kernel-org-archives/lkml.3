Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaEVSHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:07:50 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:47393 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaEVSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:07:48 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>, Simon Horman <horms@verge.net.au>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] spi: rspi: Round up division to avoid slave overclocking
Date: Thu, 22 May 2014 20:07:35 +0200
Message-Id: <1400782055-19609-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation of the bit rate divider used a standard C division, which
rounds down the quotient. This may lead to a higher bitrate than requested.
Round up to avoid this.

E.g. on Koelsch, the SPI flash (configured for 30 MHz) was driven at 48.75
MHz. After this patch it's driven at a safe 24.375 MHz.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Simon: I think you want this in renesas-backports.

 drivers/spi/spi-rspi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 1fb0ad213324..5639f9529e0b 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -266,7 +266,8 @@ static int rspi_set_config_register(struct rspi_data *rspi, int access_size)
 	rspi_write8(rspi, rspi->sppcr, RSPI_SPPCR);
 
 	/* Sets transfer bit rate */
-	spbr = clk_get_rate(rspi->clk) / (2 * rspi->max_speed_hz) - 1;
+	spbr = DIV_ROUND_UP(clk_get_rate(rspi->clk),
+			    2 * rspi->max_speed_hz) - 1;
 	rspi_write8(rspi, clamp(spbr, 0, 255), RSPI_SPBR);
 
 	/* Disable dummy transmission, set 16-bit word access, 1 frame */
@@ -302,7 +303,8 @@ static int rspi_rz_set_config_register(struct rspi_data *rspi, int access_size)
 	rspi_write8(rspi, rspi->sppcr, RSPI_SPPCR);
 
 	/* Sets transfer bit rate */
-	spbr = clk_get_rate(rspi->clk) / (2 * rspi->max_speed_hz) - 1;
+	spbr = DIV_ROUND_UP(clk_get_rate(rspi->clk),
+			    2 * rspi->max_speed_hz) - 1;
 	rspi_write8(rspi, clamp(spbr, 0, 255), RSPI_SPBR);
 
 	/* Disable dummy transmission, set byte access */
@@ -335,7 +337,7 @@ static int qspi_set_config_register(struct rspi_data *rspi, int access_size)
 	rspi_write8(rspi, rspi->sppcr, RSPI_SPPCR);
 
 	/* Sets transfer bit rate */
-	spbr = clk_get_rate(rspi->clk) / (2 * rspi->max_speed_hz);
+	spbr = DIV_ROUND_UP(clk_get_rate(rspi->clk), 2 * rspi->max_speed_hz);
 	rspi_write8(rspi, clamp(spbr, 0, 255), RSPI_SPBR);
 
 	/* Disable dummy transmission, set byte access */
-- 
1.9.1

