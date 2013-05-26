Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3EZVhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:37:46 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60720 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:37:42 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 7/8] posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}
Date: Sun, 26 May 2013 17:35:48 -0400
Message-Id: <1369604149-13016-10-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now we have four similar timer related functions, cpu_clock_sample(),
cpu_clock_sample_group(), cpu_timer_sample() and cpu_timer_sample_group().

For readability, make do_cpu_clock_timer_sample() and thread_cputime()
helper functions and all *_sample functions use these.

Cc: Olivier Langlois <olivier@trillion01.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/sched.h     |    1 +
 kernel/posix-cpu-timers.c |  132 +++++++++++++++++++-------------------------
 kernel/sched/cputime.c    |   11 ++++
 3 files changed, 69 insertions(+), 75 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4878579..ba36321 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2458,6 +2458,7 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
+void thread_cputime(struct task_struct *tsk, bool add_delta, struct task_cputime *times);
 /*
  * Idle thread specific functions to determine the need_resched
  * polling state. We have two versions, one based on TS_POLLING in
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 62466d4..34bb3f1 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -220,46 +220,6 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 	return error;
 }
 
-
-static int do_cpu_clock_timer_sample(const clockid_t which_clock,
-				     struct task_struct *p,
-				     bool add_delta,
-				     union cpu_time_count *cpu)
-{
-	switch (CPUCLOCK_WHICH(which_clock)) {
-	default:
-		return -EINVAL;
-	case CPUCLOCK_PROF:
-		cpu->cpu = prof_ticks(p);
-		break;
-	case CPUCLOCK_VIRT:
-		cpu->cpu = virt_ticks(p);
-		break;
-	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p, add_delta);
-		break;
-	}
-	return 0;
-}
-
-/*
- * Sample a per-thread clock for the given task.
- */
-static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
-			    union cpu_time_count *cpu)
-{
-	return do_cpu_clock_timer_sample(which_clock, p, true, cpu);
-}
-
-/*
- * Sample a per-thread timer clock for the given task.
- */
-static int cpu_timer_sample(const clockid_t which_clock, struct task_struct *p,
-			    union cpu_time_count *cpu)
-{
-	return do_cpu_clock_timer_sample(which_clock, p, false, cpu);
-}
-
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
@@ -301,34 +261,83 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 }
 
 /*
- * Sample a process (thread group) clock for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
+ * Sample time for the given task.
+ * @which_clock:	Clock id.
+ * @p:			Target task. Must be thread group leader when
+ *			thread_group is true.
+ * @thread_group:	True if want to get process time.
+ * @add_delta:		True if want to get clock time,
+ *			otherwise, get timer time.
  */
-static int cpu_clock_sample_group(const clockid_t which_clock,
-				  struct task_struct *p,
-				  union cpu_time_count *cpu)
+static int do_cpu_clock_timer_sample(const clockid_t which_clock,
+				     struct task_struct *p,
+				     bool thread_group,
+				     bool clock_time,
+				     union cpu_time_count *cpu)
 {
 	struct task_cputime cputime;
 
+	if (thread_group) {
+		if (clock_time)
+			thread_group_cputime(p, true, &cputime);
+		else
+			thread_group_cputimer(p, &cputime);
+	} else
+		thread_cputime(p, clock_time, &cputime);
+
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		thread_group_cputime(p, true, &cputime);
 		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
-		thread_group_cputime(p, true, &cputime);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		thread_group_cputime(p, true, &cputime);
 		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
 }
 
+/*
+ * Sample a per-thread clock time for the given task.
+ */
+static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
+			    union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, false, true, cpu);
+}
+
+/*
+ * Sample a per-process clock time for the given task.
+ */
+static int cpu_clock_sample_group(const clockid_t which_clock,
+				  struct task_struct *p,
+				  union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, true, true, cpu);
+}
+
+/*
+ * Sample a per-thread timer time for the given task.
+ */
+static int cpu_timer_sample(const clockid_t which_clock, struct task_struct *p,
+			    union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, false, false, cpu);
+}
+
+/*
+ * Sample a per-process timer time for the given task.
+ */
+static int cpu_timer_sample_group(const clockid_t which_clock,
+				  struct task_struct *p,
+				  union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, true, false, cpu);
+}
 
 static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
@@ -648,33 +657,6 @@ static void cpu_timer_fire(struct k_itimer *timer)
 	}
 }
 
-/*
- * Sample a process (thread group) timer for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
- */
-static int cpu_timer_sample_group(const clockid_t which_clock,
-				  struct task_struct *p,
-				  union cpu_time_count *cpu)
-{
-	struct task_cputime cputime;
-
-	thread_group_cputimer(p, &cputime);
-	switch (CPUCLOCK_WHICH(which_clock)) {
-	default:
-		return -EINVAL;
-	case CPUCLOCK_PROF:
-		cpu->cpu = cputime.utime + cputime.stime;
-		break;
-	case CPUCLOCK_VIRT:
-		cpu->cpu = cputime.utime;
-		break;
-	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime;
-		break;
-	}
-	return 0;
-}
-
 #ifdef CONFIG_NO_HZ_FULL
 static void nohz_kick_work_fn(struct work_struct *work)
 {
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 3ca432c..53a7de8 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -273,6 +273,17 @@ static __always_inline bool steal_account_process_tick(void)
 	return false;
 }
 
+void thread_cputime(struct task_struct *tsk, bool add_delta, struct task_cputime *times)
+{
+	struct signal_struct *sig = tsk->signal;
+	cputime_t utime, stime;
+
+	task_cputime(tsk, &utime, &stime);
+	times->utime = utime;
+	times->stime = stime;
+	times->sum_exec_runtime = task_sched_runtime(tsk, add_delta);
+}
+
 /*
  * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
  * tasks (sum on group iteration) belonging to @tsk's group.
-- 
1.7.1

