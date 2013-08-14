Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab3HNVc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:32:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55538 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab3HNVc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:32:27 -0400
Date: Wed, 14 Aug 2013 16:32:19 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 1/5] rsxx: Handling failed pci_map_page on PowerPC and double
 free.
Message-ID: <20130814213219.GB26562@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081421-7182-0000-0000-00000817C890
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

The rsxx driver was not checking the correct value during a
pci_map_page failure. Fixing this also uncovered a
double free if the bio was returned before it was
broken up into indiviadual 4k dmas, that is also
fixed here.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-08-12 14:59:32.483922150 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-08-12 15:14:16.448881961 -0500
@@ -654,7 +654,8 @@ static void rsxx_eeh_failure(struct pci_
 	for (i = 0; i < card->n_targets; i++) {
 		spin_lock_bh(&card->ctrl[i].queue_lock);
 		cnt = rsxx_cleanup_dma_queue(&card->ctrl[i],
-					     &card->ctrl[i].queue);
+					     &card->ctrl[i].queue,
+					     COMPLETE_DMA);
 		spin_unlock_bh(&card->ctrl[i].queue_lock);
 
 		cnt += rsxx_dma_cancel(&card->ctrl[i]);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-08-12 14:59:32.489864413 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-08-12 15:14:16.453861056 -0500
@@ -221,6 +221,19 @@ static void dma_intr_coal_auto_tune(stru
 }
 
 /*----------------- RSXX DMA Handling -------------------*/
+static void rsxx_free_dma(struct rsxx_dma_ctrl *ctrl, struct rsxx_dma *dma)
+{
+	if (dma->dma_addr && dma->dma_addr != -1) {
+		pci_unmap_page(ctrl->card->dev, dma->dma_addr,
+			       get_dma_size(dma),
+			       dma->cmd == HW_CMD_BLK_WRITE ?
+					   PCI_DMA_TODEVICE :
+					   PCI_DMA_FROMDEVICE);
+	}
+
+	kmem_cache_free(rsxx_dma_pool, dma);
+}
+
 static void rsxx_complete_dma(struct rsxx_dma_ctrl *ctrl,
 				  struct rsxx_dma *dma,
 				  unsigned int status)
@@ -232,21 +245,14 @@ static void rsxx_complete_dma(struct rsx
 	if (status & DMA_CANCELLED)
 		ctrl->stats.dma_cancelled++;
 
-	if (dma->dma_addr)
-		pci_unmap_page(ctrl->card->dev, dma->dma_addr,
-			       get_dma_size(dma),
-			       dma->cmd == HW_CMD_BLK_WRITE ?
-					   PCI_DMA_TODEVICE :
-					   PCI_DMA_FROMDEVICE);
-
 	if (dma->cb)
 		dma->cb(ctrl->card, dma->cb_data, status ? 1 : 0);
 
-	kmem_cache_free(rsxx_dma_pool, dma);
+	rsxx_free_dma(ctrl, dma);
 }
 
 int rsxx_cleanup_dma_queue(struct rsxx_dma_ctrl *ctrl,
-			   struct list_head *q)
+			   struct list_head *q, unsigned int done)
 {
 	struct rsxx_dma *dma;
 	struct rsxx_dma *tmp;
@@ -254,7 +260,10 @@ int rsxx_cleanup_dma_queue(struct rsxx_d
 
 	list_for_each_entry_safe(dma, tmp, q, list) {
 		list_del(&dma->list);
-		rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
+		if (done & COMPLETE_DMA)
+			rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
+		else
+			rsxx_free_dma(ctrl, dma);
 		cnt++;
 	}
 
@@ -370,7 +379,7 @@ static void dma_engine_stalled(unsigned 
 
 		/* Clean up the DMA queue */
 		spin_lock(&ctrl->queue_lock);
-		cnt = rsxx_cleanup_dma_queue(ctrl, &ctrl->queue);
+		cnt = rsxx_cleanup_dma_queue(ctrl, &ctrl->queue, COMPLETE_DMA);
 		spin_unlock(&ctrl->queue_lock);
 
 		cnt += rsxx_dma_cancel(ctrl);
@@ -623,7 +632,7 @@ static int rsxx_queue_dma(struct rsxx_ca
 	dma->dma_addr = pci_map_page(card->dev, page, pg_off, dma_len,
 				     dir ? PCI_DMA_TODEVICE :
 				     PCI_DMA_FROMDEVICE);
-	if (!dma->dma_addr) {
+	if (!dma->dma_addr || dma->dma_addr == -1) {
 		kmem_cache_free(rsxx_dma_pool, dma);
 		return -ENOMEM;
 	}
@@ -736,11 +745,9 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 	return 0;
 
 bvec_err:
-	for (i = 0; i < card->n_targets; i++) {
-		spin_lock_bh(&card->ctrl[i].queue_lock);
-		rsxx_cleanup_dma_queue(&card->ctrl[i], &dma_list[i]);
-		spin_unlock_bh(&card->ctrl[i].queue_lock);
-	}
+	for (i = 0; i < card->n_targets; i++)
+		rsxx_cleanup_dma_queue(&card->ctrl[i], &dma_list[i],
+					FREE_DMA);
 
 	return st;
 }
@@ -990,7 +997,7 @@ void rsxx_dma_destroy(struct rsxx_cardin
 
 		/* Clean up the DMA queue */
 		spin_lock_bh(&ctrl->queue_lock);
-		rsxx_cleanup_dma_queue(ctrl, &ctrl->queue);
+		rsxx_cleanup_dma_queue(ctrl, &ctrl->queue, COMPLETE_DMA);
 		spin_unlock_bh(&ctrl->queue_lock);
 
 		rsxx_dma_cancel(ctrl);
@@ -1045,7 +1052,7 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 		card->ctrl[i].e_cnt = 0;
 
 		list_for_each_entry(dma, &card->ctrl[i].queue, list) {
-			if (dma->dma_addr)
+			if (dma->dma_addr && dma->dma_addr != -1)
 				pci_unmap_page(card->dev, dma->dma_addr,
 					       get_dma_size(dma),
 					       dma->cmd == HW_CMD_BLK_WRITE ?
@@ -1073,7 +1080,7 @@ int rsxx_eeh_remap_dmas(struct rsxx_card
 					dma->cmd == HW_CMD_BLK_WRITE ?
 					PCI_DMA_TODEVICE :
 					PCI_DMA_FROMDEVICE);
-			if (!dma->dma_addr) {
+			if (!dma->dma_addr || dma->dma_addr == -1) {
 				spin_unlock_bh(&card->ctrl[i].queue_lock);
 				kmem_cache_free(rsxx_dma_pool, dma);
 				return -ENOMEM;
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-08-12 14:59:32.493879081 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-08-12 15:14:16.455899686 -0500
@@ -345,6 +345,11 @@ enum rsxx_creg_stat {
 	CREG_STAT_TAG_MASK	= 0x0000ff00,
 };
 
+enum rsxx_dma_finish {
+	FREE_DMA	= 0x0,
+	COMPLETE_DMA	= 0x1,
+};
+
 static inline unsigned int CREG_DATA(int N)
 {
 	return CREG_DATA0 + (N << 2);
@@ -379,7 +384,9 @@ typedef void (*rsxx_dma_cb)(struct rsxx_
 int rsxx_dma_setup(struct rsxx_cardinfo *card);
 void rsxx_dma_destroy(struct rsxx_cardinfo *card);
 int rsxx_dma_init(void);
-int rsxx_cleanup_dma_queue(struct rsxx_dma_ctrl *ctrl, struct list_head *q);
+int rsxx_cleanup_dma_queue(struct rsxx_dma_ctrl *ctrl,
+				struct list_head *q,
+				unsigned int done);
 int rsxx_dma_cancel(struct rsxx_dma_ctrl *ctrl);
 void rsxx_dma_cleanup(void);
 void rsxx_dma_queue_reset(struct rsxx_cardinfo *card);

