Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaKLLkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:40:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49307 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbaKLLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:39:58 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <paulz@synopsys.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <mathias.nyman@intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] usb: Use dma_zalloc_coherent
Date: Wed, 12 Nov 2014 19:37:20 +0800
Message-ID: <1415792240-6835-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-12_05:2014-11-11,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411120090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing version instead of dma_alloc_coherent and memset() as 0.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/usb/dwc2/hcd_ddma.c | 5 +----
 drivers/usb/host/uhci-hcd.c | 3 +--
 drivers/usb/host/xhci-mem.c | 3 +--
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc2/hcd_ddma.c b/drivers/usb/dwc2/hcd_ddma.c
index 3376177..d17e3cf 100644
--- a/drivers/usb/dwc2/hcd_ddma.c
+++ b/drivers/usb/dwc2/hcd_ddma.c
@@ -87,7 +87,7 @@ static u16 dwc2_frame_incr_val(struct dwc2_qh *qh)
 static int dwc2_desc_list_alloc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
 				gfp_t flags)
 {
-	qh->desc_list = dma_alloc_coherent(hsotg->dev,
+	qh->desc_list = dma_zalloc_coherent(hsotg->dev,
 				sizeof(struct dwc2_hcd_dma_desc) *
 				dwc2_max_desc_num(qh), &qh->desc_list_dma,
 				flags);
@@ -95,9 +95,6 @@ static int dwc2_desc_list_alloc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
 	if (!qh->desc_list)
 		return -ENOMEM;
 
-	memset(qh->desc_list, 0,
-	       sizeof(struct dwc2_hcd_dma_desc) * dwc2_max_desc_num(qh));
-
 	qh->n_bytes = kzalloc(sizeof(u32) * dwc2_max_desc_num(qh), flags);
 	if (!qh->n_bytes) {
 		dma_free_coherent(hsotg->dev, sizeof(struct dwc2_hcd_dma_desc)
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index a7de8e8..1d055f4 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -589,7 +589,7 @@ static int uhci_start(struct usb_hcd *hcd)
 	uhci->dentry = dentry;
 #endif
 
-	uhci->frame = dma_alloc_coherent(uhci_dev(uhci),
+	uhci->frame = dma_zalloc_coherent(uhci_dev(uhci),
 			UHCI_NUMFRAMES * sizeof(*uhci->frame),
 			&uhci->frame_dma_handle, GFP_KERNEL);
 	if (!uhci->frame) {
@@ -597,7 +597,6 @@ static int uhci_start(struct usb_hcd *hcd)
 			"unable to allocate consistent memory for frame list\n");
 		goto err_alloc_frame;
 	}
-	memset(uhci->frame, 0, UHCI_NUMFRAMES * sizeof(*uhci->frame));
 
 	uhci->frame_cpu = kcalloc(UHCI_NUMFRAMES, sizeof(*uhci->frame_cpu),
 			GFP_KERNEL);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 5cb3d7a..183ada4 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2455,7 +2455,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	if (xhci_check_trb_in_td_math(xhci, flags) < 0)
 		goto fail;
 
-	xhci->erst.entries = dma_alloc_coherent(dev,
+	xhci->erst.entries = dma_zalloc_coherent(dev,
 			sizeof(struct xhci_erst_entry) * ERST_NUM_SEGS, &dma,
 			GFP_KERNEL);
 	if (!xhci->erst.entries)
@@ -2464,7 +2464,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 			"// Allocated event ring segment table at 0x%llx",
 			(unsigned long long)dma);
 
-	memset(xhci->erst.entries, 0, sizeof(struct xhci_erst_entry)*ERST_NUM_SEGS);
 	xhci->erst.num_entries = ERST_NUM_SEGS;
 	xhci->erst.erst_dma_addr = dma;
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
-- 
2.1.3

