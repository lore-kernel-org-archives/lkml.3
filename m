Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaKEP0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:26:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbaKEP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:26:24 -0500
Message-ID: <545A419C.3090900@suse.cz>
Date: Wed, 05 Nov 2014 16:26:20 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "P. Christeas" <xrg@linux.gr>
CC: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos> <54589465.3080708@suse.cz> <2357788.X5UHX7WJZF@xorhgos3.pefnos>
In-Reply-To: <2357788.X5UHX7WJZF@xorhgos3.pefnos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 10:36 AM, P. Christeas wrote:
> On Tuesday 04 November 2014, Vlastimil Babka wrote:
>> Please do keep testing (and see below what we need), and don't try
>> another tree - it's 3.18 we need to fix!
> Let me apologize/warn you about the poor quality of this report (and debug 
> data).
> It is on a system meant for everyday desktop usage, not kernel development. 
> Thus, it is tuned to be "slightly" debuggable ; mostly for performance.
> 
>> I'm not sure what you mean by "race" here and your snippet is
>> unfortunately just a small portion of the output ...
> 
> It is a shot in the dark. System becomes non-responsive (narrowed to desktop 
> apps waiting each other, or the X+kwin blocking), I can feel the CPU heating 
> and /sometimes/ disk I/O.
> 
> No BUG, Oops or any kernel message. (is printk level 4 adequate? )
> 
> Then, I try to drop to a console and collect as much data as possible with 
> SysRq.
> 
> The snippet I'd sent you is from all-cpus-backtrace (l), trying to see which 
> traces appear consistently during the lockup. There is also the huge traces of 
> "task-states" (t), but I reckon they are too noisy.
> That trace also matches the usage profile, because AFAICG[uess] the issue 
> appears when allocating during I/O load. 
> 
> After turning on full-preemption, I have been able to terminate/kill all tasks 
> and continue with same kernel but new userspace.
> 
>> OK so the process is not dead due to the problem? That probably rules
>> out some kinds of errors but we still need the full output. Thanks in
>> advance. 
>> I'm not aware of this, CCing lkml for wider coverage.
> 
> Thank you. As I've told in the first mail, this is an early report of possible 
> 3.18 regression. I'm trying to narrow down the case and make it reproducible 
> or get a good trace.

I see. I've tried to reproduce such issues with 3.18-rc3 but wasn't successful.
But I noticed a possible issue that could lead to your problem.
Can you please try the following patch?

--------8<-------
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

