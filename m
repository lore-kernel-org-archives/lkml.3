Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaGUK11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:27:27 -0400
Received: from 8bytes.org ([81.169.241.247]:50856 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbaGUK1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:27:08 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5/6] PM / Hibernate: Remove the old memory-bitmap implementation
Date: Mon, 21 Jul 2014 12:27:01 +0200
Message-Id: <1405938422-21900-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405938422-21900-1-git-send-email-joro@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The radix tree implementatio is proved to work the same as
the old implementation now. So the old implementation can be
removed to finish the switch to the radix tree for the
memory bitmaps.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 kernel/power/snapshot.c | 223 +++++-------------------------------------------
 1 file changed, 21 insertions(+), 202 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 83a6c61..6a4e07e 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -267,18 +267,6 @@ static void *chain_alloc(struct chain_allocator *ca, unsigned int size)
 #define BM_BLOCK_SHIFT		(PAGE_SHIFT + 3)
 #define BM_BLOCK_MASK		((1UL << BM_BLOCK_SHIFT) - 1)
 
-struct bm_block {
-	struct list_head hook;	/* hook into a list of bitmap blocks */
-	unsigned long start_pfn;	/* pfn represented by the first bit */
-	unsigned long end_pfn;	/* pfn represented by the last bit plus 1 */
-	unsigned long *data;	/* bitmap representing pages */
-};
-
-static inline unsigned long bm_block_bits(struct bm_block *bb)
-{
-	return bb->end_pfn - bb->start_pfn;
-}
-
 /*
  * struct rtree_node is a wrapper struct to link the nodes
  * of the rtree together for easy linear iteration over
@@ -307,9 +295,6 @@ struct mem_zone_bm_rtree {
 /* strcut bm_position is used for browsing memory bitmaps */
 
 struct bm_position {
-	struct bm_block *block;
-	int bit;
-
 	struct mem_zone_bm_rtree *zone;
 	struct rtree_node *node;
 	unsigned long node_pfn;
@@ -318,7 +303,6 @@ struct bm_position {
 
 struct memory_bitmap {
 	struct list_head zones;
-	struct list_head blocks;	/* list of bitmap blocks */
 	struct linked_page *p_list;	/* list of pages used to store zone
 					 * bitmap objects and bitmap block
 					 * objects
@@ -490,9 +474,6 @@ static void free_zone_bm_rtree(struct mem_zone_bm_rtree *zone,
 
 static void memory_bm_position_reset(struct memory_bitmap *bm)
 {
-	bm->cur.block = list_entry(bm->blocks.next, struct bm_block, hook);
-	bm->cur.bit = 0;
-
 	bm->cur.zone = list_entry(bm->zones.next, struct mem_zone_bm_rtree,
 				  list);
 	bm->cur.node = list_entry(bm->cur.zone->leaves.next,
@@ -503,30 +484,6 @@ static void memory_bm_position_reset(struct memory_bitmap *bm)
 
 static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free);
 
-/**
- *	create_bm_block_list - create a list of block bitmap objects
- *	@pages - number of pages to track
- *	@list - list to put the allocated blocks into
- *	@ca - chain allocator to be used for allocating memory
- */
-static int create_bm_block_list(unsigned long pages,
-				struct list_head *list,
-				struct chain_allocator *ca)
-{
-	unsigned int nr_blocks = DIV_ROUND_UP(pages, BM_BITS_PER_BLOCK);
-
-	while (nr_blocks-- > 0) {
-		struct bm_block *bb;
-
-		bb = chain_alloc(ca, sizeof(struct bm_block));
-		if (!bb)
-			return -ENOMEM;
-		list_add(&bb->hook, list);
-	}
-
-	return 0;
-}
-
 struct mem_extent {
 	struct list_head hook;
 	unsigned long start;
@@ -618,7 +575,6 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 	int error;
 
 	chain_init(&ca, gfp_mask, safe_needed);
-	INIT_LIST_HEAD(&bm->blocks);
 	INIT_LIST_HEAD(&bm->zones);
 
 	error = create_mem_extents(&mem_extents, gfp_mask);
@@ -627,38 +583,13 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 
 	list_for_each_entry(ext, &mem_extents, hook) {
 		struct mem_zone_bm_rtree *zone;
-		struct bm_block *bb;
-		unsigned long pfn = ext->start;
-		unsigned long pages = ext->end - ext->start;
-
-		bb = list_entry(bm->blocks.prev, struct bm_block, hook);
-
-		error = create_bm_block_list(pages, bm->blocks.prev, &ca);
-		if (error)
-			goto Error;
-
-		list_for_each_entry_continue(bb, &bm->blocks, hook) {
-			bb->data = get_image_page(gfp_mask, safe_needed);
-			if (!bb->data) {
-				error = -ENOMEM;
-				goto Error;
-			}
-
-			bb->start_pfn = pfn;
-			if (pages >= BM_BITS_PER_BLOCK) {
-				pfn += BM_BITS_PER_BLOCK;
-				pages -= BM_BITS_PER_BLOCK;
-			} else {
-				/* This is executed only once in the loop */
-				pfn += pages;
-			}
-			bb->end_pfn = pfn;
-		}
 
 		zone = create_zone_bm_rtree(gfp_mask, safe_needed, &ca,
 					    ext->start, ext->end);
-		if (!zone)
+		if (!zone) {
+			error = -ENOMEM;
 			goto Error;
+		}
 		list_add_tail(&zone->list, &bm->zones);
 	}
 
@@ -680,11 +611,6 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free)
 {
 	struct mem_zone_bm_rtree *zone;
-	struct bm_block *bb;
-
-	list_for_each_entry(bb, &bm->blocks, hook)
-		if (bb->data)
-			free_image_page(bb->data, clear_nosave_free);
 
 	list_for_each_entry(zone, &bm->zones, list)
 		free_zone_bm_rtree(zone, clear_nosave_free);
@@ -692,55 +618,20 @@ static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free)
 	free_list_of_pages(bm->p_list, clear_nosave_free);
 
 	INIT_LIST_HEAD(&bm->zones);
-	INIT_LIST_HEAD(&bm->blocks);
 }
 
 /**
- *	memory_bm_find_bit - find the bit in the bitmap @bm that corresponds
- *	to given pfn.  The cur_zone_bm member of @bm and the cur_block member
- *	of @bm->cur_zone_bm are updated.
- */
-static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
-				void **addr, unsigned int *bit_nr)
-{
-	struct bm_block *bb;
-
-	/*
-	 * Check if the pfn corresponds to the current bitmap block and find
-	 * the block where it fits if this is not the case.
-	 */
-	bb = bm->cur.block;
-	if (pfn < bb->start_pfn)
-		list_for_each_entry_continue_reverse(bb, &bm->blocks, hook)
-			if (pfn >= bb->start_pfn)
-				break;
-
-	if (pfn >= bb->end_pfn)
-		list_for_each_entry_continue(bb, &bm->blocks, hook)
-			if (pfn >= bb->start_pfn && pfn < bb->end_pfn)
-				break;
-
-	if (&bb->hook == &bm->blocks)
-		return -EFAULT;
-
-	/* The block has been found */
-	bm->cur.block = bb;
-	pfn -= bb->start_pfn;
-	bm->cur.bit = pfn + 1;
-	*bit_nr = pfn;
-	*addr = bb->data;
-	return 0;
-}
-
-/*
- *	memory_rtree_find_bit - Find the bit for pfn in the memory
- *				bitmap
+ *	memory_bm_find_bit - Find the bit for pfn in the memory
+ *			     bitmap
  *
- *	Walks the radix tree to find the page which contains the bit for
+ *	Find the bit in the bitmap @bm that corresponds to given pfn.
+ *	The cur.zone, cur.block and cur.node_pfn member of @bm are
+ *	updated.
+ *	It walks the radix tree to find the page which contains the bit for
  *	pfn and returns the bit position in **addr and *bit_nr.
  */
-static int memory_rtree_find_bit(struct memory_bitmap *bm, unsigned long pfn,
-				 void **addr, unsigned int *bit_nr)
+static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
+			      void **addr, unsigned int *bit_nr)
 {
 	struct mem_zone_bm_rtree *curr, *zone;
 	struct rtree_node *node;
@@ -808,10 +699,6 @@ static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	BUG_ON(error);
 	set_bit(bit, addr);
-
-	error = memory_rtree_find_bit(bm, pfn, &addr, &bit);
-	BUG_ON(error);
-	set_bit(bit, addr);
 }
 
 static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
