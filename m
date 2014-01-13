Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaAMO7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:59:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:16954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbaAMO6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939454"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 10/10] xhci: rework command timeout and cancellation,
Date: Mon, 13 Jan 2014 17:05:59 +0200
Message-Id: <1389625559-32414-11-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one timer to control command timeout.

start/kick the timer every time a command is completed and a
new command is waiting, or a new command is added to a empty list.

If the timer runs out, then tag the current command as "aborted", and
start the xhci command abortion process.

Previously each function that submitted a command had its own timer.
If that command timed out, a new command structure for
the command was created and it was put on a cancel_cmd_list list,
then a pci write to abort the command ring was issued.

when the ring was aborted, it checked if the current command
was the one to be cancelled, later when the ring was stopped the
driver got ownership of the TRBs in the command ring,
compared then to the TRBs in the cancel_cmd_list,
and turned them into No-ops.

Now, instead, at timeout we tag the status of the command in the
command queue to be aborted, and start the ring abortion.
Ring abortion stops the command ring and gives control of the commands to us.
All the aborted commands are now turned into No-ops.

This allows us to remove the entire cancel_cmd_list code.

The functions waiting for a command to finish no longer have their own timeouts.
They will wait either until the command completes normally,
or until the whole command abortion is done.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c  |  11 +-
 drivers/usb/host/xhci-mem.c  |  15 +-
 drivers/usb/host/xhci-ring.c | 336 +++++++++++++------------------------------
 drivers/usb/host/xhci.c      |  79 ++++------
 drivers/usb/host/xhci.h      |   8 +-
 5 files changed, 139 insertions(+), 310 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 78983d6..34daa5a 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -271,7 +271,6 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 	struct xhci_virt_device *virt_dev;
 	struct xhci_command *cmd;
 	unsigned long flags;
-	int timeleft;
 	int ret;
 	int i;
 
@@ -303,12 +302,10 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* Wait for last stop endpoint command to finish */
-	timeleft = wait_for_completion_interruptible_timeout(
-			cmd->completion,
-			XHCI_CMD_DEFAULT_TIMEOUT);
-	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
-				timeleft == 0 ? "Timeout" : "Signal");
+	wait_for_completion(cmd->completion);
+
+	if (cmd->status == COMP_CMD_ABORT || cmd->status == COMP_CMD_STOP) {
+		xhci_warn(xhci, "Timeout while waiting for stop endpoint command\n");
 		ret = -ETIME;
 	}
 	xhci_free_command(xhci, cmd);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 80b9c11..d27178b 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1692,7 +1692,6 @@ void xhci_free_command(struct xhci_hcd *xhci,
 void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct pci_dev	*pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
-	struct xhci_cd  *cur_cd, *next_cd;
 	struct xhci_command *cur_cmd, *next_cmd;
 	int size;
 	int i, j, num_ports;
@@ -1712,15 +1711,13 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	if (xhci->lpm_command)
 		xhci_free_command(xhci, xhci->lpm_command);
 	xhci->cmd_ring_reserved_trbs = 0;
+
+	del_timer_sync(&xhci->cmd_timer);
+
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Freed command ring");
-	list_for_each_entry_safe(cur_cd, next_cd,
-			&xhci->cancel_cmd_list, cancel_cmd_list) {
-		list_del(&cur_cd->cancel_cmd_list);
-		kfree(cur_cd);
-	}
 
 	list_for_each_entry_safe(cur_cmd, next_cmd,
 			&xhci->cmd_list, cmd_list) {
@@ -2228,7 +2225,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	u32 page_size, temp;
 	int i;
 
-	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 	INIT_LIST_HEAD(&xhci->cmd_list);
 
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
@@ -2414,6 +2410,11 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 			"Wrote ERST address to ir_set 0.");
 	xhci_print_ir_set(xhci, 0);
 
+	/* init command timeout timer */
+	init_timer(&xhci->cmd_timer);
+	xhci->cmd_timer.data = (unsigned long) xhci;
+	xhci->cmd_timer.function = xhci_handle_command_timeout;
+
 	/*
 	 * XXX: Might need to set the Interrupter Moderation Register to
 	 * something other than the default (~1ms minimum between interrupts).
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6b61787..ea8c60d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -329,71 +329,6 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci)
 	return 0;
 }
 
-static int xhci_queue_cd(struct xhci_hcd *xhci,
-		struct xhci_command *command,
-		union xhci_trb *cmd_trb)
-{
-	struct xhci_cd *cd;
-	cd = kzalloc(sizeof(struct xhci_cd), GFP_ATOMIC);
-	if (!cd)
-		return -ENOMEM;
-	INIT_LIST_HEAD(&cd->cancel_cmd_list);
-
-	cd->command = command;
-	cd->cmd_trb = cmd_trb;
-	list_add_tail(&cd->cancel_cmd_list, &xhci->cancel_cmd_list);
-
-	return 0;
-}
-
-/*
- * Cancel the command which has issue.
- *
- * Some commands may hang due to waiting for acknowledgement from
- * usb device. It is outside of the xHC's ability to control and
- * will cause the command ring is blocked. When it occurs software
- * should intervene to recover the command ring.
- * See Section 4.6.1.1 and 4.6.1.2
- */
-int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
-		union xhci_trb *cmd_trb)
-{
-	int retval = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&xhci->lock, flags);
-
-	if (xhci->xhc_state & XHCI_STATE_DYING) {
-		xhci_warn(xhci, "Abort the command ring,"
-				" but the xHCI is dead.\n");
-		retval = -ESHUTDOWN;
-		goto fail;
-	}
-
-	/* queue the cmd desriptor to cancel_cmd_list */
-	retval = xhci_queue_cd(xhci, command, cmd_trb);
-	if (retval) {
-		xhci_warn(xhci, "Queuing command descriptor failed.\n");
-		goto fail;
-	}
-
-	/* abort command ring */
-	retval = xhci_abort_cmd_ring(xhci);
-	if (retval) {
-		xhci_err(xhci, "Abort command ring failed\n");
-		if (unlikely(retval == -ESHUTDOWN)) {
-			spin_unlock_irqrestore(&xhci->lock, flags);
-			usb_hc_died(xhci_to_hcd(xhci)->primary_hcd);
-			xhci_dbg(xhci, "xHCI host controller is dead.\n");
-			return retval;
-		}
-	}
-
-fail:
-	spin_unlock_irqrestore(&xhci->lock, flags);
-	return retval;
-}
-
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci,
 		unsigned int slot_id,
 		unsigned int ep_index,
