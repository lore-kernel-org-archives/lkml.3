Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936744AbaFIJmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:42:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbaFIJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/146] spi: core: Ignore unsupported Dual/Quad Transfer Mode bits
Date: Mon,  9 Jun 2014 10:51:12 +0200
Message-Id: <fe18843c6cd2860ac6981c6465315a9b49612e06.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 83596fbeb5d28e8cb8878786133945d4dc7c0090 upstream.

The availability of SPI Dual or Quad Transfer Mode as indicated by the
"spi-tx-bus-width" and "spi-rx-bus-width" properties in the device tree is
a hardware property of the SPI master, SPI slave, and board wiring.  Hence
the SPI core should not reject an SPI slave because an SPI master driver
doesn't (yet) support Dual or Quad Transfer Mode.

Change the lack of Dual or Quad Transfer Mode support in the SPI master
driver from an error condition to a warning condition, and ignore the
unsupported mode bits, falling back to Single Transfer Mode, to avoid
breakages when running old kernels with new device trees.

Fixes: f477b7fb13df (spi: DUAL and QUAD support)
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9e039c60c068..d254477372b9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1370,7 +1370,7 @@ EXPORT_SYMBOL_GPL(spi_busnum_to_master);
  */
 int spi_setup(struct spi_device *spi)
 {
-	unsigned	bad_bits;
+	unsigned	bad_bits, ugly_bits;
 	int		status = 0;
 
 	/* check mode to prevent that DUAL and QUAD set at the same time
@@ -1390,6 +1390,15 @@ int spi_setup(struct spi_device *spi)
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
1.9.3

