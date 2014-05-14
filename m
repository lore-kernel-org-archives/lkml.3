Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaENQQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:16:40 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:47015 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbaENQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:16:39 -0400
Date: Wed, 14 May 2014 11:16:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 1/3] slub: keep full slabs on list for per memcg
 caches
In-Reply-To: <bc70b480221f7765926c8b4d63c55fb42e85baaf.1399982635.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405141114040.16512@gentwo.org>
References: <cover.1399982635.git.vdavydov@parallels.com> <bc70b480221f7765926c8b4d63c55fb42e85baaf.1399982635.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Vladimir Davydov wrote:

> Currently full slabs are only kept on per-node lists for debugging, but
> we need this feature to reparent per memcg caches, so let's enable it
> for them too.

That will significantly impact the fastpaths for alloc and free.

Also a pretty significant change the logic of the fastpaths since they
were not designed to handle the full lists. In debug mode all operations
were only performed by the slow paths and only the slow paths so far
supported tracking full slabs.

> @@ -2587,6 +2610,9 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>
>  			} else { /* Needs to be taken off a list */
>
> +				if (kmem_cache_has_cpu_partial(s) && !prior)
> +					new.frozen = 1;
> +
>  	                        n = get_node(s, page_to_nid(page));

Make this code conditional?

>  				/*
>  				 * Speculatively acquire the list_lock.
> @@ -2606,6 +2632,12 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>  		object, new.counters,
>  		"__slab_free"));
>
> +	if (unlikely(n) && new.frozen && !was_frozen) {
> +		remove_full(s, n, page);
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +		n = NULL;
> +	}
> +
>  	if (likely(!n)) {

Here too.

