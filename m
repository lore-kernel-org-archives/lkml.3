Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161409AbaDPOP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:15:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56985 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaDPOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:15:27 -0400
Date: Wed, 16 Apr 2014 16:15:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140416141514.GS11182@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 05:37:01PM -0400, Vince Weaver wrote:
> 
> Still tracking memory corruption bugs found by the perf_fuzzer, I have 
> about 10 different log splats that I think might all be related to the 
> same underlying problem.
> 
> Anyway I managed to trigger this using the perf_fuzzer:
> 
> [  221.065278] Slab corruption (Not tainted): kmalloc-2048 start=ffff8800cd15e800, len=2048
> [  221.074062] 040: 6b 6b 6b 6b 6b 6b 6b 6b 98 72 57 cd 00 88 ff ff  kkkkkkkk.rW.....
> [  221.082321] Prev obj: start=ffff8800cd15e000, len=2048
> [  221.087933] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  221.096224] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 
> And luckily I had ftrace running at the time.
> 
> The allocation of this block is by perf_event
> 
> perf_fuzzer-2520  [001]   182.980563: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff811399b5 ptr=0xffff8800cd15e800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> perf_fuzzer-2520  [000]   183.628515: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff811399b5 ptr=0xffff8800cd15e800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> perf_fuzzer-2520  [000]   183.628521: kfree:                (perf_event_alloc+0x2f7) call_site=ffffffff81139c57 ptr=0xffff8800cd15e800
> perf_fuzzer-2520  [000]   183.628844: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff811399b5 ptr=0xffff8800cd15e800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> ...(thousands of times of kmalloc/kfree)

Does the below make any difference? I've only ran it through some light
testing to make sure it didn't insta-explode on running.

(perf stat make -j64 -s in fact)

The patch changes the exit path (identified by tglx as the most likely
fuckup source), if I read it right the if(child_event->parent) condition
in __perf_event_exit_task() is complete bullshit.

We should always detach from groups, inherited event or not.

The not detaching of the group, in turn, can cause the
__perf_event_exit_task() loops in perf_event_exit_task_context() to not
actually do what the goto again comment says. Because we do not detach
from the group, group siblings will not be placed back on the list as
singleton events.

This then allows us to 'exit' while still having events linked. Then
when we close the event fd, we'll free the event, _while_still_linked_.

The patch deals with this by iterating the event_list instead of the
pinned/flexible group lists. Making that retry superfluous.

Now I haven't gone through all details yet, so I might be talking crap.

I've pretty much fried my brain by now, so I'll go see if I can
reproduce some of this slab corruption.

---
 kernel/events/core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a3e46d..c3c745c1d623 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7367,11 +7367,9 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	if (child_event->parent) {
-		raw_spin_lock_irq(&child_ctx->lock);
-		perf_group_detach(child_event);
-		raw_spin_unlock_irq(&child_ctx->lock);
-	}
+	raw_spin_lock_irq(&child_ctx->lock);
+	perf_group_detach(child_event);
+	raw_spin_unlock_irq(&child_ctx->lock);
 
 	perf_remove_from_context(child_event);
 
@@ -7443,12 +7441,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	mutex_lock(&child_ctx->mutex);
 
 again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
-				 group_entry)
-		__perf_event_exit_task(child_event, child_ctx, child);
-
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->flexible_groups,
-				 group_entry)
+	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
 	/*
@@ -7457,8 +7450,10 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * will still point to the list head terminating the iteration.
 	 */
 	if (!list_empty(&child_ctx->pinned_groups) ||
-	    !list_empty(&child_ctx->flexible_groups))
+	    !list_empty(&child_ctx->flexible_groups)) {
+		WARN_ON_ONCE(1);
 		goto again;
+	}
 
 	mutex_unlock(&child_ctx->mutex);
 
