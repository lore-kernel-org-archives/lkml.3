Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3C1Ssl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3C1Ssj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:48:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] xhci: Rename SEGMENT_SIZE and SEGMENT_SHIFT as the
 former is used in a.out.h
To: sarah.a.sharp@linux.intel.com
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 18:48:35 +0000
Message-ID: <20130328184835.29679.62285.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130328184827.29679.62426.stgit@warthog.procyon.org.uk>
References: <20130328184827.29679.62426.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename SEGMENT_SIZE and SEGMENT_SHIFT as the former is used in a.out.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-usb@vger.kernel.org
---

 drivers/usb/host/xhci-mem.c |   16 ++++++++--------
 drivers/usb/host/xhci.h     |    4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 35616ff..e11e2af 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -51,7 +51,7 @@ static struct xhci_segment *xhci_segment_alloc(struct xhci_hcd *xhci,
 		return NULL;
 	}
 
-	memset(seg->trbs, 0, SEGMENT_SIZE);
+	memset(seg->trbs, 0, TRB_SEGMENT_SIZE);
 	/* If the cycle state is 0, set the cycle bit to 1 for all the TRBs */
 	if (cycle_state == 0) {
 		for (i = 0; i < TRBS_PER_SEGMENT; i++)
@@ -467,7 +467,7 @@ struct xhci_ring *xhci_dma_to_transfer_ring(
 {
 	if (ep->ep_state & EP_HAS_STREAMS)
 		return radix_tree_lookup(&ep->stream_info->trb_address_map,
-				address >> SEGMENT_SHIFT);
+				address >> TRB_SEGMENT_SHIFT);
 	return ep->ring;
 }
 
@@ -478,7 +478,7 @@ static struct xhci_ring *dma_to_stream_ring(
 		u64 address)
 {
 	return radix_tree_lookup(&stream_info->trb_address_map,
-			address >> SEGMENT_SHIFT);
+			address >> TRB_SEGMENT_SHIFT);
 }
 #endif	/* CONFIG_USB_XHCI_HCD_DEBUGGING */
 
@@ -514,7 +514,7 @@ static int xhci_test_radix_tree(struct xhci_hcd *xhci,
 
 		cur_ring = stream_info->stream_rings[cur_stream];
 		for (addr = cur_ring->first_seg->dma;
-				addr < cur_ring->first_seg->dma + SEGMENT_SIZE;
+				addr < cur_ring->first_seg->dma + TRB_SEGMENT_SIZE;
 				addr += trb_size) {
 			mapped_ring = dma_to_stream_ring(stream_info, addr);
 			if (cur_ring != mapped_ring) {
@@ -662,7 +662,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 				cur_stream, (unsigned long long) addr);
 
 		key = (unsigned long)
-			(cur_ring->first_seg->dma >> SEGMENT_SHIFT);
+			(cur_ring->first_seg->dma >> TRB_SEGMENT_SHIFT);
 		ret = radix_tree_insert(&stream_info->trb_address_map,
 				key, cur_ring);
 		if (ret) {
@@ -693,7 +693,7 @@ cleanup_rings:
 		if (cur_ring) {
 			addr = cur_ring->first_seg->dma;
 			radix_tree_delete(&stream_info->trb_address_map,
-					addr >> SEGMENT_SHIFT);
+					addr >> TRB_SEGMENT_SHIFT);
 			xhci_ring_free(xhci, cur_ring);
 			stream_info->stream_rings[cur_stream] = NULL;
 		}
@@ -764,7 +764,7 @@ void xhci_free_stream_info(struct xhci_hcd *xhci,
 		if (cur_ring) {
 			addr = cur_ring->first_seg->dma;
 			radix_tree_delete(&stream_info->trb_address_map,
-					addr >> SEGMENT_SHIFT);
+					addr >> TRB_SEGMENT_SHIFT);
 			xhci_ring_free(xhci, cur_ring);
 			stream_info->stream_rings[cur_stream] = NULL;
 		}
@@ -2325,7 +2325,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 * so we pick the greater alignment need.
 	 */
 	xhci->segment_pool = dma_pool_create("xHCI ring segments", dev,
-			SEGMENT_SIZE, 64, xhci->page_size);
+			TRB_SEGMENT_SIZE, 64, xhci->page_size);
 
 	/* See Table 46 and Note on Figure 55 */
 	xhci->device_pool = dma_pool_create("xHCI input/output contexts", dev,
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 558ba50..6bf2257 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1234,8 +1234,8 @@ union xhci_trb {
 #define TRBS_PER_SEGMENT	64
 /* Allow two commands + a link TRB, along with any reserved command TRBs */
 #define MAX_RSVD_CMD_TRBS	(TRBS_PER_SEGMENT - 3)
-#define SEGMENT_SIZE		(TRBS_PER_SEGMENT*16)
-#define SEGMENT_SHIFT		(ilog2(SEGMENT_SIZE))
+#define TRB_SEGMENT_SIZE	(TRBS_PER_SEGMENT*16)
+#define TRB_SEGMENT_SHIFT	(ilog2(TRB_SEGMENT_SIZE))
 /* TRB buffer pointers can't cross 64KB boundaries */
 #define TRB_MAX_BUFF_SHIFT		16
 #define TRB_MAX_BUFF_SIZE	(1 << TRB_MAX_BUFF_SHIFT)

