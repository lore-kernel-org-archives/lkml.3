Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3GJKSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:18:55 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64469 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3GJKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:18:53 -0400
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [V2 1/2] powerpc: mpc512x_dma: add support for data transfers between memory and i/o memory
Date: Wed, 10 Jul 2013 14:20:51 +0400
Message-Id: <1373451651-20029-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data transfers between memory and i/o memory require more delicate TCD
(Transfer Control Descriptor) configuration and DMA channel service requests
via hardware.

dma_device.device_control callback function is needed to configure
DMA channel to work with i/o memory.

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 drivers/dma/mpc512x_dma.c | 147 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 140 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 2d95673..f90b717 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -2,6 +2,7 @@
  * Copyright (C) Freescale Semicondutor, Inc. 2007, 2008.
  * Copyright (C) Semihalf 2009
  * Copyright (C) Ilya Yanok, Emcraft Systems 2010
+ * Copyright (C) Alexander Popov, Promcontroller 2013
  *
  * Written by Piotr Ziecik <kosmo@semihalf.com>. Hardware description
  * (defines, structures and comments) was taken from MPC5121 DMA driver
@@ -28,11 +29,6 @@
  * file called COPYING.
  */
 
-/*
- * This is initial version of MPC5121 DMA driver. Only memory to memory
- * transfers are supported (tested using dmatest module).
- */
-
 #include <linux/module.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -190,9 +186,13 @@ struct mpc_dma_chan {
 	struct list_head		completed;
 	struct mpc_dma_tcd		*tcd;
 	dma_addr_t			tcd_paddr;
+	u32				tcd_nunits;
 
 	/* Lock for this structure */
 	spinlock_t			lock;
+
+	/* Channel's peripheral fifo address */
+	dma_addr_t			per_paddr;
 };
 
 struct mpc_dma {
@@ -256,7 +256,9 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
 
 		prev->tcd->dlast_sga = mdesc->tcd_paddr;
 		prev->tcd->e_sg = 1;
-		mdesc->tcd->start = 1;
+		/* only start explicitly on MDDRC channel */
+		if (cid == 32)
+			mdesc->tcd->start = 1;
 
 		prev = mdesc;
 	}
@@ -268,7 +270,15 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
 
 	if (first != prev)
 		mdma->tcd[cid].e_sg = 1;
-	out_8(&mdma->regs->dmassrt, cid);
+
+	switch (cid) {
+	case 26:
+		out_8(&mdma->regs->dmaserq, cid);
+		break;
+	case 32:
+		out_8(&mdma->regs->dmassrt, cid);
+		break;
+	}
 }
 
 /* Handle interrupt on one half of DMA controller (32 channels) */
@@ -641,6 +651,126 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
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
+	unsigned long iflags;
+	struct scatterlist *sg;
+	size_t len;
+	int iter, i;
+
+	if (!list_empty(&mchan->active))
+		return NULL;
+
+	for_each_sg(sgl, sg, sg_len, i) {
+		spin_lock_irqsave(&mchan->lock, iflags);
+
+		mdesc = list_first_entry(&mchan->free, struct mpc_dma_desc,
+									node);
+		if (!mdesc) {
+			spin_unlock_irqrestore(&mchan->lock, iflags);
+			/* try to free completed descriptors */
+			mpc_dma_process_completed(mdma);
+			return NULL;
+		}
+
+		list_del(&mdesc->node);
+
+		spin_unlock_irqrestore(&mchan->lock, iflags);
+
+		mdesc->error = 0;
+		tcd = mdesc->tcd;
+
+		/* Prepare Transfer Control Descriptor for this transaction */
+		memset(tcd, 0, sizeof(struct mpc_dma_tcd));
+
+		if (!IS_ALIGNED(sg_dma_address(sg), 4))
+			return NULL;
+
+		if (direction == DMA_DEV_TO_MEM) {
+			tcd->saddr = mchan->per_paddr;
+			tcd->daddr = sg_dma_address(sg);
+			tcd->soff = 0;
+			tcd->doff = 4;
+		} else if (direction == DMA_MEM_TO_DEV) {
+			tcd->saddr = sg_dma_address(sg);
+			tcd->daddr = mchan->per_paddr;
+			tcd->soff = 4;
+			tcd->doff = 0;
+		} else {
+			return NULL;
+		}
+		tcd->ssize = MPC_DMA_TSIZE_4;
+		tcd->dsize = MPC_DMA_TSIZE_4;
+
+		len = sg_dma_len(sg);
+
+		if (mchan->tcd_nunits)
+			tcd->nbytes = mchan->tcd_nunits * 4;
+		else
+			tcd->nbytes = 64;
+
+		if (!IS_ALIGNED(len, tcd->nbytes))
+			return NULL;
+
+		iter = len / tcd->nbytes;
+		if (iter > ((1 << 15) - 1)) {   /* maximum biter */
+			return NULL; /* len is too big */
+		} else {
+			/* citer_linkch contains the high bits of iter */
+			tcd->biter = iter & 0x1ff;
+			tcd->biter_linkch = iter >> 9;
+			tcd->citer = tcd->biter;
+			tcd->citer_linkch = tcd->biter_linkch;
+		}
+
+		tcd->e_sg = 0;
+		tcd->d_req = 1;
+
+		/* Place descriptor in prepared list */
+		spin_lock_irqsave(&mchan->lock, iflags);
+		list_add_tail(&mdesc->node, &mchan->prepared);
+		spin_unlock_irqrestore(&mchan->lock, iflags);
+	}
+
+	/* Return the last descriptor */
+	return &mdesc->desc;
+}
+
+static int mpc_dma_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+				  unsigned long arg)
+{
+	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
+	struct dma_slave_config *cfg = (void *)arg;
+
+	switch (cmd) {
+	case DMA_SLAVE_CONFIG:
+		if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES &&
+		    cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)
+			return -EINVAL;
+
+		if (cfg->direction == DMA_DEV_TO_MEM) {
+			mchan->per_paddr = cfg->src_addr;
+			mchan->tcd_nunits = cfg->src_maxburst;
+		} else {
+			mchan->per_paddr = cfg->dst_addr;
+			mchan->tcd_nunits = cfg->dst_maxburst;
+		}
+
+		return 0;
+	default:
+		return -ENOSYS;
+	}
+
+	return -EINVAL;
+}
+
 static int mpc_dma_probe(struct platform_device *op)
 {
 	struct device_node *dn = op->dev.of_node;
@@ -725,9 +855,12 @@ static int mpc_dma_probe(struct platform_device *op)
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
1.7.11.3

