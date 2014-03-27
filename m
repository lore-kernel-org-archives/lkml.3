Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaC0HhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:37:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:47182 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaC0HhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:37:13 -0400
Message-ID: <5333D527.2060208@parallels.com>
Date: Thu, 27 Mar 2014 11:37:11 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <glommer@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <devel@openvz.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm 1/4] sl[au]b: do not charge large allocations to memcg
References: <cover.1395846845.git.vdavydov@parallels.com> <5a5b09d4cb9a15fc120b4bec8be168630a3b43c2.1395846845.git.vdavydov@parallels.com> <xr93fvm42rew.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93fvm42rew.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 03/27/2014 08:31 AM, Greg Thelen wrote:
> On Wed, Mar 26 2014, Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> We don't track any random page allocation, so we shouldn't track kmalloc
>> that falls back to the page allocator.
> This seems like a change which will leads to confusing (and arguably
> improper) kernel behavior.  I prefer the behavior prior to this patch.
>
> Before this change both of the following allocations are charged to
> memcg (assuming kmem accounting is enabled):
>  a = kmalloc(KMALLOC_MAX_CACHE_SIZE, GFP_KERNEL)
>  b = kmalloc(KMALLOC_MAX_CACHE_SIZE + 1, GFP_KERNEL)
>
> After this change only 'a' is charged; 'b' goes directly to page
> allocator which no longer does accounting.

Why do we need to charge 'b' in the first place? Can the userspace
trigger such allocations massively? If there can only be one or two such
allocations from a cgroup, is there any point in charging them?

In fact, do we actually need to charge every random kmem allocation? I
guess not. For instance, filesystems often allocate data shared among
all the FS users. It's wrong to charge such allocations to a particular
memcg, IMO. That said the next step is going to be adding a per kmem
cache flag specifying if allocations from this cache should be charged
so that accounting will work only for those caches that are marked so
explicitly.

There is one more argument for removing kmalloc_large accounting - we
don't have an easy way to track such allocations, which prevents us from
reparenting kmemcg charges on css offline. Of course, we could link
kmalloc_large pages in some sort of per-memcg list which would allow us
to find them on css offline, but I don't think such a complication is
justified.

Thanks.
