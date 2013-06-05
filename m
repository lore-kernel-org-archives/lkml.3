Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3FELkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:40:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37976 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3FELkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:40:22 -0400
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
        <spi-devel-general@lists.sourceforge.net>
Subject: [PATCH 2/2] spi: omap2-mcspi: Add FIFO buffer support
Date: Wed, 5 Jun 2013 14:39:58 +0300
Message-ID: <1370432398-7796-3-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCSPI controller has a built-in FIFO buffer to unload the DMA or
interrupt handler and improve data throughput.

The FIFO could be enabled by setting up the fifo_depth configuration
parameter. If enabled, the FIFO will be used, only for transfers,
which data size is a multiple of FIFO buffer size (fifo_depth).

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 Documentation/devicetree/bindings/spi/omap-spi.txt |    2 +
 drivers/spi/spi-omap2-mcspi.c                      |  159 ++++++++++++++++++--
 include/linux/platform_data/spi-omap2-mcspi.h      |    1 +
 3 files changed, 146 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/omap-spi.txt b/Documentation/devicetree/bindings/spi/omap-spi.txt
index 87b2841..46459e8 100644
--- a/Documentation/devicetree/bindings/spi/omap-spi.txt
+++ b/Documentation/devicetree/bindings/spi/omap-spi.txt
@@ -14,6 +14,7 @@ SPI Controller specific data in SPI slave nodes:
 - The spi slave nodes can provide the following information which is used
   by the spi controller:
   - ti,spi-turbo-mode: Set turbo mode for this device.
+  - ti,spi-fifo-depth: Enable FIFO and set up buffer depth.
 
 Example:
 
@@ -35,5 +36,6 @@ mcspi1: mcspi@1 {
 
 		controller-data {
 			ti,spi-turbo-mode;
+			ti,spi-fifo-depth = <64>;
 		};
 	};
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 67d0409..f973656 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -45,6 +45,8 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
 #define OMAP2_MCSPI_MAX_FREQ		48000000
+#define OMAP2_MCSPI_MAX_FIFODEPTH	64
+#define OMAP2_MCSPI_MAX_FIFOWCNT	0xFFFF
 #define SPI_AUTOSUSPEND_TIMEOUT		2000
 
 #define OMAP2_MCSPI_REVISION		0x00
@@ -54,6 +56,7 @@
 #define OMAP2_MCSPI_WAKEUPENABLE	0x20
 #define OMAP2_MCSPI_SYST		0x24
 #define OMAP2_MCSPI_MODULCTRL		0x28
+#define OMAP2_MCSPI_XFERLEVEL		0x7c
 
 /* per-channel banks, 0x14 bytes each, first is: */
 #define OMAP2_MCSPI_CHCONF0		0x2c
@@ -63,6 +66,7 @@
 #define OMAP2_MCSPI_RX0			0x3c
 
 /* per-register bitmasks: */
+#define OMAP2_MCSPI_IRQSTATUS_EOW	BIT(17)
 
 #define OMAP2_MCSPI_MODULCTRL_SINGLE	BIT(0)
 #define OMAP2_MCSPI_MODULCTRL_MS	BIT(2)
@@ -83,10 +87,13 @@
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
 
@@ -129,6 +136,7 @@ struct omap2_mcspi {
 	struct omap2_mcspi_dma	*dma_channels;
 	struct device		*dev;
 	struct omap2_mcspi_regs ctx;
+	unsigned short		fifo_depth;
 	unsigned int		pin_dir:1;
 };
 
@@ -248,6 +256,59 @@ static void omap2_mcspi_set_master_mode(struct spi_master *master)
 	ctx->modulctrl = l;
 }
 
