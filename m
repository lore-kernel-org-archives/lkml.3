Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbbAWQJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:09:08 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54827 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbbAWQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:03 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 05/18] spi/xilinx: Leave the IRQ always enabled.
Date: Fri, 23 Jan 2015 17:08:37 +0100
Message-Id: <1422029330-10971-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of enabling the IRQ and disabling it for every transaction.

Specially the small transactions (1,2 words) benefit from removing 3 bus
accesses.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 17480a2..408a842 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -167,8 +167,11 @@ static void xspi_init_hw(struct xilinx_spi *xspi)
 	/* Reset the SPI device */
 	xspi->write_fn(XIPIF_V123B_RESET_MASK,
 		regs_base + XIPIF_V123B_RESETR_OFFSET);
-	/* Disable all the interrupts just in case */
-	xspi->write_fn(0, regs_base + XIPIF_V123B_IIER_OFFSET);
+	/* Enable the transmit empty interrupt, which we use to determine
+	 * progress on the transmission.
+	 */
+	xspi->write_fn(XSPI_INTR_TX_EMPTY,
+			regs_base + XIPIF_V123B_IIER_OFFSET);
 	/* Enable the global IPIF interrupt */
 	xspi->write_fn(XIPIF_V123B_GINTR_ENABLE,
 		regs_base + XIPIF_V123B_DGIER_OFFSET);
@@ -237,7 +240,6 @@ static void xilinx_spi_fill_tx_fifo(struct xilinx_spi *xspi, int n_words)
 static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 {
 	struct xilinx_spi *xspi = spi_master_get_devdata(spi->master);
-	u32 ipif_ier;
 
 	/* We get here with transmitter inhibited */
 
@@ -246,14 +248,6 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 	xspi->remaining_bytes = t->len;
 	reinit_completion(&xspi->done);
 
-
-	/* Enable the transmit empty interrupt, which we use to determine
-	 * progress on the transmission.
-	 */
-	ipif_ier = xspi->read_fn(xspi->regs + XIPIF_V123B_IIER_OFFSET);
-	xspi->write_fn(ipif_ier | XSPI_INTR_TX_EMPTY,
-		xspi->regs + XIPIF_V123B_IIER_OFFSET);
-
 	for (;;) {
 		u16 cr;
 		int n_words;
@@ -290,9 +284,6 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 			break;
 	}
 
-	/* Disable the transmit empty interrupt */
-	xspi->write_fn(ipif_ier, xspi->regs + XIPIF_V123B_IIER_OFFSET);
-
 	return t->len - xspi->remaining_bytes;
 }
 
-- 
2.1.4

