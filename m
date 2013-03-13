Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3CMGoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:44:15 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60921 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab3CMGoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:44:00 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH V3 2/5] spi: s3c64xx: added support for polling mode
Date: Wed, 13 Mar 2013 12:13:31 +0530
Message-Id: <1363157014-9615-3-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
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
 drivers/spi/spi-s3c64xx.c | 116 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 81 insertions(+), 35 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 4188b2f..054b8d4 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -35,6 +35,7 @@
 #include <linux/platform_data/spi-s3c64xx.h>
 
 #define MAX_SPI_PORTS		3
+#define S3C64XX_SPI_QUIRK_POLL		(1 << 0)
 
 /* Registers and bit-fields */
 
@@ -126,6 +127,7 @@
 #define S3C64XX_SPI_TRAILCNT		S3C64XX_SPI_MAX_TRAILCNT
 
 #define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
+#define is_polling(x)	(x->port_conf->quirks & S3C64XX_SPI_QUIRK_POLL)
 
 #define RXBUSY    (1<<2)
 #define TXBUSY    (1<<3)
@@ -154,6 +156,7 @@ struct s3c64xx_spi_port_config {
 	int	fifo_lvl_mask[MAX_SPI_PORTS];
 	int	rx_lvl_offset;
 	int	tx_st_done;
+	int	quirks;
 	bool	high_speed;
 	bool	clk_from_cmu;
 };
@@ -419,6 +422,27 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 
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
+	unsigned long val;
+	u32 status;
+	/* max fifo depth available */
+	u32 max_fifo = (FIFO_LVL_MASK(sdd) >> 1) + 1;
+
+	val = msecs_to_loops(timeout_ms);
+	do {
+		status = readl(regs + S3C64XX_SPI_STATUS);
+	} while (RX_FIFO_LVL(status, sdd) < max_fifo && --val);
+
+	/* return the actual received data length */
+	return RX_FIFO_LVL(status, sdd);
 }
 
 static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
@@ -443,20 +467,19 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
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
@@ -466,30 +489,53 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
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
+		do{
+			/* wait for data to be received in the fifo */
+			cpy_len = wait_for_timeout(sdd, ms);
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
+		}while(loops--);
 		sdd->state &= ~RXBUSY;
 	}
 
@@ -505,6 +551,10 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 		sdd->tgl_spi = NULL;
 
 	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+
+	/* Quiese the signals */
+	writel(S3C64XX_SPI_SLAVE_SIG_INACT,
+	sdd->regs + S3C64XX_SPI_SLAVE_SEL);
 }
 
 static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
@@ -586,7 +636,7 @@ static int s3c64xx_spi_map_mssg(struct s3c64xx_spi_driver_data *sdd,
 	struct device *dev = &sdd->pdev->dev;
 	struct spi_transfer *xfer;
 
-	if (msg->is_dma_mapped)
+	if (is_polling(sdd) || msg->is_dma_mapped)
 		return 0;
 
 	/* First mark all xfer unmapped */
@@ -635,7 +685,7 @@ static void s3c64xx_spi_unmap_mssg(struct s3c64xx_spi_driver_data *sdd,
 	struct device *dev = &sdd->pdev->dev;
 	struct spi_transfer *xfer;
 
-	if (msg->is_dma_mapped)
+	if (is_polling(sdd) || msg->is_dma_mapped)
 		return;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
@@ -713,7 +763,8 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		}
 
 		/* Polling method for xfers not bigger than FIFO capacity */
-		if (xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
+		if (is_polling(sdd) ||
+			xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
 			use_dma = 0;
 		else
 			use_dma = 1;
@@ -729,17 +780,10 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
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
@@ -795,7 +839,7 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
 	/* Acquire DMA channels */
-	while (!acquire_dma(sdd))
+	while (!is_polling(sdd) && !acquire_dma(sdd))
 		usleep_range(10000, 11000);
 
 	pm_runtime_get_sync(&sdd->pdev->dev);
@@ -808,8 +852,10 @@ static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
 	/* Free DMA channels */
-	sdd->ops->release(sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
-	sdd->ops->release(sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
+	if (!is_polling(sdd)) {
+		sdd->ops->release(sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
+		sdd->ops->release(sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
+	}
 
 	pm_runtime_put(&sdd->pdev->dev);
 
@@ -1217,7 +1263,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 
 	sdd->cur_bpw = 8;
 
-	if (!sdd->pdev->dev.of_node) {
+	if (!sdd->pdev->dev.of_node && !is_polling(sdd)) {
 		res = platform_get_resource(pdev, IORESOURCE_DMA,  0);
 		if (!res) {
 			dev_err(&pdev->dev, "Unable to get SPI tx dma "
-- 
1.8.0

