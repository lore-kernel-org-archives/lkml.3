Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaAUPLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:11:23 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:40721 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaAUPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:10:21 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 4/5] spi: Check that Quad/Dual is half duplex
Date: Tue, 21 Jan 2014 16:10:08 +0100
Message-Id: <1390317009-8292-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Quad and Dual SPI Transfers use all available data lines (incl. MOSI/MISO),
hence they must be half duplex. Add a check that verify that.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
I think this check is done nowhere else. Please correct me if I missed it.

 drivers/spi/spi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 7f77f82bf95e..4afcdb4851fa 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1672,6 +1672,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 		/* check transfer tx/rx_nbits:
 		 * 1. check the value matches one of single, dual and quad
 		 * 2. check tx/rx_nbits match the mode in spi_device
+		 * 3. check dual or quad is half duplex
 		 */
 		if (xfer->tx_buf) {
 			if (xfer->tx_nbits != SPI_NBITS_SINGLE &&
@@ -1684,6 +1685,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 			if ((xfer->tx_nbits == SPI_NBITS_QUAD) &&
 				!(spi->mode & SPI_TX_QUAD))
 				return -EINVAL;
+			if (xfer->tx_nbits > SPI_NBITS_SINGLE && xfer->rx_buf)
+				return -EINVAL;
 		}
 		/* check transfer rx_nbits */
 		if (xfer->rx_buf) {
@@ -1697,6 +1700,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 			if ((xfer->rx_nbits == SPI_NBITS_QUAD) &&
 				!(spi->mode & SPI_RX_QUAD))
 				return -EINVAL;
+			if (xfer->rx_nbits > SPI_NBITS_SINGLE && xfer->tx_buf)
+				return -EINVAL;
 		}
 	}
 
-- 
1.7.9.5

