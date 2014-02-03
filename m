Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaBCWIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:08:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaBCWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:08:36 -0500
Date: Mon, 3 Feb 2014 14:08:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH v2 2/7] memcg, slab: cleanup memcg cache name creation
Message-Id: <20140203140835.c414b6222abfd9c349648e2a@linux-foundation.org>
In-Reply-To: <ec86147b3dfd5bf7da5b34e12b7a4e4881f49690.1391441746.git.vdavydov@parallels.com>
References: <cover.1391441746.git.vdavydov@parallels.com>
	<ec86147b3dfd5bf7da5b34e12b7a4e4881f49690.1391441746.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014 19:54:37 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> The way memcg_create_kmem_cache() creates the name for a memcg cache
> looks rather strange: it first formats the name in the static buffer
> tmp_name protected by a mutex, then passes the pointer to the buffer to
> kmem_cache_create_memcg(), which finally duplicates it to the cache
> name.
> 
> Let's clean this up by moving memcg cache name creation to a separate
> function to be called by kmem_cache_create_memcg(), and estimating the
> length of the name string before copying anything to it so that we won't
> need a temporary buffer.
> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3193,6 +3193,37 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>  	return 0;
>  }
>  
> +static int memcg_print_cache_name(char *buf, size_t size,
> +		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
> +{
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = snprintf(buf, size, "%s(%d:%s)", root_cache->name,
> +		       memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +char *memcg_create_cache_name(struct mem_cgroup *memcg,
> +			      struct kmem_cache *root_cache)
> +{
> +	int len;
> +	char *name;
> +
> +	/*
> +	 * We cannot use kasprintf() here, because cgroup_name() must be called
> +	 * under RCU protection.
> +	 */
> +	len = memcg_print_cache_name(NULL, 0, memcg, root_cache);
> +
> +	name = kmalloc(len + 1, GFP_KERNEL);
> +	if (name)
> +		memcg_print_cache_name(name, len + 1, memcg, root_cache);

but but but this assumes that cgroup_name(memcg->css.cgroup) did not
change between the two calls to memcg_print_cache_name().  If that is
the case then the locking was unneeded anyway.

> +	return name;
> +}
> +
>  int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
>  			     struct kmem_cache *root_cache)
>  {
> @@ -3397,44 +3428,6 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
>  	schedule_work(&cachep->memcg_params->destroy);
>  }
>  

