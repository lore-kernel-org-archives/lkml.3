Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaJVP4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:56:07 -0400
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:37039 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755142AbaJVPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:55:34 -0400
Message-Id: <20141022155527.268224371@linux.com>
Date: Wed, 22 Oct 2014 10:55:21 -0500
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: [RFC 4/4] slub: Remove preemption disable/enable from fastpath
References: <20141022155517.560385718@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=slub_fastpath_remove_preempt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can now use a this_cpu_cmpxchg_double to update two 64
bit values that are the entire description of the per cpu
freelist. There is no need anymore to disable preempt.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -2261,21 +2261,15 @@ static inline void *get_freelist(struct
  * a call to the page allocator and the setup of a new slab.
  */
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			  unsigned long addr, struct kmem_cache_cpu *c)
+			  unsigned long addr)
 {
 	void *freelist;
 	struct page *page;
 	unsigned long flags;
+	struct kmem_cache_cpu *c;
 
 	local_irq_save(flags);
-#ifdef CONFIG_PREEMPT
-	/*
-	 * We may have been preempted and rescheduled on a different
-	 * cpu before disabling interrupts. Need to reload cpu area
-	 * pointer.
-	 */
 	c = this_cpu_ptr(s->cpu_slab);
-#endif
 
 	if (!c->freelist || is_end_token(c->freelist))
 		goto new_slab;
@@ -2379,7 +2373,6 @@ static __always_inline void *slab_alloc_
 		gfp_t gfpflags, int node, unsigned long addr)
 {
 	void **object;
-	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
 	if (slab_pre_alloc_hook(s, gfpflags))
@@ -2388,31 +2381,15 @@ static __always_inline void *slab_alloc_
 	s = memcg_kmem_get_cache(s, gfpflags);
 redo:
 	/*
-	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
-	 * enabled. We may switch back and forth between cpus while
-	 * reading from one cpu area. That does not matter as long
-	 * as we end up on the original cpu again when doing the cmpxchg.
-	 *
-	 * Preemption is disabled for the retrieval of the tid because that
-	 * must occur from the current processor. We cannot allow rescheduling
-	 * on a different processor between the determination of the pointer
-	 * and the retrieval of the tid.
-	 */
-	preempt_disable();
-	c = this_cpu_ptr(s->cpu_slab);
-
-	/*
 	 * The transaction ids are globally unique per cpu and per operation on
 	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
 	 * occurs on the right processor and that there was no operation on the
 	 * linked list in between.
 	 */
-	tid = c->tid;
-	preempt_enable();
-
-	object = c->freelist;
+	tid = this_cpu_read(s->cpu_slab->tid);
+	object = this_cpu_read(s->cpu_slab->freelist);
 	if (unlikely(!object || is_end_token(object) || !node_match(virt_to_head_page(object), node))) {
-		object = __slab_alloc(s, gfpflags, node, addr, c);
+		object = __slab_alloc(s, gfpflags, node, addr);
 		stat(s, ALLOC_SLOWPATH);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
@@ -2641,30 +2618,21 @@ static __always_inline void slab_free(st
 			struct page *page, void *x, unsigned long addr)
 {
 	void **object = (void *)x;
-	struct kmem_cache_cpu *c;
+	void *freelist;
 	unsigned long tid;
 
 	slab_free_hook(s, x);
 
 redo:
-	/*
-	 * Determine the currently cpus per cpu slab.
-	 * The cpu may change afterward. However that does not matter since
-	 * data is retrieved via this pointer. If we are on the same cpu
-	 * during the cmpxchg then the free will succedd.
-	 */
-	preempt_disable();
-	c = this_cpu_ptr(s->cpu_slab);
-
-	tid = c->tid;
-	preempt_enable();
+	tid = this_cpu_read(s->cpu_slab->tid);
+	freelist = this_cpu_read(s->cpu_slab->freelist);
 
-	if (likely(c->freelist && page == virt_to_head_page(c->freelist))) {
-		set_freepointer(s, object, c->freelist);
+	if (likely(freelist && page == virt_to_head_page(freelist))) {
+		set_freepointer(s, object, freelist);
 
 		if (unlikely(!this_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
-				c->freelist, tid,
+				freelist, tid,
 				object, next_tid(tid)))) {
 
 			note_cmpxchg_failure("slab_free", s, tid);

