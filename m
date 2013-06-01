Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3FAA3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:29:49 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40362 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3FAA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:29:42 -0400
Date: Fri, 31 May 2013 19:29:37 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] rsxx: Restructured DMA cancel scheme.
Message-ID: <20130601002937.GD3051@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060100-7408-0000-0000-000010C9E670
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Before DMAs would never be cancelled if the data stall or
EEH Permenant failure occured. 

The DMA cancellation mechanism has been modified to fix
these issues and allows DMAs to be cancelled whenever they
should be.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------



diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-05-31 15:37:27.472028580 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-05-31 15:55:45.190266405 -0500
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
diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dev.c linux-block/drivers/block/rsxx/dev.c
--- linux-block-vanilla/drivers/block/rsxx/dev.c	2013-05-31 14:57:49.408015919 -0500
+++ linux-block/drivers/block/rsxx/dev.c	2013-05-31 15:58:20.127316204 -0500
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
diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-05-31 15:49:33.709091563 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-05-31 16:26:23.366143655 -0500
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
@@ -252,10 +268,10 @@ static void rsxx_requeue_dma(struct rsxx
 	 * Requeued DMAs go to the front of the queue so they are issued
 	 * first.
 	 */
-	spin_lock(&ctrl->queue_lock);
+	spin_lock_bh(&ctrl->queue_lock);
 	ctrl->stats.sw_q_depth++;
 	list_add(&dma->list, &ctrl->queue);
-	spin_unlock(&ctrl->queue_lock);
+	spin_unlock_bh(&ctrl->queue_lock);
 }
 
 static void rsxx_handle_dma_error(struct rsxx_dma_ctrl *ctrl,
@@ -330,6 +346,7 @@ static void rsxx_handle_dma_error(struct
 static void dma_engine_stalled(unsigned long data)
 {
 	struct rsxx_dma_ctrl *ctrl = (struct rsxx_dma_ctrl *)data;
+	int cnt;
 
 	if (atomic_read(&ctrl->stats.hw_q_depth) == 0 ||
 	    unlikely(ctrl->card->eeh_state))
@@ -350,6 +367,18 @@ static void dma_engine_stalled(unsigned 
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
 
@@ -369,22 +398,22 @@ static void rsxx_issue_dmas(struct work_
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
@@ -521,33 +550,10 @@ static void rsxx_dma_done(struct work_st
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
@@ -697,12 +703,15 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 		}
 	}
 
+	if (unlikely(card->halt))
+		goto bvec_err;
+
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
@@ -712,8 +721,17 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 	return 0;
 
 bvec_err:
-	for (i = 0; i < card->n_targets; i++)
-		rsxx_cleanup_dma_queue(card, &dma_list[i]);
+	for (i = 0; i < card->n_targets; i++) {
+		/*
+		 * The sleep is used so that user land apps that continue to
+		 * send DMAs even though we are halted will queue up and we
+		 * can cancel them all at once.
+		 */
+		msleep(100);
+		spin_lock_bh(&card->ctrl[i].queue_lock);
+		rsxx_cleanup_dma_queue(&card->ctrl[i], &dma_list[i]);
+		spin_unlock_bh(&card->ctrl[i].queue_lock);
+	}
 
 	return st;
 }
@@ -919,13 +937,30 @@ failed_dma_setup:
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
@@ -944,33 +979,11 @@ void rsxx_dma_destroy(struct rsxx_cardin
 			del_timer_sync(&ctrl->activity_timer);
 
 		/* Clean up the DMA queue */
-		spin_lock(&ctrl->queue_lock);
-		cnt = rsxx_cleanup_dma_queue(card, &ctrl->queue);
-		spin_unlock(&ctrl->queue_lock);
-
-		if (cnt)
-			dev_info(CARD_TO_DEV(card),
-				"Freed %d queued DMAs on channel %d\n",
-				cnt, i);
+		spin_lock_bh(&ctrl->queue_lock);
+		rsxx_cleanup_dma_queue(ctrl, &ctrl->queue);
+		spin_unlock_bh(&ctrl->queue_lock);
 
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
 
@@ -1014,7 +1027,7 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 			cnt++;
 		}
 
-		spin_lock(&card->ctrl[i].queue_lock);
+		spin_lock_bh(&card->ctrl[i].queue_lock);
 		list_splice(&issued_dmas[i], &card->ctrl[i].queue);
 
 		atomic_sub(cnt, &card->ctrl[i].stats.hw_q_depth);
@@ -1029,7 +1042,7 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 					       PCI_DMA_TODEVICE :
 					       PCI_DMA_FROMDEVICE);
 		}
-		spin_unlock(&card->ctrl[i].queue_lock);
+		spin_unlock_bh(&card->ctrl[i].queue_lock);
 	}
 
 	kfree(issued_dmas);
@@ -1037,30 +1050,13 @@ int rsxx_eeh_save_issued_dmas(struct rsx
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
@@ -1068,12 +1064,12 @@ int rsxx_eeh_remap_dmas(struct rsxx_card
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
diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-05-31 15:37:27.488017577 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-05-31 16:29:27.484074493 -0500
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

