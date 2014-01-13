Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaAMO6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:58:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:44471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaAMO61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939216"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 01/10] xhci: Use command structures when calling xhci_configure_endpoint
Date: Mon, 13 Jan 2014 17:05:50 +0200
Message-Id: <1389625559-32414-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To create a global command queue we need to fill a command structure
for each entry on the command ring.

We start by requiring xhci_configure_endpoint() to be called with
a proper command structure. Functions xhci_check_maxpacket and xhci_check_bandwith
that called xhci_configure_endpoint without a command strucure are fixed.

A special case where an endpoint needs to be configured after reset, done in interrupt
context is also changed to create a command strucure. (this command
structure is not used yet, but will be later when we requre all queued commands
to have a command strucure)

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 10 ++---
 drivers/usb/host/xhci.c      | 95 +++++++++++++++++++++++---------------------
 2 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1e2f3f4..da83a844 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1180,12 +1180,15 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 	 * because the HW can't handle two commands being queued in a row.
 	 */
 	if (xhci->quirks & XHCI_RESET_EP_QUIRK) {
+		struct xhci_command *command;
+		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"Queueing configure endpoint command");
 		xhci_queue_configure_endpoint(xhci,
 				xhci->devs[slot_id]->in_ctx->dma, slot_id,
 				false);
 		xhci_ring_cmd_db(xhci);
+		kfree(command);
 	} else {
 		/* Clear our internal halted state and restart the ring(s) */
 		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
@@ -1439,7 +1442,7 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
 			add_flags - SLOT_FLAG == drop_flags) {
 		ep_state = virt_dev->eps[ep_index].ep_state;
 		if (!(ep_state & EP_HALTED))
-			goto bandwidth_change;
+			return;
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"Completed config ep cmd - "
 				"last ep index = %d, state = %d",
@@ -1449,11 +1452,6 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 		return;
 	}
-bandwidth_change:
-	xhci_dbg_trace(xhci,  trace_xhci_dbg_context_change,
-			"Completed config ep cmd");
-	virt_dev->cmd_status = cmd_comp_code;
-	complete(&virt_dev->cmd_completion);
 	return;
 }
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4265b48..5e65052 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1179,10 +1179,10 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, struct urb *urb)
 {
-	struct xhci_container_ctx *in_ctx;
 	struct xhci_container_ctx *out_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
 	struct xhci_ep_ctx *ep_ctx;
+	struct xhci_command *command;
 	int max_packet_size;
 	int hw_max_packet_size;
 	int ret = 0;
@@ -1207,18 +1207,24 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 		/* FIXME: This won't work if a non-default control endpoint
 		 * changes max packet sizes.
 		 */
-		in_ctx = xhci->devs[slot_id]->in_ctx;
-		ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
+
+		command = xhci_alloc_command(xhci, false, true, GFP_KERNEL);
+		if (!command)
+			return -ENOMEM;
+
+		command->in_ctx = xhci->devs[slot_id]->in_ctx;
+		ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
 		if (!ctrl_ctx) {
 			xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
 					__func__);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto command_cleanup;
 		}
 		/* Set up the modified control endpoint 0 */
 		xhci_endpoint_copy(xhci, xhci->devs[slot_id]->in_ctx,
 				xhci->devs[slot_id]->out_ctx, ep_index);
 
-		ep_ctx = xhci_get_ep_ctx(xhci, in_ctx, ep_index);
+		ep_ctx = xhci_get_ep_ctx(xhci, command->in_ctx, ep_index);
 		ep_ctx->ep_info2 &= cpu_to_le32(~MAX_PACKET_MASK);
 		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet_size));
 
@@ -1226,16 +1232,20 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 		ctrl_ctx->drop_flags = 0;
 
 		xhci_dbg(xhci, "Slot %d input context\n", slot_id);
-		xhci_dbg_ctx(xhci, in_ctx, ep_index);
+		xhci_dbg_ctx(xhci, command->in_ctx, ep_index);
 		xhci_dbg(xhci, "Slot %d output context\n", slot_id);
 		xhci_dbg_ctx(xhci, out_ctx, ep_index);
 
-		ret = xhci_configure_endpoint(xhci, urb->dev, NULL,
+		ret = xhci_configure_endpoint(xhci, urb->dev, command,
 				true, false);
 
 		/* Clean up the input context for later use by bandwidth
 		 * functions.
 		 */
+command_cleanup:
+		kfree(command->completion);
+		kfree(command);
+
 		ctrl_ctx->add_flags = cpu_to_le32(SLOT_FLAG);
 	}
 	return ret;
@@ -2568,21 +2578,16 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	int ret;
 	int timeleft;
 	unsigned long flags;
-	struct xhci_container_ctx *in_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
-	struct completion *cmd_completion;
-	u32 *cmd_status;
 	struct xhci_virt_device *virt_dev;
-	union xhci_trb *cmd_trb;
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	virt_dev = xhci->devs[udev->slot_id];
 
-	if (command)
-		in_ctx = command->in_ctx;
-	else
-		in_ctx = virt_dev->in_ctx;
-	ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
+	if (!command)
+		return -EINVAL;
+
+	ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
 	if (!ctrl_ctx) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
