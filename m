Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaKDJAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:00:11 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35795 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaKDJAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:00:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141104075330.GB23102@bbox>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <543F8812.2020002@codeaurora.org> <5450FD15.4000708@suse.cz> <20141104075330.GB23102@bbox>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 4 Nov 2014 16:59:24 +0800
Message-ID: <CANFwon3rM+2pA_hiQ=cnv53kHkC+hAbVi3pvhVDNytr20qC=ww@mail.gmail.com>
Subject: Re: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive
 about allocation
To: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Laura Abbott <lauraa@codeaurora.org>,
        Hui Zhu <zhuhui@xiaomi.com>, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, m.szyprowski@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>, mina86@mina86.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, Rik van Riel <riel@redhat.com>, mgorman@suse.de,
        nasa4836@gmail.com, ddstreet@ieee.org, Hugh Dickins <hughd@google.com>,
        mingo@kernel.org, rientjes@google.com,
        Peter Zijlstra <peterz@infradead.org>, keescook@chromium.org,
        atomlin@redhat.com, raistlin@linux.it, axboe@fb.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com,
        k.khlebnikov@samsung.com, msalter@redhat.com, deller@gmx.de,
        tangchen@cn.fujitsu.com, ben@decadent.org.uk, akinobu.mita@gmail.com,
        sasha.levin@oracle.com, vdavydov@parallels.com, suleiman@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 3:53 PM, Minchan Kim <minchan@kernel.org> wrote:
> Hello,
>
> On Wed, Oct 29, 2014 at 03:43:33PM +0100, Vlastimil Babka wrote:
>> On 10/16/2014 10:55 AM, Laura Abbott wrote:
>> >On 10/15/2014 8:35 PM, Hui Zhu wrote:
>> >
>> >It's good to see another proposal to fix CMA utilization. Do you have
>> >any data about the success rate of CMA contiguous allocation after
>> >this patch series? I played around with a similar approach of using
>> >CMA for MIGRATE_MOVABLE allocations and found that although utilization
>> >did increase, contiguous allocations failed at a higher rate and were
>> >much slower. I see what this series is trying to do with avoiding
>> >allocation from CMA pages when a contiguous allocation is progress.
>> >My concern is that there would still be problems with contiguous
>> >allocation after all the MIGRATE_MOVABLE fallback has happened.
>>
>> Hi,
>>
>> did anyone try/suggest the following idea?
>>
>> - keep CMA as fallback to MOVABLE as is is now, i.e. non-agressive
>> - when UNMOVABLE (RECLAIMABLE also?) allocation fails and CMA
>> pageblocks have space, don't OOM immediately, but first try to
>> migrate some MOVABLE pages to CMA pageblocks, to make space for the
>> UNMOVABLE allocation in non-CMA pageblocks
>> - this should keep CMA pageblocks free as long as possible and
>> useful for CMA allocations, but without restricting the non-MOVABLE
>> allocations even though there is free memory (but in CMA pageblocks)
>> - the fact that a MOVABLE page could be successfully migrated to CMA
>> pageblock, means it was not pinned or otherwise non-migratable, so
>> there's a good chance it can be migrated back again if CMA
>> pageblocks need to be used by CMA allocation
>
> I suggested exactly same idea long time ago.
>
>> - it's more complex, but I guess we have most of the necessary
>> infrastructure in compaction already :)
>
> I agree but still, it doesn't solve reclaim problem(ie, VM doesn't
> need to reclaim CMA pages when memory pressure of unmovable pages
> happens). Of course, we could make VM be aware of that via introducing
> new flag of __isolate_lru_page.
>
> However, I'd like to think CMA design from the beginning.
> It made page allocation logic complicated, even very fragile as we
> had recently and now we need to add new logics to migrate like you said.
> As well, we need to fix reclaim path, too.
>
> It makes mm complicated day by day even though it doesn't do the role
> enough well(ie, big latency and frequent allocation failure) so I really
> want to stop making the mess bloated.
>
> Long time ago, when I saw Joonsoo's CMA agressive allocation patchset
> (ie, roundrobin allocation between CMA and normal movable pages)
> it was good to me at a first glance but it needs tweak of allocation
> path and doesn't solve reclaim path, either. Yes, reclaim path could
> be solved by another patch but I want to solve it altogether.
>
> At that time, I suggested big surgery to Joonsoo in offline that
> let's move CMA allocation with movable zone allocation. With it,
> we could make allocation/reclaim path simple but thing is we should
> make VM be aware of overlapping MOVABLE zone which means some of pages
> in the zone could be part of another zones but I think we already have
> logics to handle it when I read comment in isolate_freepages so I think
> the design should work.

Thanks.

>
> A thing you guys might worry is bigger CMA latency because it makes
> CMA memory usage ratio higher than the approach you mentioned but
> anyone couldn't guarantee it once memory is fully utilized.
> In addition, we have used fair zone allocator policy so it makes
> round robin allocation automatically so I believe it should be way
> to go.

Even if kernel use it to allocate the CMA memory, CMA alloc latency
will happen if most of memory is allocated and driver try to get CMA
memory.
https://lkml.org/lkml/2014/10/17/129
https://lkml.org/lkml/2014/10/17/130
These patches let cma_alloc do a shrink with function
shrink_all_memory_for_cma if need.  It handle a lot of latency issue
in my part.
And I think it can be more configurable for example some device use it
and others not.

Thanks,
Hui



>
>>
>> Thoughts?
>> Vlastimil
>>
>> >Thanks,
>> >Laura
>> >
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> Kind regards,
> Minchan Kim
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
