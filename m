Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3FVUoF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:44:05 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62261 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3FVUna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:30 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH v2 07/12] dmaengine: PL08x: Add cyclic transfer support
Date: Sat, 22 Jun 2013 22:42:39 +0200
Message-Id: <1371933764-24875-8-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Bedel <alban.bedel@avionic-design.de>

Many audio interface drivers require support of cyclic transfers to work
correctly, for example Samsung ASoC DMA driver. This patch adds support
for cyclic transfers to the amba-pl08x driver.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
[tfiga: Rebase and slightly beautify the original patch.]
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 147 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 118 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 1eeb911..a3a86dd 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -181,6 +181,7 @@ struct pl08x_sg {
  * @ccfg: config reg values for current txd
  * @done: this marks completed descriptors, which should not have their
  *   mux released.
+ * @cyclic: indicate cyclic transfers
  */
 struct pl08x_txd {
 	struct virt_dma_desc vd;
@@ -195,6 +196,7 @@ struct pl08x_txd {
 	 */
 	u32 ccfg;
 	bool done;
+	bool cyclic;
 };
 
 /**
@@ -563,9 +565,9 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 			bytes += get_bytes_in_cctl(llis_va[PL080_LLI_CCTL]);
 
 		/*
-		 * A LLI pointer of 0 terminates the LLI list
+		 * A LLI pointer going backward terminates the LLI list
 		 */
-		if (!llis_va[PL080_LLI_LLI])
+		if (llis_va[PL080_LLI_LLI] <= clli)
 			break;
 	}
 
@@ -1076,10 +1078,16 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 	llis_va = txd->llis_va;
 	last_lli = llis_va + (num_llis - 1) * pl08x->lli_words;
-	/* The final LLI terminates the LLI. */
-	last_lli[PL080_LLI_LLI] = 0;
-	/* The final LLI element shall also fire an interrupt. */
-	last_lli[PL080_LLI_CCTL] |= PL080_CONTROL_TC_IRQ_EN;
+
+	if (txd->cyclic) {
+		/* Link back to the first LLI. */
+		last_lli[PL080_LLI_LLI] = txd->llis_bus | bd.lli_bus;
+	} else {
+		/* The final LLI terminates the LLI. */
+		last_lli[PL080_LLI_LLI] = 0;
+		/* The final LLI element shall also fire an interrupt. */
+		last_lli[PL080_LLI_CCTL] |= PL080_CONTROL_TC_IRQ_EN;
+	}
 
 #ifdef VERBOSE_DEBUG
 	{
@@ -1472,25 +1480,19 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 	return vchan_tx_prep(&plchan->vc, &txd->vd, flags);
 }
 
-static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
-		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_transfer_direction direction,
-		unsigned long flags, void *context)
+static struct pl08x_txd *pl08x_init_txd(
+		struct dma_chan *chan,
+		enum dma_transfer_direction direction,
+		dma_addr_t *slave_addr)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_txd *txd;
-	struct pl08x_sg *dsg;
-	struct scatterlist *sg;
 	enum dma_slave_buswidth addr_width;
-	dma_addr_t slave_addr;
 	int ret, tmp;
 	u8 src_buses, dst_buses;
 	u32 maxburst, cctl;
 
