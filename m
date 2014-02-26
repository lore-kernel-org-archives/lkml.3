Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaBZTas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:30:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:18347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaBZT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:29:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="462814137"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFCv3 3/4] xhci: Use completion and status in global command queue
Date: Wed, 26 Feb 2014 21:38:49 +0200
Message-Id: <1393443530-9216-4-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the per-device command list and handle_cmd_in_cmd_wait_list()
and use the completion and status variables found in the
command structure in the global command list.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c  | 11 -------
 drivers/usb/host/xhci-mem.c  |  1 -
 drivers/usb/host/xhci-ring.c | 78 +++++++-------------------------------------
 drivers/usb/host/xhci.c      | 16 ++-------
 drivers/usb/host/xhci.h      |  3 --
 5 files changed, 14 insertions(+), 95 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index fb0f936..0a57d95 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -299,7 +299,6 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 						 suspend);
 		}
 	}
-	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
 	xhci_queue_stop_endpoint(xhci, cmd, slot_id, 0, suspend);
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
@@ -311,18 +310,8 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
-		spin_lock_irqsave(&xhci->lock, flags);
-		/* The timeout might have raced with the event ring handler, so
-		 * only delete from the list if the item isn't poisoned.
-		 */
-		if (cmd->cmd_list.next != LIST_POISON1)
-			list_del(&cmd->cmd_list);
-		spin_unlock_irqrestore(&xhci->lock, flags);
 		ret = -ETIME;
-		goto command_cleanup;
 	}
-
-command_cleanup:
 	xhci_free_command(xhci, cmd);
 	return ret;
 }
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 9df2aa0..81c2469 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -919,7 +919,6 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 	dev->num_rings_cached = 0;
 
 	init_completion(&dev->cmd_completion);
-	INIT_LIST_HEAD(&dev->cmd_list);
 	dev->udev = udev;
 
 	/* Point to output device context in dcbaa. */
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 39d3ff7..12bf467 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -69,10 +69,6 @@
 #include "xhci.h"
 #include "xhci-trace.h"
 
-static int handle_cmd_in_cmd_wait_list(struct xhci_hcd *xhci,
-		struct xhci_virt_device *virt_dev,
-		struct xhci_event_cmd *event);
-
 /*
  * Returns zero if the TRB isn't in this segment, otherwise it returns the DMA
  * address of the TRB.
@@ -755,7 +751,6 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 		union xhci_trb *trb, struct xhci_event_cmd *event)
 {
 	unsigned int ep_index;
-	struct xhci_virt_device *virt_dev;
 	struct xhci_ring *ep_ring;
 	struct xhci_virt_ep *ep;
 	struct list_head *entry;
@@ -765,11 +760,7 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 	struct xhci_dequeue_state deq_state;
 
 	if (unlikely(TRB_TO_SUSPEND_PORT(le32_to_cpu(trb->generic.field[3])))) {
-		virt_dev = xhci->devs[slot_id];
-		if (virt_dev)
-			handle_cmd_in_cmd_wait_list(xhci, virt_dev,
-				event);
-		else
+		if (!xhci->devs[slot_id])
 			xhci_warn(xhci, "Stop endpoint command "
 				"completion for disabled slot %u\n",
 				slot_id);
@@ -1197,29 +1188,6 @@ static void xhci_complete_cmd_in_cmd_wait_list(struct xhci_hcd *xhci,
 }
 
 
-/* Check to see if a command in the device's command queue matches this one.
- * Signal the completion or free the command, and return 1.  Return 0 if the
- * completed command isn't at the head of the command list.
- */
-static int handle_cmd_in_cmd_wait_list(struct xhci_hcd *xhci,
-		struct xhci_virt_device *virt_dev,
-		struct xhci_event_cmd *event)
-{
-	struct xhci_command *command;
-
-	if (list_empty(&virt_dev->cmd_list))
-		return 0;
-
-	command = list_entry(virt_dev->cmd_list.next,
-			struct xhci_command, cmd_list);
-	if (xhci->cmd_ring->dequeue != command->command_trb)
-		return 0;
-
-	xhci_complete_cmd_in_cmd_wait_list(xhci, command,
-			GET_COMP_CODE(le32_to_cpu(event->status)));
-	return 1;
-}
-
 /*
  * Finding the command trb need to be cancelled and modifying it to
  * NO OP command. And if the command is in device's command wait
@@ -1371,7 +1339,6 @@ static void xhci_handle_cmd_enable_slot(struct xhci_hcd *xhci, int slot_id,
 		xhci->slot_id = slot_id;
 	else
 		xhci->slot_id = 0;
-	complete(&xhci->addr_dev);
 }
 
 static void xhci_handle_cmd_disable_slot(struct xhci_hcd *xhci, int slot_id)
@@ -1396,9 +1363,6 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
 	unsigned int ep_state;
 	u32 add_flags, drop_flags;
 
-	virt_dev = xhci->devs[slot_id];
-	if (handle_cmd_in_cmd_wait_list(xhci, virt_dev, event))
-		return;
 	/*
 	 * Configure endpoint commands can come from the USB core
 	 * configuration or alt setting changes, or because the HW
@@ -1407,6 +1371,7 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
 	 * If the command was for a halted endpoint, the xHCI driver
 	 * is not waiting on the configure endpoint command.
 	 */
+	virt_dev = xhci->devs[slot_id];
 	ctrl_ctx = xhci_get_input_control_ctx(xhci, virt_dev->in_ctx);
 	if (!ctrl_ctx) {
 		xhci_warn(xhci, "Could not get input context, bad type.\n");
@@ -1442,35 +1407,11 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
 	return;
 }
 
