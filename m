Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3I1A1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 20:27:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34367 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3I1A1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 20:27:04 -0400
Date: Fri, 27 Sep 2013 19:26:58 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 1/1] rsxx: Kernel Panic caused by mapping Discards.
Message-ID: <20130928002658.GB13456@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092800-0320-0000-0000-00000128ACEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This fixes a kernel panic injected by commit id
8d26750143341831bc312f61c5ed141eeb75b8d0 where discards
are getting mapped through the pci_map_page function call.

The driver will now start verifying that a dma is not a
discard before issuing a the pci_map_page function call.

Also, we are updating the driver version.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------

diff -uprN -X linux-2.6.32-420.el6-vanilla/Documentation/dontdiff linux-2.6.32-420.el6-vanilla/drivers/block/rsxx/dma.c linux-2.6.32-420.el6/drivers/block/rsxx/dma.c
--- linux-2.6.32-420.el6-vanilla/drivers/block/rsxx/dma.c	2013-09-23 09:15:30.000000000 -0500
+++ linux-2.6.32-420.el6/drivers/block/rsxx/dma.c	2013-09-26 15:12:16.471465749 -0500
@@ -434,26 +434,29 @@ static void rsxx_issue_dmas(struct rsxx_
 			continue;
 		}
 
-		if (dma->cmd == HW_CMD_BLK_WRITE)
-			dir = PCI_DMA_TODEVICE;
-		else
-			dir = PCI_DMA_FROMDEVICE;
+		if (dma->cmd != HW_CMD_BLK_DISCARD) {
+			if (dma->cmd == HW_CMD_BLK_WRITE)
+				dir = PCI_DMA_TODEVICE;
+			else
+				dir = PCI_DMA_FROMDEVICE;
 
-		/*
-		 * The function pci_map_page is placed here because we can
-		 * only, by design, issue up to 255 commands to the hardware
-		 * at one time per DMA channel. So the maximum amount of mapped
-		 * memory would be 255 * 4 channels * 4096 Bytes which is less
-		 * than 2GB, the limit of a x8 Non-HWWD PCIe slot. This way the
-		 * pci_map_page function should never fail because of a
-		 * lack of mappable memory.
-		 */
-		dma->dma_addr = pci_map_page(ctrl->card->dev, dma->page,
-				     dma->pg_off, dma->sub_page.cnt << 9, dir);
-		if (pci_dma_mapping_error(ctrl->card->dev, dma->dma_addr)) {
-			push_tracker(ctrl->trackers, tag);
-			rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
-			continue;
+			/*
+			 * The function pci_map_page is placed here because we
+			 * can only, by design, issue up to 255 commands to the
+			 * hardware at one time per DMA channel. So the maximum
+			 * amount of mapped memory would be 255 * 4 channels *
+			 * 4096 Bytes which is less than 2GB, the limit of a x8
+			 * Non-HWWD PCIe slot. This way the pci_map_page
+			 * function should never fail because of a lack of
+			 * mappable memory.
+			 */
+			dma->dma_addr = pci_map_page(ctrl->card->dev, dma->page,
+					dma->pg_off, dma->sub_page.cnt << 9, dir);
+			if (pci_dma_mapping_error(ctrl->card->dev, dma->dma_addr)) {
+				push_tracker(ctrl->trackers, tag);
+				rsxx_complete_dma(ctrl, dma, DMA_CANCELLED);
+				continue;
+			}
 		}
 
 		set_tracker_dma(ctrl->trackers, tag, dma);
diff -uprN -X linux-2.6.32-420.el6-vanilla/Documentation/dontdiff linux-2.6.32-420.el6-vanilla/drivers/block/rsxx/rsxx_priv.h linux-2.6.32-420.el6/drivers/block/rsxx/rsxx_priv.h
--- linux-2.6.32-420.el6-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-09-23 09:15:30.000000000 -0500
+++ linux-2.6.32-420.el6/drivers/block/rsxx/rsxx_priv.h	2013-09-26 15:24:14.185459296 -0500
@@ -52,7 +52,7 @@ struct proc_cmd;
 #define RS70_PCI_REV_SUPPORTED	4
 
 #define DRIVER_NAME "rsxx"
-#define DRIVER_VERSION "4.0"
+#define DRIVER_VERSION "4.0.1.2498"
 
 /* Block size is 4096 */
 #define RSXX_HW_BLK_SHIFT		12

