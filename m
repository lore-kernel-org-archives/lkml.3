Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbbAWQJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:09:15 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:48793 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbAWQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:11 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 10/18] spi/xilinx: Support for spi mode CS_HIGH
Date: Fri, 23 Jan 2015 17:08:42 +0100
Message-Id: <1422029330-10971-11-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core controls the chip select lines individually.

By default, all the lines are consider active_low. After
spi_setup_transfer, it has its real value.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 62 +++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index a70cb91..29edf1b 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -89,6 +89,7 @@ struct xilinx_spi {
 	int remaining_bytes;	/* the number of bytes left to transfer */
 	u8 bits_per_word;
 	int buffer_size;	/* buffer size in words */
+	u32 cs_inactive;	/* Level of the CS pins when inactive*/
 	unsigned int (*read_fn)(void __iomem *);
 	void (*write_fn)(u32, void __iomem *);
 	void (*tx_fn)(struct xilinx_spi *);
@@ -194,33 +195,37 @@ static void xspi_init_hw(struct xilinx_spi *xspi)
 static void xilinx_spi_chipselect(struct spi_device *spi, int is_on)
 {
 	struct xilinx_spi *xspi = spi_master_get_devdata(spi->master);
+	u16 cr;
+	u32 cs;
 
 	if (is_on == BITBANG_CS_INACTIVE) {
 		/* Deselect the slave on the SPI bus */
-		xspi->write_fn(0xffff, xspi->regs + XSPI_SSR_OFFSET);
-	} else if (is_on == BITBANG_CS_ACTIVE) {
-		/* Set the SPI clock phase and polarity */
-		u16 cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET)
-			 & ~XSPI_CR_MODE_MASK;
-		if (spi->mode & SPI_CPHA)
-			cr |= XSPI_CR_CPHA;
-		if (spi->mode & SPI_CPOL)
-			cr |= XSPI_CR_CPOL;
-		if (spi->mode & SPI_LSB_FIRST)
-			cr |= XSPI_CR_LSB_FIRST;
-		if (spi->mode & SPI_LOOP)
-			cr |= XSPI_CR_LOOP;
-		xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
-
-		/* We do not check spi->max_speed_hz here as the SPI clock
-		 * frequency is not software programmable (the IP block design
-		 * parameter)
-		 */
-
-		/* Activate the chip select */
-		xspi->write_fn(~(0x0001 << spi->chip_select),
-			xspi->regs + XSPI_SSR_OFFSET);
+		xspi->write_fn(xspi->cs_inactive, xspi->regs + XSPI_SSR_OFFSET);
+		return;
 	}
+
+	/* Set the SPI clock phase and polarity */
+	cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET)	& ~XSPI_CR_MODE_MASK;
+	if (spi->mode & SPI_CPHA)
+		cr |= XSPI_CR_CPHA;
+	if (spi->mode & SPI_CPOL)
+		cr |= XSPI_CR_CPOL;
+	if (spi->mode & SPI_LSB_FIRST)
+		cr |= XSPI_CR_LSB_FIRST;
+	if (spi->mode & SPI_LOOP)
+		cr |= XSPI_CR_LOOP;
+	xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
+
+	/* We do not check spi->max_speed_hz here as the SPI clock
+	 * frequency is not software programmable (the IP block design
+	 * parameter)
+	 */
+
+	cs = xspi->cs_inactive;
+	cs ^= BIT(spi->chip_select);
+
+	/* Activate the chip select */
+	xspi->write_fn(cs, xspi->regs + XSPI_SSR_OFFSET);
 }
 
 /* spi_bitbang requires custom setup_transfer() to be defined if there is a
@@ -229,6 +234,13 @@ static void xilinx_spi_chipselect(struct spi_device *spi, int is_on)
 static int xilinx_spi_setup_transfer(struct spi_device *spi,
 		struct spi_transfer *t)
 {
+	struct xilinx_spi *xspi = spi_master_get_devdata(spi->master);
+
+	if (spi->mode & SPI_CS_HIGH)
+		xspi->cs_inactive &= ~BIT(spi->chip_select);
+	else
+		xspi->cs_inactive |= BIT(spi->chip_select);
+
 	return 0;
 }
 
@@ -369,9 +381,11 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	/* the spi->mode bits understood by this driver: */
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST | SPI_LOOP;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST | SPI_LOOP |
+			    SPI_CS_HIGH;
 
 	xspi = spi_master_get_devdata(master);
+	xspi->cs_inactive = 0xffffffff;
 	xspi->bitbang.master = master;
 	xspi->bitbang.chipselect = xilinx_spi_chipselect;
 	xspi->bitbang.setup_transfer = xilinx_spi_setup_transfer;
-- 
2.1.4

