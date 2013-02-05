Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3BEXK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:10:56 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63131 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab3BEXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:10:53 -0500
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] spi: s3c64xx: added support for polling mode
Date: Tue,  5 Feb 2013 15:09:42 -0800
Message-Id: <1360105784-12282-3-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64xx spi driver supports partial polling mode.
Only the last chunk of the transfer length is transferred
or recieved in polling mode.

Some SoC's that adopt this controller might not have have dma
interface. This patch adds support for complete polling mode
and gives flexibity for the user to select poll/dma mode.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |   65 +++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index b770f88..90770bd 100644
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
@@ -155,6 +157,7 @@ struct s3c64xx_spi_port_config {
 	int	fifo_lvl_mask[MAX_SPI_PORTS];
 	int	rx_lvl_offset;
 	int	tx_st_done;
+	int	quirks;
 	bool	high_speed;
 	bool	clk_from_cmu;
 };
@@ -345,19 +348,7 @@ static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 
 	chcfg = readl(regs + S3C64XX_SPI_CH_CFG);
 	chcfg &= ~S3C64XX_SPI_CH_TXCH_ON;
-
-	if (dma_mode) {
 		chcfg &= ~S3C64XX_SPI_CH_RXCH_ON;
-	} else {
-		/* Always shift in data in FIFO, even if xfer is Tx only,
-		 * this helps setting PCKT_CNT value for generating clocks
-		 * as exactly needed.
-		 */
-		chcfg |= S3C64XX_SPI_CH_RXCH_ON;
-		writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
-					| S3C64XX_SPI_PACKET_CNT_EN,
-					regs + S3C64XX_SPI_PACKET_CNT);
-	}
 
 	if (xfer->tx_buf != NULL) {
 		sdd->state |= TXBUSY;
@@ -385,6 +376,10 @@ static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 
 	if (xfer->rx_buf != NULL) {
 		sdd->state |= RXBUSY;
+		chcfg |= S3C64XX_SPI_CH_RXCH_ON;
+		writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
+				| S3C64XX_SPI_PACKET_CNT_EN,
+				regs + S3C64XX_SPI_PACKET_CNT);
 
 		if (sdd->port_conf->high_speed && sdd->cur_speed >= 30000000UL
 					&& !(sdd->cur_mode & SPI_CPHA))
@@ -392,10 +387,6 @@ static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 
 		if (dma_mode) {
 			modecfg |= S3C64XX_SPI_MODE_RXDMA_ON;
-			chcfg |= S3C64XX_SPI_CH_RXCH_ON;
-			writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
-					| S3C64XX_SPI_PACKET_CNT_EN,
-					regs + S3C64XX_SPI_PACKET_CNT);
 			prepare_dma(&sdd->rx_dma, xfer->len, xfer->rx_dma);
 		}
 	}
@@ -421,6 +412,9 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 
 	cs = spi->controller_data;
 	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+
+	/* Start the signals */
+	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
 }
 
 static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
@@ -445,12 +439,12 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 		} while (RX_FIFO_LVL(status, sdd) < xfer->len && --val);
 	}
 
-	if (!val)
-		return -EIO;
-
 	if (dma_mode) {
 		u32 status;
 
+		if (!val)
+			return -EIO;
+
 		/*
 		 * DmaTx returns after simply writing data in the FIFO,
 		 * w/o waiting for real transmission on the bus to finish.
@@ -480,16 +474,19 @@ static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
 
 		switch (sdd->cur_bpw) {
 		case 32:
-			ioread32_rep(regs + S3C64XX_SPI_RX_DATA,
-				xfer->rx_buf, xfer->len / 4);
+			for (val = 0; val < (xfer->len / 4); val++)
+				*((u32 *)xfer->rx_buf + val) =
+					ioread32(regs + S3C64XX_SPI_RX_DATA);
 			break;
 		case 16:
-			ioread16_rep(regs + S3C64XX_SPI_RX_DATA,
-				xfer->rx_buf, xfer->len / 2);
+			for (val = 0; val < (xfer->len / 2); val++)
+				*((u16 *)xfer->rx_buf + val) =
+					ioread16(regs + S3C64XX_SPI_RX_DATA);
 			break;
 		default:
-			ioread8_rep(regs + S3C64XX_SPI_RX_DATA,
-				xfer->rx_buf, xfer->len);
+			for (val = 0; val < xfer->len; val++)
+				*((u8 *)xfer->rx_buf + val) =
+					ioread8(regs + S3C64XX_SPI_RX_DATA);
 			break;
 		}
 		sdd->state &= ~RXBUSY;
@@ -507,6 +504,10 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 		sdd->tgl_spi = NULL;
 
 	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+
+	/* Quiese the signals */
+	writel(S3C64XX_SPI_SLAVE_SIG_INACT,
+	sdd->regs + S3C64XX_SPI_SLAVE_SEL);
 }
 
 static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
@@ -588,7 +589,7 @@ static int s3c64xx_spi_map_mssg(struct s3c64xx_spi_driver_data *sdd,
 	struct device *dev = &sdd->pdev->dev;
 	struct spi_transfer *xfer;
 
-	if (msg->is_dma_mapped)
+	if (is_polling(sdd) || msg->is_dma_mapped)
 		return 0;
 
 	/* First mark all xfer unmapped */
@@ -637,7 +638,7 @@ static void s3c64xx_spi_unmap_mssg(struct s3c64xx_spi_driver_data *sdd,
 	struct device *dev = &sdd->pdev->dev;
 	struct spi_transfer *xfer;
 
-	if (msg->is_dma_mapped)
+	if (is_polling(sdd) || msg->is_dma_mapped)
 		return;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
@@ -715,7 +716,8 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		}
 
 		/* Polling method for xfers not bigger than FIFO capacity */
-		if (xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
+		if (is_polling(sdd) ||
+			xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
 			use_dma = 0;
 		else
 			use_dma = 1;
@@ -731,17 +733,10 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
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
 			dev_err(&spi->dev, "I/O Error: "
 				"rx-%d tx-%d res:rx-%c tx-%c len-%d\n",
-- 
1.7.10.4