@@ -1180,164 +1115,6 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 	}
 }
 
-/* Complete the command and detele it from the devcie's command queue.
- */
-static void xhci_complete_cmd_in_cmd_wait_list(struct xhci_hcd *xhci,
-		struct xhci_command *command, u32 status)
-{
-	command->status = status;
-	list_del(&command->cmd_list);
-	if (command->completion)
-		complete(command->completion);
-	else
-		xhci_free_command(xhci, command);
-}
-
-
-/*
- * Finding the command trb need to be cancelled and modifying it to
- * NO OP command. And if the command is in device's command wait
- * list, finishing and freeing it.
- *
- * If we can't find the command trb, we think it had already been
- * executed.
- */
-static void xhci_cmd_to_noop(struct xhci_hcd *xhci, struct xhci_cd *cur_cd)
-{
-	struct xhci_segment *cur_seg;
-	union xhci_trb *cmd_trb;
-	u32 cycle_state;
-
-	if (xhci->cmd_ring->dequeue == xhci->cmd_ring->enqueue)
-		return;
-
-	/* find the current segment of command ring */
-	cur_seg = find_trb_seg(xhci->cmd_ring->first_seg,
-			xhci->cmd_ring->dequeue, &cycle_state);
-
-	if (!cur_seg) {
-		xhci_warn(xhci, "Command ring mismatch, dequeue = %p %llx (dma)\n",
-				xhci->cmd_ring->dequeue,
-				(unsigned long long)
-				xhci_trb_virt_to_dma(xhci->cmd_ring->deq_seg,
-					xhci->cmd_ring->dequeue));
-		xhci_debug_ring(xhci, xhci->cmd_ring);
-		xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
-		return;
-	}
-
-	/* find the command trb matched by cd from command ring */
-	for (cmd_trb = xhci->cmd_ring->dequeue;
-			cmd_trb != xhci->cmd_ring->enqueue;
-			next_trb(xhci, xhci->cmd_ring, &cur_seg, &cmd_trb)) {
-		/* If the trb is link trb, continue */
-		if (TRB_TYPE_LINK_LE32(cmd_trb->generic.field[3]))
-			continue;
-
-		if (cur_cd->cmd_trb == cmd_trb) {
-
-			/* If the command in device's command list, we should
-			 * finish it and free the command structure.
-			 */
-			if (cur_cd->command)
-				xhci_complete_cmd_in_cmd_wait_list(xhci,
-					cur_cd->command, COMP_CMD_STOP);
-
-			/* get cycle state from the origin command trb */
-			cycle_state = le32_to_cpu(cmd_trb->generic.field[3])
-				& TRB_CYCLE;
-
-			/* modify the command trb to NO OP command */
-			cmd_trb->generic.field[0] = 0;
-			cmd_trb->generic.field[1] = 0;
-			cmd_trb->generic.field[2] = 0;
-			cmd_trb->generic.field[3] = cpu_to_le32(
-					TRB_TYPE(TRB_CMD_NOOP) | cycle_state);
-			break;
-		}
-	}
-}
-
-static void xhci_cancel_cmd_in_cd_list(struct xhci_hcd *xhci)
-{
-	struct xhci_cd *cur_cd, *next_cd;
-
-	if (list_empty(&xhci->cancel_cmd_list))
-		return;
-
-	list_for_each_entry_safe(cur_cd, next_cd,
-			&xhci->cancel_cmd_list, cancel_cmd_list) {
-		xhci_cmd_to_noop(xhci, cur_cd);
-		list_del(&cur_cd->cancel_cmd_list);
-		kfree(cur_cd);
-	}
-}
-
-/*
- * traversing the cancel_cmd_list. If the command descriptor according
- * to cmd_trb is found, the function free it and return 1, otherwise
- * return 0.
- */
-static int xhci_search_cmd_trb_in_cd_list(struct xhci_hcd *xhci,
-		union xhci_trb *cmd_trb)
-{
-	struct xhci_cd *cur_cd, *next_cd;
-
-	if (list_empty(&xhci->cancel_cmd_list))
-		return 0;
-
-	list_for_each_entry_safe(cur_cd, next_cd,
-			&xhci->cancel_cmd_list, cancel_cmd_list) {
-		if (cur_cd->cmd_trb == cmd_trb) {
-			if (cur_cd->command)
-				xhci_complete_cmd_in_cmd_wait_list(xhci,
-					cur_cd->command, COMP_CMD_STOP);
-			list_del(&cur_cd->cancel_cmd_list);
-			kfree(cur_cd);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
-/*
- * If the cmd_trb_comp_code is COMP_CMD_ABORT, we just check whether the
- * trb pointed by the command ring dequeue pointer is the trb we want to
- * cancel or not. And if the cmd_trb_comp_code is COMP_CMD_STOP, we will
- * traverse the cancel_cmd_list to trun the all of the commands according
- * to command descriptor to NO-OP trb.
- */
-static int handle_stopped_cmd_ring(struct xhci_hcd *xhci,
-		int cmd_trb_comp_code)
-{
-	int cur_trb_is_good = 0;
-
-	/* Searching the cmd trb pointed by the command ring dequeue
-	 * pointer in command descriptor list. If it is found, free it.
-	 */
-	cur_trb_is_good = xhci_search_cmd_trb_in_cd_list(xhci,
-			xhci->cmd_ring->dequeue);
-
-	if (cmd_trb_comp_code == COMP_CMD_ABORT)
-		xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
-	else if (cmd_trb_comp_code == COMP_CMD_STOP) {
-		/* traversing the cancel_cmd_list and canceling
-		 * the command according to command descriptor
-		 */
-		xhci_cancel_cmd_in_cd_list(xhci);
-
-		xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
-		/*
-		 * ring command ring doorbell again to restart the
-		 * command ring
-		 */
-		if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue)
-			xhci_ring_cmd_db(xhci);
-	}
-	return cur_trb_is_good;
-}
-
 static void xhci_handle_cmd_enable_slot(struct xhci_hcd *xhci, int slot_id,
 		u32 cmd_comp_code)
 {
@@ -1435,6 +1212,30 @@ static void xhci_handle_cmd_nec_get_fw(struct xhci_hcd *xhci,
 			NEC_FW_MINOR(le32_to_cpu(event->status)));
 }
 
+void xhci_handle_command_timeout(unsigned long data)
+{
+	struct xhci_hcd *xhci;
+	int ret;
+	unsigned long flags;
+	xhci = (struct xhci_hcd *) data;
+	/* mark this command to be cancelled */
+	spin_lock_irqsave(&xhci->lock, flags);
+	if (xhci->current_cmd)
+		xhci->current_cmd->status = COMP_CMD_ABORT;
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	ret = xhci_abort_cmd_ring(xhci);
+
+	if (ret) {
+		xhci_err(xhci, "Abort command ring failed\n");
+		if (unlikely(ret == -ESHUTDOWN)) {
+			usb_hc_died(xhci_to_hcd(xhci)->primary_hcd);
+			xhci_dbg(xhci, "xHCI host controller is dead.\n");
+		}
+	}
+	return;
+}
+
 static void handle_cmd_completion(struct xhci_hcd *xhci,
 		struct xhci_event_cmd *event)
 {
@@ -1468,26 +1269,64 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 			 "Command completion event does not match command\n");
 		return;
 	}
+
+	del_timer(&xhci->cmd_timer);
+
 	trace_xhci_cmd_completion(cmd_trb, (struct xhci_generic_trb *) event);
 
 	cmd_comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
-	if (cmd_comp_code == COMP_CMD_ABORT || cmd_comp_code == COMP_CMD_STOP) {
-		/* If the return value is 0, we think the trb pointed by
-		 * command ring dequeue pointer is a good trb. The good
-		 * trb means we don't want to cancel the trb, but it have
-		 * been stopped by host. So we should handle it normally.
-		 * Otherwise, driver should invoke inc_deq() and return.
-		 */
-		if (handle_stopped_cmd_ring(xhci, cmd_comp_code)) {
-			inc_deq(xhci, xhci->cmd_ring);
-			return;
+
+	/* If CMD ring stopped we own the trbs between enqueue and dequeue */
+	if (cmd_comp_code == COMP_CMD_STOP) {
+		struct xhci_command *cur_cmd, *tmp_cmd;
+		u32 cycle_state;
+
+		/* Turn all aborted commands in list to no-ops, then restart */
+		list_for_each_entry_safe(cur_cmd, tmp_cmd, &xhci->cmd_list,
+					 cmd_list) {
+
+			if (cur_cmd->status != COMP_CMD_ABORT)
+				continue;
+
+			cur_cmd->status = COMP_CMD_STOP;
+
+			/* get cycle state from the original cmd trb */
+			cycle_state = le32_to_cpu(
+				cur_cmd->command_trb->generic.field[3]) &
+				TRB_CYCLE;
+
+			/* modify the command trb to NO OP command */
+			cur_cmd->command_trb->generic.field[0] = 0;
+			cur_cmd->command_trb->generic.field[1] = 0;
+			cur_cmd->command_trb->generic.field[2] = 0;
+			cur_cmd->command_trb->generic.field[3] = cpu_to_le32(
+				TRB_TYPE(TRB_CMD_NOOP) | cycle_state);
+
+			/* completion is called when command completion
+			 * event is received for these no-op commands
+			 */
 		}
-		/* There is no command to handle if we get a stop event when the
-		 * command ring is empty, event->cmd_trb points to the next
-		 * unset command
-		 */
-		if (xhci->cmd_ring->dequeue == xhci->cmd_ring->enqueue)
-			return;
+		xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
+
+		/* ring command ring doorbell to restart the command ring */
+		if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue) {
+			xhci->current_cmd = cmd;
+			mod_timer(&xhci->cmd_timer,
+				  jiffies + XHCI_CMD_DEFAULT_TIMEOUT);
+			xhci_ring_cmd_db(xhci);
+		}
+		return;
+	}
+	/*
+	 * Host aborted the command ring, check if the current command was
+	 * supposed to be aborted, otherwise continue normally.
+	 * The command ring is stopped now, but the xHC will issue a Command
+	 * Ring Stopped event which will cause us to restart it.
+	 */
+	if (cmd_comp_code == COMP_CMD_ABORT) {
+		xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
+		if (cmd->status == COMP_CMD_ABORT)
+			goto event_handled;
 	}
 
 	cmd_type = TRB_FIELD_TO_TYPE(le32_to_cpu(cmd_trb->generic.field[3]));
@@ -1518,6 +1357,9 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci_handle_cmd_set_deq(xhci, slot_id, cmd_trb, cmd_comp_code);
 		break;
 	case TRB_CMD_NOOP:
+		/* Is this an aborted command turned to NO-OP? */
+		if (cmd->status == COMP_CMD_STOP)
+			cmd_comp_code = COMP_CMD_STOP;
 		break;
 	case TRB_RESET_EP:
 		WARN_ON(slot_id != TRB_TO_SLOT_ID(
@@ -1538,6 +1380,14 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		break;
 	}
 
+	/* restart timer if this wasn't the last command */
+	if (cmd->cmd_list.next != &xhci->cmd_list) {
+		xhci->current_cmd = list_entry(cmd->cmd_list.next,
+					       struct xhci_command, cmd_list);
+		mod_timer(&xhci->cmd_timer, jiffies + XHCI_CMD_DEFAULT_TIMEOUT);
+	}
+
+event_handled:
 	list_del(&cmd->cmd_list);
 
 	if (cmd->completion) {
@@ -3950,6 +3800,14 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 	}
 	cmd->command_trb = xhci->cmd_ring->enqueue;
 	list_add_tail(&cmd->cmd_list, &xhci->cmd_list);
+
+	/* if there are no other commands queued we start the timeout timer */
+	if (xhci->cmd_list.next == &cmd->cmd_list &&
+	    !timer_pending(&xhci->cmd_timer)) {
+		xhci->current_cmd = cmd;
+		mod_timer(&xhci->cmd_timer, jiffies + XHCI_CMD_DEFAULT_TIMEOUT);
+	}
+
 	queue_trb(xhci, xhci->cmd_ring, false, field1, field2, field3,
 			field4 | xhci->cmd_ring->cycle_state);
 	return 0;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6753da3..f011a18 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1813,6 +1813,11 @@ static int xhci_configure_endpoint_result(struct xhci_hcd *xhci,
 	int ret;
 
 	switch (*cmd_status) {
+	case COMP_CMD_ABORT:
+	case COMP_CMD_STOP:
+		xhci_warn(xhci, "Timeout while waiting for configure endpoint command\n");
+		ret = -ETIME;
+		break;
 	case COMP_ENOMEM:
 		dev_warn(&udev->dev, "Not enough host controller resources "
 				"for new device state.\n");
@@ -1859,6 +1864,11 @@ static int xhci_evaluate_context_result(struct xhci_hcd *xhci,
 	struct xhci_virt_device *virt_dev = xhci->devs[udev->slot_id];
 
 	switch (*cmd_status) {
+	case COMP_CMD_ABORT:
+	case COMP_CMD_STOP:
+		xhci_warn(xhci, "Timeout while waiting for evaluate context command\n");
+		ret = -ETIME;
+		break;
 	case COMP_EINVAL:
 		dev_warn(&udev->dev, "WARN: xHCI driver setup invalid evaluate "
 				"context command.\n");
@@ -2583,7 +2593,6 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 		bool ctx_change, bool must_succeed)
 {
 	int ret;
-	int timeleft;
 	unsigned long flags;
 	struct xhci_input_control_ctx *ctrl_ctx;
 	struct xhci_virt_device *virt_dev;
@@ -2639,21 +2648,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* Wait for the configure endpoint command to complete */
-	timeleft = wait_for_completion_interruptible_timeout(
-			command->completion,
-			XHCI_CMD_DEFAULT_TIMEOUT);
-	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for %s command\n",
-				timeleft == 0 ? "Timeout" : "Signal",
-				ctx_change == 0 ?
-					"configure endpoint" :
-					"evaluate context");
-		/* cancel the configure endpoint command */
-		ret = xhci_cancel_cmd(xhci, command, command->command_trb);
-		if (ret < 0)
-			return ret;
-		return -ETIME;
-	}
+	wait_for_completion(command->completion);
 
 	if (!ctx_change)
 		ret = xhci_configure_endpoint_result(xhci, udev,
@@ -3406,7 +3401,6 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	unsigned int slot_id;
 	struct xhci_virt_device *virt_dev;
 	struct xhci_command *reset_device_cmd;
-	int timeleft;
 	int last_freed_endpoint;
 	struct xhci_slot_ctx *slot_ctx;
 	int old_active_eps = 0;
@@ -3474,15 +3468,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* Wait for the Reset Device command to finish */
-	timeleft = wait_for_completion_interruptible_timeout(
-			reset_device_cmd->completion,
-			XHCI_CMD_DEFAULT_TIMEOUT);
-	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for reset device command\n",
-				timeleft == 0 ? "Timeout" : "Signal");
-		ret = -ETIME;
-		goto command_cleanup;
-	}
+	wait_for_completion(reset_device_cmd->completion);
 
 	/* The Reset Device command can't fail, according to the 0.95/0.96 spec,
 	 * unless we tried to reset a slot ID that wasn't enabled,
@@ -3490,6 +3476,11 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	 */
 	ret = reset_device_cmd->status;
 	switch (ret) {
+	case COMP_CMD_ABORT:
+	case COMP_CMD_STOP:
+		xhci_warn(xhci, "Timeout waiting for reset device command\n");
+		ret = -ETIME;
+		goto command_cleanup;
 	case COMP_EBADSLT: /* 0.95 completion code for bad slot ID */
 	case COMP_CTX_STATE: /* 0.96 completion code for same thing */
 		xhci_dbg(xhci, "Can't reset device (slot ID %u) in %s state\n",
@@ -3657,7 +3648,6 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	unsigned long flags;
-	int timeleft;
 	int ret;
 	struct xhci_command *command;
 
@@ -3677,19 +3667,9 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
-	/* XXX: how much time for xHC slot assignment? */
-	timeleft = wait_for_completion_interruptible_timeout(
-			command->completion,
-			XHCI_CMD_DEFAULT_TIMEOUT);
-	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for a slot\n",
-				timeleft == 0 ? "Timeout" : "Signal");
-		/* cancel the enable slot request */
-		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		return ret;
-	}
+	wait_for_completion(command->completion);
 
-	if (!xhci->slot_id) {
+	if (!xhci->slot_id || command->status != COMP_SUCCESS) {
 		xhci_err(xhci, "Error while assigning device slot ID\n");
 		kfree(command);
 		return 0;
@@ -3753,7 +3733,6 @@ disable_slot:
 int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	unsigned long flags;
-	int timeleft;
 	struct xhci_virt_device *virt_dev;
 	int ret = 0;
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
@@ -3828,24 +3807,18 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* ctrl tx can take up to 5 sec; XXX: need more time for xHC? */
-	timeleft = wait_for_completion_interruptible_timeout(
-			command->completion,
-			XHCI_CMD_DEFAULT_TIMEOUT);
+	wait_for_completion(command->completion);
+
 	/* FIXME: From section 4.3.4: "Software shall be responsible for timing
 	 * the SetAddress() "recovery interval" required by USB and aborting the
 	 * command on a timeout.
 	 */
-	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for address device command\n",
-				timeleft == 0 ? "Timeout" : "Signal");
-		/* cancel the address device command */
-		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		if (ret < 0)
-			return ret;
-		return -ETIME;
-	}
-
 	switch (command->status) {
+	case COMP_CMD_ABORT:
+	case COMP_CMD_STOP:
+		xhci_warn(xhci, "Timeout while waiting for address device command\n");
+		ret = -ETIME;
+		break;
 	case COMP_CTX_STATE:
 	case COMP_EBADSLT:
 		xhci_err(xhci, "Setup ERROR: address device command for slot %d.\n",
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index afff1da..14da9fc 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1287,7 +1287,6 @@ struct xhci_td {
 
 /* command descriptor */
 struct xhci_cd {
-	struct list_head	cancel_cmd_list;
 	struct xhci_command	*command;
 	union xhci_trb		*cmd_trb;
 };
@@ -1471,9 +1470,10 @@ struct xhci_hcd {
 #define CMD_RING_STATE_RUNNING         (1 << 0)
 #define CMD_RING_STATE_ABORTED         (1 << 1)
 #define CMD_RING_STATE_STOPPED         (1 << 2)
-	struct list_head        cancel_cmd_list;
 	struct list_head        cmd_list;
 	unsigned int		cmd_ring_reserved_trbs;
+	struct timer_list	cmd_timer;
+	struct xhci_command	*current_cmd;
 	struct xhci_ring	*event_ring;
 	struct xhci_erst	erst;
 	/* Scratchpad */
@@ -1849,8 +1849,8 @@ void xhci_queue_config_ep_quirk(struct xhci_hcd *xhci,
 		unsigned int slot_id, unsigned int ep_index,
 		struct xhci_dequeue_state *deq_state);
 void xhci_stop_endpoint_command_watchdog(unsigned long arg);
-int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
-		union xhci_trb *cmd_trb);
+void xhci_handle_command_timeout(unsigned long data);
+
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, unsigned int stream_id);
 
-- 
1.8.1.2

