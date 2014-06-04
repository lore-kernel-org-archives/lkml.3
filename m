Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaFDXXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbaFDXXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 220/228] spi: core: Ignore unsupported Dual/Quad Transfer Mode bits
Date: Wed,  4 Jun 2014 16:24:09 -0700
Message-Id: <20140604232355.117177434@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1568,7 +1568,7 @@ EXPORT_SYMBOL_GPL(spi_busnum_to_master);
  */
 int spi_setup(struct spi_device *spi)
 {
-	unsigned	bad_bits;
+	unsigned	bad_bits, ugly_bits;
 	int		status = 0;
 
 	/* check mode to prevent that DUAL and QUAD set at the same time
@@ -1588,6 +1588,15 @@ int spi_setup(struct spi_device *spi)
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


