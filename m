Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3LSKXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:23:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52817 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab3LSKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:23:45 -0500
X-Sasl-enc: iOYOlD+XjIXzYv726LlEI1kUZzZpVnu1mn+tX5fqxUx3 1387448624
Message-ID: <52B2C92D.2020301@iki.fi>
Date: Thu, 19 Dec 2013 12:23:41 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Vasily Averin <vvs@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@gmail.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        cgroups@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org
Subject: Re: [Devel] [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com> <52B2AB7C.1010803@parallels.com> <52B2B0A4.8050009@parallels.com> <52B2BBB4.3090209@parallels.com>
In-Reply-To: <52B2BBB4.3090209@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 11:26 AM, Vasily Averin wrote:
> On 12/19/2013 12:39 PM, Vladimir Davydov wrote:
>> On 12/19/2013 12:17 PM, Vasily Averin wrote:
>>> On 12/18/2013 05:16 PM, Vladimir Davydov wrote:
>>>> --- a/mm/slab_common.c
>>>> +++ b/mm/slab_common.c
>>>> @@ -176,8 +176,9 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
>>>>   	get_online_cpus();
>>>>   	mutex_lock(&slab_mutex);
>>>>   
>>>> -	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
>>>> -		goto out_locked;
>>>> +	err = kmem_cache_sanity_check(memcg, name, size);
>>>> +	if (err)
>>>> +		goto out_unlock;
>>>>   
>>>>   	/*
>>>>   	 * Some allocators will constraint the set of valid flags to a subset
>>> Theoretically in future kmem_cache_sanity_check() can return positive value.
>>> Probably it's better to check (err < 0) in caller ?
>> Hmm, why? What information could positive retval carry here? We have
>> plenty of places throughout the code where we check for (err), not
>> (err<0), simply because it looks clearer, e.g. look at
>> __kmem_cache_create() calls. If it returns a positive value one day, we
>> will have to parse every place where it's called. Anyway, if someone
>> wants to change a function behavior, he must check every place where
>> this function is called and fix them accordingly.
> I believe expected semantic of function -- return negative in case of error.
> So correct error cheek should be (err < 0).
> (err) check is semantically incorrect, and it can lead to troubles in future.

I don't know what semantics you are referring to but a typical 
convention in mm/*.c is to return zero on success and negative on error 
but never positive numbers.

Looking at mm/slab_common.c, "if (err)" is the established convention so 
using "if (err < 0)" just because is pointless here.

                             Pekka
