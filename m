Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaKRRtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:49:52 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:44085 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaKRRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:49:50 -0500
Date: Tue, 18 Nov 2014 12:49:46 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH vfs v2 1/2] lib: implement ptrset
Message-ID: <20141118174946.GA10040@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113220927.GF2598@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement set of pointers.  Pointers can be added, deleted and
iterated.  It's currently implemented as a thin rbtree wrapper making
addition and removal O(log N).  A drawback is that iteration isn't RCU
safe, which is okay for now.  This will be used to remove
inode->i_devices.

v2: In ptrset_add(), ptrset_find_slot() moved before new elem
    allocation to avoid unnecessary alloc/free and -ENOMEM reporting
    on -EEXIST cases.  Suggested by Azat Khuzhin.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Azat Khuzhin <a3at.mail@gmail.com>
---
 include/linux/ptrset.h |   74 ++++++++++++++++++++++++++++
 lib/Makefile           |    2 
 lib/ptrset.c           |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+), 1 deletion(-)

--- /dev/null
+++ b/include/linux/ptrset.h
@@ -0,0 +1,74 @@
+/*
+ * include/linux/ptrset.h - set of pointers
+ *
+ * Copyright (C) 2014		Tejun Heo, Red Hat Inc.
+ *
+ * A ptrset contains an unordered set of pointers.  Pointers can be added,
+ * deleted and iterated.  Addition and removal complexities are O(log N)
+ * where N is the total number of elements in the ptrset.
+ */
+
+#ifndef __PTRSET_H
+#define __PTRSET_H
+
+#include <linux/preempt.h>
+#include <linux/rbtree.h>
+
+struct ptrset {
+	struct rb_root		root;
+};
+
+struct ptrset_elem {
+	void			*ptr;
+	struct rb_node		node;
+};
+
+struct ptrset_iter {
+	struct ptrset_elem	*pos;
+	struct ptrset_elem	*next;
+};
+
+#define PTRSET_INITIALIZER	{ .root = RB_ROOT, }
+#define DEFINE_PTRSET(set)	struct ptrset set = PTRSET_INITIALIZER
+
+static inline void ptrset_init(struct ptrset *set)
+{
+	*set = (struct ptrset)PTRSET_INITIALIZER;
+}
+
+void ptrset_preload(gfp_t gfp);
+int __must_check ptrset_add(void *ptr, struct ptrset *set, gfp_t gfp);
+int ptrset_del(void *ptr, struct ptrset *set);
+
+/**
+ * ptrset_preload_end - end preload section started with ptrset_preload()
+ *
+ * Each ptrset_preload() should be matched with an invocation of this
+ * function.  See ptrset_preload() for details.
+ */
+static inline void ptrset_preload_end(void)
+{
+	preempt_enable();
+}
+
+/**
+ * ptrset_for_each - iterate pointers in a ptrset
+ * @ptr_cur: the cursor pointer variable (can be a pointer to any type)
+ * @set: the target ptrset
+ * @iter: pointer to struct ptrset_iter used to store iteration state
+ *
+ * Iterate @ptr_cur over all pointers in @set using @iter as the temp
+ * storage.  The order of iteration is undefined and the iterated pointers
+ * may be deleted during iteration.
+ *
+ * The caller is responsible for synchronization.  This is not RCU safe.
+ */
+#define ptrset_for_each(ptr_cur, set, iter)				\
+	rbtree_postorder_for_each_entry_safe((iter)->pos, (iter)->next,	\
+					     &(set)->root, node)	\
+		if (({	(ptr_cur) = (iter)->pos->ptr;			\
+			false; }))					\
+			;						\
+		else
+
+#endif	/* __PTRSET_H */
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -8,7 +8,7 @@ KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLA
 endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
-	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
+	 rbtree.o radix-tree.o dump_stack.o timerqueue.o ptrset.o \
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o argv_split.o \
 	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