+static void omap2_mcspi_set_fifo(const struct spi_device *spi,
+				struct spi_transfer *t, int enable)
+{
+	struct spi_master *master = spi->master;
+	struct omap2_mcspi_cs *cs = spi->controller_state;
+	struct omap2_mcspi_device_config *cd = spi->controller_data;
+	struct omap2_mcspi *mcspi;
+	unsigned int wcnt;
+	int is_read, bytes_per_word;
+	u16 level;
+	u32 chconf;
+
+	mcspi = spi_master_get_devdata(master);
+	chconf = mcspi_cached_chconf0(spi);
+	is_read = (t->rx_buf != NULL) ? 1 : 0;
+
+	if (enable) {
+		if (!cd || cd->fifo_depth <= 0)
+			return;
+
+		bytes_per_word = (cs->word_len <= 8) ? 1 :
+				(cs->word_len <= 16) ? 2 :
+				/* cs->word_len <= 32 */ 4;
+
+		if (cd->fifo_depth % bytes_per_word != 0
+			|| (t->len > cd->fifo_depth
+				&& t->len % cd->fifo_depth != 0))
+			return;
+
+		wcnt = t->len / bytes_per_word;
+
+		if (wcnt > OMAP2_MCSPI_MAX_FIFOWCNT)
+			return;
+
+		mcspi->fifo_depth = cd->fifo_depth;
+
+		level = (t->len < mcspi->fifo_depth ? t->len :
+			mcspi->fifo_depth) - 1;
+
+		mcspi_write_reg(master, OMAP2_MCSPI_XFERLEVEL,
+			((wcnt << 16) | (level << (is_read ? 8 : 0))));
+
+		chconf |= is_read ? OMAP2_MCSPI_CHCONF_FFER :
+			OMAP2_MCSPI_CHCONF_FFET;
+	} else {
+		mcspi->fifo_depth = 0;
+		chconf &= ~(is_read ? OMAP2_MCSPI_CHCONF_FFER :
+			OMAP2_MCSPI_CHCONF_FFET);
+	}
+
+	mcspi_write_chconf0(spi, chconf);
+}
+
 static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
 {
 	struct spi_master	*spi_cntrl = mcspi->master;
@@ -364,7 +425,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 {
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma  *mcspi_dma;
-	unsigned int		count;
+	unsigned int		count, dma_count;
 	u32			l;
 	int			elements = 0;
 	int			word_len, element_count;
@@ -372,6 +433,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 	count = xfer->len;
+	dma_count = xfer->len - ((mcspi->fifo_depth == 0) ? es : 0);
 	word_len = cs->word_len;
 	l = mcspi_cached_chconf0(spi);
 
@@ -385,16 +447,15 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	if (mcspi_dma->dma_rx) {
 		struct dma_async_tx_descriptor *tx;
 		struct scatterlist sg;
-		size_t len = xfer->len - es;
 
 		dmaengine_slave_config(mcspi_dma->dma_rx, &cfg);
 
-		if (l & OMAP2_MCSPI_CHCONF_TURBO)
-			len -= es;
+		if ((l & OMAP2_MCSPI_CHCONF_TURBO) && (mcspi->fifo_depth == 0))
+			dma_count -= es;
 
 		sg_init_table(&sg, 1);
 		sg_dma_address(&sg) = xfer->rx_dma;
-		sg_dma_len(&sg) = len;
+		sg_dma_len(&sg) = dma_count;
 
 		tx = dmaengine_prep_slave_sg(mcspi_dma->dma_rx, &sg, 1,
 				DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT |
@@ -414,6 +475,10 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 	wait_for_completion(&mcspi_dma->dma_rx_completion);
 	dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
 			 DMA_FROM_DEVICE);
+
+	if (mcspi->fifo_depth > 0)
+		return count;
+
 	omap2_mcspi_set_enable(spi, 0);
 
 	elements = element_count - 1;
@@ -475,7 +540,10 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	struct dma_slave_config	cfg;
 	enum dma_slave_buswidth width;
 	unsigned es;
+	u32			burst;
 	void __iomem		*chstat_reg;
+	void __iomem            *irqstat_reg;
+	int			wait_res;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
@@ -493,19 +561,27 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
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
 
@@ -513,18 +589,38 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
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
+			if (wait_res >= 0
+				&& (mcspi_wait_for_reg_bit(chstat_reg,
+					OMAP2_MCSPI_CHSTAT_EOT) < 0))
 				dev_err(&spi->dev, "EOT timed out\n");
 		}
 	}
@@ -740,6 +836,7 @@ static struct omap2_mcspi_device_config *omap2_mcspi_get_slave_ctrldata(
 {
 	struct omap2_mcspi_device_config *cd;
 	struct device_node *slave_np, *data_np = NULL;
+	u32 fifo_depth;
 
 	slave_np = spi->dev.of_node;
 	if (!slave_np) {
@@ -763,6 +860,11 @@ static struct omap2_mcspi_device_config *omap2_mcspi_get_slave_ctrldata(
 	if (of_find_property(data_np, "ti,spi-turbo-mode", NULL))
 		cd->turbo_mode = 1;
 
+	if (of_property_read_u32(data_np, "ti,spi-fifo-depth", &fifo_depth) == 0)
+		cd->fifo_depth = fifo_depth;
+	else
+		cd->fifo_depth = 0;
+
 	of_node_put(data_np);
 	return cd;
 }
@@ -900,6 +1002,17 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 		return -EINVAL;
 	}
 
+	if (cd && cd->fifo_depth > 0) {
+		int bytes_per_word =	(spi->bits_per_word <= 8)  ? 1 :
+					(spi->bits_per_word <= 16) ? 2 :
+					/*spi->bits_per_word <= 32*/ 4;
+		if ((cd->fifo_depth % bytes_per_word) != 0) {
+			dev_dbg(&spi->dev, "setup: invalid %u fifo depth\n",
+				cd->fifo_depth);
+			return -EINVAL;
+		}
+	}
+
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
 	if (!cs) {
@@ -991,7 +1104,7 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 	cs = spi->controller_state;
 	cd = spi->controller_data;
 
-	omap2_mcspi_set_enable(spi, 1);
+	omap2_mcspi_set_enable(spi, 0);
 	list_for_each_entry(t, &m->transfers, transfer_list) {
 		if (t->tx_buf == NULL && t->rx_buf == NULL && t->len) {
 			status = -EINVAL;
@@ -1039,6 +1152,12 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
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
@@ -1065,6 +1184,11 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
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
@@ -1085,6 +1209,9 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 
 	omap2_mcspi_set_enable(spi, 0);
 
+	if (mcspi->fifo_depth > 0 && t)
+		omap2_mcspi_set_fifo(spi, t, 0);
+
 	m->status = status;
 
 }
diff --git a/include/linux/platform_data/spi-omap2-mcspi.h b/include/linux/platform_data/spi-omap2-mcspi.h
index c100456..27d8ed9 100644
--- a/include/linux/platform_data/spi-omap2-mcspi.h
+++ b/include/linux/platform_data/spi-omap2-mcspi.h
@@ -21,6 +21,7 @@ struct omap2_mcspi_dev_attr {
 };
 
 struct omap2_mcspi_device_config {
+	unsigned short fifo_depth;
 	unsigned turbo_mode:1;
 
 	/* toggle chip select after every word */
-- 
1.7.0.4

