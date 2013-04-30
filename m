Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab3D3BGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:06:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab3D3BGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:06:30 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DfMNWbEOgJYA:10 a=VwQbUJbxAAAA:8 a=yQHfaHzQg7OUe1LqdgEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367283987.30667.49.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.4.41-rt55-feat3
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 29 Apr 2013 21:06:27 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.41-rt55-feat3 feature release.

Note, I first uploaded -feat2 then realized I didn't add a compile fix by
Mike Galbraith, and then created the -feat3 with that fix.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.4-rt-features
  Head SHA1: f53b923711ce485f78b8a90843e2072f59be7595


Or to build 3.4.41-rt55-feat3 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.41.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.41-rt55.patch.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/features/patch-3.4.41-rt55-feat3.patch.xz

Broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/features/patches-3.4.41-rt55-feat3.tar.xz




Enjoy,

-- Steve


Changes from 3.4.41-rt55-feat2:

---

Mike Galbraith (1):
      hrtimer: fix hrtimer free zone build bug

Steven Rostedt (Red Hat) (1):
      Linux 3.4.41-rt55-feat3

----
 kernel/hrtimer.c     |    2 +-
 localversion-rt-feat |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---------------------------

Changes from 3.4.41-rt55 -feat1:

---

Christoph Lameter (3):
      FIX [1/2] slub: Do not dereference NULL pointer in node_match
      FIX [2/2] slub: Tid must be retrieved from the percpu area of the current processor
      slub: Use correct cpu_slab on dead cpu

Steven Rostedt (Red Hat) (1):
      Linux 3.4.41-rt55-feat2

Thomas Gleixner (2):
      mm: Enable SLUB for RT
      slub: Enable irqs for __GFP_WAIT

----
 include/linux/slub_def.h |    2 +-
 init/Kconfig             |    1 -
 localversion-rt-feat     |    2 +-
 mm/slub.c                |  144 ++++++++++++++++++++++++++++++++++------------
 4 files changed, 109 insertions(+), 40 deletions(-)
---------------------------

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2328c04..31d57a2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1036,7 +1036,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		&& hrtimer_enqueue_reprogram(timer, new_base)) {
 
 		if (wakeup
-#ifdef CONFIG_PREEMPT_RT_BASE
+#if defined(CONFIG_PREEMPT_RT_BASE) && defined(CONFIG_HIGH_RES_TIMERS)
 		    /*
 		     * Move softirq based timers away from the rbtree in
 		     * case it expired already. Otherwise we would have a
diff --git a/localversion-rt-feat b/localversion-rt-feat
index b349c49..be4ad0c 100644
--- a/localversion-rt-feat
+++ b/localversion-rt-feat
@@ -1 +1 @@
--feat2
+-feat3

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index c2f8c8b..f0a69f5 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -55,7 +55,7 @@ struct kmem_cache_cpu {
 };
 
 struct kmem_cache_node {
-	spinlock_t list_lock;	/* Protect partial list and nr_partial */
+	raw_spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
diff --git a/init/Kconfig b/init/Kconfig
index 87afda5..5390b4b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1266,7 +1266,6 @@ config SLAB
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
-	depends on !PREEMPT_RT_FULL
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
 	   instead of managing queues of cached objects (SLAB approach).
diff --git a/localversion-rt-feat b/localversion-rt-feat
index 14ee171..b349c49 100644
--- a/localversion-rt-feat
+++ b/localversion-rt-feat
@@ -1 +1 @@
--feat1
+-feat2
diff --git a/mm/slub.c b/mm/slub.c
index 71de9b5..bdb7f3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1266,6 +1266,12 @@ static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
 
 #endif /* CONFIG_SLUB_DEBUG */
 
+struct slub_free_list {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+static DEFINE_PER_CPU(struct slub_free_list, slub_free_list);
+
 /*
  * Slab allocation and freeing
  */
@@ -1287,10 +1293,15 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	struct page *page;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
+	bool enableirqs;
 
 	flags &= gfp_allowed_mask;
 
-	if (flags & __GFP_WAIT)
+	enableirqs = (flags & __GFP_WAIT) != 0;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	enableirqs |= system_state == SYSTEM_RUNNING;
+#endif
+	if (enableirqs)
 		local_irq_enable();
 
 	flags |= s->allocflags;
@@ -1314,7 +1325,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			stat(s, ORDER_FALLBACK);
 	}
 
-	if (flags & __GFP_WAIT)
+	if (enableirqs)
 		local_irq_disable();
 
 	if (!page)
@@ -1420,6 +1431,16 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	__free_pages(page, order);
 }
 
+static void free_delayed(struct kmem_cache *s, struct list_head *h)
+{
+	while(!list_empty(h)) {
+		struct page *page = list_first_entry(h, struct page, lru);
+
+		list_del(&page->lru);
+		__free_slab(s, page);
+	}
+}
+
 #define need_reserve_slab_rcu						\
 	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
 
@@ -1454,6 +1475,12 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 		}
 
 		call_rcu(head, rcu_free_slab);
