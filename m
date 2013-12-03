Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3LCXjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:39:06 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50493 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab3LCXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:53 -0500
Message-Id: <20131203233245.411363890@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:33 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 01/41] mm: Replace __get_cpu_var uses with this_cpu_ptr
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_mm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace places where __get_cpu_var() is used for an address calculation
with this_cpu_ptr().

Cc: akpm@linux-foundation.org
Cc: linux-mm@kvack.org
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/lib/radix-tree.c
===================================================================
--- linux.orig/lib/radix-tree.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/lib/radix-tree.c	2013-12-02 16:07:45.734746361 -0600
@@ -221,7 +221,7 @@ radix_tree_node_alloc(struct radix_tree_
 		 * succeed in getting a node here (and never reach
 		 * kmem_cache_alloc)
 		 */
-		rtp = &__get_cpu_var(radix_tree_preloads);
+		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr) {
 			ret = rtp->nodes[rtp->nr - 1];
 			rtp->nodes[rtp->nr - 1] = NULL;
@@ -277,14 +277,14 @@ static int __radix_tree_preload(gfp_t gf
 	int ret = -ENOMEM;
 
 	preempt_disable();
-	rtp = &__get_cpu_var(radix_tree_preloads);
+	rtp = this_cpu_ptr(&radix_tree_preloads);
 	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
 		preempt_enable();
 		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 		if (node == NULL)
 			goto out;
 		preempt_disable();
-		rtp = &__get_cpu_var(radix_tree_preloads);
+		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr < ARRAY_SIZE(rtp->nodes))
 			rtp->nodes[rtp->nr++] = node;
 		else
Index: linux/mm/memcontrol.c
===================================================================
--- linux.orig/mm/memcontrol.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/memcontrol.c	2013-12-02 16:07:45.734746361 -0600
@@ -2432,7 +2432,7 @@ static void drain_stock(struct memcg_sto
  */
 static void drain_local_stock(struct work_struct *dummy)
 {
-	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
+	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 }
Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/memory-failure.c	2013-12-02 16:07:45.734746361 -0600
@@ -1286,7 +1286,7 @@ static void memory_failure_work_func(str
 	unsigned long proc_flags;
 	int gotten;
 
-	mf_cpu = &__get_cpu_var(memory_failure_cpu);
+	mf_cpu = this_cpu_ptr(&memory_failure_cpu);
 	for (;;) {
 		spin_lock_irqsave(&mf_cpu->lock, proc_flags);
 		gotten = kfifo_get(&mf_cpu->fifo, &entry);
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/page-writeback.c	2013-12-02 16:07:45.734746361 -0600
@@ -1628,7 +1628,7 @@ void balance_dirty_pages_ratelimited(str
 	 * 1000+ tasks, all of them start dirtying pages at exactly the same
 	 * time, hence all honoured too large initial task->nr_dirtied_pause.
 	 */
-	p =  &__get_cpu_var(bdp_ratelimits);
+	p =  this_cpu_ptr(&bdp_ratelimits);
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		*p = 0;
 	else if (unlikely(*p >= ratelimit_pages)) {
@@ -1640,7 +1640,7 @@ void balance_dirty_pages_ratelimited(str
 	 * short-lived tasks (eg. gcc invocations in a kernel build) escaping
 	 * the dirty throttling and livelock other long-run dirtiers.
 	 */
-	p = &__get_cpu_var(dirty_throttle_leaks);
+	p = this_cpu_ptr(&dirty_throttle_leaks);
 	if (*p > 0 && current->nr_dirtied < ratelimit) {
 		unsigned long nr_pages_dirtied;
 		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
Index: linux/mm/swap.c
===================================================================
--- linux.orig/mm/swap.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/swap.c	2013-12-02 16:07:45.734746361 -0600
@@ -409,7 +409,7 @@ void rotate_reclaimable_page(struct page
 
 		page_cache_get(page);
 		local_irq_save(flags);
-		pvec = &__get_cpu_var(lru_rotate_pvecs);
+		pvec = this_cpu_ptr(&lru_rotate_pvecs);
 		if (!pagevec_add(pvec, page))
 			pagevec_move_tail(pvec);
 		local_irq_restore(flags);
Index: linux/mm/vmalloc.c
===================================================================
--- linux.orig/mm/vmalloc.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/vmalloc.c	2013-12-02 16:07:45.734746361 -0600
@@ -1488,7 +1488,7 @@ void vfree(const void *addr)
 	if (!addr)
 		return;
 	if (unlikely(in_interrupt())) {
-		struct vfree_deferred *p = &__get_cpu_var(vfree_deferred);
+		struct vfree_deferred *p = this_cpu_ptr(&vfree_deferred);
 		if (llist_add((struct llist_node *)addr, &p->list))
 			schedule_work(&p->wq);
 	} else
Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/slub.c	2013-12-02 16:07:45.734746361 -0600
@@ -2175,7 +2175,7 @@ static inline void *new_slab_objects(str
 
 	page = new_slab(s, flags, node);
 	if (page) {
-		c = __this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 		if (c->page)
 			flush_slab(s, c);
 
@@ -2395,7 +2395,7 @@ redo:
 	 * and the retrieval of the tid.
 	 */
 	preempt_disable();
-	c = __this_cpu_ptr(s->cpu_slab);
+	c = this_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * The transaction ids are globally unique per cpu and per operation on
@@ -2650,7 +2650,7 @@ redo:
 	 * during the cmpxchg then the free will succedd.
 	 */
 	preempt_disable();
-	c = __this_cpu_ptr(s->cpu_slab);
+	c = this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
 	preempt_enable();
Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c	2013-12-02 16:07:45.744746084 -0600
+++ linux/mm/vmstat.c	2013-12-02 16:07:45.734746361 -0600
@@ -502,7 +502,7 @@ static int refresh_cpu_vm_stats(void)
 			continue;
 
 		if (__this_cpu_read(p->pcp.count)) {
-			drain_zone_pages(zone, __this_cpu_ptr(&p->pcp));
+			drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
 			changes++;
 		}
 #endif

