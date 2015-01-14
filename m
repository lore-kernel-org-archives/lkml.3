Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbbANHbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbbANHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.18 094/150] tracing/sched: Check preempt_count() for current when reading task->state
Date: Tue, 13 Jan 2015 23:22:45 -0800
Message-Id: <20150114072100.134852125@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 


