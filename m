Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3D2TTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:19:42 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47373 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3D2TTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:19:40 -0400
Message-ID: <517EC7CA.8070309@gmail.com>
Date: Mon, 29 Apr 2013 15:19:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        kosaki.motohiro@gmail.com
Subject: [PATCH 5/2] posix-cpu-timers: cleanup cpu_{clock,timer}_sample{,_group}
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have similar four timer related functions, cpu_clock_sample(),
cpu_clock_sample_group(), cpu_timer_sample() and cpu_timer_sample_group().

For readability, making do_cpu_clock_timer_sample() and thread_cputime()
helper functions and all *_sample functions use them.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/sched.h     |    1 +
 kernel/posix-cpu-timers.c |  123 +++++++++++++++++++++------------------------
 kernel/sched/cputime.c    |   11 ++++
 3 files changed, 70 insertions(+), 65 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7863d4b..73ac8fa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2622,6 +2622,7 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
+void thread_cputime(struct task_struct *tsk, bool add_delta, struct task_cputime *times);
 /*
  * Thread group CPU time accounting.
  */
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 651b6c7..9088023 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -203,36 +203,6 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 	return error;
 }
 
-static int do_cpu_clock_sample(const clockid_t which_clock,
-			       struct task_struct *p,
-			       bool add_delta,
-			       union cpu_time_count *cpu)
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
-	return do_cpu_clock_sample(which_clock, p, true, cpu);
-}
-
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
@@ -274,34 +244,84 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
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
 
+	if (thread_group)
+		thread_group_cputime(p, clock_time, &cputime);
+	else
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
+ * Get a per-thread clock time for the given task.
+ */
+static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
+			    union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, false, true, cpu);
+}
+
+/*
+ * Get a per-process clock time for the given task.
+ * Must be called with tasklist_lock held for reading if p is not thread
+ * group leader.
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
+ * Sample a process timer time for the given task.
+ * Must be called with tasklist_lock held for reading if p is not thread group
+ * leader.
+ */
+static int cpu_timer_sample_group(const clockid_t which_clock,
+				  struct task_struct *p,
+				  union cpu_time_count *cpu)
+{
+	return do_cpu_clock_timer_sample(which_clock, p, true, false, cpu);
+}
 
 static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
@@ -622,33 +642,6 @@ static void cpu_timer_fire(struct k_itimer *timer)
 }
 
 /*
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
-/*
  * Guts of sys_timer_settime for CPU timers.
  * This is called with the timer locked and interrupts disabled.
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 69d3f6c..29ef7d7 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -289,6 +289,17 @@ static __always_inline bool steal_account_process_tick(void)
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


