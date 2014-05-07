Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaEGVaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:30:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56928 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaEGVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:30:04 -0400
Date: Wed, 7 May 2014 14:30:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: George Spelvin <linux@horizon.com>
cc: cl@linux.com, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 03/10] slab: move up code to get kmem_cache_node in
 free_block()
In-Reply-To: <20140507212224.9085.qmail@ns.horizon.com>
Message-ID: <alpine.DEB.2.02.1405071429310.8454@chino.kir.corp.google.com>
References: <20140507212224.9085.qmail@ns.horizon.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, George Spelvin wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index 388cb1ae6f..7fdc8df104 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -215,9 +215,9 @@ static inline void set_obj_pfmemalloc(void **objp)
>  	return;
>  }
>  
> -static inline void clear_obj_pfmemalloc(void **objp)
> +static inline void *clear_obj_pfmemalloc(void **objp)
>  {
> -	*objp = (void *)((unsigned long)*objp & ~SLAB_OBJ_PFMEMALLOC);
> +	return *objp = (void *)((unsigned long)*objp & ~SLAB_OBJ_PFMEMALLOC);
>  }
>  
>  /*
> @@ -809,10 +809,8 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
>  	if (unlikely(is_obj_pfmemalloc(objp))) {
>  		struct kmem_cache_node *n;
>  
> -		if (gfp_pfmemalloc_allowed(flags)) {
> -			clear_obj_pfmemalloc(&objp);
> -			return objp;
> -		}
> +		if (gfp_pfmemalloc_allowed(flags))
> +			return clear_obj_pfmemalloc(&objp);
>  
>  		/* The caller cannot use PFMEMALLOC objects, find another one */
>  		for (i = 0; i < ac->avail; i++) {
> @@ -833,9 +831,8 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
>  		if (!list_empty(&n->slabs_free) && force_refill) {
>  			struct page *page = virt_to_head_page(objp);
>  			ClearPageSlabPfmemalloc(page);
> -			clear_obj_pfmemalloc(&objp);
>  			recheck_pfmemalloc_active(cachep, ac);
> -			return objp;
> +			return clear_obj_pfmemalloc(&objp);
>  		}
>  
>  		/* No !PFMEMALLOC objects available */
> @@ -3362,17 +3359,12 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
>  		       int node)
>  {
>  	int i;
> -	struct kmem_cache_node *n;
> +	struct kmem_cache_node *n = cachep->node[node];
>  
>  	for (i = 0; i < nr_objects; i++) {
> -		void *objp;
> -		struct page *page;
> -
> -		clear_obj_pfmemalloc(&objpp[i]);
> -		objp = objpp[i];
> +		void *objp = clear_obj_pfmemalloc(&objpp[i]);
> +		struct page *page = virt_to_head_page(objp);
>  
> -		page = virt_to_head_page(objp);
> -		n = cachep->node[node];
>  		list_del(&page->lru);
>  		check_spinlock_acquired_node(cachep, node);
>  		slab_put_obj(cachep, page, objp, node);

I think this unnecessarily obfuscates the code.
