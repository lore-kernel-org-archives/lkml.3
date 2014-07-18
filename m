Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371AbaGRMIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:08:00 -0400
Received: from 8bytes.org ([81.169.241.247]:47502 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761525AbaGRMHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:07:17 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/6] PM / Hibernate: Create a Radix-Tree to store memory bitmap
Date: Fri, 18 Jul 2014 13:57:18 +0200
Message-Id: <1405684643-30234-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405684643-30234-1-git-send-email-joro@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This patch adds the code to allocate and build the radix
tree to store the memory bitmap. The old data structure is
left in place until the radix tree implementation is
finished.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 kernel/power/snapshot.c | 224 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 223 insertions(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 1ea328a..d0f11ec 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -248,11 +248,24 @@ static void *chain_alloc(struct chain_allocator *ca, unsigned int size)
  *	information is stored (in the form of a block of bitmap)
  *	It also contains the pfns that correspond to the start and end of
  *	the represented memory area.
+ *
+ *	The memory bitmap is organized as a radix tree to guarantee fast random
+ *	access to the bits. There is one radix tree for each zone (as returned
+ *	from create_mem_extents).
+ *
+ *	One radix tree is represented by one struct mem_zone_bm_rtree. There are
+ *	two linked lists for the nodes of the tree, one for the inner nodes and
+ *	one for the leave nodes. The linked leave nodes are used for fast linear
+ *	access of the memory bitmap.
+ *
+ *	The struct rtree_node represents one node of the radix tree.
  */
 
 #define BM_END_OF_MAP	(~0UL)
 
 #define BM_BITS_PER_BLOCK	(PAGE_SIZE * BITS_PER_BYTE)
+#define BM_BLOCK_SHIFT		(PAGE_SHIFT + 3)
+#define BM_BLOCK_MASK		((1UL << BM_BLOCK_SHIFT) - 1)
 
 struct bm_block {
 	struct list_head hook;	/* hook into a list of bitmap blocks */
@@ -266,6 +279,31 @@ static inline unsigned long bm_block_bits(struct bm_block *bb)
 	return bb->end_pfn - bb->start_pfn;
 }
 
+/*
+ * struct rtree_node is a wrapper struct to link the nodes
+ * of the rtree together for easy linear iteration over
+ * bits and easy freeing
+ */
+struct rtree_node {
+	struct list_head list;
+	unsigned long *data;
+};
+
+/*
+ * struct mem_zone_bm_rtree represents a bitmap used for one
+ * populated memory zone.
+ */
+struct mem_zone_bm_rtree {
+	struct list_head list;		/* Link Zones together         */
+	struct list_head nodes;		/* Radix Tree inner nodes      */
+	struct list_head leaves;	/* Radix Tree leaves           */
+	unsigned long start_pfn;	/* Zone start page frame       */
+	unsigned long end_pfn;		/* Zone end page frame + 1     */
+	struct rtree_node *rtree;	/* Radix Tree Root             */
+	int levels;			/* Number of Radix Tree Levels */
+	unsigned int blocks;		/* Number of Bitmap Blocks     */
+};
+
 /* strcut bm_position is used for browsing memory bitmaps */
 
 struct bm_position {
@@ -274,6 +312,7 @@ struct bm_position {
 };
 
 struct memory_bitmap {
+	struct list_head zones;
 	struct list_head blocks;	/* list of bitmap blocks */
 	struct linked_page *p_list;	/* list of pages used to store zone
 					 * bitmap objects and bitmap block
@@ -284,6 +323,167 @@ struct memory_bitmap {
 
 /* Functions that operate on memory bitmaps */
 
+#define BM_ENTRIES_PER_LEVEL	(PAGE_SIZE / sizeof(unsigned long))
+#if BITS_PER_LONG == 32
+#define BM_RTREE_LEVEL_SHIFT	(PAGE_SHIFT - 2)
+#else
+#define BM_RTREE_LEVEL_SHIFT	(PAGE_SHIFT - 3)
+#endif
+#define BM_RTREE_LEVEL_MASK	((1UL << BM_RTREE_LEVEL_SHIFT) - 1)
+
+/*
+ *	alloc_rtree_node - Allocate a new node and add it to the radix
+ *			   tree.
+ *
+ *	This function is used to allocate inner nodes as well as the
+ *	leave nodes of the radix tree. It also adds the node to the
+ *	corresponding linked list passed in by the *list parameter.
+ */
+static struct rtree_node *alloc_rtree_node(gfp_t gfp_mask, int safe_needed,
+					   struct chain_allocator *ca,
+					   struct list_head *list)
+{
+	struct rtree_node *node;
+
+	node = chain_alloc(ca, sizeof(struct rtree_node));
+	if (!node)
+		return NULL;
+
+	node->data = get_image_page(gfp_mask, safe_needed);
+	if (!node->data)
+		return NULL;
+
+	list_add_tail(&node->list, list);
+
+	return node;
+}
+
+/*
+ *	add_rtree_block - Add a new leave node to the radix tree
+ *
+ *	The leave nodes need to be allocated in order to keep the leaves
+ *	linked list in order. This is guaranteed by the zone->blocks
+ *	counter.
+ */
+static int add_rtree_block(struct mem_zone_bm_rtree *zone, gfp_t gfp_mask,
+			   int safe_needed, struct chain_allocator *ca)
+{
+	struct rtree_node *node, *block, **dst;
+	unsigned int levels_needed, block_nr;
+	int i;
+
+	block_nr	= zone->blocks;
+	levels_needed	= 0;
+
+	/* How many levels do we need for this block nr? */
+	while (block_nr) {
+		levels_needed += 1;
+		block_nr >>= BM_RTREE_LEVEL_SHIFT;
+	}
+
+	/* Make sure the rtree has enough levels */
+	for (i = zone->levels; i < levels_needed; i++) {
+		node = alloc_rtree_node(gfp_mask, safe_needed, ca,
+					&zone->nodes);
+		if (!node)
+			return -ENOMEM;
+
+		node->data[0] = (unsigned long)zone->rtree;
+		zone->rtree   = node;
+		zone->levels += 1;
+	}
+
+	/* Allocate new block */
+	block = alloc_rtree_node(gfp_mask, safe_needed, ca, &zone->leaves);
+	if (!block)
+		return -ENOMEM;
+
+	/* Now walk the rtree to insert the block */
+	node     = zone->rtree;
+	dst      = &zone->rtree;
+	block_nr = zone->blocks;
+	for (i = zone->levels; i > 0; i--) {
+		int index;
+
+		if (!node) {
+			node = alloc_rtree_node(gfp_mask, safe_needed, ca,
+						&zone->nodes);
+			if (!node)
+				return -ENOMEM;
+			*dst = node;
+		}
+
+		index  = block_nr >> ((i - 1) * BM_RTREE_LEVEL_SHIFT);
+		index &= BM_RTREE_LEVEL_MASK;
+		dst    = (struct rtree_node **)&((*dst)->data[index]);
+		node   = *dst;
+	}
+
+	zone->blocks += 1;
+	*dst          = block;
+
+	return 0;
+}
+
+static void free_zone_bm_rtree(struct mem_zone_bm_rtree *zone,
+			       int clear_nosave_free);
+
+/*
+ *	create_zone_bm_rtree - create a radix tree for one zone
+ *
+ *	Allocated the mem_zone_bm_rtree structure and initializes it.
+ *	This function also allocated and builds the radix tree for the
+ *	zone.
+ */
+static struct mem_zone_bm_rtree *
+create_zone_bm_rtree(gfp_t gfp_mask, int safe_needed,
+		     struct chain_allocator *ca,
+		     unsigned long start, unsigned long end)
+{
+	struct mem_zone_bm_rtree *zone;
+	unsigned int i, nr_blocks;
+	unsigned long pages;
+
+	pages = end - start;
+	zone  = chain_alloc(ca, sizeof(struct mem_zone_bm_rtree));
+	if (!zone)
+		return NULL;
+
+	INIT_LIST_HEAD(&zone->nodes);
+	INIT_LIST_HEAD(&zone->leaves);
+	zone->start_pfn = start;
+	zone->end_pfn   = end;
+	nr_blocks       = DIV_ROUND_UP(pages, BM_BITS_PER_BLOCK);
+
+	for (i = 0; i < nr_blocks; i++) {
+		if (add_rtree_block(zone, gfp_mask, safe_needed, ca)) {
+			free_zone_bm_rtree(zone, PG_UNSAFE_CLEAR);
+			return NULL;
+		}
+	}
+
+	return zone;
+}
+
+/*
+ *	free_zone_bm_rtree - Free the memory of the radix tree
+ *
+ *	Free all node pages of the radix tree. The mem_zone_bm_rtree
+ *	structure itself is not freed here nor are the rtree_node
+ *	structs.
+ */
+static void free_zone_bm_rtree(struct mem_zone_bm_rtree *zone,
+			       int clear_nosave_free)
+{
+	struct rtree_node *node;
+
+	list_for_each_entry(node, &zone->nodes, list)
+		free_image_page(node->data, clear_nosave_free);
+
+	list_for_each_entry(node, &zone->leaves, list)
+		free_image_page(node->data, clear_nosave_free);
+}
+
 static void memory_bm_position_reset(struct memory_bitmap *bm)
 {
 	bm->cur.block = list_entry(bm->blocks.next, struct bm_block, hook);
@@ -408,12 +608,14 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 
 	chain_init(&ca, gfp_mask, safe_needed);
 	INIT_LIST_HEAD(&bm->blocks);
+	INIT_LIST_HEAD(&bm->zones);
 
 	error = create_mem_extents(&mem_extents, gfp_mask);
 	if (error)
 		return error;
 
 	list_for_each_entry(ext, &mem_extents, hook) {
+		struct mem_zone_bm_rtree *zone;
 		struct bm_block *bb;
 		unsigned long pfn = ext->start;
 		unsigned long pages = ext->end - ext->start;
@@ -441,6 +643,12 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
 			}
 			bb->end_pfn = pfn;
 		}
+
+		zone = create_zone_bm_rtree(gfp_mask, safe_needed, &ca,
+					    ext->start, ext->end);
+		if (!zone)
+			goto Error;
+		list_add_tail(&zone->list, &bm->zones);
 	}
 
 	bm->p_list = ca.chain;
@@ -460,14 +668,19 @@ memory_bm_create(struct memory_bitmap *bm, gfp_t gfp_mask, int safe_needed)
   */
 static void memory_bm_free(struct memory_bitmap *bm, int clear_nosave_free)
 {
+	struct mem_zone_bm_rtree *zone;
 	struct bm_block *bb;
 
 	list_for_each_entry(bb, &bm->blocks, hook)
 		if (bb->data)
 			free_image_page(bb->data, clear_nosave_free);
 
+	list_for_each_entry(zone, &bm->zones, list)
+		free_zone_bm_rtree(zone, clear_nosave_free);
+
 	free_list_of_pages(bm->p_list, clear_nosave_free);
 
+	INIT_LIST_HEAD(&bm->zones);
 	INIT_LIST_HEAD(&bm->blocks);
 }
 
@@ -816,12 +1029,21 @@ void free_basic_memory_bitmaps(void)
 
 unsigned int snapshot_additional_pages(struct zone *zone)
 {
+	unsigned int rtree, nodes;
 	unsigned int res;
 
 	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
 	res += DIV_ROUND_UP(res * sizeof(struct bm_block),
 			    LINKED_PAGE_DATA_SIZE);
-	return 2 * res;
+	rtree = nodes = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
+	rtree += DIV_ROUND_UP(rtree * sizeof(struct rtree_node),
+			      LINKED_PAGE_DATA_SIZE);
+	while (nodes > 1) {
+		nodes = DIV_ROUND_UP(nodes, BM_ENTRIES_PER_LEVEL);
+		rtree += nodes;
+	}
+
+	return 2 * (res + rtree);
 }
 
 #ifdef CONFIG_HIGHMEM
-- 
1.9.1

