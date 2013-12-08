Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab3LHPf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:35:58 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53471 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3LHPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:35:23 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 1/3] spi: tegra114: use u32 for 32-bit register values
Date: Sun,  8 Dec 2013 16:35:09 +0100
Message-Id: <1386516911-26388-2-git-send-email-mina86@mina86.com>
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

This commit also removes some unused fields of the tegra_spi_data
structure as well as removes duplicated #defines.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/spi/spi-tegra114.c | 98 ++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 64 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index aaecfb3..272ac47 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -54,11 +54,8 @@
 #define SPI_CS_SS_VAL				(1 << 20)
 #define SPI_CS_SW_HW				(1 << 21)
 /* SPI_CS_POL_INACTIVE bits are default high */
-#define SPI_CS_POL_INACTIVE			22
-#define SPI_CS_POL_INACTIVE_0			(1 << 22)
-#define SPI_CS_POL_INACTIVE_1			(1 << 23)
-#define SPI_CS_POL_INACTIVE_2			(1 << 24)
-#define SPI_CS_POL_INACTIVE_3			(1 << 25)
+						/* n from 0 to 3 */
+#define SPI_CS_POL_INACTIVE(n)			(1 << (22 + (n)))
 #define SPI_CS_POL_INACTIVE_MASK		(0xF << 22)
 
 #define SPI_CS_SEL_0				(0 << 26)
@@ -165,9 +162,6 @@
 #define MAX_HOLD_CYCLES				16
 #define SPI_DEFAULT_SPEED			25000000
 
