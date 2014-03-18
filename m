Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaCRJ2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:28:53 -0400
Received: from relay.parallels.com ([195.214.232.42]:33812 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaCRJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:28:51 -0400
Message-ID: <532811D0.5070203@parallels.com>
Date: Tue, 18 Mar 2014 13:28:48 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH RESEND -mm 01/12] memcg: flush cache creation works before
 memcg cache destruction
References: <cover.1394708827.git.vdavydov@parallels.com> <4cccfcf74595f26532a6dda7264dc420df82fb8a.1394708827.git.vdavydov@parallels.com> <20140317160755.GB30623@dhcp22.suse.cz> <5328006D.5020802@parallels.com> <20140318085532.GB3191@dhcp22.suse.cz>
In-Reply-To: <20140318085532.GB3191@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 12:55 PM, Michal Hocko wrote:
> On Tue 18-03-14 12:14:37, Vladimir Davydov wrote:
>> On 03/17/2014 08:07 PM, Michal Hocko wrote:
>>> On Thu 13-03-14 19:06:39, Vladimir Davydov wrote:
>>>> When we get to memcg cache destruction, either from the root cache
>>>> destruction path or when turning memcg offline, there still might be
>>>> memcg cache creation works pending that was scheduled before we
>>>> initiated destruction. We need to flush them before starting to destroy
>>>> memcg caches, otherwise we can get a leaked kmem cache or, even worse,
>>>> an attempt to use after free.
>>> How can we use-after-free? Even if there is a pending work item to
>>> create a new cache then we keep the css reference for the memcg and
>>> release it from the worker (memcg_create_cache_work_func). So although
>>> this can race with memcg offlining the memcg itself will be still alive.
>> There are actually two issues:
>>
>> 1) When we destroy a root cache using kmem_cache_destroy(), we should
>> ensure all pending memcg creation works for this root cache are over,
>> otherwise a work could be executed after the root cache is destroyed
>> resulting in use-after-free.
> Dunno, but this sounds backwards to me. If we are using a root cache for
> a new child creation then the child should make sure that the root
> doesn't go away, no? Cannot we take a reference to the root cache before
> we schedule memcg_create_cache_work_func?

Yeah, that would work of course. We already have kmem_cache::refcount,
which is currently used for alias handling, and I guess we could reuse
it here. We would only have to make it atomic, because we can't take the
slab_mutex in memcg_kmem_get_cache(), but it shouldn't be a problem.

> But I admit that the root cache concept is not entirely clear to me.
>
>> 2) Memcg offline. In this case use-after-free is impossible in a memcg
>> creation work handler, because, as you mentioned, the work holds the css
>> reference. However, we still have to synchronize against pending
>> requests, otherwise a work handler can be executed after we destroyed
>> the caches corresponding to the memcg being offlined resulting in a
>> kmem_cache leak.
> If that is a case then we should come up with a proper synchronization
> because synchronization by workqueues and explicit flushing and
> canceling is really bad.

Would be something like this suitable as proper synchronization:

mem_cgroup_destroy_all_caches():
    /* currently we don't take the slab_mutex here,
     * so we'd have to add this line */
    take slab_mutex
    mark the memcg dead
    schedule the memcg's caches destruction
    release slab_mutex

kmem_cache_create_memcg():
    take slab_mutex
    if memcg is not dead, then create a cache
    release slab_mutex

?

Thanks.
