Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbbALSaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbALSaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 138/216] tracing/sched: Check preempt_count() for current when reading task->state
Date: Mon, 12 Jan 2015 18:28:36 +0000
Message-Id: <1421087394-2712-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit aee4e5f3d3abb7a2239dd02f6d8fb173413fd02f upstream.

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
Cc: Peter Zijlstra <peterz@infradead.org>
Fixes: 01028747559a "sched: Create more preempt_count accessors"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

