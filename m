Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab3LHPf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:35:56 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49261 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab3LHPfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:35:25 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/3] spi: tegra20-slink: use u32 for 32-bit register values
Date: Sun,  8 Dec 2013 16:35:10 +0100
Message-Id: <1386516911-26388-3-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386516911-26388-1-git-send-email-mina86@mina86.com>
References: <1385745164-10534-1-git-send-email-mpn@google.com>
 <1386516911-26388-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously used “unsigned long” may lead to confusion should the code
be compiled for 64-bit machine.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/spi/spi-tegra20-slink.c | 97 +++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 57 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index e66715b..0dcd6f9 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -196,7 +196,7 @@ struct tegra_slink_data {
 	u32					rx_status;
 	u32					status_reg;
 	bool					is_packed;
-	unsigned long				packed_size;
+	u32					packed_size;
 
 	u32					command_reg;
 	u32					command2_reg;
@@ -220,14 +220,14 @@ struct tegra_slink_data {
 static int tegra_slink_runtime_suspend(struct device *dev);
 static int tegra_slink_runtime_resume(struct device *dev);
 
-static inline unsigned long tegra_slink_readl(struct tegra_slink_data *tspi,
+static inline u32 tegra_slink_readl(struct tegra_slink_data *tspi,
 		unsigned long reg)
 {
 	return readl(tspi->base + reg);
 }
 
 static inline void tegra_slink_writel(struct tegra_slink_data *tspi,
-		unsigned long val, unsigned long reg)
+		u32 val, unsigned long reg)
 {
 	writel(val, tspi->base + reg);
 
@@ -238,38 +238,30 @@ static inline void tegra_slink_writel(struct tegra_slink_data *tspi,
 
 static void tegra_slink_clear_status(struct tegra_slink_data *tspi)
 {
-	unsigned long val;
-	unsigned long val_write = 0;
+	u32 val_write;
 
-	val = tegra_slink_readl(tspi, SLINK_STATUS);
+	tegra_slink_readl(tspi, SLINK_STATUS);
 
 	/* Write 1 to clear status register */
 	val_write = SLINK_RDY | SLINK_FIFO_ERROR;
 	tegra_slink_writel(tspi, val_write, SLINK_STATUS);
 }
 
-static unsigned long tegra_slink_get_packed_size(struct tegra_slink_data *tspi,
+static u32 tegra_slink_get_packed_size(struct tegra_slink_data *tspi,
 				  struct spi_transfer *t)
 {
-	unsigned long val;
-
 	switch (tspi->bytes_per_word) {
 	case 0:
-		val = SLINK_PACK_SIZE_4;
-		break;
+		return SLINK_PACK_SIZE_4;
 	case 1:
-		val = SLINK_PACK_SIZE_8;
-		break;
+		return SLINK_PACK_SIZE_8;
 	case 2:
-		val = SLINK_PACK_SIZE_16;
-		break;
+		return SLINK_PACK_SIZE_16;
 	case 4:
-		val = SLINK_PACK_SIZE_32;
-		break;
+		return SLINK_PACK_SIZE_32;
 	default:
-		val = 0;
+		return 0;
 	}
-	return val;
 }
 
 static unsigned tegra_slink_calculate_curr_xfer_param(
@@ -312,10 +304,9 @@ static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(
 {
 	unsigned nbytes;
 	unsigned tx_empty_count;
-	unsigned long fifo_status;
+	u32 fifo_status;
 	unsigned max_n_32bit;
 	unsigned i, count;
-	unsigned long x;
 	unsigned int written_words;
 	unsigned fifo_words_left;
 	u8 *tx_buf = (u8 *)t->tx_buf + tspi->cur_tx_pos;
@@ -329,9 +320,9 @@ static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(
 		nbytes = written_words * tspi->bytes_per_word;
 		max_n_32bit = DIV_ROUND_UP(nbytes, 4);
 		for (count = 0; count < max_n_32bit; count++) {
-			x = 0;
+			u32 x = 0;
 			for (i = 0; (i < 4) && nbytes; i++, nbytes--)
-				x |= (*tx_buf++) << (i*8);
+				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
 		}
 	} else {
@@ -339,10 +330,10 @@ static unsigned tegra_slink_fill_tx_fifo_from_client_txbuf(
 		written_words = max_n_32bit;
 		nbytes = written_words * tspi->bytes_per_word;
 		for (count = 0; count < max_n_32bit; count++) {
-			x = 0;
+			u32 x = 0;
 			for (i = 0; nbytes && (i < tspi->bytes_per_word);
 							i++, nbytes--)
-				x |= ((*tx_buf++) << i*8);
+				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_slink_writel(tspi, x, SLINK_TX_FIFO);
 		}
 	}
@@ -354,9 +345,8 @@ static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(
 		struct tegra_slink_data *tspi, struct spi_transfer *t)
 {
 	unsigned rx_full_count;
-	unsigned long fifo_status;
+	u32 fifo_status;
 	unsigned i, count;
-	unsigned long x;
 	unsigned int read_words = 0;
 	unsigned len;
 	u8 *rx_buf = (u8 *)t->rx_buf + tspi->cur_rx_pos;
@@ -366,7 +356,7 @@ static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(
 	if (tspi->is_packed) {
 		len = tspi->curr_dma_words * tspi->bytes_per_word;
 		for (count = 0; count < rx_full_count; count++) {
-			x = tegra_slink_readl(tspi, SLINK_RX_FIFO);
+			u32 x = tegra_slink_readl(tspi, SLINK_RX_FIFO);
 			for (i = 0; len && (i < 4); i++, len--)
 				*rx_buf++ = (x >> i*8) & 0xFF;
 		}
@@ -374,7 +364,7 @@ static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(
 		read_words += tspi->curr_dma_words;
 	} else {
 		for (count = 0; count < rx_full_count; count++) {
-			x = tegra_slink_readl(tspi, SLINK_RX_FIFO);
+			u32 x = tegra_slink_readl(tspi, SLINK_RX_FIFO);
 			for (i = 0; (i < tspi->bytes_per_word); i++)
 				*rx_buf++ = (x >> (i*8)) & 0xFF;
 		}
@@ -387,27 +377,24 @@ static unsigned int tegra_slink_read_rx_fifo_to_client_rxbuf(
 static void tegra_slink_copy_client_txbuf_to_spi_txbuf(
 		struct tegra_slink_data *tspi, struct spi_transfer *t)
 {
-	unsigned len;
-
 	/* Make the dma buffer to read by cpu */
 	dma_sync_single_for_cpu(tspi->dev, tspi->tx_dma_phys,
 				tspi->dma_buf_size, DMA_TO_DEVICE);
 
 	if (tspi->is_packed) {
-		len = tspi->curr_dma_words * tspi->bytes_per_word;
+		unsigned len = tspi->curr_dma_words * tspi->bytes_per_word;
 		memcpy(tspi->tx_dma_buf, t->tx_buf + tspi->cur_pos, len);
 	} else {
 		unsigned int i;
 		unsigned int count;
 		u8 *tx_buf = (u8 *)t->tx_buf + tspi->cur_tx_pos;
 		unsigned consume = tspi->curr_dma_words * tspi->bytes_per_word;
-		unsigned int x;
 
 		for (count = 0; count < tspi->curr_dma_words; count++) {
-			x = 0;
+			u32 x = 0;
 			for (i = 0; consume && (i < tspi->bytes_per_word);
 							i++, consume--)
-				x |= ((*tx_buf++) << i * 8);
+				x |= (u32)(*tx_buf++) << (i * 8);
 			tspi->tx_dma_buf[count] = x;
 		}
 	}
@@ -434,14 +421,10 @@ static void tegra_slink_copy_spi_rxbuf_to_client_rxbuf(
 		unsigned int i;
 		unsigned int count;
 		unsigned char *rx_buf = t->rx_buf + tspi->cur_rx_pos;
-		unsigned int x;
-		unsigned int rx_mask, bits_per_word;
+		u32 rx_mask = ((u32)1 << t->bits_per_word) - 1;
 
-		bits_per_word = t->bits_per_word;
-		rx_mask = (1 << bits_per_word) - 1;
 		for (count = 0; count < tspi->curr_dma_words; count++) {
-			x = tspi->rx_dma_buf[count];
-			x &= rx_mask;
+			u32 x = tspi->rx_dma_buf[count] & rx_mask;
 			for (i = 0; (i < tspi->bytes_per_word); i++)
 				*rx_buf++ = (x >> (i*8)) & 0xFF;
 		}
@@ -501,17 +484,16 @@ static int tegra_slink_start_rx_dma(struct tegra_slink_data *tspi, int len)
 static int tegra_slink_start_dma_based_transfer(
 		struct tegra_slink_data *tspi, struct spi_transfer *t)
 {
-	unsigned long val;
-	unsigned long test_val;
+	u32 val;
 	unsigned int len;
 	int ret = 0;
-	unsigned long status;
+	u32 status;
 
 	/* Make sure that Rx and Tx fifo are empty */
 	status = tegra_slink_readl(tspi, SLINK_STATUS);
 	if ((status & SLINK_FIFO_EMPTY) != SLINK_FIFO_EMPTY) {
-		dev_err(tspi->dev,
-			"Rx/Tx fifo are not empty status 0x%08lx\n", status);
+		dev_err(tspi->dev, "Rx/Tx fifo are not empty status 0x%08x\n",
+			(unsigned)status);
 		return -EIO;
 	}
 
@@ -551,9 +533,9 @@ static int tegra_slink_start_dma_based_transfer(
 		}
 
 		/* Wait for tx fifo to be fill before starting slink */
-		test_val = tegra_slink_readl(tspi, SLINK_STATUS);
-		while (!(test_val & SLINK_TX_FULL))
-			test_val = tegra_slink_readl(tspi, SLINK_STATUS);
+		status = tegra_slink_readl(tspi, SLINK_STATUS);
+		while (!(status & SLINK_TX_FULL))
+			status = tegra_slink_readl(tspi, SLINK_STATUS);
 	}
 
 	if (tspi->cur_direction & DATA_DIR_RX) {
@@ -587,7 +569,7 @@ static int tegra_slink_start_dma_based_transfer(
 static int tegra_slink_start_cpu_based_transfer(
 		struct tegra_slink_data *tspi, struct spi_transfer *t)
 {
-	unsigned long val;
+	u32 val;
 	unsigned cur_words;
 
 	val = tspi->packed_size;
@@ -714,8 +696,8 @@ static int tegra_slink_start_transfer_one(struct spi_device *spi,
 	u8 bits_per_word;
 	unsigned total_fifo_words;
 	int ret;
-	unsigned long command;
-	unsigned long command2;
+	u32 command;
+	u32 command2;
 
 	bits_per_word = t->bits_per_word;
 	speed = t->speed_hz;
@@ -762,17 +744,18 @@ static int tegra_slink_start_transfer_one(struct spi_device *spi,
 
 static int tegra_slink_setup(struct spi_device *spi)
 {
-	struct tegra_slink_data *tspi = spi_master_get_devdata(spi->master);
-	unsigned long val;
-	unsigned long flags;
-	int ret;
-	unsigned int cs_pol_bit[MAX_CHIP_SELECT] = {
+	static const u32 cs_pol_bit[MAX_CHIP_SELECT] = {
 			SLINK_CS_POLARITY,
 			SLINK_CS_POLARITY1,
 			SLINK_CS_POLARITY2,
 			SLINK_CS_POLARITY3,
 	};
 
+	struct tegra_slink_data *tspi = spi_master_get_devdata(spi->master);
+	u32 val;
+	unsigned long flags;
+	int ret;
+
 	dev_dbg(&spi->dev, "setup %d bpw, %scpol, %scpha, %dHz\n",
 		spi->bits_per_word,
 		spi->mode & SPI_CPOL ? "" : "~",
-- 
1.8.4

