Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaBUQ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:29:46 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:57921 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbaBUQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:29:28 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 4/4] spi: rspi: Fix loopback mode for Dual/Quad SPI Transfers
Date: Fri, 21 Feb 2014 17:29:18 +0100
Message-Id: <1393000158-6622-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
References: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

While normal Dual and Quad SPI Transfers are unidirectional, we must do
a bidirectional transfer if loopback mode is enabled, else rx_buf is not
filled.

With spidev it seemed to work, as spidev uses the same buffer for
tranmission and reception.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 4a1f978c3381..92bec7e91046 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -859,7 +859,9 @@ static int qspi_transfer_one(struct spi_master *master, struct spi_device *spi,
 {
 	struct rspi_data *rspi = spi_master_get_devdata(master);
 
-	if (xfer->tx_buf && xfer->tx_nbits > SPI_NBITS_SINGLE) {
+	if (spi->mode & SPI_LOOP) {
+		return qspi_transfer_out_in(rspi, xfer);
+	} else if (xfer->tx_buf && xfer->tx_nbits > SPI_NBITS_SINGLE) {
 		/* Quad or Dual SPI Write */
 		return qspi_transfer_out(rspi, xfer);
 	} else if (xfer->rx_buf && xfer->rx_nbits > SPI_NBITS_SINGLE) {
-- 
1.7.9.5

