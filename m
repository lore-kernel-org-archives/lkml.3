Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967175AbaFQVwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:52:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390AbaFQVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 074/212] spi: core: Ignore unsupported Dual/Quad Transfer Mode bits
Date: Tue, 17 Jun 2014 14:42:48 -0700
Message-Id: <1403041506-13646-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 349ebba..a416aec 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1551,7 +1551,7 @@ EXPORT_SYMBOL_GPL(spi_busnum_to_master);
  */
 int spi_setup(struct spi_device *spi)
 {
-	unsigned	bad_bits;
+	unsigned	bad_bits, ugly_bits;
 	int		status = 0;
 
 	/* check mode to prevent that DUAL and QUAD set at the same time
@@ -1571,6 +1571,15 @@ int spi_setup(struct spi_device *spi)
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
1.9.1

