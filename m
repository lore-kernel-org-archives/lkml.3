Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3JKAgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:36:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:29083 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab3JKAgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1075,1371106800"; 
   d="scan'208";a="409149859"
From: xiao jin <jin.xiao@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] xhci: Ensure a command structure points to the correct trb on the command ring
Date: Fri, 11 Oct 2013 08:47:54 +0800
Message-Id: <1381452474-32613-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

If a command on the command ring needs to be cancelled before it is handled
it can be turned to a no-op operation when the ring is stopped.
We want to store the command ring enqueue pointer in the command structure
when the command in enqueued for the cancellation case.

Some commands used to store the command ring dequeue pointers instead of enqueue
(these often worked because enqueue happends to equal dequeue quite often)

Other commands correctly used the enqueue pointer but did not check if it pointed
to a valid trb or a link trb, this caused for example stop endpoint command to timeout in
xhci_stop_device() in about 2% of suspend/resume cases.

This should also solve some weird behavior happening in command cancellation cases.

This patch is based on a patch submitted by Sarah Sharp to linux-usb, but
then forgotten:
    http://marc.info/?l=linux-usb&m=136269803207465&w=2

This patch should be backported to kernels as old as 3.7, that contain
the commit b92cc66c047ff7cf587b318fe377061a353c120f "xHCI: add aborting
command ring function"

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/host/xhci-hub.c  |    2 +-
 drivers/usb/host/xhci-ring.c |   10 ++++++++++
 drivers/usb/host/xhci.c      |   25 +++++--------------------
 drivers/usb/host/xhci.h      |    1 +
 4 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index fae697e..ccf0a06 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -287,7 +287,7 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue)
 			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
 	}
-	cmd->command_trb = xhci->cmd_ring->enqueue;
+	cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
 	xhci_queue_stop_endpoint(xhci, slot_id, 0, suspend);
 	xhci_ring_cmd_db(xhci);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index aaa2906..9ac9672 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -123,6 +123,16 @@ static int enqueue_is_link_trb(struct xhci_ring *ring)
 	return TRB_TYPE_LINK_LE32(link->control);
 }
 
+union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring)
+{
+	/* Enqueue pointer can be left pointing to the link TRB,
+	 * we must handle that
+	 */
+	if (TRB_TYPE_LINK_LE32(ring->enqueue->link.control))
+		return ring->enq_seg->next->trbs;
+	return ring->enqueue;
+}
+
 /* Updates trb to point to the next TRB in the ring, and updates seg if the next
  * TRB is in a new segment.  This does not skip over link TRBs, and it does not
  * effect the ring dequeue or enqueue pointers.
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 49b6edb..1e36dbb 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2598,15 +2598,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	if (command) {
 		cmd_completion = command->completion;
 		cmd_status = &command->status;
-		command->command_trb = xhci->cmd_ring->enqueue;
-
-		/* Enqueue pointer can be left pointing to the link TRB,
-		 * we must handle that
-		 */
-		if (TRB_TYPE_LINK_LE32(command->command_trb->link.control))
-			command->command_trb =
-				xhci->cmd_ring->enq_seg->next->trbs;
-
+		command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 		list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
 	} else {
 		cmd_completion = &virt_dev->cmd_completion;
@@ -2614,7 +2606,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	}
 	init_completion(cmd_completion);
 
-	cmd_trb = xhci->cmd_ring->dequeue;
+	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	if (!ctx_change)
 		ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,
 				udev->slot_id, must_succeed);
@@ -3439,14 +3431,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 
 	/* Attempt to submit the Reset Device command to the command ring */
 	spin_lock_irqsave(&xhci->lock, flags);
-	reset_device_cmd->command_trb = xhci->cmd_ring->enqueue;
-
-	/* Enqueue pointer can be left pointing to the link TRB,
-	 * we must handle that
-	 */
-	if (TRB_TYPE_LINK_LE32(reset_device_cmd->command_trb->link.control))
-		reset_device_cmd->command_trb =
-			xhci->cmd_ring->enq_seg->next->trbs;
+	reset_device_cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 
 	list_add_tail(&reset_device_cmd->cmd_list, &virt_dev->cmd_list);
 	ret = xhci_queue_reset_device(xhci, slot_id);
@@ -3650,7 +3635,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	union xhci_trb *cmd_trb;
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	cmd_trb = xhci->cmd_ring->dequeue;
+	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	ret = xhci_queue_slot_control(xhci, TRB_ENABLE_SLOT, 0);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
@@ -3785,7 +3770,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 				slot_ctx->dev_info >> 27);
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	cmd_trb = xhci->cmd_ring->dequeue;
+	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	ret = xhci_queue_address_device(xhci, virt_dev->in_ctx->dma,
 					udev->slot_id);
 	if (ret) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 46aa148..f3e1020 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1840,6 +1840,7 @@ int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
 		union xhci_trb *cmd_trb);
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, unsigned int stream_id);
+union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring);
 
 /* xHCI roothub code */
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
-- 
1.7.1

