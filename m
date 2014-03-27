Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbaC0Umk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 16:42:40 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44413 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbaC0Umi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 16:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <5333D527.2060208@parallels.com>
References: <cover.1395846845.git.vdavydov@parallels.com> <5a5b09d4cb9a15fc120b4bec8be168630a3b43c2.1395846845.git.vdavydov@parallels.com>
 <xr93fvm42rew.fsf@gthelen.mtv.corp.google.com> <5333D527.2060208@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 27 Mar 2014 13:42:17 -0700
Message-ID: <CAHH2K0YFB9yXF_oyxhQt9EiD_kuBuK7py6ah8YEy2H70P8SC_A@mail.gmail.com>
Subject: Re: [PATCH -mm 1/4] sl[au]b: do not charge large allocations to memcg
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, devel@openvz.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 12:37 AM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> Hi Greg,
>
> On 03/27/2014 08:31 AM, Greg Thelen wrote:
>> On Wed, Mar 26 2014, Vladimir Davydov <vdavydov@parallels.com> wrote:
>>
>>> We don't track any random page allocation, so we shouldn't track kmalloc
>>> that falls back to the page allocator.
>> This seems like a change which will leads to confusing (and arguably
>> improper) kernel behavior.  I prefer the behavior prior to this patch.
>>
>> Before this change both of the following allocations are charged to
>> memcg (assuming kmem accounting is enabled):
>>  a = kmalloc(KMALLOC_MAX_CACHE_SIZE, GFP_KERNEL)
>>  b = kmalloc(KMALLOC_MAX_CACHE_SIZE + 1, GFP_KERNEL)
>>
>> After this change only 'a' is charged; 'b' goes directly to page
>> allocator which no longer does accounting.
>
> Why do we need to charge 'b' in the first place? Can the userspace
> trigger such allocations massively? If there can only be one or two such
> allocations from a cgroup, is there any point in charging them?

Of the top of my head I don't know of any >8KIB kmalloc()s so I can't
say if they're directly triggerable by user space en masse.  But we
recently ran into some order:3 allocations in networking.  The
networking allocations used a non-generic kmem_cache (rather than
kmalloc which started this discussion).  For details, see ed98df3361f0
("net: use __GFP_NORETRY for high order allocations").  I can't say if
such allocations exist in device drivers, but given the networking
example, it's conceivable that they may (or will) exist.

With slab this isn't a problem because sla has kmalloc kmem_caches for
all supported allocation sizes.  However, slub shows this issue for
any kmalloc() allocations larger than 8KIB (at least on x86_64).  It
seems like a strange directly to take kmem accounting to say that
kmalloc allocations are kmem limited, but only if they are either less
than a threshold size or done with slab.  Simply increasing the size
of a data structure doesn't seem like it should automatically cause
the memory to become exempt from kmem limits.

> In fact, do we actually need to charge every random kmem allocation? I
> guess not. For instance, filesystems often allocate data shared among
> all the FS users. It's wrong to charge such allocations to a particular
> memcg, IMO. That said the next step is going to be adding a per kmem
> cache flag specifying if allocations from this cache should be charged
> so that accounting will work only for those caches that are marked so
> explicitly.

It's a question of what direction to approach kmem slab accounting
from: either opt-out (as the code currently is), or opt-in (with per
kmem_cache flags as you suggest).  I agree that some structures end up
being shared (e.g. filesystem block bit map structures).  In an
opt-out system these are charged to a memcg initially and remain
charged there until the memcg is deleted at which point the shared
objects are reparented to a shared location.  While this isn't
perfect, it's unclear if it's better or worse than analyzing each
class of allocation and deciding if they should be opt'd-in.  One
could (though I'm not) make the case that even dentries are easily
shareable between containers and thus shouldn't be accounted to a
single memcg.  But given user space's ability to DoS a machine with
dentires, they should be accounted.

> There is one more argument for removing kmalloc_large accounting - we
> don't have an easy way to track such allocations, which prevents us from
> reparenting kmemcg charges on css offline. Of course, we could link
> kmalloc_large pages in some sort of per-memcg list which would allow us
> to find them on css offline, but I don't think such a complication is
> justified.

I assume that reparenting of such non kmem_cache allocations (e.g.
large kmalloc) is difficult because such pages refer to the memcg,
which we're trying to delete and the memcg has no index of such pages.
 If such zombie memcg are undesirable, then an alternative to indexing
the pages is to define a kmem context object which such large pages
point to.  The kmem context would be reparented without needing to
adjust the individual large pages.  But there are plenty of options.
