Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab3FCUlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:41:12 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:60836 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757089Ab3FCUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:41:10 -0400
Date: Mon, 3 Jun 2013 20:41:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <CAAmzW4M8rX9WGo_FYeyBQ8=Ht-mRnQz1TGhLfbFuKhm3r8grGA@mail.gmail.com>
Message-ID: <0000013f0bc59d82-3a33091a-f21f-4ba1-bd7a-2db7c54067d9-000000@email.amazonses.com>
References: <1364010673.6345.156.camel@gandalf.local.home> <1364227073.6345.182.camel@gandalf.local.home> <1364228039.6345.183.camel@gandalf.local.home> <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com>
 <1364234613.6345.184.camel@gandalf.local.home> <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com> <1364236355.6345.185.camel@gandalf.local.home> <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home>
 <20130327061351.GB17125@lge.com> <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com> <1369751967.15552.12.camel@gandalf.local.home> <alpine.DEB.2.02.1305281121420.1627@gentwo.org>
 <0000013eec62261a-77052f34-f1cb-41b2-ae90-7575a2d0472c-000000@email.amazonses.com> <CAAmzW4M8rX9WGo_FYeyBQ8=Ht-mRnQz1TGhLfbFuKhm3r8grGA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.03-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, JoonSoo Kim wrote:

> But, this modification adds lots of "#ifdef" and makes code less clean.
> How about *not* removing struct page *partial in struct kmem_cache_cpu?
> This introduces memory overhead and makes code bigger
> for !CONFIG_SLUB_CPU_PARTIAL, but, this will help to make clean code
> and we will maintain code easily.

ok.

Subject: slub: Make cpu partial slab support configurable V2

cpu partial support can introduce level of indeterminism that is not wanted
in certain context (like a realtime kernel). Make it configurable.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/slub_def.h
===================================================================
--- linux.orig/include/linux/slub_def.h	2013-06-03 14:28:57.954239479 -0500
+++ linux/include/linux/slub_def.h	2013-06-03 14:28:57.950239416 -0500
@@ -73,7 +73,9 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int object_size;	/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	int cpu_partial;	/* Number of per cpu partial objects to keep around */
+#endif
 	struct kmem_cache_order_objects oo;

 	/* Allocation and freeing of slabs */
@@ -104,6 +106,15 @@ struct kmem_cache {
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
--- linux.orig/mm/slub.c	2013-06-03 14:28:57.954239479 -0500
+++ linux/mm/slub.c	2013-06-03 14:28:57.950239416 -0500
@@ -1573,7 +1573,8 @@ static void *get_partial_node(struct kme
 			put_cpu_partial(s, page, 0);
 			stat(s, CPU_PARTIAL_NODE);
 		}
-		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
+		if (kmem_cache_debug(s) ||
+			       available > kmem_cache_cpu_partial(s) / 2)
 			break;

 	}
@@ -1884,6 +1885,7 @@ redo:
 static void unfreeze_partials(struct kmem_cache *s,
 		struct kmem_cache_cpu *c)
 {
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct page *page, *discard_page = NULL;

@@ -1938,6 +1940,7 @@ static void unfreeze_partials(struct kme
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
+#endif
 }

 /*
@@ -1951,6 +1954,7 @@ static void unfreeze_partials(struct kme
  */
 static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 {
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *oldpage;
 	int pages;
 	int pobjects;
@@ -1987,6 +1991,7 @@ static void put_cpu_partial(struct kmem_
 		page->next = oldpage;

 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
+#endif
 }

 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
@@ -2495,6 +2500,7 @@ static void __slab_free(struct kmem_cach
 		new.inuse--;
 		if ((!new.inuse || !prior) && !was_frozen) {

+#ifdef CONFIG_SLUB_CPU_PARTIAL
 			if (!kmem_cache_debug(s) && !prior)

 				/*
@@ -2503,7 +2509,9 @@ static void __slab_free(struct kmem_cach
 				 */
 				new.frozen = 1;

-			else { /* Needs to be taken off a list */
+			else
+#endif
+		       		{ /* Needs to be taken off a list */

 	                        n = get_node(s, page_to_nid(page));
 				/*
@@ -2525,6 +2533,7 @@ static void __slab_free(struct kmem_cach
 		"__slab_free"));

 	if (likely(!n)) {
+#ifdef CONFIG_SLUB_CPU_PARTIAL

 		/*
 		 * If we just froze the page then put it onto the
@@ -2534,6 +2543,7 @@ static void __slab_free(struct kmem_cach
 			put_cpu_partial(s, page, 1);
 			stat(s, CPU_PARTIAL_FREE);
 		}
+#endif
 		/*
 		 * The list lock was not taken therefore no list
 		 * activity can be necessary.
@@ -3041,7 +3051,7 @@ static int kmem_cache_open(struct kmem_c
 	 * list to avoid pounding the page allocator excessively.
 	 */
 	set_min_partial(s, ilog2(s->size) / 2);
-
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	/*
 	 * cpu_partial determined the maximum number of objects kept in the
 	 * per cpu partial lists of a processor.
@@ -3069,6 +3079,7 @@ static int kmem_cache_open(struct kmem_c
 		s->cpu_partial = 13;
 	else
 		s->cpu_partial = 30;
+#endif

 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -4424,7 +4435,7 @@ SLAB_ATTR(order);

 static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%lu\n", s->min_partial);
+	return sprintf(buf, "%u\n", kmem_cache_cpu_partial(s));
 }

 static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
@@ -4444,7 +4455,7 @@ SLAB_ATTR(min_partial);

 static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->cpu_partial);
+	return sprintf(buf, "%u\n", kmem_cache_cpu_partial(s));
 }

 static ssize_t cpu_partial_store(struct kmem_cache *s, const char *buf,
@@ -4458,10 +4469,13 @@ static ssize_t cpu_partial_store(struct
 		return err;
 	if (objects && kmem_cache_debug(s))
 		return -EINVAL;
-
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	s->cpu_partial = objects;
 	flush_all(s);
 	return length;
+#else
+	return -ENOSYS;
+#endif
 }
 SLAB_ATTR(cpu_partial);

Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig	2013-06-03 14:28:57.954239479 -0500
+++ linux/init/Kconfig	2013-06-03 14:28:57.950239416 -0500
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
