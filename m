Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbaLJWoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:44:34 -0500
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:57497 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933160AbaLJWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:44:32 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6261:7904:8660:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13148:13161:13229:13230:13255:13870:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: balls04_445dea1cf4c03
X-Filterd-Recvd-Size: 3331
Date: Wed, 10 Dec 2014 17:44:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] tracing/sched: Check preempt_count() for current when
 reading task->state
Message-ID: <20141210174428.3cb7542a@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When recording the state of a task for the sched_switch tracepoint a check of
task_preempt_count() is performed to see if PREEMPT_ACTIVE is set. This is
because, technically, a task being preempted is really in the TASK_RUNNING
state, and that is what should be recorded when tracing a sched_switch,
even if the task put itself into another state (it hasn't scheduled out
in that state yet).

But with the change to use per_cpu preempt counts, the
task_thread_info(p)->preempt_count is no longer used, and instead
task_preempt_count(p) is used.

The problem is that this does not use the current preempt count but a
stale one from a previous sched_switch. The task_preempt_count(p) uses
saved_preempt_count and not preempt_count(). But for tracing
sched_switch, if p is current, we really want preempt_count().

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

Cc: stable@vger.kernel.org # 3.13+
Fixes: 01028747559a "sched: Create more preempt_count accessors"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5ae584e..13fbadcc172b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -97,10 +97,14 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	long state = p->state;
 
 #ifdef CONFIG_PREEMPT
+	unsigned long pc;
+
+	pc = (p == current) ? preempt_count() : task_preempt_count(p);
+
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (pc & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
-- 
1.8.1.4

