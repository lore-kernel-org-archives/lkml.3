Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab3HNUrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:47:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab3HNUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:47:12 -0400
Date: Wed, 14 Aug 2013 13:47:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] kmemcg: don't allocate extra memory for root
 memcg_cache_params
Message-Id: <20130814134710.ff123b0ea802efa7261d7e26@linux-foundation.org>
In-Reply-To: <1376476281-26559-1-git-send-email-avagin@openvz.org>
References: <1376476281-26559-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 14:31:21 +0400 Andrey Vagin <avagin@openvz.org> wrote:

> The memcg_cache_params structure contains the common part and the union,
> which represents two different types of data: one for root cashes and
> another for child caches.
> 
> The size of child data is fixed. The size of the memcg_caches array is
> calculated in runtime.
> 
> Currently the size of memcg_cache_params for root caches is calculated
> incorrectly, because it includes the size of parameters for child caches.
> 
> ssize_t size = memcg_caches_array_size(num_groups);
> size *= sizeof(void *);
> 
> size += sizeof(struct memcg_cache_params);
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3140,7 +3140,7 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>  		ssize_t size = memcg_caches_array_size(num_groups);
>  
>  		size *= sizeof(void *);
> -		size += sizeof(struct memcg_cache_params);
> +		size += sizeof(offsetof(struct memcg_cache_params, memcg_caches));

This looks wrong. offsetof() returns size_t, so this is equivalent to

		size += sizeof(size_t);

>  		s->memcg_params = kzalloc(size, GFP_KERNEL);
>  		if (!s->memcg_params) {
> @@ -3183,13 +3183,16 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>  int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
>  			 struct kmem_cache *root_cache)
>  {
> -	size_t size = sizeof(struct memcg_cache_params);
> +	size_t size;
>  
>  	if (!memcg_kmem_enabled())
>  		return 0;
>  
> -	if (!memcg)
> +	if (!memcg) {
> +		size = offsetof(struct memcg_cache_params, memcg_caches);
>  		size += memcg_limited_groups_array_size * sizeof(void *);
> +	} else
> +		size = sizeof(struct memcg_cache_params);
>  
>  	s->memcg_params = kzalloc(size, GFP_KERNEL);
>  	if (!s->memcg_params)

