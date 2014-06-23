Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaFWNmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:42:19 -0400
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:59080 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753989AbaFWNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1535:1730:1747:1777:1792:1801:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:4049:4117:4321:4385:4419:4605:5007:6261:8957:9010:9149:9592:10004:10026:10848:11026:11232:11233:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: baby38_87caa2353f963
X-Filterd-Recvd-Size: 6764
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: [PATCH 03/22] block: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:31 -0700
Message-Id: <431e35ae1ea1e808c8e74a0739e03d8b2c631e30.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/DAC960.c   | 18 +++++++++---------
 drivers/block/cciss.c    | 11 ++++-------
 drivers/block/skd_main.c | 25 +++++++++----------------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 125d845..811e11c 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6741,11 +6741,11 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
-	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
-				DataTransferLength, &DataTransferBufferDMA);
+	    DataTransferBuffer = pci_zalloc_consistent(Controller->PCIDevice,
+                                                       DataTransferLength,
+                                                       &DataTransferBufferDMA);
 	    if (DataTransferBuffer == NULL)
 	    	break;
-	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
@@ -6877,11 +6877,11 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
     	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
-	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
-				DataTransferLength, &DataTransferBufferDMA);
+	    DataTransferBuffer = pci_zalloc_consistent(Controller->PCIDevice,
+                                                       DataTransferLength,
+                                                       &DataTransferBufferDMA);
 	    if (DataTransferBuffer == NULL)
 	    	break;
-	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
@@ -6899,14 +6899,14 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	RequestSenseLength = UserCommand.RequestSenseLength;
 	if (RequestSenseLength > 0)
 	  {
-	    RequestSenseBuffer = pci_alloc_consistent(Controller->PCIDevice,
-			RequestSenseLength, &RequestSenseBufferDMA);
+	    RequestSenseBuffer = pci_zalloc_consistent(Controller->PCIDevice,
+                                                       RequestSenseLength,
+                                                       &RequestSenseBufferDMA);
 	    if (RequestSenseBuffer == NULL)
 	      {
 		ErrorCode = -ENOMEM;
 		goto Failure2;
 	      }
-	    memset(RequestSenseBuffer, 0, RequestSenseLength);
 	  }
 	spin_lock_irqsave(&Controller->queue_lock, flags);
 	while ((Command = DAC960_AllocateCommand(Controller)) == NULL)
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4595c22..ff20f19 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1014,24 +1014,21 @@ static CommandList_struct *cmd_special_alloc(ctlr_info_t *h)
 	u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 
-	c = (CommandList_struct *) pci_alloc_consistent(h->pdev,
-		sizeof(CommandList_struct), &cmd_dma_handle);
+	c = pci_zalloc_consistent(h->pdev, sizeof(CommandList_struct),
+				  &cmd_dma_handle);
 	if (c == NULL)
 		return NULL;
-	memset(c, 0, sizeof(CommandList_struct));
 
 	c->cmdindex = -1;
 
-	c->err_info = (ErrorInfo_struct *)
-	    pci_alloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
-		    &err_dma_handle);
+	c->err_info = pci_zalloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
+					    &err_dma_handle);
 
 	if (c->err_info == NULL) {
 		pci_free_consistent(h->pdev,
 			sizeof(CommandList_struct), c, cmd_dma_handle);
 		return NULL;
 	}
-	memset(c->err_info, 0, sizeof(ErrorInfo_struct));
 
 	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (__u32) cmd_dma_handle;
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 608532d..f0a089d 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4112,16 +4112,14 @@ static int skd_cons_skcomp(struct skd_device *skdev)
 		 skdev->name, __func__, __LINE__,
 		 nbytes, SKD_N_COMPLETION_ENTRY);
 
-	skcomp = pci_alloc_consistent(skdev->pdev, nbytes,
-				      &skdev->cq_dma_address);
+	skcomp = pci_zalloc_consistent(skdev->pdev, nbytes,
+				       &skdev->cq_dma_address);
 
 	if (skcomp == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	memset(skcomp, 0, nbytes);
-
 	skdev->skcomp_table = skcomp;
 	skdev->skerr_table = (struct fit_comp_error_info *)((char *)skcomp +
 							   sizeof(*skcomp) *
@@ -4304,15 +4302,14 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 
 		nbytes = SKD_N_SPECIAL_FITMSG_BYTES;
 
-		skspcl->msg_buf = pci_alloc_consistent(skdev->pdev, nbytes,
-						       &skspcl->mb_dma_address);
+		skspcl->msg_buf =
+			pci_zalloc_consistent(skdev->pdev, nbytes,
+					      &skspcl->mb_dma_address);
 		if (skspcl->msg_buf == NULL) {
 			rc = -ENOMEM;
 			goto err_out;
 		}
 
-		memset(skspcl->msg_buf, 0, nbytes);
-
 		skspcl->req.sg = kzalloc(sizeof(struct scatterlist) *
 					 SKD_N_SG_PER_SPECIAL, GFP_KERNEL);
 		if (skspcl->req.sg == NULL) {
@@ -4353,25 +4350,21 @@ static int skd_cons_sksb(struct skd_device *skdev)
 
 	nbytes = SKD_N_INTERNAL_BYTES;
 
-	skspcl->data_buf = pci_alloc_consistent(skdev->pdev, nbytes,
-						&skspcl->db_dma_address);
+	skspcl->data_buf = pci_zalloc_consistent(skdev->pdev, nbytes,
+						 &skspcl->db_dma_address);
 	if (skspcl->data_buf == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	memset(skspcl->data_buf, 0, nbytes);
-
 	nbytes = SKD_N_SPECIAL_FITMSG_BYTES;
-	skspcl->msg_buf = pci_alloc_consistent(skdev->pdev, nbytes,
-					       &skspcl->mb_dma_address);
+	skspcl->msg_buf = pci_zalloc_consistent(skdev->pdev, nbytes,
+						&skspcl->mb_dma_address);
 	if (skspcl->msg_buf == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	memset(skspcl->msg_buf, 0, nbytes);
-
 	skspcl->req.sksg_list = skd_cons_sg_list(skdev, 1,
 						 &skspcl->req.sksg_dma_address);
 	if (skspcl->req.sksg_list == NULL) {
-- 
1.8.1.2.459.gbcd45b4.dirty

