Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbbAWQMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:12:35 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34848 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbbAWQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:13 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 12/18] spi/xilinx: Make spi_tx and spi_rx simmetric
Date: Fri, 23 Jan 2015 17:08:44 +0100
Message-Id: <1422029330-10971-13-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi_rx handles the case where the buffer is null. Nevertheless spi_tx
did not handle it, and was handled by the caller function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 6b6c658..514ad01 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -116,6 +116,10 @@ static unsigned int xspi_read32_be(void __iomem *addr)
 
 static void xilinx_spi_tx(struct xilinx_spi *xspi)
 {
+	if (!xspi->tx_ptr) {
+		xspi->write_fn(0, xspi->regs + XSPI_TXD_OFFSET);
+		return;
+	}
 	xspi->write_fn(*(u32 *)(xspi->tx_ptr), xspi->regs + XSPI_TXD_OFFSET);
 	xspi->tx_ptr += xspi->bits_per_word/8;
 }
@@ -230,10 +234,7 @@ static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi, int n_words)
 	xspi->remaining_bytes -= n_words * xspi->bits_per_word / 8;
 
 	while (n_words--)
-		if (xspi->tx_ptr)
-			xilinx_spi_tx(xspi);
-		else
-			xspi->write_fn(0, xspi->regs + XSPI_TXD_OFFSET);
+		xilinx_spi_tx(xspi);
 	return;
 }
 
-- 
2.1.4

