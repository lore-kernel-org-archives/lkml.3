Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaBFSoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:44:01 -0500
Received: from relay.parallels.com ([195.214.232.42]:55744 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbaBFSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:43:59 -0500
Message-ID: <52F3D7E8.2090602@parallels.com>
Date: Thu, 6 Feb 2014 22:43:52 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <akpm@linux-foundation.org>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH v2 3/7] memcg, slab: separate memcg vs root cache creation
 paths
References: <cover.1391441746.git.vdavydov@parallels.com> <81a403327163facea2b4c7b720fdc0ef62dd1dbf.1391441746.git.vdavydov@parallels.com> <20140204160336.GL4890@dhcp22.suse.cz> <52F13D3C.801@parallels.com> <20140206164135.GK20269@dhcp22.suse.cz> <52F3C293.3060400@parallels.com> <20140206181735.GA2137@dhcp22.suse.cz>
In-Reply-To: <20140206181735.GA2137@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 10:17 PM, Michal Hocko wrote:
> On Thu 06-02-14 21:12:51, Vladimir Davydov wrote:
>> On 02/06/2014 08:41 PM, Michal Hocko wrote:
> [...]
>>>> +int kmem_cache_create_memcg(struct mem_cgroup *memcg, struct kmem_cache *cachep)
>>>>  {
>>>> -	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor, NULL);
>>>> +	struct kmem_cache *s;
>>>> +	int err;
>>>> +
>>>> +	get_online_cpus();
>>>> +	mutex_lock(&slab_mutex);
>>>> +
>>>> +	/*
>>>> +	 * Since per-memcg caches are created asynchronously on first
>>>> +	 * allocation (see memcg_kmem_get_cache()), several threads can try to
>>>> +	 * create the same cache, but only one of them may succeed.
>>>> +	 */
>>>> +	err = -EEXIST;
>>> Does it make any sense to report the error here? If we are racing then at
>>> least on part wins and the work is done.
>> Yeah, you're perfectly right. It's better to return 0 here.
> Why not void?

Yeah, better to make it void for now, just to keep it clean. I guess if
one day we need an error code there (for accounting of error reporting),
we'll add it then, but currently there is no point in that.

>
>>> We should probably warn about errors which prevent from accounting but
>>> I do not think there is much more we can do so returning an error code
>>> from this function seems pointless. memcg_create_cache_work_func ignores
>>> the return value anyway.
>> I do not think warnings are appropriate here, because it is not actually
>> an error if we are short on memory and can't do proper memcg accounting
>> due to this. Perhaps, we'd better add fail counters for memcg cache
>> creations and/or accounting to the root cache instead of memcg's one.
>> That would be useful for debugging. I'm not sure though.
> warn on once per memcg would be probably sufficient but it would still
> be great if an admin could see that a memcg is not accounted although it
> is supposed to be. Scanning all the memcgs might be really impractical.
> We do not fail allocations needed for those object in the real life now
> but we shouldn't rely on that.

Hmm, an alert in dmesg first time kmem_cache_create_memcg() fails for a
particular memcg, just to draw attention, plus accounting of total
number of failures for each memcg so that admin could check if it's a
real problem... Sounds reasonable to me. I guess I'll handle it in a
separate patch a bit later.

Thanks.
