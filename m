Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3BDIDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:03:47 -0500
Received: from mx2.parallels.com ([64.131.90.16]:42953 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3BDIDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:03:46 -0500
Message-ID: <510F6B76.3080605@parallels.com>
Date: Mon, 4 Feb 2013 12:04:06 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: stop warning on memcg_propagate_kmem
References: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils> <20130204075732.GA2556@dhcp22.suse.cz>
In-Reply-To: <20130204075732.GA2556@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 11:57 AM, Michal Hocko wrote:
> On Sun 03-02-13 20:29:01, Hugh Dickins wrote:
>> Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
>> I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
>> "mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
>> used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.
>>
>> Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Hmm, if you are not too tired then moving the function downwards to
> where it is called (memcg_init_kmem) will reduce the number of ifdefs.
> But this can wait for a bigger clean up which is getting due:
> git grep "def.*CONFIG_MEMCG_KMEM" mm/memcontrol.c | wc -l
> 12
> 

The problem is that I was usually keeping things in clearly separated
blocks, like this :

#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
        struct tcp_memcontrol tcp_mem;
#endif
#if defined(CONFIG_MEMCG_KMEM)
        /* analogous to slab_common's slab_caches list. per-memcg */
        struct list_head memcg_slab_caches;
        /* Not a spinlock, we can take a lot of time walking the list */
        struct mutex slab_caches_mutex;
        /* Index in the kmem_cache->memcg_params->memcg_caches array */
        int kmemcg_id;
#endif

If it would be preferable to everybody, this could be easily rewritten as:

#if defined(CONFIG_MEMCG_KMEM)
#if defined(CONFIG_INET)
        struct tcp_memcontrol tcp_mem;
#endif
        /* analogous to slab_common's slab_caches list. per-memcg */
        struct list_head memcg_slab_caches;
        /* Not a spinlock, we can take a lot of time walking the list */
        struct mutex slab_caches_mutex;
        /* Index in the kmem_cache->memcg_params->memcg_caches array */
        int kmemcg_id;
#endif

This would allow us to collapse some blocks a bit down as well.

It doesn't bother me *that* much, though.

> Thanks
>> ---
>>
>>  mm/memcontrol.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- 3.8-rc6/mm/memcontrol.c	2012-12-22 09:43:27.628015582 -0800
>> +++ linux/mm/memcontrol.c	2013-02-02 16:56:06.188325771 -0800
>> @@ -4969,6 +4969,7 @@ out:
>>  	return ret;
>>  }
>>  
>> +#ifdef CONFIG_MEMCG_KMEM
>>  static int memcg_propagate_kmem(struct mem_cgroup *memcg)
>>  {
>>  	int ret = 0;
>> @@ -4977,7 +4978,6 @@ static int memcg_propagate_kmem(struct m
>>  		goto out;
>>  
>>  	memcg->kmem_account_flags = parent->kmem_account_flags;
>> -#ifdef CONFIG_MEMCG_KMEM
>>  	/*
>>  	 * When that happen, we need to disable the static branch only on those
>>  	 * memcgs that enabled it. To achieve this, we would be forced to
>> @@ -5003,10 +5003,10 @@ static int memcg_propagate_kmem(struct m
>>  	mutex_lock(&set_limit_mutex);
>>  	ret = memcg_update_cache_sizes(memcg);
>>  	mutex_unlock(&set_limit_mutex);
>> -#endif
>>  out:
>>  	return ret;
>>  }
>> +#endif /* CONFIG_MEMCG_KMEM */
>>  
>>  /*
>>   * The user of this function is...
> 

