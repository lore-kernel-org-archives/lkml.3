Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3GFFIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:08:47 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62325 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3GFFIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:08:40 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, sfr@canb.auug.org.au, andi@firstfloor.org, oleg@redhat.com,
        mingo@redhat.com, nab@linux-iscsi.org, axboe@kernel.dk,
        Kent Overstreet <koverstreet@google.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 03/10] idr: Rewrite ida
Date: Fri,  5 Jul 2013 22:08:14 -0700
Message-Id: <1373087301-23730-4-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

This is a new, from scratch implementation of ida that should be
simpler, faster and more space efficient.

Two primary reasons for the rewrite:
 * A future patch will reimplement idr on top of this ida implementation +
   radix trees. Once that's done, the end result will be ~1k fewer lines
   of code, much simpler and easier to understand and it should be quite
   a bit faster.

 * The performance improvements and addition of ganged allocation should
   make ida more suitable for use by a percpu id/tag allocator, which
   would then act as a frontend to this allocator.

The old ida implementation was done with the idr data structures - this
was IMO backwards. I'll soon be reimplementing idr on top of this new
ida implementation and radix trees - using a separate dedicated data
structure for the free ID bitmap should actually make idr faster, and
the end result is _significantly_ less code.

This implementation conceptually isn't that different from the old one -
it's a tree of bitmaps, where one bit in a given node indicates whether
or not there are free bits in a child node.

The main difference (and advantage) over the old version is that the
tree isn't implemented with pointers - it's implemented in an array,
like how heaps are implemented, which both better space efficiency and
it'll be faster since there's no pointer chasing. (It's not one giant
contiguous array, it's an array of arrays but the algorithm treats it as
one big array)

Time to allocate 1 << 24 ids:		0m0.663s
Time to allocate 1 << 24 ids, old code:	0m28.604s

Time to allocate INT_MAX ids:		1m41.371s
Time to allocate INT_MAX ids, old code:	Got bored of waiting for it to finish.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/idr.h | 122 ++++---
 lib/idr.c           | 894 +++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 687 insertions(+), 329 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index c0e0c54..a310bb0 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -16,6 +16,92 @@
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock_types.h>
+#include <linux/wait.h>
+
+/* IDA */
+
+struct ida {
+	spinlock_t		lock;
+
+	/*
+	 * cur_id and allocated_ids are for ida_alloc_cyclic. For cyclic
+	 * allocations we search for new ids to allocate starting from the last
+	 * id allocated - cur_id is the next id to try allocating.
+	 *
+	 * But we also don't want the allocated ids to be arbitrarily sparse -
+	 * the memory usage for the bitmap could be arbitrarily bad, and if
+	 * they're used as keys in a radix tree the memory overhead of the radix
+	 * tree could be quite bad as well. So we use allocated_ids to decide
+	 * when to restart cur_id from 0, and bound how sparse the bitmap can
+	 * be.
+	 */
+	unsigned		cur_id;
+	unsigned		allocated_ids;
+
+	/* size of ida->tree */
+	unsigned		nodes;
+
+	/*
+	 * Index of first leaf node in ida->tree; equal to the number of non
+	 * leaf nodes, ida->nodes - ida->first_leaf == number of leaf nodes
+	 */
+	unsigned		first_leaf;
+	unsigned		sections;
+
+	unsigned long		**tree;
+	unsigned long		*inline_section;
+	unsigned long		inline_node;
+};
+
+#define IDA_INIT(name)						\
+{								\
+	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+	.nodes		= 1,					\
+	.first_leaf	= 0,					\
+	.sections	= 1,					\
+	.tree		= &name.inline_section,			\
+	.inline_section	= &name.inline_node,			\
+}
+#define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
+
+void ida_remove(struct ida *ida, unsigned id);
+int ida_alloc_range(struct ida *ida, unsigned int start,
+		  unsigned int end, gfp_t gfp);
+int ida_alloc_cyclic(struct ida *ida, unsigned start, unsigned end, gfp_t gfp);
+void ida_destroy(struct ida *ida);
+int ida_init_prealloc(struct ida *ida, unsigned prealloc);
+
+/**
+ * ida_alloc_range - allocate a new id.
+ * @ida: the (initialized) ida.
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range [0, INT_MAX]. Returns -ENOSPC if no ids are
+ * available, or -ENOMEM on memory allocation failure.
+ *
+ * Returns the smallest available id
+ *
+ * Use ida_remove() to get rid of an id.
+ */
+static inline int ida_alloc(struct ida *ida, gfp_t gfp_mask)
+{
+	return ida_alloc_range(ida, 0, 0, gfp_mask);
+}
+
+/**
+ * ida_init - initialize ida handle
+ * @ida:	ida handle
+ *
+ * This function is use to set up the handle (@ida) that you will pass
+ * to the rest of the functions.
+ */
+static inline void ida_init(struct ida *ida)
+{
+	ida_init_prealloc(ida, 0);
+}
+
+/* IDR */
 
 /*
  * We want shallower trees and thus more bits covered at each layer.  8
@@ -195,42 +281,6 @@ static inline void __deprecated idr_remove_all(struct idr *idp)
 	__idr_remove_all(idp);
 }
 
-/*
- * IDA - IDR based id allocator, use when translation from id to
- * pointer isn't necessary.
- *
- * IDA_BITMAP_LONGS is calculated to be one less to accommodate
- * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
- */
-#define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
-#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long) - 1)
-#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
-
-struct ida_bitmap {
-	long			nr_busy;
-	unsigned long		bitmap[IDA_BITMAP_LONGS];
-};
-
-struct ida {
-	struct idr		idr;
-	struct ida_bitmap	*free_bitmap;
-};
-
-#define IDA_INIT(name)		{ .idr = IDR_INIT((name).idr), .free_bitmap = NULL, }
-#define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
-
-void ida_destroy(struct ida *ida);
-void ida_init(struct ida *ida);
-
-int ida_alloc_range(struct ida *ida, unsigned int start, unsigned int end,
-		   gfp_t gfp_mask);
-void ida_remove(struct ida *ida, unsigned int id);
-
-static inline int ida_alloc(struct ida *ida, gfp_t gfp_mask)
-{
-	return ida_alloc_range(ida, 0, 0, gfp_mask);
-}
-
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index df2d32e..4666350 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -8,6 +8,8 @@
  *
  * Modified by Nadia Derbey to make it RCU safe.
  *
