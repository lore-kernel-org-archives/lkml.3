Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaFLGyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:54:46 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63151 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaFLGyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:54:45 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 12 Jun 2014 15:58:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 5/8] slub: make slab_free non-preemptable
Message-ID: <20140612065842.GE19918@js1304-P5Q-DELUXE>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <7cd6784a36ed997cc6631615d98e11e02e811b1b.1402060096.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cd6784a36ed997cc6631615d98e11e02e811b1b.1402060096.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 05:22:42PM +0400, Vladimir Davydov wrote:
> Since per memcg cache destruction is scheduled when the last slab is
> freed, to avoid use-after-free in kmem_cache_free we should either
> rearrange code in kmem_cache_free so that it won't dereference the cache
> ptr after freeing the object, or wait for all kmem_cache_free's to
> complete before proceeding to cache destruction.
> 
> The former approach isn't a good option from the future development
> point of view, because every modifications to kmem_cache_free must be
> done with great care then. Hence we should provide a method to wait for
> all currently executing kmem_cache_free's to finish.
> 
> This patch makes SLUB's implementation of kmem_cache_free
> non-preemptable. As a result, synchronize_sched() will work as a barrier
> against kmem_cache_free's in flight, so that issuing it before cache
> destruction will protect us against the use-after-free.
> 
> This won't affect performance of kmem_cache_free, because we already
> disable preemption there, and this patch only moves preempt_enable to
> the end of the function. Neither should it affect the system latency,
> because kmem_cache_free is extremely short, even in its slow path.
> 
> SLAB's version of kmem_cache_free already proceeds with irqs disabled,
> so nothing to be done there.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  mm/slub.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 35741592be8c..e46d6abe8a68 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2673,18 +2673,11 @@ static __always_inline void slab_free(struct kmem_cache *s,
>  
>  	slab_free_hook(s, x);
>  
> -redo:
> -	/*
> -	 * Determine the currently cpus per cpu slab.
> -	 * The cpu may change afterward. However that does not matter since
> -	 * data is retrieved via this pointer. If we are on the same cpu
> -	 * during the cmpxchg then the free will succedd.
> -	 */
>  	preempt_disable();

Hello,

Could you add some code comment why this preempt_disable/enable() is
needed? We don't have any clue that kmemcg depends on these things
on code, so someone cannot understand why it is here.

If possible, please add similar code comment on slab_alloc in mm/slab.c.

Thanks.

