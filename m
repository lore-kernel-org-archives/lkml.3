Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbaGRUIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:08:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59255 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbaGRUII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:08:08 -0400
Date: Fri, 18 Jul 2014 16:08:04 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH percpu/for-3.17 1/2] percpu: implement percpu_pool
Message-ID: <20140718200804.GG13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

So, I have another case where percpu allocation needs to be performed
from an atomic context (also on the IO path), so I wrote up a simple
percpu alloc cache which is filled asynchronously and replaced
blk-throttle's custom implementation with it.

I still think it's quite unlikely that we implement atomic allocation
directly in the percpu allocator; however, even if that happens
eventually, having percpu_pool instead of multiple custom mechanisms
scattered around the kernel should make it a lot easier to transition
to that.

Thanks.
------ 8< ------
>From eaaca4e64d3cce54d2b7ac5e4d5fb207290cc48f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jul 2014 16:07:14 -0400
Subject: [PATCH 1/2] percpu: implement percpu_pool

percpu allocator requires sleepable context for allocations.  Most use
cases are fine with the requirement but blk-throttle currently
implements its own asynchronous allocation mechanism to allow
initiating allocation from atomic contexts and there are expected to
be more similar use cases.

It'd be best to make percpu allocator take GFP mask like other
allocators but its entanglement with kernel virtual address management
makes it very cumbersome.  Also, percpu allocations from atomic
contexts are likely to remain highly restricted.

This patch implements a simple asynchronous allocation pool, named
percpu_pool, which can be used from any context and is refilled
automatically.  A pool is initialized with the size and alignment of
the percpu areas to serve and the low an high watermarks.  When the
number of cached areas fall below the low watermark, a work item is
kicked off to fill it up to the high mark.  A pool can be statically
defined and can be manually filled and emptied.

If we later end up implementing proper GFP support for percpu
allocator, percpu_pool usages should be easy to convert.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/percpu.h |  90 +++++++++++++++++++++++++
 mm/percpu.c            | 177 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 267 insertions(+)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 6f61b61..ab5d3ff 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/pfn.h>
 #include <linux/init.h>
+#include <linux/workqueue.h>
 
 #include <asm/percpu.h>
 
