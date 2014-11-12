Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161177AbaKLB42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:56:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161161AbaKLB40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:56:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.10 113/123] usb: dwc3: gadget: fix set_halt() bug with pending transfers
Date: Wed, 12 Nov 2014 10:17:59 +0900
Message-Id: <20141112011724.113957362@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

[ Upstream commit 7a60855972f0d3c014093046cb6f013a1ee5bb19 ]

According to our Gadget Framework API documentation,
->set_halt() *must* return -EAGAIN if we have pending
transfers (on either direction) or FIFO isn't empty (on
TX endpoints).

Fix this bug so that the mass storage gadget can be used
without stall=0 parameter.

This patch should be backported to all kernels since v3.2.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c    |    4 ++--
 drivers/usb/dwc3/gadget.c |   16 ++++++++++++----
 drivers/usb/dwc3/gadget.h |    2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -270,7 +270,7 @@ static void dwc3_ep0_stall_and_restart(s
 
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
-	__dwc3_gadget_ep_set_halt(dep, 1);
+	__dwc3_gadget_ep_set_halt(dep, 1, false);
 	dep->flags = DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
@@ -480,7 +480,7 @@ static int dwc3_ep0_handle_feature(struc
 				return -EINVAL;
 			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
 				break;
-			ret = __dwc3_gadget_ep_set_halt(dep, set);
+			ret = __dwc3_gadget_ep_set_halt(dep, set, true);
 			if (ret)
 				return -EINVAL;
 			break;
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -605,7 +605,7 @@ static int __dwc3_gadget_ep_disable(stru
 
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
-		__dwc3_gadget_ep_set_halt(dep, 0);
+		__dwc3_gadget_ep_set_halt(dep, 0, false);
 
 	reg = dwc3_readl(dwc->regs, DWC3_DALEPENA);
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
@@ -1205,7 +1205,7 @@ out0:
 	return ret;
 }
 
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 {
 	struct dwc3_gadget_ep_cmd_params	params;
 	struct dwc3				*dwc = dep->dwc;
@@ -1214,6 +1214,14 @@ int __dwc3_gadget_ep_set_halt(struct dwc
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
@@ -1253,7 +1261,7 @@ static int dwc3_gadget_ep_set_halt(struc
 		goto out;
 	}
 
-	ret = __dwc3_gadget_ep_set_halt(dep, value);
+	ret = __dwc3_gadget_ep_set_halt(dep, value, false);
 out:
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -1273,7 +1281,7 @@ static int dwc3_gadget_ep_set_wedge(stru
 	if (dep->number == 0 || dep->number == 1)
 		return dwc3_gadget_ep0_set_halt(ep, 1);
 	else
-		return dwc3_gadget_ep_set_halt(ep, 1);
+		return __dwc3_gadget_ep_set_halt(dep, 1, false);
 }
 
 /* -------------------------------------------------------------------------- */
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -114,7 +114,7 @@ void dwc3_ep0_out_start(struct dwc3 *dwc
 int dwc3_gadget_ep0_set_halt(struct usb_ep *ep, int value);
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value);
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
 int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
 		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params);
 int dwc3_send_gadget_generic_command(struct dwc3 *dwc, int cmd, u32 param);


