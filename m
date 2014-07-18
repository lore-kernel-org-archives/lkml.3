Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbaGRMHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:07:21 -0400
Received: from 8bytes.org ([81.169.241.247]:47498 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759454AbaGRMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:07:15 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/6] PM / Hibernate: Implement position keeping in radix tree
Date: Fri, 18 Jul 2014 13:57:20 +0200
Message-Id: <1405684643-30234-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405684643-30234-1-git-send-email-joro@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add code to remember the last position that was requested in
the radix tree. Use it as a cache for faster linear walking
of the bitmap in the memory_bm_rtree_next_pfn() function
which is also added with this patch.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 kernel/power/snapshot.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 9a3b723..2ccbf77 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -309,6 +309,11 @@ struct mem_zone_bm_rtree {
 struct bm_position {
 	struct bm_block *block;
 	int bit;
+
+	struct mem_zone_bm_rtree *zone;
+	struct rtree_node *node;
+	unsigned long node_pfn;
+	int node_bit;
 };
 
 struct memory_bitmap {
@@ -488,6 +493,13 @@ static void memory_bm_position_reset(struct memory_bitmap *bm)
 {
 	bm->cur.block = list_entry(bm->blocks.next, struct bm_block, hook);
 	bm->cur.bit = 0;
+
+	bm->cur.zone = list_entry(bm->zones.next, struct mem_zone_bm_rtree,
+				  list);
+	bm->cur.node = list_entry(bm->cur.zone->leaves.next,
+				  struct rtree_node, list);
+	bm->cur.node_pfn = 0;
+	bm->cur.node_bit = 0;
 }
 
 static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free);
@@ -735,6 +747,11 @@ static int memory_rtree_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 	struct rtree_node *node;
 	int i, block_nr;
 
+	zone = bm->cur.zone;
+
+	if (pfn >= zone->start_pfn && pfn < zone->end_pfn)
+		goto zone_found;
+
 	zone = NULL;
 
 	/* Find the right zone */
@@ -748,10 +765,16 @@ static int memory_rtree_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 	if (!zone)
 		return -EFAULT;
 
+zone_found:
 	/*
 	 * We have a zone. Now walk the radix tree to find the leave
 	 * node for our pfn.
 	 */
+
+	node = bm->cur.node;
+	if (((pfn - zone->start_pfn) & ~BM_BLOCK_MASK) == bm->cur.node_pfn)
+		goto node_found;
+
 	node      = zone->rtree;
 	block_nr  = (pfn - zone->start_pfn) >> BM_BLOCK_SHIFT;
 
@@ -764,9 +787,15 @@ static int memory_rtree_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 		node = (struct rtree_node *)node->data[index];
 	}
 
+node_found:
+	/* Update last position */
+	bm->cur.zone     = zone;
+	bm->cur.node     = node;
+	bm->cur.node_pfn = (pfn - zone->start_pfn) & ~BM_BLOCK_MASK;
+
 	/* Set return values */
-	*addr   = node->data;
-	*bit_nr = (pfn - zone->start_pfn) & BM_BLOCK_MASK;
+	*addr            = node->data;
+	*bit_nr          = (pfn - zone->start_pfn) & BM_BLOCK_MASK;
 
 	return 0;
 }
@@ -861,11 +890,16 @@ static bool memory_bm_pfn_present(struct memory_bitmap *bm, unsigned long pfn)
  *	this function.
  */
 
+static unsigned long memory_bm_rtree_next_pfn(struct memory_bitmap *bm);
+
 static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
 {
+	unsigned long rtree_pfn;
 	struct bm_block *bb;
 	int bit;
 
+	rtree_pfn = memory_bm_rtree_next_pfn(bm);
+
 	bb = bm->cur.block;
 	do {
 		bit = bm->cur.bit;
@@ -879,13 +913,77 @@ static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
 	} while (&bb->hook != &bm->blocks);
 
 	memory_bm_position_reset(bm);
+	WARN_ON_ONCE(rtree_pfn != BM_END_OF_MAP);
 	return BM_END_OF_MAP;
 
  Return_pfn:
+	WARN_ON_ONCE(bb->start_pfn + bit != rtree_pfn);
 	bm->cur.bit = bit + 1;
 	return bb->start_pfn + bit;
 }
 
+/*
+ *	rtree_next_node - Jumps to the next leave node
+ *
+ *	Sets the position to the beginning of the next node in the
+ *	memory bitmap. This is either the next node in the current
+ *	zone's radix tree or the first node in the radix tree of the
+ *	next zone.
+ *
+ *	Returns true if there is a next node, false otherwise.
+ */
+static bool rtree_next_node(struct memory_bitmap *bm)
+{
+	bm->cur.node = list_entry(bm->cur.node->list.next,
+				  struct rtree_node, list);
+	if (&bm->cur.node->list != &bm->cur.zone->leaves) {
+		bm->cur.node_pfn += BM_BITS_PER_BLOCK;
+		bm->cur.node_bit  = 0;
+		return true;
+	}
+
+	/* No more nodes, goto next zone */
+	bm->cur.zone = list_entry(bm->cur.zone->list.next,
+				  struct mem_zone_bm_rtree, list);
+	if (&bm->cur.zone->list != &bm->zones) {
+		bm->cur.node = list_entry(bm->cur.zone->leaves.next,
+					  struct rtree_node, list);
+		bm->cur.node_pfn = 0;
+		bm->cur.node_bit = 0;
+		return true;
+	}
+
+	/* No more zones */
+	return false;
+}
+
+/*
+ *	memory_bm_rtree_next_pfn - Find the next set bit
+ *
+ *	Starting from the last returned position this function searches
+ *	for the next set bit in the memory bitmap and returns its
+ *	number. If no more bit is set BM_END_OF_MAP is returned.
+ */
+static unsigned long memory_bm_rtree_next_pfn(struct memory_bitmap *bm)
+{
+	unsigned long bits, pfn, pages;
+	int bit;
+
+	do {
+		pages	  = bm->cur.zone->end_pfn - bm->cur.zone->start_pfn;
+		bits      = min(pages - bm->cur.node_pfn, BM_BITS_PER_BLOCK);
+		bit	  = find_next_bit(bm->cur.node->data, bits,
+					  bm->cur.node_bit);
+		if (bit < bits) {
+			pfn = bm->cur.zone->start_pfn + bm->cur.node_pfn + bit;
+			bm->cur.node_bit = bit + 1;
+			return pfn;
+		}
+	} while (rtree_next_node(bm));
+
+	return BM_END_OF_MAP;
+}
+
 /**
  *	This structure represents a range of page frames the contents of which
  *	should not be saved during the suspend.
-- 
1.9.1

