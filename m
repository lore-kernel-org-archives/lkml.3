Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaHUI3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:29:50 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23575 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753980AbaHUI3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:29:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,371,1406563200"; 
   d="scan'208";a="34886686"
Message-ID: <53F5AD88.9050303@cn.fujitsu.com>
Date: Thu, 21 Aug 2014 16:27:52 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] mm/slab_common: move kmem_cache definition to internal
 header
References: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joonsoo,

Seems like this is a cleanup patchset. I want to mention another
tiny cleanup here.

You removed the "struct slab" before but it seems there is still
a slab_page field in page descriptor left and has no user now, right?

Thanks
Zhang

On 08/21/2014 04:09 PM, Joonsoo Kim wrote:
> We don't need to keep kmem_cache definition in include/linux/slab.h
> if we don't need to inline kmem_cache_size(). According to my
> code inspection, this function is only called at lc_create() in
> lib/lru_cache.c which may be called at initialization phase of something,
> so we don't need to inline it. Therfore, move it to slab_common.c and
> move kmem_cache definition to internal header.
> 
> After this change, we can change kmem_cache definition easily without
> full kernel build. For instance, we can turn on/off CONFIG_SLUB_STATS
> without full kernel build.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  include/linux/slab.h |   42 +-----------------------------------------
>  mm/slab.h            |   33 +++++++++++++++++++++++++++++++++
>  mm/slab_common.c     |    8 ++++++++
>  3 files changed, 42 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 1d9abb7..9062e4a 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -158,31 +158,6 @@ size_t ksize(const void *);
>  #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
>  #endif
>  
> -#ifdef CONFIG_SLOB
> -/*
> - * Common fields provided in kmem_cache by all slab allocators
> - * This struct is either used directly by the allocator (SLOB)
> - * or the allocator must include definitions for all fields
> - * provided in kmem_cache_common in their definition of kmem_cache.
> - *
> - * Once we can do anonymous structs (C11 standard) we could put a
> - * anonymous struct definition in these allocators so that the
> - * separate allocations in the kmem_cache structure of SLAB and
> - * SLUB is no longer needed.
> - */
> -struct kmem_cache {
> -	unsigned int object_size;/* The original size of the object */
> -	unsigned int size;	/* The aligned/padded/added on size  */
> -	unsigned int align;	/* Alignment as calculated */
> -	unsigned long flags;	/* Active flags on the slab */
> -	const char *name;	/* Slab name for sysfs */
> -	int refcount;		/* Use counter */
> -	void (*ctor)(void *);	/* Called on object slot creation */
> -	struct list_head list;	/* List of all slab caches on the system */
> -};
> -
> -#endif /* CONFIG_SLOB */
> -
>  /*
>   * Kmalloc array related definitions
>   */
> @@ -363,14 +338,6 @@ kmem_cache_alloc_node_trace(struct kmem_cache *s,
>  }
>  #endif /* CONFIG_TRACING */
>  
> -#ifdef CONFIG_SLAB
> -#include <linux/slab_def.h>
> -#endif
> -
> -#ifdef CONFIG_SLUB
> -#include <linux/slub_def.h>
> -#endif
> -
>  extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order);
>  
>  #ifdef CONFIG_TRACING
> @@ -650,14 +617,7 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
>  	return kmalloc_node(size, flags | __GFP_ZERO, node);
>  }
>  
> -/*
> - * Determine the size of a slab object
> - */
> -static inline unsigned int kmem_cache_size(struct kmem_cache *s)
> -{
> -	return s->object_size;
> -}
> -
> +unsigned int kmem_cache_size(struct kmem_cache *s);
>  void __init kmem_cache_init_late(void);
>  
>  #endif	/* _LINUX_SLAB_H */
> diff --git a/mm/slab.h b/mm/slab.h
> index 0e0fdd3..bd1c54a 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -4,6 +4,39 @@
>   * Internal slab definitions
>   */
>  
> +#ifdef CONFIG_SLOB
> +/*
> + * Common fields provided in kmem_cache by all slab allocators
> + * This struct is either used directly by the allocator (SLOB)
> + * or the allocator must include definitions for all fields
> + * provided in kmem_cache_common in their definition of kmem_cache.
> + *
> + * Once we can do anonymous structs (C11 standard) we could put a
> + * anonymous struct definition in these allocators so that the
> + * separate allocations in the kmem_cache structure of SLAB and
> + * SLUB is no longer needed.
> + */
> +struct kmem_cache {
> +	unsigned int object_size;/* The original size of the object */
> +	unsigned int size;	/* The aligned/padded/added on size  */
> +	unsigned int align;	/* Alignment as calculated */
> +	unsigned long flags;	/* Active flags on the slab */
> +	const char *name;	/* Slab name for sysfs */
> +	int refcount;		/* Use counter */
> +	void (*ctor)(void *);	/* Called on object slot creation */
> +	struct list_head list;	/* List of all slab caches on the system */
> +};
> +
> +#endif /* CONFIG_SLOB */
> +
> +#ifdef CONFIG_SLAB
> +#include <linux/slab_def.h>
> +#endif
> +
> +#ifdef CONFIG_SLUB
> +#include <linux/slub_def.h>
> +#endif
> +
>  /*
>   * State of the slab allocator.
>   *
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d319502..2088904 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -30,6 +30,14 @@ LIST_HEAD(slab_caches);
>  DEFINE_MUTEX(slab_mutex);
>  struct kmem_cache *kmem_cache;
>  
> +/*
> + * Determine the size of a slab object
> + */
> +unsigned int kmem_cache_size(struct kmem_cache *s)
> +{
> +	return s->object_size;
> +}
> +
>  #ifdef CONFIG_DEBUG_VM
>  static int kmem_cache_sanity_check(const char *name, size_t size)
>  {
> 


-- 
Thanks.
Zhang Yanfei
