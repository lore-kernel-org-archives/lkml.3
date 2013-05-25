Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3EYBeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 21:34:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3EYBeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 21:34:02 -0400
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Elric Fu <elricfu1@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: xhci: Fix Command Ring Stopped Event handling
Date: Fri, 24 May 2013 18:33:50 -0700
Message-Id: <1369445630-31018-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current XHCI code treats a command completion event with the
COMP_CMD_STOP code as a slightly different version of COMP_CMD_ABORT. In
particular, it puts the pointed-to command TRB through the normal
command completion handlers. This is not how this event works.

As XHCI spec 4.6.1.1 describes, unlike other command completion events
Command Ring Stopped sets the Command TRB Pointer to the *current*
Command Ring Dequeue Pointer. This is the command TRB that the XHCI will
execute next, and not a command that has already been executed. The
driver's internal command ring dequeue pointer should not be increased
after this event, since it does not really mark a command completion...
it's just a hint for the driver that execution is stopped now and where
it will be picked up again if the ring gets restarted.

This patch gets rid of the handle_stopped_command_ring() function and
splits its behavior into two distinct parts for COMP_CMD_STOP and
COMP_CMD_ABORT events. It ensures that the former no longer messes with
the dequeue pointer, while the latter's behavior is unchanged. This
prevents the hardware and software dequeue pointer from going out of
sync during command cancellations, which can lead to a variety of
problems (up to a total HCD death if the next command after the one that
was cancelled is Stop Endpoint, and the stop_endpoint_watchdog won't see
the command's completion because it got skipped by the software dequeue
pointer).

This patch should be backported to kernels as far as 3.0 that contain
the commit b63f4053cc8aa22a98e3f9a97845afe6c15d0a0d "xHCI: handle
command after aborting the command ring".

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-ring.c | 85 +++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 52 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1969c00..98b7673 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1314,47 +1314,11 @@ static int xhci_search_cmd_trb_in_cd_list(struct xhci_hcd *xhci,
 	return 0;
 }
 
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
 static void handle_cmd_completion(struct xhci_hcd *xhci,
 		struct xhci_event_cmd *event)
 {
 	int slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
+	int comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
 	u64 cmd_dma;
 	dma_addr_t cmd_dequeue_dma;
 	struct xhci_input_control_ctx *ctrl_ctx;
@@ -1377,16 +1341,34 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		return;
 	}
 
-	if ((GET_COMP_CODE(le32_to_cpu(event->status)) == COMP_CMD_ABORT) ||
-		(GET_COMP_CODE(le32_to_cpu(event->status)) == COMP_CMD_STOP)) {
-		/* If the return value is 0, we think the trb pointed by
-		 * command ring dequeue pointer is a good trb. The good
-		 * trb means we don't want to cancel the trb, but it have
-		 * been stopped by host. So we should handle it normally.
-		 * Otherwise, driver should invoke inc_deq() and return.
-		 */
-		if (handle_stopped_cmd_ring(xhci,
-				GET_COMP_CODE(le32_to_cpu(event->status)))) {
+	/*
+	 * Command Ring Stopped events point at the xHC's *current* dequeue
+	 * pointer, i.e. the next command that will be executed. That TRB may
+	 * or may not have been issued yet. Just overwrite all canceled commands
+	 * with NOOPs and restart the ring, leaving our internal dequeue pointer
+	 * as it is (we will get another event for that position later, when
+	 * it has actually been executed).
+	 */
+	if (comp_code == COMP_CMD_STOP) {
+		xhci_cancel_cmd_in_cd_list(xhci);
+		xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
+		if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue)
+			xhci_ring_cmd_db(xhci);
+		return;
+	}
+
+	/*
+	 * If we aborted a command, we check if it is one of the commands we
+	 * meant to cancel. In that case, it will be freed and we just finish
+	 * up right here. If we aborted something else instead, we run it
+	 * through the normal handlers below. At any rate, the command ring is
+	 * stopped now, but the xHC will issue a Command Ring Stopped event
+	 * after this that will cause us to restart it.
+	 */
+	if (comp_code == COMP_CMD_ABORT) {
+		xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
+		if (xhci_search_cmd_trb_in_cd_list(xhci,
+			xhci->cmd_ring->dequeue)) {
 			inc_deq(xhci, xhci->cmd_ring);
 			return;
 		}
@@ -1395,7 +1377,7 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 	switch (le32_to_cpu(xhci->cmd_ring->dequeue->generic.field[3])
 		& TRB_TYPE_BITMASK) {
 	case TRB_TYPE(TRB_ENABLE_SLOT):
-		if (GET_COMP_CODE(le32_to_cpu(event->status)) == COMP_SUCCESS)
+		if (comp_code == COMP_SUCCESS)
 			xhci->slot_id = slot_id;
 		else
 			xhci->slot_id = 0;
@@ -1451,19 +1433,18 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		}
 bandwidth_change:
 		xhci_dbg(xhci, "Completed config ep cmd\n");
-		xhci->devs[slot_id]->cmd_status =
-			GET_COMP_CODE(le32_to_cpu(event->status));
+		xhci->devs[slot_id]->cmd_status = comp_code;
 		complete(&xhci->devs[slot_id]->cmd_completion);
 		break;
 	case TRB_TYPE(TRB_EVAL_CONTEXT):
 		virt_dev = xhci->devs[slot_id];
 		if (handle_cmd_in_cmd_wait_list(xhci, virt_dev, event))
 			break;
-		xhci->devs[slot_id]->cmd_status = GET_COMP_CODE(le32_to_cpu(event->status));
+		xhci->devs[slot_id]->cmd_status = comp_code;
 		complete(&xhci->devs[slot_id]->cmd_completion);
 		break;
 	case TRB_TYPE(TRB_ADDR_DEV):
-		xhci->devs[slot_id]->cmd_status = GET_COMP_CODE(le32_to_cpu(event->status));
+		xhci->devs[slot_id]->cmd_status = comp_code;
 		complete(&xhci->addr_dev);
 		break;
 	case TRB_TYPE(TRB_STOP_RING):
-- 
1.7.12.4

