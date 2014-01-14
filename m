Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaANHXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:23:38 -0500
Received: from relay.parallels.com ([195.214.232.42]:56978 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:23:36 -0500
Message-ID: <52D4E5F2.5080205@parallels.com>
Date: Tue, 14 Jan 2014 11:23:30 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: shrink all slab objects if tight on memory
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com> <20140113150502.4505f661589a4a2d30e6f11d@linux-foundation.org>
In-Reply-To: <20140113150502.4505f661589a4a2d30e6f11d@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 03:05 AM, Andrew Morton wrote:
> On Sat, 11 Jan 2014 16:36:31 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> When reclaiming kmem, we currently don't scan slabs that have less than
>> batch_size objects (see shrink_slab_node()):
>>
>>         while (total_scan >= batch_size) {
>>                 shrinkctl->nr_to_scan = batch_size;
>>                 shrinker->scan_objects(shrinker, shrinkctl);
>>                 total_scan -= batch_size;
>>         }
>>
>> If there are only a few shrinkers available, such a behavior won't cause
>> any problems, because the batch_size is usually small, but if we have a
>> lot of slab shrinkers, which is perfectly possible since FS shrinkers
>> are now per-superblock, we can end up with hundreds of megabytes of
>> practically unreclaimable kmem objects. For instance, mounting a
>> thousand of ext2 FS images with a hundred of files in each and iterating
>> over all the files using du(1) will result in about 200 Mb of FS caches
>> that cannot be dropped even with the aid of the vm.drop_caches sysctl!
> True.  I suspect this was an accidental consequence of the chosen
> implementation.  As you mentioned, I was thinking that the caches would
> all be large, and the remaining 1 ..  SHRINK_BATCH-1 objects just
> didn't matter.
>
>> This problem was initially pointed out by Glauber Costa [*]. Glauber
>> proposed to fix it by making the shrink_slab() always take at least one
>> pass, to put it simply, turning the scan loop above to a do{}while()
>> loop. However, this proposal was rejected, because it could result in
>> more aggressive and frequent slab shrinking even under low memory
>> pressure when total_scan is naturally very small.
> Well, it wasn't "rejected" - Mel pointed out that Glauber's change
> could potentially trigger problems which already exist in shrinkers.
>
> The potential issues seem pretty unlikely to me, and they're things we
> can fix up if they eventuate.

When preparing this patch, I considered not the problems that
potentially exist in some shrinkers, but the issues that unconditional
scan of < batch_size objects might trigger for any shrinker:

1) We would call shrinkers more frequently, which could possibly
increase contention on shrinker-internal locks. The point is that under
very light memory pressure when we can fulfill the allocation request
after a few low-prio scans, we would not call slab shrinkers at all,
instead we would only add the delta to nr_deferred in order to keep
slab-vs-pagecache reclaim balanced. Original Glauber's patch changes
this behavior - it makes shrink_slab() always call the shrinker at least
once, even if the current delta is negligible. I'm afraid, this might
affect performance. Note, this is irrespective of how much objects the
shrinker has to reclaim (< or > batch_size).

2) As Mel Gorman pointed out
(http://thread.gmane.org/gmane.linux.kernel.mm/99059):

> It's possible for caches to shrink to zero where before the last
> SHRINK_SLAB objects would often be protected for any slab. If this is
> an inode or dentry cache and there are very few objects then it's
> possible that objects will be reclaimed before they can be used by the
> process allocating them.


> So I'm thinking we should at least try Glauber's approach - it's a bit
> weird that we should treat the final 0 ..  batch_size-1 objects in a
> different manner from all the others.

It's not exactly that we treat the final 0 .. batch_size-1 objects
differently from others. We rather try to accumulate at least batch_size
objects before calling ->scan().

> That being said, I think I'll schedule this patch as-is for 3.14.  Can
> you please take a look at implementing the simpler approach, send me
> something for 3.15-rc1?

IMHO the simpler approach (Glauber's patch) is not suitable as is,
because it, in fact, neglects the notion of batch_size when doing low
prio scans, because it calls ->scan() for < batch_size objects even if
the slab has >= batch_size objects while AFAIU it should accumulate a
sufficient number of objects to scan in nr_deferred instead.

Thanks.
