Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaJIQ2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:28:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:14026 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754972AbaJIQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:28:12 -0400
Date: Thu, 9 Oct 2014 12:28:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing: Fix and clean up some start up testst
Message-ID: <20141009122810.77abdd23@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Seems that Peter Zijlstra added a new check that is making old
code screem nasty warnings:

WARNING: CPU: 0 PID: 91 at kernel/sched/core.c:7253 __might_sleep+0x9a/0x378()
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8d79b511>] event_test_thread+0x48/0x93
Modules linked in:
CPU: 0 PID: 91 Comm: test-events Not tainted 3.17.0-rc7-00109-g2f85d18 #37
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
 0000000000000000 ffff880010ec3c80 ffffffff8c696943 ffff880010ec3cb8
 ffffffff8be7cae5 ffffffff8bead236 0000000000000001 ffff88001161fa01
 0000000000000001 0000000000000000 ffff880010ec3d20 ffffffff8be7cb46
Call Trace:
 [<ffffffff8c696943>] dump_stack+0x19/0x1b
 [<ffffffff8be7cae5>] warn_slowpath_common+0x8f/0xa8
 [<ffffffff8bead236>] ? __might_sleep+0x9a/0x378
 [<ffffffff8be7cb46>] warn_slowpath_fmt+0x48/0x50
 [<ffffffff8be0dd55>] ? sched_clock+0x9/0xd
 [<ffffffff8d79b511>] ? event_test_thread+0x48/0x93
 [<ffffffff8d79b511>] ? event_test_thread+0x48/0x93
 [<ffffffff8bead236>] __might_sleep+0x9a/0x378
 [<ffffffff8c6a0227>] down_read+0x26/0x98
 [<ffffffff8be8f503>] exit_signals+0x27/0x1c2
 [<ffffffff8be7fedd>] do_exit+0x193/0x10bd
 [<ffffffff8bfd1969>] ? kfree+0x4a0/0x4d7
 [<ffffffff8d79b4c9>] ? event_trace_self_tests+0x6d7/0x6d7
 [<ffffffff8d79b4c9>] ? event_trace_self_tests+0x6d7/0x6d7
 [<ffffffff8bea4b65>] kthread+0x156/0x156
 [<ffffffff8c69c0f8>] ? wait_for_common+0x3e/0x224
 [<ffffffff8bea4a0f>] ? insert_kthread_work+0xe7/0xe7
 [<ffffffff8c6a353a>] ret_from_fork+0x7a/0xb0
 [<ffffffff8bea4a0f>] ? insert_kthread_work+0xe7/0xe7
---[ end trace 14d02ef17adbc114 ]---

These are triggered by some self tests that run at start up when
configure in. Although the code is technically correct, they are a little
sloppy and not very robust. They work now because it runs at boot up
and the tests do not call anything that might trigger a spurious
wake up. But that doesn't mean those tests wont change in the future.

It's best to clean them now to make sure the tests used to test the
internal workings of the system don't cause breakage themselves.

This also quiets the warnings made by the new checks.

Please pull the latest trace-3.18-2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.18-2

Tag SHA1: 2cef195ea7cf63359971f06ca094b63a84ecb70c
Head SHA1: addff1feb02b03cb766b9a611c6b2cebf29bc285


Peter Zijlstra (1):
      tracing: Robustify wait loop

Steven Rostedt (1):
      tracing: Clean up scheduling in trace_wakeup_test_thread()

----
 kernel/trace/trace_events.c   |  5 ++++-
 kernel/trace/trace_selftest.c | 47 +++++++++++++++++++++++++++----------------
 2 files changed, 34 insertions(+), 18 deletions(-)
---------------------------
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ef06ce7e9cf8..0cc51edde3a8 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2513,8 +2513,11 @@ static __init int event_test_thread(void *unused)
 	kfree(test_malloc);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop())
+	while (!kthread_should_stop()) {
 		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
 
 	return 0;
 }
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
 
