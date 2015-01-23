Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbbAWQL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:11:59 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:43096 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbbAWQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:15 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 13/18] spi/xilinx: Convert remainding_bytes in remaining words
Date: Fri, 23 Jan 2015 17:08:45 +0100
Message-Id: <1422029330-10971-14-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code by using the unit used on most of the code logic.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 514ad01..fce5d0b 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -86,7 +86,7 @@ struct xilinx_spi {
 
 	u8 *rx_ptr;		/* pointer in the Tx buffer */
 	const u8 *tx_ptr;	/* pointer in the Rx buffer */
-	int remaining_bytes;	/* the number of bytes left to transfer */
+	int remaining_words;	/* the number of words left to transfer */
 	u8 bits_per_word;
 	int buffer_size;	/* buffer size in words */
 	u32 cs_inactive;	/* Level of the CS pins when inactive*/
@@ -231,7 +231,7 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
 
 static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi, int n_words)
 {
-	xspi->remaining_bytes -= n_words * xspi->bits_per_word / 8;
+	xspi->remaining_words -= n_words;
 
 	while (n_words--)
 		xilinx_spi_tx(xspi);
@@ -246,15 +246,14 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 	xspi->tx_ptr = t->tx_buf;
 	xspi->rx_ptr = t->rx_buf;
-	xspi->remaining_bytes = t->len;
+	xspi->remaining_words = (t->len * 8) / xspi->bits_per_word;
 	reinit_completion(&xspi->done);
 
-	while (xspi->remaining_bytes) {
+	while (xspi->remaining_words) {
 		u16 cr = 0;
 		int n_words;
 
-		n_words = (xspi->remaining_bytes * 8) / xspi->bits_per_word;
-		n_words = min(n_words, xspi->buffer_size);
+		n_words = min(xspi->remaining_words, xspi->buffer_size);
 
 		xilinx_spi_fill_tx_fifo(xspi, n_words);
 
@@ -286,7 +285,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 			xilinx_spi_rx(xspi);
 	}
 
-	return t->len - xspi->remaining_bytes;
+	return t->len;
 }
 
 
-- 
2.1.4

