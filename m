Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3ETGv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:51:56 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:45147 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3ETGvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:51:53 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH v1 1/3] spi: s3c64xx: added support for polling mode
Date: Mon, 20 May 2013 12:21:32 +0530
Message-Id: <1369032694-13183-2-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Girish K S <girishks2000@gmail.com>

The 64xx spi driver supports partial polling mode.
Only the last chunk of the transfer length is transferred
or recieved in polling mode.

Some SoC's that adopt this controller might not have have dma
interface. This patch adds support for complete polling mode
and gives flexibity for the user to select poll/dma mode.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
changes in v1:
		Addressed the performance issue reported by Mark Brown
caused due to this patch. The wait_for_timeout function is modified to
address this issue in dma mode.

 drivers/spi/spi-s3c64xx.c |  153 ++++++++++++++++++++++++++++++--------------
 1 files changed, 104 insertions(+), 49 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 5000586..0a80692 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -39,6 +39,7 @@
 #endif
 
 #define MAX_SPI_PORTS		3
+#define S3C64XX_SPI_QUIRK_POLL		(1 << 0)
 
 /* Registers and bit-fields */
 
@@ -130,6 +131,7 @@
 #define S3C64XX_SPI_TRAILCNT		S3C64XX_SPI_MAX_TRAILCNT
 
 #define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
+#define is_polling(x)	(x->port_conf->quirks & S3C64XX_SPI_QUIRK_POLL)
 
 #define RXBUSY    (1<<2)
 #define TXBUSY    (1<<3)
@@ -158,6 +160,7 @@ struct s3c64xx_spi_port_config {
 	int	fifo_lvl_mask[MAX_SPI_PORTS];
 	int	rx_lvl_offset;
 	int	tx_st_done;
+	int	quirks;
 	bool	high_speed;
 	bool	clk_from_cmu;
 };
@@ -344,8 +347,12 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 {
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
-	/* Acquire DMA channels */
-	while (!acquire_dma(sdd))
+	/*
+	 * If DMA resource was not available during
+	 * probe, no need to continue with dma requests
+	 * else Acquire DMA channels
+	 */
+	while (!is_polling(sdd) && !acquire_dma(sdd))
 		usleep_range(10000, 11000);
 
 	pm_runtime_get_sync(&sdd->pdev->dev);
@@ -358,9 +365,12 @@ static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
 	/* Free DMA channels */
-	sdd->ops->release((enum dma_ch)sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
-	sdd->ops->release((enum dma_ch)sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
-
+	if (!is_polling(sdd)) {
+		sdd->ops->release((enum dma_ch)sdd->rx_dma.ch,
+					&s3c64xx_spi_dma_client);
+		sdd->ops->release((enum dma_ch)sdd->tx_dma.ch,
+					&s3c64xx_spi_dma_client);
+	}
 	pm_runtime_put(&sdd->pdev->dev);
 
 	return 0;
@@ -464,8 +474,10 @@ static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
 	/* Free DMA channels */
-	dma_release_channel(sdd->rx_dma.ch);
-	dma_release_channel(sdd->tx_dma.ch);
+	if (!is_polling(sdd)) {
+		dma_release_channel(sdd->rx_dma.ch);
+		dma_release_channel(sdd->tx_dma.ch);
+	}
 
 	pm_runtime_put(&sdd->pdev->dev);
 	return 0;
@@ -566,6 +578,30 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 
 	cs = spi->controller_data;
 	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+
+	/* Start the signals */
+	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
+}
+
+static u32 wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
+					int timeout_ms)
+{
+	void __iomem *regs = sdd->regs;
+	unsigned long val = 1;
+	u32 status;
+
+	/* max fifo depth available */
+	u32 max_fifo = (FIFO_LVL_MASK(sdd) >> 1) + 1;
+
+	if (timeout_ms)
+		val = msecs_to_loops(timeout_ms);
+
+	do {
+		status = readl(regs + S3C64XX_SPI_STATUS);
+	} while (RX_FIFO_LVL(status, sdd) < max_fifo && --val);
+
+	/* return the actual received data length */
+	return RX_FIFO_LVL(status, sdd);
 }
 
 static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
@@ -590,20 +626,19 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 		} while (RX_FIFO_LVL(status, sdd) < xfer->len && --val);
 	}
 
