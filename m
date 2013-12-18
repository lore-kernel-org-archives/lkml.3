Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3LRHvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:51:44 -0500
Received: from relay.parallels.com ([195.214.232.42]:58875 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LRHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:51:43 -0500
Message-ID: <52B15402.4060907@parallels.com>
Date: Wed, 18 Dec 2013 11:51:30 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@gmail.com>, Balbir Singh <bsingharora@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [Devel] Race in memcg kmem?
References: <52A71E43.9040200@parallels.com> <CAA6-i6oyraHQ7_1GBKxgupS12_QFx708Niu93nyNFLrbQBXE5A@mail.gmail.com> <52A8048E.4020806@parallels.com> <20131212132113.GG2630@dhcp22.suse.cz> <52A9BC91.5020105@parallels.com>
In-Reply-To: <52A9BC91.5020105@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 05:39 PM, Vladimir Davydov wrote:
> On 12/12/2013 05:21 PM, Michal Hocko wrote:
>> On Wed 11-12-13 10:22:06, Vladimir Davydov wrote:
>>> On 12/11/2013 03:13 AM, Glauber Costa wrote:
>>>> On Tue, Dec 10, 2013 at 5:59 PM, Vladimir Davydov
>> [...]
>>>>> -- memcg_update_cache_size(s, num_groups) --
>>>>> grows s->memcg_params to accomodate data for num_groups memcg's
>>>>> @s is the root cache whose memcg_params we want to grow
>>>>> @num_groups is the new number of kmem-active cgroups (defines the new
>>>>> size of memcg_params array).
>>>>>
>>>>> The function:
>>>>>
>>>>> B1) allocates and assigns a new cache:
>>>>>     cur_params = s->memcg_params;
>>>>>     s->memcg_params = kzalloc(size, GFP_KERNEL);
>>>>>
>>>>> B2) copies per-memcg cache ptrs from the old memcg_params array to the
>>>>> new one:
>>>>>     for (i = 0; i < memcg_limited_groups_array_size; i++) {
>>>>>         if (!cur_params->memcg_caches[i])
>>>>>             continue;
>>>>>         s->memcg_params->memcg_caches[i] =
>>>>>                     cur_params->memcg_caches[i];
>>>>>     }
>>>>>
>>>>> B3) frees the old array:
>>>>>     kfree(cur_params);
>>>>>
>>>>>
>>>>> Since these two functions do not share any mutexes, we can get the
>>>> They do share a mutex, the slab mutex.
>> Worth sticking in a lock_dep_assert?
> AFAIU, lockdep_assert_held() is not applicable here:
> memcg_create_kmem_cache() is called w/o the slab_mutex held, but it
> calls kmem_cache_create_kmemcg(), which takes and releases this mutex,
> working as a barrier. Placing lockdep_assert_held() into the latter
> won't make things any clearer. IMO, we need a big good comment in
> memcg_create_kmem_cache() proving its correctness.

After a bit of thinking on the comment explaining why the race is
impossible I seem to have found another one in these two functions.

Assume two threads schedule kmem_cache creation works for the same
kmem_cache of the same memcg from __memcg_kmem_get_cache(). One of the
works successfully creates it. Another work should fail then, but if it
interleaves with memcg_update_cache_size() as follows, it does not:

memcg_create_kmem_cache()                       memcg_update_cache_size()
(called w/o mutexes held)                       (called with slab_mutex
held)
-------------------------                       -------------------------
mutex_lock(&memcg_cache_mutex)
                                                s->memcg_params=kzalloc(...)
new_cachep=cache_from_memcg_idx(cachep,idx)
// new_cachep==NULL => proceed to creation
                                                // initialize
s->memcg_params;
                                                // sets s->memcg_params
                                                //       
->memcg_caches[idx]
new_cachep = kmem_cache_dup(memcg, cachep)
// nothing prevents kmem_cache_dup from
// succeeding so ...
cachep->memcg_params->memcg_caches[idx]=new_cachep
// we've overwritten an existing cache ptr!

slab_mutex won't help here...

Anyway, I'm going to move check and initialization of memcg_caches[idx]
from memcg_create_kmem_cache() to kmem_cache_create_memcg() under the
slab_mutex eliminating every possibility of race there. Will send the
patch soon.

Thanks.
