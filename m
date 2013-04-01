Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab3DAVqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:46:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:41823 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab3DAVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:46:46 -0400
Message-ID: <515A001B.4010009@windriver.com>
Date: Mon, 1 Apr 2013 17:46:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's unfreeze_partials()
 code.
References: <1364010673.6345.156.camel@gandalf.local.home> <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com> <1364227073.6345.182.camel@gandalf.local.home> <1364228039.6345.183.camel@gandalf.local.home> <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com> <1364234613.6345.184.camel@gandalf.local.home> <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com> <1364236355.6345.185.camel@gandalf.local.home> <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com> <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com> <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com> <0000013dc63a9086-7d10c4a8-748c-4e19-829a-856d8d42c8eb-000000@email.amazonses.com>
In-Reply-To: <0000013dc63a9086-7d10c4a8-748c-4e19-829a-856d8d42c8eb-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-04-01 11:32 AM, Christoph Lameter wrote:

[...]

> @@ -4583,6 +4615,7 @@ static ssize_t min_partial_store(struct
>  }
>  SLAB_ATTR(min_partial);
> 
> +#ifdef CONFIG_CPU_PARTIAL

Above causes build failures when stats are on, because the
name is wrong and hence is never defined, and ....

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

...the same here, and ...

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

...here too.  All should be CONFIG_SLUB_CPU_PARTIAL

Thanks,
Paul.
--

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
> --- linux.orig/init/Kconfig	2013-04-01 10:27:05.908964674 -0500
> +++ linux/init/Kconfig	2013-04-01 10:31:46.497863625 -0500
> @@ -1514,6 +1514,17 @@ config SLOB
> 
>  endchoice
> 
> +config SLUB_CPU_PARTIAL
> +	default y
> +	depends on SLUB
> +	bool "SLUB per cpu partial cache"
> +	help
> +	  Per cpu partial caches accellerate objects allocation and freeing
> +	  that is local to a processor at the price of more indeterminism
> +	  in the latency of the free. On overflow these caches will be cleared
> +	  which requires the taking of locks that may cause latency spikes.
> +	  Typically one would choose no for a realtime system.
> +
>  config MMAP_ALLOW_UNINITIALIZED
>  	bool "Allow mmapped anonymous memory to be uninitialized"
>  	depends on EXPERT && !MMU
> 
