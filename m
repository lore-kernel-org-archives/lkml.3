Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKBN5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 08:57:48 -0500
Received: from sauhun.de ([89.238.76.85]:35855 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaKBN53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 08:57:29 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Balbir Singh <bsingharora@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 2/2] spi: account completions as iowait
Date: Sun,  2 Nov 2014 14:58:09 +0100
Message-Id: <1414936689-2707-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
References: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are waiting for IO, so it should be accounted as such.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/spi/spi-altera.c         |  2 +-
 drivers/spi/spi-atmel.c          |  2 +-
 drivers/spi/spi-au1550.c         |  4 ++--
 drivers/spi/spi-bcm2835.c        |  2 +-
 drivers/spi/spi-bcm63xx-hsspi.c  |  2 +-
 drivers/spi/spi-bcm63xx.c        |  2 +-
 drivers/spi/spi-efm32.c          |  2 +-
 drivers/spi/spi-ep93xx.c         |  4 ++--
 drivers/spi/spi-fsl-espi.c       |  2 +-
 drivers/spi/spi-fsl-spi.c        |  2 +-
 drivers/spi/spi-imx.c            |  6 +++---
 drivers/spi/spi-mpc512x-psc.c    |  2 +-
 drivers/spi/spi-mpc52xx-psc.c    |  2 +-
 drivers/spi/spi-mxs.c            |  2 +-
 drivers/spi/spi-nuc900.c         |  2 +-
 drivers/spi/spi-oc-tiny.c        |  2 +-
 drivers/spi/spi-omap2-mcspi.c    |  4 ++--
 drivers/spi/spi-ppc4xx.c         |  2 +-
 drivers/spi/spi-qup.c            |  2 +-
 drivers/spi/spi-s3c24xx.c        |  2 +-
 drivers/spi/spi-s3c64xx.c        |  2 +-
 drivers/spi/spi-sh-msiof.c       |  4 ++--
 drivers/spi/spi-sirf.c           | 10 +++++-----
 drivers/spi/spi-sun4i.c          |  2 +-
 drivers/spi/spi-sun6i.c          |  2 +-
 drivers/spi/spi-tegra114.c       |  2 +-
 drivers/spi/spi-tegra20-sflash.c |  2 +-
 drivers/spi/spi-tegra20-slink.c  |  2 +-
 drivers/spi/spi-ti-qspi.c        |  4 ++--
 drivers/spi/spi-xilinx.c         |  2 +-
 drivers/spi/spi.c                |  4 ++--
 drivers/spi/spidev.c             |  2 +-
 32 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
index 5b5709a5c957..b2d4440ced5f 100644
--- a/drivers/spi/spi-altera.c
+++ b/drivers/spi/spi-altera.c
@@ -134,7 +134,7 @@ static int altera_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 		/* send the first byte */
 		writel(hw_txbyte(hw, 0), hw->base + ALTERA_SPI_TXDATA);
 
-		wait_for_completion(&hw->done);
+		wait_for_completion_io(&hw->done);
 		/* disable receive interrupt */
 		hw->imr &= ~ALTERA_SPI_CONTROL_IRRDY_MSK;
 		writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 113c83f44b5c..427d356070ed 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1114,7 +1114,7 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 
 		/* interrupts are disabled, so free the lock for schedule */
 		atmel_spi_unlock(as);
