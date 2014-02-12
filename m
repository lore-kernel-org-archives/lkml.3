Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaBLJ51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:57:27 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40523 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbaBLJ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:57:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Robin Gong <b38343@freescale.com>
To: <broonie@kernel.org>
CC: <s.hauer@pengutronix.de>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>,
        <shijie.huang@freescale.com>
Subject: [PATCH V1] spi: imx: add dma support for ecspi
Date: Wed, 12 Feb 2014 18:02:59 +0800
Message-ID: <1392199379-6742-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basical dma support for ecspi. Validate on i.MX6qsabresd board.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/spi/spi-imx.c |  221 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 211 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index a5474ef..6a80658 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -21,6 +21,8 @@
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
@@ -42,6 +44,9 @@
 
 #define DRIVER_NAME "spi_imx"
 
+#define DMA_SG_MAXLEN		0xffff /* align with imx-sdma.c */
+#define ECSPI_TIMEOUT		1000
+
 #define MXC_CSPIRXDATA		0x00
 #define MXC_CSPITXDATA		0x04
 #define MXC_CSPICTRL		0x08
@@ -76,13 +81,14 @@ struct spi_imx_devtype_data {
 	void (*trigger)(struct spi_imx_data *);
 	int (*rx_available)(struct spi_imx_data *);
 	void (*reset)(struct spi_imx_data *);
+	void (*dmactrl)(struct spi_imx_data *, int);
 	enum spi_imx_devtype devtype;
 };
 
 struct spi_imx_data {
 	struct spi_bitbang bitbang;
 
-	struct completion xfer_done;
+	struct completion rx_done; /* PIO mode use rx_done both rx/tx */
 	void __iomem *base;
 	int irq;
 	struct clk *clk_per;
@@ -96,6 +102,16 @@ struct spi_imx_data {
 	const void *tx_buf;
 	unsigned int txfifo; /* number of words pushed in tx FIFO */
 
+	/* DMA used */
+	struct dma_chan	*rx_dmach;	/* rx dma channel */
+	struct dma_chan	*tx_dmach;	/* tx dma channel */
+	dma_addr_t src_start;
+	dma_addr_t dst_start;
+	dma_addr_t rxfifo_phy;
+	dma_addr_t txfifo_phy;
+	struct completion tx_done;
+	void *dummy_buf; /* send or receive dummy data in DMA mode */
+
 	const struct spi_imx_devtype_data *devtype_data;
 	int chipselect[0];
 };
@@ -185,6 +201,7 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 #define MX51_ECSPI_CTRL		0x08
 #define MX51_ECSPI_CTRL_ENABLE		(1 <<  0)
 #define MX51_ECSPI_CTRL_XCH		(1 <<  2)
+#define MX51_ECSPI_CTRL_SMC		(1 <<  3)
 #define MX51_ECSPI_CTRL_MODE_MASK	(0xf << 4)
 #define MX51_ECSPI_CTRL_POSTDIV_OFFSET	8
 #define MX51_ECSPI_CTRL_PREDIV_OFFSET	12
@@ -202,6 +219,17 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 #define MX51_ECSPI_INT_TEEN		(1 <<  0)
 #define MX51_ECSPI_INT_RREN		(1 <<  3)
 
+#define MX51_ECSPI_DMA		0x14
+#define MX51_ECSPI_DMA_TXTHR_OFFSET	(0)
+#define MX51_ECSPI_DMA_TXTHR_MASK	(0x3f << MX51_ECSPI_DMA_TXTHR_OFFSET)
+#define MX51_ECSPI_DMA_TXDEN	(1 << 7)
+#define MX51_ECSPI_DMA_RXTHR_OFFSET	(16)
+#define MX51_ECSPI_DMA_RXTHR_MASK	(0x3f << MX51_ECSPI_DMA_RXTHR_OFFSET)
+#define MX51_ECSPI_DMA_RXDEN	(1 << 23)
+#define MX51_ECSPI_DMA_RXDMALEN_OFFSET	(24)
+#define MX51_ECSPI_DMA_RXDMALEN_MASK	(0x3f << MX51_ECSPI_DMA_RXDMALEN_OFFSET)
+#define MX51_ECSPI_DMA_RXTDEN	(1 << 31)
+
 #define MX51_ECSPI_STAT		0x18
 #define MX51_ECSPI_STAT_RR		(1 <<  3)
 
@@ -288,6 +316,10 @@ static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
 
 	ctrl |= (config->bpw - 1) << MX51_ECSPI_CTRL_BL_OFFSET;
 
+	/* set smc bit for dma */
+	if (spi_imx->rx_dmach)
+		ctrl |= MX51_ECSPI_CTRL_SMC;
+
 	cfg |= MX51_ECSPI_CONFIG_SBBCTRL(config->cs);
 
 	if (config->mode & SPI_CPHA)
@@ -303,6 +335,26 @@ static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
 	writel(ctrl, spi_imx->base + MX51_ECSPI_CTRL);
 	writel(cfg, spi_imx->base + MX51_ECSPI_CONFIG);
 
+	/* set rx/tx fifo threshold in DMA mode */
+	if (spi_imx->rx_dmach) {
+		cfg = readl(spi_imx->base + MX51_ECSPI_DMA);
+		cfg &= ~(MX51_ECSPI_DMA_TXTHR_MASK | MX51_ECSPI_DMA_RXTHR_MASK
+			| MX51_ECSPI_DMA_RXDMALEN_MASK);
+		/* set rx/tx fifo threshold */
+		cfg |= (spi_imx_get_fifosize(spi_imx) / 2) <<
+			MX51_ECSPI_DMA_TXTHR_OFFSET;
+		cfg |= (spi_imx_get_fifosize(spi_imx) / 2) <<
+			MX51_ECSPI_DMA_RXTHR_OFFSET;
+		/*
+		 * set RX_DMA_LENTH to 1 to prvent missing the last bytes which
+		 * is less than rx threshold based on current design.
+		 */
+		cfg |= 1 << MX51_ECSPI_DMA_RXDMALEN_OFFSET;
+		cfg |= MX51_ECSPI_DMA_RXTDEN;
+
+		writel(cfg, spi_imx->base + MX51_ECSPI_DMA);
+	}
+
 	/*
 	 * Wait until the changes in the configuration register CONFIGREG
 	 * propagate into the hardware. It takes exactly one tick of the
@@ -335,6 +387,17 @@ static void __maybe_unused mx51_ecspi_reset(struct spi_imx_data *spi_imx)
 		readl(spi_imx->base + MXC_CSPIRXDATA);
 }
 
+static void __maybe_unused mx51_ecspi_dmactrl(struct spi_imx_data *spi_imx, int enable)
+{
+	u32 value = readl(spi_imx->base + MX51_ECSPI_DMA);
+
+	if (enable)
+		value |= MX51_ECSPI_DMA_TXDEN | MX51_ECSPI_DMA_RXDEN;
+	else
+		value &= ~(MX51_ECSPI_DMA_TXDEN | MX51_ECSPI_DMA_RXDEN);
+	writel(value, spi_imx->base + MX51_ECSPI_DMA);
+}
+
 #define MX31_INTREG_TEEN	(1 << 0)
 #define MX31_INTREG_RREN	(1 << 3)
 
@@ -606,6 +669,7 @@ static struct spi_imx_devtype_data imx51_ecspi_devtype_data = {
 	.trigger = mx51_ecspi_trigger,
 	.rx_available = mx51_ecspi_rx_available,
 	.reset = mx51_ecspi_reset,
+	.dmactrl = mx51_ecspi_dmactrl,
 	.devtype = IMX51_ECSPI,
 };
 
@@ -693,7 +757,7 @@ static irqreturn_t spi_imx_isr(int irq, void *dev_id)
 	}
 
 	spi_imx->devtype_data->intctrl(spi_imx, 0);
-	complete(&spi_imx->xfer_done);
+	complete(&spi_imx->rx_done);
 
 	return IRQ_HANDLED;
 }
@@ -703,6 +767,8 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
 	struct spi_imx_config config;
+	struct dma_slave_config slave_config = {};
+	int ret;
 
 	config.bpw = t ? t->bits_per_word : spi->bits_per_word;
 	config.speed_hz  = t ? t->speed_hz : spi->max_speed_hz;
@@ -728,9 +794,116 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 
 	spi_imx->devtype_data->config(spi_imx, &config);
 
+	/* DMA channel config */
+	if (spi_imx->rx_dmach) {
+		slave_config.direction = DMA_DEV_TO_MEM;
+		slave_config.src_addr = spi_imx->rxfifo_phy;
+		slave_config.src_addr_width = config.bpw / 8;
+		slave_config.src_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
+		ret = dmaengine_slave_config(spi_imx->rx_dmach, &slave_config);
+		if (ret) {
+			dev_err(&spi->dev, "error in RX dma configuration.\n");
+			return ret;
+		}
+	}
+	if (spi_imx->tx_dmach) {
+		slave_config.direction = DMA_MEM_TO_DEV;
+		slave_config.dst_addr = spi_imx->txfifo_phy;
+		slave_config.dst_addr_width = config.bpw / 8;
+		slave_config.dst_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
+		ret = dmaengine_slave_config(spi_imx->tx_dmach, &slave_config);
+		if (ret) {
+			dev_err(&spi->dev, "error in TX dma configuration.\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
+static int spi_imx_transfer_pio(struct spi_device *spi,
+				struct spi_transfer *transfer)
+{
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+
+	init_completion(&spi_imx->rx_done);
+
+	spi_imx_push(spi_imx);
+
+	spi_imx->devtype_data->intctrl(spi_imx, MXC_INT_TE);
+
+	wait_for_completion(&spi_imx->rx_done);
+
+	return transfer->len;
+}
+
+static void spi_imx_dma_done_callback(void *data)
+{
+	struct completion *dma_complete = data;
+
+	complete(dma_complete);
+}
+
+static int spi_imx_transfer_dma(struct spi_device *spi,
+				struct spi_transfer *t)
+{
+	struct dma_async_tx_descriptor *rx_desc, *tx_desc;
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+	int ret;
+
+	spi_imx->tx_buf =  t->tx_buf ? t->tx_buf : spi_imx->dummy_buf;
+	spi_imx->rx_buf =  t->rx_buf ? t->rx_buf : spi_imx->dummy_buf;
+
+	init_completion(&spi_imx->rx_done);
+	init_completion(&spi_imx->tx_done);
+
+	spi_imx->dst_start = dma_map_single(&spi->dev, spi_imx->rx_buf, t->len,
+						DMA_FROM_DEVICE);
+	rx_desc = dmaengine_prep_slave_single(spi_imx->rx_dmach,
+		spi_imx->dst_start, t->len, DMA_DEV_TO_MEM,
+		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	rx_desc->callback = spi_imx_dma_done_callback;
+	rx_desc->callback_param = &spi_imx->rx_done;
+
+	spi_imx->src_start = dma_map_single(&spi->dev, (void *)spi_imx->tx_buf,
+						t->len, DMA_TO_DEVICE);
+	tx_desc = dmaengine_prep_slave_single(spi_imx->tx_dmach,
+		spi_imx->src_start, t->len, DMA_MEM_TO_DEV,
+		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	tx_desc->callback = spi_imx_dma_done_callback;
+	tx_desc->callback_param = &spi_imx->tx_done;
+
+	dmaengine_submit(tx_desc);
+	dmaengine_submit(rx_desc);
+	dma_async_issue_pending(spi_imx->tx_dmach);
+	dma_async_issue_pending(spi_imx->rx_dmach);
+
+	/* enable rx/tx DMA transfer */
+	spi_imx->devtype_data->dmactrl(spi_imx, 1);
+
+	/* only wait tx event */
+	ret = wait_for_completion_timeout(&spi_imx->tx_done,
+				msecs_to_jiffies(ECSPI_TIMEOUT));
+	if (!ret) {
+		dev_err(&spi->dev, "DMA transfer timeout\n");
+		ret = -ETIMEDOUT;
+		dmaengine_terminate_all(spi_imx->tx_dmach);
+		dmaengine_terminate_all(spi_imx->rx_dmach);
+		goto unmap_rxtx;
+	}
+
+	ret = t->len;
+
+unmap_rxtx:
+	dma_unmap_single(&spi->dev, spi_imx->src_start, t->len, DMA_TO_DEVICE);
+	dma_unmap_single(&spi->dev, spi_imx->dst_start, t->len, DMA_FROM_DEVICE);
+
+	/* disable rx/tx DMA transfer */
+	spi_imx->devtype_data->dmactrl(spi_imx, 0);
+
+	return ret;
+}
+
 static int spi_imx_transfer(struct spi_device *spi,
 				struct spi_transfer *transfer)
 {
@@ -741,13 +914,10 @@ static int spi_imx_transfer(struct spi_device *spi,
 	spi_imx->count = transfer->len;
 	spi_imx->txfifo = 0;
 
-	init_completion(&spi_imx->xfer_done);
-
-	spi_imx_push(spi_imx);
-
-	spi_imx->devtype_data->intctrl(spi_imx, MXC_INT_TE);
-
-	wait_for_completion(&spi_imx->xfer_done);
+	if (spi_imx->rx_dmach && transfer->len < DMA_SG_MAXLEN)
+		transfer->len = spi_imx_transfer_dma(spi, transfer);
+	else
+		transfer->len = spi_imx_transfer_pio(spi, transfer);
 
 	return transfer->len;
 }
@@ -866,7 +1036,7 @@ static int spi_imx_probe(struct platform_device *pdev)
 	spi_imx->bitbang.master->unprepare_message = spi_imx_unprepare_message;
 	spi_imx->bitbang.master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
-	init_completion(&spi_imx->xfer_done);
+	init_completion(&spi_imx->rx_done);
 
 	spi_imx->devtype_data = of_id ? of_id->data :
 		(struct spi_imx_devtype_data *) pdev->id_entry->driver_data;
@@ -891,6 +1061,37 @@ static int spi_imx_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
+	spi_imx->rx_dmach = dma_request_slave_channel(&pdev->dev, "rx");
+	spi_imx->tx_dmach = dma_request_slave_channel(&pdev->dev, "tx");
+
+	/*
+	 * work in PIO mode if NOT set dma channel in dts or requeset dma
+	 * channel failed. Only validated in i.MX6(MX51) now.
+	 */
+	if (spi_imx->rx_dmach && spi_imx->tx_dmach) {
+		dev_info(&pdev->dev, "requested DMA channel rx:%d,tx:%d\n",
+			spi_imx->rx_dmach->chan_id, spi_imx->tx_dmach->chan_id);
+
+		spi_imx->rxfifo_phy = res->start + MXC_CSPIRXDATA;
+		spi_imx->txfifo_phy = res->start + MXC_CSPITXDATA;
+		/* malloc one max SG buf(64KB) to read/write rx/tx FIFO */
+		spi_imx->dummy_buf = kmalloc(DMA_SG_MAXLEN, GFP_KERNEL);
+		if (!spi_imx->dummy_buf) {
+			ret = -ENOMEM;
+			dma_release_channel(spi_imx->rx_dmach);
+			dma_release_channel(spi_imx->tx_dmach);
+			goto out_master_put;
+		}
+	} else if (spi_imx->rx_dmach) {
+		/* rx dma requested but tx failed, force to both PIO mode */
+		dma_release_channel(spi_imx->rx_dmach);
+		spi_imx->rx_dmach = NULL;
+	} else if (spi_imx->tx_dmach) {
+		/* tx dma requested but rx failed, force to both PIO mode */
+		dma_release_channel(spi_imx->tx_dmach);
+		spi_imx->tx_dmach = NULL;
+	}
+
 	spi_imx->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(spi_imx->clk_ipg)) {
 		ret = PTR_ERR(spi_imx->clk_ipg);
-- 
1.7.5.4


