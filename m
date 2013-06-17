Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3FQNbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:31:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41995 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3FQNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:31:29 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>, Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v4] spi: omap2-mcspi: Add FIFO buffer support
Date: Mon, 17 Jun 2013 16:31:06 +0300
Message-ID: <1371475866-9647-1-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCSPI controller has a built-in FIFO buffer to unload the DMA or interrupt
handler and improve data throughput. This patch adds FIFO buffer support for SPI
transfers in DMA mode.

For SPI transfers in DMA mode, the largest possible FIFO buffer size will be
calculated and set up. The FIFO won't be used for the SPI transfers in DMA mode
if: calculated FIFO buffer size is less then 2 bytes or the FIFO buffer size
isn't multiple of the SPI word length.

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
v4:
* rebased on topic/omap branch

 drivers/spi/spi-omap2-mcspi.c |  147 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 130 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 5a93a0d..6802806 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -38,12 +38,15 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/gcd.h>
 
 #include <linux/spi/spi.h>
 
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
 #define OMAP2_MCSPI_MAX_FREQ		48000000
+#define OMAP2_MCSPI_MAX_FIFODEPTH	64
+#define OMAP2_MCSPI_MAX_FIFOWCNT	0xFFFF
 #define SPI_AUTOSUSPEND_TIMEOUT		2000
 
 #define OMAP2_MCSPI_REVISION		0x00
@@ -53,6 +56,7 @@
 #define OMAP2_MCSPI_WAKEUPENABLE	0x20
 #define OMAP2_MCSPI_SYST		0x24
 #define OMAP2_MCSPI_MODULCTRL		0x28
+#define OMAP2_MCSPI_XFERLEVEL		0x7c
 
 /* per-channel banks, 0x14 bytes each, first is: */
 #define OMAP2_MCSPI_CHCONF0		0x2c
@@ -62,6 +66,7 @@
 #define OMAP2_MCSPI_RX0			0x3c
 
 /* per-register bitmasks: */
+#define OMAP2_MCSPI_IRQSTATUS_EOW	BIT(17)
 
 #define OMAP2_MCSPI_MODULCTRL_SINGLE	BIT(0)
 #define OMAP2_MCSPI_MODULCTRL_MS	BIT(2)
@@ -82,10 +87,13 @@
 #define OMAP2_MCSPI_CHCONF_IS		BIT(18)
 #define OMAP2_MCSPI_CHCONF_TURBO	BIT(19)
 #define OMAP2_MCSPI_CHCONF_FORCE	BIT(20)
+#define OMAP2_MCSPI_CHCONF_FFET		BIT(27)
+#define OMAP2_MCSPI_CHCONF_FFER		BIT(28)
 
 #define OMAP2_MCSPI_CHSTAT_RXS		BIT(0)
 #define OMAP2_MCSPI_CHSTAT_TXS		BIT(1)
 #define OMAP2_MCSPI_CHSTAT_EOT		BIT(2)
+#define OMAP2_MCSPI_CHSTAT_TXFFE	BIT(3)
 
 #define OMAP2_MCSPI_CHCTRL_EN		BIT(0)
 
@@ -128,6 +136,7 @@ struct omap2_mcspi {
 	struct omap2_mcspi_dma	*dma_channels;
 	struct device		*dev;
 	struct omap2_mcspi_regs ctx;
+	int			fifo_depth;
 	unsigned int		pin_dir:1;
 };
 
@@ -257,6 +266,58 @@ static void omap2_mcspi_set_master_mode(struct spi_master *master)
 	ctx->modulctrl = l;
 }
 
