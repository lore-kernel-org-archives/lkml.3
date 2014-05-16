Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaEPMxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49550 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Julius Werner" <jwerner@chromium.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.479771018@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 25/34] usb: xhci: Prefer endpoint context dequeue
 pointer over stopped_trb
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit 1f81b6d22a5980955b01e08cf27fb745dc9b686f upstream.

We have observed a rare cycle state desync bug after Set TR Dequeue
Pointer commands on Intel LynxPoint xHCs (resulting in an endpoint that
doesn't fetch new TRBs and thus an unresponsive USB device). It always
triggers when a previous Set TR Dequeue Pointer command has set the
pointer to the final Link TRB of a segment, and then another URB gets
enqueued and cancelled again before it can be completed. Further
investigation showed that the xHC had returned the Link TRB in the TRB
Pointer field of the Transfer Event (CC == Stopped -- Length Invalid),
but when xhci_find_new_dequeue_state() later accesses the Endpoint
Context's TR Dequeue Pointer field it is set to the first TRB of the
next segment.

The driver expects those two values to be the same in this situation,
and uses the cycle state of the latter together with the address of the
former. This should be fine according to the XHCI specification, since
the endpoint ring should be stopped when returning the Transfer Event
and thus should not advance over the Link TRB before it gets restarted.
However, real-world XHCI implementations apparently don't really care
that much about these details, so the driver should follow a more
defensive approach to try to work around HC spec violations.

This patch removes the stopped_trb variable that had been used to store
the TRB Pointer from the last Transfer Event of a stopped TRB. Instead,
xhci_find_new_dequeue_state() now relies only on the Endpoint Context,
requiring a small amount of additional processing to find the virtual
address corresponding to the TR Dequeue Pointer. Some other parts of the
function were slightly rearranged to better fit into this model.

This patch should be backported to kernels as old as 2.6.31 that contain
the commit ae636747146ea97efa18e04576acd3416e2514f5 "USB: xhci: URB
cancellation support."

Signed-off-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -574,6 +574,7 @@ void xhci_find_new_dequeue_state(struct
 	struct xhci_ring *ep_ring;
 	struct xhci_generic_trb *trb;
 	dma_addr_t addr;
+	u64 hw_dequeue;
 
 	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
 			ep_index, stream_id);
@@ -583,15 +584,6 @@ void xhci_find_new_dequeue_state(struct
 				stream_id);
 		return;
 	}
-	state->new_cycle_state = 0;
-	xhci_dbg(xhci, "Finding segment containing stopped TRB.\n");
-	state->new_deq_seg = find_trb_seg(cur_td->start_seg,
-			dev->eps[ep_index].stopped_trb,
-			&state->new_cycle_state);
-	if (!state->new_deq_seg) {
-		WARN_ON(1);
-		return;
-	}
 
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg(xhci, "Finding endpoint context\n");
@@ -599,44 +591,55 @@ void xhci_find_new_dequeue_state(struct
 	if (ep->ep_state & EP_HAS_STREAMS) {
 		struct xhci_stream_ctx *ctx =
 			&ep->stream_info->stream_ctx_array[stream_id];
-		state->new_cycle_state = 0x1 & le64_to_cpu(ctx->stream_ring);
+		hw_dequeue = le64_to_cpu(ctx->stream_ring);
 	} else {
 		struct xhci_ep_ctx *ep_ctx
 			= xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
-		state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
+		hw_dequeue = le64_to_cpu(ep_ctx->deq);
 	}
 
+	/* Find virtual address and segment of hardware dequeue pointer */
+	state->new_deq_seg = ep_ring->deq_seg;
+	state->new_deq_ptr = ep_ring->dequeue;
+	while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
+			!= (dma_addr_t)(hw_dequeue & ~0xf)) {
+		next_trb(xhci, ep_ring, &state->new_deq_seg,
+					&state->new_deq_ptr);
+		if (state->new_deq_ptr == ep_ring->dequeue) {
+			WARN_ON(1);
+			return;
+		}
+	}
+	/*
+	 * Find cycle state for last_trb, starting at old cycle state of
+	 * hw_dequeue. If there is only one segment ring, find_trb_seg() will
+	 * return immediately and cannot toggle the cycle state if this search
+	 * wraps around, so add one more toggle manually in that case.
+	 */
+	state->new_cycle_state = hw_dequeue & 0x1;
+	if (ep_ring->first_seg == ep_ring->first_seg->next &&
+			cur_td->last_trb < state->new_deq_ptr)
+		state->new_cycle_state ^= 0x1;
+
 	state->new_deq_ptr = cur_td->last_trb;
 	xhci_dbg(xhci, "Finding segment containing last TRB in TD.\n");
 	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
