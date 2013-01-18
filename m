Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3AREmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:42:36 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52455 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3AREmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:42:35 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-69-50f8d2b8ca61
Date: Fri, 18 Jan 2013 13:42:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RFC][PATCH v2] slub: Keep page and object in sync in
 slab_alloc_node()
Message-ID: <20130118044242.GA18665@lge.com>
References: <1358446258.23211.32.camel@gandalf.local.home>
 <1358447864.23211.34.camel@gandalf.local.home>
 <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com>
 <1358458996.23211.46.camel@gandalf.local.home>
 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com>
 <1358462763.23211.57.camel@gandalf.local.home>
 <1358464245.23211.62.camel@gandalf.local.home>
 <1358464837.23211.66.camel@gandalf.local.home>
 <1358468598.23211.67.camel@gandalf.local.home>
 <1358468924.23211.69.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358468924.23211.69.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Thu, Jan 17, 2013 at 07:28:44PM -0500, Steven Rostedt wrote:
> In slab_alloc_node(), after the cpu_slab is assigned, if the task is
> preempted and moves to another CPU, there's nothing keeping the page and
> object in sync. The -rt kernel crashed because page was NULL and object
> was not, and the node_match() dereferences page. Even though the crash
> happened on -rt, there's nothing that's keeping this from happening on
> mainline.
> 
> The easiest fix is to disable interrupts for the entire time from
> acquiring the current CPU cpu_slab and assigning the object and page.
> After that, it's fine to allow preemption.

How about this?

It's based on v3.8-rc3.
I'm not test this patch, yet.
Just for sharing my idea to fix a problem.

-----------------8<-----------------------
>From aaf529e347b7deb8c35dd484abc9166a5d3c0629 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Fri, 18 Jan 2013 13:10:33 +0900
Subject: [RFC PATCH] slub: change an approach of checking node id in
 slab_alloc_node()

Below description borrows from Steven's "[RFC]slub: Keep page and object
in sync in slab_alloc_node()"

In slab_alloc_node(), after the cpu_slab is assigned, if the task is
preempted and moves to another CPU, there's nothing keeping the page and
object in sync. The -rt kernel crashed because page was NULL and object
was not, and the node_match() dereferences page. Even though the crash
happened on -rt, there's nothing that's keeping this from happening on
mainline.

To fix this, I add new variable, node, to struct kmem_cache_cpu.
With it, we can safely compare current cpu slab's node with node of
allocation request without considering both preemption and irq
in fast-path of allocation.

This variable is set in slow-path, so this doesn't make much
performance degration.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 9db4825..b54dffa 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -46,6 +46,9 @@ enum stat_item {
 struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
+#ifdef CONFIG_NUMA
+	int node;
+#endif
 	struct page *page;	/* The slab from which we are allocating */
 	struct page *partial;	/* Partially allocated frozen slabs */
 #ifdef CONFIG_SLUB_STATS
diff --git a/mm/slub.c b/mm/slub.c
index ba2ca53..d4d3d07 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -272,6 +272,17 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 	*(void **)(object + s->offset) = fp;
 }
 
+static inline void set_cpuslab(struct kmem_cache_cpu *c, struct page *page)
+{
+	c->page = page;
+#ifdef CONFIG_NUMA
+	if (page)
+		c->node = page_to_nid(page);
+	else
+		c->node = NUMA_NO_NODE;
+#endif
+}
+
 /* Loop over all objects in a slab */
 #define for_each_object(__p, __s, __addr, __objects) \
 	for (__p = (__addr); __p < (__addr) + (__objects) * (__s)->size;\
@@ -1562,7 +1573,7 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 			break;
 
 		if (!object) {
-			c->page = page;
+			set_cpuslab(c, page);
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
 			available =  page->objects - page->inuse;
@@ -1993,7 +2004,7 @@ static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 	deactivate_slab(s, c->page, c->freelist);
 
 	c->tid = next_tid(c->tid);
-	c->page = NULL;
+	set_cpuslab(c, NULL);
 	c->freelist = NULL;
 }
 
@@ -2038,10 +2049,10 @@ static void flush_all(struct kmem_cache *s)
  * Check if the objects in a per cpu structure fit numa
  * locality expectations.
  */
-static inline int node_match(struct page *page, int node)
+static inline int node_match(struct kmem_cache_cpu *c, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && page_to_nid(page) != node)
+	if (node != NUMA_NO_NODE && c->node != node)
 		return 0;
 #endif
 	return 1;
@@ -2136,7 +2147,7 @@ static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
 		page->freelist = NULL;
 
 		stat(s, ALLOC_SLAB);
-		c->page = page;
+		set_cpuslab(c, page);
 		*pc = c;
 	} else
 		freelist = NULL;
@@ -2224,10 +2235,10 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		goto new_slab;
 redo:
 
-	if (unlikely(!node_match(page, node))) {
+	if (unlikely(!node_match(c, node))) {
 		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, page, c->freelist);
-		c->page = NULL;
+		set_cpuslab(c, NULL);
 		c->freelist = NULL;
 		goto new_slab;
 	}
@@ -2239,7 +2250,7 @@ redo:
 	 */
 	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
 		deactivate_slab(s, page, c->freelist);
-		c->page = NULL;
+		set_cpuslab(c, NULL);
 		c->freelist = NULL;
 		goto new_slab;
 	}
@@ -2254,7 +2265,7 @@ redo:
 	freelist = get_freelist(s, page);
 
 	if (!freelist) {
-		c->page = NULL;
+		set_cpuslab(c, NULL);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
@@ -2276,8 +2287,8 @@ load_freelist:
 new_slab:
 
 	if (c->partial) {
-		page = c->page = c->partial;
-		c->partial = page->next;
+		set_cpuslab(c, c->partial);
+		c->partial = c->partial->next;
 		stat(s, CPU_PARTIAL_ALLOC);
 		c->freelist = NULL;
 		goto redo;
@@ -2302,7 +2313,7 @@ new_slab:
 		goto new_slab;	/* Slab failed checks. Next slab needed */
 
 	deactivate_slab(s, page, get_freepointer(s, freelist));
-	c->page = NULL;
+	set_cpuslab(c, NULL);
 	c->freelist = NULL;
 	local_irq_restore(flags);
 	return freelist;
@@ -2323,7 +2334,6 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 {
 	void **object;
 	struct kmem_cache_cpu *c;
-	struct page *page;
 	unsigned long tid;
 
 	if (slab_pre_alloc_hook(s, gfpflags))
@@ -2350,8 +2360,7 @@ redo:
 	barrier();
 
 	object = c->freelist;
-	page = c->page;
-	if (unlikely(!object || !node_match(page, node)))
+	if (unlikely(!object || !node_match(c, node)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
-- 
1.7.9.5

