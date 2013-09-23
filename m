Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3IWXGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:06:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49908 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab3IWXGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:06:09 -0400
From: Joel Fernandes <joelf@ti.com>
To: Matt Porter <matt@ohporter.com>, Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Jyri Sarha <jsarha@ti.com>,
        Lars Peter-Clausen <lars@metafoo.de>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 2/3] dma: edma: Add support for Cyclic DMA
Date: Mon, 23 Sep 2013 18:05:14 -0500
Message-ID: <1379977515-3794-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379977515-3794-1-git-send-email-joelf@ti.com>
References: <1379977515-3794-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the PaRAM configuration function that we split for reuse by the
different DMA types, we implement Cyclic DMA support.
For the cyclic case, we pass different configuration parameters to this
function, and handle all the Cyclic-specific functionality separately.

Callbacks to the DMA users are handled using vchan_cyclic_callback in
the virt-dma layer. Linking is handled the same way as the slave SG case
except for the last slot where we link it back to the first one in a
cyclic fashion.

For continuity, we check for cases where no.of periods is great than the
MAX number of slots the driver can allocate for a particular descriptor
and error out on such cases.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 151 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 725b00c..9b63e1e 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -54,6 +54,7 @@
 struct edma_desc {
 	struct virt_dma_desc		vdesc;
 	struct list_head		node;
+	int				cyclic;
 	int				absync;
 	int				pset_nr;
 	int				processed;
@@ -167,8 +168,13 @@ static void edma_execute(struct edma_chan *echan)
 	 * then setup a link to the dummy slot, this results in all future
 	 * events being absorbed and that's OK because we're done
 	 */
-	if (edesc->processed == edesc->pset_nr)
-		edma_link(echan->slot[nslots-1], echan->ecc->dummy_slot);
+	if (edesc->processed == edesc->pset_nr) {
+		if (edesc->cyclic)
+			edma_link(echan->slot[nslots-1], echan->slot[1]);
+		else
+			edma_link(echan->slot[nslots-1],
+				  echan->ecc->dummy_slot);
+	}
 
 	edma_resume(echan->ch_num);
 
@@ -449,6 +455,138 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
 }
 
