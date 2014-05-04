Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaEDGdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 02:33:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36013 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaEDGdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 02:33:17 -0400
From: Qipan Li <swingboard@gmail.com>
To: broonie@kernel.org, baohua@kernel.org
Cc: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH v2 2/2] spi: sirf: decrease the interrupt count and latency of PIO mode 
Date: Sun,  4 May 2014 14:32:36 +0800
Message-Id: <1399185156-521-1-git-send-email-swingboard@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qipan Li <Qipan.Li@csr.com>

current PIO tranfer method be described as follows:
1. fill as much as bytes but no more than 256 bytes(fifo size)
2. enable oflow/uflow/txfifo_empty interrupt
3. isr process 3 interrupt signal, do complete works.
4. after isr done, if there are left bytes go into 1 else go into 5
5. transfer end

by current PIO transfer method:
1. reduce interrupt counts in spi interrupt line.
2. reduce interrupt latency because no do data fill/fetch in isr.

Signed-off-by: Qipan Li <Qipan.Li@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
-v2
use do {} while statement to replace for(;;) statement pointed by Mark Brown
 drivers/spi/spi-sirf.c | 101 ++++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 47 deletions(-)

diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index 2d23899..95ac276 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -86,6 +86,7 @@
 #define SIRFSOC_SPI_TX_DONE		BIT(1)
 #define SIRFSOC_SPI_RX_OFLOW		BIT(2)
 #define SIRFSOC_SPI_TX_UFLOW		BIT(3)
+#define SIRFSOC_SPI_RX_IO_DMA		BIT(4)
 #define SIRFSOC_SPI_RX_FIFO_FULL	BIT(6)
 #define SIRFSOC_SPI_TXFIFO_EMPTY	BIT(7)
 #define SIRFSOC_SPI_RXFIFO_THD_REACH	BIT(8)
@@ -265,41 +266,34 @@ static irqreturn_t spi_sirfsoc_irq(int irq, void *dev_id)
 {
 	struct sirfsoc_spi *sspi = dev_id;
 	u32 spi_stat = readl(sspi->base + SIRFSOC_SPI_INT_STATUS);
-
-	writel(spi_stat, sspi->base + SIRFSOC_SPI_INT_STATUS);
-
 	if (sspi->tx_by_cmd && (spi_stat & SIRFSOC_SPI_FRM_END)) {
 		complete(&sspi->tx_done);
 		writel(0x0, sspi->base + SIRFSOC_SPI_INT_EN);
+		writel(SIRFSOC_SPI_INT_MASK_ALL,
+				sspi->base + SIRFSOC_SPI_INT_STATUS);
 		return IRQ_HANDLED;
 	}
 
 	/* Error Conditions */
 	if (spi_stat & SIRFSOC_SPI_RX_OFLOW ||
 			spi_stat & SIRFSOC_SPI_TX_UFLOW) {
+		complete(&sspi->tx_done);
 		complete(&sspi->rx_done);
 		writel(0x0, sspi->base + SIRFSOC_SPI_INT_EN);
+		writel(SIRFSOC_SPI_INT_MASK_ALL,
+				sspi->base + SIRFSOC_SPI_INT_STATUS);
+		return IRQ_HANDLED;
 	}
+	if (spi_stat & SIRFSOC_SPI_TXFIFO_EMPTY)
+		complete(&sspi->tx_done);
+	while (!(readl(sspi->base + SIRFSOC_SPI_INT_STATUS) &
+		SIRFSOC_SPI_RX_IO_DMA))
+		cpu_relax();
+	complete(&sspi->rx_done);
+	writel(0x0, sspi->base + SIRFSOC_SPI_INT_EN);
+	writel(SIRFSOC_SPI_INT_MASK_ALL,
+			sspi->base + SIRFSOC_SPI_INT_STATUS);
 
-	if (spi_stat & (SIRFSOC_SPI_FRM_END
-			| SIRFSOC_SPI_RXFIFO_THD_REACH))
-		while (!((readl(sspi->base + SIRFSOC_SPI_RXFIFO_STATUS)
-				& SIRFSOC_SPI_FIFO_EMPTY)) &&
-				sspi->left_rx_word)
-			sspi->rx_word(sspi);
-
-	if (spi_stat & (SIRFSOC_SPI_TXFIFO_EMPTY |
-			SIRFSOC_SPI_TXFIFO_THD_REACH))
-		while (!((readl(sspi->base + SIRFSOC_SPI_TXFIFO_STATUS)
-				& SIRFSOC_SPI_FIFO_FULL)) &&
-				sspi->left_tx_word)
-			sspi->tx_word(sspi);
-
-	/* Received all words */
-	if ((sspi->left_rx_word == 0) && (sspi->left_tx_word == 0)) {
-		complete(&sspi->rx_done);
-		writel(0x0, sspi->base + SIRFSOC_SPI_INT_EN);
-	}
 	return IRQ_HANDLED;
 }
 
