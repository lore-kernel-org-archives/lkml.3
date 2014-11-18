Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaKRORN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:17:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbaKROK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 191/206] usb: dwc3: gadget: fix set_halt() bug with pending transfers
Date: Tue, 18 Nov 2014 15:09:06 +0100
Message-Id: <4220f3ffc14964c3395c031334d088f6fd545009.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/dwc3/ep0.c    |  4 ++--
 drivers/usb/dwc3/gadget.c | 16 ++++++++++++----
 drivers/usb/dwc3/gadget.h |  2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 056da977ebdf..4a1922cafc8e 100644
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
index 2cdf69962e31..be149b82564f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -587,7 +587,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
-		__dwc3_gadget_ep_set_halt(dep, 0);
+		__dwc3_gadget_ep_set_halt(dep, 0, false);
 
 	reg = dwc3_readl(dwc->regs, DWC3_DALEPENA);
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
@@ -1185,7 +1185,7 @@ out0:
 	return ret;
 }
 
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 {
 	struct dwc3_gadget_ep_cmd_params	params;
 	struct dwc3				*dwc = dep->dwc;
@@ -1194,6 +1194,14 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
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
@@ -1233,7 +1241,7 @@ static int dwc3_gadget_ep_set_halt(struct usb_ep *ep, int value)
 		goto out;
 	}
 
-	ret = __dwc3_gadget_ep_set_halt(dep, value);
+	ret = __dwc3_gadget_ep_set_halt(dep, value, false);
 out:
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -1253,7 +1261,7 @@ static int dwc3_gadget_ep_set_wedge(struct usb_ep *ep)
 	if (dep->number == 0 || dep->number == 1)
 		return dwc3_gadget_ep0_set_halt(ep, 1);
 	else
-		return dwc3_gadget_ep_set_halt(ep, 1);
+		return __dwc3_gadget_ep_set_halt(dep, 1, false);
 }
 
 /* -------------------------------------------------------------------------- */
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index a0ee75b68a80..ac62558231be 100644
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
2.1.3