+ * IDA completely rewritten by Kent Overstreet <koverstreet@google.com>
+ *
  * Small id to pointer translation service.
  *
  * It uses a radix tree like structure as a sparse array indexed
@@ -26,17 +28,608 @@
  * with the slab allocator.
  */
 
-#ifndef TEST                        // to test in user space...
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/export.h>
-#endif
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
 #include <linux/err.h>
-#include <linux/string.h>
+#include <linux/export.h>
+#include <linux/hardirq.h>
 #include <linux/idr.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+
+static void kgfree(void *ptr, size_t size)
+{
+	if (size < PAGE_SIZE)
+		kfree(ptr);
+	else
+		free_pages((unsigned long) ptr, get_order(size));
+}
+
+static void *kgalloc(size_t size, gfp_t gfp)
+{
+	return size < PAGE_SIZE
+		? kmalloc(size, gfp)
+		: (void *) __get_free_pages(gfp, get_order(size));
+}
+
+/**
+ * DOC: IDA description
+ * IDA - ID (small integer) allocator
+ *
+ * This works much like using a simple bitmap to allocate indices - ida_alloc()
+ * is equivalent to find_first_zero_bit() then __set_bit(), and ida_remove() is
+ * equivalent to __clear_bit(). But it's much more efficient than a large
+ * bitmap, and resizes itself as needed.
+ *
+ * It's implemented as a tree of bitmaps: a node in the tree is a single
+ * unsigned long. The leaf nodes of the tree are segments of the entire bitmap -
+ * a cleared bit indicates a free id, and a set bit indicates an allocated one.
+ * Bits in the parent nodes indicate whether or not there are free bits in the
+ * corresponding child node - when all the bits in a parent node are set, none
+ * of its children have bits free.
+ *
+ * The splay factor of the tree (IDA_TREE_ARY) == BITS_PER_LONG - parent nodes
+ * have 32 or 64 children.
+ *
+ * The tree itself is implemented with an array instead of pointers - exactly
+ * like the textbook implementation of D-ary heaps. The root of the bitmap tree
+ * is at ida->tree[0]. The children of node i are at i * IDA_TREE_ARY + 1 + j,
+ * where j is in the range [0, 63], and the parent of node i is at (i - 1) /
+ * IDA_TREE_ARY.
+ *
+ * This conveniently means that our leaf nodes are all contiguous in memory -
+ * the bit for id i is bit id % BITS_PER_LONG in ida->tree[ida->first_leaf + i /
+ * BITS_PER_LONG].
+ *
+ * Note that the number of ids we can allocate is limited by the amount of
+ * memory we can contiguously allocate. The amount of memory used for the bitmap
+ * tree is only slightly more than a flat bitmap would use - about 1 / TREE_ARY
+ * * (sizeof flat bitmap).
+ *
+ * So for 1 mb of memory (and allocating more than that should be fine with
+ * CONFIG_COMPACTION) you get slightly under 8 million IDs.
+ */
+
+#define IDA_TREE_ARY		BITS_PER_LONG
+#define IDA_ALLOC_ORDER_MAX	4
+#define IDA_SECTION_SIZE	(PAGE_SIZE << IDA_ALLOC_ORDER_MAX)
+#define IDA_NODES_PER_SECTION	(IDA_SECTION_SIZE / sizeof(unsigned long))
+
+static inline unsigned long *ida_index_to_node(struct ida *ida, unsigned node)
+{
+	return ida->tree[node / IDA_NODES_PER_SECTION] +
+		node % IDA_NODES_PER_SECTION;
+}
+
+/*
+ * For a given number of nodes, calculate how many are going to be parent nodes
+ * (equal to ida->first_leaf) and by extension how my will be leaves.
+ */
+static unsigned first_leaf_from_nodes(unsigned nodes)
+{
+	unsigned ret = 0;
+
+	while (ret * IDA_TREE_ARY + 1 < nodes)
+		ret = ret * IDA_TREE_ARY + 1;
+
+	return ret;
+}
+
+static void __ida_remove(struct ida *ida, unsigned int id)
+{
+	unsigned i = ida->first_leaf + id / BITS_PER_LONG;
+	unsigned bit = id % BITS_PER_LONG;
+
+	BUG_ON(i >= ida->nodes);
+
+	--ida->allocated_ids;
+
+	while (1) {
+		unsigned long *node = ida_index_to_node(ida, i), old = *node;
+
+		WARN_ON(!test_bit(bit, node));
+		__clear_bit(bit, node);
+
+		if (~old || !i)
+			break;
+
+		/*
+		 * If this node's bits were all 1s before we cleared this bit,
+		 * we need to clear this node's bit in the parent node - and so
+		 * on up to the root.
+		 */
+
+		bit = (i - 1) % IDA_TREE_ARY;
+		i = (i - 1) / IDA_TREE_ARY;
+	}
+}
+
+/**
+ * ida_remove - remove an allocated id.
+ * @ida: the (initialized) ida.
+ * @id: the id returned by ida_alloc_range.
+ */
+void ida_remove(struct ida *ida, unsigned int id)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&ida->lock, flags);
+	__ida_remove(ida, id);
+	spin_unlock_irqrestore(&ida->lock, flags);
+}
+EXPORT_SYMBOL(ida_remove);
+
+static void ida_increase_depth(struct ida *ida, unsigned new_nodes,
+			       unsigned new_first_leaf)
+{
+	unsigned old_leaves = ida->nodes - ida->first_leaf;
+	unsigned src = ida->nodes;
+	unsigned dst = new_first_leaf + old_leaves;
+	unsigned n, i, bit;
+	unsigned long *node;
+
+	/* Shift leaves up to new position */
+	while (src != ida->first_leaf) {
+		i = min((src - 1) % IDA_NODES_PER_SECTION + 1,
+			(dst - 1) % IDA_NODES_PER_SECTION + 1);
+
+		i = min(i, src - ida->first_leaf);
+
+		src -= i;
+		dst -= i;
+
+		memmove(ida_index_to_node(ida, dst),
+			ida_index_to_node(ida, src),
+			i * sizeof(unsigned long));
+	}
+
+	/* Zero out parent nodes */
+	for (n = 0; n < new_first_leaf; n += i) {
+		i = min_t(unsigned, new_first_leaf - n,
+			  IDA_NODES_PER_SECTION);
+
+		memset(ida_index_to_node(ida, n),
+		       0, i * sizeof(unsigned long));
+	}
+
+	/* Reconstruct parent nodes */
+	for (n = new_first_leaf; n < new_first_leaf + old_leaves; n++) {
+		i = n;
+		node = ida_index_to_node(ida, i);
+
+		while (!~*node && i) {
+			bit = (i - 1) % IDA_TREE_ARY;
+			i = (i - 1) / IDA_TREE_ARY;
+
+			node = ida_index_to_node(ida, i);
+			__set_bit(bit, node);
+		}
+	}
+}
+
+/*
+ * Attempt to double the size of the tree. We have to drop ida->lock to allocate
+ * memory, so we might race with another allocation that also tries to resize.
+ * So if the tree's not the size it originally was when we retake ida->lock,
+ * just return 0 - but the caller needs to recheck for the tree being full in
+ * case we _really_ raced badly.
+ */
+static int __ida_resize(struct ida *ida, gfp_t gfp, unsigned long *flags)
+	__releases(&ida->lock)
+	__acquires(&ida->lock)
+{
+	unsigned long *tree, **sections;
+	unsigned cur_nodes, new_nodes, new_first_leaf, cur_sections;
+again:
+	cur_nodes = ida->nodes;
+
+	new_nodes = roundup_pow_of_two(ida->nodes + 1) <= IDA_NODES_PER_SECTION
+		? roundup_pow_of_two(ida->nodes + 1)
+		: ida->nodes + IDA_NODES_PER_SECTION;
+
+	new_first_leaf = first_leaf_from_nodes(new_nodes);
+
+	sections = NULL;
+	cur_sections = ida->sections;
+
+	BUG_ON(ida->nodes > IDA_NODES_PER_SECTION &&
+	       ida->nodes % IDA_NODES_PER_SECTION);
+
+	spin_unlock_irqrestore(&ida->lock, *flags);
+
+	if (ida->nodes >= IDA_NODES_PER_SECTION &&
+	    is_power_of_2(cur_sections)) {
+		sections = kgalloc(cur_sections * 2 * sizeof(unsigned long *),
+				   __GFP_ZERO|gfp);
+		if (!sections)
+			goto err;
+	}
+
+	tree = kgalloc(min(new_nodes * sizeof(unsigned long),
+			   IDA_SECTION_SIZE), __GFP_ZERO|gfp);
+	if (!tree)
+		goto err;
+
+	spin_lock_irqsave(&ida->lock, *flags);
+
+	if (cur_nodes != ida->nodes || cur_sections != ida->sections) {
+		kgfree(sections, cur_sections * 2 * sizeof(unsigned long *));
+		kgfree(tree, min(new_nodes * sizeof(unsigned long),
+				 IDA_SECTION_SIZE));
+		return 0;
+	}
+
+	if (sections) {
+		memcpy(sections, ida->tree,
+		       ida->sections  * sizeof(unsigned long *));
+
+		if (ida->tree != &ida->inline_section)
+			kgfree(ida->tree, ida->sections * sizeof(unsigned long *));
+
+		ida->tree = sections;
+	}
+
+	if (ida->nodes < IDA_NODES_PER_SECTION) {
+		BUG_ON(new_nodes > IDA_NODES_PER_SECTION);
+
+		memcpy(tree, ida_index_to_node(ida, 0),
+		       ida->nodes * sizeof(unsigned long));
+
+		if (ida->tree[0] != &ida->inline_node)
+			kgfree(ida->tree[0], ida->nodes * sizeof(unsigned long));
+
+		ida->tree[0] = tree;
+
+		BUG_ON(new_nodes - new_first_leaf < ida->nodes - ida->first_leaf);
+	} else {
+		ida->tree[ida->sections++] = tree;
+
+		new_nodes = ida->sections * IDA_NODES_PER_SECTION;
+		new_first_leaf = first_leaf_from_nodes(new_nodes);
+
+		if (new_nodes - new_first_leaf < ida->nodes - ida->first_leaf)
+			goto again;
+	}
+
+	if (new_first_leaf != ida->first_leaf)
+		ida_increase_depth(ida, new_nodes, new_first_leaf);
+
+	ida->nodes	= new_nodes;
+	ida->first_leaf	= new_first_leaf;
+
+	return 0;
+err:
+	kgfree(sections, cur_sections * 2 * sizeof(unsigned long));
+	spin_lock_irqsave(&ida->lock, *flags);
+	return -ENOMEM;
+}
+
+/*
+ * Ganged allocation - amortize locking and tree traversal for when we've got
+ * another allocator (i.e. a percpu version) acting as a frontend to this code
+ */
+static int __ida_alloc_range_multiple(struct ida *ida, unsigned *ids,
+				      unsigned nr_ids, unsigned min_id,
+				      unsigned max_id, gfp_t gfp,
+				      unsigned long *flags)
+	__releases(&ida->lock)
+	__acquires(&ida->lock)
+{
+	unsigned i = 0, bit, bit_offset, id, ids_found = 0;
+	unsigned long *node = ida_index_to_node(ida, i);
+	int err = 0;
+
+	if (!max_id)
+		max_id = (unsigned) INT_MAX + 1;
+
+	if (min_id >= max_id)
+		return -ENOSPC;
+
+	while (ids_found < nr_ids) {
+		/*
+		 * If all bits are set in the root, no bits free and we need to
+		 * resize.
+		 */
+		while (!~*node) {
+resize:
+			if (ida->nodes - ida->first_leaf >=
+			    BITS_TO_LONGS(max_id)) {
+				err = -ENOSPC;
+				goto err;
+			}
+
+			err = __ida_resize(ida, gfp, flags);
+			if (err)
+				goto err;
+
+			i = 0;
+			node = ida_index_to_node(ida, i);
+		}
+
+		if (min_id) {
+			/*
+			 * If we're starting from a specific index, skip to that
+			 * leaf node and start looking there:
+			 */
+			bit_offset = min_id % BITS_PER_LONG;
+			i = ida->first_leaf + min_id / BITS_PER_LONG;
+
+			if (i >= ida->nodes)
+				goto resize;
+
+			while (1) {
+				node = ida_index_to_node(ida, i);
+				bit = ffz(*node >> bit_offset) + bit_offset;
+
+				/*
+				 * We might have had to go back up the tree
+				 * before we found a free bit - so skip down to
+				 * where we recurse down the tree.
+				 */
+				if (~*node && bit < BITS_PER_LONG)
+					goto found;
+
+				if (!i)
+					goto resize;
+
+				/*
+				 * Ok, no bits available in this node - go up a
+				 * level. But we have to update bit_offset so we
+				 * start searching in the parent _after_ the
+				 * node we're currently at
+				 */
+				bit_offset = (i - 1) % IDA_TREE_ARY + 1;
+				i = (i - 1) / IDA_TREE_ARY;
+			}
+		}
+
+		/*
+		 * Recurse down the tree looking for a free bit. We already
+		 * checked to make sure there _were_ free bits, but we might end
+		 * up at a leaf node we haven't allocated yet.
+		 */
+		while (1) {
+			bit = ffz(*node);
+found:
+			/*
+			 * Found a bit - if we're at a leaf node, great! We're
+			 * done:
+			 */
+			if (i >= ida->first_leaf)
+				break;
+
+			i = i * IDA_TREE_ARY + 1 + bit;
+			node = ida_index_to_node(ida, i);
+
+			/*
+			 * Recurse. But if we'd recurse to a node that hasn't
+			 * been allocated yet, resize:
+			 */
+
+			if (i >= ida->nodes)
+				goto resize;
+
+			BUG_ON(!~*node);
+		}
+
+		/*
+		 * Our leaves are contiguous, so we can calculate the id we
+		 * allocated from the node we're at and the bit we found within
+		 * that node:
+		 */
+		id = (i - ida->first_leaf) * BITS_PER_LONG + bit;
+		BUG_ON(id < min_id);
+
+		if (id >= max_id) {
+			err = -ENOSPC;
+			goto err;
+		}
+
+		ids[ids_found++] = id;
+		ida->allocated_ids++;
+
+		/*
+		 * Mark the id as allocated. If all the bits are now set in this
+		 * node, set this node's bit in the parent node - and so on up
+		 * to the root:
+		 */
+		while (1) {
+			__set_bit(bit, node);
+
+			if (~*node || !i)
+				break;
+
+			bit = (i - 1) % IDA_TREE_ARY;
+			i = (i - 1) / IDA_TREE_ARY;
+
+			node = ida_index_to_node(ida, i);
+		}
+	}
+err:
+	return ids_found ? ids_found : err;
+}
+
+/**
+ * ida_alloc_range - allocate a new id.
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, <= INT_MAX)
+ * @end: the maximum id (exclusive, <= INT_MAX + 1 or 0 for unlimited)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range [start, end). Returns -ENOSPC if no ids are
+ * available, or -ENOMEM on memory allocation failure.
+ *
+ * Returns the smallest free id >= start.
+ *
+ * Use ida_remove() to get rid of an id.
+ */
+int ida_alloc_range(struct ida *ida, unsigned int start,
+		    unsigned int end, gfp_t gfp)
+{
+	int ret;
+	unsigned id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ida->lock, flags);
+	ret = __ida_alloc_range_multiple(ida, &id, 1, start, end, gfp, &flags);
+	spin_unlock_irqrestore(&ida->lock, flags);
+
+	return ret == 1 ? id : ret;
+}
+EXPORT_SYMBOL(ida_alloc_range);
+
+static int __ida_alloc_cyclic(struct ida *ida, unsigned start, unsigned end,
+			      gfp_t gfp, unsigned long *flags)
+	__releases(&ida->lock)
+	__acquires(&ida->lock)
+{
+	int ret;
+	unsigned id;
+
+	ret = __ida_alloc_range_multiple(ida, &id, 1,
+					 max(start, ida->cur_id),
+					 end, gfp, flags);
+
+	if (ret < 0)
+		ret = __ida_alloc_range_multiple(ida, &id, 1, start,
+						 end, gfp, flags);
+	if (ret == 1) {
+		ida->cur_id = id + 1;
+		if ((ida->cur_id - start) / 2 > max(1024U, ida->allocated_ids))
+			ida->cur_id = 0;
+
+		return id;
+	}
+
+	return ret;
+}
+
+/**
+ * ida_alloc_cyclic - allocate new ids cyclically
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, <= INT_MAX)
+ * @end: the maximum id (exclusive, <= INT_MAX + 1 or 0 for unlimited)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range start <= id < end, or returns -ENOSPC.
+ * On memory allocation failure, returns -ENOMEM.
+ *
+ * Instead of returning the smallest free id, start searching from the position
+ * where the last id was allocated - i.e. it won't reuse freed ids right away.
+ *
+ * To avoid the allocated id space (and internal bitmap) becoming arbitrarily
+ * sparse, it can wrap before reaching the maximum id - if less than half of our
+ * current id space is allocated, it resets cur_id to 0
+ *
+ * But we don't want to wrap when the id space is small, so we use the maximum
+ * of (1024, allocated_ids) - see __ida_alloc_cyclic().
+ *
+ * Use ida_remove() to get rid of an id.
+ */
+int ida_alloc_cyclic(struct ida *ida, unsigned start, unsigned end, gfp_t gfp)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ida->lock, flags);
+	ret = __ida_alloc_cyclic(ida, start, end, gfp, &flags);
+	spin_unlock_irqrestore(&ida->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(ida_alloc_cyclic);
+
+/**
+ * ida_destroy - release all cached layers within an ida tree
+ * @ida:		ida handle
+ */
+void ida_destroy(struct ida *ida)
+{
+	unsigned i;
+
+	if (ida->tree[0] != &ida->inline_node)
+		kgfree(ida->tree[0], min(ida->nodes * sizeof(unsigned long),
+					 IDA_SECTION_SIZE));
+
+	for (i = 1; i < ida->sections; i++)
+		kgfree(ida->tree[i], IDA_SECTION_SIZE);
+
+	if (ida->tree != &ida->inline_section)
+		kgfree(ida->tree, roundup_pow_of_two(ida->sections) *
+		       sizeof(unsigned long *));
+}
+EXPORT_SYMBOL(ida_destroy);
+
+/**
+ * ida_init_prealloc - initialize ida handle
+ * @ida:	ida handle
+ * @prealloc:	number of ids to preallocate memory for
+ *
+ * Initialize an ida, and preallocate enough memory that ida_alloc() will never
+ * return -ENOMEM if passed max_id <= prealloc.
+ */
+int ida_init_prealloc(struct ida *ida, unsigned prealloc)
+{
+	unsigned leaves = BITS_TO_LONGS(prealloc);
+
+	memset(ida, 0, sizeof(*ida));
+
+	spin_lock_init(&ida->lock);
+
+	ida->nodes		= 1;
+	ida->first_leaf		= 0;
+	ida->sections		= 1;
+	ida->inline_section	= &ida->inline_node;
+	ida->tree		= &ida->inline_section;
+
+	if (leaves > ida->nodes - ida->first_leaf) {
+		unsigned i;
+
+		while (leaves > ida->nodes - ida->first_leaf) {
+			if (ida->nodes < IDA_NODES_PER_SECTION)
+				ida->nodes *= 2;
+			else
+				ida->nodes += IDA_NODES_PER_SECTION;
+
+			ida->first_leaf = first_leaf_from_nodes(ida->nodes);
+		}
+
+		if (ida->nodes > IDA_NODES_PER_SECTION) {
+			ida->sections = ida->nodes / IDA_NODES_PER_SECTION;
+			ida->tree = kgalloc(roundup_pow_of_two(ida->sections) *
+					    sizeof(unsigned long *),
+					    __GFP_ZERO|GFP_KERNEL);
+			if (!ida->tree)
+				return -ENOMEM;
+
+			for (i = 0; i < ida->sections; i++) {
+				ida->tree[i] = kgalloc(IDA_SECTION_SIZE,
+						       __GFP_ZERO|GFP_KERNEL);
+				if (!ida->tree[i])
+					goto err;
+			}
+		} else {
+			ida->tree[0] = kgalloc(ida->nodes * sizeof(unsigned long),
+					       __GFP_ZERO|GFP_KERNEL);
+			if (!ida->tree)
+				return -ENOMEM;
+		}
+	}
+
+	return 0;
+err:
+	ida_destroy(ida);
+	return -ENOMEM;
+
+}
+EXPORT_SYMBOL(ida_init_prealloc);
+
+/* IDR */
 
 #define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
 #define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
@@ -50,7 +643,6 @@
 static struct kmem_cache *idr_layer_cache;
 static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
 static DEFINE_PER_CPU(int, idr_preload_cnt);
-static DEFINE_SPINLOCK(simple_ida_lock);
 
 /* the maximum ID which can be allocated given idr->layers */
 static int idr_max(int layers)
@@ -870,287 +1462,3 @@ void idr_init(struct idr *idp)
 	spin_lock_init(&idp->lock);
 }
 EXPORT_SYMBOL(idr_init);
