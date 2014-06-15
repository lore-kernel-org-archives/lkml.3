Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaFOUkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:40:23 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:37058 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752656AbaFOUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:4321:4385:4605:5007:6261:9010:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: water95_6dbb3644d2b2b
X-Filterd-Recvd-Size: 3501
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: [PATCH -next 24/26] usb: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:53 -0700
Message-Id: <1816dd87707535b6442e5c75fde9f799821c457a.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/dwc2/hcd_ddma.c | 20 +++++++-------------
 drivers/usb/host/uhci-hcd.c |  7 +++----
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/dwc2/hcd_ddma.c b/drivers/usb/dwc2/hcd_ddma.c
index 3376177..ab8d7fc 100644
--- a/drivers/usb/dwc2/hcd_ddma.c
+++ b/drivers/usb/dwc2/hcd_ddma.c
@@ -87,17 +87,12 @@ static u16 dwc2_frame_incr_val(struct dwc2_qh *qh)
 static int dwc2_desc_list_alloc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
 				gfp_t flags)
 {
-	qh->desc_list = dma_alloc_coherent(hsotg->dev,
-				sizeof(struct dwc2_hcd_dma_desc) *
-				dwc2_max_desc_num(qh), &qh->desc_list_dma,
-				flags);
-
+	qh->desc_list = dma_zalloc_coherent(hsotg->dev,
+					    sizeof(struct dwc2_hcd_dma_desc) * dwc2_max_desc_num(qh),
+					    &qh->desc_list_dma, flags);
 	if (!qh->desc_list)
 		return -ENOMEM;
 
-	memset(qh->desc_list, 0,
-	       sizeof(struct dwc2_hcd_dma_desc) * dwc2_max_desc_num(qh));
-
 	qh->n_bytes = kzalloc(sizeof(u32) * dwc2_max_desc_num(qh), flags);
 	if (!qh->n_bytes) {
 		dma_free_coherent(hsotg->dev, sizeof(struct dwc2_hcd_dma_desc)
@@ -128,14 +123,13 @@ static int dwc2_frame_list_alloc(struct dwc2_hsotg *hsotg, gfp_t mem_flags)
 	if (hsotg->frame_list)
 		return 0;
 
-	hsotg->frame_list = dma_alloc_coherent(hsotg->dev,
-					       4 * FRLISTEN_64_SIZE,
-					       &hsotg->frame_list_dma,
-					       mem_flags);
+	hsotg->frame_list = dma_zalloc_coherent(hsotg->dev,
+						4 * FRLISTEN_64_SIZE,
+						&hsotg->frame_list_dma,
+						mem_flags);
 	if (!hsotg->frame_list)
 		return -ENOMEM;
 
-	memset(hsotg->frame_list, 0, 4 * FRLISTEN_64_SIZE);
 	return 0;
 }
 
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 27f35e8..681fc5e 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -589,15 +589,14 @@ static int uhci_start(struct usb_hcd *hcd)
 	uhci->dentry = dentry;
 #endif
 
-	uhci->frame = dma_alloc_coherent(uhci_dev(uhci),
-			UHCI_NUMFRAMES * sizeof(*uhci->frame),
-			&uhci->frame_dma_handle, 0);
+	uhci->frame = dma_zalloc_coherent(uhci_dev(uhci),
+					  UHCI_NUMFRAMES * sizeof(*uhci->frame),
+					  &uhci->frame_dma_handle, 0);
 	if (!uhci->frame) {
 		dev_err(uhci_dev(uhci),
 			"unable to allocate consistent memory for frame list\n");
 		goto err_alloc_frame;
 	}
-	memset(uhci->frame, 0, UHCI_NUMFRAMES * sizeof(*uhci->frame));
 
 	uhci->frame_cpu = kcalloc(UHCI_NUMFRAMES, sizeof(*uhci->frame_cpu),
 			GFP_KERNEL);
-- 
1.8.1.2.459.gbcd45b4.dirty