@@ -129,4 +130,93 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
+/*
+ * percpu_pool is an automatically managed percpu allocation cache which
+ * can be used to allocate percpu areas from atomic contexts.
+ */
+struct percpu_pool {
+	spinlock_t		lock;
+	size_t			elem_size;
+	size_t			elem_align;
+	int			nr_low;
+	int			nr_high;
+	int			nr;
+	bool			inhibit_fill:1;
+	void __percpu		*head;
+	struct work_struct	fill_work;
+};
+
+void __pcpu_pool_fill_workfn(struct work_struct *work);
+
+/**
+ * __PERCPU_POOL_INIT - initializer for percpu_pool
+ * @name: name of the percpu_pool being initialized
+ * @size: size of the percpu elements to be cached
+ * @align: alignment of the percpu elements to be cached
+ * @low: low watermark of the pool
+ * @high: high watermark of the pool
+ *
+ * Initializer for percpu_pool @name which serves percpu areas of @size
+ * bytes with the alignment of @align.  If the pool falls below @low, it's
+ * filled upto @high.  Note that the pool starts empty.  If not explicitly
+ * filled with percpu_pool_fill(), the first allocation will fail and
+ * trigger filling.
+ */
+#define __PERCPU_POOL_INIT(name, size, align, low, high)		\
+{									\
+	.lock			= __SPIN_LOCK_INITIALIZER(name.lock),	\
+	.elem_size		= (size),				\
+	.elem_align		= (align),				\
+	.nr_low			= (low),				\
+	.nr_high		= (high),				\
+	.fill_work		= __WORK_INITIALIZER(name.fill_work,	\
+					__pcpu_pool_fill_workfn),	\
+}
+
+/**
+ * __DEFINE_PERCPU_POOL - define a percpu_pool
+ * @name: name of the percpu_pool being defined
+ * @size: size of the percpu elements to be cached
+ * @align: alignment of the percpu elements to be cached
+ * @low: low watermark of the pool
+ * @high: high watermark of the pool
+ *
+ * Define a percpu_pool @name.  See __PERCPU_POOL_INIT().
+ */
+#define __DEFINE_PERCPU_POOL(name, size, align, low, high)		\
+	struct percpu_pool name = __PERCPU_POOL_INIT(name, size, align,	\
+						     low, high)
+
+/**
+ * PERCPU_POOL_INIT - initializer for percpu_pool
+ * @name: name of the percpu_pool being initialized
+ * @type: type of the percpu elements to be cached
+ * @low: low watermark of the pool
+ * @high: high watermark of the pool
+ *
+ * Equivalent to __PERCPU_POOL_INIT() except that the size and alignment
+ * are calculated from @type instead of being explicitly specified.
+ */
+#define PERCPU_POOL_INIT(name, type, low, high)				\
+	__PERCPU_POOL_INIT(name, sizeof(type), __alignof__(type),	\
+			   low, high)
+
+/**
+ * DEFINE_PERCPU_POOL - define a percpu_pool
+ * @name: name of the percpu_pool being defined
+ * @type: type of the percpu elements to be cached
+ * @low: low watermark of the pool
+ * @high: high watermark of the pool
+ *
+ * Equivalent to __DEFINE_PERCPU_POOL() except that the size and alignment
+ * are calculated from @type instead of being explicitly specified.
+ */
+#define DEFINE_PERCPU_POOL(name, type, low, high)			\
+	__DEFINE_PERCPU_POOL(name, sizeof(type), __alignof__(type),	\
+			     low, high)
+
+extern void percpu_pool_fill(struct percpu_pool *pool, int target_nr);
+extern void percpu_pool_empty(struct percpu_pool *pool);
+extern void __percpu *percpu_pool_alloc(struct percpu_pool *pool);
+
 #endif /* __LINUX_PERCPU_H */
diff --git a/mm/percpu.c b/mm/percpu.c
index 2139e30..c536cd0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -68,6 +68,7 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/kmemleak.h>
+#include <linux/delay.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -1965,3 +1966,179 @@ void __init percpu_init_late(void)
 		spin_unlock_irqrestore(&pcpu_lock, flags);
 	}
 }
