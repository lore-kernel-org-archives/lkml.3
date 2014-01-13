Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaAMO6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:58:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:16954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaAMO6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939380"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 07/10] xhci: Use command structured when queuing commands
Date: Mon, 13 Jan 2014 17:05:56 +0200
Message-Id: <1389625559-32414-8-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require each queued command to have a command structure.
We store the command trb pointer in the structure when queuing it,
making the find_next_enqueue() function obsolete.

Don't free the command strucures right away after sending the commands,
We will free the commands when we receive a "command handled" event
in a later patch.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c  |  8 ++--
 drivers/usb/host/xhci-ring.c | 94 ++++++++++++++++++++++----------------------
 drivers/usb/host/xhci.c      | 47 +++++++++++-----------
 drivers/usb/host/xhci.h      | 31 ++++++++-------
 4 files changed, 91 insertions(+), 89 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index f93c842..3a08e26 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -292,14 +292,14 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 			if (!command) {
 				xhci_free_command(xhci, cmd);
 				return -ENOMEM;
+
 			}
-			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
-			kfree(command);
+			xhci_queue_stop_endpoint(xhci, command, slot_id, i,
+						 suspend);
 		}
 	}
-	cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
-	xhci_queue_stop_endpoint(xhci, slot_id, 0, suspend);
+	xhci_queue_stop_endpoint(xhci, cmd, slot_id, 0, suspend);
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index bf50d28..6f6018c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -123,16 +123,6 @@ static int enqueue_is_link_trb(struct xhci_ring *ring)
 	return TRB_TYPE_LINK_LE32(link->control);
 }
 
-union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring)
-{
-	/* Enqueue pointer can be left pointing to the link TRB,
-	 * we must handle that
-	 */
-	if (TRB_TYPE_LINK_LE32(ring->enqueue->link.control))
-		return ring->enq_seg->next->trbs;
-	return ring->enqueue;
-}
-
 /* Updates trb to point to the next TRB in the ring, and updates seg if the next
  * TRB is in a new segment.  This does not skip over link TRBs, and it does not
  * effect the ring dequeue or enqueue pointers.
@@ -680,12 +670,14 @@ static void td_to_noop(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 	}
 }
 
-static int queue_set_tr_deq(struct xhci_hcd *xhci, int slot_id,
+static int queue_set_tr_deq(struct xhci_hcd *xhci,
+		struct xhci_command *cmd, int slot_id,
 		unsigned int ep_index, unsigned int stream_id,
 		struct xhci_segment *deq_seg,
 		union xhci_trb *deq_ptr, u32 cycle_state);
 
 void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
+		struct xhci_command *cmd,
 		unsigned int slot_id, unsigned int ep_index,
 		unsigned int stream_id,
 		struct xhci_dequeue_state *deq_state)
@@ -700,7 +692,7 @@ void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
 			deq_state->new_deq_ptr,
 			(unsigned long long)xhci_trb_virt_to_dma(deq_state->new_deq_seg, deq_state->new_deq_ptr),
 			deq_state->new_cycle_state);
-	queue_set_tr_deq(xhci, slot_id, ep_index, stream_id,
+	queue_set_tr_deq(xhci, cmd, slot_id, ep_index, stream_id,
 			deq_state->new_deq_seg,
 			deq_state->new_deq_ptr,
 			(u32) deq_state->new_cycle_state);
@@ -857,12 +849,11 @@ remove_finished_td:
 	if (deq_state.new_deq_ptr && deq_state.new_deq_seg) {
 		struct xhci_command *command;
 		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
-		xhci_queue_new_dequeue_state(xhci,
+		xhci_queue_new_dequeue_state(xhci, command,
 				slot_id, ep_index,
 				ep->stopped_td->urb->stream_id,
 				&deq_state);
 		xhci_ring_cmd_db(xhci);
-		kfree(command);
 	} else {
 		/* Otherwise ring the doorbell(s) to restart queued transfers */
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
@@ -1187,11 +1178,10 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"Queueing configure endpoint command");
-		xhci_queue_configure_endpoint(xhci,
+		xhci_queue_configure_endpoint(xhci, command,
 				xhci->devs[slot_id]->in_ctx->dma, slot_id,
 				false);
 		xhci_ring_cmd_db(xhci);
-		kfree(command);
 	} else {
 		/* Clear our internal halted state and restart the ring(s) */
 		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
@@ -1922,7 +1912,7 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 	ep->stopped_trb = event_trb;
 	ep->stopped_stream = stream_id;
 
-	xhci_queue_reset_ep(xhci, slot_id, ep_index);
+	xhci_queue_reset_ep(xhci, command, slot_id, ep_index);
 	xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
 
 	ep->stopped_td = NULL;
@@ -1930,7 +1920,6 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 	ep->stopped_stream = 0;
 
 	xhci_ring_cmd_db(xhci);
-	kfree(command);
 }
 
 /* Check if an error has halted the endpoint ring.  The class driver will
@@ -2638,7 +2627,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				 * successful event after a short transfer.
 				 * Ignore it.
 				 */
