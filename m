Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3IML12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab3IML10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:27:26 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/6] xhci: fix usb3 streams
Date: Fri, 13 Sep 2013 13:27:10 +0200
Message-Id: <1379071635-30701-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci maintains a radix tree for each stream endpoint because it must
be able to map a trb address to the stream ring.  Each ring segment
must be added to the ring for this to work.  Currently xhci sticks
only the first segment of each stream ring into the radix tree.

Result is that things work initially, but as soon as the first segment
is full xhci can't map the trb address from the completion event to the
stream ring any more -> BOOM.  You'll find this message in the logs:

  ERROR Transfer event for disabled endpoint or incorrect stream ring

This patch adds a helper function to update the radix tree.  It can
both insert and remove ring segments.  It loops over the segment list
and handles all segments instead of just the first.  It is called
whenever an update is needed:  When allocating a ring, when expanding
a ring and when releasing a ring.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/host/xhci-mem.c | 53 ++++++++++++++++++++++++++++++++++-----------
 drivers/usb/host/xhci.h     |  2 ++
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 6f8c2fd..de8b006 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -154,8 +154,11 @@ void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
 	if (!ring)
 		return;
 
-	if (ring->first_seg)
+	if (ring->first_seg) {
+		if (ring->type == TYPE_STREAM)
+			xhci_update_stream_ring(ring, false);
 		xhci_free_segments_for_ring(xhci, ring->first_seg);
+	}
 
 	kfree(ring);
 }
@@ -351,6 +354,11 @@ int xhci_ring_expansion(struct xhci_hcd *xhci, struct xhci_ring *ring,
 	xhci_dbg(xhci, "ring expansion succeed, now has %d segments\n",
 			ring->num_segs);
 
+	if (ring->type == TYPE_STREAM) {
+		ret = xhci_update_stream_ring(ring, true);
+		WARN_ON(ret); /* FIXME */
+	}
+
 	return 0;
 }
 
@@ -601,6 +609,35 @@ static int xhci_test_radix_tree(struct xhci_hcd *xhci,
  * extended systems (where the DMA address can be bigger than 32-bits),
  * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
  */
+
+int xhci_update_stream_ring(struct xhci_ring *ring, bool insert)
+{
+	struct xhci_segment *seg;
+	unsigned long key;
+	bool present;
+	int ret;
+
+	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
+		return 0;
+
+	seg = ring->first_seg;
+	do {
+		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
+		present = radix_tree_lookup(ring->trb_address_map, key) != NULL;
+		if (!present && insert) {
+			ret = radix_tree_insert(ring->trb_address_map,
+						key, ring);
+			if (ret)
+				return ret;
+		}
+		if (present && !insert)
+			radix_tree_delete(ring->trb_address_map, key);
+		seg = seg->next;
+	} while (seg != ring->first_seg);
+
+	return 0;
+}
+
 struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 		unsigned int num_stream_ctxs,
 		unsigned int num_streams, gfp_t mem_flags)
@@ -608,7 +645,6 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 	struct xhci_stream_info *stream_info;
 	u32 cur_stream;
 	struct xhci_ring *cur_ring;
-	unsigned long key;
 	u64 addr;
 	int ret;
 
@@ -663,6 +699,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 		if (!cur_ring)
 			goto cleanup_rings;
 		cur_ring->stream_id = cur_stream;
+		cur_ring->trb_address_map = &stream_info->trb_address_map;
 		/* Set deq ptr, cycle bit, and stream context type */
 		addr = cur_ring->first_seg->dma |
 			SCT_FOR_CTX(SCT_PRI_TR) |
@@ -672,10 +709,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 		xhci_dbg(xhci, "Setting stream %d ring ptr to 0x%08llx\n",
 				cur_stream, (unsigned long long) addr);
 
-		key = (unsigned long)
-			(cur_ring->first_seg->dma >> TRB_SEGMENT_SHIFT);
-		ret = radix_tree_insert(&stream_info->trb_address_map,
-				key, cur_ring);
+		ret = xhci_update_stream_ring(cur_ring, true);
 		if (ret) {
 			xhci_ring_free(xhci, cur_ring);
 			stream_info->stream_rings[cur_stream] = NULL;
@@ -702,9 +736,6 @@ cleanup_rings:
 	for (cur_stream = 1; cur_stream < num_streams; cur_stream++) {
 		cur_ring = stream_info->stream_rings[cur_stream];
 		if (cur_ring) {
-			addr = cur_ring->first_seg->dma;
-			radix_tree_delete(&stream_info->trb_address_map,
-					addr >> TRB_SEGMENT_SHIFT);
 			xhci_ring_free(xhci, cur_ring);
 			stream_info->stream_rings[cur_stream] = NULL;
 		}
@@ -764,7 +795,6 @@ void xhci_free_stream_info(struct xhci_hcd *xhci,
 {
 	int cur_stream;
 	struct xhci_ring *cur_ring;
-	dma_addr_t addr;
 
 	if (!stream_info)
 		return;
@@ -773,9 +803,6 @@ void xhci_free_stream_info(struct xhci_hcd *xhci,
 			cur_stream++) {
 		cur_ring = stream_info->stream_rings[cur_stream];
 		if (cur_ring) {
-			addr = cur_ring->first_seg->dma;
-			radix_tree_delete(&stream_info->trb_address_map,
-					addr >> TRB_SEGMENT_SHIFT);
 			xhci_ring_free(xhci, cur_ring);
 			stream_info->stream_rings[cur_stream] = NULL;
 		}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c338741..b525cfc 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1334,6 +1334,7 @@ struct xhci_ring {
 	unsigned int		num_trbs_free_temp;
 	enum xhci_ring_type	type;
 	bool			last_td_was_short;
+	struct radix_tree_root	*trb_address_map;
 };
 
 struct xhci_erst_entry {
@@ -1702,6 +1703,7 @@ int xhci_endpoint_init(struct xhci_hcd *xhci, struct xhci_virt_device *virt_dev,
 void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring);
 int xhci_ring_expansion(struct xhci_hcd *xhci, struct xhci_ring *ring,
 				unsigned int num_trbs, gfp_t flags);
+int xhci_update_stream_ring(struct xhci_ring *ring, bool insert);
 void xhci_free_or_cache_endpoint_ring(struct xhci_hcd *xhci,
 		struct xhci_virt_device *virt_dev,
 		unsigned int ep_index);
-- 
1.8.3.1

