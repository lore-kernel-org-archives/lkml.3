Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab3LHPfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:35:52 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61078 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab3LHPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:35:26 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 3/3] spi: tegra20-sflash: use u32 for 32-bit register values
Date: Sun,  8 Dec 2013 16:35:11 +0100
Message-Id: <1386516911-26388-4-git-send-email-mina86@mina86.com>
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
 drivers/spi/spi-tegra20-sflash.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index 4dc8e81..ce9589c 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -148,14 +148,14 @@ struct tegra_sflash_data {
 static int tegra_sflash_runtime_suspend(struct device *dev);
 static int tegra_sflash_runtime_resume(struct device *dev);
 
-static inline unsigned long tegra_sflash_readl(struct tegra_sflash_data *tsd,
+static inline u32 tegra_sflash_readl(struct tegra_sflash_data *tsd,
 		unsigned long reg)
 {
 	return readl(tsd->base + reg);
 }
 
 static inline void tegra_sflash_writel(struct tegra_sflash_data *tsd,
-		unsigned long val, unsigned long reg)
+		u32 val, unsigned long reg)
 {
 	writel(val, tsd->base + reg);
 }
@@ -185,7 +185,7 @@ static unsigned tegra_sflash_fill_tx_fifo_from_client_txbuf(
 	struct tegra_sflash_data *tsd, struct spi_transfer *t)
 {
 	unsigned nbytes;
-	unsigned long status;
+	u32 status;
 	unsigned max_n_32bit = tsd->curr_xfer_words;
 	u8 *tx_buf = (u8 *)t->tx_buf + tsd->cur_tx_pos;
 
@@ -196,11 +196,11 @@ static unsigned tegra_sflash_fill_tx_fifo_from_client_txbuf(
 	status = tegra_sflash_readl(tsd, SPI_STATUS);
 	while (!(status & SPI_TXF_FULL)) {
 		int i;
-		unsigned int x = 0;
+		u32 x = 0;
 
 		for (i = 0; nbytes && (i < tsd->bytes_per_word);
 							i++, nbytes--)
-				x |= ((*tx_buf++) << i*8);
+			x |= (u32)(*tx_buf++) << (i * 8);
 		tegra_sflash_writel(tsd, x, SPI_TX_FIFO);
 		if (!nbytes)
 			break;
@@ -214,16 +214,14 @@ static unsigned tegra_sflash_fill_tx_fifo_from_client_txbuf(
 static int tegra_sflash_read_rx_fifo_to_client_rxbuf(
 		struct tegra_sflash_data *tsd, struct spi_transfer *t)
 {
-	unsigned long status;
+	u32 status;
 	unsigned int read_words = 0;
 	u8 *rx_buf = (u8 *)t->rx_buf + tsd->cur_rx_pos;
 
 	status = tegra_sflash_readl(tsd, SPI_STATUS);
 	while (!(status & SPI_RXF_EMPTY)) {
 		int i;
-		unsigned long x;
-
-		x = tegra_sflash_readl(tsd, SPI_RX_FIFO);
+		u32 x = tegra_sflash_readl(tsd, SPI_RX_FIFO);
 		for (i = 0; (i < tsd->bytes_per_word); i++)
 			*rx_buf++ = (x >> (i*8)) & 0xFF;
 		read_words++;
@@ -236,7 +234,7 @@ static int tegra_sflash_read_rx_fifo_to_client_rxbuf(
 static int tegra_sflash_start_cpu_based_transfer(
 		struct tegra_sflash_data *tsd, struct spi_transfer *t)
 {
-	unsigned long val = 0;
+	u32 val = 0;
 	unsigned cur_words;
 
 	if (tsd->cur_direction & DATA_DIR_TX)
@@ -266,7 +264,7 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
 {
 	struct tegra_sflash_data *tsd = spi_master_get_devdata(spi->master);
 	u32 speed;
-	unsigned long command;
+	u32 command;
 
 	speed = t->speed_hz;
 	if (speed != tsd->cur_speed) {
@@ -313,7 +311,7 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
 	tegra_sflash_writel(tsd, command, SPI_COMMAND);
 	tsd->command_reg = command;
 
-	return  tegra_sflash_start_cpu_based_transfer(tsd, t);
+	return tegra_sflash_start_cpu_based_transfer(tsd, t);
 }
 
 static int tegra_sflash_setup(struct spi_device *spi)
-- 
1.8.4