-				if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) && 
+				if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) &&
 						ep_ring->last_td_was_short) {
 					ep_ring->last_td_was_short = false;
 					ret = 0;
@@ -3980,8 +3969,9 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
  * Don't decrement xhci->cmd_ring_reserved_trbs after we've queued the TRB
  * because the command event handler may want to resubmit a failed command.
  */
-static int queue_command(struct xhci_hcd *xhci, u32 field1, u32 field2,
-		u32 field3, u32 field4, bool command_must_succeed)
+static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			 u32 field1, u32 field2,
+			 u32 field3, u32 field4, bool command_must_succeed)
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
 	int ret;
@@ -3998,57 +3988,64 @@ static int queue_command(struct xhci_hcd *xhci, u32 field1, u32 field2,
 					"unfailable commands failed.\n");
 		return ret;
 	}
+	cmd->command_trb = xhci->cmd_ring->enqueue;
+
 	queue_trb(xhci, xhci->cmd_ring, false, field1, field2, field3,
 			field4 | xhci->cmd_ring->cycle_state);
 	return 0;
 }
 
 /* Queue a slot enable or disable request on the command ring */
-int xhci_queue_slot_control(struct xhci_hcd *xhci, u32 trb_type, u32 slot_id)
+int xhci_queue_slot_control(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			    u32 trb_type, u32 slot_id)
 {
-	return queue_command(xhci, 0, 0, 0,
+	return queue_command(xhci, cmd, 0, 0, 0,
 			TRB_TYPE(trb_type) | SLOT_ID_FOR_TRB(slot_id), false);
 }
 
 /* Queue an address device command TRB */
-int xhci_queue_address_device(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
-		u32 slot_id)
+int xhci_queue_address_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			      dma_addr_t in_ctx_ptr, u32 slot_id)
 {
-	return queue_command(xhci, lower_32_bits(in_ctx_ptr),
+	return queue_command(xhci, cmd, lower_32_bits(in_ctx_ptr),
 			upper_32_bits(in_ctx_ptr), 0,
 			TRB_TYPE(TRB_ADDR_DEV) | SLOT_ID_FOR_TRB(slot_id),
 			false);
 }
 
-int xhci_queue_vendor_command(struct xhci_hcd *xhci,
+int xhci_queue_vendor_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 		u32 field1, u32 field2, u32 field3, u32 field4)
 {
-	return queue_command(xhci, field1, field2, field3, field4, false);
+	return queue_command(xhci, cmd, field1, field2, field3, field4, false);
 }
 
 /* Queue a reset device command TRB */
-int xhci_queue_reset_device(struct xhci_hcd *xhci, u32 slot_id)
+int xhci_queue_reset_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			    u32 slot_id)
 {
-	return queue_command(xhci, 0, 0, 0,
+	return queue_command(xhci, cmd, 0, 0, 0,
 			TRB_TYPE(TRB_RESET_DEV) | SLOT_ID_FOR_TRB(slot_id),
 			false);
 }
 
 /* Queue a configure endpoint command TRB */
-int xhci_queue_configure_endpoint(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
-		u32 slot_id, bool command_must_succeed)
+int xhci_queue_configure_endpoint(struct xhci_hcd *xhci,
+				  struct xhci_command *cmd,
+				  dma_addr_t in_ctx_ptr,
+				  u32 slot_id, bool command_must_succeed)
 {
-	return queue_command(xhci, lower_32_bits(in_ctx_ptr),
+	return queue_command(xhci, cmd, lower_32_bits(in_ctx_ptr),
 			upper_32_bits(in_ctx_ptr), 0,
 			TRB_TYPE(TRB_CONFIG_EP) | SLOT_ID_FOR_TRB(slot_id),
 			command_must_succeed);
 }
 
 /* Queue an evaluate context command TRB */
-int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
-		u32 slot_id, bool command_must_succeed)
+int xhci_queue_evaluate_context(struct xhci_hcd *xhci, struct xhci_command *cmd,
+				dma_addr_t in_ctx_ptr,
+				u32 slot_id, bool command_must_succeed)
 {
-	return queue_command(xhci, lower_32_bits(in_ctx_ptr),
+	return queue_command(xhci, cmd, lower_32_bits(in_ctx_ptr),
 			upper_32_bits(in_ctx_ptr), 0,
 			TRB_TYPE(TRB_EVAL_CONTEXT) | SLOT_ID_FOR_TRB(slot_id),
 			command_must_succeed);
@@ -4058,25 +4055,26 @@ int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
  * Suspend is set to indicate "Stop Endpoint Command" is being issued to stop
  * activity on an endpoint that is about to be suspended.
  */
-int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, int slot_id,
-		unsigned int ep_index, int suspend)
+int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			     int slot_id, unsigned int ep_index, int suspend)
 {
 	u32 trb_slot_id = SLOT_ID_FOR_TRB(slot_id);
 	u32 trb_ep_index = EP_ID_FOR_TRB(ep_index);
 	u32 type = TRB_TYPE(TRB_STOP_RING);
 	u32 trb_suspend = SUSPEND_PORT_FOR_TRB(suspend);
 
-	return queue_command(xhci, 0, 0, 0,
+	return queue_command(xhci, cmd, 0, 0, 0,
 			trb_slot_id | trb_ep_index | type | trb_suspend, false);
 }
 
 /* Set Transfer Ring Dequeue Pointer command.
  * This should not be used for endpoints that have streams enabled.
  */
-static int queue_set_tr_deq(struct xhci_hcd *xhci, int slot_id,
-		unsigned int ep_index, unsigned int stream_id,
-		struct xhci_segment *deq_seg,
-		union xhci_trb *deq_ptr, u32 cycle_state)
+static int queue_set_tr_deq(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			int slot_id,
+			unsigned int ep_index, unsigned int stream_id,
+			struct xhci_segment *deq_seg,
+			union xhci_trb *deq_ptr, u32 cycle_state)
 {
 	dma_addr_t addr;
 	u32 trb_slot_id = SLOT_ID_FOR_TRB(slot_id);
@@ -4100,18 +4098,18 @@ static int queue_set_tr_deq(struct xhci_hcd *xhci, int slot_id,
 	}
 	ep->queued_deq_seg = deq_seg;
 	ep->queued_deq_ptr = deq_ptr;
-	return queue_command(xhci, lower_32_bits(addr) | cycle_state,
+	return queue_command(xhci, cmd, lower_32_bits(addr) | cycle_state,
 			upper_32_bits(addr), trb_stream_id,
 			trb_slot_id | trb_ep_index | type, false);
 }
 
-int xhci_queue_reset_ep(struct xhci_hcd *xhci, int slot_id,
-		unsigned int ep_index)
+int xhci_queue_reset_ep(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			int slot_id, unsigned int ep_index)
 {
 	u32 trb_slot_id = SLOT_ID_FOR_TRB(slot_id);
 	u32 trb_ep_index = EP_ID_FOR_TRB(ep_index);
 	u32 type = TRB_TYPE(TRB_RESET_EP);
 
-	return queue_command(xhci, 0, 0, 0, trb_slot_id | trb_ep_index | type,
-			false);
+	return queue_command(xhci, cmd, 0, 0, 0,
+			     trb_slot_id | trb_ep_index | type, false);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 23e057f..6d6e888 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -631,10 +631,14 @@ int xhci_run(struct usb_hcd *hcd)
 			&xhci->ir_set->irq_pending);
 	xhci_print_ir_set(xhci, 0);
 
-	if (xhci->quirks & XHCI_NEC_HOST)
-		xhci_queue_vendor_command(xhci, 0, 0, 0,
+	if (xhci->quirks & XHCI_NEC_HOST) {
+		struct xhci_command *command;
+		command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
+		if (!command)
+			return -ENOMEM;
+		xhci_queue_vendor_command(xhci, command,  0, 0, 0,
 				TRB_TYPE(TRB_NEC_GET_FW));
-
+	}
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 	return 0;
@@ -1543,9 +1547,9 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		ep->stop_cmd_timer.expires = jiffies +
 			XHCI_STOP_EP_CMD_TIMEOUT * HZ;
 		add_timer(&ep->stop_cmd_timer);
-		xhci_queue_stop_endpoint(xhci, urb->dev->slot_id, ep_index, 0);
+		xhci_queue_stop_endpoint(xhci, command, urb->dev->slot_id,
+					 ep_index, 0);
 		xhci_ring_cmd_db(xhci);
-		kfree(command);
 	}
 done:
 	spin_unlock_irqrestore(&xhci->lock, flags);
@@ -2615,14 +2619,15 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 		return -ENOMEM;
 	}
 
-	command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
 
 	if (!ctx_change)
-		ret = xhci_queue_configure_endpoint(xhci, command->in_ctx->dma,
+		ret = xhci_queue_configure_endpoint(xhci, command,
+				command->in_ctx->dma,
 				udev->slot_id, must_succeed);
 	else
-		ret = xhci_queue_evaluate_context(xhci, command->in_ctx->dma,
+		ret = xhci_queue_evaluate_context(xhci, command,
+				command->in_ctx->dma,
 				udev->slot_id, must_succeed);
 	if (ret < 0) {
 		list_del(&command->cmd_list);
@@ -2874,9 +2879,8 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 			return;
 		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 				"Queueing new dequeue state");
-		xhci_queue_new_dequeue_state(xhci, udev->slot_id,
+		xhci_queue_new_dequeue_state(xhci, command, udev->slot_id,
 				ep_index, ep->stopped_stream, &deq_state);
-		kfree(command);
 	} else {
 		/* Better hope no one uses the input context between now and the
 		 * reset endpoint completion!
@@ -2936,7 +2940,7 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 	xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 			"Queueing reset endpoint command");
 	spin_lock_irqsave(&xhci->lock, flags);
-	ret = xhci_queue_reset_ep(xhci, udev->slot_id, ep_index);
+	ret = xhci_queue_reset_ep(xhci, command, udev->slot_id, ep_index);
 	/*
 	 * Can't change the ring dequeue pointer until it's transitioned to the
 	 * stopped state, which is only upon a successful reset endpoint
@@ -2951,7 +2955,6 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 	virt_ep->stopped_trb = NULL;
 	virt_ep->stopped_stream = 0;
 	spin_unlock_irqrestore(&xhci->lock, flags);
-	kfree(command);
 
 	if (ret)
 		xhci_warn(xhci, "FIXME allocate a new ring segment\n");
@@ -3463,10 +3466,9 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 
 	/* Attempt to submit the Reset Device command to the command ring */
 	spin_lock_irqsave(&xhci->lock, flags);
-	reset_device_cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 
 	list_add_tail(&reset_device_cmd->cmd_list, &virt_dev->cmd_list);
-	ret = xhci_queue_reset_device(xhci, slot_id);
+	ret = xhci_queue_reset_device(xhci, reset_device_cmd, slot_id);
 	if (ret) {
 		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
 		list_del(&reset_device_cmd->cmd_list);
@@ -3621,15 +3623,14 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		return;
 	}
 
-	if (xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id)) {
+	if (xhci_queue_slot_control(xhci, command, TRB_DISABLE_SLOT,
+				    udev->slot_id)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
-		kfree(command);
 		return;
 	}
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
-	kfree(command);
 
 	/*
 	 * Event command completion handler will free any data structures
@@ -3677,9 +3678,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		return 0;
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	command->completion = &xhci->addr_dev;
-	ret = xhci_queue_slot_control(xhci, TRB_ENABLE_SLOT, 0);
+	ret = xhci_queue_slot_control(xhci, command, TRB_ENABLE_SLOT, 0);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
@@ -3748,10 +3748,12 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 disable_slot:
 	/* Disable slot, if we can do it without mem alloc */
 	spin_lock_irqsave(&xhci->lock, flags);
-	if (!xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id))
+	command->completion = NULL;
+	command->status = 0;
+	if (!xhci_queue_slot_control(xhci, command, TRB_DISABLE_SLOT,
+				     udev->slot_id))
 		xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
-	kfree(command);
 	return 0;
 }
 
@@ -3826,8 +3828,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 				slot_ctx->dev_info >> 27);
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
-	ret = xhci_queue_address_device(xhci, virt_dev->in_ctx->dma,
+	ret = xhci_queue_address_device(xhci, command, virt_dev->in_ctx->dma,
 					udev->slot_id);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 03c74b7..d02b73d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1811,13 +1811,14 @@ struct xhci_segment *trb_in_td(struct xhci_segment *start_seg,
 		dma_addr_t suspect_dma);
 int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code);
 void xhci_ring_cmd_db(struct xhci_hcd *xhci);
-int xhci_queue_slot_control(struct xhci_hcd *xhci, u32 trb_type, u32 slot_id);
-int xhci_queue_address_device(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
-		u32 slot_id);
-int xhci_queue_vendor_command(struct xhci_hcd *xhci,
+int xhci_queue_slot_control(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			    u32 trb_type, u32 slot_id);
+int xhci_queue_address_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
+			      dma_addr_t in_ctx_ptr, u32 slot_id);
+int xhci_queue_vendor_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 		u32 field1, u32 field2, u32 field3, u32 field4);
-int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, int slot_id,
-		unsigned int ep_index, int suspend);
+int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, struct xhci_command *cmd,
+		int slot_id, unsigned int ep_index, int suspend);
 int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
 		int slot_id, unsigned int ep_index);
 int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