-	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from %s\n",
-			__func__, sg_dma_len(sgl), plchan->name);
-
 	txd = pl08x_get_txd(plchan);
 	if (!txd) {
 		dev_err(&pl08x->adev->dev, "%s no txd\n", __func__);
@@ -1504,14 +1506,14 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	 */
 	if (direction == DMA_MEM_TO_DEV) {
 		cctl = PL080_CONTROL_SRC_INCR;
-		slave_addr = plchan->cfg.dst_addr;
+		*slave_addr = plchan->cfg.dst_addr;
 		addr_width = plchan->cfg.dst_addr_width;
 		maxburst = plchan->cfg.dst_maxburst;
 		src_buses = pl08x->mem_buses;
 		dst_buses = plchan->cd->periph_buses;
 	} else if (direction == DMA_DEV_TO_MEM) {
 		cctl = PL080_CONTROL_DST_INCR;
-		slave_addr = plchan->cfg.src_addr;
+		*slave_addr = plchan->cfg.src_addr;
 		addr_width = plchan->cfg.src_addr_width;
 		maxburst = plchan->cfg.src_maxburst;
 		src_buses = plchan->cd->periph_buses;
@@ -1560,24 +1562,107 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	else
 		txd->ccfg |= plchan->signal << PL080_CONFIG_SRC_SEL_SHIFT;
 
+	return txd;
+}
+
+static int pl08x_tx_add_sg(struct pl08x_txd *txd,
+			   enum dma_transfer_direction direction,
+			   dma_addr_t slave_addr,
+			   dma_addr_t buf_addr,
+			   unsigned int len)
+{
+	struct pl08x_sg *dsg;
+
+	dsg = kzalloc(sizeof(struct pl08x_sg), GFP_NOWAIT);
+	if (!dsg)
+		return -ENOMEM;
+
+	list_add_tail(&dsg->node, &txd->dsg_list);
+
+	dsg->len = len;
+	if (direction == DMA_MEM_TO_DEV) {
+		dsg->src_addr = buf_addr;
+		dsg->dst_addr = slave_addr;
+	} else {
+		dsg->src_addr = slave_addr;
+		dsg->dst_addr = buf_addr;
+	}
+
+	return 0;
+}
+
+static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_transfer_direction direction,
+		unsigned long flags, void *context)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+	struct pl08x_txd *txd;
+	struct scatterlist *sg;
+	int ret, tmp;
+	dma_addr_t slave_addr;
+
+	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from %s\n",
+			__func__, sg_dma_len(sgl), plchan->name);
+
+	txd = pl08x_init_txd(chan, direction, &slave_addr);
+	if (!txd)
+		return NULL;
+
 	for_each_sg(sgl, sg, sg_len, tmp) {
-		dsg = kzalloc(sizeof(struct pl08x_sg), GFP_NOWAIT);
-		if (!dsg) {
+		ret = pl08x_tx_add_sg(txd, direction, slave_addr,
+				      sg_dma_address(sg),
+				      sg_dma_len(sg));
+		if (ret) {
 			pl08x_release_mux(plchan);
 			pl08x_free_txd(pl08x, txd);
 			dev_err(&pl08x->adev->dev, "%s no mem for pl080 sg\n",
 					__func__);
 			return NULL;
 		}
-		list_add_tail(&dsg->node, &txd->dsg_list);
+	}
 
-		dsg->len = sg_dma_len(sg);
-		if (direction == DMA_MEM_TO_DEV) {
-			dsg->src_addr = sg_dma_address(sg);
-			dsg->dst_addr = slave_addr;
-		} else {
-			dsg->src_addr = slave_addr;
-			dsg->dst_addr = sg_dma_address(sg);
+	ret = pl08x_fill_llis_for_desc(plchan->host, txd);
+	if (!ret) {
+		pl08x_release_mux(plchan);
+		pl08x_free_txd(pl08x, txd);
+		return NULL;
+	}
+
+	return vchan_tx_prep(&plchan->vc, &txd->vd, flags);
+}
+
+static struct dma_async_tx_descriptor *pl08x_prep_dma_cyclic(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_transfer_direction direction,
+		unsigned long flags, void *context)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+	struct pl08x_txd *txd;
+	int ret, tmp;
+	dma_addr_t slave_addr;
+
+	dev_dbg(&pl08x->adev->dev,
+		"%s prepare cyclic transaction of %d/%d bytes %s %s\n",
+		__func__, period_len, buf_len,
+		direction == DMA_MEM_TO_DEV ? "to" : "from",
+		plchan->name);
+
+	txd = pl08x_init_txd(chan, direction, &slave_addr);
+	if (!txd)
+		return NULL;
+
+	txd->cyclic = true;
+	txd->cctl |= PL080_CONTROL_TC_IRQ_EN;
+	for (tmp = 0; tmp < buf_len; tmp += period_len) {
+		ret = pl08x_tx_add_sg(txd, direction, slave_addr,
+				      buf_addr + tmp, period_len);
+		if (ret) {
+			pl08x_release_mux(plchan);
+			pl08x_free_txd(pl08x, txd);
+			return NULL;
 		}
 	}
 
@@ -1720,7 +1805,9 @@ static irqreturn_t pl08x_irq(int irq, void *dev)
 
 			spin_lock(&plchan->vc.lock);
 			tx = plchan->at;
-			if (tx) {
+			if (tx && tx->cyclic) {
+				vchan_cyclic_callback(&tx->vd);
+			} else if (tx) {
 				plchan->at = NULL;
 				/*
 				 * This descriptor is done, release its mux
@@ -1942,6 +2029,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	/* Initialize slave engine */
 	dma_cap_set(DMA_SLAVE, pl08x->slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, pl08x->slave.cap_mask);
 	pl08x->slave.dev = &adev->dev;
 	pl08x->slave.device_alloc_chan_resources = pl08x_alloc_chan_resources;
 	pl08x->slave.device_free_chan_resources = pl08x_free_chan_resources;
@@ -1949,6 +2037,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	pl08x->slave.device_tx_status = pl08x_dma_tx_status;
 	pl08x->slave.device_issue_pending = pl08x_issue_pending;
 	pl08x->slave.device_prep_slave_sg = pl08x_prep_slave_sg;
+	pl08x->slave.device_prep_dma_cyclic = pl08x_prep_dma_cyclic;
 	pl08x->slave.device_control = pl08x_control;
 
 	/* Get the platform data */
-- 
1.8.2.1

