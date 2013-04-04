Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3DDJKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab3DDJK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:10:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 4/4] cputime: remove scaling
Date: Thu,  4 Apr 2013 11:10:35 +0200
Message-Id: <1365066635-2959-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scaling cputime cause problems, bunch of them was fixed, but still is possible
to hit multiplication overflow issue, which make {u,s}time values incorrect.
This problem has no good solution in kernel.

This patch remove scaling code and export raw values of {u,t}ime . Procps
programs can use newly introduced sum_exec_runtime to find out precisely
calculated process cpu time and scale utime/stime values accordingly.

Unfortunately times(2) syscall has no such option.

This change affect kernels compiled without CONFIG_VIRT_CPU_ACCOUNTING_*.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 fs/proc/array.c        |    4 +-
 include/linux/sched.h  |   20 --------
 kernel/exit.c          |    4 +-
 kernel/fork.c          |    3 -
 kernel/sched/cputime.c |  117 +-----------------------------------------------
 kernel/sys.c           |    6 +-
 6 files changed, 8 insertions(+), 146 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 1444dc5..5feadc4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -459,7 +459,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime_adjusted(task, &cputime);
+			thread_group_cputime(task, &cputime);
 			utime = cputime.utime;
 			stime = cputime.stime;
 			sum_exec_runtime = cputime.sum_exec_runtime;
@@ -478,7 +478,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_cputime_adjusted(task, &utime, &stime);
+		task_cputime(task, &utime, &stime);
 		sum_exec_runtime = task->se.sum_exec_runtime;
 		gtime = task_gtime(task);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c25772d..23c8ac3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -397,18 +397,6 @@ struct cpu_itimer {
 };
 
 /**
- * struct cputime - snaphsot of system and user cputime
- * @utime: time spent in user mode
- * @stime: time spent in system mode
- *
- * Gathers a generic snapshot of user and system time.
- */
-struct cputime {
-	cputime_t utime;
-	cputime_t stime;
-};
-
-/**
  * struct task_cputime - collected CPU time counts
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
@@ -558,9 +546,6 @@ struct signal_struct {
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-	struct cputime prev_cputime;
-#endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
@@ -1161,9 +1146,6 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-	struct cputime prev_cputime;
-#endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 	seqlock_t vtime_seqlock;
 	unsigned long long vtime_snap;
@@ -1597,8 +1579,6 @@ static inline cputime_t task_gtime(struct task_struct *t)
 	return t->gtime;
 }
 #endif
-extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_cputime_adjusted(struct task_struct *p, struct task_cputime *ct);
 
 /*
  * Per process flags
diff --git a/kernel/exit.c b/kernel/exit.c
index fb158f1..b6bd7ae 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1084,11 +1084,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
-		 * We use thread_group_cputime_adjusted() to get times for the thread
+		 * We use thread_group_cputime() to get times for the thread
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_cputime_adjusted(p, &tg_cputime);
+		thread_group_cputime(p, &tg_cputime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
diff --git a/kernel/fork.c b/kernel/fork.c
index 339f60d..2ae1706 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1233,9 +1233,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->utime = p->stime = p->gtime = 0;
 	p->utimescaled = p->stimescaled = 0;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-	p->prev_cputime.utime = p->prev_cputime.stime = 0;
-#endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 	seqlock_init(&p->vtime_seqlock);
 	p->vtime_snap = 0;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a600f7f..23df74b 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -448,19 +448,7 @@ EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 
-
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	*ut = p->utime;
-	*st = p->stime;
-}
-
-void thread_group_cputime_adjusted(struct task_struct *p, struct task_cputime *cputime)
-{
-	thread_group_cputime(p, cputime);
-}
-#else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 /*
  * Account a single tick of cpu time.
  * @p: the process that the cpu time gets accounted to
@@ -516,109 +504,6 @@ void account_idle_ticks(unsigned long ticks)
 	account_idle_time(jiffies_to_cputime(ticks));
 }
 
-/*
- * Perform (stime * rtime) / total with reduced chances
- * of multiplication overflows by using smaller factors
- * like quotient and remainders of divisions between
- * rtime and total.
- */
-static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
-{
-	u64 rem, res, scaled;
-
-	if (rtime >= total) {
-		/*
-		 * Scale up to rtime / total then add
-		 * the remainder scaled to stime / total.
-		 */
-		res = div64_u64_rem(rtime, total, &rem);
-		scaled = stime * res;
-		scaled += div64_u64(stime * rem, total);
-	} else {
-		/*
-		 * Same in reverse: scale down to total / rtime
-		 * then substract that result scaled to
-		 * to the remaining part.
-		 */
-		res = div64_u64_rem(total, rtime, &rem);
-		scaled = div64_u64(stime, res);
-		scaled -= div64_u64(scaled * rem, total);
-	}
-
-	return (__force cputime_t) scaled;
-}
-
-/*
- * Adjust tick based cputime random precision against scheduler
- * runtime accounting.
- */
-static void cputime_adjust(struct task_cputime *curr,
-			   struct cputime *prev,
-			   cputime_t *ut, cputime_t *st)
-{
-	cputime_t rtime, stime, total;
-
-	if (vtime_accounting_enabled()) {
-		*ut = curr->utime;
-		*st = curr->stime;
-		return;
-	}
-
-	stime = curr->stime;
-	total = stime + curr->utime;
-
-	/*
-	 * Tick based cputime accounting depend on random scheduling
-	 * timeslices of a task to be interrupted or not by the timer.
-	 * Depending on these circumstances, the number of these interrupts
-	 * may be over or under-optimistic, matching the real user and system
-	 * cputime with a variable precision.
-	 *
-	 * Fix this by scaling these tick based values against the total
-	 * runtime accounted by the CFS scheduler.
-	 */
-	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
-
-	if (!rtime) {
-		stime = 0;
-	} else if (!total) {
-		stime = rtime;
-	} else {
-		stime = scale_stime((__force u64)stime,
-				    (__force u64)rtime, (__force u64)total);
-	}
-
-	/*
-	 * If the tick based count grows faster than the scheduler one,
-	 * the result of the scaling may go backward.
-	 * Let's enforce monotonicity.
-	 */
-	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, rtime - prev->stime);
-
-	*ut = prev->utime;
-	*st = prev->stime;
-}
-
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
-{
-	struct task_cputime cputime = {
-		.sum_exec_runtime = p->se.sum_exec_runtime,
-	};
-
-	task_cputime(p, &cputime.utime, &cputime.stime);
-	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
-}
-
-/*
- * Must be called with siglock held.
- */
-void thread_group_cputime_adjusted(struct task_struct *p, struct task_cputime *cputime)
-{
-	thread_group_cputime(p, cputime);
-	cputime_adjust(cputime, &p->signal->prev_cputime,
-		       &cputime->utime, &cputime->stime);
-}
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
diff --git a/kernel/sys.c b/kernel/sys.c
index 2f555c1..00f143e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1049,7 +1049,7 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime tg_cputime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_cputime_adjusted(current, &tg_cputime);
+	thread_group_cputime(current, &tg_cputime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -1708,7 +1708,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	utime = stime = 0;
 
 	if (who == RUSAGE_THREAD) {
-		task_cputime_adjusted(current, &utime, &stime);
+		task_cputime(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
 		maxrss = p->signal->maxrss;
 		goto out;
@@ -1734,7 +1734,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_cputime_adjusted(p, &tg_cputime);
+			thread_group_cputime(p, &tg_cputime);
 			utime += tg_cputime.utime;
 			stime += tg_cputime.stime;
 			r->ru_nvcsw += p->signal->nvcsw;
-- 
1.7.1

