Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaA3VjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:39:00 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44530 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3Vi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:38:59 -0500
Date: Thu, 30 Jan 2014 13:38:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on memcg_create_kmem_cache
 fail path
In-Reply-To: <20140130132939.96a25a37016a12f9a0093a90@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401301336530.15271@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com> <20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org> <alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com>
 <20140130132939.96a25a37016a12f9a0093a90@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Andrew Morton wrote:

> > What's funnier is that tmp_name isn't required at all since 
> > kmem_cache_create_memcg() is just going to do a kstrdup() on it anyway, so 
> > you could easily just pass in the pointer to memory that has been 
> > allocated for s->name rather than allocating memory twice.
> 
> We need a buffer to sprintf() into.
> 

Yeah, it shouldn't be temporary it should be the one and only allocation.  
We should construct the name in memcg_create_kmem_cache() and be done with 
it.

> diff -puN mm/memcontrol.c~mm-memcontrolc-memcg_create_kmem_cache-tweaks mm/memcontrol.c
> --- a/mm/memcontrol.c~mm-memcontrolc-memcg_create_kmem_cache-tweaks
> +++ a/mm/memcontrol.c
> @@ -3400,24 +3400,18 @@ void mem_cgroup_destroy_cache(struct kme
>  static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>  						  struct kmem_cache *s)
>  {
> -	struct kmem_cache *new = NULL;
> -	static char *tmp_name = NULL;
> -	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
> +	struct kmem_cache *new;
> +	char *tmp_name;
>  
>  	BUG_ON(!memcg_can_account_kmem(memcg));
>  
> -	mutex_lock(&mutex);
>  	/*
> -	 * kmem_cache_create_memcg duplicates the given name and
> -	 * cgroup_name for this name requires RCU context.
> -	 * This static temporary buffer is used to prevent from
> -	 * pointless shortliving allocation.
> +	 * kmem_cache_create_memcg duplicates the given name and cgroup_name()
> +	 * for this name requires rcu_read_lock().
>  	 */
> -	if (!tmp_name) {
> -		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
> -		if (!tmp_name)
> -			goto out;
> -	}
> +	tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (!tmp_name)
> +		return NULL;
>  
>  	rcu_read_lock();
>  	snprintf(tmp_name, PATH_MAX, "%s(%d:%s)", s->name,
> @@ -3430,8 +3424,7 @@ static struct kmem_cache *memcg_create_k
>  		new->allocflags |= __GFP_KMEMCG;
>  	else
>  		new = s;
> -out:
> -	mutex_unlock(&mutex);
> +	kfree(tmp_name);
>  	return new;
>  }
>  

This is fine, but kmem_cache_create_memcg() is still just going to do a 
pointless kstrdup() on it which isn't necessary.