-#define MAX_CHIP_SELECT				4
-#define SPI_FIFO_DEPTH				64
-
 struct tegra_spi_data {
 	struct device				*dev;
 	struct spi_master			*master;
@@ -184,7 +178,6 @@ struct tegra_spi_data {
 	struct spi_device			*cur_spi;
 	struct spi_device			*cs_control;
 	unsigned				cur_pos;
-	unsigned				cur_len;
 	unsigned				words_per_32bit;
 	unsigned				bytes_per_word;
 	unsigned				curr_dma_words;
@@ -204,12 +197,10 @@ struct tegra_spi_data {
 	u32					rx_status;
 	u32					status_reg;
 	bool					is_packed;
-	unsigned long				packed_size;
 
 	u32					command1_reg;
 	u32					dma_control_reg;
 	u32					def_command1_reg;
-	u32					spi_cs_timing;
 
 	struct completion			xfer_completion;
 	struct spi_transfer			*curr_xfer;
@@ -227,14 +218,14 @@ struct tegra_spi_data {
 static int tegra_spi_runtime_suspend(struct device *dev);
 static int tegra_spi_runtime_resume(struct device *dev);
 
-static inline unsigned long tegra_spi_readl(struct tegra_spi_data *tspi,
+static inline u32 tegra_spi_readl(struct tegra_spi_data *tspi,
 		unsigned long reg)
 {
 	return readl(tspi->base + reg);
 }
 
 static inline void tegra_spi_writel(struct tegra_spi_data *tspi,
-		unsigned long val, unsigned long reg)
+		u32 val, unsigned long reg)
 {
 	writel(val, tspi->base + reg);
 
@@ -245,7 +236,7 @@ static inline void tegra_spi_writel(struct tegra_spi_data *tspi,
 
 static void tegra_spi_clear_status(struct tegra_spi_data *tspi)
 {
-	unsigned long val;
+	u32 val;
 
 	/* Write 1 to clear status register */
 	val = tegra_spi_readl(tspi, SPI_TRANS_STATUS);
@@ -296,10 +287,9 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
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
@@ -313,9 +303,9 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
 		nbytes = written_words * tspi->bytes_per_word;
 		max_n_32bit = DIV_ROUND_UP(nbytes, 4);
 		for (count = 0; count < max_n_32bit; count++) {
-			x = 0;
+			u32 x = 0;
 			for (i = 0; (i < 4) && nbytes; i++, nbytes--)
-				x |= (*tx_buf++) << (i*8);
+				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_spi_writel(tspi, x, SPI_TX_FIFO);
 		}
 	} else {
@@ -323,10 +313,10 @@ static unsigned tegra_spi_fill_tx_fifo_from_client_txbuf(
 		written_words = max_n_32bit;
 		nbytes = written_words * tspi->bytes_per_word;
 		for (count = 0; count < max_n_32bit; count++) {
-			x = 0;
+			u32 x = 0;
 			for (i = 0; nbytes && (i < tspi->bytes_per_word);
 							i++, nbytes--)
-				x |= ((*tx_buf++) << i*8);
+				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_spi_writel(tspi, x, SPI_TX_FIFO);
 		}
 	}
@@ -338,9 +328,8 @@ static unsigned int tegra_spi_read_rx_fifo_to_client_rxbuf(
 		struct tegra_spi_data *tspi, struct spi_transfer *t)
 {
 	unsigned rx_full_count;
-	unsigned long fifo_status;
+	u32 fifo_status;
 	unsigned i, count;
-	unsigned long x;
 	unsigned int read_words = 0;
 	unsigned len;
 	u8 *rx_buf = (u8 *)t->rx_buf + tspi->cur_rx_pos;
@@ -350,20 +339,16 @@ static unsigned int tegra_spi_read_rx_fifo_to_client_rxbuf(
 	if (tspi->is_packed) {
 		len = tspi->curr_dma_words * tspi->bytes_per_word;
 		for (count = 0; count < rx_full_count; count++) {
-			x = tegra_spi_readl(tspi, SPI_RX_FIFO);
+			u32 x = tegra_spi_readl(tspi, SPI_RX_FIFO);
 			for (i = 0; len && (i < 4); i++, len--)
 				*rx_buf++ = (x >> i*8) & 0xFF;
 		}
 		tspi->cur_rx_pos += tspi->curr_dma_words * tspi->bytes_per_word;
 		read_words += tspi->curr_dma_words;
 	} else {
-		unsigned int rx_mask;
-		unsigned int bits_per_word = t->bits_per_word;
-
-		rx_mask = (1 << bits_per_word) - 1;
+		u32 rx_mask = ((u32)1 << t->bits_per_word) - 1;
 		for (count = 0; count < rx_full_count; count++) {
-			x = tegra_spi_readl(tspi, SPI_RX_FIFO);
-			x &= rx_mask;
+			u32 x = tegra_spi_readl(tspi, SPI_RX_FIFO) & rx_mask;
 			for (i = 0; (i < tspi->bytes_per_word); i++)
 				*rx_buf++ = (x >> (i*8)) & 0xFF;
 		}
@@ -376,27 +361,24 @@ static unsigned int tegra_spi_read_rx_fifo_to_client_rxbuf(
 static void tegra_spi_copy_client_txbuf_to_spi_txbuf(
 		struct tegra_spi_data *tspi, struct spi_transfer *t)
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
@@ -410,27 +392,21 @@ static void tegra_spi_copy_client_txbuf_to_spi_txbuf(
 static void tegra_spi_copy_spi_rxbuf_to_client_rxbuf(
 		struct tegra_spi_data *tspi, struct spi_transfer *t)
 {
-	unsigned len;
-
 	/* Make the dma buffer to read by cpu */
 	dma_sync_single_for_cpu(tspi->dev, tspi->rx_dma_phys,
 		tspi->dma_buf_size, DMA_FROM_DEVICE);
 
 	if (tspi->is_packed) {
-		len = tspi->curr_dma_words * tspi->bytes_per_word;
+		unsigned len = tspi->curr_dma_words * tspi->bytes_per_word;
 		memcpy(t->rx_buf + tspi->cur_rx_pos, tspi->rx_dma_buf, len);
 	} else {
 		unsigned int i;
 		unsigned int count;
 		unsigned char *rx_buf = t->rx_buf + tspi->cur_rx_pos;
-		unsigned int x;
-		unsigned int rx_mask;
-		unsigned int bits_per_word = t->bits_per_word;
+		u32 rx_mask = ((u32)1 << t->bits_per_word) - 1;
 
-		rx_mask = (1 << bits_per_word) - 1;
 		for (count = 0; count < tspi->curr_dma_words; count++) {
-			x = tspi->rx_dma_buf[count];
-			x &= rx_mask;
+			u32 x = tspi->rx_dma_buf[count] & rx_mask;
 			for (i = 0; (i < tspi->bytes_per_word); i++)
 				*rx_buf++ = (x >> (i*8)) & 0xFF;
 		}
@@ -490,16 +466,16 @@ static int tegra_spi_start_rx_dma(struct tegra_spi_data *tspi, int len)
 static int tegra_spi_start_dma_based_transfer(
 		struct tegra_spi_data *tspi, struct spi_transfer *t)
 {
-	unsigned long val;
+	u32 val;
 	unsigned int len;
 	int ret = 0;
-	unsigned long status;
+	u32 status;
 
 	/* Make sure that Rx and Tx fifo are empty */
 	status = tegra_spi_readl(tspi, SPI_FIFO_STATUS);
 	if ((status & SPI_FIFO_EMPTY) != SPI_FIFO_EMPTY) {
-		dev_err(tspi->dev,
-			"Rx/Tx fifo are not empty status 0x%08lx\n", status);
+		dev_err(tspi->dev, "Rx/Tx fifo are not empty status 0x%08x\n",
+			(unsigned)status);
 		return -EIO;
 	}
 
@@ -564,7 +540,7 @@ static int tegra_spi_start_dma_based_transfer(
 static int tegra_spi_start_cpu_based_transfer(
 		struct tegra_spi_data *tspi, struct spi_transfer *t)
 {
-	unsigned long val;
+	u32 val;
 	unsigned cur_words;
 
 	if (tspi->cur_direction & DATA_DIR_TX)
@@ -677,13 +653,13 @@ static void tegra_spi_deinit_dma_param(struct tegra_spi_data *tspi,
 	dma_release_channel(dma_chan);
 }
 
-static unsigned long tegra_spi_setup_transfer_one(struct spi_device *spi,
+static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 		struct spi_transfer *t, bool is_first_of_msg)
 {
 	struct tegra_spi_data *tspi = spi_master_get_devdata(spi->master);
 	u32 speed = t->speed_hz;
 	u8 bits_per_word = t->bits_per_word;
-	unsigned long command1;
+	u32 command1;
 	int req_mode;
 
 	if (speed != tspi->cur_speed) {
@@ -738,7 +714,7 @@ static unsigned long tegra_spi_setup_transfer_one(struct spi_device *spi,
 }
 
 static int tegra_spi_start_transfer_one(struct spi_device *spi,
-		struct spi_transfer *t, unsigned long command1)
+		struct spi_transfer *t, u32 command1)
 {
 	struct tegra_spi_data *tspi = spi_master_get_devdata(spi->master);
 	unsigned total_fifo_words;
@@ -763,8 +739,8 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 	tegra_spi_writel(tspi, command1, SPI_COMMAND1);
 	tspi->command1_reg = command1;
 
-	dev_dbg(tspi->dev, "The def 0x%x and written 0x%lx\n",
-				tspi->def_command1_reg, command1);
+	dev_dbg(tspi->dev, "The def 0x%x and written 0x%x\n",
+		tspi->def_command1_reg, (unsigned)command1);
 
 	if (total_fifo_words > SPI_FIFO_DEPTH)
 		ret = tegra_spi_start_dma_based_transfer(tspi, t);
@@ -776,15 +752,9 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 static int tegra_spi_setup(struct spi_device *spi)
 {
 	struct tegra_spi_data *tspi = spi_master_get_devdata(spi->master);
-	unsigned long val;
+	u32 val;
 	unsigned long flags;
 	int ret;
-	unsigned int cs_pol_bit[MAX_CHIP_SELECT] = {
-			SPI_CS_POL_INACTIVE_0,
-			SPI_CS_POL_INACTIVE_1,
-			SPI_CS_POL_INACTIVE_2,
-			SPI_CS_POL_INACTIVE_3,
-	};
 
 	dev_dbg(&spi->dev, "setup %d bpw, %scpol, %scpha, %dHz\n",
 		spi->bits_per_word,
@@ -806,9 +776,9 @@ static int tegra_spi_setup(struct spi_device *spi)
 	spin_lock_irqsave(&tspi->lock, flags);
 	val = tspi->def_command1_reg;
 	if (spi->mode & SPI_CS_HIGH)
-		val &= ~cs_pol_bit[spi->chip_select];
+		val &= ~SPI_CS_POL_INACTIVE(spi->chip_select);
 	else
-		val |= cs_pol_bit[spi->chip_select];
+		val |= SPI_CS_POL_INACTIVE(spi->chip_select);
 	tspi->def_command1_reg = val;
 	tegra_spi_writel(tspi, tspi->def_command1_reg, SPI_COMMAND1);
 	spin_unlock_irqrestore(&tspi->lock, flags);
@@ -842,7 +812,7 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 	msg->actual_length = 0;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		unsigned long cmd1;
+		u32 cmd1;
 
 		reinit_completion(&tspi->xfer_completion);
 
-- 
1.8.4

