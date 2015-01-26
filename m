Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbbAZPsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:48:06 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:36969 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbbAZPsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:48:04 -0500
Date: Mon, 26 Jan 2015 09:48:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
In-Reply-To: <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1501260944550.15849@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vladimir Davydov wrote:

> SLUB's kmem_cache_shrink not only removes empty slabs from the cache,
> but also sorts slabs by the number of objects in-use to cope with
> fragmentation. To achieve that, it tries to allocate a temporary array.
> If it fails, it will abort the whole procedure.

I do not think its worth optimizing this. If we cannot allocate even a
small object then the system is in an extremely bad state anyways.

> @@ -3400,7 +3407,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
>  		 * list_lock. page->inuse here is the upper limit.
>  		 */
>  		list_for_each_entry_safe(page, t, &n->partial, lru) {
> -			list_move(&page->lru, slabs_by_inuse + page->inuse);
> +			if (page->inuse < objects)
> +				list_move(&page->lru,
> +					  slabs_by_inuse + page->inuse);
>  			if (!page->inuse)
>  				n->nr_partial--;
>  		}

The condition is always true. A page that has page->inuse == objects
would not be on the partial list.

