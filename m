Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbbA1Euy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:50:54 -0500
Received: from mail.kernel.org ([198.145.29.136]:40001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934282AbbA1EW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:28 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 091/177] usb: dwc3: gadget: fix set_halt() bug with pending transfers
Date: Wed, 28 Jan 2015 12:09:09 +0800
Message-Id: <1422418236-12852-182-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4:
 - adjust context
 - drop the change to dwc3_gadget_ep_set_wedge()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/dwc3/ep0.c    |  4 ++--
 drivers/usb/dwc3/gadget.c | 14 +++++++++++---
 drivers/usb/dwc3/gadget.h |  2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 5bf2bc0..8a7a8ee 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -209,7 +209,7 @@ static void dwc3_ep0_stall_and_restart(struct dwc3 *dwc)
 	struct dwc3_ep		*dep = dwc->eps[0];
 
 	/* stall is always issued on EP0 */
-	__dwc3_gadget_ep_set_halt(dep, 1);
+	__dwc3_gadget_ep_set_halt(dep, 1, false);
 	dep->flags = DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 
@@ -382,7 +382,7 @@ static int dwc3_ep0_handle_feature(struct dwc3 *dwc,
 				return -EINVAL;
 			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
 				break;
-			ret = __dwc3_gadget_ep_set_halt(dep, set);
+			ret = __dwc3_gadget_ep_set_halt(dep, set, true);
 			if (ret)
 				return -EINVAL;
 			break;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 895497d..3ceb8da 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -533,7 +533,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	/* make sure HW endpoint isn't stalled */
 	if (dep->flags & DWC3_EP_STALL)
-		__dwc3_gadget_ep_set_halt(dep, 0);
+		__dwc3_gadget_ep_set_halt(dep, 0, false);
 
 	reg = dwc3_readl(dwc->regs, DWC3_DALEPENA);
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
@@ -1078,7 +1078,7 @@ out0:
 	return ret;
 }
 
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol)
 {
 	struct dwc3_gadget_ep_cmd_params	params;
 	struct dwc3				*dwc = dep->dwc;
@@ -1087,6 +1087,14 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
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
 		if (dep->number == 0 || dep->number == 1) {
 			/*
 			 * Whenever EP0 is stalled, we will restart
@@ -1135,7 +1143,7 @@ static int dwc3_gadget_ep_set_halt(struct usb_ep *ep, int value)
 		goto out;
 	}
 
-	ret = __dwc3_gadget_ep_set_halt(dep, value);
+	ret = __dwc3_gadget_ep_set_halt(dep, value, false);
 out:
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index a860008..6f498fc 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -108,7 +108,7 @@ void dwc3_ep0_interrupt(struct dwc3 *dwc,
 void dwc3_ep0_out_start(struct dwc3 *dwc);
 int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 		gfp_t gfp_flags);
-int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value);
+int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value, int protocol);
 int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
 		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params);
 
-- 
1.9.1

