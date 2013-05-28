Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab3E1S3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:29:41 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:54709 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440Ab3E1S3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:29:39 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 14:29:39 EDT
Date: Tue, 28 May 2013 18:24:15 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <alpine.DEB.2.02.1305281121420.1627@gentwo.org>
Message-ID: <0000013eec62261a-77052f34-f1cb-41b2-ae90-7575a2d0472c-000000@email.amazonses.com>
References: <1364010673.6345.156.camel@gandalf.local.home> <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com> <1364227073.6345.182.camel@gandalf.local.home> <1364228039.6345.183.camel@gandalf.local.home>
 <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com> <1364234613.6345.184.camel@gandalf.local.home> <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com> <1364236355.6345.185.camel@gandalf.local.home>
 <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com> <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <1369751967.15552.12.camel@gandalf.local.home> <alpine.DEB.2.02.1305281121420.1627@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.28-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just ran some quick tests and the following seems to work.

Critical portions that need additional review (Joonsoo?) are the
modifications to get_partialinode() and __slab_free().


Subject: slub: Make cpu partial slab support configurable V2

cpu partial support can introduce level of indeterminism that is not wanted
in certain context (like a realtime kernel). Make it configurable.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/slub_def.h
===================================================================
--- linux.orig/include/linux/slub_def.h	2013-05-20 15:21:26.925704505 -0500
+++ linux/include/linux/slub_def.h	2013-05-20 15:27:40.827613445 -0500
@@ -47,12 +47,24 @@ struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *partial;	/* Partially allocated frozen slabs */
+#endif
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
 };

+static inline struct page *kmem_cache_cpu_partial_pages
+			(struct kmem_cache_cpu *c)
+{
+#ifdef CONFIG_SLUB_CPU_PARTIAL
+	return c->partial;
+#else
+	return NULL;
+#endif
+}
+
 /*
  * Word size structure that can be atomically updated or read and that
  * contains both the order and the number of objects that a slab of the
@@ -73,7 +85,9 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int object_size;	/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	int cpu_partial;	/* Number of per cpu partial objects to keep around */
+#endif
 	struct kmem_cache_order_objects oo;

 	/* Allocation and freeing of slabs */
@@ -104,6 +118,15 @@ struct kmem_cache {
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };

+static inline int kmem_cache_cpu_partial(struct kmem_cache *s)
+{
+#ifdef CONFIG_SLUB_CPU_PARTIAL
+	return s->cpu_partial;
+#else
+	return 0;
+#endif
+}
+
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-05-20 15:21:26.925704505 -0500
+++ linux/mm/slub.c	2013-05-20 15:38:00.681437630 -0500
@@ -1530,7 +1530,9 @@ static inline void *acquire_slab(struct
 	return freelist;
 }

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
+#endif
 static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);

 /*
@@ -1570,10 +1572,15 @@ static void *get_partial_node(struct kme
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
 		} else {
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 			put_cpu_partial(s, page, 0);
 			stat(s, CPU_PARTIAL_NODE);
+#else
+			BUG();
+#endif
 		}
-		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
+		if (kmem_cache_debug(s) ||
+			       available > kmem_cache_cpu_partial(s) / 2)
 			break;

 	}
@@ -1874,6 +1881,7 @@ redo:
 	}
 }

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 /*
  * Unfreeze all the cpu partial slabs.
  *
@@ -1988,6 +1996,7 @@ static void put_cpu_partial(struct kmem_

 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
 }
+#endif

 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
@@ -2012,7 +2021,9 @@ static inline void __flush_cpu_slab(stru
 		if (c->page)
 			flush_slab(s, c);

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 		unfreeze_partials(s, c);
+#endif
 	}
 }

@@ -2028,7 +2039,7 @@ static bool has_cpu_slab(int cpu, void *
 	struct kmem_cache *s = info;
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);

-	return c->page || c->partial;
+	return c->page || kmem_cache_cpu_partial_pages(c);
 }

 static void flush_all(struct kmem_cache *s)
@@ -2224,6 +2235,7 @@ static void *__slab_alloc(struct kmem_ca
 	page = c->page;
 	if (!page)
 		goto new_slab;
+
 redo:

 	if (unlikely(!node_match(page, node))) {
@@ -2277,10 +2289,12 @@ load_freelist:

 new_slab:

-	if (c->partial) {
+	if (kmem_cache_cpu_partial_pages(c)) {
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 		page = c->page = c->partial;
 		c->partial = page->next;
 		stat(s, CPU_PARTIAL_ALLOC);
+#endif
 		c->freelist = NULL;
 		goto redo;
 	}
@@ -2495,6 +2509,7 @@ static void __slab_free(struct kmem_cach
 		new.inuse--;
 		if ((!new.inuse || !prior) && !was_frozen) {

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 			if (!kmem_cache_debug(s) && !prior)

 				/*
@@ -2503,7 +2518,9 @@ static void __slab_free(struct kmem_cach
 				 */
 				new.frozen = 1;

