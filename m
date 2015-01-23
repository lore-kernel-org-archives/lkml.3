Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbbAWQKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:10:13 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40651 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbbAWQJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:20 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 17/18] spi/xilinx: Remove remaining_words driver data variable
Date: Fri, 23 Jan 2015 17:08:49 +0100
Message-Id: <1422029330-10971-18-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable never leaves the scope of txrx_bufs.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 8c25c59..026f4c5 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -86,7 +86,6 @@ struct xilinx_spi {
 
 	u8 *rx_ptr;		/* pointer in the Tx buffer */
 	const u8 *tx_ptr;	/* pointer in the Rx buffer */
-	int remaining_words;	/* the number of words left to transfer */
 	u8 bytes_per_word;
 	int buffer_size;	/* buffer size in words */
 	u32 cs_inactive;	/* Level of the CS pins when inactive*/
@@ -209,33 +208,27 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
 	return 0;
 }
 
-static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi, int n_words)
-{
-	xspi->remaining_words -= n_words;
-
-	while (n_words--)
-		xilinx_spi_tx(xspi);
-	return;
-}
-
 static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 {
 	struct xilinx_spi *xspi = spi_master_get_devdata(spi->master);
+	int remaining_words;	/* the number of words left to transfer */
 
 	/* We get here with transmitter inhibited */
 
 	xspi->tx_ptr = t->tx_buf;
 	xspi->rx_ptr = t->rx_buf;
-	xspi->remaining_words = t->len / xspi->bytes_per_word;
+	remaining_words = t->len / xspi->bytes_per_word;
 	reinit_completion(&xspi->done);
 
-	while (xspi->remaining_words) {
+	while (remaining_words) {
 		u16 cr = 0;
-		int n_words;
+		int n_words, tx_words, rx_words;
 
-		n_words = min(xspi->remaining_words, xspi->buffer_size);
+		n_words = min(remaining_words, xspi->buffer_size);
 
-		xilinx_spi_fill_tx_fifo(xspi, n_words);
+		tx_words = n_words;
+		while (tx_words--)
+			xilinx_spi_tx(xspi);
 
 		/* Start the transfer by not inhibiting the transmitter any
 		 * longer
@@ -261,8 +254,11 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 			       xspi->regs + XSPI_CR_OFFSET);
 
 		/* Read out all the data from the Rx FIFO */
-		while (n_words--)
+		rx_words = n_words;
+		while (rx_words--)
 			xilinx_spi_rx(xspi);
+
+		remaining_words -= n_words;
 	}
 
 	return t->len;
-- 
2.1.4