--- /dev/null
+++ b/lib/ptrset.c
@@ -0,0 +1,129 @@
+/*
+ * lib/ptrset.c - set of pointers
+ *
+ * Copyright (C) 2014		Tejun Heo, Red Hat Inc.
+ */
+
+#include <linux/ptrset.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+
+static DEFINE_PER_CPU(struct ptrset_elem *, ptrset_preload_elem);
+
+/**
+ * ptrset_preload - preload for ptrset_add()
+ * @gfp: allocation mask to use for preloading
+ *
+ * Preload per-cpu ptrset_elem buffer for ptrset_add().  Can only be used
+ * from process context and each ptrset_preload() invocation should be
+ * matched with ptrset_preload_end().  Note that preemption is disabled
+ * while preloaded.
+ *
+ * The first ptrset_add() in the preloaded section can be treated as if it
+ * were invoked with @gfp used for preloading.  This allows using more
+ * permissive allocation masks for ptrsets protected by spinlocks.
+ */
+void ptrset_preload(gfp_t gfp)
+{
+	/*
+	 * Consuming preload buffer from non-process context breaks preload
+	 * allocation guarantee.  Disallow usage from those contexts.
+	 */
+	WARN_ON_ONCE(in_interrupt());
+	might_sleep_if(gfp & __GFP_WAIT);
+
+	preempt_disable();
+
+	if (!__this_cpu_read(ptrset_preload_elem)) {
+		struct ptrset_elem *new;
+
+		preempt_enable();
+		new = kmalloc(sizeof(*new), gfp);
+		preempt_disable();
+
+		new = __this_cpu_xchg(ptrset_preload_elem, new);
+		kfree(new);
+	}
+}
+
+static __always_inline bool ptrset_find_slot(void *ptr, struct ptrset *set,
+					     struct rb_node ***slotp,
+					     struct rb_node **parentp)
+{
+	struct rb_node **slot = &set->root.rb_node, *parent = NULL;
+
+	while (*slot) {
+		struct ptrset_elem *elem =
+			container_of(*slot, struct ptrset_elem, node);
+
+		parent = *slot;
+		if (ptr < elem->ptr) {
+			slot = &(*slot)->rb_left;
+		} else if (ptr > elem->ptr) {
+			slot = &(*slot)->rb_right;
+		} else {
+			*slotp = slot;
+			return true;
+		}
+	}
+
+	*slotp = slot;
+	if (parentp)
+		*parentp = parent;
+	return false;
+}
+
+/**
+ * ptrset_add - add a pointer to a ptrset
+ * @ptr: the pointer to add
+ * @set: the target ptrset
+ * @gfp: the allocation mask to use
+ *
+ * Allocate a ptrset_elem using @gfp, init with @ptr and add to @set.
+ * Returns 0 on success, -ENOMEM if allocation failed and -EEXIST if @ptr
+ * already exists in @set.
+ *
+ * The caller is responsible for synchronization.
+ */
+int ptrset_add(void *ptr, struct ptrset *set, gfp_t gfp)
+{
+	struct ptrset_elem *elem;
+	struct rb_node *parent, **slot;
+
+	if (ptrset_find_slot(ptr, set, &slot, &parent))
+		return -EEXIST;
+
+	elem = kmalloc(sizeof(*elem), gfp);
+	if (!elem && !in_interrupt())	/* see ptrset_preload() */
+		elem = this_cpu_xchg(ptrset_preload_elem, NULL);
+	if (!elem)
+		return -ENOMEM;
+	elem->ptr = ptr;
+
+	rb_link_node(&elem->node, parent, slot);
+	rb_insert_color(&elem->node, &set->root);
+	return 0;
+}
+
+/**
+ * ptrset_del - delete a pointer from a ptrset
+ * @ptr: the pointer to delete
+ * @set: the target ptrset
+ *
+ * Delete @ptr from @set.  Returns 0 on success, -ENOENT if @ptr is not in
+ * @set.
+ *
+ * The caller is responsible for synchronization.
+ */
+int ptrset_del(void *ptr, struct ptrset *set)
+{
+	struct rb_node **slot, *node;
+
+	if (!ptrset_find_slot(ptr, set, &slot, NULL))
+		return -ENOENT;
+
+	node = *slot;
+	rb_erase(node, &set->root);
+	kfree(container_of(node, struct ptrset_elem, node));
+	return 0;
+}