-	if (!val)
-		return -EIO;
-
 	if (dma_mode) {
 		u32 status;
 
 		/*
+		 * If the previous xfer was completed within timeout, then
+		 * proceed further else return -EIO.
 		 * DmaTx returns after simply writing data in the FIFO,
 		 * w/o waiting for real transmission on the bus to finish.
 		 * DmaRx returns only after Dma read data from FIFO which
 		 * needs bus transmission to finish, so we don't worry if
 		 * Xfer involved Rx(with or without Tx).
 		 */
-		if (xfer->rx_buf == NULL) {
+		if (val && !xfer->rx_buf) {
 			val = msecs_to_loops(10);
 			status = readl(regs + S3C64XX_SPI_STATUS);
 			while ((TX_FIFO_LVL(status, sdd)
@@ -613,30 +648,53 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 				status = readl(regs + S3C64XX_SPI_STATUS);
 			}
 
-			if (!val)
-				return -EIO;
 		}
+
+		/* If timed out while checking rx/tx status return error */
+		if (!val)
+			return -EIO;
 	} else {
+		int loops;
+		u32 cpy_len;
+		u8 *buf;
+
 		/* If it was only Tx */
-		if (xfer->rx_buf == NULL) {
+		if (!xfer->rx_buf) {
 			sdd->state &= ~TXBUSY;
 			return 0;
 		}
 
-		switch (sdd->cur_bpw) {
-		case 32:
-			ioread32_rep(regs + S3C64XX_SPI_RX_DATA,
-				xfer->rx_buf, xfer->len / 4);
-			break;
-		case 16:
-			ioread16_rep(regs + S3C64XX_SPI_RX_DATA,
-				xfer->rx_buf, xfer->len / 2);
-			break;
-		default:
-			ioread8_rep(regs + S3C64XX_SPI_RX_DATA,
-				xfer->rx_buf, xfer->len);
-			break;
-		}
+		/*
+		 * If the receive length is bigger than the controller fifo
+		 * size, calculate the loops and read the fifo as many times.
+		 * loops = length / max fifo size (calculated by using the
+		 * fifo mask).
+		 * For any size less than the fifo size the below code is
+		 * executed atleast once.
+		 */
+		loops = xfer->len / ((FIFO_LVL_MASK(sdd) >> 1) + 1);
+		buf = xfer->rx_buf;
+		do {
+			/* wait for data to be received in the fifo */
+			cpy_len = wait_for_timeout(sdd, (loops ? ms : 0));
+
+			switch (sdd->cur_bpw) {
+			case 32:
+				ioread32_rep(regs + S3C64XX_SPI_RX_DATA,
+					buf, cpy_len / 4);
+				break;
+			case 16:
+				ioread16_rep(regs + S3C64XX_SPI_RX_DATA,
+					buf, cpy_len / 2);
+				break;
+			default:
+				ioread8_rep(regs + S3C64XX_SPI_RX_DATA,
+					buf, cpy_len);
+				break;
+			}
+
+			buf = buf + cpy_len;
+		} while (loops--);
 		sdd->state &= ~RXBUSY;
 	}
 
@@ -652,6 +710,9 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 		sdd->tgl_spi = NULL;
 
 	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+
+	/* Quiese the signals */
+	writel(S3C64XX_SPI_SLAVE_SIG_INACT, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
 }
 
 static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
@@ -733,7 +794,7 @@ static int s3c64xx_spi_map_mssg(struct s3c64xx_spi_driver_data *sdd,
 	struct device *dev = &sdd->pdev->dev;
 	struct spi_transfer *xfer;
 
-	if (msg->is_dma_mapped)
+	if (is_polling(sdd) || msg->is_dma_mapped)
 		return 0;
 
 	/* First mark all xfer unmapped */
@@ -782,7 +843,7 @@ static void s3c64xx_spi_unmap_mssg(struct s3c64xx_spi_driver_data *sdd,
 	struct device *dev = &sdd->pdev->dev;
 	struct spi_transfer *xfer;
 
-	if (msg->is_dma_mapped)
+	if (is_polling(sdd) || msg->is_dma_mapped)
 		return;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
@@ -861,8 +922,9 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 
 		/* Polling method for xfers not bigger than FIFO capacity */
 		use_dma = 0;
-		if (sdd->rx_dma.ch && sdd->tx_dma.ch &&
-		    (xfer->len > ((FIFO_LVL_MASK(sdd) >> 1) + 1)))
+		if (!is_polling(sdd) &&
+			(sdd->rx_dma.ch && sdd->tx_dma.ch &&
+			(xfer->len > ((FIFO_LVL_MASK(sdd) >> 1) + 1))))
 			use_dma = 1;
 
 		spin_lock_irqsave(&sdd->lock, flags);
@@ -876,17 +938,10 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		/* Slave Select */
 		enable_cs(sdd, spi);
 
-		/* Start the signals */
-		writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
-
 		spin_unlock_irqrestore(&sdd->lock, flags);
 
 		status = wait_for_xfer(sdd, xfer, use_dma);
 
-		/* Quiese the signals */
-		writel(S3C64XX_SPI_SLAVE_SIG_INACT,
-		       sdd->regs + S3C64XX_SPI_SLAVE_SEL);
-
 		if (status) {
 			dev_err(&spi->dev, "I/O Error: rx-%d tx-%d res:rx-%c tx-%c len-%d\n",
 				xfer->rx_buf ? 1 : 0, xfer->tx_buf ? 1 : 0,
@@ -1287,19 +1342,19 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	if (!sdd->pdev->dev.of_node) {
 		res = platform_get_resource(pdev, IORESOURCE_DMA,  0);
 		if (!res) {
-			dev_err(&pdev->dev, "Unable to get SPI tx dma "
-					"resource\n");
-			return -ENXIO;
-		}
-		sdd->tx_dma.dmach = res->start;
+			dev_warn(&pdev->dev, "Unable to get SPI tx dma "
+					"resource. Switching to poll mode\n");
+			sdd->port_conf->quirks = S3C64XX_SPI_QUIRK_POLL;
+		} else
+			sdd->tx_dma.dmach = res->start;
 
 		res = platform_get_resource(pdev, IORESOURCE_DMA,  1);
 		if (!res) {
-			dev_err(&pdev->dev, "Unable to get SPI rx dma "
-					"resource\n");
-			return -ENXIO;
-		}
-		sdd->rx_dma.dmach = res->start;
+			dev_warn(&pdev->dev, "Unable to get SPI rx dma "
+					"resource. Switching to poll mode\n");
+			sdd->port_conf->quirks = S3C64XX_SPI_QUIRK_POLL;
+		} else
+			sdd->rx_dma.dmach = res->start;
 	}
 
 	sdd->tx_dma.direction = DMA_MEM_TO_DEV;
-- 
1.7.5.4

