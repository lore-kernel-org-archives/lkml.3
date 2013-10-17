Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733Ab3JQTpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:45:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:42798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758635Ab3JQTpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,516,1378882800"; 
   d="scan'208";a="420809116"
Date: Thu, 17 Oct 2013 12:44:58 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Gerd Hoffmann <kraxel@redhat.com>, Hans de Goede <hdegoede@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] xhci: Remove segments from radix tree on failed insert.
Message-ID: <20131017194458.GA12351@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017184026.GE6256@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're expanding a stream ring, we want to make sure we can add those
ring segments to the radix tree that maps segments to ring pointers.
Try the radix tree insert after the new ring segments have been allocated
(the last segment in the new ring chunk will point to the first newly
allocated segment), but before the new ring segments are linked into the
old ring.

If insert fails on any one segment, remove each segment from the radix
tree, deallocate the new segments, and return.  Otherwise, link the new
segments into the tree.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---

Something like this.  It's ugly, but it compiles.  I haven't tested it.
Hans, can you review and test this?

Sarah Sharp

 drivers/usb/host/xhci-mem.c | 106 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 80 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index a455c56..6ce8d31 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -180,53 +180,98 @@ static void xhci_link_rings(struct xhci_hcd *xhci, struct xhci_ring *ring,
  * extended systems (where the DMA address can be bigger than 32-bits),
  * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
  */
-static int xhci_update_stream_mapping(struct xhci_ring *ring, gfp_t mem_flags)
+static int xhci_insert_segment_mapping(struct radix_tree_root *trb_address_map,
+		struct xhci_ring *ring,
+		struct xhci_segment *seg,
+		gfp_t mem_flags)
 {
-	struct xhci_segment *seg;
 	unsigned long key;
 	int ret;
 
-	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
+	key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
+	/* Skip any segments that were already added. */
+	if (radix_tree_lookup(trb_address_map, key))
 		return 0;
 
-	seg = ring->first_seg;
-	do {
-		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
-		/* Skip any segments that were already added. */
-		if (radix_tree_lookup(ring->trb_address_map, key))
-			continue;
+	ret = radix_tree_maybe_preload(mem_flags);
+	if (ret)
+		return ret;
+	ret = radix_tree_insert(trb_address_map,
+			key, ring);
+	radix_tree_preload_end();
+	return ret;
+}
 
-		ret = radix_tree_maybe_preload(mem_flags);
-		if (ret)
-			return ret;
-		ret = radix_tree_insert(ring->trb_address_map,
-				key, ring);
-		radix_tree_preload_end();
+static void xhci_remove_segment_mapping(struct radix_tree_root *trb_address_map,
+		struct xhci_segment *seg)
+{
+	unsigned long key;
+
+	key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
+	if (radix_tree_lookup(trb_address_map, key))
+		radix_tree_delete(trb_address_map, key);
+}
+
+static int xhci_update_stream_segment_mapping(
+		struct radix_tree_root *trb_address_map,
+		struct xhci_ring *ring,
+		struct xhci_segment *first_seg,
+		struct xhci_segment *last_seg,
+		gfp_t mem_flags)
+{
+	struct xhci_segment *seg;
+	struct xhci_segment *failed_seg;
+	int ret;
+
+	if (WARN_ON_ONCE(trb_address_map == NULL))
+		return 0;
+
+	seg = first_seg;
+	do {
+		ret = xhci_insert_segment_mapping(trb_address_map,
+				ring, seg, mem_flags);
 		if (ret)
-			return ret;
+			goto remove_streams;
+		if (seg == last_seg)
+			return 0;
 		seg = seg->next;
-	} while (seg != ring->first_seg);
+	} while (seg != first_seg);
 
 	return 0;
+
+remove_streams:
+	failed_seg = seg;
+	seg = first_seg;
+	do {
+		xhci_remove_segment_mapping(trb_address_map, seg);
+		if (seg == failed_seg)
+			return ret;
+		seg = seg->next;
+	} while (seg != first_seg);
+
+	return ret;
 }
 
 static void xhci_remove_stream_mapping(struct xhci_ring *ring)
 {
 	struct xhci_segment *seg;
-	unsigned long key;
 
 	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
 		return;
 
 	seg = ring->first_seg;
 	do {
-		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
-		if (radix_tree_lookup(ring->trb_address_map, key))
-			radix_tree_delete(ring->trb_address_map, key);
+		xhci_remove_segment_mapping(ring->trb_address_map, seg);
 		seg = seg->next;
 	} while (seg != ring->first_seg);
 }
 
+static int xhci_update_stream_mapping(struct xhci_ring *ring, gfp_t mem_flags)
+{
+	return xhci_update_stream_segment_mapping(ring->trb_address_map, ring,
+			ring->first_seg, ring->last_seg, mem_flags);
+}
+
 /* XXX: Do we need the hcd structure in all these functions? */
 void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
 {
@@ -429,16 +474,25 @@ int xhci_ring_expansion(struct xhci_hcd *xhci, struct xhci_ring *ring,
 	if (ret)
 		return -ENOMEM;
 
+	ret = xhci_update_stream_segment_mapping(ring->trb_address_map, ring,
+			first, last, flags);
+	if (ret) {
+		struct xhci_segment *next;
+		do {
+			next = first->next;
+			xhci_segment_free(xhci, first);
+			if (first == last)
+				break;
+			first = next;
+		} while (true);
+		return ret;
+	}
+
 	xhci_link_rings(xhci, ring, first, last, num_segs);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_ring_expansion,
 			"ring expansion succeed, now has %d segments",
 			ring->num_segs);
 
-	if (ring->type == TYPE_STREAM) {
-		ret = xhci_update_stream_mapping(ring, flags);
-		WARN_ON(ret); /* FIXME */
-	}
-
 	return 0;
 }
 
-- 
1.8.3.3

