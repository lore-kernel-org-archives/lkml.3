Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaKFNDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:03:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaKFNDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:03:38 -0500
Message-ID: <545B71A8.6030209@suse.cz>
Date: Thu, 06 Nov 2014 14:03:36 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com> <20141105001026.GQ13232@auth.logic.tuwien.ac.at> <20141105001243.GR13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com> <545B68C9.2060107@suse.cz> <20141106123904.GU11838@auth.logic.tuwien.ac.at>
In-Reply-To: <20141106123904.GU11838@auth.logic.tuwien.ac.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 01:39 PM, Norbert Preining wrote:
> Hi Vlastimil
> 
> thanks for your answer.
> 
> In the meantime I have tried rc3, too, with the same effects.
> 
> Interestingly, once it goes into a bad state, every future approach
> does the same. I started shotwell (photo organizer) and it went into the
> same state (khugepaged / shotwell each using about 100% of CPu time).
> 
> On Thu, 06 Nov 2014, Vlastimil Babka wrote:
>> Could be that another task holds the mmap_sem during THP allocation attempt on
>> its own page fault, and compaction goes in some kind of infinite loop. There are
> 
> My feeling somehow is about the plugin-container in firefox ...
> (flashplayer or something similar, but I might be wrong!). With shotwell,
> I have no idea why.

plugin-container is different process than firefox, so it should show its CPU
consumption separately. If you see firefox, it's firefox binary itself.

>> I suggested testing a commit revert in one thread, and a possible fix in the
>> other. If you can reproduce this well, that would be very useful.
> 
> Which commit are you talking about? I can easily revert some/all of what you
> want and do test runs.

OK, one possibility is to do (it should apply cleanly)
git revert e14c720efdd73c6d69cd8d07fa894bcd11fe1973

Then there's a patch at the end of this e-mail, which however I doubt would fix
the symptoms you describe.
 

>> khugepaged using CPU also points to either the address space scanning, or
>> compaction going wrong. Since 8b1645685ac it shouldn't hold mmap_sem during
>> compaction, but that still leaves page faulters to possibly hold it.
> 
> So, do you mean I should try reverting 8b1645685ac?

No, not that one. That one should actually reduce the problem you see.

>> So yeah we would need the stacks of processes that do hog the CPU's, not those
>> that sleep. As David suggested, a /proc/pid/stack could work. Also can you
>> please provide /proc/zoneinfo ?
> 
> Again, as I mentioned, I don't have /proc/pid/stack for any "pid", is
> this depending on some specific kerenl option?

Ah I missed that. Should be CONFIG_STACKTRACE to enable that.
 
> /proc/zoneinfo I have and can send you the next time.
> 
> Thanks a lot and all the best

Great, thank you!
Vlastimil

> Norbert
> 
> ------------------------------------------------------------------------
> PREINING, Norbert                               http://www.preining.info
> JAIST, Japan                                 TeX Live & Debian Developer
> GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
> ------------------------------------------------------------------------
> 

------8<------
>From fe9c963cc665cdab50abb41f3babb5b19d08fab1 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 5 Nov 2014 14:19:18 +0100
Subject: [PATCH] mm, compaction: do not reset deferred compaction
 optimistically

In try_to_compact_pages() we reset deferred compaction for a zone where we
think compaction has succeeded. Although this action does not reset the
counters affecting deferred compaction period, just bumping the deferred order
means that another compaction attempt will be able to pass the check in
compaction_deferred() and proceed with compaction.

This is a problem when try_to_compact_pages() thinks compaction was successful
just because the watermark check is missing proper classzone_idx parameter,
but then the allocation attempt itself will fail due to its watermark check
having the proper value. Although __alloc_pages_direct_compact() will re-defer
compaction in such case, this happens only in the case of sync compaction.
Async compaction will leave the zone open for another compaction attempt which
may reset the deferred order again. This could possibly explain what
P. Christeas reported - a system where many processes include the following
backtrace:

        [<ffffffff813b1025>] preempt_schedule_irq+0x3c/0x59
        [<ffffffff813b4810>] retint_kernel+0x20/0x30
        [<ffffffff810d7481>] ? __zone_watermark_ok+0x77/0x85
        [<ffffffff810d8256>] zone_watermark_ok+0x1a/0x1c
        [<ffffffff810eee56>] compact_zone+0x215/0x4b2
        [<ffffffff810ef13f>] compact_zone_order+0x4c/0x5f
        [<ffffffff810ef2fe>] try_to_compact_pages+0xc4/0x1e8
        [<ffffffff813ad7f8>] __alloc_pages_direct_compact+0x61/0x1bf
        [<ffffffff810da299>] __alloc_pages_nodemask+0x409/0x799
        [<ffffffff8110d3fd>] new_slab+0x5f/0x21c

The issue has been made visible by commit 53853e2d2bfb ("mm, compaction: defer
each zone individually instead of preferred zone"), since before the commit,
deferred compaction for fallback zones (where classzone_idx matters) was not
considered separately.

Although work is underway to fix the underlying zone watermark check mismatch,
this patch fixes the immediate problem by removing the optimistic defer reset
completely. Its usefulness is questionable anyway, since if the allocation
really succeeds, a full defer reset (including the period counters) follows.

Fixes: 53853e2d2bfb748a8b5aa2fd1de15699266865e0
Reported-by: P. Christeas <xrg@linux.gr>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index ec74cf0..f0335f9 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1325,13 +1325,6 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 				      alloc_flags)) {
 			*candidate_zone = zone;
 			/*
-			 * We think the allocation will succeed in this zone,
-			 * but it is not certain, hence the false. The caller
-			 * will repeat this with true if allocation indeed
-			 * succeeds in this zone.
-			 */
-			compaction_defer_reset(zone, order, false);
-			/*
 			 * It is possible that async compaction aborted due to
 			 * need_resched() and the watermarks were ok thanks to
 			 * somebody else freeing memory. The allocation can
-- 
2.1.2


