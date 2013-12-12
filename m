Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LLNjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:39:48 -0500
Received: from relay.parallels.com ([195.214.232.42]:45818 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3LLNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:39:43 -0500
Message-ID: <52A9BC91.5020105@parallels.com>
Date: Thu, 12 Dec 2013 17:39:29 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Race in memcg kmem?
References: <52A71E43.9040200@parallels.com> <CAA6-i6oyraHQ7_1GBKxgupS12_QFx708Niu93nyNFLrbQBXE5A@mail.gmail.com> <52A8048E.4020806@parallels.com> <20131212132113.GG2630@dhcp22.suse.cz>
In-Reply-To: <20131212132113.GG2630@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 05:21 PM, Michal Hocko wrote:
> On Wed 11-12-13 10:22:06, Vladimir Davydov wrote:
>> On 12/11/2013 03:13 AM, Glauber Costa wrote:
>>> On Tue, Dec 10, 2013 at 5:59 PM, Vladimir Davydov
> [...]
>>>> -- memcg_update_cache_size(s, num_groups) --
>>>> grows s->memcg_params to accomodate data for num_groups memcg's
>>>> @s is the root cache whose memcg_params we want to grow
>>>> @num_groups is the new number of kmem-active cgroups (defines the new
>>>> size of memcg_params array).
>>>>
>>>> The function:
>>>>
>>>> B1) allocates and assigns a new cache:
>>>>     cur_params = s->memcg_params;
>>>>     s->memcg_params = kzalloc(size, GFP_KERNEL);
>>>>
>>>> B2) copies per-memcg cache ptrs from the old memcg_params array to the
>>>> new one:
>>>>     for (i = 0; i < memcg_limited_groups_array_size; i++) {
>>>>         if (!cur_params->memcg_caches[i])
>>>>             continue;
>>>>         s->memcg_params->memcg_caches[i] =
>>>>                     cur_params->memcg_caches[i];
>>>>     }
>>>>
>>>> B3) frees the old array:
>>>>     kfree(cur_params);
>>>>
>>>>
>>>> Since these two functions do not share any mutexes, we can get the
>>> They do share a mutex, the slab mutex.
> Worth sticking in a lock_dep_assert?

AFAIU, lockdep_assert_held() is not applicable here:
memcg_create_kmem_cache() is called w/o the slab_mutex held, but it
calls kmem_cache_create_kmemcg(), which takes and releases this mutex,
working as a barrier. Placing lockdep_assert_held() into the latter
won't make things any clearer. IMO, we need a big good comment in
memcg_create_kmem_cache() proving its correctness.

Thanks.
