Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKLKcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:32:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaKLKcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:32:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] sched/cputime: fix clock_nanosleep/clock_gettime inconsistency
Date: Wed, 12 Nov 2014 11:29:28 +0100
Message-Id: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d670ec13178d "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
test case in cost of breaking another one. After that commit, calling
clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
of Y time being smaller than X time.

Below is full reproducer (tst-cpuclock2.c) :

#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <time.h>
#include <pthread.h>
#include <stdint.h>
#include <inttypes.h>

/* Parameters for the Linux kernel ABI for CPU clocks.  */
#define CPUCLOCK_SCHED          2
#define MAKE_PROCESS_CPUCLOCK(pid, clock) \
        ((~(clockid_t) (pid) << 3) | (clockid_t) (clock))

static pthread_barrier_t barrier;

/* Help advance the clock.  */
static void *chew_cpu(void *arg)
{
	pthread_barrier_wait(&barrier);
	while (1) ;

	return NULL;
}

/* Don't use the glibc wrapper.  */
static int do_nanosleep(int flags, const struct timespec *req)
{
	clockid_t clock_id = MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED);

	return syscall(SYS_clock_nanosleep, clock_id, flags, req, NULL);
}

static int64_t tsdiff(const struct timespec *before, const struct timespec *after)
{
	int64_t before_i = before->tv_sec * 1000000000ULL + before->tv_nsec;
	int64_t after_i = after->tv_sec * 1000000000ULL + after->tv_nsec;

	return after_i - before_i;
}

int main(void)
{
	int result = 0;
	pthread_t th;

	pthread_barrier_init(&barrier, NULL, 2);

	if (pthread_create(&th, NULL, chew_cpu, NULL) != 0) {
		perror("pthread_create");
		return 1;
	}

	pthread_barrier_wait(&barrier);

	/* The test.  */
	struct timespec before, after, sleeptimeabs;
	int64_t sleepdiff, diffabs;
	const struct timespec sleeptime = {.tv_sec = 0,.tv_nsec = 100000000 };

	/* The relative nanosleep.  Not sure why this is needed, but its presence
	   seems to make it easier to reproduce the problem.  */
	if (do_nanosleep(0, &sleeptime) != 0) {
		perror("clock_nanosleep");
		return 1;
	}

	/* Get the current time.  */
	if (clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &before) < 0) {
		perror("clock_gettime[2]");
		return 1;
	}

	/* Compute the absolute sleep time based on the current time.  */
	uint64_t nsec = before.tv_nsec + sleeptime.tv_nsec;
	sleeptimeabs.tv_sec = before.tv_sec + nsec / 1000000000;
	sleeptimeabs.tv_nsec = nsec % 1000000000;

	/* Sleep for the computed time.  */
	if (do_nanosleep(TIMER_ABSTIME, &sleeptimeabs) != 0) {
		perror("absolute clock_nanosleep");
		return 1;
	}

	/* Get the time after the sleep.  */
	if (clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &after) < 0) {
		perror("clock_gettime[3]");
		return 1;
	}

	/* The time after sleep should always be equal to or after the absolute sleep
	   time passed to clock_nanosleep.  */
	sleepdiff = tsdiff(&sleeptimeabs, &after);
	if (sleepdiff < 0) {
		printf("absolute clock_nanosleep woke too early: %" PRId64 "\n", sleepdiff);
		result = 1;

		printf("Before %llu.%09llu\n", before.tv_sec, before.tv_nsec);
		printf("After  %llu.%09llu\n", after.tv_sec, after.tv_nsec);
		printf("Sleep  %llu.%09llu\n", sleeptimeabs.tv_sec, sleeptimeabs.tv_nsec);
	}

	/* The difference between the timestamps taken before and after the
	   clock_nanosleep call should be equal to or more than the duration of the
	   sleep.  */
	diffabs = tsdiff(&before, &after);
	if (diffabs < sleeptime.tv_nsec) {
		printf("clock_gettime difference too small: %" PRId64 "\n", diffabs);
		result = 1;
	}

	pthread_cancel(th);

	return result;
}

It can be compiled and ran by:

gcc -o tst-cpuclock2 tst-cpuclock2.c -pthread
while ./tst-cpuclock2 ; do : ; done

Issue happens because on start in thread_group_cputimer() we initialize
sum_exec_runtime of cputimer with threads runtime not yet accounted and
then add the threads runtime again on scheduler tick. When cputimer
finish, it's sum_exec_runtime value is bigger than current sum counted
by iterating over the threads in thread_group_cputime().

KOSAKI Motohiro posted fix for this problem, but that patch was never
applied: https://lkml.org/lkml/2013/5/26/191.

This patch takes different approach. It revert change from d670ec13178d,
but to assure process times are in sync with thread times, before
accounting the times it calls update_curr() to update current thread
sum_exec_runtime. This fixes the test case from commit d670ec13178d and
also make things like they were before i.e. process cpu times can be
(nr_threads - 1) * TICK_NSEC behind the clock (this is a drawback
unfortunately). Good news is that patch improve performance of
thread_group_cputime(), i.e. we do not need optimizations from commit
911b289 "sched: Optimize task_sched_runtime()"

