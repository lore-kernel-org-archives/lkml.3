Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaEPMxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.608011116@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 24/34] xhci: For streams the css flag most be read
 from the stream-ctx on ep stop
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c4bedb77ec4cb42f37cae4cbfddda8283161f7c8 upstream.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -570,9 +570,9 @@ void xhci_find_new_dequeue_state(struct
 		struct xhci_dequeue_state *state)
 {
 	struct xhci_virt_device *dev = xhci->devs[slot_id];
+	struct xhci_virt_ep *ep = &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
 	struct xhci_generic_trb *trb;
-	struct xhci_ep_ctx *ep_ctx;
 	dma_addr_t addr;
 
 	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
@@ -595,8 +595,16 @@ void xhci_find_new_dequeue_state(struct
 
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg(xhci, "Finding endpoint context\n");
-	ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
-	state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
+	/* 4.6.9 the css flag is written to the stream context for streams */
+	if (ep->ep_state & EP_HAS_STREAMS) {
+		struct xhci_stream_ctx *ctx =
+			&ep->stream_info->stream_ctx_array[stream_id];
+		state->new_cycle_state = 0x1 & le64_to_cpu(ctx->stream_ring);
+	} else {
+		struct xhci_ep_ctx *ep_ctx
+			= xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
+		state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
+	}
 
 	state->new_deq_ptr = cur_td->last_trb;
 	xhci_dbg(xhci, "Finding segment containing last TRB in TD.\n");