+static void omap2_mcspi_set_fifo(const struct spi_device *spi,
+				struct spi_transfer *t, int enable)
+{
+	struct spi_master *master = spi->master;
+	struct omap2_mcspi_cs *cs = spi->controller_state;
+	struct omap2_mcspi *mcspi;
+	unsigned int wcnt;
+	int fifo_depth, bytes_per_word;
+	u32 chconf, xferlevel;
+
+	mcspi = spi_master_get_devdata(master);
+
+	chconf = mcspi_cached_chconf0(spi);
+	if (enable) {
+		bytes_per_word = mcspi_bytes_per_word(cs->word_len);
+		if (t->len % bytes_per_word != 0)
+			goto disable_fifo;
+
+		fifo_depth = gcd(t->len, OMAP2_MCSPI_MAX_FIFODEPTH);
+		if (fifo_depth < 2 || fifo_depth % bytes_per_word != 0)
+			goto disable_fifo;
+
+		wcnt = t->len / bytes_per_word;
+		if (wcnt > OMAP2_MCSPI_MAX_FIFOWCNT)
+			goto disable_fifo;
+
+		xferlevel = wcnt << 16;
+		if (t->rx_buf != NULL) {
+			chconf |= OMAP2_MCSPI_CHCONF_FFER;
+			xferlevel |= (fifo_depth - 1) << 8;
+		} else {
+			chconf |= OMAP2_MCSPI_CHCONF_FFET;
+			xferlevel |= fifo_depth - 1;
+		}
+
+		mcspi_write_reg(master, OMAP2_MCSPI_XFERLEVEL, xferlevel);
+		mcspi_write_chconf0(spi, chconf);
+		mcspi->fifo_depth = fifo_depth;
+
+		return;
+	}
+
+disable_fifo:
+	if (t->rx_buf != NULL)
+		chconf &= ~OMAP2_MCSPI_CHCONF_FFER;
+	else
+		chconf &= ~OMAP2_MCSPI_CHCONF_FFET;
+
+	mcspi_write_chconf0(spi, chconf);
+	mcspi->fifo_depth = 0;
+}
+
 static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
 {
 	struct spi_master	*spi_cntrl = mcspi->master;
@@ -373,7 +434,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 {
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma  *mcspi_dma;
-	unsigned int		count;
+	unsigned int		count, dma_count;
 	u32			l;
 	int			elements = 0;
 	int			word_len, element_count;
@@ -381,6 +442,11 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 	count = xfer->len;
+	dma_count = xfer->len;
+
+	if (mcspi->fifo_depth == 0)
+		dma_count -= es;
+
 	word_len = cs->word_len;
 	l = mcspi_cached_chconf0(spi);
 
@@ -394,16 +460,15 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	if (mcspi_dma->dma_rx) {
 		struct dma_async_tx_descriptor *tx;
 		struct scatterlist sg;
-		size_t len = xfer->len - es;
 
 		dmaengine_slave_config(mcspi_dma->dma_rx, &cfg);
 
-		if (l & OMAP2_MCSPI_CHCONF_TURBO)
-			len -= es;
+		if ((l & OMAP2_MCSPI_CHCONF_TURBO) && mcspi->fifo_depth == 0)
+			dma_count -= es;
 
 		sg_init_table(&sg, 1);
 		sg_dma_address(&sg) = xfer->rx_dma;
-		sg_dma_len(&sg) = len;
+		sg_dma_len(&sg) = dma_count;
 
 		tx = dmaengine_prep_slave_sg(mcspi_dma->dma_rx, &sg, 1,
 				DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT |
@@ -423,6 +488,10 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	wait_for_completion(&mcspi_dma->dma_rx_completion);
 	dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
 			 DMA_FROM_DEVICE);
+
+	if (mcspi->fifo_depth > 0)
+		return count;
+
 	omap2_mcspi_set_enable(spi, 0);
 
 	elements = element_count - 1;
@@ -481,7 +550,10 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	struct dma_slave_config	cfg;
 	enum dma_slave_buswidth width;
 	unsigned es;
+	u32			burst;
 	void __iomem		*chstat_reg;
+	void __iomem            *irqstat_reg;
+	int			wait_res;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
@@ -499,19 +571,27 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		es = 4;
 	}
 
+	count = xfer->len;
+	burst = 1;
+
+	if (mcspi->fifo_depth > 0) {
+		if (count > mcspi->fifo_depth)
+			burst = mcspi->fifo_depth / es;
+		else
+			burst = count / es;
+	}
+
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = cs->phys + OMAP2_MCSPI_RX0;
 	cfg.dst_addr = cs->phys + OMAP2_MCSPI_TX0;
 	cfg.src_addr_width = width;
 	cfg.dst_addr_width = width;
-	cfg.src_maxburst = 1;
-	cfg.dst_maxburst = 1;
+	cfg.src_maxburst = burst;
+	cfg.dst_maxburst = burst;
 
 	rx = xfer->rx_buf;
 	tx = xfer->tx_buf;
 
-	count = xfer->len;
-
 	if (tx != NULL)
 		omap2_mcspi_tx_dma(spi, xfer, cfg);
 
@@ -519,18 +599,38 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		count = omap2_mcspi_rx_dma(spi, xfer, cfg, es);
 
 	if (tx != NULL) {
-		chstat_reg = cs->base + OMAP2_MCSPI_CHSTAT0;
 		wait_for_completion(&mcspi_dma->dma_tx_completion);
 		dma_unmap_single(mcspi->dev, xfer->tx_dma, xfer->len,
 				 DMA_TO_DEVICE);
 
+		if (mcspi->fifo_depth > 0) {
+			irqstat_reg = mcspi->base + OMAP2_MCSPI_IRQSTATUS;
+
+			if (mcspi_wait_for_reg_bit(irqstat_reg,
+						OMAP2_MCSPI_IRQSTATUS_EOW) < 0)
+				dev_err(&spi->dev, "EOW timed out\n");
+
+			mcspi_write_reg(mcspi->master, OMAP2_MCSPI_IRQSTATUS,
+					OMAP2_MCSPI_IRQSTATUS_EOW);
+		}
+
 		/* for TX_ONLY mode, be sure all words have shifted out */
 		if (rx == NULL) {
-			if (mcspi_wait_for_reg_bit(chstat_reg,
-						OMAP2_MCSPI_CHSTAT_TXS) < 0)
-				dev_err(&spi->dev, "TXS timed out\n");
-			else if (mcspi_wait_for_reg_bit(chstat_reg,
-						OMAP2_MCSPI_CHSTAT_EOT) < 0)
+			chstat_reg = cs->base + OMAP2_MCSPI_CHSTAT0;
+			if (mcspi->fifo_depth > 0) {
+				wait_res = mcspi_wait_for_reg_bit(chstat_reg,
+						OMAP2_MCSPI_CHSTAT_TXFFE);
+				if (wait_res < 0)
+					dev_err(&spi->dev, "TXFFE timed out\n");
+			} else {
+				wait_res = mcspi_wait_for_reg_bit(chstat_reg,
+						OMAP2_MCSPI_CHSTAT_TXS);
+				if (wait_res < 0)
+					dev_err(&spi->dev, "TXS timed out\n");
+			}
+			if (wait_res >= 0 &&
+				(mcspi_wait_for_reg_bit(chstat_reg,
+					OMAP2_MCSPI_CHSTAT_EOT) < 0))
 				dev_err(&spi->dev, "EOT timed out\n");
 		}
 	}
@@ -957,7 +1057,7 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 	cs = spi->controller_state;
 	cd = spi->controller_data;
 
-	omap2_mcspi_set_enable(spi, 1);
+	omap2_mcspi_set_enable(spi, 0);
 	list_for_each_entry(t, &m->transfers, transfer_list) {
 		if (t->tx_buf == NULL && t->rx_buf == NULL && t->len) {
 			status = -EINVAL;
@@ -1005,6 +1105,12 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 		if (t->len) {
 			unsigned	count;
 
+			if ((mcspi_dma->dma_rx && mcspi_dma->dma_tx) &&
+			    (m->is_dma_mapped || t->len >= DMA_MIN_BYTES))
+				omap2_mcspi_set_fifo(spi, t, 1);
+
+			omap2_mcspi_set_enable(spi, 1);
+
 			/* RX_ONLY mode needs dummy data in TX reg */
 			if (t->tx_buf == NULL)
 				__raw_writel(0, cs->base
@@ -1031,6 +1137,11 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 			omap2_mcspi_force_cs(spi, 0);
 			cs_active = 0;
 		}
+
+		omap2_mcspi_set_enable(spi, 0);
+
+		if (mcspi->fifo_depth > 0)
+			omap2_mcspi_set_fifo(spi, t, 0);
 	}
 	/* Restore defaults if they were overriden */
 	if (par_override) {
@@ -1051,8 +1162,10 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 
 	omap2_mcspi_set_enable(spi, 0);
 
-	m->status = status;
+	if (mcspi->fifo_depth > 0 && t)
+		omap2_mcspi_set_fifo(spi, t, 0);
 
+	m->status = status;
 }
 
 static int omap2_mcspi_transfer_one_message(struct spi_master *master,
-- 
1.7.0.4

