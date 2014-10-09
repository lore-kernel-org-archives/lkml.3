Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaJIBLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:11:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:62655 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751347AbaJIBLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:11:05 -0400
Message-Id: <20141009011057.316310917@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 08 Oct 2014 21:10:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [for-next][PATCH 2/2] tracing: Clean up scheduling in trace_wakeup_test_thread()
References: <20141009011010.446507073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Clean-up-scheduling-in-trace_wakeup_test_thr.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Peter's new debugging tool triggers when tasks exit with !TASK_RUNNING.
The code in trace_wakeup_test_thread() also has a single schedule() call
that should be encompassed by a loop.

This cleans up the code a little to make it a bit more robust and
also makes the return exit properly with TASK_RUNNING.

Link: http://lkml.kernel.org/p/20141008135216.76142204@gandalf.local.home

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c | 47 +++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 5ef60499dc8e..593f52b73551 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1025,6 +1025,12 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 #endif
 
 #ifdef CONFIG_SCHED_TRACER
+
+struct wakeup_test_data {
+	struct completion	is_ready;
+	int			go;
+};
+
 static int trace_wakeup_test_thread(void *data)
 {
 	/* Make this a -deadline thread */
@@ -1034,51 +1040,56 @@ static int trace_wakeup_test_thread(void *data)
 		.sched_deadline = 10000000ULL,
 		.sched_period = 10000000ULL
 	};
-	struct completion *x = data;
+	struct wakeup_test_data *x = data;
 
 	sched_setattr(current, &attr);
 
 	/* Make it know we have a new prio */
-	complete(x);
+	complete(&x->is_ready);
 
 	/* now go to sleep and let the test wake us up */
 	set_current_state(TASK_INTERRUPTIBLE);
-	schedule();
+	while (!x->go) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
 
-	complete(x);
+	complete(&x->is_ready);
+
+	set_current_state(TASK_INTERRUPTIBLE);
 
 	/* we are awake, now wait to disappear */
 	while (!kthread_should_stop()) {
-		/*
-		 * This will likely be the system top priority
-		 * task, do short sleeps to let others run.
-		 */
-		msleep(100);
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
 
+	__set_current_state(TASK_RUNNING);
+
 	return 0;
 }
-
 int
 trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
 	unsigned long save_max = tr->max_latency;
 	struct task_struct *p;
-	struct completion is_ready;
+	struct wakeup_test_data data;
 	unsigned long count;
 	int ret;
 
-	init_completion(&is_ready);
+	memset(&data, 0, sizeof(data));
+
+	init_completion(&data.is_ready);
 
 	/* create a -deadline thread */
-	p = kthread_run(trace_wakeup_test_thread, &is_ready, "ftrace-test");
+	p = kthread_run(trace_wakeup_test_thread, &data, "ftrace-test");
 	if (IS_ERR(p)) {
 		printk(KERN_CONT "Failed to create ftrace wakeup test thread ");
 		return -1;
 	}
 
 	/* make sure the thread is running at -deadline policy */
-	wait_for_completion(&is_ready);
+	wait_for_completion(&data.is_ready);
 
 	/* start the tracing */
 	ret = tracer_init(trace, tr);
@@ -1099,18 +1110,20 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 		msleep(100);
 	}
 
-	init_completion(&is_ready);
+	init_completion(&data.is_ready);
+
+	data.go = 1;
+	/* memory barrier is in the wake_up_process() */
 
 	wake_up_process(p);
 
 	/* Wait for the task to wake up */
-	wait_for_completion(&is_ready);
+	wait_for_completion(&data.is_ready);
 
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(&tr->trace_buffer, NULL);
-	printk("ret = %d\n", ret);
 	if (!ret)
 		ret = trace_test_buffer(&tr->max_buffer, &count);
 
-- 
2.0.1


