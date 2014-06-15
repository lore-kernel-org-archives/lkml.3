Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaFOUly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:41:54 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:36024 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751829AbaFOUjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1606:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3866:3870:3871:3874:4117:4250:4321:4385:4605:5007:6261:8603:9010:10004:10026:10848:11026:11233:11473:11658:11914:12043:12296:12438:12517:12519:12555:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss80_6bf601be24a19
X-Filterd-Recvd-Size: 6195
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 19/26] lpfc: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:48 -0700
Message-Id: <a442398ba7fd22971ffc7ee95db3ca3ebcf2a887.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  |  5 ++---
 drivers/scsi/lpfc/lpfc_init.c | 22 +++++++---------------
 drivers/scsi/lpfc/lpfc_mbox.c |  6 +++---
 drivers/scsi/lpfc/lpfc_sli.c  | 14 +++++---------
 4 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 5b5c825..c8ad7fe 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2693,14 +2693,13 @@ lpfc_bsg_dma_page_alloc(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&dmabuf->list);
 
 	/* now, allocate dma buffer */
-	dmabuf->virt = dma_alloc_coherent(&pcidev->dev, BSG_MBOX_SIZE,
-					  &(dmabuf->phys), GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&pcidev->dev, BSG_MBOX_SIZE,
+					   &(dmabuf->phys), GFP_KERNEL);
 
 	if (!dmabuf->virt) {
 		kfree(dmabuf);
 		return NULL;
 	}
-	memset((uint8_t *)dmabuf->virt, 0, BSG_MBOX_SIZE);
 
 	return dmabuf;
 }
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 06f9a5b..6fd761b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5848,16 +5848,14 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 	if (!dmabuf)
 		return NULL;
 
-	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-					  LPFC_HDR_TEMPLATE_SIZE,
-					  &dmabuf->phys,
-					  GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev,
+					   LPFC_HDR_TEMPLATE_SIZE,
+					   &dmabuf->phys, GFP_KERNEL);
 	if (!dmabuf->virt) {
 		rpi_hdr = NULL;
 		goto err_free_dmabuf;
 	}
 
-	memset(dmabuf->virt, 0, LPFC_HDR_TEMPLATE_SIZE);
 	if (!IS_ALIGNED(dmabuf->phys, LPFC_HDR_TEMPLATE_SIZE)) {
 		rpi_hdr = NULL;
 		goto err_free_coherent;
@@ -6246,14 +6244,11 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	}
 
 	/* Allocate memory for SLI-2 structures */
-	phba->slim2p.virt = dma_alloc_coherent(&pdev->dev,
-					       SLI2_SLIM_SIZE,
-					       &phba->slim2p.phys,
-					       GFP_KERNEL);
+	phba->slim2p.virt = dma_zalloc_coherent(&pdev->dev, SLI2_SLIM_SIZE,
+						&phba->slim2p.phys, GFP_KERNEL);
 	if (!phba->slim2p.virt)
 		goto out_iounmap;
 
-	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
 	phba->mbox = phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, mbx);
 	phba->mbox_ext = (phba->slim2p.virt +
 		offsetof(struct lpfc_sli2_slim, mbx_ext_words));
@@ -6618,15 +6613,12 @@ lpfc_create_bootstrap_mbox(struct lpfc_hba *phba)
 	 * plus an alignment restriction of 16 bytes.
 	 */
 	bmbx_size = sizeof(struct lpfc_bmbx_create) + (LPFC_ALIGN_16_BYTE - 1);
-	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-					  bmbx_size,
-					  &dmabuf->phys,
-					  GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev, bmbx_size,
+					   &dmabuf->phys, GFP_KERNEL);
 	if (!dmabuf->virt) {
 		kfree(dmabuf);
 		return -ENOMEM;
 	}
-	memset(dmabuf->virt, 0, bmbx_size);
 
 	/*
 	 * Initialize the bootstrap mailbox pointers now so that the register
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 1f292e2..06241f5 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1811,12 +1811,12 @@ lpfc_sli4_config(struct lpfc_hba *phba, struct lpfcMboxq *mbox,
 		 * page, this is used as a priori size of SLI4_PAGE_SIZE for
 		 * the later DMA memory free.
 		 */
-		viraddr = dma_alloc_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
-					     &phyaddr, GFP_KERNEL);
+		viraddr = dma_zalloc_coherent(&phba->pcidev->dev,
+					      SLI4_PAGE_SIZE, &phyaddr,
+					      GFP_KERNEL);
 		/* In case of malloc fails, proceed with whatever we have */
 		if (!viraddr)
 			break;
-		memset(viraddr, 0, SLI4_PAGE_SIZE);
 		mbox->sge_array->addr[pagen] = viraddr;
 		/* Keep the first page for later sub-header construction */
 		if (pagen == 0)
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 32ada05..a418a04 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4864,15 +4864,12 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	 * mailbox command.
 	 */
 	dma_size = *vpd_size;
-	dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-					  dma_size,
-					  &dmabuf->phys,
-					  GFP_KERNEL);
+	dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev, dma_size,
+					   &dmabuf->phys, GFP_KERNEL);
 	if (!dmabuf->virt) {
 		kfree(dmabuf);
 		return -ENOMEM;
 	}
-	memset(dmabuf->virt, 0, dma_size);
 
 	/*
 	 * The SLI4 implementation of READ_REV conflicts at word1,
@@ -12760,14 +12757,13 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 		dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 		if (!dmabuf)
 			goto out_fail;
-		dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
-						  hw_page_size, &dmabuf->phys,
-						  GFP_KERNEL);
+		dmabuf->virt = dma_zalloc_coherent(&phba->pcidev->dev,
+						   hw_page_size, &dmabuf->phys,
+						   GFP_KERNEL);
 		if (!dmabuf->virt) {
 			kfree(dmabuf);
 			goto out_fail;
 		}
-		memset(dmabuf->virt, 0, hw_page_size);
 		dmabuf->buffer_tag = x;
 		list_add_tail(&dmabuf->list, &queue->page_list);
 		/* initialize queue's entry array */
-- 
1.8.1.2.459.gbcd45b4.dirty

