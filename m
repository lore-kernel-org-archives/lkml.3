Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaAMPys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:54:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaAMPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:54:43 -0500
Date: Mon, 13 Jan 2014 07:54:06 -0800
From: tip-bot for Dario Faggioli <tipbot@zytor.com>
Message-ID: <tip-af6ace764d03900524e9b1ac621a1c520ee49fc6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, raistlin@linux.it,
        juri.lelli@gmail.com
In-Reply-To: <1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Add latency tracing for SCHED_DEADLINE tasks
Git-Commit-ID: af6ace764d03900524e9b1ac621a1c520ee49fc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:54:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af6ace764d03900524e9b1ac621a1c520ee49fc6
Gitweb:     http://git.kernel.org/tip/af6ace764d03900524e9b1ac621a1c520ee49fc6
Author:     Dario Faggioli <raistlin@linux.it>
AuthorDate: Thu, 7 Nov 2013 14:43:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:41:11 +0100

sched/deadline: Add latency tracing for SCHED_DEADLINE tasks

It is very likely that systems that wants/needs to use the new
SCHED_DEADLINE policy also want to have the scheduling latency of
the -deadline tasks under control.

For this reason a new version of the scheduling wakeup latency,
called "wakeup_dl", is introduced.

As a consequence of applying this patch there will be three wakeup
latency tracer:

 * "wakeup", that deals with all tasks in the system;
 * "wakeup_rt", that deals with -rt and -deadline tasks only;
 * "wakeup_dl", that deals with -deadline tasks only.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1383831828-15501-9-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/trace_sched_wakeup.c | 64 ++++++++++++++++++++++++++++++++++++---
 kernel/trace/trace_selftest.c     | 33 +++++++++++---------
 2 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index fee77e1..090c4d9 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -27,6 +27,8 @@ static int			wakeup_cpu;
 static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
+static int			wakeup_dl;
+static int			tracing_dl = 0;
 
 static arch_spinlock_t wakeup_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
@@ -437,6 +439,7 @@ static void __wakeup_reset(struct trace_array *tr)
 {
 	wakeup_cpu = -1;
 	wakeup_prio = -1;
+	tracing_dl = 0;
 
 	if (wakeup_task)
 		put_task_struct(wakeup_task);
@@ -472,9 +475,17 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	tracing_record_cmdline(p);
 	tracing_record_cmdline(current);
 
-	if ((wakeup_rt && !rt_task(p)) ||
-			p->prio >= wakeup_prio ||
-			p->prio >= current->prio)
+	/*
+	 * Semantic is like this:
+	 *  - wakeup tracer handles all tasks in the system, independently
+	 *    from their scheduling class;
+	 *  - wakeup_rt tracer handles tasks belonging to sched_dl and
+	 *    sched_rt class;
+	 *  - wakeup_dl handles tasks belonging to sched_dl class only.
+	 */
+	if (tracing_dl || (wakeup_dl && !dl_task(p)) ||
+	    (wakeup_rt && !dl_task(p) && !rt_task(p)) ||
+	    (!dl_task(p) && (p->prio >= wakeup_prio || p->prio >= current->prio)))
 		return;
 
 	pc = preempt_count();
@@ -486,7 +497,8 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	arch_spin_lock(&wakeup_lock);
 
 	/* check for races. */
-	if (!tracer_enabled || p->prio >= wakeup_prio)
+	if (!tracer_enabled || tracing_dl ||
+	    (!dl_task(p) && p->prio >= wakeup_prio))
 		goto out_locked;
 
 	/* reset the trace */
@@ -496,6 +508,15 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	wakeup_current_cpu = wakeup_cpu;
 	wakeup_prio = p->prio;
 
+	/*
+	 * Once you start tracing a -deadline task, don't bother tracing
+	 * another task until the first one wakes up.
+	 */
+	if (dl_task(p))
+		tracing_dl = 1;
+	else
+		tracing_dl = 0;
+
 	wakeup_task = p;
 	get_task_struct(wakeup_task);
 
@@ -597,16 +618,25 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl = 0;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
 }
 
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	wakeup_dl = 0;
 	wakeup_rt = 1;
 	return __wakeup_tracer_init(tr);
 }
 
