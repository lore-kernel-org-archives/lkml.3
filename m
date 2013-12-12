Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3LLNVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:21:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3LLNVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:21:15 -0500
Date: Thu, 12 Dec 2013 14:21:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Glauber Costa <glommer@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        devel@openvz.org, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Race in memcg kmem?
Message-ID: <20131212132113.GG2630@dhcp22.suse.cz>
References: <52A71E43.9040200@parallels.com>
 <CAA6-i6oyraHQ7_1GBKxgupS12_QFx708Niu93nyNFLrbQBXE5A@mail.gmail.com>
 <52A8048E.4020806@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A8048E.4020806@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-12-13 10:22:06, Vladimir Davydov wrote:
> On 12/11/2013 03:13 AM, Glauber Costa wrote:
> > On Tue, Dec 10, 2013 at 5:59 PM, Vladimir Davydov
[...]
> >> -- memcg_update_cache_size(s, num_groups) --
> >> grows s->memcg_params to accomodate data for num_groups memcg's
> >> @s is the root cache whose memcg_params we want to grow
> >> @num_groups is the new number of kmem-active cgroups (defines the new
> >> size of memcg_params array).
> >>
> >> The function:
> >>
> >> B1) allocates and assigns a new cache:
> >>     cur_params = s->memcg_params;
> >>     s->memcg_params = kzalloc(size, GFP_KERNEL);
> >>
> >> B2) copies per-memcg cache ptrs from the old memcg_params array to the
> >> new one:
> >>     for (i = 0; i < memcg_limited_groups_array_size; i++) {
> >>         if (!cur_params->memcg_caches[i])
> >>             continue;
> >>         s->memcg_params->memcg_caches[i] =
> >>                     cur_params->memcg_caches[i];
> >>     }
> >>
> >> B3) frees the old array:
> >>     kfree(cur_params);
> >>
> >>
> >> Since these two functions do not share any mutexes, we can get the
> > They do share a mutex, the slab mutex.

Worth sticking in a lock_dep_assert?

> >
> >> following race:
> >>
> >> Assume, by the time Cpu0 gets to memcg_create_kmem_cache(), the memcg
> >> cache has already been created by another thread, so this function
> >> should do nothing.
> >>
> >> Cpu0    Cpu1
> >> ----    ----
> >>         B1
> >> A1              we haven't initialized memcg_params yet so Cpu0 will
> >>                 proceed to A2 to alloc and assign a new cache
> >> A2
> >>         B2      Cpu1 rewrites the memcg cache ptr set by Cpu0 at A2
> >>                 - a memory leak?
> >>         B3
> >>
> >> I'd like to add that even if I'm right about the race, this is rather
> >> not critical, because memcg_update_cache_sizes() is called very rarely.
> >>
> > Every race is critical.
> >
> > So, I am a bit lost by your description. Get back to me if I got anything wrong,
> > but I am think that the point that you're missing is that all heavy
> > slab operations
> > take the slab_mutex underneath, and that includes cache creation and update.
> >
> >
> >> BTW, it seems to me that the way we update memcg_params in
> >> memcg_update_cache_size() make cache_from_memcg_idx() prone to
> >> use-after-free:
> >>
> >>> static inline struct kmem_cache *
> >>> cache_from_memcg_idx(struct kmem_cache *s, int idx)
> >>> {
> >>>     if (!s->memcg_params)
> >>>         return NULL;
> >>>     return s->memcg_params->memcg_caches[idx];
> >>> }
> >> This is equivalent to
> >>
> >> 1) struct memcg_cache_params *params = s->memcg_params;
> >> 2) return params->memcg_caches[idx];
> >>
> >> If memcg_update_cache_size() is executed between steps 1 and 2 on
> >> another CPU, at step 2 we will dereference memcg_params that has already
> >> been freed. This is very unlikely, but still possible. Perhaps, we
> >> should free old memcg params only after a sync_rcu()?
> >>
> > You seem to be right in this one. Indeed, if my mind does not betray
> > me, That is how I freed
> > the LRUs. (with synchronize_rcus).
> 
> Yes, you freed LRUs only after a sync_rcu, that's why the way
> memcg_params is updated looks suspicious to me. I'll try to fix it then.

I have quickly glanced through cache_from_memcg_idx users and the
locking is quite inconsistent.
* mem_cgroup_slabinfo_read - memcg->slab_caches_mutex
* memcg_create_kmem_cache - memcg_cache_mutex
* kmem_cache_destroy_memcg_children - set_limit_mutex
* __memcg_kmem_get_cache - RCU read lock

I was afraid to go further...

memcg_update_cache_size and kmem_cache_create_memcg seem to be the only
who touch memcg_params and they rely on slab_mutex. The later one is
touching a cache which is not visible yet so it should be safe.

I didn't look closer at all the callers of cache_from_memcg_idx but I
guess we want to use RCU here.
-- 
Michal Hocko
SUSE Labs
