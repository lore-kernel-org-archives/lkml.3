Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaDNRkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:40:04 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:32887 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaDNRkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:40:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] spi: core: Ignore unsupported Dual/Quad Transfer Mode bits
Date: Mon, 14 Apr 2014 19:39:53 +0200
Message-Id: <1397497193-28067-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

The availability of SPI Dual or Quad Transfer Mode as indicated by the
"spi-tx-bus-width" and "spi-rx-bus-width" properties in the device tree is
a hardware property of the SPI master, SPI slave, and board wiring.  Hence
the SPI core should not reject an SPI slave because an SPI master driver
doesn't (yet) support Dual or Quad Transfer Mode.

Change the lack of Dual or Quad Transfer Mode support in the SPI master
driver from an error condition to a warning condition, and ignore the
unsupported mode bits, falling back to Single Transfer Mode, to avoid
breakages when running old kernels with new device trees.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I think this should be applied to -stable, for all versions containing
commit f477b7fb13df2b843997559ff34e87d054ba6538 ("spi: DUAL and QUAD
support"), i.e. v3.12, v3.13, v3.14.
---
 drivers/spi/spi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4eb9bf02996c..1534fa1dac34 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1756,7 +1756,7 @@ EXPORT_SYMBOL_GPL(spi_busnum_to_master);
  */
 int spi_setup(struct spi_device *spi)
 {
-	unsigned	bad_bits;
+	unsigned	bad_bits, ugly_bits;
 	int		status = 0;
 
 	/* check mode to prevent that DUAL and QUAD set at the same time
@@ -1776,6 +1776,15 @@ int spi_setup(struct spi_device *spi)
 	 * that aren't supported with their current master
 	 */
 	bad_bits = spi->mode & ~spi->master->mode_bits;
+	ugly_bits = bad_bits &
+		    (SPI_TX_DUAL | SPI_TX_QUAD | SPI_RX_DUAL | SPI_RX_QUAD);
+	if (ugly_bits) {
+		dev_warn(&spi->dev,
+			 "setup: ignoring unsupported mode bits %x\n",
+			 ugly_bits);
+		spi->mode &= ~ugly_bits;
+		bad_bits &= ~ugly_bits;
+	}
 	if (bad_bits) {
 		dev_err(&spi->dev, "setup: unsupported mode bits %x\n",
 			bad_bits);
-- 
1.7.9.5

