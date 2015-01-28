Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbbA2BYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:46 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57384 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbbA2BYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:43 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 05/15] spi/xilinx: Support cores with no interrupt
Date: Wed, 28 Jan 2015 13:23:44 +0100
Message-Id: <1422447834-23116-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core can run in polling mode. In fact, the performance of the core
is similar (or even better), due to the fact most of the spi
transactions are just a couple of bytes and there is one irq per
transactions.

When an mtd device is connected via spi, reading 8MB of data produces
more than 80K interrupts (with irq disabling, context swith....)

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 12b311e..f21e857 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -173,8 +173,11 @@ static void xspi_init_hw(struct xilinx_spi *xspi)
 	xspi->write_fn(XSPI_INTR_TX_EMPTY,
 			regs_base + XIPIF_V123B_IIER_OFFSET);
 	/* Enable the global IPIF interrupt */
-	xspi->write_fn(XIPIF_V123B_GINTR_ENABLE,
-		regs_base + XIPIF_V123B_DGIER_OFFSET);
+	if (xspi->irq >= 0)
+		xspi->write_fn(XIPIF_V123B_GINTR_ENABLE,
+			regs_base + XIPIF_V123B_DGIER_OFFSET);
+	else
+		xspi->write_fn(0, regs_base + XIPIF_V123B_DGIER_OFFSET);
 	/* Deselect the slave on the SPI bus */
 	xspi->write_fn(0xffff, regs_base + XSPI_SSR_OFFSET);
 	/* Disable the transmitter, enable Manual Slave Select Assertion,
@@ -264,7 +267,12 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 							~XSPI_CR_TRANS_INHIBIT;
 		xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
 
-		wait_for_completion(&xspi->done);
+		if (xspi->irq >= 0)
+			wait_for_completion(&xspi->done);
+		else
+			while (!(xspi->read_fn(xspi->regs + XSPI_SR_OFFSET) &
+						XSPI_SR_TX_EMPTY_MASK))
+				;
 
 		/* A transmit has just completed. Process received data and
 		 * check for more data to transmit. Always inhibit the
@@ -419,20 +427,17 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 
 	xspi->buffer_size = xilinx_spi_find_buffer_size(xspi);
 
-	/* SPI controller initializations */
-	xspi_init_hw(xspi);
-
 	xspi->irq = platform_get_irq(pdev, 0);
-	if (xspi->irq < 0) {
-		ret = xspi->irq;
-		goto put_master;
+	if (xspi->irq >= 0) {
+		/* Register for SPI Interrupt */
+		ret = devm_request_irq(&pdev->dev, xspi->irq, xilinx_spi_irq, 0,
+				dev_name(&pdev->dev), xspi);
+		if (ret)
+			goto put_master;
 	}
 
-	/* Register for SPI Interrupt */
-	ret = devm_request_irq(&pdev->dev, xspi->irq, xilinx_spi_irq, 0,
-			       dev_name(&pdev->dev), xspi);
-	if (ret)
-		goto put_master;
+	/* SPI controller initializations */
+	xspi_init_hw(xspi);
 
 	ret = spi_bitbang_start(&xspi->bitbang);
 	if (ret) {
-- 
2.1.4

