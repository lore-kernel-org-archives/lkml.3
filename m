Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbbAWQJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:09:22 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42275 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbbAWQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:17 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 15/18] spi/xilinx: Remove iowrite/ioread wrappers
Date: Fri, 23 Jan 2015 17:08:47 +0100
Message-Id: <1422029330-10971-16-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save a stack level and cleanup code.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 5d3503a..704613c 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -94,26 +94,6 @@ struct xilinx_spi {
 	void (*write_fn)(u32, void __iomem *);
 };
 
-static void xspi_write32(u32 val, void __iomem *addr)
-{
-	iowrite32(val, addr);
-}
-
-static unsigned int xspi_read32(void __iomem *addr)
-{
-	return ioread32(addr);
-}
-
-static void xspi_write32_be(u32 val, void __iomem *addr)
-{
-	iowrite32be(val, addr);
-}
-
-static unsigned int xspi_read32_be(void __iomem *addr)
-{
-	return ioread32be(addr);
-}
-
 static void xilinx_spi_tx(struct xilinx_spi *xspi)
 {
 	if (!xspi->tx_ptr) {
@@ -391,15 +371,15 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	 * Setup little endian helper functions first and try to use them
 	 * and check if bit was correctly setup or not.
 	 */
-	xspi->read_fn = xspi_read32;
-	xspi->write_fn = xspi_write32;
+	xspi->read_fn = ioread32;
+	xspi->write_fn = iowrite32;
 
 	xspi->write_fn(XSPI_CR_LOOP, xspi->regs + XSPI_CR_OFFSET);
 	tmp = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
 	tmp &= XSPI_CR_LOOP;
 	if (tmp != XSPI_CR_LOOP) {
-		xspi->read_fn = xspi_read32_be;
-		xspi->write_fn = xspi_write32_be;
+		xspi->read_fn = ioread32be;
+		xspi->write_fn = iowrite32be;
 	}
 
 	master->bits_per_word_mask = SPI_BPW_MASK(bits_per_word);
-- 
2.1.4

