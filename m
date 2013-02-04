Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3BDIju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:39:50 -0500
Received: from mx2.parallels.com ([64.131.90.16]:43804 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab3BDIjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:39:49 -0500
Message-ID: <510F73E8.50201@parallels.com>
Date: Mon, 4 Feb 2013 12:40:08 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: stop warning on memcg_propagate_kmem
References: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils> <20130204075732.GA2556@dhcp22.suse.cz> <510F6B76.3080605@parallels.com> <20130204083658.GB2556@dhcp22.suse.cz>
In-Reply-To: <20130204083658.GB2556@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 12:36 PM, Michal Hocko wrote:
> On Mon 04-02-13 12:04:06, Glauber Costa wrote:
>> On 02/04/2013 11:57 AM, Michal Hocko wrote:
>>> On Sun 03-02-13 20:29:01, Hugh Dickins wrote:
>>>> Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
>>>> I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
>>>> "mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
>>>> used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.
>>>>
>>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>>
>>> Acked-by: Michal Hocko <mhocko@suse.cz>
>>>
>>> Hmm, if you are not too tired then moving the function downwards to
>>> where it is called (memcg_init_kmem) will reduce the number of ifdefs.
>>> But this can wait for a bigger clean up which is getting due:
>>> git grep "def.*CONFIG_MEMCG_KMEM" mm/memcontrol.c | wc -l
>>> 12
>>>
>>
>> The problem is that I was usually keeping things in clearly separated
>> blocks, like this :
>>
>> #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
>>         struct tcp_memcontrol tcp_mem;
>> #endif
>> #if defined(CONFIG_MEMCG_KMEM)
>>         /* analogous to slab_common's slab_caches list. per-memcg */
>>         struct list_head memcg_slab_caches;
>>         /* Not a spinlock, we can take a lot of time walking the list */
>>         struct mutex slab_caches_mutex;
>>         /* Index in the kmem_cache->memcg_params->memcg_caches array */
>>         int kmemcg_id;
>> #endif
>>
>> If it would be preferable to everybody, this could be easily rewritten as:
>>
>> #if defined(CONFIG_MEMCG_KMEM)
>> #if defined(CONFIG_INET)
>>         struct tcp_memcontrol tcp_mem;
>> #endif
>>         /* analogous to slab_common's slab_caches list. per-memcg */
>>         struct list_head memcg_slab_caches;
>>         /* Not a spinlock, we can take a lot of time walking the list */
>>         struct mutex slab_caches_mutex;
>>         /* Index in the kmem_cache->memcg_params->memcg_caches array */
>>         int kmemcg_id;
>> #endif
> 
> I was rather interested in reducing CONFIG_KMEM block, the above example
> doesn't bother me that much.
>  
>> This would allow us to collapse some blocks a bit down as well.
>>
>> It doesn't bother me *that* much, though.
> 
> Yes and a quick attempt shows that a clean up would bring a lot of
> churn.
> 
And some of it, because there are circular dependencies. So we would
have to start adding forward declarations here and there to make it all
work. That is part of the reason why I kept the blocks separate.
