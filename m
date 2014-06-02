Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaFBEig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 00:38:36 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35277 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFBEif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 00:38:35 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 2 Jun 2014 13:41:55 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, hannes@cmpxchg.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
Message-ID: <20140602044154.GB17964@js1304-P5Q-DELUXE>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 05:51:11PM +0400, Vladimir Davydov wrote:
> There is no use in keeping free objects/slabs on dead memcg caches,
> because they will never be allocated. So let's make cache_reap() shrink
> as many free objects from such caches as possible.
> 
> Note the difference between SLAB and SLUB handling of dead memcg caches.
> For SLUB, dead cache destruction is scheduled as soon as the last object
> is freed, because dead caches do not cache free objects. For SLAB, dead
> caches can keep some free objects on per cpu arrays, so that an empty
> dead cache will be hanging around until cache_reap() drains it.
> 
> We don't disable free objects caching for SLAB, because it would force
> kfree to always take a spin lock, which would degrade performance
> significantly.
> 
> Since cache_reap() drains all caches once ~4 secs on each CPU, empty
> dead caches will die quickly.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  mm/slab.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index cecc01bba389..d81e46316c99 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3985,6 +3985,11 @@ static void cache_reap(struct work_struct *w)
>  		goto out;
>  
>  	list_for_each_entry(searchp, &slab_caches, list) {
> +		int force = 0;
> +
> +		if (memcg_cache_dead(searchp))
> +			force = 1;
> +
>  		check_irq_on();
>  
>  		/*
> @@ -3996,7 +4001,7 @@ static void cache_reap(struct work_struct *w)
>  
>  		reap_alien(searchp, n);
>  
> -		drain_array(searchp, n, cpu_cache_get(searchp), 0, node);
> +		drain_array(searchp, n, cpu_cache_get(searchp), force, node);
>  
>  		/*
>  		 * These are racy checks but it does not matter
> @@ -4007,15 +4012,17 @@ static void cache_reap(struct work_struct *w)
>  
>  		n->next_reap = jiffies + REAPTIMEOUT_NODE;
>  
> -		drain_array(searchp, n, n->shared, 0, node);
> +		drain_array(searchp, n, n->shared, force, node);
>  
>  		if (n->free_touched)
>  			n->free_touched = 0;
>  		else {
> -			int freed;
> +			int freed, tofree;
> +
> +			tofree = force ? slabs_tofree(searchp, n) :
> +				DIV_ROUND_UP(n->free_limit, 5 * searchp->num);

Hello,

According to my code reading, slabs_to_free() doesn't return number of
free slabs. This bug is introduced by 0fa8103b. I think that it is
better to fix it before applyting this patch. Otherwise, use n->free_objects
instead of slabs_tofree() to achieve your purpose correctly.

Thanks.
