Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093AbaLMEWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:22:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6342 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754672AbaLMEWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:22:19 -0500
Message-Id: <20141213042217.148887062@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 12 Dec 2014 23:21:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] tracing/sched: Check preempt_count() for current when reading
 task->state
References: <20141213042144.599602592@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-sched-Check-preempt_count-for-current-when-r.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When recording the state of a task for the sched_switch tracepoint a check of
task_preempt_count() is performed to see if PREEMPT_ACTIVE is set. This is
because, technically, a task being preempted is really in the TASK_RUNNING
state, and that is what should be recorded when tracing a sched_switch,
even if the task put itself into another state (it hasn't scheduled out
in that state yet).

But with the change to use per_cpu preempt counts, the
task_thread_info(p)->preempt_count is no longer used, and instead
task_preempt_count(p) is used.

The problem is that this does not use the current preempt count but a stale
one from a previous sched_switch. The task_preempt_count(p) uses
saved_preempt_count and not preempt_count(). But for tracing sched_switch,
if p is current, we really want preempt_count().

I hit this bug when I was tracing sleep and the call from do_nanosleep()
scheduled out in the "RUNNING" state.

           sleep-4290  [000] 537272.259992: sched_switch:         sleep:4290 [120] R ==> swapper/0:0 [120]
           sleep-4290  [000] 537272.260015: kernel_stack:         <stack trace>
=> __schedule (ffffffff8150864a)
=> schedule (ffffffff815089f8)
=> do_nanosleep (ffffffff8150b76c)
=> hrtimer_nanosleep (ffffffff8108d66b)
=> SyS_nanosleep (ffffffff8108d750)
=> return_to_handler (ffffffff8150e8e5)
=> tracesys_phase2 (ffffffff8150c844)

After a bit of hair pulling, I found that the state was really
TASK_INTERRUPTIBLE, but the saved_preempt_count had an old PREEMPT_ACTIVE
set and caused the sched_switch tracepoint to show it as RUNNING.

Link: http://lkml.kernel.org/r/20141210174428.3cb7542a@gandalf.local.home

Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org # 3.13+
Cc: Peter Zijlstra <peterz@infradead.org>
Fixes: 01028747559a "sched: Create more preempt_count accessors"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5ae584e..a7d67bc14906 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
-- 
2.1.3