Note I'm not familiar with scheduler subsystem, hence I'm not sure if
calling update_curr() will not affect scheduler functionality somehow.

Cc: Rik van Riel <riel@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/linux/kernel_stat.h    |  5 +--
 kernel/sched/core.c            | 69 +++++-------------------------------------
 kernel/sched/cputime.c         |  2 +-
 kernel/sched/deadline.c        |  2 ++
 kernel/sched/fair.c            |  7 +++++
 kernel/sched/rt.c              |  2 ++
 kernel/sched/sched.h           |  2 ++
 kernel/time/posix-cpu-timers.c |  7 +++--
 8 files changed, 27 insertions(+), 69 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8422b4e..d5bf373 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -77,10 +77,7 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 	return kstat_cpu(cpu).irqs_sum;
 }
 
-/*
- * Lock/unlock the current runqueue - to extract task statistics:
- */
-extern unsigned long long task_delta_exec(struct task_struct *);
+extern void scheduler_update_curr(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..117c852 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2475,75 +2475,20 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
 
 /*
- * Return any ns on the sched_clock that have not yet been accounted in
- * @p in case that task is currently running.
- *
- * Called with task_rq_lock() held on @rq.
+ * If the task is currently running, update the statistics. Main purpose
+ * of this function is assure that the accounted runtime is updated.
  */
-static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
-{
-	u64 ns = 0;
-
-	/*
-	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
-	 * project cycles that may never be accounted to this
-	 * thread, breaking clock_gettime().
-	 */
-	if (task_current(rq, p) && task_on_rq_queued(p)) {
-		update_rq_clock(rq);
-		ns = rq_clock_task(rq) - p->se.exec_start;
-		if ((s64)ns < 0)
-			ns = 0;
-	}
-
-	return ns;
-}
-
-unsigned long long task_delta_exec(struct task_struct *p)
+void scheduler_update_curr(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
-	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
- * Return accounted runtime for the task.
- * In case the task is currently running, return the runtime plus current's
- * pending runtime that have not been accounted yet.
- */
-unsigned long long task_sched_runtime(struct task_struct *p)
-{
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns = 0;
-
-#if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
-	/*
-	 * 64-bit doesn't need locks to atomically read a 64bit value.
-	 * So we have a optimization chance when the task's delta_exec is 0.
-	 * Reading ->on_cpu is racy, but this is ok.
-	 *
-	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
-	 * If we race with it entering cpu, unaccounted time is 0. This is
-	 * indistinguishable from the read occurring a few cycles earlier.
-	 * If we see ->on_cpu without ->on_rq, the task is leaving, and has
-	 * been accounted, so we're correct here as well.
-	 */
-	if (!p->on_cpu || !task_on_rq_queued(p))
-		return p->se.sum_exec_runtime;
-#endif
-
-	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	if (task_current(rq, p) && task_on_rq_queued(p)) {
+		update_rq_clock(rq);
+		p->sched_class->update_curr(rq);
+	}
 	task_rq_unlock(rq, p, &flags);
-
-	return ns;
 }
 
 /*
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 8394b1e..afcf114 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -305,7 +305,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 			task_cputime(t, &utime, &stime);
 			times->utime += utime;
 			times->stime += stime;
-			times->sum_exec_runtime += task_sched_runtime(t);
+			times->sum_exec_runtime += t->se.sum_exec_runtime;
 		}
 		/* If lockless access failed, take the lock. */
 		nextseq = 1;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5285332..28fa9d9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1701,4 +1701,6 @@ const struct sched_class dl_sched_class = {
 	.prio_changed           = prio_changed_dl,
 	.switched_from		= switched_from_dl,
 	.switched_to		= switched_to_dl,
+
+	.update_curr		= update_curr_dl,
 };
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34baa60..99995e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -726,6 +726,11 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
+static void update_curr_rq(struct rq *rq)
+{
+	update_curr(&rq->cfs);
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -7949,6 +7954,8 @@ const struct sched_class fair_sched_class = {
 
 	.get_rr_interval	= get_rr_interval_fair,
 
+	.update_curr		= update_curr_rq,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d024e6c..20bca39 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2128,6 +2128,8 @@ const struct sched_class rt_sched_class = {
 
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
+
+	.update_curr		= update_curr_rt,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..2df8ef0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1135,6 +1135,8 @@ struct sched_class {
 	unsigned int (*get_rr_interval) (struct rq *rq,
 					 struct task_struct *task);
 
+	void (*update_curr) (struct rq *rq);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 492b986..c2a5401 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -190,7 +190,8 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		*sample = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		*sample = task_sched_runtime(p);
+		scheduler_update_curr(p);
+		*sample = p->se.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -221,6 +222,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * to synchronize the timer to the clock every time we start
 		 * it.
 		 */
+		scheduler_update_curr(tsk);
 		thread_group_cputime(tsk, &sum);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
 		cputimer->running = 1;
@@ -254,6 +256,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
+		scheduler_update_curr(p);
 		thread_group_cputime(p, &cputime);
 		*sample = cputime.sum_exec_runtime;
 		break;
@@ -553,7 +556,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
-		*sample = cputime.sum_exec_runtime + task_delta_exec(p);
+		*sample = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
-- 
1.8.3.1

