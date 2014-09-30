Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaI3WAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:00:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60892 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaI3VhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 055/103] xhci: rework cycle bit checking for new dequeue pointers
Date: Tue, 30 Sep 2014 14:31:00 -0700
Message-Id: <1412112708-27356-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 365038d83313951d6ace15342eb24624bbef1666 upstream.

When we manually need to move the TR dequeue pointer we need to set the
correct cycle bit as well. Previously we used the trb pointer from the
last event received as a base, but this was changed in
commit 1f81b6d22a59 ("usb: xhci: Prefer endpoint context dequeue pointer")
to use the dequeue pointer from the endpoint context instead

It turns out some Asmedia controllers advance the dequeue pointer
stored in the endpoint context past the event triggering TRB, and
this messed up the way the cycle bit was calculated.

Instead of adding a quirk or complicating the already hard to follow cycle bit
code, the whole cycle bit calculation is now simplified and adapted to handle
event and endpoint context dequeue pointer differences.

Fixes: 1f81b6d22a59 ("usb: xhci: Prefer endpoint context dequeue pointer")
Reported-by: Maciej Puzio <mx34567@gmail.com>
Reported-by: Evan Langlois <uudruid74@gmail.com>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Tested-by: Maciej Puzio <mx34567@gmail.com>
Tested-by: Evan Langlois <uudruid74@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.13-stable: leave find_trb_seg() for xhci_cmd_to_noop() ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 75 +++++++++++++++++++++++---------------------
 drivers/usb/host/xhci.c      |  3 ++
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 41deedb..58c2eac 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -554,9 +554,12 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	struct xhci_virt_device *dev = xhci->devs[slot_id];
 	struct xhci_virt_ep *ep = &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
-	struct xhci_generic_trb *trb;
+	struct xhci_segment *new_seg;
+	union xhci_trb *new_deq;
 	dma_addr_t addr;
 	u64 hw_dequeue;
+	bool cycle_found = false;
+	bool td_last_trb_found = false;
 
 	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
 			ep_index, stream_id);
@@ -581,45 +584,45 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 		hw_dequeue = le64_to_cpu(ep_ctx->deq);
 	}
 
-	/* Find virtual address and segment of hardware dequeue pointer */
-	state->new_deq_seg = ep_ring->deq_seg;
-	state->new_deq_ptr = ep_ring->dequeue;
-	while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
-			!= (dma_addr_t)(hw_dequeue & ~0xf)) {
-		next_trb(xhci, ep_ring, &state->new_deq_seg,
-					&state->new_deq_ptr);
-		if (state->new_deq_ptr == ep_ring->dequeue) {
-			WARN_ON(1);
-			return;
-		}
-	}
+	new_seg = ep_ring->deq_seg;
+	new_deq = ep_ring->dequeue;
+	state->new_cycle_state = hw_dequeue & 0x1;
+
 	/*
-	 * Find cycle state for last_trb, starting at old cycle state of
-	 * hw_dequeue. If there is only one segment ring, find_trb_seg() will
-	 * return immediately and cannot toggle the cycle state if this search
-	 * wraps around, so add one more toggle manually in that case.
+	 * We want to find the pointer, segment and cycle state of the new trb
+	 * (the one after current TD's last_trb). We know the cycle state at
+	 * hw_dequeue, so walk the ring until both hw_dequeue and last_trb are
+	 * found.
 	 */
-	state->new_cycle_state = hw_dequeue & 0x1;
-	if (ep_ring->first_seg == ep_ring->first_seg->next &&
-			cur_td->last_trb < state->new_deq_ptr)
-		state->new_cycle_state ^= 0x1;
+	do {
+		if (!cycle_found && xhci_trb_virt_to_dma(new_seg, new_deq)
+		    == (dma_addr_t)(hw_dequeue & ~0xf)) {
+			cycle_found = true;
+			if (td_last_trb_found)
+				break;
+		}
+		if (new_deq == cur_td->last_trb)
+			td_last_trb_found = true;
 
-	state->new_deq_ptr = cur_td->last_trb;
-	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
-			"Finding segment containing last TRB in TD.");
-	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
-			state->new_deq_ptr, &state->new_cycle_state);
-	if (!state->new_deq_seg) {
-		WARN_ON(1);
-		return;
-	}
+		if (cycle_found &&
+		    TRB_TYPE_LINK_LE32(new_deq->generic.field[3]) &&
+		    new_deq->generic.field[3] & cpu_to_le32(LINK_TOGGLE))
+			state->new_cycle_state ^= 0x1;
+
+		next_trb(xhci, ep_ring, &new_seg, &new_deq);
+
+		/* Search wrapped around, bail out */
+		if (new_deq == ep->ring->dequeue) {
+			xhci_err(xhci, "Error: Failed finding new dequeue state\n");
+			state->new_deq_seg = NULL;
+			state->new_deq_ptr = NULL;
+			return;
+		}
+
+	} while (!cycle_found || !td_last_trb_found);
 
-	/* Increment to find next TRB after last_trb. Cycle if appropriate. */
-	trb = &state->new_deq_ptr->generic;
-	if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
-	    (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
-		state->new_cycle_state ^= 0x1;
-	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
+	state->new_deq_seg = new_seg;
+	state->new_deq_ptr = new_deq;
 
 	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8f1b31b..a879287 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2862,6 +2862,9 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 			ep_index, ep->stopped_stream, ep->stopped_td,
 			&deq_state);
 
+	if (!deq_state.new_deq_ptr || !deq_state.new_deq_seg)
+		return;
+
 	/* HW with the reset endpoint quirk will use the saved dequeue state to
 	 * issue a configure endpoint command later.
 	 */
-- 
1.9.1

