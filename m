Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbbAWQOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:14:52 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57166 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbbAWQJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:00 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 03/18] spi/xilinx: Simplify data read from the Rx FIFO
Date: Fri, 23 Jan 2015 17:08:35 +0100
Message-Id: <1422029330-10971-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of words in the read buffer will be exactly the same as the
number of words written on write buffer, once the transaction has
finished.

Instead of cheking the rx_empty flags for every word simply save the
number of words written by fill_tx_fifo.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index e1d9a20..416b227 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -221,9 +221,10 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
 	return 0;
 }
 
-static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi)
+static int xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi)
 {
 	u8 sr;
+	int n_words = 0;
 
 	/* Fill the Tx FIFO with as many bytes as possible */
 	sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
@@ -234,7 +235,10 @@ static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi)
 			xspi->write_fn(0, xspi->regs + XSPI_TXD_OFFSET);
 		xspi->remaining_bytes -= xspi->bits_per_word / 8;
 		sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
+		n_words++;
 	}
+
+	return n_words;
 }
 
 static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
@@ -259,9 +263,9 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 	for (;;) {
 		u16 cr;
-		u8 sr;
+		int n_words;
 
-		xilinx_spi_fill_tx_fifo(xspi);
+		n_words = xilinx_spi_fill_tx_fifo(xspi);
 
 		/* Start the transfer by not inhibiting the transmitter any
 		 * longer
@@ -282,11 +286,8 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 			       xspi->regs + XSPI_CR_OFFSET);
 
 		/* Read out all the data from the Rx FIFO */
-		sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
-		while ((sr & XSPI_SR_RX_EMPTY_MASK) == 0) {
+		while (n_words--)
 			xspi->rx_fn(xspi);
-			sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
-		}
 
 		/* See if there is more data to send */
 		if (xspi->remaining_bytes <= 0)
-- 
2.1.4

