Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3CaQSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 12:18:17 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55484 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3CaQSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 12:18:15 -0400
X-Auth-Info: XiPbYTnK9m+1S7pNWXPJeXjDwy5spb3O0ApXz84NGK0=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, Vinod Koul <vinod.koul@intel.com>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 2/2] dmaengine: mpc512x: add slave sg and device control operations
Date: Sun, 31 Mar 2013 18:18:00 +0200
Message-Id: <1364746680-6564-2-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364746680-6564-1-git-send-email-agust@denx.de>
References: <1364746680-6564-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the driver to support slave sg operation.

For memory to memory transfers mpc_dma_execute() used to start
the transfer explicitely, for peripheral transfers the dma transfer
will be started on peripheral's request, so we only need to enable
peripheral's channel request in mpc_dma_execute().

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/dma/mpc512x_dma.c |  150 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 148 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index bc6c356..1c822b1 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -194,6 +194,9 @@ struct mpc_dma_chan {
 
 	/* Lock for this structure */
 	spinlock_t			lock;
+
+	/* Channel's peripheral fifo address */
+	dma_addr_t			per_paddr;
 };
 
 struct mpc_dma {
@@ -257,7 +260,9 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
 
 		prev->tcd->dlast_sga = mdesc->tcd_paddr;
 		prev->tcd->e_sg = 1;
-		mdesc->tcd->start = 1;
+		/* only start explicitly on MDDRC channel */
+		if (cid == 32)
+			mdesc->tcd->start = 1;
 
 		prev = mdesc;
 	}
@@ -269,7 +274,15 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
 
 	if (first != prev)
 		mdma->tcd[cid].e_sg = 1;
-	out_8(&mdma->regs->dmassrt, cid);
+
+	switch (cid) {
+	case 30:
+		out_8(&mdma->regs->dmaserq, cid);
+		break;
+	case 32:
+		out_8(&mdma->regs->dmassrt, cid);
+		break;
+	}
 }
 
 /* Handle interrupt on one half of DMA controller (32 channels) */
@@ -642,6 +655,136 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 	return &mdesc->desc;
 }
 
+static struct dma_async_tx_descriptor *mpc_dma_prep_slave_sg(
+		struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_transfer_direction direction,
+		unsigned long flags, void *context)
+{
+	struct mpc_dma *mdma = dma_chan_to_mpc_dma(chan);
+	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
+	struct mpc_dma_desc *mdesc = NULL;
+	struct mpc_dma_tcd *tcd;
+	unsigned long flags;
+	struct scatterlist *sg;
+	dma_addr_t dst, src;
+	size_t len;
+	int iter, i;
+
+	if (!list_empty(&mchan->active))
+		return NULL;
+
+	for_each_sg(sgl, sg, sg_len, i) {
+		spin_lock_irqsave(&mchan->lock, flags);
+
+		mdesc = list_first_entry(&mchan->free, struct mpc_dma_desc,
+					 node);
+		if (!mdesc) {
+			spin_unlock_irqrestore(&mchan->lock, flags);
+			/* try to free completed descriptors */
+			mpc_dma_process_completed(mdma);
+			return NULL;
+		}
+
+		list_del(&mdesc->node);
+
+		spin_unlock_irqrestore(&mchan->lock, flags);
+
+		mdesc->error = 0;
+		tcd = mdesc->tcd;
+
+		/* Prepare Transfer Control Descriptor for this transaction */
+		memset(tcd, 0, sizeof(struct mpc_dma_tcd));
+
+		if (direction == DMA_DEV_TO_MEM) {
+			dst = sg_dma_address(sg);
+			src = mchan->per_paddr;
+		} else if (direction == DMA_MEM_TO_DEV) {
+			dst = mchan->per_paddr;
+			src = sg_dma_address(sg);
+		} else {
+			return NULL;
+		}
+
+		len = sg_dma_len(sg);
+
+		if (direction == DMA_MEM_TO_DEV) {
+			tcd->saddr = sg_dma_address(sg);
+			tcd->daddr = mchan->per_paddr;
+			tcd->soff = 4;
+			tcd->doff = 0;
+		} else {
+			tcd->saddr = mchan->per_paddr;
+			tcd->daddr = sg_dma_address(sg);
+			tcd->soff = 0;
+			tcd->doff = 4;
+		}
+
+		tcd->ssize = MPC_DMA_TSIZE_4;
+		tcd->dsize = MPC_DMA_TSIZE_4;
+		tcd->nbytes = 64;
+
+		iter = sg_dma_len(sg) / 64;
+
+		/* citer_linkch contains the high bits of iter */
+		tcd->citer_linkch = iter >> 9;
+		tcd->biter_linkch = iter >> 9;
+		tcd->citer = iter & 0x1ff;
+		tcd->biter = iter & 0x1ff;
+
+		tcd->e_sg = 0;
+
+		if (i != (sg_len - 1)) {
+			struct scatterlist *s = sg_next(sg);
+
+			if (!s)
+				tcd->dlast_sga = sg_dma_address(s);
+			tcd->e_sg = 1;
+		} else {
+			tcd->d_req = 1;
+		}
+	}
+
+	/* Place descriptor in prepared list */
+	spin_lock_irqsave(&mchan->lock, flags);
+	list_add_tail(&mdesc->node, &mchan->prepared);
+	spin_unlock_irqrestore(&mchan->lock, flags);
+
+	return &mdesc->desc;
+}
+
+static int mpc_dma_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+				  unsigned long arg)
+{
+	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
+	struct mpc_dma *mdma = dma_chan_to_mpc_dma(chan);
+	struct dma_slave_config *cfg = (void *)arg;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		/* disable channel requests */
+		out_8(&mdma->regs->dmaserq, chan->chan_id);
+		list_splice_tail_init(&mchan->prepared, &mchan->free);
+		list_splice_tail_init(&mchan->queued, &mchan->free);
+		list_splice_tail_init(&mchan->active, &mchan->free);
+		return 0;
+	case DMA_SLAVE_CONFIG:
+		if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES &&
+		    cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)
+			return -EINVAL;
+
+		if (cfg->direction == DMA_DEV_TO_MEM)
+			mchan->per_paddr = cfg->src_addr;
+		else
+			mchan->per_paddr = cfg->dst_addr;
+
+		return 0;
+	default:
+		return -ENOSYS;
+	}
+
+	return -EINVAL;
+}
+
 struct mpc_dma_filter_args {
 	struct mpc_dma *mdma;
 	unsigned int chan_id;
@@ -764,9 +907,12 @@ static int mpc_dma_probe(struct platform_device *op)
 	dma->device_issue_pending = mpc_dma_issue_pending;
 	dma->device_tx_status = mpc_dma_tx_status;
 	dma->device_prep_dma_memcpy = mpc_dma_prep_memcpy;
+	dma->device_prep_slave_sg = mpc_dma_prep_slave_sg;
+	dma->device_control = mpc_dma_device_control;
 
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
+	dma_cap_set(DMA_SLAVE, dma->cap_mask);
 
 	for (i = 0; i < dma->chancnt; i++) {
 		mchan = &mdma->channels[i];
-- 
1.7.5.4

