Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaFXHVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:21:14 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38356 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaFXHVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:21:13 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 24 Jun 2014 16:25:54 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
Message-ID: <20140624072554.GB4836@js1304-P5Q-DELUXE>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:38:22AM +0400, Vladimir Davydov wrote:
> Since a dead memcg cache is destroyed only after the last slab allocated
> to it is freed, we must disable caching of free objects/slabs for such
> caches, otherwise they will be hanging around forever.
> 
> For SLAB that means we must disable per cpu free object arrays and make
> free_block always discard empty slabs irrespective of node's free_limit.
> 
> To disable per cpu arrays, we free them on kmem_cache_shrink (see
> drain_cpu_caches -> do_drain) and make __cache_free fall back to
> free_block if there is no per cpu array. Also, we have to disable
> allocation of per cpu arrays on cpu hotplug for dead caches (see
> cpuup_prepare, __do_tune_cpucache).
> 
> After we disabled free objects/slabs caching, there is no need to reap
> those caches periodically. Moreover, it will only result in slowdown. So
> we also make cache_reap skip then.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  mm/slab.c |   31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index b3af82419251..7e91f5f1341d 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1210,6 +1210,9 @@ static int cpuup_prepare(long cpu)
>  		struct array_cache *shared = NULL;
>  		struct array_cache **alien = NULL;
>  
> +		if (memcg_cache_dead(cachep))
> +			continue;
> +
>  		nc = alloc_arraycache(node, cachep->limit,
>  					cachep->batchcount, GFP_KERNEL);
>  		if (!nc)
> @@ -2411,10 +2414,18 @@ static void do_drain(void *arg)
>  
>  	check_irq_off();
>  	ac = cpu_cache_get(cachep);
> +	if (!ac)
> +		return;
> +
>  	spin_lock(&cachep->node[node]->list_lock);
>  	free_block(cachep, ac->entry, ac->avail, node);
>  	spin_unlock(&cachep->node[node]->list_lock);
>  	ac->avail = 0;
> +
> +	if (memcg_cache_dead(cachep)) {
> +		cachep->array[smp_processor_id()] = NULL;
> +		kfree(ac);
> +	}
>  }
>  
>  static void drain_cpu_caches(struct kmem_cache *cachep)
> @@ -3368,7 +3379,8 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
>  
>  		/* fixup slab chains */
>  		if (page->active == 0) {
> -			if (n->free_objects > n->free_limit) {
> +			if (n->free_objects > n->free_limit ||
> +			    memcg_cache_dead(cachep)) {

Hello, Vladimir.

I'd like to set 0 to free_limit in __kmem_cache_shrink()
rather than memcg_cache_dead() test here, because memcg_cache_dead()
is more expensive than it. Is there any problem in this way?

Thanks.
