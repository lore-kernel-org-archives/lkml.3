Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaBNS1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:27:16 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:33372 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbaBNS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:27:13 -0500
Date: Fri, 14 Feb 2014 12:27:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/9] slab: makes clear_obj_pfmemalloc() just return store
 masked value
In-Reply-To: <1392361043-22420-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1402141225460.12887@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Joonsoo Kim wrote:

> clear_obj_pfmemalloc() takes the pointer to the object pointer as argument
> to store masked value back into this address.
> But this is useless, since we don't use this stored value anymore.
> All we need is just masked value. So makes clear_obj_pfmemalloc()
> just return masked value.

Could this be a bit more compact?

> @@ -215,9 +215,9 @@ static inline void set_obj_pfmemalloc(void **objp)
>  	return;
>  }
>
> -static inline void clear_obj_pfmemalloc(void **objp)
> +static inline void *clear_obj_pfmemalloc(void *objp)
>  {
> -	*objp = (void *)((unsigned long)*objp & ~SLAB_OBJ_PFMEMALLOC);
> +	return (void *)((unsigned long)objp & ~SLAB_OBJ_PFMEMALLOC);
>  }

I dont think you need the (void *) cast here.

>  /*
> @@ -810,7 +810,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
>  		struct kmem_cache_node *n;
>
>  		if (gfp_pfmemalloc_allowed(flags)) {
> -			clear_obj_pfmemalloc(&objp);
> +			objp = clear_obj_pfmemalloc(objp);
>  			return objp;
>  		}

No need for objp. Just "return clear_obj_....


> @@ -833,7 +833,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
>  		if (!list_empty(&n->slabs_free) && force_refill) {
>  			struct page *page = virt_to_head_page(objp);
>  			ClearPageSlabPfmemalloc(page);
> -			clear_obj_pfmemalloc(&objp);
> +			objp = clear_obj_pfmemalloc(objp);
>  			recheck_pfmemalloc_active(cachep, ac);
>  			return objp;

Same here?