@@ -2599,7 +2604,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 		return -ENOMEM;
 	}
 	if ((xhci->quirks & XHCI_SW_BW_CHECKING) &&
-			xhci_reserve_bandwidth(xhci, virt_dev, in_ctx)) {
+	    xhci_reserve_bandwidth(xhci, virt_dev, command->in_ctx)) {
 		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
 			xhci_free_host_resources(xhci, ctrl_ctx);
 		spin_unlock_irqrestore(&xhci->lock, flags);
@@ -2607,27 +2612,17 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 		return -ENOMEM;
 	}
 
-	if (command) {
-		cmd_completion = command->completion;
-		cmd_status = &command->status;
-		command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
-		list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
-	} else {
-		cmd_completion = &virt_dev->cmd_completion;
-		cmd_status = &virt_dev->cmd_status;
-	}
-	init_completion(cmd_completion);
+	command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
+	list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
 
-	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	if (!ctx_change)
-		ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,
+		ret = xhci_queue_configure_endpoint(xhci, command->in_ctx->dma,
 				udev->slot_id, must_succeed);
 	else
-		ret = xhci_queue_evaluate_context(xhci, in_ctx->dma,
+		ret = xhci_queue_evaluate_context(xhci, command->in_ctx->dma,
 				udev->slot_id, must_succeed);
 	if (ret < 0) {
-		if (command)
-			list_del(&command->cmd_list);
+		list_del(&command->cmd_list);
 		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
 			xhci_free_host_resources(xhci, ctrl_ctx);
 		spin_unlock_irqrestore(&xhci->lock, flags);
@@ -2640,7 +2635,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 
 	/* Wait for the configure endpoint command to complete */
 	timeleft = wait_for_completion_interruptible_timeout(
-			cmd_completion,
+			command->completion,
 			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for %s command\n",
@@ -2649,16 +2644,18 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 					"configure endpoint" :
 					"evaluate context");
 		/* cancel the configure endpoint command */
-		ret = xhci_cancel_cmd(xhci, command, cmd_trb);
+		ret = xhci_cancel_cmd(xhci, command, command->command_trb);
 		if (ret < 0)
 			return ret;
 		return -ETIME;
 	}
 
 	if (!ctx_change)
-		ret = xhci_configure_endpoint_result(xhci, udev, cmd_status);
+		ret = xhci_configure_endpoint_result(xhci, udev,
+						     &command->status);
 	else
-		ret = xhci_evaluate_context_result(xhci, udev, cmd_status);
+		ret = xhci_evaluate_context_result(xhci, udev,
+						   &command->status);
 
 	if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK)) {
 		spin_lock_irqsave(&xhci->lock, flags);
@@ -2692,6 +2689,7 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_virt_device	*virt_dev;
 	struct xhci_input_control_ctx *ctrl_ctx;
 	struct xhci_slot_ctx *slot_ctx;
+	struct xhci_command *command;
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	if (ret <= 0)
@@ -2703,12 +2701,16 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 	xhci_dbg(xhci, "%s called for udev %p\n", __func__, udev);
 	virt_dev = xhci->devs[udev->slot_id];
 
+	command = xhci_alloc_command(xhci, false, true, GFP_KERNEL);
+	command->in_ctx = virt_dev->in_ctx;
+
 	/* See section 4.6.6 - A0 = 1; A1 = D0 = D1 = 0 */
-	ctrl_ctx = xhci_get_input_control_ctx(xhci, virt_dev->in_ctx);
+	ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
 	if (!ctrl_ctx) {
 		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
 				__func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto command_cleanup;
 	}
 	ctrl_ctx->add_flags |= cpu_to_le32(SLOT_FLAG);
 	ctrl_ctx->add_flags &= cpu_to_le32(~EP0_FLAG);
@@ -2716,20 +2718,20 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 
 	/* Don't issue the command if there's no endpoints to update. */
 	if (ctrl_ctx->add_flags == cpu_to_le32(SLOT_FLAG) &&
-			ctrl_ctx->drop_flags == 0)
-		return 0;
-
+	    ctrl_ctx->drop_flags == 0) {
+		ret = 0;
+		goto command_cleanup;
+	}
 	xhci_dbg(xhci, "New Input Control Context:\n");
 	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx,
 		     LAST_CTX_TO_EP_NUM(le32_to_cpu(slot_ctx->dev_info)));
 
-	ret = xhci_configure_endpoint(xhci, udev, NULL,
+	ret = xhci_configure_endpoint(xhci, udev, command,
 			false, false);
-	if (ret) {
+	if (ret)
 		/* Callee should call reset_bandwidth() */
-		return ret;
-	}
+		goto command_cleanup;
 
 	xhci_dbg(xhci, "Output context after successful config ep cmd:\n");
 	xhci_dbg_ctx(xhci, virt_dev->out_ctx,
@@ -2758,6 +2760,9 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		virt_dev->eps[i].ring = virt_dev->eps[i].new_ring;
 		virt_dev->eps[i].new_ring = NULL;
 	}
+command_cleanup:
+	kfree(command->completion);
+	kfree(command);
 
 	return ret;
 }
-- 
1.8.1.2

