Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaKLQCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:02:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbaKLQCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:02:10 -0500
Date: Wed, 12 Nov 2014 16:58:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112155843.GA24803@redhat.com>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112122155.GA3250@redhat.com>
 <20141112125158.GB21343@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112125158.GB21343@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d670ec13178d0 "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
test case in cost of breaking another one. After that commit, calling
clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
of Y time being smaller than X time.

Below is full reproducer (tst-cpuclock2.c) :

/* Parameters for the Linux kernel ABI for CPU clocks.  */
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
then add the threads runtime to running cputimer again on scheduler
tick, making it's sum_exec_runtime bigger than actual threads runtime.

KOSAKI Motohiro posted fix for this problem, but that patch was never
applied: https://lkml.org/lkml/2013/5/26/191 .

This patch takes different approach to cure the problem. It calls
update_curr() when cputimer starts, that assure we will have updated
stats of running threads and on the next schedule tick we will account
only the runtime that elapsed from cputimer start. That also assure we
have consistent state between cpu times of individual threads and cpu
time of the process consisted by those threads.

Cc: Rik van Riel <riel@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Originally-from: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: post Peter version

Peter, if you want post your patch by yourself please do so (you can
add me with Reported-and-tested-by: tag then). I'm posting this in case
you don't want to write the changelog :-)

 include/linux/kernel_stat.h    |  5 -----
 kernel/sched/core.c            | 51 +++++++++---------------------------------
 kernel/sched/deadline.c        |  2 ++
 kernel/sched/fair.c            |  7 ++++++
 kernel/sched/rt.c              |  2 ++
 kernel/sched/sched.h           |  2 ++
 kernel/time/posix-cpu-timers.c |  2 +-
 7 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8422b4e..b9376cd 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -77,11 +77,6 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 	return kstat_cpu(cpu).irqs_sum;
 }
 
-/*
- * Lock/unlock the current runqueue - to extract task statistics:
- */
-extern unsigned long long task_delta_exec(struct task_struct *);
-
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5df22f1da..960f704 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2457,44 +2457,6 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
 
 /*
- * Return any ns on the sched_clock that have not yet been accounted in
- * @p in case that task is currently running.
- *
- * Called with task_rq_lock() held on @rq.
- */
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
-{
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns = 0;
-
-	rq = task_rq_lock(p, &flags);
-	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
  * Return accounted runtime for the task.
  * In case the task is currently running, return the runtime plus current's
  * pending runtime that have not been accounted yet.
@@ -2503,7 +2465,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-	u64 ns = 0;
+	u64 ns;
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
 	/*
@@ -2522,7 +2484,16 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 #endif
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	/*
+	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
+	 * project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && task_on_rq_queued(p)) {
+		update_rq_clock(rq);
+		p->sched_class->update_curr(rq);
+	}
+	ns = p->se.sum_exec_runtime;
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f3d7776..b091179 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1747,6 +1747,8 @@ const struct sched_class dl_sched_class = {
 	.prio_changed           = prio_changed_dl,
 	.switched_from		= switched_from_dl,
 	.switched_to		= switched_to_dl,
+
+	.update_curr		= update_curr_dl,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf3..faa482e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -726,6 +726,11 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
+static void update_curr_fair(struct rq *rq)
+{
+	update_curr(&rq->cfs);
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -8137,6 +8142,8 @@ const struct sched_class fair_sched_class = {
 
 	.get_rr_interval	= get_rr_interval_fair,
 
+	.update_curr		= update_curr_fair,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3d14312..f1bb92f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2134,6 +2134,8 @@ const struct sched_class rt_sched_class = {
 
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
+
+	.update_curr		= update_curr_rt,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31f1e4d..9a2a45c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1177,6 +1177,8 @@ struct sched_class {
 	unsigned int (*get_rr_interval) (struct rq *rq,
 					 struct task_struct *task);
 
+	void (*update_curr) (struct rq *rq);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 492b986..a16b678 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -553,7 +553,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
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

