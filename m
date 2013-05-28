Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387Ab3E1Ojc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:39:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab3E1Oja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:39:30 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZzSxI7jMevMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mVTtbqeYs4EA:10 a=NufY4J3AAAAA:8 a=evw4A6Cq85Im8trTRpAA:9 a=QEXdDO2ut3YA:10 a=re9sYKne76oA:10 a=ycmlTtmQ-pm-8niZ:21 a=tSjXLd6HV5BqHhWJ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369751967.15552.12.camel@gandalf.local.home>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Date: Tue, 28 May 2013 10:39:27 -0400
In-Reply-To: <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
References: <1364010673.6345.156.camel@gandalf.local.home>
	 <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com>
	 <1364227073.6345.182.camel@gandalf.local.home>
	 <1364228039.6345.183.camel@gandalf.local.home>
	 <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com>
	 <1364234613.6345.184.camel@gandalf.local.home>
	 <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
	 <1364236355.6345.185.camel@gandalf.local.home>
	 <20130327025957.GA17125@lge.com>
	 <1364355032.6345.200.camel@gandalf.local.home>
	 <20130327061351.GB17125@lge.com>
	 <alpine.DEB.2.02.1303281227520.16200@gentwo.org>
	 <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 17:30 +0000, Christoph Lameter wrote:
> This patch requires the earlier bug fix.
> 
> 
> Subject: slub: Make cpu partial slab support configurable
> 
> cpu partial support can introduce level of indeterminism that is not wanted
> in certain context (like a realtime kernel). Make it configurable.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Hi Christoph,

Any progress on this patch?

Thanks!

-- Steve

