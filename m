Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3HNVec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:34:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55938 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173Ab3HNVeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:34:31 -0400
Date: Wed, 14 Aug 2013 16:34:26 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 2/5] rsxx: Moving pci_map_page to prevent overflow
Message-ID: <20130814213426.GC26562@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081421-7182-0000-0000-00000817C975
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

The pci_map_page function has been moved into our
issued workqueue to prevent us running out of
mappable addresses on non-HWWD PCIe x8 slots. The
maximum amount that can possible be mapped at one
time now is: 255 dmas X 4 dma channels X 4096 Bytes.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-08-12 15:22:18.608859980 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-08-12 15:23:14.508859632 -0500
@@ -749,10 +749,6 @@ static pci_ers_result_t rsxx_slot_reset(
 
 	card->eeh_state = 0;
 
-	st = rsxx_eeh_remap_dmas(card);
-	if (st)
-		goto failed_remap_dmas;
-
 	spin_lock_irqsave(&card->irq_lock, flags);
 	if (card->n_targets & RSXX_MAX_TARGETS)
 		rsxx_enable_ier_and_isr(card, CR_INTR_ALL_G);
@@ -779,7 +775,6 @@ static pci_ers_result_t rsxx_slot_reset(
 	return PCI_ERS_RESULT_RECOVERED;
 
 failed_hw_buffers_init:
-failed_remap_dmas:
 	for (i = 0; i < card->n_targets; i++) {
 		if (card->ctrl[i].status.buf)
 			pci_free_consistent(card->dev,
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-08-12 15:22:18.612863489 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-08-12 15:23:22.158858765 -0500
@@ -397,6 +397,7 @@ static void rsxx_issue_dmas(struct rsxx_
 	int tag;
 	int cmds_pending = 0;
 	struct hw_cmd *hw_cmd_buf;
+	int dir;
 
 	hw_cmd_buf = ctrl->cmd.buf;
 
@@ -433,6 +434,27 @@ static void rsxx_issue_dmas(struct rsxx_
 			continue;
 		}
 
+		if (dma->cmd == HW_CMD_BLK_WRITE)
+			dir = PCI_DMA_TODEVICE;
+		else
+			dir = PCI_DMA_FROMDEVICE;
+
+		/*
+		 * The function pci_map_page is placed here because we can
+		 * only, by design, issue up to 255 commands to the hardware
+		 * at one time per DMA channel. So the maximum amount of mapped
+		 * memory would be 255 * 4 channels * 4096 Bytes which is less
+		 * than 2GB, the limit of a x8 Non-HWWD PCIe slot. This way the
+		 * pci_map_page function should never fail because of a
+		 * lack of mappable memory.
+		 */
+		dma->dma_addr = pci_map_page(ctrl->card->dev, dma->page,
+				     dma->pg_off, dma->sub_page.cnt << 9, dir);
+		if (!dma->dma_addr || dma->dma_addr == -1) {
+			kmem_cache_free(rsxx_dma_pool, dma);
+			return;
+		}
+
 		set_tracker_dma(ctrl->trackers, tag, dma);
 		hw_cmd_buf[ctrl->cmd.idx].command  = dma->cmd;
 		hw_cmd_buf[ctrl->cmd.idx].tag      = tag;
@@ -629,14 +651,6 @@ static int rsxx_queue_dma(struct rsxx_ca
 	if (!dma)
 		return -ENOMEM;
 
-	dma->dma_addr = pci_map_page(card->dev, page, pg_off, dma_len,
-				     dir ? PCI_DMA_TODEVICE :
-				     PCI_DMA_FROMDEVICE);
-	if (!dma->dma_addr || dma->dma_addr == -1) {
-		kmem_cache_free(rsxx_dma_pool, dma);
-		return -ENOMEM;
-	}
-
 	dma->cmd          = dir ? HW_CMD_BLK_WRITE : HW_CMD_BLK_READ;
 	dma->laddr        = laddr;
 	dma->sub_page.off = (dma_off >> 9);
@@ -1039,6 +1053,11 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 			else
 				card->ctrl[i].stats.reads_issued--;
 
+			pci_unmap_page(card->dev, dma->dma_addr,
+				       get_dma_size(dma),
+				       dma->cmd == HW_CMD_BLK_WRITE ?
+				       PCI_DMA_TODEVICE :
+				       PCI_DMA_FROMDEVICE);
 			list_add_tail(&dma->list, &issued_dmas[i]);
 			push_tracker(card->ctrl[i].trackers, j);
 			cnt++;
@@ -1050,15 +1069,6 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 		atomic_sub(cnt, &card->ctrl[i].stats.hw_q_depth);
 		card->ctrl[i].stats.sw_q_depth += cnt;
 		card->ctrl[i].e_cnt = 0;
-
-		list_for_each_entry(dma, &card->ctrl[i].queue, list) {
-			if (dma->dma_addr && dma->dma_addr != -1)
-				pci_unmap_page(card->dev, dma->dma_addr,
-					       get_dma_size(dma),
-					       dma->cmd == HW_CMD_BLK_WRITE ?
-					       PCI_DMA_TODEVICE :
-					       PCI_DMA_FROMDEVICE);
-		}
 		spin_unlock_bh(&card->ctrl[i].queue_lock);
 	}
 
@@ -1067,31 +1077,6 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 	return 0;
 }
 
-int rsxx_eeh_remap_dmas(struct rsxx_cardinfo *card)
-{
-	struct rsxx_dma *dma;
-	int i;
-
-	for (i = 0; i < card->n_targets; i++) {
-		spin_lock_bh(&card->ctrl[i].queue_lock);
-		list_for_each_entry(dma, &card->ctrl[i].queue, list) {
-			dma->dma_addr = pci_map_page(card->dev, dma->page,
-					dma->pg_off, get_dma_size(dma),
-					dma->cmd == HW_CMD_BLK_WRITE ?
-					PCI_DMA_TODEVICE :
-					PCI_DMA_FROMDEVICE);
-			if (!dma->dma_addr || dma->dma_addr == -1) {
-				spin_unlock_bh(&card->ctrl[i].queue_lock);
-				kmem_cache_free(rsxx_dma_pool, dma);
-				return -ENOMEM;
-			}
-		}
-		spin_unlock_bh(&card->ctrl[i].queue_lock);
-	}
-
-	return 0;
-}
-
 int rsxx_dma_init(void)
 {
 	rsxx_dma_pool = KMEM_CACHE(rsxx_dma, SLAB_HWCACHE_ALIGN);
 
 

