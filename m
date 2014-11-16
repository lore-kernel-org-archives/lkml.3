Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaKPJv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:51:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaKPJvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:51:24 -0500
Date: Sun, 16 Nov 2014 01:50:46 -0800
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-6e998916dfe327e785e7c2447959b2c1a3ea4930@git.kernel.org>
Cc: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com,
        torvalds@linux-foundation.org, fweisbec@gmail.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, oleg@redhat.com, sgruszka@redhat.com
Reply-To: fweisbec@gmail.com, torvalds@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, tglx@linutronix.de,
        oleg@redhat.com, sgruszka@redhat.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, mingo@kernel.org
In-Reply-To: <20141112155843.GA24803@redhat.com>
References: <20141112155843.GA24803@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/cputime: Fix clock_nanosleep()/
 clock_gettime() inconsistency
Git-Commit-ID: 6e998916dfe327e785e7c2447959b2c1a3ea4930
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e998916dfe327e785e7c2447959b2c1a3ea4930
Gitweb:     http://git.kernel.org/tip/6e998916dfe327e785e7c2447959b2c1a3ea4930
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Wed, 12 Nov 2014 16:58:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:04:20 +0100

sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency

Commit d670ec13178d0 "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
test case in cost of breaking another one. After that commit, calling
clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
of Y time being smaller than X time.

Reproducer/tester can be found further below, it can be compiled and ran by:

	gcc -o tst-cpuclock2 tst-cpuclock2.c -pthread
	while ./tst-cpuclock2 ; do : ; done

This reproducer, when running on a buggy kernel, will complain
about "clock_gettime difference too small".

Issue happens because on start in thread_group_cputimer() we initialize
sum_exec_runtime of cputimer with threads runtime not yet accounted and
then add the threads runtime to running cputimer again on scheduler
tick, making it's sum_exec_runtime bigger than actual threads runtime.

KOSAKI Motohiro posted a fix for this problem, but that patch was never
applied: https://lkml.org/lkml/2013/5/26/191 .

This patch takes different approach to cure the problem. It calls
update_curr() when cputimer starts, that assure we will have updated
stats of running threads and on the next schedule tick we will account
only the runtime that elapsed from cputimer start. That also assure we
have consistent state between cpu times of individual threads and cpu
time of the process consisted by those threads.

Full reproducer (tst-cpuclock2.c):

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

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141112155843.GA24803@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c     | 38 +++++++++++---------------------------
 kernel/sched/deadline.c |  2 ++
 kernel/sched/fair.c     |  7 +++++++
 kernel/sched/rt.c       |  2 ++
 kernel/sched/sched.h    |  2 ++
 5 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 797a6c8..24beb9b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2475,31 +2475,6 @@ EXPORT_PER_CPU_SYMBOL(kstat);
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
-/*
  * Return accounted runtime for the task.
  * In case the task is currently running, return the runtime plus current's
  * pending runtime that have not been accounted yet.
@@ -2508,7 +2483,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-	u64 ns = 0;
+	u64 ns;
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
 	/*
@@ -2527,7 +2502,16 @@ unsigned long long task_sched_runtime(struct task_struct *p)
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
index 3af3d1e..ef2b104 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -726,6 +726,11 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
+static void update_curr_fair(struct rq *rq)
+{
+	update_curr(cfs_rq_of(&rq->curr->se));
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -7956,6 +7961,8 @@ const struct sched_class fair_sched_class = {
 
 	.get_rr_interval	= get_rr_interval_fair,
 
+	.update_curr		= update_curr_fair,
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