@@ -420,32 +414,45 @@ static void spi_sirfsoc_pio_transfer(struct spi_device *spi,
 	int timeout = t->len * 10;
 
 	sspi = spi_master_get_devdata(spi->master);
-	writel(SIRFSOC_SPI_FIFO_RESET, sspi->base + SIRFSOC_SPI_RXFIFO_OP);
-	writel(SIRFSOC_SPI_FIFO_RESET, sspi->base + SIRFSOC_SPI_TXFIFO_OP);
-	writel(SIRFSOC_SPI_FIFO_START, sspi->base + SIRFSOC_SPI_RXFIFO_OP);
-	writel(SIRFSOC_SPI_FIFO_START, sspi->base + SIRFSOC_SPI_TXFIFO_OP);
-	writel(0, sspi->base + SIRFSOC_SPI_INT_EN);
-	writel(SIRFSOC_SPI_INT_MASK_ALL, sspi->base + SIRFSOC_SPI_INT_STATUS);
-	writel(readl(sspi->base + SIRFSOC_SPI_CTRL) | SIRFSOC_SPI_MUL_DAT_MODE |
-		SIRFSOC_SPI_ENA_AUTO_CLR, sspi->base + SIRFSOC_SPI_CTRL);
-	writel(sspi->left_tx_word - 1,
-			sspi->base + SIRFSOC_SPI_TX_DMA_IO_LEN);
-	writel(sspi->left_rx_word - 1,
-			sspi->base + SIRFSOC_SPI_RX_DMA_IO_LEN);
-	sspi->tx_word(sspi);
-	writel(SIRFSOC_SPI_TXFIFO_EMPTY_INT_EN | SIRFSOC_SPI_TX_UFLOW_INT_EN |
-		SIRFSOC_SPI_RX_OFLOW_INT_EN | SIRFSOC_SPI_RXFIFO_THD_INT_EN |
-		SIRFSOC_SPI_TXFIFO_THD_INT_EN | SIRFSOC_SPI_FRM_END_INT_EN|
-		SIRFSOC_SPI_RXFIFO_FULL_INT_EN,
-		sspi->base + SIRFSOC_SPI_INT_EN);
-	writel(SIRFSOC_SPI_RX_EN | SIRFSOC_SPI_TX_EN,
+	do {
+		writel(SIRFSOC_SPI_FIFO_RESET,
+			sspi->base + SIRFSOC_SPI_RXFIFO_OP);
+		writel(SIRFSOC_SPI_FIFO_RESET,
+			sspi->base + SIRFSOC_SPI_TXFIFO_OP);
+		writel(SIRFSOC_SPI_FIFO_START,
+			sspi->base + SIRFSOC_SPI_RXFIFO_OP);
+		writel(SIRFSOC_SPI_FIFO_START,
+			sspi->base + SIRFSOC_SPI_TXFIFO_OP);
+		writel(0, sspi->base + SIRFSOC_SPI_INT_EN);
+		writel(SIRFSOC_SPI_INT_MASK_ALL,
+			sspi->base + SIRFSOC_SPI_INT_STATUS);
+		writel(readl(sspi->base + SIRFSOC_SPI_CTRL) |
+			SIRFSOC_SPI_MUL_DAT_MODE | SIRFSOC_SPI_ENA_AUTO_CLR,
+			sspi->base + SIRFSOC_SPI_CTRL);
+		writel(min(sspi->left_tx_word, (u32)(256 / sspi->word_width))
+				- 1, sspi->base + SIRFSOC_SPI_TX_DMA_IO_LEN);
+		writel(min(sspi->left_rx_word, (u32)(256 / sspi->word_width))
+				- 1, sspi->base + SIRFSOC_SPI_RX_DMA_IO_LEN);
+		while (!((readl(sspi->base + SIRFSOC_SPI_TXFIFO_STATUS)
+			& SIRFSOC_SPI_FIFO_FULL)) && sspi->left_tx_word)
+			sspi->tx_word(sspi);
+		writel(SIRFSOC_SPI_TXFIFO_EMPTY_INT_EN |
+			SIRFSOC_SPI_TX_UFLOW_INT_EN |
+			SIRFSOC_SPI_RX_OFLOW_INT_EN,
+			sspi->base + SIRFSOC_SPI_INT_EN);
+		writel(SIRFSOC_SPI_RX_EN | SIRFSOC_SPI_TX_EN,
 			sspi->base + SIRFSOC_SPI_TX_RX_EN);
-	if (wait_for_completion_timeout(&sspi->rx_done, timeout) == 0)
-		dev_err(&spi->dev, "transfer timeout\n");
-	writel(0, sspi->base + SIRFSOC_SPI_RXFIFO_OP);
-	writel(0, sspi->base + SIRFSOC_SPI_TXFIFO_OP);
-	writel(0, sspi->base + SIRFSOC_SPI_TX_RX_EN);
-	writel(0, sspi->base + SIRFSOC_SPI_INT_EN);
+		if (!wait_for_completion_timeout(&sspi->tx_done, timeout) ||
+			!wait_for_completion_timeout(&sspi->rx_done, timeout)) {
+			dev_err(&spi->dev, "transfer timeout\n");
+			break;
+		}
+		while (!((readl(sspi->base + SIRFSOC_SPI_RXFIFO_STATUS)
+			& SIRFSOC_SPI_FIFO_EMPTY)) && sspi->left_rx_word)
+			sspi->rx_word(sspi);
+		writel(0, sspi->base + SIRFSOC_SPI_RXFIFO_OP);
+		writel(0, sspi->base + SIRFSOC_SPI_TXFIFO_OP);
+	} while (sspi->left_tx_word != 0 || sspi->left_rx_word != 0);
 }
 
 static int spi_sirfsoc_transfer(struct spi_device *spi, struct spi_transfer *t)
-- 
1.9.1

