Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865Ab3EAKXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:23:24 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:59587 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312Ab3EAKXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:23:19 -0400
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] powerpc: mpc512x_dma: add support for data transfers between memory and i/o memory
Date: Wed,  1 May 2013 15:28:09 +0400
Message-Id: <1367407689-16252-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial version of this driver supports only memory to memory
data transfers.

Data transfers between memory and i/o memory require more delicate TCD
(Transfer Control Descriptor) configuration and DMA channel service requests
via hardware.

dma_device.device_control callback function is needed to configure
DMA channel to work with i/o memory.

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 drivers/dma/mpc512x_dma.c | 230 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 192 insertions(+), 38 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 2d95673..8aedff1 100644
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
@@ -183,6 +179,8 @@ struct mpc_dma_desc {
 
 struct mpc_dma_chan {
 	struct dma_chan			chan;
+	enum dma_transfer_direction	dir;
+	enum dma_slave_buswidth		slave_reg_width;
 	struct list_head		free;
 	struct list_head		prepared;
 	struct list_head		queued;
@@ -190,6 +188,7 @@ struct mpc_dma_chan {
 	struct list_head		completed;
 	struct mpc_dma_tcd		*tcd;
 	dma_addr_t			tcd_paddr;
+	u32				tcd_nunits;
 
 	/* Lock for this structure */
 	spinlock_t			lock;
@@ -268,7 +267,11 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
 
 	if (first != prev)
 		mdma->tcd[cid].e_sg = 1;
-	out_8(&mdma->regs->dmassrt, cid);
+
+	if (first->tcd->biter != 1) /* Request channel service by... */
+		out_8(&mdma->regs->dmaserq, cid); /* hardware */
+	else
+		out_8(&mdma->regs->dmassrt, cid); /* software */
 }
 
 /* Handle interrupt on one half of DMA controller (32 channels) */
@@ -567,7 +570,42 @@ mpc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	return ret;
 }
 
-/* Prepare descriptor for memory to memory copy */
+static int mpc_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+						unsigned long arg)
+{
+	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
+	struct dma_slave_config *cfg = (void *)arg;
+	int ret = 0;
+
+	if (!chan)
+		return -EINVAL;
+
+	if (cmd == DMA_SLAVE_CONFIG && cfg) {
+		if (cfg->direction == DMA_DEV_TO_MEM) {
+			if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_UNDEFINED)
+				mchan->slave_reg_width = cfg->src_addr_width;
+			else
+				return -EINVAL;
+			mchan->dir = DMA_DEV_TO_MEM;
+			mchan->tcd_nunits = cfg->src_maxburst;
+		} else if (cfg->direction == DMA_MEM_TO_DEV) {
+			if (cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_UNDEFINED)
+				mchan->slave_reg_width = cfg->dst_addr_width;
+			else
+				return -EINVAL;
+			mchan->dir = DMA_MEM_TO_DEV;
+			mchan->tcd_nunits = cfg->dst_maxburst;
+		} else {
+			mchan->dir = DMA_MEM_TO_MEM;
+			mchan->slave_reg_width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
+			mchan->tcd_nunits = 0;
+		}
+	} else
+		return -ENOSYS;
+
+	return ret;
+}
+
 static struct dma_async_tx_descriptor *
 mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 					size_t len, unsigned long flags)
@@ -577,6 +615,7 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 	struct mpc_dma_desc *mdesc = NULL;
 	struct mpc_dma_tcd *tcd;
 	unsigned long iflags;
+	u32 iter = 0;
 
 	/* Get free descriptor */
 	spin_lock_irqsave(&mchan->lock, iflags);
@@ -599,39 +638,153 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 	/* Prepare Transfer Control Descriptor for this transaction */
 	memset(tcd, 0, sizeof(struct mpc_dma_tcd));
 
