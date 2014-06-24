Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaFXIQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:16:24 -0400
Received: from mx2.parallels.com ([199.115.105.18]:49876 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFXIQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:16:21 -0400
Date: Tue, 24 Jun 2014 12:16:08 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix off by one in number of slab tests
Message-ID: <20140624081608.GC18121@esperanza>
References: <1403595842-28270-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1403595842-28270-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:44:01PM +0900, Joonsoo Kim wrote:
> min_partial means minimum number of slab cached in node partial
> list. So, if nr_partial is less than it, we keep newly empty slab
> on node partial list rather than freeing it. But if nr_partial is
> equal or greater than it, it means that we have enough partial slabs
> so should free newly empty slab. Current implementation missed
> the equal case so if we set min_partial is 0, then, at least one slab
> could be cached. This is critical problem to kmemcg destroying logic
> because it doesn't works properly if some slabs is cached. This patch
> fixes this problem.

Oops, my fault :-(

Thank you for catching this!

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vladimir Davydov <vdavydov@parallels.com>

> 
> diff --git a/mm/slub.c b/mm/slub.c
> index c567927..67da14d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1851,7 +1851,7 @@ redo:
>  
>  	new.frozen = 0;
>  
> -	if (!new.inuse && n->nr_partial > s->min_partial)
> +	if (!new.inuse && n->nr_partial >= s->min_partial)
>  		m = M_FREE;
>  	else if (new.freelist) {
>  		m = M_PARTIAL;
> @@ -1962,7 +1962,7 @@ static void unfreeze_partials(struct kmem_cache *s,
>  				new.freelist, new.counters,
>  				"unfreezing slab"));
>  
> -		if (unlikely(!new.inuse && n->nr_partial > s->min_partial)) {
> +		if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
>  			page->next = discard_page;
>  			discard_page = page;
>  		} else {
> @@ -2595,7 +2595,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
>                  return;
>          }
>  
> -	if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
> +	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
>  		goto slab_empty;
>  
>  	/*
> -- 
> 1.7.9.5
> 