+static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
+	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+	size_t period_len, enum dma_transfer_direction direction,
+	unsigned long tx_flags, void *context)
+{
+	struct edma_chan *echan = to_edma_chan(chan);
+	struct device *dev = chan->device->dev;
+	struct edma_desc *edesc;
+	dma_addr_t src_addr, dst_addr;
+	enum dma_slave_buswidth dev_width;
+	u32 burst;
+	int i, ret, nr_periods;
+
+	if (unlikely(!echan || !buf_len || !period_len))
+		return NULL;
+
+	if (direction == DMA_DEV_TO_MEM) {
+		src_addr = echan->cfg.src_addr;
+		dst_addr = buf_addr;
+		dev_width = echan->cfg.src_addr_width;
+		burst = echan->cfg.src_maxburst;
+	} else if (direction == DMA_MEM_TO_DEV) {
+		src_addr = buf_addr;
+		dst_addr = echan->cfg.dst_addr;
+		dev_width = echan->cfg.dst_addr_width;
+		burst = echan->cfg.dst_maxburst;
+	} else {
+		dev_err(dev, "%s: bad direction?\n", __func__);
+		return NULL;
+	}
+
+	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
+		dev_err(dev, "Undefined slave buswidth\n");
+		return NULL;
+	}
+
+	if (unlikely(buf_len % period_len)) {
+		dev_err(dev, "Period should be multiple of Buffer length\n");
+		return NULL;
+	}
+
+	nr_periods = (buf_len / period_len) + 1;
+
+	/*
+	 * Cyclic DMA users such as audio cannot tolerate delays introduced
+	 * by cases where the number of periods is more than the maximum
+	 * number of SGs the EDMA driver can handle at a time. For DMA types
+	 * such as Slave SGs, such delays are tolerable and synchronized,
+	 * but the synchronization is difficult to achieve with Cyclic and
+	 * cannot be guaranteed, so we error out early.
+	 */
+	if (nr_periods > MAX_NR_SG)
+		return NULL;
+
+	edesc = kzalloc(sizeof(*edesc) + nr_periods *
+		sizeof(edesc->pset[0]), GFP_ATOMIC);
+	if (!edesc) {
+		dev_dbg(dev, "Failed to allocate a descriptor\n");
+		return NULL;
+	}
+
+	edesc->cyclic = 1;
+	edesc->pset_nr = nr_periods;
+
+	dev_dbg(dev, "%s: nr_periods=%d\n", __func__, nr_periods);
+	dev_dbg(dev, "%s: period_len=%d\n", __func__, period_len);
+	dev_dbg(dev, "%s: buf_len=%d\n", __func__, buf_len);
+
+	for (i = 0; i < nr_periods; i++) {
+		/* Allocate a PaRAM slot, if needed */
+		if (echan->slot[i] < 0) {
+			echan->slot[i] =
+				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
+						EDMA_SLOT_ANY);
+			if (echan->slot[i] < 0) {
+				dev_err(dev, "Failed to allocate slot\n");
+				return NULL;
+			}
+		}
+
+		if (i == nr_periods - 1) {
+			memcpy(&edesc->pset[i], &edesc->pset[0],
+			       sizeof(edesc->pset[0]));
+			break;
+		}
+
+		ret = edma_config_pset(chan, &edesc->pset[i], src_addr,
+				       dst_addr, burst, dev_width, period_len,
+				       direction);
+		if (ret < 0)
+			return NULL;
+
+		if (direction == DMA_DEV_TO_MEM)
+			dst_addr += period_len;
+		else
+			src_addr += period_len;
+
+		dev_dbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
+		dev_dbg(dev,
+			"\n pset[%d]:\n"
+			"  chnum\t%d\n"
+			"  slot\t%d\n"
+			"  opt\t%08x\n"
+			"  src\t%08x\n"
+			"  dst\t%08x\n"
+			"  abcnt\t%08x\n"
+			"  ccnt\t%08x\n"
+			"  bidx\t%08x\n"
+			"  cidx\t%08x\n"
+			"  lkrld\t%08x\n",
+			i, echan->ch_num, echan->slot[i],
+			edesc->pset[i].opt,
+			edesc->pset[i].src,
+			edesc->pset[i].dst,
+			edesc->pset[i].a_b_cnt,
+			edesc->pset[i].ccnt,
+			edesc->pset[i].src_dst_bidx,
+			edesc->pset[i].src_dst_cidx,
+			edesc->pset[i].link_bcntrld);
+
+		edesc->absync = ret;
+
+		/*
+		 * Enable interrupts for every period because callback
+		 * has to be called for every period.
+		 */
+		edesc->pset[i].opt |= TCINTEN;
+	}
+
+	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
+}
+
 static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 {
 	struct edma_chan *echan = data;
@@ -457,24 +595,28 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 	unsigned long flags;
 	struct edmacc_param p;
 
-	/* Pause the channel */
-	edma_pause(echan->ch_num);
+	edesc = echan->edesc;
+
+	/* Pause the channel for non-cyclic */
+	if (!edesc || (edesc && !edesc->cyclic))
+		edma_pause(echan->ch_num);
 
 	switch (ch_status) {
 	case DMA_COMPLETE:
 		spin_lock_irqsave(&echan->vchan.lock, flags);
 
-		edesc = echan->edesc;
 		if (edesc) {
-			if (edesc->processed == edesc->pset_nr) {
+			if (edesc->cyclic) {
+				vchan_cyclic_callback(&edesc->vdesc);
+			} else if (edesc->processed == edesc->pset_nr) {
 				dev_dbg(dev, "Transfer complete, stopping channel %d\n", ch_num);
 				edma_stop(echan->ch_num);
 				vchan_cookie_complete(&edesc->vdesc);
+				edma_execute(echan);
 			} else {
 				dev_dbg(dev, "Intermediate transfer complete on channel %d\n", ch_num);
+				edma_execute(echan);
 			}
-
-			edma_execute(echan);
 		}
 
 		spin_unlock_irqrestore(&echan->vchan.lock, flags);
@@ -670,6 +812,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 			  struct device *dev)
 {
 	dma->device_prep_slave_sg = edma_prep_slave_sg;
+	dma->device_prep_dma_cyclic = edma_prep_dma_cyclic;
 	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
 	dma->device_free_chan_resources = edma_free_chan_resources;
 	dma->device_issue_pending = edma_issue_pending;
-- 
1.8.1.2

