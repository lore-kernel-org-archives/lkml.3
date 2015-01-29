Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbbA2Icl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:32:41 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:37575 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbbA2Icj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:32:39 -0500
MIME-Version: 1.0
In-Reply-To: <20150128135752.afcb196d6ded7c16a79ed6fd@linux-foundation.org>
References: <cover.1422461573.git.vdavydov@parallels.com>
	<012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com>
	<20150128135752.afcb196d6ded7c16a79ed6fd@linux-foundation.org>
Date: Thu, 29 Jan 2015 14:02:38 +0530
Message-ID: <CAKTCnzmt6SkxzwmL=qk3ZfDqvFZ8E9OM-8gJmi+0kFsq6xNrvQ@mail.gmail.com>
Subject: Re: [PATCH -mm v2 1/3] slub: never fail to shrink cache
From: Balbir Singh <bsingharora@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 3:27 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 28 Jan 2015 19:22:49 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> SLUB's version of __kmem_cache_shrink() not only removes empty slabs,
>> but also tries to rearrange the partial lists to place slabs filled up
>> most to the head to cope with fragmentation. To achieve that, it
>> allocates a temporary array of lists used to sort slabs by the number of
>> objects in use. If the allocation fails, the whole procedure is aborted.
>>
>> This is unacceptable for the kernel memory accounting extension of the
>> memory cgroup, where we want to make sure that kmem_cache_shrink()
>> successfully discarded empty slabs. Although the allocation failure is
>> utterly unlikely with the current page allocator implementation, which
>> retries GFP_KERNEL allocations of order <= 2 infinitely, it is better
>> not to rely on that.
>>
>> This patch therefore makes __kmem_cache_shrink() allocate the array on
>> stack instead of calling kmalloc, which may fail. The array size is
>> chosen to be equal to 32, because most SLUB caches store not more than
>> 32 objects per slab page. Slab pages with <= 32 free objects are sorted
>> using the array by the number of objects in use and promoted to the head
>> of the partial list, while slab pages with > 32 free objects are left in
>> the end of the list without any ordering imposed on them.
>>
>> ...
>>
>> @@ -3375,51 +3376,56 @@ int __kmem_cache_shrink(struct kmem_cache *s)
>>       struct kmem_cache_node *n;
>>       struct page *page;
>>       struct page *t;
>> -     int objects = oo_objects(s->max);
>> -     struct list_head *slabs_by_inuse =
>> -             kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
>> +     LIST_HEAD(discard);
>> +     struct list_head promote[SHRINK_PROMOTE_MAX];
>
> 512 bytes of stack.  The call paths leading to __kmem_cache_shrink()
> are many and twisty.  How do we know this isn't a problem?
>
> The logic behind choosing "32" sounds rather rubbery.  What goes wrong
> if we use, say, "4"?

This much space in the stack may be fertile grounds for kernel stack
overflow code execution :) Another perspective could be that there
should be allocations that are not penalized to a particular cgroup
(from an accounting perspective), should come from the reserved  pool.

Balbir Singh.