@@ -1826,18 +1827,21 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
 		int slot_id, unsigned int ep_index);
 int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
 		struct urb *urb, int slot_id, unsigned int ep_index);
-int xhci_queue_configure_endpoint(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
-		u32 slot_id, bool command_must_succeed);
-int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
-		u32 slot_id, bool command_must_succeed);
-int xhci_queue_reset_ep(struct xhci_hcd *xhci, int slot_id,
-		unsigned int ep_index);
-int xhci_queue_reset_device(struct xhci_hcd *xhci, u32 slot_id);
+int xhci_queue_configure_endpoint(struct xhci_hcd *xhci,
+		struct xhci_command *cmd, dma_addr_t in_ctx_ptr, u32 slot_id,
+		bool command_must_succeed);
+int xhci_queue_evaluate_context(struct xhci_hcd *xhci, struct xhci_command *cmd,
+		dma_addr_t in_ctx_ptr, u32 slot_id, bool command_must_succeed);
+int xhci_queue_reset_ep(struct xhci_hcd *xhci, struct xhci_command *cmd,
+		int slot_id, unsigned int ep_index);
+int xhci_queue_reset_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
+		u32 slot_id);
 void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 		unsigned int slot_id, unsigned int ep_index,
 		unsigned int stream_id, struct xhci_td *cur_td,
 		struct xhci_dequeue_state *state);
 void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
+		struct xhci_command *cmd,
 		unsigned int slot_id, unsigned int ep_index,
 		unsigned int stream_id,
 		struct xhci_dequeue_state *deq_state);
@@ -1851,7 +1855,6 @@ int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
 		union xhci_trb *cmd_trb);
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, unsigned int stream_id);
-union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring);
 
 /* xHCI roothub code */
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
-- 
1.8.1.2

