Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3H0Sc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:32:59 -0400
Received: from smtp-out-186.synserver.de ([212.40.185.186]:1073 "EHLO
	smtp-out-186.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3H0Scp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:32:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17590
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend] dma: pl330: Fix handling of TERMINATE_ALL while processing completed descriptors
Date: Tue, 27 Aug 2013 20:34:05 +0200
Message-Id: <1377628445-16231-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pl330 DMA driver is broken in regard to handling a terminate all request
while it is processing the list of completed descriptors. This is most visible
when calling dmaengine_terminate_all() from within the descriptors callback for
cyclic transfers. In this case the TERMINATE_ALL transfer will clear the
work_list and stop the transfer. But after all callbacks for all completed
descriptors have been handled the descriptors will be re-enqueued into the (now
empty) work_list. So the next time dma_async_issue_pending() is called for the
channel these descriptors will be transferred again which will cause data
corruption. Similar issues can occur if dmaengine_terminate_all() is not called
from within the descriptor callback but runs on a different CPU at the same time
as the completed descriptor list is processed.

This patch introduces a new per channel list which will hold the completed
descriptors. While processing the list the channel's lock will be held to avoid
racing against dmaengine_terminate_all(). The lock will be released when calling
the descriptors callback though. Since the list of completed descriptors might
be modified (e.g. by calling dmaengine_terminate_all() from the callback) we can
not use the normal list iterator macros. Instead we'll need to check for each
loop iteration again if there are still items in the list. The drivers
TERMINATE_ALL implementation is updated to move descriptors from both the
work_list as well the new completed_list back to the descriptor pool. This makes
sure that none of the descripts finds its way back into the work list and also
that we do not call any futher complete callbacks after
dmaengine_terminate_all() has been called.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/pl330.c | 111 ++++++++++++++++++----------------------------------
 1 file changed, 39 insertions(+), 72 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 33186fd..36ed301 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -545,6 +545,8 @@ struct dma_pl330_chan {
 
 	/* List of to be xfered descriptors */
 	struct list_head work_list;
+	/* List of completed descriptors */
+	struct list_head completed_list;
 
 	/* Pointer to the DMAC that manages this channel,
 	 * NULL if the channel is available to be acquired.
@@ -2198,66 +2200,6 @@ to_desc(struct dma_async_tx_descriptor *tx)
 	return container_of(tx, struct dma_pl330_desc, txd);
 }
 
-static inline void free_desc_list(struct list_head *list)
-{
-	struct dma_pl330_dmac *pdmac;
-	struct dma_pl330_desc *desc;
-	struct dma_pl330_chan *pch = NULL;
-	unsigned long flags;
-
-	/* Finish off the work list */
-	list_for_each_entry(desc, list, node) {
-		dma_async_tx_callback callback;
-		void *param;
-
-		/* All desc in a list belong to same channel */
-		pch = desc->pchan;
-		callback = desc->txd.callback;
-		param = desc->txd.callback_param;
-
-		if (callback)
-			callback(param);
-
-		desc->pchan = NULL;
-	}
-
-	/* pch will be unset if list was empty */
-	if (!pch)
-		return;
-
-	pdmac = pch->dmac;
-
-	spin_lock_irqsave(&pdmac->pool_lock, flags);
-	list_splice_tail_init(list, &pdmac->desc_pool);
-	spin_unlock_irqrestore(&pdmac->pool_lock, flags);
-}
-
-static inline void handle_cyclic_desc_list(struct list_head *list)
-{
-	struct dma_pl330_desc *desc;
-	struct dma_pl330_chan *pch = NULL;
-	unsigned long flags;
-
-	list_for_each_entry(desc, list, node) {
-		dma_async_tx_callback callback;
-
-		/* Change status to reload it */
-		desc->status = PREP;
-		pch = desc->pchan;
-		callback = desc->txd.callback;
-		if (callback)
-			callback(desc->txd.callback_param);
-	}
-
-	/* pch will be unset if list was empty */
-	if (!pch)
-		return;
-
-	spin_lock_irqsave(&pch->lock, flags);
-	list_splice_tail_init(list, &pch->work_list);
-	spin_unlock_irqrestore(&pch->lock, flags);
-}
-
 static inline void fill_queue(struct dma_pl330_chan *pch)
 {
 	struct dma_pl330_desc *desc;
@@ -2291,7 +2233,6 @@ static void pl330_tasklet(unsigned long data)
 	struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
 	struct dma_pl330_desc *desc, *_dt;
 	unsigned long flags;
-	LIST_HEAD(list);
 
 	spin_lock_irqsave(&pch->lock, flags);
 
@@ -2300,7 +2241,7 @@ static void pl330_tasklet(unsigned long data)
 		if (desc->status == DONE) {
 			if (!pch->cyclic)
 				dma_cookie_complete(&desc->txd);
-			list_move_tail(&desc->node, &list);
+			list_move_tail(&desc->node, &pch->completed_list);
 		}
 
 	/* Try to submit a req imm. next to the last completed cookie */
@@ -2309,12 +2250,31 @@ static void pl330_tasklet(unsigned long data)
 	/* Make sure the PL330 Channel thread is active */
 	pl330_chan_ctrl(pch->pl330_chid, PL330_OP_START);
 
-	spin_unlock_irqrestore(&pch->lock, flags);
+	while (!list_empty(&pch->completed_list)) {
+		dma_async_tx_callback callback;
+		void *callback_param;
 
-	if (pch->cyclic)
-		handle_cyclic_desc_list(&list);
-	else
-		free_desc_list(&list);
+		desc = list_first_entry(&pch->completed_list,
+					struct dma_pl330_desc, node);
+
+		callback = desc->txd.callback;
+		callback_param = desc->txd.callback_param;
+
+		if (pch->cyclic) {
+			desc->status = PREP;
+			list_move_tail(&desc->node, &pch->work_list);
+		} else {
+			desc->status = FREE;
+			list_move_tail(&desc->node, &pch->dmac->desc_pool);
+		}
+
+		if (callback) {
+			spin_unlock_irqrestore(&pch->lock, flags);
+			callback(callback_param);
+			spin_lock_irqsave(&pch->lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&pch->lock, flags);
 }
 
 static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
@@ -2409,7 +2369,7 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
 static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned long arg)
 {
 	struct dma_pl330_chan *pch = to_pchan(chan);
-	struct dma_pl330_desc *desc, *_dt;
+	struct dma_pl330_desc *desc;
 	unsigned long flags;
 	struct dma_pl330_dmac *pdmac = pch->dmac;
 	struct dma_slave_config *slave_config;
@@ -2423,12 +2383,18 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 		pl330_chan_ctrl(pch->pl330_chid, PL330_OP_FLUSH);
 
 		/* Mark all desc done */
-		list_for_each_entry_safe(desc, _dt, &pch->work_list , node) {
-			desc->status = DONE;
-			list_move_tail(&desc->node, &list);
+		list_for_each_entry(desc, &pch->work_list , node) {
+			desc->status = FREE;
+			dma_cookie_complete(&desc->txd);
+		}
+
+		list_for_each_entry(desc, &pch->completed_list , node) {
+			desc->status = FREE;
+			dma_cookie_complete(&desc->txd);
 		}
 
-		list_splice_tail_init(&list, &pdmac->desc_pool);
+		list_splice_tail_init(&pch->work_list, &pdmac->desc_pool);
+		list_splice_tail_init(&pch->completed_list, &pdmac->desc_pool);
 		spin_unlock_irqrestore(&pch->lock, flags);
 		break;
 	case DMA_SLAVE_CONFIG:
@@ -3005,6 +2971,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 			pch->chan.private = adev->dev.of_node;
 
 		INIT_LIST_HEAD(&pch->work_list);
+		INIT_LIST_HEAD(&pch->completed_list);
 		spin_lock_init(&pch->lock);
 		pch->pl330_chid = NULL;
 		pch->chan.device = pd;
-- 
1.8.0