+
+
+/*
+ * percpu_pool implementation.
+ *
+ * percpu_pool allocates percpu areas and chain them so that they can be
+ * given out in atomic contexts.  When a pool goes below its configured low
+ * watermark, its work item is queued to fill it upto the high watermark.
+ */
+
+static void __percpu **pcpu_pool_nextp(void __percpu *p)
+{
+	static int pcpu_pool_cpu = -1;
+
+	/*
+	 * @pcpu_pool_cpu is the CPU whose area is used to chain percpu
+	 * areas and can be any possible CPU.
+	 */
+	if (unlikely(pcpu_pool_cpu < 0))
+		pcpu_pool_cpu = cpumask_any(cpu_possible_mask);
+
+	return per_cpu_ptr((void __percpu * __percpu *)p, pcpu_pool_cpu);
+}
+
+/**
+ * pcpu_pool_alloc_elems - allocate percpu_areas and put them on a list
+ * @elem_size: the size of each element
+ * @elem_align: the alignment of each element
+ * @nr: the number of elements to allocate
+ * @headp: out param for the head of the allocated list
+ * @tailp: out param for the tail of the allocated list
+ *
+ * Try to allocate @nr percpu areas with @elem_size and @elem_align and put
+ * them on a list pointed to by *@headp and *@tailp.  Returns the number of
+ * successfully allocated elements which may be zero.
+ */
+static int pcpu_pool_alloc_elems(size_t elem_size, size_t elem_align, int nr,
+				 void __percpu **headp, void __percpu **tailp)
+{
+	void __percpu *head = NULL;
+	void __percpu *tail = NULL;
+	int i;
+
+	/* each elem should be able to carry a pointer to allow chaining */
+	elem_size = max_t(size_t, elem_size, sizeof(void __percpu *));
+	elem_align = max_t(size_t, elem_align, __alignof__(void __percpu *));
+
+	for (i = 0; i < nr; i++) {
+		void __percpu *p;
+
+		p = __alloc_percpu(elem_size, elem_align);
+		if (!p)
+			break;
+
+		if (!tail)
+			tail = p;
+		if (head)
+			*pcpu_pool_nextp(p) = head;
+		head = p;
+
+		cond_resched();
+	}
+
+	*headp = head;
+	*tailp = tail;
+	return i;
+}
+
+/**
+ * pcpu_pool_fill - fill a percpu_pool
+ * @pool: percpu_pool to fill
+ * @target_nr: target number of elements (0 for default)
+ *
+ * Try to fill @pool upto @target_nr elements.  If @target_nr is zero, the
+ * high watermark set during pool init is used.
+ *
+ * If @target_nr is non-zero but lower than the low watermark, automatic
+ * pool refilling is disabled until it is completely empty.  This is useful
+ * for a pool which allocates some fixed number of elements during boot but
+ * may or may not be used afterwards.  By pre-filling with the amount
+ * necessary during boot, systems which don't use it afterwards can avoid
+ * carrying around a potentially large cache of percpu areas.
+ */
+void percpu_pool_fill(struct percpu_pool *pool, int target_nr)
+{
+	void __percpu *head;
+	void __percpu *tail;
+	int nr;
+
+	target_nr = target_nr ?: pool->nr_high;
+	nr = max(target_nr - pool->nr, 0);
+	nr = pcpu_pool_alloc_elems(pool->elem_size, pool->elem_align, nr,
+				   &head, &tail);
+
+	spin_lock_irq(&pool->lock);
+	if (nr) {
+		*pcpu_pool_nextp(tail) = pool->head;
+		pool->head = head;
+		pool->nr += nr;
+	}
+	pool->inhibit_fill = target_nr < pool->nr_low;
+	spin_unlock_irq(&pool->lock);
+}
+
+/**
+ * pcpu_pool_empty - empty a percpu_pool
+ * @pool: percpu_pool to empty
+ *
+ * Empty @pool.  If @pool is not used after this function is invoked, @pool
+ * can be destroyed on completion.
+ */
+void percpu_pool_empty(struct percpu_pool *pool)
+{
+	void __percpu *head;
+	unsigned long flags;
+
+	cancel_work_sync(&pool->fill_work);
+
+	spin_lock_irqsave(&pool->lock, flags);
+	head = pool->head;
+	pool->head = NULL;
+	pool->nr = 0;
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	while (head) {
+		void __percpu *p = head;
+
+		head = *pcpu_pool_nextp(p);
+		free_percpu(p);
+	}
+}
+
+void __pcpu_pool_fill_workfn(struct work_struct *work)
+{
+	struct percpu_pool *pool = container_of(work, struct percpu_pool,
+						fill_work);
+	percpu_pool_fill(pool, 0);
+}
+
+/**
+ * percpu_pool_alloc - allocate from a percpu_pool
+ * @pool: percpu_pool to allocate from
+ *
+ * Allocate an element from @pool.  This function can be used from any
+ * context.
+ *
+ * @pool is automatically refilled if it falls below the low watermark set
+ * during pool init; however, the refilling is asynchronous and the pool
+ * may go empty before refilling is complete.
+ *
+ * Returns the pointer to the allocated percpu area on success, %NULL on
+ * failure.  The returned percpu pointer can be freed via free_percpu().
+ */
+void __percpu *percpu_pool_alloc(struct percpu_pool *pool)
+{
+	void __percpu *p;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	p = pool->head;
+	if (p) {
+		pool->head = *pcpu_pool_nextp(p);
+		*pcpu_pool_nextp(p) = NULL;
+		pool->nr--;
+	}
+
+	if (!pool->nr || (!pool->inhibit_fill && pool->nr < pool->nr_low)) {
+		pool->inhibit_fill = false;
+		schedule_work(&pool->fill_work);
+	}
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return p;
+}
-- 
1.9.3

