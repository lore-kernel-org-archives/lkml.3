Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaD3Mnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:43:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:50889 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758818AbaD3Mmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:42:33 -0400
Message-Id: <20140430124231.452570718@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 08:41:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [for-next][PATCH 4/4] tracing: Remove mock up poll wait function
References: <20140430124153.334527053@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-Remove-mock-up-poll-wait-function.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Now that the ring buffer has a built in way to wake up readers
when there's data, using irq_work such that it is safe to do it
in any context. But it was still using the old "poor man's"
wait polling that checks every 1/10 of a second to see if it
should wake up a waiter. This makes the latency for a wake up
excruciatingly long. No need to do that anymore.

Completely remove the different wait_poll types from the tracers
and have them all use the default one now.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c                 | 29 ++++-------------------------
 kernel/trace/trace.h                 |  4 ----
 kernel/trace/trace_functions.c       |  1 -
 kernel/trace/trace_functions_graph.c |  1 -
 kernel/trace/trace_nop.c             |  1 -
 kernel/trace/trace_sched_wakeup.c    |  2 --
 6 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e058c60..4c392c8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1085,7 +1085,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-static void default_wait_pipe(struct trace_iterator *iter)
+static void wait_on_pipe(struct trace_iterator *iter)
 {
 	/* Iterators are static, they should be filled or empty */
 	if (trace_buffer_iter(iter, iter->cpu_file))
@@ -1202,8 +1202,6 @@ int register_tracer(struct tracer *type)
 	else
 		if (!type->flags->opts)
 			type->flags->opts = dummy_tracer_opt;
-	if (!type->wait_pipe)
-		type->wait_pipe = default_wait_pipe;
 
 	ret = run_tracer_selftest(type);
 	if (ret < 0)
@@ -4207,25 +4205,6 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 	return trace_poll(iter, filp, poll_table);
 }
 
-/*
- * This is a make-shift waitqueue.
- * A tracer might use this callback on some rare cases:
- *
- *  1) the current tracer might hold the runqueue lock when it wakes up
- *     a reader, hence a deadlock (sched, function, and function graph tracers)
- *  2) the function tracers, trace all functions, we don't want
- *     the overhead of calling wake_up and friends
- *     (and tracing them too)
- *
- *     Anyway, this is really very primitive wakeup.
- */
-void poll_wait_pipe(struct trace_iterator *iter)
-{
-	set_current_state(TASK_INTERRUPTIBLE);
-	/* sleep for 100 msecs, and try again. */
-	schedule_timeout(HZ / 10);
-}
-
 /* Must be called with trace_types_lock mutex held. */
 static int tracing_wait_pipe(struct file *filp)
 {
@@ -4251,7 +4230,7 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		iter->trace->wait_pipe(iter);
+		wait_on_pipe(iter);
 
 		mutex_lock(&iter->mutex);
 
@@ -5179,7 +5158,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			iter->trace->wait_pipe(iter);
+			wait_on_pipe(iter);
 			mutex_lock(&trace_types_lock);
 			if (signal_pending(current)) {
 				size = -EINTR;
@@ -5390,7 +5369,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		iter->trace->wait_pipe(iter);
+		wait_on_pipe(iter);
 		mutex_lock(&trace_types_lock);
 		if (signal_pending(current)) {
 			ret = -EINTR;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8624b50..3b3e09e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -338,7 +338,6 @@ struct tracer_flags {
  * @stop: called when tracing is paused (echo 0 > tracing_enabled)
  * @open: called when the trace file is opened
  * @pipe_open: called when the trace_pipe file is opened
- * @wait_pipe: override how the user waits for traces on trace_pipe
  * @close: called when the trace file is released
  * @pipe_close: called when the trace_pipe file is released
  * @read: override the default read callback on trace_pipe
@@ -357,7 +356,6 @@ struct tracer {
 	void			(*stop)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
-	void			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
 	void			(*pipe_close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
@@ -566,8 +564,6 @@ void trace_init_global_iter(struct trace_iterator *iter);
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
-void poll_wait_pipe(struct trace_iterator *iter);
-
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 2d9482b..57f0ec9 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -252,7 +252,6 @@ static struct tracer function_trace __tracer_data =
 	.init		= function_trace_init,
 	.reset		= function_trace_reset,
 	.start		= function_trace_start,
-	.wait_pipe	= poll_wait_pipe,
 	.flags		= &func_flags,
 	.set_flag	= func_set_flag,
 	.allow_instances = true,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index deff112..b86dd4d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1505,7 +1505,6 @@ static struct tracer graph_trace __tracer_data = {
 	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
 	.pipe_close	= graph_trace_close,
-	.wait_pipe	= poll_wait_pipe,
 	.init		= graph_trace_init,
 	.reset		= graph_trace_reset,
 	.print_line	= print_graph_function,
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 69a5cc9..fcf0a9e 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -91,7 +91,6 @@ struct tracer nop_trace __read_mostly =
 	.name		= "nop",
 	.init		= nop_trace_init,
 	.reset		= nop_trace_reset,
-	.wait_pipe	= poll_wait_pipe,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_nop,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 1573c03..19bd892 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -705,7 +705,6 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
-	.wait_pipe	= poll_wait_pipe,
 	.print_max	= true,
 	.print_header	= wakeup_print_header,
 	.print_line	= wakeup_print_line,
@@ -728,7 +727,6 @@ static struct tracer wakeup_dl_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
-	.wait_pipe	= poll_wait_pipe,
 	.print_max	= true,
 	.print_header	= wakeup_print_header,
 	.print_line	= wakeup_print_line,
-- 
1.8.5.3