-	if (IS_ALIGNED(src | dst | len, 32)) {
-		tcd->ssize = MPC_DMA_TSIZE_32;
-		tcd->dsize = MPC_DMA_TSIZE_32;
-		tcd->soff = 32;
-		tcd->doff = 32;
-	} else if (!mdma->is_mpc8308 && IS_ALIGNED(src | dst | len, 16)) {
-		/* MPC8308 doesn't support 16 byte transfers */
-		tcd->ssize = MPC_DMA_TSIZE_16;
-		tcd->dsize = MPC_DMA_TSIZE_16;
-		tcd->soff = 16;
-		tcd->doff = 16;
-	} else if (IS_ALIGNED(src | dst | len, 4)) {
-		tcd->ssize = MPC_DMA_TSIZE_4;
-		tcd->dsize = MPC_DMA_TSIZE_4;
-		tcd->soff = 4;
-		tcd->doff = 4;
-	} else if (IS_ALIGNED(src | dst | len, 2)) {
-		tcd->ssize = MPC_DMA_TSIZE_2;
-		tcd->dsize = MPC_DMA_TSIZE_2;
-		tcd->soff = 2;
-		tcd->doff = 2;
-	} else {
-		tcd->ssize = MPC_DMA_TSIZE_1;
-		tcd->dsize = MPC_DMA_TSIZE_1;
-		tcd->soff = 1;
-		tcd->doff = 1;
-	}
-
 	tcd->saddr = src;
 	tcd->daddr = dst;