> 
> Index: linux/include/linux/slub_def.h
> ===================================================================
> --- linux.orig/include/linux/slub_def.h	2013-03-28 12:14:26.958358688 -0500
> +++ linux/include/linux/slub_def.h	2013-03-28 12:19:46.275866639 -0500
> @@ -47,7 +47,9 @@ struct kmem_cache_cpu {
>  	void **freelist;	/* Pointer to next available object */
>  	unsigned long tid;	/* Globally unique transaction id */
>  	struct page *page;	/* The slab from which we are allocating */
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	struct page *partial;	/* Partially allocated frozen slabs */
> +#endif
>  #ifdef CONFIG_SLUB_STATS
>  	unsigned stat[NR_SLUB_STAT_ITEMS];
>  #endif
> @@ -84,7 +86,9 @@ struct kmem_cache {
>  	int size;		/* The size of an object including meta data */
>  	int object_size;	/* The size of an object without meta data */
>  	int offset;		/* Free pointer offset. */
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	int cpu_partial;	/* Number of per cpu partial objects to keep around */
> +#endif
>  	struct kmem_cache_order_objects oo;
> 
>  	/* Allocation and freeing of slabs */
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c	2013-03-28 12:18:48.446813991 -0500
> +++ linux/mm/slub.c	2013-03-28 12:19:46.275866639 -0500
> @@ -1531,7 +1531,9 @@ static inline void *acquire_slab(struct
>  	return freelist;
>  }
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
> +#endif
>  static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
> 
>  /*
> @@ -1570,10 +1572,20 @@ static void *get_partial_node(struct kme
>  			object = t;
>  			available =  page->objects - (unsigned long)page->lru.next;
>  		} else {
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  			available = put_cpu_partial(s, page, 0);
>  			stat(s, CPU_PARTIAL_NODE);
> +#else
> +			BUG();
> +#endif
>  		}
> -		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
> +		if (kmem_cache_debug(s) ||
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
> +			available > s->cpu_partial / 2
> +#else
> +			available > 0
> +#endif
> +			)
>  			break;
> 
>  	}
> @@ -1874,6 +1886,7 @@ redo:
>  	}
>  }
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  /*
>   * Unfreeze all the cpu partial slabs.
>   *
> @@ -1989,6 +2002,7 @@ static int put_cpu_partial(struct kmem_c
>  	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
>  	return pobjects;
>  }
> +#endif
> 
>  static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
>  {
> @@ -2013,7 +2027,9 @@ static inline void __flush_cpu_slab(stru
>  		if (c->page)
>  			flush_slab(s, c);
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  		unfreeze_partials(s, c);
> +#endif
>  	}
>  }
> 
> @@ -2029,7 +2045,11 @@ static bool has_cpu_slab(int cpu, void *
>  	struct kmem_cache *s = info;
>  	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	return c->page || c->partial;
> +#else
> +	return c->page;
> +#endif
>  }
> 
>  static void flush_all(struct kmem_cache *s)
> @@ -2225,7 +2245,10 @@ static void *__slab_alloc(struct kmem_ca
>  	page = c->page;
>  	if (!page)
>  		goto new_slab;
> +
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  redo:
> +#endif
> 
>  	if (unlikely(!node_match(page, node))) {
>  		stat(s, ALLOC_NODE_MISMATCH);
> @@ -2278,6 +2301,7 @@ load_freelist:
> 
>  new_slab:
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	if (c->partial) {
>  		page = c->page = c->partial;
>  		c->partial = page->next;
> @@ -2285,6 +2309,7 @@ new_slab:
>  		c->freelist = NULL;
>  		goto redo;
>  	}
> +#endif
> 
>  	freelist = new_slab_objects(s, gfpflags, node, &c);
> 
> @@ -2491,6 +2516,7 @@ static void __slab_free(struct kmem_cach
>  		new.inuse--;
>  		if ((!new.inuse || !prior) && !was_frozen) {
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  			if (!kmem_cache_debug(s) && !prior)
> 
>  				/*
> @@ -2499,7 +2525,9 @@ static void __slab_free(struct kmem_cach
>  				 */
>  				new.frozen = 1;
> 
> -			else { /* Needs to be taken off a list */
> +			else
> +#endif
> +		       		{ /* Needs to be taken off a list */
> 
>  	                        n = get_node(s, page_to_nid(page));
>  				/*
> @@ -2521,6 +2549,7 @@ static void __slab_free(struct kmem_cach
>  		"__slab_free"));
> 
>  	if (likely(!n)) {
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
> 
>  		/*
>  		 * If we just froze the page then put it onto the
> @@ -2530,6 +2559,7 @@ static void __slab_free(struct kmem_cach
>  			put_cpu_partial(s, page, 1);
>  			stat(s, CPU_PARTIAL_FREE);
>  		}
> +#endif
>  		/*
>  		 * The list lock was not taken therefore no list
>  		 * activity can be necessary.
> @@ -3036,7 +3066,7 @@ static int kmem_cache_open(struct kmem_c
>  	 * list to avoid pounding the page allocator excessively.
>  	 */
>  	set_min_partial(s, ilog2(s->size) / 2);
> -
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	/*
>  	 * cpu_partial determined the maximum number of objects kept in the
>  	 * per cpu partial lists of a processor.
> @@ -3064,6 +3094,7 @@ static int kmem_cache_open(struct kmem_c
>  		s->cpu_partial = 13;
>  	else
>  		s->cpu_partial = 30;
> +#endif
> 
>  #ifdef CONFIG_NUMA
>  	s->remote_node_defrag_ratio = 1000;
> @@ -4424,13 +4455,14 @@ static ssize_t show_slab_objects(struct
>  			total += x;
>  			nodes[node] += x;
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  			page = ACCESS_ONCE(c->partial);
>  			if (page) {
>  				x = page->pobjects;
>  				total += x;
>  				nodes[node] += x;
>  			}
> -
> +#endif
>  			per_cpu[node]++;
>  		}
>  	}
> @@ -4583,6 +4615,7 @@ static ssize_t min_partial_store(struct
>  }
>  SLAB_ATTR(min_partial);
> 
> +#ifdef CONFIG_CPU_PARTIAL
>  static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
>  {
>  	return sprintf(buf, "%u\n", s->cpu_partial);
> @@ -4605,6 +4638,7 @@ static ssize_t cpu_partial_store(struct
>  	return length;
>  }
>  SLAB_ATTR(cpu_partial);
> +#endif
> 
>  static ssize_t ctor_show(struct kmem_cache *s, char *buf)
>  {
> @@ -4644,6 +4678,7 @@ static ssize_t objects_partial_show(stru
>  }
>  SLAB_ATTR_RO(objects_partial);
> 
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
>  {
>  	int objects = 0;
> @@ -4674,6 +4709,7 @@ static ssize_t slabs_cpu_partial_show(st
>  	return len + sprintf(buf + len, "\n");
>  }
>  SLAB_ATTR_RO(slabs_cpu_partial);
> +#endif
> 
>  static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
>  {
> @@ -4997,11 +5033,13 @@ STAT_ATTR(DEACTIVATE_BYPASS, deactivate_
>  STAT_ATTR(ORDER_FALLBACK, order_fallback);
>  STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
>  STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
> +#ifdef CONFIG_CPU_PARTIAL
>  STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
>  STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
>  STAT_ATTR(CPU_PARTIAL_NODE, cpu_partial_node);
>  STAT_ATTR(CPU_PARTIAL_DRAIN, cpu_partial_drain);
>  #endif
> +#endif
> 
>  static struct attribute *slab_attrs[] = {
>  	&slab_size_attr.attr,
> @@ -5009,7 +5047,9 @@ static struct attribute *slab_attrs[] =
>  	&objs_per_slab_attr.attr,
>  	&order_attr.attr,
>  	&min_partial_attr.attr,
> +#ifdef CONFIG_CPU_PARTIAL
>  	&cpu_partial_attr.attr,
> +#endif
>  	&objects_attr.attr,
>  	&objects_partial_attr.attr,
>  	&partial_attr.attr,
> @@ -5022,7 +5062,9 @@ static struct attribute *slab_attrs[] =
>  	&destroy_by_rcu_attr.attr,
>  	&shrink_attr.attr,
>  	&reserved_attr.attr,
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	&slabs_cpu_partial_attr.attr,
> +#endif
>  #ifdef CONFIG_SLUB_DEBUG
>  	&total_objects_attr.attr,
>  	&slabs_attr.attr,
> @@ -5064,11 +5106,13 @@ static struct attribute *slab_attrs[] =
>  	&order_fallback_attr.attr,
>  	&cmpxchg_double_fail_attr.attr,
>  	&cmpxchg_double_cpu_fail_attr.attr,
> +#ifdef CONFIG_SLUB_CPU_PARTIAL
>  	&cpu_partial_alloc_attr.attr,
>  	&cpu_partial_free_attr.attr,
>  	&cpu_partial_node_attr.attr,
>  	&cpu_partial_drain_attr.attr,
>  #endif
> +#endif
>  #ifdef CONFIG_FAILSLAB
>  	&failslab_attr.attr,
>  #endif
> Index: linux/init/Kconfig
> ===================================================================
> --- linux.orig/init/Kconfig	2013-03-28 12:14:26.958358688 -0500
> +++ linux/init/Kconfig	2013-03-28 12:19:46.275866639 -0500
> @@ -1514,6 +1514,14 @@ config SLOB
> 
>  endchoice
> 
> +config SLUB_CPU_PARTIAL
> +	depends on SLUB
> +	bool "SLUB per cpu partial cache"
> +	help
> +	  Per cpu partial caches accellerate freeing of objects at the
> +	  price of more indeterminism in the latency of the free.
> +	  Typically one would choose no for a realtime system.
> +
>  config MMAP_ALLOW_UNINITIALIZED
>  	bool "Allow mmapped anonymous memory to be uninitialized"
>  	depends on EXPERT && !MMU


