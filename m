Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3KLVBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:01:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:4888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab3KLVA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:00:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407682069"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v6 5/5] usb: dwc3: implement gadget's quirk ep_out_align_size
Date: Tue, 12 Nov 2013 13:04:46 -0800
Message-Id: <1384290286-21432-6-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
This patch implements necessary quirk for it.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/core.h   |  6 ++++++
 drivers/usb/dwc3/gadget.c | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f8af8d44af85..ff42d7ddc546 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -571,6 +571,12 @@ struct dwc3_request {
 	struct dwc3_ep		*dep;
 	u32			start_slot;
 
+	/*
+	 * If gadget/epout, we need to pad buffer size to align with
+	 * maxpacketsize.
+	 */
+	size_t			pad;
+
 	u8			epnum;
 	struct dwc3_trb		*trb;
 	dma_addr_t		trb_dma;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5452c0fce360..7c2d36f6ad4b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1130,6 +1130,14 @@ static int dwc3_gadget_ep_queue(struct usb_ep *ep, struct usb_request *request,
 	dev_vdbg(dwc->dev, "queing request %p to %s length %d\n",
 			request, ep->name, request->length);
 
+	/* If ep out, roundup request->length to epout maxpacketsize */
+	if (!(dep->number & 1)) {
+		unsigned int aligned = roundup(request->length,
+					       ep->desc->wMaxPacketSize);
+		req->pad = aligned - request->length;
+		request->length = aligned;
+	}
+
 	spin_lock_irqsave(&dwc->lock, flags);
 	ret = __dwc3_gadget_ep_queue(dep, req);
 	spin_unlock_irqrestore(&dwc->lock, flags);
@@ -1173,6 +1181,15 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 	}
 
 out1:
+	if (!(dep->number & 1)) {
+		/*
+		 * Sanitize request->length after pad was applied before
+		 * queue.
+		 */
+		request->length -= req->pad;
+		req->pad = 0;
+	}
+
 	/* giveback the request */
 	dwc3_gadget_giveback(dep, req, -ECONNRESET);
 
@@ -2600,6 +2617,12 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc->gadget.name		= "dwc3-gadget";
 
 	/*
+	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
+	 * on ep out.
+	 */
+	dwc->gadget.quirk_ep_out_aligned_size = true;
+
+	/*
 	 * REVISIT: Here we should clear all pending IRQs to be
 	 * sure we're starting from a well known location.
 	 */
-- 
1.8.4.2

