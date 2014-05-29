Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbaE2OVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:21:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59321 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933155AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 009/103] xhci: For streams the css flag most be read from the stream-ctx on ep stop
Date: Thu, 29 May 2014 15:47:54 +0200
Message-Id: <0da837ca84b26c3c4f560788a6e62b12d345e49f.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c4bedb77ec4cb42f37cae4cbfddda8283161f7c8 upstream.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-ring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index cbecb5ff7d90..1dbfb52dbcd6 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -552,9 +552,9 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 		struct xhci_dequeue_state *state)
 {
 	struct xhci_virt_device *dev = xhci->devs[slot_id];
+	struct xhci_virt_ep *ep = &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
 	struct xhci_generic_trb *trb;
-	struct xhci_ep_ctx *ep_ctx;
 	dma_addr_t addr;
 	u64 hw_dequeue;
 
@@ -570,8 +570,16 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
 			"Finding endpoint context");
-	ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
-	hw_dequeue = le64_to_cpu(ep_ctx->deq);
+	/* 4.6.9 the css flag is written to the stream context for streams */
+	if (ep->ep_state & EP_HAS_STREAMS) {
+		struct xhci_stream_ctx *ctx =
+			&ep->stream_info->stream_ctx_array[stream_id];
+		hw_dequeue = le64_to_cpu(ctx->stream_ring);
+	} else {
+		struct xhci_ep_ctx *ep_ctx
+			= xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
+		hw_dequeue = le64_to_cpu(ep_ctx->deq);
+	}
 
 	/* Find virtual address and segment of hardware dequeue pointer */
 	state->new_deq_seg = ep_ring->deq_seg;
-- 
1.9.3