+	} else if (irqs_disabled()) {
+		struct slub_free_list *f = &__get_cpu_var(slub_free_list);
+
+		raw_spin_lock(&f->lock);
+		list_add(&page->lru, &f->list);
+		raw_spin_unlock(&f->lock);
 	} else
 		__free_slab(s, page);
 }
@@ -1553,7 +1580,7 @@ static void *get_partial_node(struct kmem_cache *s,
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	spin_lock(&n->list_lock);
+	raw_spin_lock(&n->list_lock);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
 		void *t = acquire_slab(s, n, page, object == NULL);
 		int available;
@@ -1575,7 +1602,7 @@ static void *get_partial_node(struct kmem_cache *s,
 			break;
 
 	}
-	spin_unlock(&n->list_lock);
+	raw_spin_unlock(&n->list_lock);
 	return object;
 }
 
@@ -1824,7 +1851,7 @@ redo:
 			 * that acquire_slab() will see a slab page that
 			 * is frozen
 			 */
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 	} else {
 		m = M_FULL;
@@ -1835,7 +1862,7 @@ redo:
 			 * slabs from diagnostic functions will not see
 			 * any frozen slabs.
 			 */
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 	}
 
@@ -1870,7 +1897,7 @@ redo:
 		goto redo;
 
 	if (lock)
-		spin_unlock(&n->list_lock);
+		raw_spin_unlock(&n->list_lock);
 
 	if (m == M_FREE) {
 		stat(s, DEACTIVATE_EMPTY);
@@ -1879,11 +1906,15 @@ redo:
 	}
 }
 
-/* Unfreeze all the cpu partial slabs */
-static void unfreeze_partials(struct kmem_cache *s)
+/*
+ * Unfreeze all the cpu partial slabs.
+ *
+ * This function must be called with interrupt disabled.
+ */
+static void unfreeze_partials(struct kmem_cache *s,
+		struct kmem_cache_cpu *c)
 {
 	struct kmem_cache_node *n = NULL;
-	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
 	struct page *page, *discard_page = NULL;
 
 	while ((page = c->partial)) {
@@ -1915,10 +1946,10 @@ static void unfreeze_partials(struct kmem_cache *s)
 				m = M_PARTIAL;
 				if (n != n2) {
 					if (n)
-						spin_unlock(&n->list_lock);
+						raw_spin_unlock(&n->list_lock);
 
 					n = n2;
-					spin_lock(&n->list_lock);
+					raw_spin_lock(&n->list_lock);
 				}
 			}
 
@@ -1947,7 +1978,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 	}
 
 	if (n)
