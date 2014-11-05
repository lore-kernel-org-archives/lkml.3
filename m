Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKESnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:43:35 -0500
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:58650 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbaKESne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:43:34 -0500
Date: Wed, 5 Nov 2014 12:43:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 8/8] slab: recharge slab pages to the allocating
 memory cgroup
In-Reply-To: <fe7c55a7ff9bb8a1ddff0256f5404196c10bfd08.1415046910.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1411051242410.28485@gentwo.org>
References: <cover.1415046910.git.vdavydov@parallels.com> <fe7c55a7ff9bb8a1ddff0256f5404196c10bfd08.1415046910.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Vladimir Davydov wrote:

> +static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
> +
>  static __always_inline void *
>  slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
>  		   unsigned long caller)
> @@ -3185,6 +3187,10 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
>  		kmemcheck_slab_alloc(cachep, flags, ptr, cachep->object_size);
>  		if (unlikely(flags & __GFP_ZERO))
>  			memset(ptr, 0, cachep->object_size);
> +		if (unlikely(memcg_kmem_recharge_slab(ptr, flags))) {
> +			slab_free(cachep, ptr);
> +			ptr = NULL;
> +		}
>  	}
>
>  	return ptr;
> @@ -3250,6 +3256,10 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
>  		kmemcheck_slab_alloc(cachep, flags, objp, cachep->object_size);
>  		if (unlikely(flags & __GFP_ZERO))
>  			memset(objp, 0, cachep->object_size);
> +		if (unlikely(memcg_kmem_recharge_slab(objp, flags))) {
> +			slab_free(cachep, objp);
> +			objp = NULL;
> +		}
>  	}
>

Please do not add code to the hotpaths if its avoidable. Can you charge
the full slab only when allocated please?