-			state->new_deq_ptr,
-			&state->new_cycle_state);
+			state->new_deq_ptr, &state->new_cycle_state);
 	if (!state->new_deq_seg) {
 		WARN_ON(1);
 		return;
 	}
 
+	/* Increment to find next TRB after last_trb. Cycle if appropriate. */
 	trb = &state->new_deq_ptr->generic;
 	if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
 	    (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
 		state->new_cycle_state ^= 0x1;
 	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
 
-	/*
-	 * If there is only one segment in a ring, find_trb_seg()'s while loop
-	 * will not run, and it will return before it has a chance to see if it
-	 * needs to toggle the cycle bit.  It can't tell if the stalled transfer
-	 * ended just before the link TRB on a one-segment ring, or if the TD
-	 * wrapped around the top of the ring, because it doesn't have the TD in
-	 * question.  Look for the one-segment case where stalled TRB's address
-	 * is greater than the new dequeue pointer address.
-	 */
-	if (ep_ring->first_seg == ep_ring->first_seg->next &&
-			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
-		state->new_cycle_state ^= 0x1;
+	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "Cycle state = 0x%x\n", state->new_cycle_state);
 
-	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
 			state->new_deq_seg);
 	addr = xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr);
@@ -821,7 +824,6 @@ static void handle_stopped_endpoint(stru
 	if (list_empty(&ep->cancelled_td_list)) {
 		xhci_stop_watchdog_timer_in_irq(xhci, ep);
 		ep->stopped_td = NULL;
-		ep->stopped_trb = NULL;
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 		return;
 	}
@@ -888,11 +890,9 @@ remove_finished_td:
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
 
-	/* Clear stopped_td and stopped_trb if endpoint is not halted */
-	if (!(ep->ep_state & EP_HALTED)) {
+	/* Clear stopped_td if endpoint is not halted */
+	if (!(ep->ep_state & EP_HALTED))
 		ep->stopped_td = NULL;
-		ep->stopped_trb = NULL;
-	}
 
 	/*
 	 * Drop the lock and complete the URBs in the cancelled TD list.
@@ -1752,14 +1752,12 @@ static void xhci_cleanup_halted_endpoint
 	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
 	ep->ep_state |= EP_HALTED;
 	ep->stopped_td = td;
-	ep->stopped_trb = event_trb;
 	ep->stopped_stream = stream_id;
 
 	xhci_queue_reset_ep(xhci, slot_id, ep_index);
 	xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
 
 	ep->stopped_td = NULL;
-	ep->stopped_trb = NULL;
 	ep->stopped_stream = 0;
 
 	xhci_ring_cmd_db(xhci);
@@ -1841,7 +1839,6 @@ static int finish_td(struct xhci_hcd *xh
 		 * the ring dequeue pointer or take this TD off any lists yet.
 		 */
 		ep->stopped_td = td;
-		ep->stopped_trb = event_trb;
 		return 0;
 	} else {
 		if (trb_comp_code == COMP_STALL) {
@@ -1853,7 +1850,6 @@ static int finish_td(struct xhci_hcd *xh
 			 * USB class driver clear the stall later.
 			 */
 			ep->stopped_td = td;
-			ep->stopped_trb = event_trb;
 			ep->stopped_stream = ep_ring->stream_id;
 		} else if (xhci_requires_manual_halt_cleanup(xhci,
 					ep_ctx, trb_comp_code)) {
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2884,7 +2884,6 @@ void xhci_endpoint_reset(struct usb_hcd
 		xhci_ring_cmd_db(xhci);
 	}
 	virt_ep->stopped_td = NULL;
-	virt_ep->stopped_trb = NULL;
 	virt_ep->stopped_stream = 0;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -835,8 +835,6 @@ struct xhci_virt_ep {
 #define EP_GETTING_NO_STREAMS	(1 << 5)
 	/* ----  Related to URB cancellation ---- */
 	struct list_head	cancelled_td_list;
-	/* The TRB that was last reported in a stopped endpoint ring */
-	union xhci_trb		*stopped_trb;
 	struct xhci_td		*stopped_td;
 	unsigned int		stopped_stream;
 	/* Watchdog timer for stop endpoint command to cancel URBs */