-			else { /* Needs to be taken off a list */
+			else
+#endif
+		       		{ /* Needs to be taken off a list */

 	                        n = get_node(s, page_to_nid(page));
 				/*
@@ -2525,6 +2542,7 @@ static void __slab_free(struct kmem_cach
 		"__slab_free"));

 	if (likely(!n)) {
+#ifdef CONFIG_SLUB_CPU_PARTIAL

 		/*
 		 * If we just froze the page then put it onto the
@@ -2534,6 +2552,7 @@ static void __slab_free(struct kmem_cach
 			put_cpu_partial(s, page, 1);
 			stat(s, CPU_PARTIAL_FREE);
 		}
+#endif
 		/*
 		 * The list lock was not taken therefore no list
 		 * activity can be necessary.
@@ -3041,7 +3060,7 @@ static int kmem_cache_open(struct kmem_c
 	 * list to avoid pounding the page allocator excessively.
 	 */
 	set_min_partial(s, ilog2(s->size) / 2);
-
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	/*
 	 * cpu_partial determined the maximum number of objects kept in the
 	 * per cpu partial lists of a processor.
@@ -3069,6 +3088,7 @@ static int kmem_cache_open(struct kmem_c
 		s->cpu_partial = 13;
 	else
 		s->cpu_partial = 30;
+#endif

 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -4283,14 +4303,15 @@ static ssize_t show_slab_objects(struct
 			total += x;
 			nodes[node] += x;

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 			page = ACCESS_ONCE(c->partial);
 			if (page) {
 				x = page->pobjects;
 				total += x;
 				nodes[node] += x;
 			}
-
 			per_cpu[node]++;
+#endif
 		}
 	}

@@ -4442,6 +4463,7 @@ static ssize_t min_partial_store(struct
 }
 SLAB_ATTR(min_partial);

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%u\n", s->cpu_partial);
@@ -4464,6 +4486,7 @@ static ssize_t cpu_partial_store(struct
 	return length;
 }
 SLAB_ATTR(cpu_partial);
+#endif

 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
@@ -4503,6 +4526,7 @@ static ssize_t objects_partial_show(stru
 }
 SLAB_ATTR_RO(objects_partial);

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 {
 	int objects = 0;
@@ -4533,6 +4557,7 @@ static ssize_t slabs_cpu_partial_show(st
 	return len + sprintf(buf + len, "\n");
 }
 SLAB_ATTR_RO(slabs_cpu_partial);
+#endif

 static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
 {
@@ -4856,11 +4881,13 @@ STAT_ATTR(DEACTIVATE_BYPASS, deactivate_
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
 STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
 STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
 STAT_ATTR(CPU_PARTIAL_NODE, cpu_partial_node);
 STAT_ATTR(CPU_PARTIAL_DRAIN, cpu_partial_drain);
 #endif
+#endif

 static struct attribute *slab_attrs[] = {
 	&slab_size_attr.attr,
@@ -4868,7 +4895,9 @@ static struct attribute *slab_attrs[] =
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
 	&min_partial_attr.attr,
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	&cpu_partial_attr.attr,
+#endif
 	&objects_attr.attr,
 	&objects_partial_attr.attr,
 	&partial_attr.attr,
@@ -4881,7 +4910,9 @@ static struct attribute *slab_attrs[] =
 	&destroy_by_rcu_attr.attr,
 	&shrink_attr.attr,
 	&reserved_attr.attr,
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	&slabs_cpu_partial_attr.attr,
+#endif
 #ifdef CONFIG_SLUB_DEBUG
 	&total_objects_attr.attr,
 	&slabs_attr.attr,
@@ -4923,11 +4954,13 @@ static struct attribute *slab_attrs[] =
 	&order_fallback_attr.attr,
 	&cmpxchg_double_fail_attr.attr,
 	&cmpxchg_double_cpu_fail_attr.attr,
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	&cpu_partial_alloc_attr.attr,
 	&cpu_partial_free_attr.attr,
 	&cpu_partial_node_attr.attr,
 	&cpu_partial_drain_attr.attr,
 #endif
+#endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,
 #endif
Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig	2013-05-20 15:21:26.925704505 -0500
+++ linux/init/Kconfig	2013-05-20 15:21:26.921704441 -0500
@@ -1558,6 +1558,17 @@ config SLOB

 endchoice

+config SLUB_CPU_PARTIAL
+	default y
+	depends on SLUB
+	bool "SLUB per cpu partial cache"
+	help
+	  Per cpu partial caches accellerate objects allocation and freeing
+	  that is local to a processor at the price of more indeterminism
+	  in the latency of the free. On overflow these caches will be cleared
+	  which requires the taking of locks that may cause latency spikes.
+	  Typically one would choose no for a realtime system.
+
 config MMAP_ALLOW_UNINITIALIZED
 	bool "Allow mmapped anonymous memory to be uninitialized"
 	depends on EXPERT && !MMU
