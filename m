Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbbA2OvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:51:19 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51170 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbA2OvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:51:17 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] spi/xilinx: Cast ioread32/iowrite32 function pointers
Date: Thu, 29 Jan 2015 15:51:13 +0100
Message-Id: <1422543073-21895-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO functions prototypes may have different argument qualifiers
on different architectures.

This patch cast the assignment of the function, to match the one defined
at iomap.h.

Fixes: 99082eab63449f9d spi/xilinx: Remove iowrite/ioread wrappers
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 0e8962c..418e730 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -91,7 +91,7 @@ struct xilinx_spi {
 	u8 bytes_per_word;
 	int buffer_size;	/* buffer size in words */
 	u32 cs_inactive;	/* Level of the CS pins when inactive*/
-	unsigned int (*read_fn)(void __iomem *);
+	u32 (*read_fn)(void __iomem *);
 	void (*write_fn)(u32, void __iomem *);
 };
 
@@ -378,15 +378,15 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 	 * Setup little endian helper functions first and try to use them
 	 * and check if bit was correctly setup or not.
 	 */
-	xspi->read_fn = ioread32;
-	xspi->write_fn = iowrite32;
+	xspi->read_fn = (u32 (*)(void __iomem *)) ioread32;
+	xspi->write_fn = (void (*)(u32, void __iomem *)) iowrite32;
 
 	xspi->write_fn(XSPI_CR_LOOP, xspi->regs + XSPI_CR_OFFSET);
 	tmp = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
 	tmp &= XSPI_CR_LOOP;
 	if (tmp != XSPI_CR_LOOP) {
-		xspi->read_fn = ioread32be;
-		xspi->write_fn = iowrite32be;
+		xspi->read_fn = (u32 (*)(void __iomem *)) ioread32be;
+		xspi->write_fn = (void (*)(u32, void __iomem *)) iowrite32be;
 	}
 
 	master->bits_per_word_mask = SPI_BPW_MASK(bits_per_word);
-- 
2.1.4