-	tcd->nbytes = len;
-	tcd->biter = 1;
-	tcd->citer = 1;
+	if (mchan->dir == DMA_MEM_TO_MEM) {
+		if (IS_ALIGNED(src | dst | len, 32)) {
+			tcd->ssize = MPC_DMA_TSIZE_32;
+			tcd->dsize = MPC_DMA_TSIZE_32;
+			tcd->soff = 32;
+			tcd->doff = 32;
+		} else if (!mdma->is_mpc8308 &&
+					IS_ALIGNED(src | dst | len, 16)) {
+			/* MPC8308 doesn't support 16 byte transfers */
+			tcd->ssize = MPC_DMA_TSIZE_16;
+			tcd->dsize = MPC_DMA_TSIZE_16;
+			tcd->soff = 16;
+			tcd->doff = 16;
+		} else if (IS_ALIGNED(src | dst | len, 4)) {
+			tcd->ssize = MPC_DMA_TSIZE_4;
+			tcd->dsize = MPC_DMA_TSIZE_4;
+			tcd->soff = 4;
+			tcd->doff = 4;
+		} else if (IS_ALIGNED(src | dst | len, 2)) {
+			tcd->ssize = MPC_DMA_TSIZE_2;
+			tcd->dsize = MPC_DMA_TSIZE_2;
+			tcd->soff = 2;
+			tcd->doff = 2;
+		} else {
+			tcd->ssize = MPC_DMA_TSIZE_1;
+			tcd->dsize = MPC_DMA_TSIZE_1;
+			tcd->soff = 1;
+			tcd->doff = 1;
+		}
+		tcd->nbytes = len;
+		tcd->biter = 1;
+		tcd->citer = 1;
+	} else {
+		/* Memory to io-memory transfer or vice versa.
+		 * DMA controller is going to access io-memory via
+		 * some FIFO data register. The width of this register
+		 * is mchan->slave_reg_width.
+		 *
+		 * Since some FIFO registers require full width access,
+		 * let's firmly set the corresponding transfer size
+		 * to mchan->slave_reg_width
+		 * and prohibit transfers of packets with a length
+		 * which is not aligned on mchan->slave_reg_width boundaries
+		 * to avoid Transfer Control Descriptor inconsistency.
+		 * Moreover this will save us from playing with
+		 * source and destination address modulo.
+		 */
+
+		if (!IS_ALIGNED(len, mchan->slave_reg_width))
+			return NULL;
+
+		if (mchan->dir == DMA_DEV_TO_MEM) {
+			tcd->soff = 0;
+			if (mchan->slave_reg_width ==
+					DMA_SLAVE_BUSWIDTH_4_BYTES) {
+				tcd->ssize = MPC_DMA_TSIZE_4;
+				if (IS_ALIGNED(dst, 4)) {
+					tcd->dsize = MPC_DMA_TSIZE_4;
+					tcd->doff = 4;
+				} else if (IS_ALIGNED(dst, 2)) {
+					tcd->dsize = MPC_DMA_TSIZE_2;
+					tcd->doff = 2;
+				} else {
+					tcd->dsize = MPC_DMA_TSIZE_1;
+					tcd->doff = 1;
+				}
+			} else if (mchan->slave_reg_width ==
+					DMA_SLAVE_BUSWIDTH_2_BYTES) {
+				tcd->ssize = MPC_DMA_TSIZE_2;
+				if (IS_ALIGNED(dst, 2)) {
+					tcd->dsize = MPC_DMA_TSIZE_2;
+					tcd->doff = 2;
+				} else {
+					tcd->dsize = MPC_DMA_TSIZE_1;
+					tcd->doff = 1;
+				}
+			} else if (mchan->slave_reg_width ==
+					DMA_SLAVE_BUSWIDTH_1_BYTE) {
+				tcd->ssize = MPC_DMA_TSIZE_1;
+				tcd->dsize = MPC_DMA_TSIZE_1;
+				tcd->doff = 1;
+			} else
+				return NULL;
+		} else {
+			tcd->doff = 0;
+			if (mchan->slave_reg_width ==
+					DMA_SLAVE_BUSWIDTH_4_BYTES) {
+				tcd->dsize = MPC_DMA_TSIZE_4;
+				if (IS_ALIGNED(src, 4)) {
+					tcd->ssize = MPC_DMA_TSIZE_4;
+					tcd->soff = 4;
+				} else if (IS_ALIGNED(src, 2)) {
+					tcd->ssize = MPC_DMA_TSIZE_2;
+					tcd->soff = 2;
+				} else {
+					tcd->ssize = MPC_DMA_TSIZE_1;
+					tcd->soff = 1;
+				}
+			} else if (mchan->slave_reg_width ==
+					DMA_SLAVE_BUSWIDTH_2_BYTES) {
+				tcd->dsize = MPC_DMA_TSIZE_2;
+				if (IS_ALIGNED(src, 2)) {
+					tcd->ssize = MPC_DMA_TSIZE_2;
+					tcd->soff = 2;
+				} else {
+					tcd->ssize = MPC_DMA_TSIZE_1;
+					tcd->soff = 1;
+				}
+			} else if (mchan->slave_reg_width ==
+					DMA_SLAVE_BUSWIDTH_1_BYTE) {
+				tcd->dsize = MPC_DMA_TSIZE_1;
+				tcd->ssize = MPC_DMA_TSIZE_1;
+				tcd->soff = 1;
+			} else
+				return NULL;
+		}
+
+		if (mchan->tcd_nunits) {
+			tcd->nbytes = mchan->tcd_nunits *
+						mchan->slave_reg_width;
+			if (!IS_ALIGNED(len, tcd->nbytes)) {
+				/* mchan->tcd_nunits is inconsistent */
+				return NULL;
+			}
+
+			iter = len / tcd->nbytes;
+			if (iter > ((1 << 15) - 1)) {	/* maximum biter */
+				return NULL; /* len is too big */
+			} else {
+				tcd->biter = iter;
+				tcd->biter_linkch = iter >> 9;
+				tcd->citer = tcd->biter;
+				tcd->citer_linkch = tcd->biter_linkch;
+			}
+
+			/* DMA hardware should automatically clear
+			 * the corresponding DMAERQ bit when
+			 * the current major iteration count reaches zero. */
+			tcd->d_req = 1;
+		} else {
+			tcd->nbytes = len;
+			tcd->biter = 1;
+			tcd->citer = 1;
+		}
+	}
 
 	/* Place descriptor in prepared list */
 	spin_lock_irqsave(&mchan->lock, iflags);
@@ -725,6 +878,7 @@ static int mpc_dma_probe(struct platform_device *op)
 	dma->device_issue_pending = mpc_dma_issue_pending;
 	dma->device_tx_status = mpc_dma_tx_status;
 	dma->device_prep_dma_memcpy = mpc_dma_prep_memcpy;
+	dma->device_control = mpc_dma_control;
 
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
-- 
1.7.11.3