-		ret = wait_for_completion_timeout(&as->xfer_completion,
+		ret = wait_for_completion_io_timeout(&as->xfer_completion,
 							SPI_DMA_TIMEOUT);
 		atmel_spi_lock(as);
 		if (WARN_ON(ret == 0)) {
diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index f40b34cdf2fc..d0666a6c0829 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -402,7 +402,7 @@ static int au1550_spi_dma_txrxb(struct spi_device *spi, struct spi_transfer *t)
 	hw->regs->psc_spipcr = PSC_SPIPCR_MS;
 	wmb(); /* drain writebuffer */
 
-	wait_for_completion(&hw->master_done);
+	wait_for_completion_io(&hw->master_done);
 
 	au1xxx_dbdma_stop(hw->dma_tx_ch);
 	au1xxx_dbdma_stop(hw->dma_rx_ch);
@@ -552,7 +552,7 @@ static int au1550_spi_pio_txrxb(struct spi_device *spi, struct spi_transfer *t)
 	hw->regs->psc_spipcr = PSC_SPIPCR_MS;
 	wmb(); /* drain writebuffer */
 
-	wait_for_completion(&hw->master_done);
+	wait_for_completion_io(&hw->master_done);
 
 	return hw->rx_count < hw->tx_count ? hw->rx_count : hw->tx_count;
 }
diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 69167456ec1e..4ba4d159619b 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -271,7 +271,7 @@ static int bcm2835_spi_transfer_one(struct spi_master *master,
 		if (err)
 			goto out;
 
-		timeout = wait_for_completion_timeout(&bs->done,
+		timeout = wait_for_completion_io_timeout(&bs->done,
 				msecs_to_jiffies(BCM2835_SPI_TIMEOUT_MS));
 		if (!timeout) {
 			err = -ETIMEDOUT;
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 86f5a98aa7a2..75520895cdf5 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -197,7 +197,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 			     PINGPONG_COMMAND_START_NOW,
 			     bs->regs + HSSPI_PINGPONG_COMMAND_REG(0));
 
-		if (wait_for_completion_timeout(&bs->done, HZ) == 0) {
+		if (wait_for_completion_io_timeout(&bs->done, HZ) == 0) {
 			dev_err(&bs->pdev->dev, "transfer timed out!\n");
 			return -ETIMEDOUT;
 		}
diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 8510400e7867..04ba88d9fe0a 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -195,7 +195,7 @@ static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 	/* Enable the CMD_DONE interrupt */
 	bcm_spi_writeb(bs, SPI_INTR_CMD_DONE, SPI_INT_MASK);
 
-	timeout = wait_for_completion_timeout(&bs->done, HZ);
+	timeout = wait_for_completion_io_timeout(&bs->done, HZ);
 	if (!timeout)
 		return -ETIMEDOUT;
 
diff --git a/drivers/spi/spi-efm32.c b/drivers/spi/spi-efm32.c
index 6caeb1cac0f3..e847c986c9a2 100644
--- a/drivers/spi/spi-efm32.c
+++ b/drivers/spi/spi-efm32.c
@@ -204,7 +204,7 @@ static int efm32_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 	spin_unlock_irq(&ddata->lock);
 
-	wait_for_completion(&ddata->done);
+	wait_for_completion_io(&ddata->done);
 
 	spin_lock_irq(&ddata->lock);
 
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index bf9728773247..30f240b86071 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -415,7 +415,7 @@ static void ep93xx_spi_pio_transfer(struct ep93xx_spi *espi)
 	 */
 	if (ep93xx_spi_read_write(espi)) {
 		ep93xx_spi_enable_interrupts(espi);
-		wait_for_completion(&espi->wait);
+		wait_for_completion_io(&espi->wait);
 	}
 }
 
@@ -583,7 +583,7 @@ static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
 	dma_async_issue_pending(espi->dma_rx);
 	dma_async_issue_pending(espi->dma_tx);
 
-	wait_for_completion(&espi->wait);
+	wait_for_completion_io(&espi->wait);
 
 	ep93xx_spi_dma_finish(espi, DMA_MEM_TO_DEV);
 	ep93xx_spi_dma_finish(espi, DMA_DEV_TO_MEM);
diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index a7f94b6a9e70..d1640aa60230 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -242,7 +242,7 @@ static int fsl_espi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	if (ret)
 		return ret;
 
-	wait_for_completion(&mpc8xxx_spi->done);
+	wait_for_completion_io(&mpc8xxx_spi->done);
 
 	/* disable rx ints */
 	mpc8xxx_spi_write_reg(&reg_base->mask, 0);
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index ed792880c9d6..2ded296d53c2 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -342,7 +342,7 @@ static int fsl_spi_bufs(struct spi_device *spi, struct spi_transfer *t,
 	if (ret)
 		return ret;
 
-	wait_for_completion(&mpc8xxx_spi->done);
+	wait_for_completion_io(&mpc8xxx_spi->done);
 
 	/* disable rx ints */
 	mpc8xxx_spi_write_reg(&reg_base->mask, 0);
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 3637847b5370..eb1d8391e80e 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -939,7 +939,7 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 	dma_async_issue_pending(master->dma_tx);
 	dma_async_issue_pending(master->dma_rx);
 	/* Wait SDMA to finish the data transfer.*/
-	ret = wait_for_completion_timeout(&spi_imx->dma_tx_completion,
+	ret = wait_for_completion_io_timeout(&spi_imx->dma_tx_completion,
 						IMX_DMA_TIMEOUT);
 	if (!ret) {
 		pr_warn("%s %s: I/O Error in DMA TX\n",
@@ -947,7 +947,7 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 			dev_name(&master->dev));
 		dmaengine_terminate_all(master->dma_tx);
 	} else {
-		ret = wait_for_completion_timeout(&spi_imx->dma_rx_completion,
+		ret = wait_for_completion_io_timeout(&spi_imx->dma_rx_completion,
 				IMX_DMA_TIMEOUT);
 		if (!ret) {
 			pr_warn("%s %s: I/O Error in DMA RX\n",
@@ -994,7 +994,7 @@ static int spi_imx_pio_transfer(struct spi_device *spi,
 
 	spi_imx->devtype_data->intctrl(spi_imx, MXC_INT_TE);
 
-	wait_for_completion(&spi_imx->xfer_done);
+	wait_for_completion_io(&spi_imx->xfer_done);
 
 	return transfer->len;
 }
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 577d23a12763..0d9cea915a84 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -170,7 +170,7 @@ static int mpc512x_psc_spi_transfer_rxtx(struct spi_device *spi,
 			reinit_completion(&mps->txisrdone);
 			out_be32(&fifo->txisr, MPC512x_PSC_FIFO_EMPTY);
 			out_be32(&fifo->tximr, MPC512x_PSC_FIFO_EMPTY);
-			wait_for_completion(&mps->txisrdone);
+			wait_for_completion_io(&mps->txisrdone);
 		}
 
 		/*
diff --git a/drivers/spi/spi-mpc52xx-psc.c b/drivers/spi/spi-mpc52xx-psc.c
index de532aa11d34..d48e388dc84a 100644
--- a/drivers/spi/spi-mpc52xx-psc.c
+++ b/drivers/spi/spi-mpc52xx-psc.c
@@ -183,7 +183,7 @@ static int mpc52xx_psc_spi_transfer_rxtx(struct spi_device *spi,
 			out_be16(&fifo->rfalarm, rfalarm);
 		}
 		out_be16(&psc->mpc52xx_psc_imr, MPC52xx_PSC_IMR_RXRDY);
-		wait_for_completion(&mps->done);
+		wait_for_completion_io(&mps->done);
 		recv_at_once = in_be16(&fifo->rfnum);
 		dev_dbg(&spi->dev, "%d bytes received\n", recv_at_once);
 
diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 51460878af04..32080e879d1f 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -282,7 +282,7 @@ static int mxs_spi_txrx_dma(struct mxs_spi *spi,
 	dmaengine_submit(desc);
 	dma_async_issue_pending(ssp->dmach);
 
-	ret = wait_for_completion_timeout(&spi->c,
+	ret = wait_for_completion_io_timeout(&spi->c,
 				msecs_to_jiffies(SSP_TIMEOUT));
 	if (!ret) {
 		dev_err(ssp->dev, "DMA transfer timeout\n");
diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index 73e91d5a43df..16bfcc654a97 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -185,7 +185,7 @@ static int nuc900_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 
 	nuc900_spi_gobusy(hw);
 
-	wait_for_completion(&hw->done);
+	wait_for_completion_io(&hw->done);
 
 	return hw->count;
 }
diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 8998d11c7238..3dc1b7526fa3 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -151,7 +151,7 @@ static int tiny_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 			writeb(TINY_SPI_STATUS_TXE, hw->base + TINY_SPI_STATUS);
 		}
 
-		wait_for_completion(&hw->done);
+		wait_for_completion_io(&hw->done);
 	} else {
 		/* we need to tighten the transfer loop */
 		writeb(txp ? *txp++ : 0, hw->base + TINY_SPI_TXDATA);
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 352eed7463ac..49fcea30588e 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -487,7 +487,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	dma_async_issue_pending(mcspi_dma->dma_rx);
 	omap2_mcspi_set_dma_req(spi, 1, 1);
 
-	wait_for_completion(&mcspi_dma->dma_rx_completion);
+	wait_for_completion_io(&mcspi_dma->dma_rx_completion);
 	dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
 			 DMA_FROM_DEVICE);
 
@@ -601,7 +601,7 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		count = omap2_mcspi_rx_dma(spi, xfer, cfg, es);
 
 	if (tx != NULL) {
-		wait_for_completion(&mcspi_dma->dma_tx_completion);
+		wait_for_completion_io(&mcspi_dma->dma_tx_completion);
 		dma_unmap_single(mcspi->dev, xfer->tx_dma, xfer->len,
 				 DMA_TO_DEVICE);
 
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 80b8408ac3e3..955ea726e5c6 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -161,7 +161,7 @@ static int spi_ppc4xx_txrx(struct spi_device *spi, struct spi_transfer *t)
 	data = hw->tx ? hw->tx[0] : 0;
 	out_8(&hw->regs->txd, data);
 	out_8(&hw->regs->cr, SPI_PPC4XX_CR_STR);
-	wait_for_completion(&hw->done);
+	wait_for_completion_io(&hw->done);
 
 	return hw->count;
 }
diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 9f83d2950748..109917fa70d7 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -469,7 +469,7 @@ static int spi_qup_transfer_one(struct spi_master *master,
 		goto exit;
 	}
 
-	if (!wait_for_completion_timeout(&controller->done, timeout))
+	if (!wait_for_completion_io_timeout(&controller->done, timeout))
 		ret = -ETIMEDOUT;
 exit:
 	spi_qup_set_state(controller, QUP_STATE_RESET);
diff --git a/drivers/spi/spi-s3c24xx.c b/drivers/spi/spi-s3c24xx.c
index e713737d784f..6af9d7f84e7b 100644
--- a/drivers/spi/spi-s3c24xx.c
+++ b/drivers/spi/spi-s3c24xx.c
@@ -417,7 +417,7 @@ static int s3c24xx_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 	/* send the first byte */
 	writeb(hw_txbyte(hw, 0), hw->regs + S3C2410_SPTDAT);
 
-	wait_for_completion(&hw->done);
+	wait_for_completion_io(&hw->done);
 	return hw->count;
 }
 
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 480133ee1eb3..653490cf408a 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -488,7 +488,7 @@ static int wait_for_dma(struct s3c64xx_spi_driver_data *sdd,
 	ms += 10; /* some tolerance */
 
 	val = msecs_to_jiffies(ms) + 10;
-	val = wait_for_completion_timeout(&sdd->xfer_completion, val);
+	val = wait_for_completion_io_timeout(&sdd->xfer_completion, val);
 
 	/*
 	 * If the previous xfer was completed within timeout, then
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 3f365402fcc0..71b1df4d159b 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -590,7 +590,7 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	}
 
 	/* wait for tx fifo to be emptied / rx fifo to be filled */
-	ret = wait_for_completion_timeout(&p->done, HZ);
+	ret = wait_for_completion_io_timeout(&p->done, HZ);
 	if (!ret) {
 		dev_err(&p->pdev->dev, "PIO timeout\n");
 		ret = -ETIMEDOUT;
@@ -701,7 +701,7 @@ static int sh_msiof_dma_once(struct sh_msiof_spi_priv *p, const void *tx,
 	}
 
 	/* wait for tx fifo to be emptied / rx fifo to be filled */
-	ret = wait_for_completion_timeout(&p->done, HZ);
+	ret = wait_for_completion_io_timeout(&p->done, HZ);
 	if (!ret) {
 		dev_err(&p->pdev->dev, "DMA timeout\n");
 		ret = -ETIMEDOUT;
diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index 39e2c0a55a28..7a5571873581 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -325,7 +325,7 @@ static void spi_sirfsoc_cmd_transfer(struct spi_device *spi,
 		sspi->base + SIRFSOC_SPI_INT_EN);
 	writel(SIRFSOC_SPI_CMD_TX_EN,
 		sspi->base + SIRFSOC_SPI_TX_RX_EN);
-	if (wait_for_completion_timeout(&sspi->tx_done, timeout) == 0) {
+	if (wait_for_completion_io_timeout(&sspi->tx_done, timeout) == 0) {
 		dev_err(&spi->dev, "cmd transfer timeout\n");
 		return;
 	}
@@ -384,7 +384,7 @@ static void spi_sirfsoc_dma_transfer(struct spi_device *spi,
 	dma_async_issue_pending(sspi->rx_chan);
 	writel(SIRFSOC_SPI_RX_EN | SIRFSOC_SPI_TX_EN,
 			sspi->base + SIRFSOC_SPI_TX_RX_EN);
-	if (wait_for_completion_timeout(&sspi->rx_done, timeout) == 0) {
+	if (wait_for_completion_io_timeout(&sspi->rx_done, timeout) == 0) {
 		dev_err(&spi->dev, "transfer timeout\n");
 		dmaengine_terminate_all(sspi->rx_chan);
 	} else
@@ -394,7 +394,7 @@ static void spi_sirfsoc_dma_transfer(struct spi_device *spi,
 	 * we get rx data by writing tx data, so if rx is done, tx has
 	 * done earlier
 	 */
-	if (wait_for_completion_timeout(&sspi->tx_done, timeout) == 0) {
+	if (wait_for_completion_io_timeout(&sspi->tx_done, timeout) == 0) {
 		dev_err(&spi->dev, "transfer timeout\n");
 		dmaengine_terminate_all(sspi->tx_chan);
 	}
@@ -443,8 +443,8 @@ static void spi_sirfsoc_pio_transfer(struct spi_device *spi,
 			sspi->base + SIRFSOC_SPI_INT_EN);
 		writel(SIRFSOC_SPI_RX_EN | SIRFSOC_SPI_TX_EN,
 			sspi->base + SIRFSOC_SPI_TX_RX_EN);
-		if (!wait_for_completion_timeout(&sspi->tx_done, timeout) ||
-			!wait_for_completion_timeout(&sspi->rx_done, timeout)) {
+		if (!wait_for_completion_io_timeout(&sspi->tx_done, timeout) ||
+			!wait_for_completion_io_timeout(&sspi->rx_done, timeout)) {
 			dev_err(&spi->dev, "transfer timeout\n");
 			break;
 		}
diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 85204c93f3d3..f2d3d03891e9 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -279,7 +279,7 @@ static int sun4i_spi_transfer_one(struct spi_master *master,
 	reg = sun4i_spi_read(sspi, SUN4I_CTL_REG);
 	sun4i_spi_write(sspi, SUN4I_CTL_REG, reg | SUN4I_CTL_XCH);
 
-	timeout = wait_for_completion_timeout(&sspi->done,
+	timeout = wait_for_completion_io_timeout(&sspi->done,
 					      msecs_to_jiffies(1000));
 	if (!timeout) {
 		ret = -ETIMEDOUT;
diff --git a/drivers/spi/spi-sun6i.c b/drivers/spi/spi-sun6i.c
index bd24093f4038..6c8b73f74690 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -269,7 +269,7 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 	reg = sun6i_spi_read(sspi, SUN6I_TFR_CTL_REG);
 	sun6i_spi_write(sspi, SUN6I_TFR_CTL_REG, reg | SUN6I_TFR_CTL_XCH);
 
-	timeout = wait_for_completion_timeout(&sspi->done,
+	timeout = wait_for_completion_io_timeout(&sspi->done,
 					      msecs_to_jiffies(1000));
 	if (!timeout) {
 		ret = -ETIMEDOUT;
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 795bcbc0131b..2b6c4de63c23 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -833,7 +833,7 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 		}
 
 		is_first_msg = false;
-		ret = wait_for_completion_timeout(&tspi->xfer_completion,
+		ret = wait_for_completion_io_timeout(&tspi->xfer_completion,
 						SPI_DMA_TIMEOUT);
 		if (WARN_ON(ret == 0)) {
 			dev_err(tspi->dev,
diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index cd66fe7b78a9..70b858b44fc7 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -337,7 +337,7 @@ static int tegra_sflash_transfer_one_message(struct spi_master *master,
 			goto exit;
 		}
 		is_first_msg = false;
-		ret = wait_for_completion_timeout(&tsd->xfer_completion,
+		ret = wait_for_completion_io_timeout(&tsd->xfer_completion,
 						SPI_DMA_TIMEOUT);
 		if (WARN_ON(ret == 0)) {
 			dev_err(tsd->dev,
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 0b9e32e9f493..9b16fac3d069 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -820,7 +820,7 @@ static int tegra_slink_transfer_one(struct spi_master *master,
 		return ret;
 	}
 
-	ret = wait_for_completion_timeout(&tspi->xfer_completion,
+	ret = wait_for_completion_io_timeout(&tspi->xfer_completion,
 					  SLINK_DMA_TIMEOUT);
 	if (WARN_ON(ret == 0)) {
 		dev_err(tspi->dev,
diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 6c211d1910b0..e1d7d813b80d 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -230,7 +230,7 @@ static int qspi_write_msg(struct ti_qspi *qspi, struct spi_transfer *t)
 		}
 
 		ti_qspi_write(qspi, cmd, QSPI_SPI_CMD_REG);
-		ret = wait_for_completion_timeout(&qspi->transfer_complete,
+		ret = wait_for_completion_io_timeout(&qspi->transfer_complete,
 						  QSPI_COMPLETION_TIMEOUT);
 		if (ret == 0) {
 			dev_err(qspi->dev, "write timed out\n");
@@ -268,7 +268,7 @@ static int qspi_read_msg(struct ti_qspi *qspi, struct spi_transfer *t)
 	while (count) {
 		dev_dbg(qspi->dev, "rx cmd %08x dc %08x\n", cmd, qspi->dc);
 		ti_qspi_write(qspi, cmd, QSPI_SPI_CMD_REG);
-		ret = wait_for_completion_timeout(&qspi->transfer_complete,
+		ret = wait_for_completion_io_timeout(&qspi->transfer_complete,
 				QSPI_COMPLETION_TIMEOUT);
 		if (ret == 0) {
 			dev_err(qspi->dev, "read timed out\n");
diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 79bd84f43430..eb11e12b6ddc 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -265,7 +265,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 							~XSPI_CR_TRANS_INHIBIT;
 		xspi->write_fn(cr, xspi->regs + XSPI_CR_OFFSET);
 
-		wait_for_completion(&xspi->done);
+		wait_for_completion_io(&xspi->done);
 
 		/* A transmit has just completed. Process received data and
 		 * check for more data to transmit. Always inhibit the
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index ebcb33df2eb2..f8f76978b9b2 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -810,7 +810,7 @@ static int spi_transfer_one_message(struct spi_master *master,
 				ms = xfer->len * 8 * 1000 / xfer->speed_hz;
 				ms += ms + 100; /* some tolerance */
 
-				ms = wait_for_completion_timeout(&master->xfer_completion,
+				ms = wait_for_completion_io_timeout(&master->xfer_completion,
 								 msecs_to_jiffies(ms));
 			}
 
@@ -2113,7 +2113,7 @@ static int __spi_sync(struct spi_device *spi, struct spi_message *message,
 		mutex_unlock(&master->bus_lock_mutex);
 
 	if (status == 0) {
-		wait_for_completion(&done);
+		wait_for_completion_io(&done);
 		status = message->status;
 	}
 	message->context = NULL;
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index e3bc23bb5883..a2171010b46d 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -123,7 +123,7 @@ spidev_sync(struct spidev_data *spidev, struct spi_message *message)
 	spin_unlock_irq(&spidev->spi_lock);
 
 	if (status == 0) {
-		wait_for_completion(&done);
+		wait_for_completion_io(&done);
 		status = message->status;
 		if (status == 0)
 			status = message->actual_length;
-- 
2.1.1