@@ -823,12 +710,6 @@ static int mem_bm_set_bit_check(struct memory_bitmap *bm, unsigned long pfn)
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	if (!error)
 		set_bit(bit, addr);
-	else
-		return error;
-
-	error = memory_rtree_find_bit(bm, pfn, &addr, &bit);
-	if (!error)
-		set_bit(bit, addr);
 
 	return error;
 }
@@ -842,10 +723,6 @@ static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	BUG_ON(error);
 	clear_bit(bit, addr);
-
-	error = memory_rtree_find_bit(bm, pfn, &addr, &bit);
-	BUG_ON(error);
-	clear_bit(bit, addr);
 }
 
 static void memory_bm_clear_current(struct memory_bitmap *bm)
@@ -854,82 +731,25 @@ static void memory_bm_clear_current(struct memory_bitmap *bm)
 
 	bit  = max(bm->cur.node_bit - 1, 0);
 	clear_bit(bit, bm->cur.node->data);
-
-	bit = max(bm->cur.bit - 1, 0);
-	clear_bit(bit, bm->cur.block->data);
 }
 
 static int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
-	int error, error2;
-	int v;
+	int error;
 
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
 	BUG_ON(error);
-	v = test_bit(bit, addr);
-
-	error2 = memory_rtree_find_bit(bm, pfn, &addr, &bit);
-	BUG_ON(error2);
-
-	WARN_ON_ONCE(v != test_bit(bit, addr));
-
-	return v;
+	return test_bit(bit, addr);
 }
 
 static bool memory_bm_pfn_present(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
 	unsigned int bit;
-	int present;
-
-	present = !memory_bm_find_bit(bm, pfn, &addr, &bit);
-
-	WARN_ON_ONCE(present != !memory_rtree_find_bit(bm, pfn, &addr, &bit));
 
-	return present;
-}
-
-/**
- *	memory_bm_next_pfn - find the pfn that corresponds to the next set bit
- *	in the bitmap @bm.  If the pfn cannot be found, BM_END_OF_MAP is
- *	returned.
- *
- *	It is required to run memory_bm_position_reset() before the first call to
- *	this function.
- */
-
-static unsigned long memory_bm_rtree_next_pfn(struct memory_bitmap *bm);
-
-static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
-{
-	unsigned long rtree_pfn;
-	struct bm_block *bb;
-	int bit;
-
-	rtree_pfn = memory_bm_rtree_next_pfn(bm);
-
-	bb = bm->cur.block;
-	do {
-		bit = bm->cur.bit;
-		bit = find_next_bit(bb->data, bm_block_bits(bb), bit);
-		if (bit < bm_block_bits(bb))
-			goto Return_pfn;
-
-		bb = list_entry(bb->hook.next, struct bm_block, hook);
-		bm->cur.block = bb;
-		bm->cur.bit = 0;
-	} while (&bb->hook != &bm->blocks);
-
-	memory_bm_position_reset(bm);
-	WARN_ON_ONCE(rtree_pfn != BM_END_OF_MAP);
-	return BM_END_OF_MAP;
-
- Return_pfn:
-	WARN_ON_ONCE(bb->start_pfn + bit != rtree_pfn);
-	bm->cur.bit = bit + 1;
-	return bb->start_pfn + bit;
+	return !memory_bm_find_bit(bm, pfn, &addr, &bit);
 }
 
 /*
@@ -967,14 +787,17 @@ static bool rtree_next_node(struct memory_bitmap *bm)
 	return false;
 }
 
-/*
- *	memory_bm_rtree_next_pfn - Find the next set bit
+/**
+ *	memory_bm_rtree_next_pfn - Find the next set bit in the bitmap @bm
  *
  *	Starting from the last returned position this function searches
  *	for the next set bit in the memory bitmap and returns its
  *	number. If no more bit is set BM_END_OF_MAP is returned.
+ *
+ *	It is required to run memory_bm_position_reset() before the
+ *	first call to this function.
  */
-static unsigned long memory_bm_rtree_next_pfn(struct memory_bitmap *bm)
+static unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
 {
 	unsigned long bits, pfn, pages;
 	int bit;
@@ -1216,11 +1039,7 @@ void free_basic_memory_bitmaps(void)
 unsigned int snapshot_additional_pages(struct zone *zone)
 {
 	unsigned int rtree, nodes;
-	unsigned int res;
 
-	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
-	res += DIV_ROUND_UP(res * sizeof(struct bm_block),
-			    LINKED_PAGE_DATA_SIZE);
 	rtree = nodes = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
 	rtree += DIV_ROUND_UP(rtree * sizeof(struct rtree_node),
 			      LINKED_PAGE_DATA_SIZE);
@@ -1229,7 +1048,7 @@ unsigned int snapshot_additional_pages(struct zone *zone)
 		rtree += nodes;
 	}
 
-	return 2 * (res + rtree);
+	return 2 * rtree;
 }
 
 #ifdef CONFIG_HIGHMEM
-- 
1.9.1

