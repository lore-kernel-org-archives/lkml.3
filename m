Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaEGJvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:51:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbaEGJvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:51:31 -0400
Date: Wed, 7 May 2014 11:51:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 1/2] memcg: get rid of memcg_create_cache_name
Message-ID: <20140507095127.GC9489@dhcp22.suse.cz>
References: <a4aa62026c10fc709e8bf13542b29cf771381394.1399450112.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4aa62026c10fc709e8bf13542b29cf771381394.1399450112.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-05-14 12:15:29, Vladimir Davydov wrote:
> Instead of calling back to memcontrol.c from kmem_cache_create_memcg in
> order to just create the name of a per memcg cache, let's allocate it in
> place. We only need to pass the memcg name to kmem_cache_create_memcg
> for that - everything else can be done in slab_common.c.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Seems good to me.
I would keep the comment about the static buffer as mentioned below.
Other than that
Acked-by: Michal Hocko <mhocko@suse.cz>

[...]
> -char *memcg_create_cache_name(struct mem_cgroup *memcg,
> -			      struct kmem_cache *root_cache)
> -{
> -	static char *buf;
> -
> -	/*
> -	 * We need a mutex here to protect the shared buffer. Since this is
> -	 * expected to be called only on cache creation, we can employ the
> -	 * slab_mutex for that purpose.
> -	 */
> -	lockdep_assert_held(&slab_mutex);
> -
> -	if (!buf) {
> -		buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
> -		if (!buf)
> -			return NULL;
> -	}
> -
> -	cgroup_name(memcg->css.cgroup, buf, NAME_MAX + 1);
> -	return kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
> -			 memcg_cache_id(memcg), buf);
> -}
> -
>  int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
>  			     struct kmem_cache *root_cache)
>  {
> @@ -3164,6 +3141,7 @@ void memcg_free_cache_params(struct kmem_cache *s)
>  static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
>  				    struct kmem_cache *root_cache)
>  {
> +	static char *memcg_name_buf;
>  	struct kmem_cache *cachep;
>  	int id;

So we are relying on memcg_slab_mutex now, right? Worth a comment I
suppose.

-- 
Michal Hocko
SUSE Labs