-
-
-/**
- * DOC: IDA description
- * IDA - IDR based ID allocator
- *
- * This is id allocator without id -> pointer translation.  Memory
- * usage is much lower than full blown idr because each id only
- * occupies a bit.  ida uses a custom leaf node which contains
- * IDA_BITMAP_BITS slots.
- *
- * 2007-04-25  written by Tejun Heo <htejun@gmail.com>
- */
-
-static void free_bitmap(struct ida *ida, struct ida_bitmap *bitmap)
-{
-	unsigned long flags;
-
-	if (!ida->free_bitmap) {
-		spin_lock_irqsave(&ida->idr.lock, flags);
-		if (!ida->free_bitmap) {
-			ida->free_bitmap = bitmap;
-			bitmap = NULL;
-		}
-		spin_unlock_irqrestore(&ida->idr.lock, flags);
-	}
-
-	kfree(bitmap);
-}
-
-/**
- * ida_pre_get - reserve resources for ida allocation
- * @ida:	ida handle
- * @gfp_mask:	memory allocation flag
- *
- * This function should be called prior to locking and calling the
- * following function.  It preallocates enough memory to satisfy the
- * worst possible allocation.
- *
- * If the system is REALLY out of memory this function returns %0,
- * otherwise %1.
- */
-static int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
-{
-	/* allocate idr_layers */
-	if (!__idr_pre_get(&ida->idr, gfp_mask))
-		return 0;
-
-	/* allocate free_bitmap */
-	if (!ida->free_bitmap) {
-		struct ida_bitmap *bitmap;
-
-		bitmap = kmalloc(sizeof(struct ida_bitmap), gfp_mask);
-		if (!bitmap)
-			return 0;
-
-		free_bitmap(ida, bitmap);
-	}
-
-	return 1;
-}
-
-/**
- * ida_get_new_above - allocate new ID above or equal to a start id
- * @ida:	ida handle
- * @starting_id: id to start search at
- * @p_id:	pointer to the allocated handle
- *
- * Allocate new ID above or equal to @starting_id.  It should be called
- * with any required locks.
- *
- * If memory is required, it will return %-EAGAIN, you should unlock
- * and go back to the ida_pre_get() call.  If the ida is full, it will
- * return %-ENOSPC.
- *
- * @p_id returns a value in the range @starting_id ... %0x7fffffff.
- */
-static int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
-{
-	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	struct ida_bitmap *bitmap;
-	unsigned long flags;
-	int idr_id = starting_id / IDA_BITMAP_BITS;
-	int offset = starting_id % IDA_BITMAP_BITS;
-	int t, id;
-
- restart:
-	/* get vacant slot */
-	t = idr_get_empty_slot(&ida->idr, idr_id, pa, 0, &ida->idr);
-	if (t < 0)
-		return t == -ENOMEM ? -EAGAIN : t;
-
-	if (t * IDA_BITMAP_BITS >= MAX_IDR_BIT)
-		return -ENOSPC;
-
-	if (t != idr_id)
-		offset = 0;
-	idr_id = t;
-
-	/* if bitmap isn't there, create a new one */
-	bitmap = (void *)pa[0]->ary[idr_id & IDR_MASK];
-	if (!bitmap) {
-		spin_lock_irqsave(&ida->idr.lock, flags);
-		bitmap = ida->free_bitmap;
-		ida->free_bitmap = NULL;
-		spin_unlock_irqrestore(&ida->idr.lock, flags);
-
-		if (!bitmap)
-			return -EAGAIN;
-
-		memset(bitmap, 0, sizeof(struct ida_bitmap));
-		rcu_assign_pointer(pa[0]->ary[idr_id & IDR_MASK],
-				(void *)bitmap);
-		pa[0]->count++;
-	}
-
-	/* lookup for empty slot */
-	t = find_next_zero_bit(bitmap->bitmap, IDA_BITMAP_BITS, offset);
-	if (t == IDA_BITMAP_BITS) {
-		/* no empty slot after offset, continue to the next chunk */
-		idr_id++;
-		offset = 0;
-		goto restart;
-	}
-
-	id = idr_id * IDA_BITMAP_BITS + t;
-	if (id >= MAX_IDR_BIT)
-		return -ENOSPC;
-
-	__set_bit(t, bitmap->bitmap);
-	if (++bitmap->nr_busy == IDA_BITMAP_BITS)
-		idr_mark_full(pa, idr_id);
-
-	*p_id = id;
-
-	/* Each leaf node can handle nearly a thousand slots and the
-	 * whole idea of ida is to have small memory foot print.
-	 * Throw away extra resources one by one after each successful
-	 * allocation.
-	 */
-	if (ida->idr.id_free_cnt || ida->free_bitmap) {
-		struct idr_layer *p = get_from_free_list(&ida->idr);
-		if (p)
-			kmem_cache_free(idr_layer_cache, p);
-	}
-
-	return 0;
-}
-
-static void __ida_remove(struct ida *ida, int id)
-{
-	struct idr_layer *p = ida->idr.top;
-	int shift = (ida->idr.layers - 1) * IDR_BITS;
-	int idr_id = id / IDA_BITMAP_BITS;
-	int offset = id % IDA_BITMAP_BITS;
-	int n;
-	struct ida_bitmap *bitmap;
-
-	/* clear full bits while looking up the leaf idr_layer */
-	while ((shift > 0) && p) {
-		n = (idr_id >> shift) & IDR_MASK;
-		__clear_bit(n, p->bitmap);
-		p = p->ary[n];
-		shift -= IDR_BITS;
-	}
-
-	if (p == NULL)
-		goto err;
-
-	n = idr_id & IDR_MASK;
-	__clear_bit(n, p->bitmap);
-
-	bitmap = (void *)p->ary[n];
-	if (!test_bit(offset, bitmap->bitmap))
-		goto err;
-
-	/* update bitmap and remove it if empty */
-	__clear_bit(offset, bitmap->bitmap);
-	if (--bitmap->nr_busy == 0) {
-		__set_bit(n, p->bitmap);	/* to please idr_remove() */
-		idr_remove(&ida->idr, idr_id);
-		free_bitmap(ida, bitmap);
-	}
-
-	return;
-
- err:
-	printk(KERN_WARNING
-	       "ida_remove called for id=%d which is not allocated.\n", id);
-}
-
-/**
- * ida_destroy - release all cached layers within an ida tree
- * @ida:		ida handle
- */
-void ida_destroy(struct ida *ida)
-{
-	idr_destroy(&ida->idr);
-	kfree(ida->free_bitmap);
-}
-EXPORT_SYMBOL(ida_destroy);
-
-/**
- * ida_alloc_range - get a new id.
- * @ida: the (initialized) ida.
- * @start: the minimum id (inclusive, < 0x8000000)
- * @end: the maximum id (exclusive, < 0x8000000 or 0)
- * @gfp_mask: memory allocation flags
- *
- * Allocates an id in the range start <= id < end, or returns -ENOSPC.
- * On memory allocation failure, returns -ENOMEM.
- *
- * Use ida_remove() to get rid of an id.
- */
-int ida_alloc_range(struct ida *ida, unsigned int start, unsigned int end,
-		   gfp_t gfp_mask)
-{
-	int ret, id;
-	unsigned int max;
-	unsigned long flags;
-
-	BUG_ON((int)start < 0);
-	BUG_ON((int)end < 0);
-
-	if (end == 0)
-		max = 0x80000000;
-	else {
-		BUG_ON(end < start);
-		max = end - 1;
-	}
-
-again:
-	if (!ida_pre_get(ida, gfp_mask))
-		return -ENOMEM;
-
-	spin_lock_irqsave(&simple_ida_lock, flags);
-	ret = ida_get_new_above(ida, start, &id);
-	if (!ret) {
-		if (id > max) {
-			__ida_remove(ida, id);
-			ret = -ENOSPC;
-		} else {
-			ret = id;
-		}
-	}
-	spin_unlock_irqrestore(&simple_ida_lock, flags);
-
-	if (unlikely(ret == -EAGAIN))
-		goto again;
-
-	return ret;
-}
-EXPORT_SYMBOL(ida_alloc_range);
-
-/**
- * ida_remove - remove an allocated id.
- * @ida: the (initialized) ida.
- * @id: the id returned by ida_alloc_range.
- */
-void ida_remove(struct ida *ida, unsigned int id)
-{
-	unsigned long flags;
-
-	BUG_ON((int)id < 0);
-	spin_lock_irqsave(&simple_ida_lock, flags);
-	__ida_remove(ida, id);
-	spin_unlock_irqrestore(&simple_ida_lock, flags);
-}
-EXPORT_SYMBOL(ida_remove);
-
-/**
- * ida_init - initialize ida handle
- * @ida:	ida handle
- *
- * This function is use to set up the handle (@ida) that you will pass
- * to the rest of the functions.
- */
-void ida_init(struct ida *ida)
-{
-	memset(ida, 0, sizeof(struct ida));
-	idr_init(&ida->idr);
-
-}
-EXPORT_SYMBOL(ida_init);
-- 
1.8.3.2