+static int wakeup_dl_tracer_init(struct trace_array *tr)
+{
+	wakeup_dl = 1;
+	wakeup_rt = 0;
+	return __wakeup_tracer_init(tr);
+}
+
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
 	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
@@ -674,6 +704,28 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.use_max_tr	= true,
 };
 
+static struct tracer wakeup_dl_tracer __read_mostly =
+{
+	.name		= "wakeup_dl",
+	.init		= wakeup_dl_tracer_init,
+	.reset		= wakeup_tracer_reset,
+	.start		= wakeup_tracer_start,
+	.stop		= wakeup_tracer_stop,
+	.wait_pipe	= poll_wait_pipe,
+	.print_max	= true,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
+	.flag_changed	= wakeup_flag_changed,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest    = trace_selftest_startup_wakeup,
+#endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
+	.use_max_tr	= true,
+};
+
 __init static int init_wakeup_tracer(void)
 {
 	int ret;
@@ -686,6 +738,10 @@ __init static int init_wakeup_tracer(void)
 	if (ret)
 		return ret;
 
+	ret = register_tracer(&wakeup_dl_tracer);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 core_initcall(init_wakeup_tracer);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index a7329b7..e98fca6 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1022,11 +1022,16 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 #ifdef CONFIG_SCHED_TRACER
 static int trace_wakeup_test_thread(void *data)
 {
-	/* Make this a RT thread, doesn't need to be too high */
-	static const struct sched_param param = { .sched_priority = 5 };
+	/* Make this a -deadline thread */
+	static const struct sched_attr attr = {
+		.sched_policy = SCHED_DEADLINE,
+		.sched_runtime = 100000ULL,
+		.sched_deadline = 10000000ULL,
+		.sched_period = 10000000ULL
+	};
 	struct completion *x = data;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
+	sched_setattr(current, &attr);
 
 	/* Make it know we have a new prio */
 	complete(x);
@@ -1040,8 +1045,8 @@ static int trace_wakeup_test_thread(void *data)
 	/* we are awake, now wait to disappear */
 	while (!kthread_should_stop()) {
 		/*
-		 * This is an RT task, do short sleeps to let
-		 * others run.
+		 * This will likely be the system top priority
+		 * task, do short sleeps to let others run.
 		 */
 		msleep(100);
 	}
@@ -1054,21 +1059,21 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
 	unsigned long save_max = tracing_max_latency;
 	struct task_struct *p;
-	struct completion isrt;
+	struct completion is_ready;
 	unsigned long count;
 	int ret;
 
-	init_completion(&isrt);
+	init_completion(&is_ready);
 
-	/* create a high prio thread */
-	p = kthread_run(trace_wakeup_test_thread, &isrt, "ftrace-test");
+	/* create a -deadline thread */
+	p = kthread_run(trace_wakeup_test_thread, &is_ready, "ftrace-test");
 	if (IS_ERR(p)) {
 		printk(KERN_CONT "Failed to create ftrace wakeup test thread ");
 		return -1;
 	}
 
-	/* make sure the thread is running at an RT prio */
-	wait_for_completion(&isrt);
+	/* make sure the thread is running at -deadline policy */
+	wait_for_completion(&is_ready);
 
 	/* start the tracing */
 	ret = tracer_init(trace, tr);
@@ -1082,19 +1087,19 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 
 	while (p->on_rq) {
 		/*
-		 * Sleep to make sure the RT thread is asleep too.
+		 * Sleep to make sure the -deadline thread is asleep too.
 		 * On virtual machines we can't rely on timings,
 		 * but we want to make sure this test still works.
 		 */
 		msleep(100);
 	}
 
-	init_completion(&isrt);
+	init_completion(&is_ready);
 
 	wake_up_process(p);
 
 	/* Wait for the task to wake up */
-	wait_for_completion(&isrt);
+	wait_for_completion(&is_ready);
 
 	/* stop the tracing. */
 	tracing_stop();
