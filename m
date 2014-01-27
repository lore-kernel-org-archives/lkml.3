Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaA0OYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:24:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:41910 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaA0OYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:24:11 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <jouko.haapaluoma@wapice.com>
CC: <Sami.Pietikainen@wapice.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <vinod.koul@intel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] dmaengine: at_hdmac: run callback function with no lock held nor interrupts disabled
Date: Mon, 27 Jan 2014 15:23:24 +0100
Message-ID: <82e722d2f2af0bff5f5959c050e7724e69a8bc0f.1390832343.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1390832343.git.nicolas.ferre@atmel.com>
References: <cover.1390832343.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, submission from callbacks are permitted as per dmaengine framework. So we
shouldn't hold any spinlock nor disable IRQs while calling callbacks.
As locks were taken by parent routines, spin_lock_irqsave() has to be called
inside all routines, wherever they are required.

The little used atc_issue_pending() function is made void.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c | 121 +++++++++++++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 50 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index b28759b6d1ca..f7bf4065636c 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -268,10 +268,14 @@ static struct at_desc *atc_get_current_descriptors(struct at_dma_chan *atchan,
 static int atc_get_bytes_left(struct dma_chan *chan)
 {
 	struct at_dma_chan      *atchan = to_at_dma_chan(chan);
-	struct at_desc *desc_first = atc_first_active(atchan);
+	struct at_desc *desc_first;
 	struct at_desc *desc_cur;
+	unsigned long flags;
 	int ret = 0, count = 0;
 
+	spin_lock_irqsave(&atchan->lock, flags);
+	desc_first = atc_first_active(atchan);
+
 	/*
 	 * Initialize necessary values in the first time.
 	 * remain_desc record remain desc length.
@@ -311,6 +315,7 @@ static int atc_get_bytes_left(struct dma_chan *chan)
 	}
 
 out:
+	spin_unlock_irqrestore(&atchan->lock, flags);
 	return ret;
 }
 
@@ -318,12 +323,14 @@ out:
  * atc_chain_complete - finish work for one transaction chain
  * @atchan: channel we work on
  * @desc: descriptor at the head of the chain we want do complete
- *
- * Called with atchan->lock held and bh disabled */
+ */
 static void
 atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 {
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
+	unsigned long			flags;
+
+	spin_lock_irqsave(&atchan->lock, flags);
 
 	dev_vdbg(chan2dev(&atchan->chan_common),
 		"descriptor %u complete\n", txd->cookie);
@@ -337,6 +344,8 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	/* move myself to free_list */
 	list_move(&desc->desc_node, &atchan->free_list);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	dma_descriptor_unmap(txd);
 	/* for cyclic transfers,
 	 * no need to replay callback function while stopping */
@@ -344,10 +353,6 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 		dma_async_tx_callback	callback = txd->callback;
 		void			*param = txd->callback_param;
 
-		/*
-		 * The API requires that no submissions are done from a
-		 * callback, so we don't need to drop the lock here
-		 */
 		if (callback)
 			callback(param);
 	}
@@ -362,15 +367,17 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
  * Eventually submit queued descriptors if any
  *
  * Assume channel is idle while calling this function
- * Called with atchan->lock held and bh disabled
  */
 static void atc_complete_all(struct at_dma_chan *atchan)
 {
 	struct at_desc *desc, *_desc;
 	LIST_HEAD(list);
+	unsigned long flags;
 
 	dev_vdbg(chan2dev(&atchan->chan_common), "complete all\n");
 
+	spin_lock_irqsave(&atchan->lock, flags);
+
 	/*
 	 * Submit queued descriptors ASAP, i.e. before we go through
 	 * the completed ones.
@@ -382,6 +389,8 @@ static void atc_complete_all(struct at_dma_chan *atchan)
 	/* empty queue list by moving descriptors (if any) to active_list */
 	list_splice_init(&atchan->queue, &atchan->active_list);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		atc_chain_complete(atchan, desc);
 }
@@ -389,23 +398,35 @@ static void atc_complete_all(struct at_dma_chan *atchan)
 /**
  * atc_advance_work - at the end of a transaction, move forward
  * @atchan: channel where the transaction ended
- *
- * Called with atchan->lock held and bh disabled
  */
 static void atc_advance_work(struct at_dma_chan *atchan)
 {
+	unsigned long	flags;
+
 	dev_vdbg(chan2dev(&atchan->chan_common), "advance_work\n");
 
-	if (atc_chan_is_enabled(atchan))
+	spin_lock_irqsave(&atchan->lock, flags);
+
+	if (atc_chan_is_enabled(atchan)) {
+		spin_unlock_irqrestore(&atchan->lock, flags);
 		return;
+	}
 
 	if (list_empty(&atchan->active_list) ||
 	    list_is_singular(&atchan->active_list)) {
+		spin_unlock_irqrestore(&atchan->lock, flags);
 		atc_complete_all(atchan);
 	} else {
-		atc_chain_complete(atchan, atc_first_active(atchan));
+		struct at_desc *desc_first = atc_first_active(atchan);
+
+		spin_unlock_irqrestore(&atchan->lock, flags);
+		atc_chain_complete(atchan, desc_first);
+		barrier();
 		/* advance work */
-		atc_dostart(atchan, atc_first_active(atchan));
+		spin_lock_irqsave(&atchan->lock, flags);
+		desc_first = atc_first_active(atchan);
+		atc_dostart(atchan, desc_first);
+		spin_unlock_irqrestore(&atchan->lock, flags);
 	}
 }
 
@@ -413,13 +434,14 @@ static void atc_advance_work(struct at_dma_chan *atchan)
 /**
  * atc_handle_error - handle errors reported by DMA controller
  * @atchan: channel where error occurs
- *
- * Called with atchan->lock held and bh disabled
  */
 static void atc_handle_error(struct at_dma_chan *atchan)
 {
 	struct at_desc *bad_desc;
 	struct at_desc *child;
+	unsigned long flags;
+
+	spin_lock_irqsave(&atchan->lock, flags);
 
 	/*
 	 * The descriptor currently at the head of the active list is
@@ -452,6 +474,8 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
 		atc_dump_lli(atchan, &child->lli);
 
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
 	/* Pretend the descriptor completed successfully */
 	atc_chain_complete(atchan, bad_desc);
 }
@@ -459,19 +483,27 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 /**
  * atc_handle_cyclic - at the end of a period, run callback function
  * @atchan: channel used for cyclic operations
- *
- * Called with atchan->lock held and bh disabled
  */
 static void atc_handle_cyclic(struct at_dma_chan *atchan)
 {
-	struct at_desc			*first = atc_first_active(atchan);
-	struct dma_async_tx_descriptor	*txd = &first->txd;
-	dma_async_tx_callback		callback = txd->callback;
-	void				*param = txd->callback_param;
+	struct at_desc			*first;
+	struct dma_async_tx_descriptor	*txd;
+	dma_async_tx_callback		callback;
+	void				*param;
+	u32				dscr;
+	unsigned long			flags;
+
+	spin_lock_irqsave(&atchan->lock, flags);
+	first = atc_first_active(atchan);
+	dscr = channel_readl(atchan, DSCR);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
+	txd = &first->txd;
+	callback = txd->callback;
+	param = txd->callback_param;
 
 	dev_vdbg(chan2dev(&atchan->chan_common),
-			"new cyclic period llp 0x%08x\n",
-			channel_readl(atchan, DSCR));
+			"new cyclic period llp 0x%08x\n", dscr);
 
 	if (callback)
 		callback(param);
@@ -482,17 +514,13 @@ static void atc_handle_cyclic(struct at_dma_chan *atchan)
 static void atc_tasklet(unsigned long data)
 {
 	struct at_dma_chan *atchan = (struct at_dma_chan *)data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&atchan->lock, flags);
 	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
 		atc_handle_error(atchan);
 	else if (atc_chan_is_cyclic(atchan))
 		atc_handle_cyclic(atchan);
 	else
 		atc_advance_work(atchan);
-
-	spin_unlock_irqrestore(&atchan->lock, flags);
 }
 
 static irqreturn_t at_dma_interrupt(int irq, void *dev_id)
@@ -1013,6 +1041,11 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		spin_unlock_irqrestore(&atchan->lock, flags);
 	} else if (cmd == DMA_TERMINATE_ALL) {
 		struct at_desc	*desc, *_desc;
+
+		/* Disable interrupts */
+		atc_disable_chan_irq(atdma, chan->chan_id);
+		tasklet_disable(&atchan->tasklet);
+
 		/*
 		 * This is only called when something went wrong elsewhere, so
 		 * we don't really care about the data. Just disable the
@@ -1033,14 +1066,22 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		list_splice_init(&atchan->active_list, &list);
 
 		/* Flush all pending and queued descriptors */
-		list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		list_for_each_entry_safe(desc, _desc, &list, desc_node) {
+			spin_unlock_irqrestore(&atchan->lock, flags);
 			atc_chain_complete(atchan, desc);
+			spin_lock_irqsave(&atchan->lock, flags);
+		}
 
 		clear_bit(ATC_IS_PAUSED, &atchan->status);
 		/* if channel dedicated to cyclic operations, free it */
 		clear_bit(ATC_IS_CYCLIC, &atchan->status);
 
 		spin_unlock_irqrestore(&atchan->lock, flags);
+
+		/* Re-enable channel for future operations */
+		tasklet_enable(&atchan->tasklet);
+		atc_enable_chan_irq(atdma, chan->chan_id);
+
 	} else if (cmd == DMA_SLAVE_CONFIG) {
 		return set_runtime_config(chan, (struct dma_slave_config *)arg);
 	} else {
@@ -1065,8 +1106,6 @@ atc_tx_status(struct dma_chan *chan,
 		dma_cookie_t cookie,
 		struct dma_tx_state *txstate)
 {
-	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
-	unsigned long		flags;
 	enum dma_status		ret;
 	int bytes = 0;
 
@@ -1080,13 +1119,9 @@ atc_tx_status(struct dma_chan *chan,
 	if (!txstate)
 		return DMA_ERROR;
 
-	spin_lock_irqsave(&atchan->lock, flags);
-
 	/*  Get number of bytes left in the active transactions */
 	bytes = atc_get_bytes_left(chan);
 
-	spin_unlock_irqrestore(&atchan->lock, flags);
-
 	if (unlikely(bytes < 0)) {
 		dev_vdbg(chan2dev(chan), "get residual bytes error\n");
 		return DMA_ERROR;
@@ -1101,24 +1136,10 @@ atc_tx_status(struct dma_chan *chan,
 }
 
 /**
- * atc_issue_pending - try to finish work
+ * atc_issue_pending - void function
  * @chan: target DMA channel
  */
-static void atc_issue_pending(struct dma_chan *chan)
-{
-	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
-	unsigned long		flags;
-
-	dev_vdbg(chan2dev(chan), "issue_pending\n");
-
-	/* Not needed for cyclic transfers */
-	if (atc_chan_is_cyclic(atchan))
-		return;
-
-	spin_lock_irqsave(&atchan->lock, flags);
-	atc_advance_work(atchan);
-	spin_unlock_irqrestore(&atchan->lock, flags);
-}
+static void atc_issue_pending(struct dma_chan *chan) {}
 
 /**
  * atc_alloc_chan_resources - allocate resources for DMA channel
-- 
1.8.2.2

