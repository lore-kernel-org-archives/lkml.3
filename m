Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaLVTf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:35:26 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39917 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbaLVTfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:35:21 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V2 2/2] spi: img-spfi: Select FIFO based on transfer length
Date: Mon, 22 Dec 2014 11:35:16 -0800
Message-Id: <1419276916-28433-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1419276916-28433-1-git-send-email-abrestic@chromium.org>
References: <1419276916-28433-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the 32-bit FIFO is deeper (64 bytes) than the 8-bit FIFO (16 bytes),
use the 32-bit FIFO when there are at least 32 bits remaining to be
transferred in PIO mode or when the transfer length is 32-bit aligned
in DMA mode.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/spi/spi-img-spfi.c | 49 ++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index aad6683..c01567d 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -160,16 +160,16 @@ static unsigned int spfi_pio_write32(struct img_spfi *spfi, const u32 *buf,
 	unsigned int count = 0;
 	u32 status;
 
-	while (count < max) {
+	while (count < max / 4) {
 		spfi_writel(spfi, SPFI_INTERRUPT_SDFUL, SPFI_INTERRUPT_CLEAR);
 		status = spfi_readl(spfi, SPFI_INTERRUPT_STATUS);
 		if (status & SPFI_INTERRUPT_SDFUL)
 			break;
-		spfi_writel(spfi, buf[count / 4], SPFI_TX_32BIT_VALID_DATA);
-		count += 4;
+		spfi_writel(spfi, buf[count], SPFI_TX_32BIT_VALID_DATA);
+		count++;
 	}
 
-	return count;
+	return count * 4;
 }
 
 static unsigned int spfi_pio_write8(struct img_spfi *spfi, const u8 *buf,
@@ -196,17 +196,17 @@ static unsigned int spfi_pio_read32(struct img_spfi *spfi, u32 *buf,
 	unsigned int count = 0;
 	u32 status;
 
-	while (count < max) {
+	while (count < max / 4) {
 		spfi_writel(spfi, SPFI_INTERRUPT_GDEX32BIT,
 			    SPFI_INTERRUPT_CLEAR);
 		status = spfi_readl(spfi, SPFI_INTERRUPT_STATUS);
 		if (!(status & SPFI_INTERRUPT_GDEX32BIT))
 			break;
-		buf[count / 4] = spfi_readl(spfi, SPFI_RX_32BIT_VALID_DATA);
-		count += 4;
+		buf[count] = spfi_readl(spfi, SPFI_RX_32BIT_VALID_DATA);
+		count++;
 	}
 
-	return count;
+	return count * 4;
 }
 
 static unsigned int spfi_pio_read8(struct img_spfi *spfi, u8 *buf,
@@ -251,17 +251,15 @@ static int img_spfi_start_pio(struct spi_master *master,
 	       time_before(jiffies, timeout)) {
 		unsigned int tx_count, rx_count;
 
-		switch (xfer->bits_per_word) {
-		case 32:
+		if (tx_bytes >= 4)
 			tx_count = spfi_pio_write32(spfi, tx_buf, tx_bytes);
-			rx_count = spfi_pio_read32(spfi, rx_buf, rx_bytes);
-			break;
-		case 8:
-		default:
+		else
 			tx_count = spfi_pio_write8(spfi, tx_buf, tx_bytes);
+
+		if (rx_bytes >= 4)
+			rx_count = spfi_pio_read32(spfi, rx_buf, rx_bytes);
+		else
 			rx_count = spfi_pio_read8(spfi, rx_buf, rx_bytes);
-			break;
-		}
 
 		tx_buf += tx_count;
 		rx_buf += rx_count;
@@ -331,14 +329,11 @@ static int img_spfi_start_dma(struct spi_master *master,
 
 	if (xfer->rx_buf) {
 		rxconf.direction = DMA_DEV_TO_MEM;
-		switch (xfer->bits_per_word) {
-		case 32:
+		if (xfer->len % 4 == 0) {
 			rxconf.src_addr = spfi->phys + SPFI_RX_32BIT_VALID_DATA;
 			rxconf.src_addr_width = 4;
 			rxconf.src_maxburst = 4;
-			break;
-		case 8:
-		default:
+		} else {
 			rxconf.src_addr = spfi->phys + SPFI_RX_8BIT_VALID_DATA;
 			rxconf.src_addr_width = 1;
 			rxconf.src_maxburst = 4;
@@ -358,18 +353,14 @@ static int img_spfi_start_dma(struct spi_master *master,
 
 	if (xfer->tx_buf) {
 		txconf.direction = DMA_MEM_TO_DEV;
-		switch (xfer->bits_per_word) {
-		case 32:
+		if (xfer->len % 4 == 0) {
 			txconf.dst_addr = spfi->phys + SPFI_TX_32BIT_VALID_DATA;
 			txconf.dst_addr_width = 4;
 			txconf.dst_maxburst = 4;
-			break;
-		case 8:
-		default:
+		} else {
 			txconf.dst_addr = spfi->phys + SPFI_TX_8BIT_VALID_DATA;
 			txconf.dst_addr_width = 1;
 			txconf.dst_maxburst = 4;
-			break;
 		}
 		dmaengine_slave_config(spfi->tx_ch, &txconf);
 
@@ -508,9 +499,7 @@ static void img_spfi_set_cs(struct spi_device *spi, bool enable)
 static bool img_spfi_can_dma(struct spi_master *master, struct spi_device *spi,
 			     struct spi_transfer *xfer)
 {
-	if (xfer->bits_per_word == 8 && xfer->len > SPFI_8BIT_FIFO_SIZE)
-		return true;
-	if (xfer->bits_per_word == 32 && xfer->len > SPFI_32BIT_FIFO_SIZE)
+	if (xfer->len > SPFI_32BIT_FIFO_SIZE)
 		return true;
 	return false;
 }
-- 
2.2.0.rc0.207.ga3a616c

