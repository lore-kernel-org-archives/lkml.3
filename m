Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3GFFI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:08:59 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54065 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3GFFIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:08:52 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, sfr@canb.auug.org.au, andi@firstfloor.org, oleg@redhat.com,
        mingo@redhat.com, nab@linux-iscsi.org, axboe@kernel.dk,
        Kent Overstreet <kmo@daterainc.com>,
        Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 08/10] idr: Reimplement idr on top of ida/radix trees
Date: Fri,  5 Jul 2013 22:08:19 -0700
Message-Id: <1373087301-23730-9-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old idr code was really a second radix tree implementation - we
already have one in lib/radix-tree.c.

This patch reimplements idr on top of our existing radix trees, using
our shiny new ida implementation for allocating/freeing the ids. The old
idr code was noticably slower than lib/radix-tree.c in at least some
benchmarks, so in addition to being ~500 lines less code this patch
should improve performance too.

There's one thing left unfinished in this patch - the existing
idr_preload() interface won't work for ida. Another patch on top of this
will fix idr_preload() and update existing users to the new interface.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/idr.h | 157 ++++-----
 init/main.c         |   1 -
 lib/idr.c           | 896 ++++++++++------------------------------------------
 3 files changed, 249 insertions(+), 805 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 6fc0225..85355d7 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -1,6 +1,6 @@
 /*
  * include/linux/idr.h
- * 
+ *
  * 2002-10-18  written by Jim Houston jim.houston@ccur.com
  *	Copyright (C) 2002 by Concurrent Computer Corporation
  *	Distributed under the GNU GPL license version 2.
@@ -12,10 +12,8 @@
 #ifndef __IDR_H__
 #define __IDR_H__
 
-#include <linux/types.h>
-#include <linux/bitops.h>
-#include <linux/init.h>
-#include <linux/rcupdate.h>
+#include <linux/gfp.h>
+#include <linux/radix-tree.h>
 #include <linux/spinlock_types.h>
 #include <linux/wait.h>
 
@@ -149,74 +147,42 @@ int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags);
 
 /* IDR */
 
-/*
- * We want shallower trees and thus more bits covered at each layer.  8
- * bits gives us large enough first layer for most use cases and maximum
- * tree depth of 4.  Each idr_layer is slightly larger than 2k on 64bit and
- * 1k on 32bit.
+/**
+ * DOC: idr sync
+ * idr synchronization (stolen from radix-tree.h)
+ *
+ * idr_alloc() and idr_remove() do their own locking internally - the user need
+ * not be concerned with synchronization unless there's other operations that
+ * need to be done atomically.
+ *
+ * idr_find() does no locking - it can be called locklessly using RCU, if the
+ * caller ensures calls to this function are made within rcu_read_lock()
+ * regions and does all the other appropriate RCU stuff.
  */
