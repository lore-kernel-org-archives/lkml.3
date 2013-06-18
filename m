Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab3FRThT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:37:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37253 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3FRThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:37:16 -0400
Date: Tue, 18 Jun 2013 14:36:26 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 2/11] rsxx: Restructured DMA cancel scheme.
Message-ID: <20130618193625.GC6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-3620-0000-0000-0000032D7CF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Before, DMAs would never be cancelled if there was a data stall
or an EEH Permenant failure which would cause an unrecoverable
I/O hang.

The DMA cancellation mechanism has been modified to fix
these issues and allows DMAs to be cancelled during the 
above mentioned events.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-06-17 16:42:07.984854270 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-06-17 16:43:34.334841997 -0500
@@ -368,15 +368,26 @@ static void rsxx_eeh_failure(struct pci_
 {
 	struct rsxx_cardinfo *card = pci_get_drvdata(dev);
 	int i;
+	int cnt = 0;
 
 	dev_err(&dev->dev, "IBM FlashSystem PCI: disabling failed card.\n");
 
 	card->eeh_state = 1;
+	card->halt = 1;
 
-	for (i = 0; i < card->n_targets; i++)
-		del_timer_sync(&card->ctrl[i].activity_timer);
-
-	rsxx_eeh_cancel_dmas(card);
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock_bh(&card->ctrl[i].queue_lock);
+		cnt = rsxx_cleanup_dma_queue(&card->ctrl[i],
+					     &card->ctrl[i].queue);
+		spin_unlock_bh(&card->ctrl[i].queue_lock);
+
+		cnt += rsxx_dma_cancel(&card->ctrl[i]);
+
+		if (cnt)
+			dev_info(CARD_TO_DEV(card),
+				"Freed %d queued DMAs on channel %d\n",
+				cnt, card->ctrl[i].id);
+	}
 }
 
 static int rsxx_eeh_fifo_flush_poll(struct rsxx_cardinfo *card)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dev.c linux-block/drivers/block/rsxx/dev.c
