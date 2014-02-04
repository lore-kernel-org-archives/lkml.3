Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaBDQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:04:57 -0500
Received: from relay.parallels.com ([195.214.232.42]:52166 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaBDQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:04:43 -0500
Message-ID: <52F10F95.4050204@parallels.com>
Date: Tue, 4 Feb 2014 20:04:37 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 3/8] memcg, slab: never try to merge memcg caches
References: <cover.1391356789.git.vdavydov@parallels.com> <27c4e7d7fb6b788b66995d2523225ef2dcbc6431.1391356789.git.vdavydov@parallels.com> <20140204145210.GH4890@dhcp22.suse.cz> <52F1004B.90307@parallels.com> <20140204151145.GI4890@dhcp22.suse.cz> <52F106D7.3060802@parallels.com> <CAA6-i6p0xPFxPpdM5Q_0Y_HZDdeLO1j4_SDPdZiiPXOZS8dg_g@mail.gmail.com>
In-Reply-To: <CAA6-i6p0xPFxPpdM5Q_0Y_HZDdeLO1j4_SDPdZiiPXOZS8dg_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 07:43 PM, Glauber Costa wrote:
> On Tue, Feb 4, 2014 at 7:27 PM, Vladimir Davydov <vdavydov@parallels.com> wrote:
>> On 02/04/2014 07:11 PM, Michal Hocko wrote:
>>> On Tue 04-02-14 18:59:23, Vladimir Davydov wrote:
>>>> On 02/04/2014 06:52 PM, Michal Hocko wrote:
>>>>> On Sun 02-02-14 20:33:48, Vladimir Davydov wrote:
>>>>>> Suppose we are creating memcg cache A that could be merged with cache B
>>>>>> of the same memcg. Since any memcg cache has the same parameters as its
>>>>>> parent cache, parent caches PA and PB of memcg caches A and B must be
>>>>>> mergeable too. That means PA was merged with PB on creation or vice
>>>>>> versa, i.e. PA = PB. From that it follows that A = B, and we couldn't
>>>>>> even try to create cache B, because it already exists - a contradiction.
>>>>> I cannot tell I understand the above but I am totally not sure about the
>>>>> statement bellow.
>>>>>
>>>>>> So let's remove unused code responsible for merging memcg caches.
>>>>> How come the code was unused? find_mergeable called cache_match_memcg...
>>>> Oh, sorry for misleading comment. I mean the code handling merging of
>>>> per-memcg caches is useless, AFAIU: if we find an alias for a per-memcg
>>>> cache on kmem_cache_create_memcg(), the parent of the found alias must
>>>> be the same as the parent_cache passed to kmem_cache_create_memcg(), but
>>>> if it were so, we would never proceed to the memcg cache creation,
>>>> because the cache we want to create already exists.
>>> I am still not sure I understand this correctly. So the outcome of this
>>> patch is that compatible caches of different memcgs can be merged
>>> together? Sorry if this is a stupid question but I am not that familiar
>>> with this area much I am just seeing that cache_match_memcg goes away
>>> and my understanding of the function is that it should prevent from
>>> different memcg's caches merging.
>> Let me try to explain how I understand it.
>>
>> What is cache merging/aliasing? When we create a cache
>> (kmem_cache_create()), we first try to find a compatible cache that
>> already exists and can handle requests from the new cache. If it is, we
>> do not create any new caches, instead we simply increment the old cache
>> refcount and return it.
>>
>> What about memcgs? Currently, it operates in the same way, i.e. on memcg
>> cache creation we also try to find a compatible cache of the same memcg
>> first. But if there were such a cache, they parents would have been
>> merged (i.e. it would be the same cache). That means we would not even
>> get to this memcg cache creation, because it already exists. That's why
>> the code handling memcg caches merging seems pointless to me.
>>
> IIRC, this may not always hold. Some of the properties are configurable via
> sysfs, and it might be that you haven't merged two parent caches because they
> properties differ, but would be fine merging the child caches.
>
> If all properties we check are compile-time parameters, then it should be okay.

AFAIK, we decide if a cache should be merged only basing on its internal
parameters, such as size, ctor, flags, align (see find_mergeable()), but
they are the same for root and memcg caches.

The only way to disable slub merging is via the "slub_nomerge" kernel
parameter, so it is impossible to get a situation when parents can not
be merged, while children can.

The only point of concern may be so called boot caches
(create_boot_cache()), which are forcefully not allowed to be merged by
setting refcount = -1. There are actually only two of them kmem_cache
and kmem_cache_node used for internal slub allocations. I guess it was
done preliminary, and we should not merge them for memcgs neither.

To sum it up, if a particular root cache is allowed to be merged, it was
allowed to be merged since its creation and all its children caches are
also allowed to be merged. If merging was not allowed for a root cache
when it was created, we should not merge its children caches.

Thanks.
