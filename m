Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbaFQQXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:23:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965003AbaFQQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 093/121] xhci: For streams the css flag most be read from the stream-ctx on ep stop
Date: Tue, 17 Jun 2014 09:17:51 -0700
Message-Id: <1403021899-16708-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
index 3607da9..c311338 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -551,9 +551,9 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 		struct xhci_dequeue_state *state)
 {
 	struct xhci_virt_device *dev = xhci->devs[slot_id];
+	struct xhci_virt_ep *ep = &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
 	struct xhci_generic_trb *trb;
-	struct xhci_ep_ctx *ep_ctx;
 	dma_addr_t addr;
 
 	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
@@ -576,8 +576,16 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 
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
-- 
1.9.1

