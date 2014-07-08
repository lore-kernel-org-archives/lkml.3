Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaGHTDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:03:04 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33282 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaGHTDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:03:01 -0400
From: Julius Werner <jwerner@chromium.org>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Maciej Puzio <mx34567@gmail.com>, David Laight <David.Laight@ACULAB.COM>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: xhci: Fix Set TR Dequeue Pointer cycle state for quirky xHCs
Date: Tue,  8 Jul 2014 12:01:44 -0700
Message-Id: <1404846104-4959-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
References: <CACH_MLWEYRaT8RPHw-tdBBJoey283w1ED_QY6yXMiqYO5pjROg@mail.gmail.com> <CAODwPW-x3RmQ95Zs0HKYkqOUN9G+r-mueW4d9G+x7qZGhctwRw@mail.gmail.com> <CACH_MLVpnfJjQSEf3xqF_KQzsi=E=M=Fz2khEqajg7FdNR0x_g@mail.gmail.com> <CAODwPW9UUGYzK3-83+PNXWKP4M5H=8GmYBjrgvW2Kg6nA6ssrw@mail.gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1726E25E@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726E25E@AcuExch.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1f81b6d22 "usb: xhci: Prefer endpoint context dequeue pointer
over stopped_trb" changed the logic in xhci_find_new_dequeue_state() to
only use the Endpoint Context's TR Dequeue Pointer instead of the last
Event TRB's TRB Pointer as a basis from which to infer the host
controller state. This has uncovered a bug with certain Asmedia xHCs
which seem to advance their TR Dequeue Pointer one TRB behind the one
that caused a Stall Error.

This confuses the cycle state calculation since cur_td->last_trb is now
behind hw_dequeue (which the algorithm interprets as a single huge TD
that wraps around the whole transfer ring). This patch counteracts that
by explicitly looking for last_trb when searching for hw_dequeue from
the old software dequeue pointer. If it is found, we toggle the cycle
state once more to balance out the incorrect toggle that will happen
later.

In order to make this work for both single and multi segment rings, this
patch also expands the detection of wrap-around TDs to work on the
latter ones (which cannot normally happen because the kernel prevents
that case to allow for ring expansion, but it's how things appear to be
in the quirky case and allowing the code to handle it makes it easier to
generalize this fix across all kernels). The code will now toggle the
cycle state whenever last_trb is before hw_dequeue on the same segment,
regardless of how many segments there are in the ring.

This patch should be backported to kernels as old as 2.6.31 that contain
the commit ae636747146ea97efa18e04576acd3416e2514f5 "USB: xhci: URB
cancellation support."

Cc: stable@vger.kernel.org
Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-ring.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 749fc68..50abc68 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -489,8 +489,17 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	/* Find virtual address and segment of hardware dequeue pointer */
 	state->new_deq_seg = ep_ring->deq_seg;
 	state->new_deq_ptr = ep_ring->dequeue;
+	state->new_cycle_state = hw_dequeue & 0x1;
 	while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
 			!= (dma_addr_t)(hw_dequeue & ~0xf)) {
+		/*
+		 * Quirky HCs can advance hw_dequeue behind cur_td->last_trb.
+		 * That violates the assumptions of the TD wrap around check
+		 * below, so toggle the cycle state once more to cancel it out.
+		 */
+		if (state->new_deq_ptr == cur_td->last_trb)
+			state->new_cycle_state ^= 1;
+
 		next_trb(xhci, ep_ring, &state->new_deq_seg,
 					&state->new_deq_ptr);
 		if (state->new_deq_ptr == ep_ring->dequeue) {
@@ -500,12 +509,11 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	}
 	/*
 	 * Find cycle state for last_trb, starting at old cycle state of
-	 * hw_dequeue. If there is only one segment ring, find_trb_seg() will
-	 * return immediately and cannot toggle the cycle state if this search
-	 * wraps around, so add one more toggle manually in that case.
+	 * hw_dequeue. If last_trb is on the current segment before hw_dequeue,
+	 * that means we wrap around the whole ring, but find_trb_seq() will
+	 * return immediately. Toggle the cycle state manually in that case.
 	 */
-	state->new_cycle_state = hw_dequeue & 0x1;
-	if (ep_ring->first_seg == ep_ring->first_seg->next &&
+	if (state->new_deq_seg->trbs < cur_td->last_trb &&
 			cur_td->last_trb < state->new_deq_ptr)
 		state->new_cycle_state ^= 0x1;
 
-- 
1.8.3.2

