Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaEHBTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:19:16 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41501 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaEHBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:19:15 -0400
Date: Wed, 7 May 2014 18:19:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 05/10] slab: factor out initialization of arracy
 cache
In-Reply-To: <1399442780-28748-6-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1405071818060.5305@chino.kir.corp.google.com>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com> <1399442780-28748-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Joonsoo Kim wrote:

> Factor out initialization of array cache to use it in following patch.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 

Acked-by: David Rientjes <rientjes@google.com>

s/arracy/array/ in patch title.

> diff --git a/mm/slab.c b/mm/slab.c
> index 7647728..755fb57 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -741,13 +741,8 @@ static void start_cpu_timer(int cpu)
>  	}
>  }
>  
> -static struct array_cache *alloc_arraycache(int node, int entries,
> -					    int batchcount, gfp_t gfp)
> +static void init_arraycache(struct array_cache *ac, int limit, int batch)
>  {
> -	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
> -	struct array_cache *nc = NULL;
> -
> -	nc = kmalloc_node(memsize, gfp, node);
>  	/*
>  	 * The array_cache structures contain pointers to free object.
>  	 * However, when such objects are allocated or transferred to another
> @@ -755,15 +750,25 @@ static struct array_cache *alloc_arraycache(int node, int entries,
>  	 * valid references during a kmemleak scan. Therefore, kmemleak must
>  	 * not scan such objects.
>  	 */
> -	kmemleak_no_scan(nc);
> -	if (nc) {
> -		nc->avail = 0;
> -		nc->limit = entries;
> -		nc->batchcount = batchcount;
> -		nc->touched = 0;
> -		spin_lock_init(&nc->lock);
> +	kmemleak_no_scan(ac);
> +	if (ac) {
> +		ac->avail = 0;
> +		ac->limit = limit;
> +		ac->batchcount = batch;
> +		ac->touched = 0;
> +		spin_lock_init(&ac->lock);
>  	}
> -	return nc;
> +}
> +
> +static struct array_cache *alloc_arraycache(int node, int entries,
> +					    int batchcount, gfp_t gfp)
> +{
> +	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);

const?

> +	struct array_cache *ac = NULL;
> +
> +	ac = kmalloc_node(memsize, gfp, node);

I thought nc meant node cache, but I agree that ac is clearer.

> +	init_arraycache(ac, entries, batchcount);
> +	return ac;
>  }
>  
>  static inline bool is_slab_pfmemalloc(struct page *page)