-#define IDR_BITS 8
-#define IDR_SIZE (1 << IDR_BITS)
-#define IDR_MASK ((1 << IDR_BITS)-1)
-
-struct idr_layer {
-	int			prefix;	/* the ID prefix of this idr_layer */
-	DECLARE_BITMAP(bitmap, IDR_SIZE); /* A zero bit means "space here" */
-	struct idr_layer __rcu	*ary[1<<IDR_BITS];
-	int			count;	/* When zero, we can release it */
-	int			layer;	/* distance from leaf */
-	struct rcu_head		rcu_head;
-};
 
 struct idr {
-	struct idr_layer __rcu	*hint;	/* the last layer allocated from */
-	struct idr_layer __rcu	*top;
-	struct idr_layer	*id_free;
-	int			layers;	/* only valid w/o concurrent changes */
-	int			id_free_cnt;
-	int			cur;	/* current pos for cyclic allocation */
-	spinlock_t		lock;
+	struct ida		ida;
+	struct radix_tree_root	ptrs;
 };
 
 #define IDR_INIT(name)							\
 {									\
-	.lock			= __SPIN_LOCK_UNLOCKED(name.lock),	\
+	.ida			= IDA_INIT(name.ida),			\
+	.ptrs			= RADIX_TREE_INIT(GFP_NOWAIT),		\
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
-/**
- * DOC: idr sync
- * idr synchronization (stolen from radix-tree.h)
- *
- * idr_find() is able to be called locklessly, using RCU. The caller must
- * ensure calls to this function are made within rcu_read_lock() regions.
- * Other readers (lock-free or otherwise) and modifications may be running
- * concurrently.
- *
- * It is still required that the caller manage the synchronization and
- * lifetimes of the items. So if RCU lock-free lookups are used, typically
- * this would mean that the items have their own locks, or are amenable to
- * lock-free access; and that the items are freed by RCU (or only freed after
- * having been deleted from the idr tree *and* a synchronize_rcu() grace
- * period).
- */
-
-/*
- * This is what we export.
- */
-
-void *idr_find_slowpath(struct idr *idp, int id);
-void idr_preload(gfp_t gfp_mask);
-int idr_alloc_range(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
-int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask);
-int idr_for_each(struct idr *idp,
+void *idr_find_next(struct idr *idr, int *nextid);
+int idr_for_each(struct idr *idr,
 		 int (*fn)(int id, void *p, void *data), void *data);
-void *idr_find_next(struct idr *idp, int *nextid);
-void *idr_replace(struct idr *idp, void *ptr, int id);
-void idr_remove(struct idr *idp, int id);
-void idr_free(struct idr *idp, int id);
-void idr_destroy(struct idr *idp);
-void idr_init(struct idr *idp);
+void *idr_replace(struct idr *idr, void *ptr, unsigned id);
+void idr_remove(struct idr *idr, unsigned id);
+int idr_alloc_range(struct idr *idr, void *ptr, unsigned start,
+		    unsigned end, gfp_t gfp);
+int idr_alloc_cyclic(struct idr *idr, void *ptr, unsigned start,
+		     unsigned end, gfp_t gfp_mask);
+void idr_destroy(struct idr *idr);
+void idr_init(struct idr *idr);
 
 static inline int idr_alloc(struct idr *idr, void *ptr, gfp_t gfp)
 {
@@ -231,7 +197,53 @@ static inline int idr_alloc(struct idr *idr, void *ptr, gfp_t gfp)
  */
 static inline void idr_preload_end(void)
 {
-	preempt_enable();
+	radix_tree_preload_end();
+}
+
+/**
+ * idr_preload - preload for idr_alloc_range()
+ * @gfp: allocation mask to use for preloading
+ *
+ * Preload per-cpu layer buffer for idr_alloc_range().  Can only be used from
+ * process context and each idr_preload() invocation should be matched with
+ * idr_preload_end().  Note that preemption is disabled while preloaded.
+ *
+ * The first idr_alloc_range() in the preloaded section can be treated as if it
+ * were invoked with @gfp_mask used for preloading.  This allows using more
+ * permissive allocation masks for idrs protected by spinlocks.
+ *
+ * For example, if idr_alloc_range() below fails, the failure can be treated as
+ * if idr_alloc_range() were called with GFP_KERNEL rather than GFP_NOWAIT.
+ *
+ *	idr_preload(GFP_KERNEL);
+ *	spin_lock(lock);
+ *
+ *	id = idr_alloc_range(idr, ptr, start, end, GFP_NOWAIT);
+ *
+ *	spin_unlock(lock);
+ *	idr_preload_end();
+ *	if (id < 0)
+ *		error;
+ */
+static inline void idr_preload(gfp_t gfp)
+{
+	might_sleep_if(gfp & __GFP_WAIT);
+
+	/* Well this is horrible, but idr_preload doesn't return errors */
+	if (radix_tree_preload(gfp))
+		preempt_disable();
+}
+
+/* radix tree can't store NULL pointers, so we have to translate...  */
+static inline void *__radix_idr_ptr(void *ptr)
+{
+	return ptr != (void *) (~0UL & ~RADIX_TREE_INDIRECT_PTR)
+		? ptr : NULL;
+}
+
+static inline void *__idr_radix_ptr(void *ptr)
+{
+	return ptr ?: (void *) (~0UL & ~RADIX_TREE_INDIRECT_PTR);
 }
 
 /**
@@ -241,24 +253,19 @@ static inline void idr_preload_end(void)
  *
  * Return the pointer given the id it has been registered with.  A %NULL
  * return indicates that @id is not valid or you passed %NULL in
- * idr_get_new().
+ * idr_alloc().
  *
  * This function can be called under rcu_read_lock(), given that the leaf
  * pointers lifetimes are correctly managed.
  */
-static inline void *idr_find(struct idr *idr, int id)
+static inline void *idr_find(struct idr *idr, unsigned id)
 {
-	struct idr_layer *hint = rcu_dereference_raw(idr->hint);
-
-	if (hint && (id & ~IDR_MASK) == hint->prefix)
-		return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
-
-	return idr_find_slowpath(idr, id);
+	return __radix_idr_ptr(radix_tree_lookup(&idr->ptrs, id));
 }
 
 /**
  * idr_for_each_entry - iterate over an idr's elements of a given type
- * @idp:     idr handle
+ * @idr:     idr handle
  * @entry:   the type * to use as cursor
  * @id:      id entry's key
  *
@@ -266,9 +273,7 @@ static inline void *idr_find(struct idr *idr, int id)
  * after normal terminatinon @entry is left with the value NULL.  This
  * is convenient for a "not found" value.
  */
-#define idr_for_each_entry(idp, entry, id)			\
-	for (id = 0; ((entry) = idr_find_next(idp, &(id))) != NULL; ++id)
-
-void __init idr_init_cache(void);
+#define idr_for_each_entry(idr, entry, id)			\
+	for (id = 0; ((entry) = idr_find_next(idr, &(id))) != NULL; ++id)
 
 #endif /* __IDR_H__ */
diff --git a/init/main.c b/init/main.c
index 9484f4b..87b5a0f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -541,7 +541,6 @@ asmlinkage void __init start_kernel(void)
 	preempt_disable();
 	if (WARN(!irqs_disabled(), "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
-	idr_init_cache();
 	perf_event_init();
 	rcu_init();
 	tick_nohz_init();
diff --git a/lib/idr.c b/lib/idr.c
index a3977aa..fc7cb1a 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -8,24 +8,10 @@
  *
  * Modified by Nadia Derbey to make it RCU safe.
  *
- * IDA completely rewritten by Kent Overstreet <koverstreet@google.com>
+ * Completely rewritten by Kent Overstreet <koverstreet@google.com>.
  *
- * Small id to pointer translation service.
- *
- * It uses a radix tree like structure as a sparse array indexed
- * by the id to obtain the pointer.  The bitmap makes allocating
- * a new id quick.
- *
- * You call it to allocate an id (an int) an associate with that id a
- * pointer or what ever, we treat it as a (void *).  You can pass this
- * id to a user for him to pass back at a later time.  You then pass
- * that id to this code and it returns your pointer.
-
- * You can release ids at any time. When all ids are released, most of
- * the memory is returned (we keep MAX_IDR_FREE) in a local pool so we
- * don't need to go to the memory "store" during an id allocate, just
- * so you don't need to be too concerned about locking and conflicts
- * with the slab allocator.
+ * id allocator (scalable/resizable bitmap, essentially), and also idr which
+ * combines ida with a radix tree to map pointers to small integers for you.
  */
 
 #include <linux/bitmap.h>
@@ -33,11 +19,10 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <linux/hardirq.h>
 #include <linux/idr.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -911,389 +896,158 @@ err:
 }
 EXPORT_SYMBOL_GPL(percpu_ida_init);
 
-/* IDR */
-
-#define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
-#define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
-
-/* Leave the possibility of an incomplete final layer */
-#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
-
-/* Number of id_layer structs to leave in free list */
-#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
-
-static struct kmem_cache *idr_layer_cache;
-static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
-static DEFINE_PER_CPU(int, idr_preload_cnt);
-
-/* the maximum ID which can be allocated given idr->layers */
-static int idr_max(int layers)
-{
-	int bits = min_t(int, layers * IDR_BITS, MAX_IDR_SHIFT);
-
-	return (1 << bits) - 1;
-}
-
-/*
- * Prefix mask for an idr_layer at @layer.  For layer 0, the prefix mask is
- * all bits except for the lower IDR_BITS.  For layer 1, 2 * IDR_BITS, and
- * so on.
+/**
+ * DOC: IDR description
+ * IDR: Maps ids (small integers) to pointers.
+ *
+ * This merely combines ida (id allocation) with a radix tree; idr_alloc()
+ * stores a pointer, and returns you a small integer by which you can refer to
+ * it.
+ *
+ * It'll give you the smallest available integer (within a specified range if
+ * you use idr_alloc_range()) - there's also idr_alloc_cyclic() if you don't
+ * want ids to be reused right away.
+ *
+ * id -> pointer mappings can be deleted with idr_remove().
  */
-static int idr_layer_prefix_mask(int layer)
-{
-	return ~idr_max(layer + 1);
-}
-
-static struct idr_layer *get_from_free_list(struct idr *idp)
-{
-	struct idr_layer *p;
-	unsigned long flags;
-
-	spin_lock_irqsave(&idp->lock, flags);
-	if ((p = idp->id_free)) {
-		idp->id_free = p->ary[0];
-		idp->id_free_cnt--;
-		p->ary[0] = NULL;
-	}
-	spin_unlock_irqrestore(&idp->lock, flags);
-	return(p);
-}
 
 /**
- * idr_layer_alloc - allocate a new idr_layer
- * @gfp_mask: allocation mask
- * @layer_idr: optional idr to allocate from
+ * idr_find_next - lookup next object of id to given id.
+ * @idr: idr handle
+ * @nextidp:  pointer to lookup key
  *
- * If @layer_idr is %NULL, directly allocate one using @gfp_mask or fetch
- * one from the per-cpu preload buffer.  If @layer_idr is not %NULL, fetch
- * an idr_layer from @idr->id_free.
+ * Returns pointer to registered object with id, which is next number to
+ * given id. After being looked up, *@nextidp will be updated for the next
+ * iteration.
  *
- * @layer_idr is to maintain backward compatibility with the old alloc
- * interface - idr_pre_get() and idr_get_new*() - and will be removed
- * together with per-pool preload buffer.
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
-static struct idr_layer *idr_layer_alloc(gfp_t gfp_mask, struct idr *layer_idr)
-{
-	struct idr_layer *new;
-
-	/* this is the old path, bypass to get_from_free_list() */
-	if (layer_idr)
-		return get_from_free_list(layer_idr);
-
-	/*
-	 * Try to allocate directly from kmem_cache.  We want to try this
-	 * before preload buffer; otherwise, non-preloading idr_alloc_range()
-	 * users will end up taking advantage of preloading ones.  As the
-	 * following is allowed to fail for preloaded cases, suppress
-	 * warning this time.
-	 */
-	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask | __GFP_NOWARN);
-	if (new)
-		return new;
-
-	/*
-	 * Try to fetch one from the per-cpu preload buffer if in process
-	 * context.  See idr_preload() for details.
-	 */
-	if (!in_interrupt()) {
-		preempt_disable();
-		new = __this_cpu_read(idr_preload_head);
-		if (new) {
-			__this_cpu_write(idr_preload_head, new->ary[0]);
-			__this_cpu_dec(idr_preload_cnt);
-			new->ary[0] = NULL;
-		}
-		preempt_enable();
-		if (new)
-			return new;
-	}
-
-	/*
-	 * Both failed.  Try kmem_cache again w/o adding __GFP_NOWARN so
-	 * that memory allocation failure warning is printed as intended.
-	 */
-	return kmem_cache_zalloc(idr_layer_cache, gfp_mask);
-}
-
-static void idr_layer_rcu_free(struct rcu_head *head)
+void *idr_find_next(struct idr *idr, int *nextidp)
 {
-	struct idr_layer *layer;
+	void **slot;
+	struct radix_tree_iter iter;
+	void *ret = NULL;
 
-	layer = container_of(head, struct idr_layer, rcu_head);
-	kmem_cache_free(idr_layer_cache, layer);
-}
+	rcu_read_lock();
 
-static inline void free_layer(struct idr *idr, struct idr_layer *p)
-{
-	if (idr->hint && idr->hint == p)
-		RCU_INIT_POINTER(idr->hint, NULL);
-	call_rcu(&p->rcu_head, idr_layer_rcu_free);
-}
-
-/* only called when idp->lock is held */
-static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
-{
-	p->ary[0] = idp->id_free;
-	idp->id_free = p;
-	idp->id_free_cnt++;
-}
+	radix_tree_for_each_slot(slot, &idr->ptrs, &iter, *nextidp) {
+		*nextidp = iter.index;
+		ret = radix_tree_deref_slot(slot);
+		break;
+	}
 
-static void move_to_free_list(struct idr *idp, struct idr_layer *p)
-{
-	unsigned long flags;
+	rcu_read_unlock();
 
-	/*
-	 * Depends on the return element being zeroed.
-	 */
-	spin_lock_irqsave(&idp->lock, flags);
-	__move_to_free_list(idp, p);
-	spin_unlock_irqrestore(&idp->lock, flags);
-}
-
-static void idr_mark_full(struct idr_layer **pa, int id)
-{
-	struct idr_layer *p = pa[0];
-	int l = 0;
-
-	__set_bit(id & IDR_MASK, p->bitmap);
-	/*
-	 * If this layer is full mark the bit in the layer above to
-	 * show that this part of the radix tree is full.  This may
-	 * complete the layer above and require walking up the radix
-	 * tree.
-	 */
-	while (bitmap_full(p->bitmap, IDR_SIZE)) {
-		if (!(p = pa[++l]))
-			break;
-		id = id >> IDR_BITS;
-		__set_bit((id & IDR_MASK), p->bitmap);
-	}
+	return __radix_idr_ptr(ret);
 }
+EXPORT_SYMBOL(idr_find_next);
 
 /**
- * sub_alloc - try to allocate an id without growing the tree depth
- * @idp: idr handle
- * @starting_id: id to start search at
- * @pa: idr_layer[MAX_IDR_LEVEL] used as backtrack buffer
- * @gfp_mask: allocation mask for idr_layer_alloc()
- * @layer_idr: optional idr passed to idr_layer_alloc()
+ * idr_for_each - iterate through all stored pointers
+ * @idr: idr handle
+ * @fn: function to be called for each pointer
+ * @data: data passed back to callback function
+ *
+ * Iterate over the pointers registered with the given idr.  The
+ * callback function will be called for each pointer currently
+ * registered, passing the id, the pointer and the data pointer passed
+ * to this function.  It is not safe to modify the idr tree while in
+ * the callback, so functions such as idr_remove are not allowed.
  *
- * Allocate an id in range [@starting_id, INT_MAX] from @idp without
- * growing its depth.  Returns
+ * We check the return of @fn each time. If it returns anything other
+ * than %0, we break out and return that value.
  *
- *  the allocated id >= 0 if successful,
- *  -EAGAIN if the tree needs to grow for allocation to succeed,
- *  -ENOSPC if the id space is exhausted,
- *  -ENOMEM if more idr_layers need to be allocated.
+ * The caller must serialize idr_for_each() vs idr_remove().
  */
-static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa,
-		     gfp_t gfp_mask, struct idr *layer_idr)
+int idr_for_each(struct idr *idr,
+		 int (*fn)(int id, void *p, void *data), void *data)
 {
-	int n, m, sh;
-	struct idr_layer *p, *new;
-	int l, id, oid;
-
-	id = *starting_id;
- restart:
-	p = idp->top;
-	l = idp->layers;
-	pa[l--] = NULL;
-	while (1) {
-		/*
-		 * We run around this while until we reach the leaf node...
-		 */
-		n = (id >> (IDR_BITS*l)) & IDR_MASK;
-		m = find_next_zero_bit(p->bitmap, IDR_SIZE, n);
-		if (m == IDR_SIZE) {
-			/* no space available go back to previous layer. */
-			l++;
-			oid = id;
-			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
-
-			/* if already at the top layer, we need to grow */
-			if (id >= 1 << (idp->layers * IDR_BITS)) {
-				*starting_id = id;
-				return -EAGAIN;
-			}
-			p = pa[l];
-			BUG_ON(!p);
+	void *p;
+	unsigned id;
+	int error = 0;
 
-			/* If we need to go up one layer, continue the
-			 * loop; otherwise, restart from the top.
-			 */
-			sh = IDR_BITS * (l + 1);
-			if (oid >> sh == id >> sh)
-				continue;
-			else
-				goto restart;
-		}
-		if (m != n) {
-			sh = IDR_BITS*l;
-			id = ((id >> sh) ^ n ^ m) << sh;
-		}
-		if ((id >= MAX_IDR_BIT) || (id < 0))
-			return -ENOSPC;
-		if (l == 0)
+	idr_for_each_entry(idr, p, id) {
+		error = fn(id, p, data);
+		if (error)
 			break;
-		/*
-		 * Create the layer below if it is missing.
-		 */
-		if (!p->ary[m]) {
-			new = idr_layer_alloc(gfp_mask, layer_idr);
-			if (!new)
-				return -ENOMEM;
-			new->layer = l-1;
-			new->prefix = id & idr_layer_prefix_mask(new->layer);
-			rcu_assign_pointer(p->ary[m], new);
-			p->count++;
-		}
-		pa[l--] = p;
-		p = p->ary[m];
 	}
 
-	pa[l] = p;
-	return id;
+	return error;
 }
+EXPORT_SYMBOL(idr_for_each);
 
-static int idr_get_empty_slot(struct idr *idp, int starting_id,
-			      struct idr_layer **pa, gfp_t gfp_mask,
-			      struct idr *layer_idr)
+/**
+ * idr_replace - replace pointer for given id
+ * @idr: idr handle
+ * @ptr: pointer you want associated with the id
+ * @id: lookup key
+ *
+ * Replace the pointer registered with an id and return the old value.
+ * A %-ENOENT return indicates that @id was not found.
+ * A %-EINVAL return indicates that @id was not within valid constraints.
+ */
+void *idr_replace(struct idr *idr, void *ptr, unsigned id)
 {
-	struct idr_layer *p, *new;
-	int layers, v, id;
+	void **slot, *old = ERR_PTR(-ENOENT);
 	unsigned long flags;
 
-	id = starting_id;
-build_up:
-	p = idp->top;
-	layers = idp->layers;
-	if (unlikely(!p)) {
-		if (!(p = idr_layer_alloc(gfp_mask, layer_idr)))
-			return -ENOMEM;
-		p->layer = 0;
-		layers = 1;
-	}
-	/*
-	 * Add a new layer to the top of the tree if the requested
-	 * id is larger than the currently allocated space.
-	 */
-	while (id > idr_max(layers)) {
-		layers++;
-		if (!p->count) {
-			/* special case: if the tree is currently empty,
-			 * then we grow the tree by moving the top node
-			 * upwards.
-			 */
-			p->layer++;
-			WARN_ON_ONCE(p->prefix);
-			continue;
-		}
-		if (!(new = idr_layer_alloc(gfp_mask, layer_idr))) {
-			/*
-			 * The allocation failed.  If we built part of
-			 * the structure tear it down.
-			 */
-			spin_lock_irqsave(&idp->lock, flags);
-			for (new = p; p && p != idp->top; new = p) {
-				p = p->ary[0];
-				new->ary[0] = NULL;
-				new->count = 0;
-				bitmap_clear(new->bitmap, 0, IDR_SIZE);
-				__move_to_free_list(idp, new);
-			}
-			spin_unlock_irqrestore(&idp->lock, flags);
-			return -ENOMEM;
-		}
-		new->ary[0] = p;
-		new->count = 1;
-		new->layer = layers-1;
-		new->prefix = id & idr_layer_prefix_mask(new->layer);
-		if (bitmap_full(p->bitmap, IDR_SIZE))
-			__set_bit(0, new->bitmap);
-		p = new;
+	rcu_read_lock();
+	spin_lock_irqsave(&idr->ida.lock, flags);
+
+	slot = radix_tree_lookup_slot(&idr->ptrs, id);
+
+	if (slot) {
+		old = radix_tree_deref_slot(slot);
+		if (old)
+			radix_tree_replace_slot(slot, __idr_radix_ptr(ptr));
 	}
-	rcu_assign_pointer(idp->top, p);
-	idp->layers = layers;
-	v = sub_alloc(idp, &id, pa, gfp_mask, layer_idr);
-	if (v == -EAGAIN)
-		goto build_up;
-	return(v);
-}
 
-/*
- * @id and @pa are from a successful allocation from idr_get_empty_slot().
- * Install the user pointer @ptr and mark the slot full.
- */
-static void idr_fill_slot(struct idr *idr, void *ptr, int id,
-			  struct idr_layer **pa)
-{
-	/* update hint used for lookup, cleared from free_layer() */
-	rcu_assign_pointer(idr->hint, pa[0]);
+	spin_unlock_irqrestore(&idr->ida.lock, flags);
+	rcu_read_unlock();
 
-	rcu_assign_pointer(pa[0]->ary[id & IDR_MASK], (struct idr_layer *)ptr);
-	pa[0]->count++;
-	idr_mark_full(pa, id);
+	return __radix_idr_ptr(old);
 }
+EXPORT_SYMBOL(idr_replace);
 
 /**
- * idr_preload - preload for idr_alloc_range()
- * @gfp_mask: allocation mask to use for preloading
- *
- * Preload per-cpu layer buffer for idr_alloc_range().  Can only be used from
- * process context and each idr_preload() invocation should be matched with
- * idr_preload_end().  Note that preemption is disabled while preloaded.
- *
- * The first idr_alloc_range() in the preloaded section can be treated as if it
- * were invoked with @gfp_mask used for preloading.  This allows using more
- * permissive allocation masks for idrs protected by spinlocks.
- *
- * For example, if idr_alloc_range() below fails, the failure can be treated as
- * if idr_alloc_range() were called with GFP_KERNEL rather than GFP_NOWAIT.
- *
- *	idr_preload(GFP_KERNEL);
- *	spin_lock(lock);
- *
- *	id = idr_alloc_range(idr, ptr, start, end, GFP_NOWAIT);
- *
- *	spin_unlock(lock);
- *	idr_preload_end();
- *	if (id < 0)
- *		error;
+ * idr_remove - remove the given id and free its slot
+ * @idr: idr handle
+ * @id: unique key
  */
-void idr_preload(gfp_t gfp_mask)
+void idr_remove(struct idr *idr, unsigned id)
 {
-	/*
-	 * Consuming preload buffer from non-process context breaks preload
-	 * allocation guarantee.  Disallow usage from those contexts.
-	 */
-	WARN_ON_ONCE(in_interrupt());
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
-	preempt_disable();
-
-	/*
-	 * idr_alloc_range() is likely to succeed w/o full idr_layer buffer and
-	 * return value from idr_alloc_range() needs to be checked for failure
-	 * anyway.  Silently give up if allocation fails.  The caller can
-	 * treat failures from idr_alloc_range() as if idr_alloc() were called
-	 * with @gfp_mask which should be enough.
-	 */
-	while (__this_cpu_read(idr_preload_cnt) < MAX_IDR_FREE) {
-		struct idr_layer *new;
-
-		preempt_enable();
-		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
-		preempt_disable();
-		if (!new)
-			break;
+	unsigned long flags;
 
-		/* link the new one to per-cpu preload list */
-		new->ary[0] = __this_cpu_read(idr_preload_head);
-		__this_cpu_write(idr_preload_head, new);
-		__this_cpu_inc(idr_preload_cnt);
+	spin_lock_irqsave(&idr->ida.lock, flags);
+
+	radix_tree_delete(&idr->ptrs, id);
+	__ida_remove(&idr->ida, id);
+
+	spin_unlock_irqrestore(&idr->ida.lock, flags);
+}
+EXPORT_SYMBOL(idr_remove);
+
+static int idr_insert(struct idr *idr, void *ptr, unsigned id,
+		      gfp_t gfp, unsigned long *flags)
+{
+	int ret = radix_tree_preload(GFP_NOWAIT);
+	if (ret) {
+		spin_unlock_irqrestore(&idr->ida.lock, *flags);
+		ret = radix_tree_preload(gfp);
+		spin_lock_irqsave(&idr->ida.lock, *flags);
+
+		if (ret) {
+			__ida_remove(&idr->ida, id);
+			return ret;
+		}
 	}
+
+	ret = radix_tree_insert(&idr->ptrs, id, __idr_radix_ptr(ptr));
+	BUG_ON(ret);
+	radix_tree_preload_end();
+	return id;
 }
-EXPORT_SYMBOL(idr_preload);
 
 /**
  * idr_alloc_range - allocate new idr entry
@@ -1301,43 +1055,34 @@ EXPORT_SYMBOL(idr_preload);
  * @ptr: pointer to be associated with the new id
  * @start: the minimum id (inclusive)
  * @end: the maximum id (exclusive, <= 0 for max)
- * @gfp_mask: memory allocation flags
+ * @gfp: memory allocation flags
  *
  * Allocate an id in [start, end) and associate it with @ptr.  If no ID is
  * available in the specified range, returns -ENOSPC.  On memory allocation
  * failure, returns -ENOMEM.
  *
- * Note that @end is treated as max when <= 0.  This is to always allow
- * using @start + N as @end as long as N is inside integer range.
- *
- * The user is responsible for exclusively synchronizing all operations
- * which may modify @idr.  However, read-only accesses such as idr_find()
- * or iteration can be performed under RCU read lock provided the user
- * destroys @ptr in RCU-safe way after removal from idr.
+ * Note that @end is treated as max when <= 0.  This is to always allow using
+ * @start + N as @end as long as N is inside integer range.
  */
-int idr_alloc_range(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
+int idr_alloc_range(struct idr *idr, void *ptr, unsigned start,
+		    unsigned end, gfp_t gfp)
 {
-	int max = end > 0 ? end - 1 : INT_MAX;	/* inclusive upper limit */
-	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	int id;
+	int ret;
+	unsigned id;
+	unsigned long flags;
 
-	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_sleep_if(gfp & __GFP_WAIT);
 
-	/* sanity checks */
-	if (WARN_ON_ONCE(start < 0))
-		return -EINVAL;
-	if (unlikely(max < start))
-		return -ENOSPC;
+	spin_lock_irqsave(&idr->ida.lock, flags);
 
-	/* allocate id */
-	id = idr_get_empty_slot(idr, start, pa, gfp_mask, NULL);
-	if (unlikely(id < 0))
-		return id;
-	if (unlikely(id > max))
-		return -ENOSPC;
+	ret = __ida_alloc_range_multiple(&idr->ida, &id, 1, start,
+					 end, gfp, &flags);
+	if (ret == 1)
+		ret = idr_insert(idr, ptr, id, gfp, &flags);
 
-	idr_fill_slot(idr, ptr, id, pa);
-	return id;
+	spin_unlock_irqrestore(&idr->ida.lock, flags);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(idr_alloc_range);
 
@@ -1349,368 +1094,63 @@ EXPORT_SYMBOL_GPL(idr_alloc_range);
  * @end: the maximum id (exclusive, <= 0 for max)
  * @gfp_mask: memory allocation flags
  *
- * Essentially the same as idr_alloc_range, but prefers to allocate progressively
- * higher ids if it can. If the "cur" counter wraps, then it will start again
- * at the "start" end of the range and allocate one that has already been used.
+ * Essentially the same as idr_alloc_range, but prefers to allocate
+ * progressively higher ids if it can. If the "cur" counter wraps, then it will
+ * start again at the "start" end of the range and allocate one that has already
+ * been used.
  */
-int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end,
-			gfp_t gfp_mask)
+int idr_alloc_cyclic(struct idr *idr, void *ptr, unsigned start,
+		    unsigned end, gfp_t gfp)
 {
-	int id;
+	int ret;
+	unsigned long flags;
 
-	id = idr_alloc_range(idr, ptr, max(start, idr->cur), end, gfp_mask);
-	if (id == -ENOSPC)
-		id = idr_alloc_range(idr, ptr, start, end, gfp_mask);
+	might_sleep_if(gfp & __GFP_WAIT);
 
-	if (likely(id >= 0))
-		idr->cur = id + 1;
-	return id;
-}
-EXPORT_SYMBOL(idr_alloc_cyclic);
+	spin_lock_irqsave(&idr->ida.lock, flags);
 
-static void idr_remove_warning(int id)
-{
-	printk(KERN_WARNING
-		"idr_remove called for id=%d which is not allocated.\n", id);
-	dump_stack();
-}
+	ret = __ida_alloc_cyclic(&idr->ida, start, end, gfp, &flags);
+	if (ret >= 0)
+		ret = idr_insert(idr, ptr, ret, gfp, &flags);
 
-static void sub_remove(struct idr *idp, int shift, int id)
-{
-	struct idr_layer *p = idp->top;
-	struct idr_layer **pa[MAX_IDR_LEVEL + 1];
-	struct idr_layer ***paa = &pa[0];
-	struct idr_layer *to_free;
-	int n;
-
-	*paa = NULL;
-	*++paa = &idp->top;
-
-	while ((shift > 0) && p) {
-		n = (id >> shift) & IDR_MASK;
-		__clear_bit(n, p->bitmap);
-		*++paa = &p->ary[n];
-		p = p->ary[n];
-		shift -= IDR_BITS;
-	}
-	n = id & IDR_MASK;
-	if (likely(p != NULL && test_bit(n, p->bitmap))) {
-		__clear_bit(n, p->bitmap);
-		rcu_assign_pointer(p->ary[n], NULL);
-		to_free = NULL;
-		while(*paa && ! --((**paa)->count)){
-			if (to_free)
-				free_layer(idp, to_free);
-			to_free = **paa;
-			**paa-- = NULL;
-		}
-		if (!*paa)
-			idp->layers = 0;
-		if (to_free)
-			free_layer(idp, to_free);
-	} else
-		idr_remove_warning(id);
-}
+	spin_unlock_irqrestore(&idr->ida.lock, flags);
 
-/**
- * idr_remove - remove the given id and free its slot
- * @idp: idr handle
- * @id: unique key
- */
-void idr_remove(struct idr *idp, int id)
-{
-	struct idr_layer *p;
-	struct idr_layer *to_free;
-
-	if (id < 0)
-		return;
-
-	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
-	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
-	    idp->top->ary[0]) {
-		/*
-		 * Single child at leftmost slot: we can shrink the tree.
-		 * This level is not needed anymore since when layers are
-		 * inserted, they are inserted at the top of the existing
-		 * tree.
-		 */
-		to_free = idp->top;
-		p = idp->top->ary[0];
-		rcu_assign_pointer(idp->top, p);
-		--idp->layers;
-		to_free->count = 0;
-		bitmap_clear(to_free->bitmap, 0, IDR_SIZE);
-		free_layer(idp, to_free);
-	}
-	while (idp->id_free_cnt >= MAX_IDR_FREE) {
-		p = get_from_free_list(idp);
-		/*
-		 * Note: we don't call the rcu callback here, since the only
-		 * layers that fall into the freelist are those that have been
-		 * preallocated.
-		 */
-		kmem_cache_free(idr_layer_cache, p);
-	}
-	return;
-}
-EXPORT_SYMBOL(idr_remove);
-
-static void __idr_remove_all(struct idr *idp)
-{
-	int n, id, max;
-	int bt_mask;
-	struct idr_layer *p;
-	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	struct idr_layer **paa = &pa[0];
-
-	n = idp->layers * IDR_BITS;
-	p = idp->top;
-	rcu_assign_pointer(idp->top, NULL);
-	max = idr_max(idp->layers);
-
-	id = 0;
-	while (id >= 0 && id <= max) {
-		while (n > IDR_BITS && p) {
-			n -= IDR_BITS;
-			*paa++ = p;
-			p = p->ary[(id >> n) & IDR_MASK];
-		}
-
-		bt_mask = id;
-		id += 1 << n;
-		/* Get the highest bit that the above add changed from 0->1. */
-		while (n < fls(id ^ bt_mask)) {
-			if (p)
-				free_layer(idp, p);
-			n += IDR_BITS;
-			p = *--paa;
-		}
-	}
-	idp->layers = 0;
+	return ret;
 }
+EXPORT_SYMBOL(idr_alloc_cyclic);
 
 /**
- * idr_destroy - release all cached layers within an idr tree
- * @idp: idr handle
+ * idr_destroy - free all memory owned by @idr
+ * @idr: idr handle
  *
- * Free all id mappings and all idp_layers.  After this function, @idp is
- * completely unused and can be freed / recycled.  The caller is
- * responsible for ensuring that no one else accesses @idp during or after
- * idr_destroy().
+ * After this function, @idr is completely unused and can be freed / recycled.
  *
  * A typical clean-up sequence for objects stored in an idr tree will use
  * idr_for_each() to free all objects, if necessay, then idr_destroy() to
- * free up the id mappings and cached idr_layers.
- */
-void idr_destroy(struct idr *idp)
-{
-	__idr_remove_all(idp);
-
-	while (idp->id_free_cnt) {
-		struct idr_layer *p = get_from_free_list(idp);
-		kmem_cache_free(idr_layer_cache, p);
-	}
-}
-EXPORT_SYMBOL(idr_destroy);
-
-void *idr_find_slowpath(struct idr *idp, int id)
-{
-	int n;
-	struct idr_layer *p;
-
-	if (id < 0)
-		return NULL;
-
-	p = rcu_dereference_raw(idp->top);
-	if (!p)
-		return NULL;
-	n = (p->layer+1) * IDR_BITS;
-
-	if (id > idr_max(p->layer + 1))
-		return NULL;
-	BUG_ON(n == 0);
-
-	while (n > 0 && p) {
-		n -= IDR_BITS;
-		BUG_ON(n != p->layer*IDR_BITS);
-		p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
-	}
-	return((void *)p);
-}
-EXPORT_SYMBOL(idr_find_slowpath);
-
-/**
- * idr_for_each - iterate through all stored pointers
- * @idp: idr handle
- * @fn: function to be called for each pointer
- * @data: data passed back to callback function
- *
- * Iterate over the pointers registered with the given idr.  The
- * callback function will be called for each pointer currently
- * registered, passing the id, the pointer and the data pointer passed
- * to this function.  It is not safe to modify the idr tree while in
- * the callback, so functions such as idr_remove are not allowed.
- *
- * We check the return of @fn each time. If it returns anything other
- * than %0, we break out and return that value.
- *
- * The caller must serialize idr_for_each() vs idr_remove().
+ * free the embedded ida and radix tree.
  */
-int idr_for_each(struct idr *idp,
-		 int (*fn)(int id, void *p, void *data), void *data)
+void idr_destroy(struct idr *idr)
 {
-	int n, id, max, error = 0;
-	struct idr_layer *p;
-	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	struct idr_layer **paa = &pa[0];
-
-	n = idp->layers * IDR_BITS;
-	p = rcu_dereference_raw(idp->top);
-	max = idr_max(idp->layers);
-
-	id = 0;
-	while (id >= 0 && id <= max) {
-		while (n > 0 && p) {
-			n -= IDR_BITS;
-			*paa++ = p;
-			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
-		}
-
-		if (p) {
-			error = fn(id, (void *)p, data);
-			if (error)
-				break;
-		}
-
-		id += 1 << n;
-		while (n < fls(id)) {
-			n += IDR_BITS;
-			p = *--paa;
-		}
-	}
-
-	return error;
-}
-EXPORT_SYMBOL(idr_for_each);
-
-/**
- * idr_find_next - lookup next object of id to given id.
- * @idp: idr handle
- * @nextidp:  pointer to lookup key
- *
- * Returns pointer to registered object with id, which is next number to
- * given id. After being looked up, *@nextidp will be updated for the next
- * iteration.
- *
- * This function can be called under rcu_read_lock(), given that the leaf
- * pointers lifetimes are correctly managed.
- */
-void *idr_find_next(struct idr *idp, int *nextidp)
-{
-	struct idr_layer *p, *pa[MAX_IDR_LEVEL + 1];
-	struct idr_layer **paa = &pa[0];
-	int id = *nextidp;
-	int n, max;
-
-	/* find first ent */
-	p = rcu_dereference_raw(idp->top);
-	if (!p)
-		return NULL;
-	n = (p->layer + 1) * IDR_BITS;
-	max = idr_max(p->layer + 1);
-
-	while (id >= 0 && id <= max) {
-		while (n > 0 && p) {
-			n -= IDR_BITS;
-			*paa++ = p;
-			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
-		}
-
-		if (p) {
-			*nextidp = id;
-			return p;
-		}
-
-		/*
-		 * Proceed to the next layer at the current level.  Unlike
-		 * idr_for_each(), @id isn't guaranteed to be aligned to
-		 * layer boundary at this point and adding 1 << n may
-		 * incorrectly skip IDs.  Make sure we jump to the
-		 * beginning of the next layer using round_up().
-		 */
-		id = round_up(id + 1, 1 << n);
-		while (n < fls(id)) {
-			n += IDR_BITS;
-			p = *--paa;
-		}
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(idr_find_next);
-
-
-/**
- * idr_replace - replace pointer for given id
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: lookup key
- *
- * Replace the pointer registered with an id and return the old value.
- * A %-ENOENT return indicates that @id was not found.
- * A %-EINVAL return indicates that @id was not within valid constraints.
- *
- * The caller must serialize with writers.
- */
-void *idr_replace(struct idr *idp, void *ptr, int id)
-{
-	int n;
-	struct idr_layer *p, *old_p;
-
-	if (id < 0)
-		return ERR_PTR(-EINVAL);
-
-	p = idp->top;
-	if (!p)
-		return ERR_PTR(-EINVAL);
-
-	n = (p->layer+1) * IDR_BITS;
-
-	if (id >= (1 << n))
-		return ERR_PTR(-EINVAL);
-
-	n -= IDR_BITS;
-	while ((n > 0) && p) {
-		p = p->ary[(id >> n) & IDR_MASK];
-		n -= IDR_BITS;
-	}
-
-	n = id & IDR_MASK;
-	if (unlikely(p == NULL || !test_bit(n, p->bitmap)))
-		return ERR_PTR(-ENOENT);
-
-	old_p = p->ary[n];
-	rcu_assign_pointer(p->ary[n], ptr);
+	void *p;
+	unsigned id;
 
-	return old_p;
-}
-EXPORT_SYMBOL(idr_replace);
+	idr_for_each_entry(idr, p, id)
+		idr_remove(idr, id);
 
-void __init idr_init_cache(void)
-{
-	idr_layer_cache = kmem_cache_create("idr_layer_cache",
-				sizeof(struct idr_layer), 0, SLAB_PANIC, NULL);
+	ida_destroy(&idr->ida);
 }
+EXPORT_SYMBOL(idr_destroy);
 
 /**
- * idr_init - initialize idr handle
- * @idp:	idr handle
+ * idr_init - initialize sparse idr handle
+ * @idr:	idr handle
  *
- * This function is use to set up the handle (@idp) that you will pass
+ * This function is use to set up the handle (@idr) that you will pass
  * to the rest of the functions.
  */
-void idr_init(struct idr *idp)
+void idr_init(struct idr *idr)
 {
-	memset(idp, 0, sizeof(struct idr));
-	spin_lock_init(&idp->lock);
+	ida_init(&idr->ida);
+	INIT_RADIX_TREE(&idr->ptrs, GFP_NOWAIT);
 }
 EXPORT_SYMBOL(idr_init);
-- 
1.8.3.2