-static void xhci_handle_cmd_eval_ctx(struct xhci_hcd *xhci, int slot_id,
-		struct xhci_event_cmd *event, u32 cmd_comp_code)
-{
-	struct xhci_virt_device *virt_dev;
-
-	virt_dev = xhci->devs[slot_id];
-	if (handle_cmd_in_cmd_wait_list(xhci, virt_dev, event))
-		return;
-	virt_dev->cmd_status = cmd_comp_code;
-	complete(&virt_dev->cmd_completion);
-}
-
-static void xhci_handle_cmd_addr_dev(struct xhci_hcd *xhci, int slot_id,
-		u32 cmd_comp_code)
-{
-	xhci->devs[slot_id]->cmd_status = cmd_comp_code;
-	complete(&xhci->addr_dev);
-}
-
 static void xhci_handle_cmd_reset_dev(struct xhci_hcd *xhci, int slot_id,
 		struct xhci_event_cmd *event)
 {
-	struct xhci_virt_device *virt_dev;
-
 	xhci_dbg(xhci, "Completed reset device command.\n");
-	virt_dev = xhci->devs[slot_id];
-	if (virt_dev)
-		handle_cmd_in_cmd_wait_list(xhci, virt_dev, event);
-	else
+	if (!xhci->devs[slot_id])
 		xhci_warn(xhci, "Reset device command completion "
 				"for disabled slot %u\n", slot_id);
 }
@@ -1552,13 +1493,13 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci_handle_cmd_disable_slot(xhci, slot_id);
 		break;
 	case TRB_CONFIG_EP:
-		xhci_handle_cmd_config_ep(xhci, slot_id, event, cmd_comp_code);
+		if (!cmd->completion)
+			xhci_handle_cmd_config_ep(xhci, slot_id, event,
+						  cmd_comp_code);
 		break;
 	case TRB_EVAL_CONTEXT:
-		xhci_handle_cmd_eval_ctx(xhci, slot_id, event, cmd_comp_code);
 		break;
 	case TRB_ADDR_DEV:
-		xhci_handle_cmd_addr_dev(xhci, slot_id, cmd_comp_code);
 		break;
 	case TRB_STOP_RING:
 		WARN_ON(slot_id != TRB_TO_SLOT_ID(
@@ -1593,8 +1534,13 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 
 	list_del(&cmd->cmd_list);
 
-	if (!cmd->completion)
+	if (cmd->completion) {
+		/* the caller waiting for completion should free the command */
+		cmd->status = cmd_comp_code;
+		complete(cmd->completion);
+	} else {
 		kfree(cmd);
+	}
 
 	inc_deq(xhci, xhci->cmd_ring);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 97de328..4dc88ae 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2622,8 +2622,6 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 		return -ENOMEM;
 	}
 
-	list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
-
 	if (!ctx_change)
 		ret = xhci_queue_configure_endpoint(xhci, command,
 				command->in_ctx->dma,
@@ -2633,7 +2631,6 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 				command->in_ctx->dma,
 				udev->slot_id, must_succeed);
 	if (ret < 0) {
-		list_del(&command->cmd_list);
 		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
 			xhci_free_host_resources(xhci, ctrl_ctx);
 		spin_unlock_irqrestore(&xhci->lock, flags);
@@ -3473,11 +3470,9 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	/* Attempt to submit the Reset Device command to the command ring */
 	spin_lock_irqsave(&xhci->lock, flags);
 
-	list_add_tail(&reset_device_cmd->cmd_list, &virt_dev->cmd_list);
 	ret = xhci_queue_reset_device(xhci, reset_device_cmd, slot_id);
 	if (ret) {
 		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
-		list_del(&reset_device_cmd->cmd_list);
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		goto command_cleanup;
 	}
@@ -3491,13 +3486,6 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for reset device command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
-		spin_lock_irqsave(&xhci->lock, flags);
-		/* The timeout might have raced with the event ring handler, so
-		 * only delete from the list if the item isn't poisoned.
-		 */
-		if (reset_device_cmd->cmd_list.next != LIST_POISON1)
-			list_del(&reset_device_cmd->cmd_list);
-		spin_unlock_irqrestore(&xhci->lock, flags);
 		ret = -ETIME;
 		goto command_cleanup;
 	}
@@ -3864,7 +3852,7 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 		return -ETIME;
 	}
 
-	switch (virt_dev->cmd_status) {
+	switch (command->status) {
 	case COMP_CTX_STATE:
 	case COMP_EBADSLT:
 		xhci_err(xhci, "Setup ERROR: setup %s command for slot %d.\n",
@@ -3887,7 +3875,7 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 	default:
 		xhci_err(xhci,
 			 "ERROR: unexpected setup %s command completion code 0x%x.\n",
-			 act, virt_dev->cmd_status);
+			 act, command->status);
 		xhci_dbg(xhci, "Slot ID %d Output Context:\n", udev->slot_id);
 		xhci_dbg_ctx(xhci, virt_dev->out_ctx, 2);
 		trace_xhci_address_ctx(xhci, virt_dev->out_ctx, 1);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7052b8c..217e5b0 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -938,9 +938,6 @@ struct xhci_virt_device {
 #define	XHCI_MAX_RINGS_CACHED	31
 	struct xhci_virt_ep		eps[31];
 	struct completion		cmd_completion;
-	/* Status of the last command issued for this device */
-	u32				cmd_status;
-	struct list_head		cmd_list;
 	u8				fake_port;
 	u8				real_port;
 	struct xhci_interval_bw_table	*bw_table;
-- 
1.8.1.2

