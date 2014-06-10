Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbaFJHov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:44:51 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39473 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaFJHou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:44:50 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 10 Jun 2014 16:48:40 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 3/8] memcg: mark caches that belong to offline
 memcgs as dead
Message-ID: <20140610074840.GF19036@js1304-P5Q-DELUXE>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <9e6537847c22a5050f84bd2bf5633f7c022fb801.1402060096.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e6537847c22a5050f84bd2bf5633f7c022fb801.1402060096.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 05:22:40PM +0400, Vladimir Davydov wrote:
> This will be used by the next patches.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> ---
>  include/linux/slab.h |    2 ++
>  mm/memcontrol.c      |    1 +
>  mm/slab.h            |   10 ++++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index d9716fdc8211..d99d5212b815 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -527,6 +527,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
>   * @list: list_head for the list of all caches in this memcg
>   * @root_cache: pointer to the global, root cache, this cache was derived from
>   * @refcnt: reference counter
> + * @dead: set to true when owner memcg is turned offline
>   * @unregister_work: worker to destroy the cache
>   */
>  struct memcg_cache_params {
> @@ -541,6 +542,7 @@ struct memcg_cache_params {
>  			struct list_head list;
>  			struct kmem_cache *root_cache;
>  			atomic_long_t refcnt;
> +			bool dead;
>  			struct work_struct unregister_work;
>  		};
>  	};
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 886b5b414958..ed42fd1105a5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3294,6 +3294,7 @@ static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
>  	mutex_lock(&memcg_slab_mutex);
>  	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
>  		cachep = memcg_params_to_cache(params);
> +		cachep->memcg_params->dead = true;

I guess that this needs smp_wmb() and memcg_cache_dead() needs
smp_rmb(), since we could call memcg_cache_dead() without holding any locks.

Thanks.
