Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3JRWLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:11:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33229 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab3JRWLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:11:52 -0400
Date: Fri, 18 Oct 2013 17:11:46 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 1/2] rsxx: Disallow discards from being unmapped.
Message-ID: <20131018221146.GB1278@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101822-0320-0000-0000-0000016D650C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch fixes a bug in which discards were always
calling pci_unmap_page. Discards should never call the
pci_unmap_page function call because they are never mapped.

This caused a race condition on PowerPC systems when issuing
discards, writes, and reads all at the same time. The
pci_map_page function would eventually map logical address
0 for a read or write. Discards are always assigned a DMA
address of 0 because they are never mapped. So if
pci_map_page mapped address 0 for a DMA and a discard was
"unmapped" then the address would be freed and would cause 
an EEH event to occur when Hardware accesses the address.

This was injected/uncovered in commit:
b347f9cf0bc8d42ee95ba1d3837fd93045ab336b

The pci_dma_mapping_error function declares -1 a DMA_ERROR
not 0 like initially thought So before we would never unmap
discards because they were considered NULL.

This patch should fall on top of commit id:
fc1967bb08a6184ed44ef990e1dd4389901b809c

Also, the driver version is being up dated.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------

	
diff -uprN -X linux-2.6.32-422.el6-vanilla/Documentation/dontdiff linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/dma.c linux-2.6.32-422.el6/drivers/block/rsxx/dma.c
--- linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/dma.c	2013-10-15 15:19:39.404677428 -0500
+++ linux-2.6.32-422.el6/drivers/block/rsxx/dma.c	2013-10-15 15:37:33.800759570 -0500
@@ -223,12 +223,14 @@ static void dma_intr_coal_auto_tune(stru
 /*----------------- RSXX DMA Handling -------------------*/
 static void rsxx_free_dma(struct rsxx_dma_ctrl *ctrl, struct rsxx_dma *dma)
 {
-	if (!pci_dma_mapping_error(ctrl->card->dev, dma->dma_addr)) {
-		pci_unmap_page(ctrl->card->dev, dma->dma_addr,
-			       get_dma_size(dma),
-			       dma->cmd == HW_CMD_BLK_WRITE ?
-					   PCI_DMA_TODEVICE :
-					   PCI_DMA_FROMDEVICE);
+	if (dma->cmd != HW_CMD_BLK_DISCARD) {
+		if (!pci_dma_mapping_error(ctrl->card->dev, dma->dma_addr)) {
+			pci_unmap_page(ctrl->card->dev, dma->dma_addr,
+				       get_dma_size(dma),
+				       dma->cmd == HW_CMD_BLK_WRITE ?
+						   PCI_DMA_TODEVICE :
+						   PCI_DMA_FROMDEVICE);
+		}
 	}
 
 	kmem_cache_free(rsxx_dma_pool, dma);
@@ -1057,11 +1059,14 @@ int rsxx_eeh_save_issued_dmas(struct rsx
 			else
 				card->ctrl[i].stats.reads_issued--;
 
-			pci_unmap_page(card->dev, dma->dma_addr,
-				       get_dma_size(dma),
-				       dma->cmd == HW_CMD_BLK_WRITE ?
-				       PCI_DMA_TODEVICE :
-				       PCI_DMA_FROMDEVICE);
+			if (dma->cmd != HW_CMD_BLK_DISCARD) {
+				pci_unmap_page(card->dev, dma->dma_addr,
+					       get_dma_size(dma),
+					       dma->cmd == HW_CMD_BLK_WRITE ?
+					       PCI_DMA_TODEVICE :
+					       PCI_DMA_FROMDEVICE);
+			}
+
 			list_add_tail(&dma->list, &issued_dmas[i]);
 			push_tracker(card->ctrl[i].trackers, j);
 			cnt++;
diff -uprN -X linux-2.6.32-422.el6-vanilla/Documentation/dontdiff linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/rsxx_priv.h linux-2.6.32-422.el6/drivers/block/rsxx/rsxx_priv.h
--- linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-10-15 15:19:39.414675085 -0500
+++ linux-2.6.32-422.el6/drivers/block/rsxx/rsxx_priv.h	2013-10-15 15:40:40.074863193 -0500
@@ -52,7 +52,7 @@ struct proc_cmd;
 #define RS70_PCI_REV_SUPPORTED	4
 
 #define DRIVER_NAME "rsxx"
-#define DRIVER_VERSION "4.0.1.2498"
+#define DRIVER_VERSION "4.0.2.2510"
 
 /* Block size is 4096 */
 #define RSXX_HW_BLK_SHIFT		12

