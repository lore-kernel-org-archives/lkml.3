Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3ILAfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:35:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:38746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3ILAe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,887,1371106800"; 
   d="scan'208";a="359232712"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] usb: dwc3: gadget: avoid memory leak when failing to allocate all eps
Date: Wed, 11 Sep 2013 17:38:30 -0700
Message-Id: <1378946310-28421-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dwc3_gadget_init_endpoint() fails after allocate some of the eps, we
need to free their memory to avoid leak.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/gadget.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index f168eae..611bdba 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1707,8 +1707,13 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 
 	for (epnum = 0; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
 		dep = dwc->eps[epnum];
+		/*
+		 * Because dwc was allocated by kzalloc() and eps are set
+		 * in ascending order, we can assume no extra one was
+		 * allocated after first dep == NULL.
+		 */
 		if (!dep)
-			continue;
+			break;
 		/*
 		 * Physical endpoints 0 and 1 are special; they form the
 		 * bi-directional USB endpoint 0.
@@ -2611,15 +2616,13 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	ret = usb_add_gadget_udc(dwc->dev, &dwc->gadget);
 	if (ret) {
 		dev_err(dwc->dev, "failed to register udc\n");
-		goto err5;
+		goto err4;
 	}
 
 	return 0;
 
-err5:
-	dwc3_gadget_free_endpoints(dwc);
-
 err4:
+	dwc3_gadget_free_endpoints(dwc);
 	dma_free_coherent(dwc->dev, DWC3_EP0_BOUNCE_SIZE,
 			dwc->ep0_bounce, dwc->ep0_bounce_addr);
 
-- 
1.8.4.rc3

