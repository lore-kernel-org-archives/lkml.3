Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaFJTuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:50:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35175 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaFJTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/160] xhci: For streams the css flag most be read from the stream-ctx on ep stop
Date: Tue, 10 Jun 2014 12:45:29 -0700
Message-Id: <1402429600-20477-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c4bedb77ec4cb42f37cae4cbfddda8283161f7c8 upstream.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1e2f3f4..fb6df2c 100644
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
 
 	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
@@ -579,8 +579,16 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
 			"Finding endpoint context");
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
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
-- 
1.9.1