--- linux-block-vanilla/drivers/block/rsxx/dev.c	2013-06-14 09:06:56.253034309 -0500
+++ linux-block/drivers/block/rsxx/dev.c	2013-06-17 16:43:34.342956958 -0500
@@ -155,7 +155,8 @@ static void bio_dma_done_cb(struct rsxx_
 		atomic_set(&meta->error, 1);
 
 	if (atomic_dec_and_test(&meta->pending_dmas)) {
-		disk_stats_complete(card, meta->bio, meta->start_time);
+		if (!card->eeh_state && card->gendisk)
+			disk_stats_complete(card, meta->bio, meta->start_time);
 
 		bio_endio(meta->bio, atomic_read(&meta->error) ? -EIO : 0);
 		kmem_cache_free(bio_meta_pool, meta);
@@ -196,7 +197,8 @@ static void rsxx_make_request(struct req
 	atomic_set(&bio_meta->pending_dmas, 0);
 	bio_meta->start_time = jiffies;
 
-	disk_stats_start(card, bio);
+	if (!unlikely(card->halt))
+		disk_stats_start(card, bio);
 
 	dev_dbg(CARD_TO_DEV(card), "BIO[%c]: meta: %p addr8: x%llx size: %d\n",
 		 bio_data_dir(bio) ? 'W' : 'R', bio_meta,
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-06-17 16:41:26.357842319 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-06-17 16:44:37.987884428 -0500
@@ -245,6 +245,22 @@ static void rsxx_complete_dma(struct rsx
 	kmem_cache_free(rsxx_dma_pool, dma);
 }
 
+int rsxx_cleanup_dma_queue(struct rsxx_dma_ctrl *ctrl,
+			   struct list_head *q)
+{
+	struct rsxx_dma *dma;
+	struct rsxx_dma *tmp;
+	int cnt = 0;
+
+	list_for_each_entry_safe(dma, tmp, q, list) {
+		list_del(&dma->list);
+		rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
+		cnt++;
+	}
+
+	return cnt;
+}
+
 static void rsxx_requeue_dma(struct rsxx_dma_ctrl *ctrl,
 				 struct rsxx_dma *dma)
 {
@@ -252,9 +268,9 @@ static void rsxx_requeue_dma(struct rsxx
 	 * Requeued DMAs go to the front of the queue so they are issued
 	 * first.
 	 */
-	spin_lock(&ctrl->queue_lock);
+	spin_lock_bh(&ctrl->queue_lock);
 	list_add(&dma->list, &ctrl->queue);
-	spin_unlock(&ctrl->queue_lock);
+	spin_unlock_bh(&ctrl->queue_lock);
 }
 
 static void rsxx_handle_dma_error(struct rsxx_dma_ctrl *ctrl,
@@ -329,6 +345,7 @@ static void rsxx_handle_dma_error(struct
 static void dma_engine_stalled(unsigned long data)
 {
 	struct rsxx_dma_ctrl *ctrl = (struct rsxx_dma_ctrl *)data;
+	int cnt;
 
 	if (atomic_read(&ctrl->stats.hw_q_depth) == 0 ||
 	    unlikely(ctrl->card->eeh_state))
@@ -349,6 +366,18 @@ static void dma_engine_stalled(unsigned 
 			"DMA channel %d has stalled, faulting interface.\n",
 			ctrl->id);
 		ctrl->card->dma_fault = 1;
+
+		/* Clean up the DMA queue */
+		spin_lock(&ctrl->queue_lock);
+		cnt = rsxx_cleanup_dma_queue(ctrl, &ctrl->queue);
+		spin_unlock(&ctrl->queue_lock);
+
+		cnt += rsxx_dma_cancel(ctrl);
+
+		if (cnt)
+			dev_info(CARD_TO_DEV(ctrl->card),
+				"Freed %d queued DMAs on channel %d\n",
+				cnt, ctrl->id);
 	}
 }
 
@@ -368,22 +397,22 @@ static void rsxx_issue_dmas(struct work_
 		return;
 
 	while (1) {
-		spin_lock(&ctrl->queue_lock);
+		spin_lock_bh(&ctrl->queue_lock);
 		if (list_empty(&ctrl->queue)) {
-			spin_unlock(&ctrl->queue_lock);
+			spin_unlock_bh(&ctrl->queue_lock);
 			break;
 		}
-		spin_unlock(&ctrl->queue_lock);
+		spin_unlock_bh(&ctrl->queue_lock);
 
 		tag = pop_tracker(ctrl->trackers);
 		if (tag == -1)
 			break;
 
-		spin_lock(&ctrl->queue_lock);
+		spin_lock_bh(&ctrl->queue_lock);
 		dma = list_entry(ctrl->queue.next, struct rsxx_dma, list);
 		list_del(&dma->list);
 		ctrl->stats.sw_q_depth--;
-		spin_unlock(&ctrl->queue_lock);
+		spin_unlock_bh(&ctrl->queue_lock);
 
 		/*
 		 * This will catch any DMAs that slipped in right before the
@@ -520,33 +549,10 @@ static void rsxx_dma_done(struct work_st
 	rsxx_enable_ier(ctrl->card, CR_INTR_DMA(ctrl->id));
 	spin_unlock_irqrestore(&ctrl->card->irq_lock, flags);
 
-	spin_lock(&ctrl->queue_lock);
+	spin_lock_bh(&ctrl->queue_lock);
 	if (ctrl->stats.sw_q_depth)
 		queue_work(ctrl->issue_wq, &ctrl->issue_dma_work);
-	spin_unlock(&ctrl->queue_lock);
-}
-
-static int rsxx_cleanup_dma_queue(struct rsxx_cardinfo *card,
-				      struct list_head *q)
-{
-	struct rsxx_dma *dma;
-	struct rsxx_dma *tmp;
-	int cnt = 0;
-
-	list_for_each_entry_safe(dma, tmp, q, list) {
-		list_del(&dma->list);
-
-		if (dma->dma_addr)
-			pci_unmap_page(card->dev, dma->dma_addr,
-				       get_dma_size(dma),
-				       (dma->cmd == HW_CMD_BLK_WRITE) ?
-				       PCI_DMA_TODEVICE :
-				       PCI_DMA_FROMDEVICE);
-		kmem_cache_free(rsxx_dma_pool, dma);
-		cnt++;
-	}
-
-	return cnt;
+	spin_unlock_bh(&ctrl->queue_lock);
 }
 
 static int rsxx_queue_discard(struct rsxx_cardinfo *card,
@@ -698,10 +704,10 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 
 	for (i = 0; i < card->n_targets; i++) {
 		if (!list_empty(&dma_list[i])) {
-			spin_lock(&card->ctrl[i].queue_lock);
+			spin_lock_bh(&card->ctrl[i].queue_lock);
 			card->ctrl[i].stats.sw_q_depth += dma_cnt[i];
 			list_splice_tail(&dma_list[i], &card->ctrl[i].queue);
-			spin_unlock(&card->ctrl[i].queue_lock);
+			spin_unlock_bh(&card->ctrl[i].queue_lock);
 
 			queue_work(card->ctrl[i].issue_wq,
 				   &card->ctrl[i].issue_dma_work);
@@ -711,8 +717,11 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 	return 0;
 
 bvec_err:
-	for (i = 0; i < card->n_targets; i++)
-		rsxx_cleanup_dma_queue(card, &dma_list[i]);
+	for (i = 0; i < card->n_targets; i++) {
+		spin_lock_bh(&card->ctrl[i].queue_lock);
+		rsxx_cleanup_dma_queue(&card->ctrl[i], &dma_list[i]);
+		spin_unlock_bh(&card->ctrl[i].queue_lock);
+	}
 
 	return st;
 }
@@ -918,13 +927,30 @@ failed_dma_setup:
 	return st;
 }
 
+int rsxx_dma_cancel(struct rsxx_dma_ctrl *ctrl)
+{
+	struct rsxx_dma *dma;
+	int i;
+	int cnt = 0;
+
+	/* Clean up issued DMAs */
+	for (i = 0; i < RSXX_MAX_OUTSTANDING_CMDS; i++) {
+		dma = get_tracker_dma(ctrl->trackers, i);
+		if (dma) {
+			atomic_dec(&ctrl->stats.hw_q_depth);
+			rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
+			push_tracker(ctrl->trackers, i);
+			cnt++;
+		}
+	}
+
+	return cnt;
+}
 
 void rsxx_dma_destroy(struct rsxx_cardinfo *card)
 {
 	struct rsxx_dma_ctrl *ctrl;
-	struct rsxx_dma *dma;
-	int i, j;
-	int cnt = 0;
+	int i;
 
 	for (i = 0; i < card->n_targets; i++) {
 		ctrl = &card->ctrl[i];
@@ -943,33 +969,11 @@ void rsxx_dma_destroy(struct rsxx_cardin
 			del_timer_sync(&ctrl->activity_timer);
 
 		/* Clean up the DMA queue */
-		spin_lock(&ctrl->queue_lock);
-		cnt = rsxx_cleanup_dma_queue(card, &ctrl->queue);
-		spin_unlock(&ctrl->queue_lock);
+		spin_lock_bh(&ctrl->queue_lock);
+		rsxx_cleanup_dma_queue(ctrl, &ctrl->queue);
+		spin_unlock_bh(&ctrl->queue_lock);
 
-		if (cnt)
-			dev_info(CARD_TO_DEV(card),
-				"Freed %d queued DMAs on channel %d\n",
-				cnt, i);
-
-		/* Clean up issued DMAs */
-		for (j = 0; j < RSXX_MAX_OUTSTANDING_CMDS; j++) {
-			dma = get_tracker_dma(ctrl->trackers, j);
-			if (dma) {
-				pci_unmap_page(card->dev, dma->dma_addr,
-					       get_dma_size(dma),
-					       (dma->cmd == HW_CMD_BLK_WRITE) ?
-					       PCI_DMA_TODEVICE :
-					       PCI_DMA_FROMDEVICE);
-				kmem_cache_free(rsxx_dma_pool, dma);
-				cnt++;
-			}
-		}
-
-		if (cnt)
-			dev_info(CARD_TO_DEV(card),
-				"Freed %d pending DMAs on channel %d\n",
-				cnt, i);
+		rsxx_dma_cancel(ctrl);
 
 		vfree(ctrl->trackers);
 
@@ -1013,7 +1017,7 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 			cnt++;
 		}
 
-		spin_lock(&card->ctrl[i].queue_lock);
+		spin_lock_bh(&card->ctrl[i].queue_lock);
 		list_splice(&issued_dmas[i], &card->ctrl[i].queue);
 
 		atomic_sub(cnt, &card->ctrl[i].stats.hw_q_depth);
@@ -1028,7 +1032,7 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 					       PCI_DMA_TODEVICE :
 					       PCI_DMA_FROMDEVICE);
 		}
-		spin_unlock(&card->ctrl[i].queue_lock);
+		spin_unlock_bh(&card->ctrl[i].queue_lock);
 	}
 
 	kfree(issued_dmas);
@@ -1036,30 +1040,13 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 	return 0;
 }
 
-void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card)
-{
-	struct rsxx_dma *dma;
-	struct rsxx_dma *tmp;
-	int i;
-
-	for (i = 0; i < card->n_targets; i++) {
-		spin_lock(&card->ctrl[i].queue_lock);
-		list_for_each_entry_safe(dma, tmp, &card->ctrl[i].queue, list) {
-			list_del(&dma->list);
-
-			rsxx_complete_dma(&card->ctrl[i], dma, DMA_CANCELLED);
-		}
-		spin_unlock(&card->ctrl[i].queue_lock);
-	}
-}
-
 int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card)
 {
 	struct rsxx_dma *dma;
 	int i;
 
 	for (i = 0; i < card->n_targets; i++) {
-		spin_lock(&card->ctrl[i].queue_lock);
+		spin_lock_bh(&card->ctrl[i].queue_lock);
 		list_for_each_entry(dma, &card->ctrl[i].queue, list) {
 			dma->dma_addr = pci_map_page(card->dev, dma->page,
 					dma->pg_off, get_dma_size(dma),
@@ -1067,12 +1054,12 @@ int rsxx_eeh_remap_dmas(struct rsxx_card
 					PCI_DMA_TODEVICE :
 					PCI_DMA_FROMDEVICE);
 			if (!dma->dma_addr) {
-				spin_unlock(&card->ctrl[i].queue_lock);
+				spin_unlock_bh(&card->ctrl[i].queue_lock);
 				kmem_cache_free(rsxx_dma_pool, dma);
 				return -ENOMEM;
 			}
 		}
-		spin_unlock(&card->ctrl[i].queue_lock);
+		spin_unlock_bh(&card->ctrl[i].queue_lock);
 	}
 
 	return 0;
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-06-17 16:42:07.998053105 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-06-17 16:43:34.359028122 -0500
@@ -39,6 +39,7 @@
 #include <linux/vmalloc.h>
 #include <linux/timer.h>
 #include <linux/ioctl.h>
+#include <linux/delay.h>
 
 #include "rsxx.h"
 #include "rsxx_cfg.h"
@@ -374,6 +375,8 @@ typedef void (*rsxx_dma_cb)(struct rsxx_
 int rsxx_dma_setup(struct rsxx_cardinfo *card);
 void rsxx_dma_destroy(struct rsxx_cardinfo *card);
 int rsxx_dma_init(void);
+int rsxx_cleanup_dma_queue(struct rsxx_dma_ctrl *ctrl, struct list_head *q);
+int rsxx_dma_cancel(struct rsxx_dma_ctrl *ctrl);
 void rsxx_dma_cleanup(void);
 void rsxx_dma_queue_reset(struct rsxx_cardinfo *card);
 int rsxx_dma_configure(struct rsxx_cardinfo *card);
@@ -384,7 +387,6 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 			   void *cb_data);
 int rsxx_hw_buffers_init(struct pci_dev *dev, struct rsxx_dma_ctrl *ctrl);
 int rsxx_eeh_save_issued_dmas(struct rsxx_cardinfo *card);
-void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card);
 int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card);
 
 /***** cregs.c *****/

