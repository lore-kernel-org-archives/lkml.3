Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaKFXFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:05:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaKFWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 114/162] usb: dwc3: gadget: fix set_halt() bug with pending transfers
Date: Thu,  6 Nov 2014 14:36:18 -0800
Message-Id: <1415313426-9622-115-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 7a60855972f0d3c014093046cb6f013a1ee5bb19 upstream.

According to our Gadget Framework API documentation,
->set_halt() *must* return -EAGAIN if we have pending
transfers (on either direction) or FIFO isn't empty (on
TX endpoints).

Fix this bug so that the mass storage gadget can be used
without stall=0 parameter.

This patch should be backported to all kernels since v3.2.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ kamal: backport to 3.13-stable: omitted ep_set_wedge() change ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/ep0.c    |  4 ++--
 drivers/usb/dwc3/gadget.c | 14 +++++++++++---
 drivers/usb/dwc3/gadget.h |  2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 21a3520..0985ff7 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -251,7 +251,7 @@ static void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
-	__dwc3_gadget_ep_set_halt(dep, 1);
+	__dwc3_gadget_ep_set_halt(dep, 1, false);
 	dep->flags = DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
@@ -461,7 +461,7 @@ static int dwc3_ep0_handle_feature(struct dwc3 *dwc,
 				return -EINVAL;
 			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
 				break;
-			ret = __dwc3_gadget_ep_set_halt(dep, set);
+			ret = __dwc3_gadget_ep_set_halt(dep, set, true);
 			if (ret)
 				return -EINVAL;
 			break;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index c37da0c..27b9c8a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -588,7 +588,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
-		__dwc3_gadget_ep_set_halt(dep, 0);
+		__dwc3_gadget_ep_set_halt(dep, 0, false);
 
 	reg = dwc3_readl(dwc->regs, DWC3_DALEPENA);
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
@@ -1186,7 +1186,7 @@ out0:
 	return ret;
 }
 
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 {
 	struct dwc3_gadget_ep_cmd_params	params;
 	struct dwc3				*dwc = dep->dwc;
@@ -1195,6 +1195,14 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
 	memset(&params, 0x00, sizeof(params));
 
 	if (value) {
+		if (!protocol && ((dep->direction && dep->flags & DWC3_EP_BUSY) ||
+				(!list_empty(&dep->req_queued) ||
+				 !list_empty(&dep->request_list)))) {
+			dev_dbg(dwc->dev, "%s: pending request, cannot halt\n",
+					dep->name);
+			return -EAGAIN;
+		}
+
 		ret = dwc3_send_gadget_ep_cmd(dwc, dep->number,
 			DWC3_DEPCMD_SETSTALL, &params);
 		if (ret)
@@ -1234,7 +1242,7 @@ static int dwc3_gadget_ep_set_halt(struct usb_ep *ep, int value)
 		goto out;
 	}
 
-	ret = __dwc3_gadget_ep_set_halt(dep, value);
+	ret = __dwc3_gadget_ep_set_halt(dep, value, false);
 out:
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index a0ee75b..ac625582 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -85,7 +85,7 @@ void dwc3_ep0_out_start(struct dwc3 *dwc);
 int dwc3_gadget_ep0_set_halt(struct usb_ep *ep, int value);
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value);
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW
-- 
1.9.1