-		spin_unlock(&n->list_lock);
+		raw_spin_unlock(&n->list_lock);
 
 	while (discard_page) {
 		page = discard_page;
@@ -1968,7 +1999,7 @@ static void unfreeze_partials(struct kmem_cache *s)
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
  */
-int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 {
 	struct page *oldpage;
 	int pages;
@@ -1983,14 +2014,21 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
 			if (drain && pobjects > s->cpu_partial) {
+				LIST_HEAD(tofree);
+				struct slub_free_list *f;
 				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
 				local_irq_save(flags);
-				unfreeze_partials(s);
+				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+				f = &__get_cpu_var(slub_free_list);
+				raw_spin_lock(&f->lock);
+				list_splice_init(&f->list, &tofree);
+				raw_spin_unlock(&f->lock);
 				local_irq_restore(flags);
+				free_delayed(s, &tofree);
 				pobjects = 0;
 				pages = 0;
 				stat(s, CPU_PARTIAL_DRAIN);
@@ -2027,7 +2065,7 @@ static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 		if (c->page)
 			flush_slab(s, c);
 
-		unfreeze_partials(s);
+		unfreeze_partials(s, c);
 	}
 }
 
@@ -2048,7 +2086,22 @@ static bool has_cpu_slab(int cpu, void *info)
 
 static void flush_all(struct kmem_cache *s)
 {
+	LIST_HEAD(tofree);
+	int cpu;
+
 	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
+	for_each_online_cpu(cpu) {
+		struct slub_free_list *f;
+
+		if (!has_cpu_slab(cpu, s))
+			continue;
+
+		f = &per_cpu(slub_free_list, cpu);
+		raw_spin_lock_irq(&f->lock);
+		list_splice_init(&f->list, &tofree);
+		raw_spin_unlock_irq(&f->lock);
+		free_delayed(s, &tofree);
+	}
 }
 
 /*
@@ -2058,7 +2111,7 @@ static void flush_all(struct kmem_cache *s)
 static inline int node_match(struct kmem_cache_cpu *c, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && c->node != node)
+	if (!c->page || (node != NUMA_NO_NODE && c->node != node))
 		return 0;
 #endif
 	return 1;
@@ -2076,10 +2129,10 @@ static unsigned long count_partial(struct kmem_cache_node *n,
 	unsigned long x = 0;
 	struct page *page;
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	raw_spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry(page, &n->partial, lru)
 		x += get_count(page);
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
 
@@ -2206,6 +2259,8 @@ static inline void *get_freelist(struct kmem_cache *s, struct page *page)
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
+	struct slub_free_list *f;
+	LIST_HEAD(tofree);
 	void **object;
 	unsigned long flags;
 
@@ -2248,7 +2303,13 @@ redo:
 load_freelist:
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);
+out:
+	f = &__get_cpu_var(slub_free_list);
+	raw_spin_lock(&f->lock);
+	list_splice_init(&f->list, &tofree);
+	raw_spin_unlock(&f->lock);
 	local_irq_restore(flags);
+	free_delayed(s, &tofree);
 	return object;
 
 new_slab:
@@ -2273,8 +2334,7 @@ new_slab:
 			if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 				slab_out_of_memory(s, gfpflags, node);
 
-			local_irq_restore(flags);
-			return NULL;
+			goto out;
 		}
 	}
 
@@ -2288,8 +2348,7 @@ new_slab:
 	c->freelist = get_freepointer(s, object);
 	deactivate_slab(s, c);
 	c->node = NUMA_NO_NODE;
-	local_irq_restore(flags);
-	return object;
+	goto out;
 }
 
 /*
@@ -2313,13 +2372,18 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 		return NULL;
 
 redo:
-
 	/*
 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
 	 * enabled. We may switch back and forth between cpus while
 	 * reading from one cpu area. That does not matter as long
 	 * as we end up on the original cpu again when doing the cmpxchg.
+	 *
+	 * Preemption is disabled for the retrieval of the tid because that
+	 * must occur from the current processor. We cannot allow rescheduling
+	 * on a different processor between the determination of the pointer
+	 * and the retrieval of the tid.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	/*
@@ -2329,7 +2393,7 @@ redo:
 	 * linked list in between.
 	 */
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	object = c->freelist;
 	if (unlikely(!object || !node_match(c, node)))
@@ -2479,7 +2543,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 				 * Otherwise the list_lock will synchronize with
 				 * other processors updating the list of slabs.
 				 */
-				spin_lock_irqsave(&n->list_lock, flags);
+				raw_spin_lock_irqsave(&n->list_lock, flags);
 
 			}
 		}
@@ -2529,7 +2593,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return;
 
 slab_empty:
@@ -2543,7 +2607,7 @@ slab_empty:
 		/* Slab must be on the full list */
 		remove_full(s, page);
 
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 }
@@ -2575,10 +2639,11 @@ redo:
 	 * data is retrieved via this pointer. If we are on the same cpu
 	 * during the cmpxchg then the free will succedd.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
@@ -2772,7 +2837,7 @@ static void
 init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 {
 	n->nr_partial = 0;
-	spin_lock_init(&n->list_lock);
+	raw_spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
@@ -3515,7 +3580,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		for (i = 0; i < objects; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
 
-		spin_lock_irqsave(&n->list_lock, flags);
+		raw_spin_lock_irqsave(&n->list_lock, flags);
 
 		/*
 		 * Build lists indexed by the items in use in each slab.
@@ -3536,7 +3601,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		for (i = objects - 1; i > 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		raw_spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
 		list_for_each_entry_safe(page, t, slabs_by_inuse, lru)
@@ -3702,10 +3767,15 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 	struct kmem_cache *temp_kmem_cache;
-	int order;
+	int order, cpu;
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
 
+	for_each_possible_cpu(cpu) {
+		raw_spin_lock_init(&per_cpu(slub_free_list, cpu).lock);
+		INIT_LIST_HEAD(&per_cpu(slub_free_list, cpu).list);
+	}
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
@@ -4129,7 +4199,7 @@ static int validate_slab_node(struct kmem_cache *s,
 	struct page *page;
 	unsigned long flags;
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	raw_spin_lock_irqsave(&n->list_lock, flags);
 
 	list_for_each_entry(page, &n->partial, lru) {
 		validate_slab_slab(s, page, map);
@@ -4152,7 +4222,7 @@ static int validate_slab_node(struct kmem_cache *s,
 			atomic_long_read(&n->nr_slabs));
 
 out:
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return count;
 }
 
@@ -4342,12 +4412,12 @@ static int list_locations(struct kmem_cache *s, char *buf,
 		if (!atomic_long_read(&n->nr_slabs))
 			continue;
 
-		spin_lock_irqsave(&n->list_lock, flags);
+		raw_spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->partial, lru)
 			process_slab(&t, s, page, alloc, map);
 		list_for_each_entry(page, &n->full, lru)
 			process_slab(&t, s, page, alloc, map);
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
 	for (i = 0; i < t.count; i++) {


