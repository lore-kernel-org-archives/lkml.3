Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaK1SYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:34 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50538 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaK1SYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:30 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 11/30] cputime: Special API to return old-typed cputime
Date: Fri, 28 Nov 2014 19:23:41 +0100
Message-Id: <1417199040-21044-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This API returns the tasks cputime in cputime_t before we convert
cputime internals to use nsecs. Blindly converting all cputime readers
to use this API will later let us convert smoothly and step by step all
these places to use nsec cputime.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/alpha/kernel/osf_sys.c    |  2 +-
 arch/x86/kernel/apm_32.c       |  2 +-
 drivers/isdn/mISDN/stack.c     |  2 +-
 fs/binfmt_elf.c                |  6 +++---
 fs/binfmt_elf_fdpic.c          |  6 +++---
 include/linux/init_task.h      |  2 +-
 include/linux/sched.h          | 43 +++++++++++++++++++++++++++++++++++++----
 kernel/acct.c                  |  2 +-
 kernel/delayacct.c             |  4 ++--
 kernel/signal.c                |  4 ++--
 kernel/time/itimer.c           |  2 +-
 kernel/time/posix-cpu-timers.c | 44 +++++++++++++++++++++---------------------
 kernel/tsacct.c                |  6 +++---
 13 files changed, 80 insertions(+), 45 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 6358718..5451c10 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1146,7 +1146,7 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 	memset(&r, 0, sizeof(r));
 	switch (who) {
 	case RUSAGE_SELF:
-		task_cputime(current, &utime, &stime);
+		task_cputime_t(current, &utime, &stime);
 		utime_jiffies = cputime_to_jiffies(utime);
 		stime_jiffies = cputime_to_jiffies(stime);
 		jiffies_to_timeval32(utime_jiffies, &r.ru_utime);
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index b3949c3..bffca50 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -914,7 +914,7 @@ static int apm_cpu_idle(struct cpuidle_device *dev,
 	unsigned int bucket;
 
 recalc:
-	task_cputime(current, NULL, &stime);
+	task_cputime_t(current, NULL, &stime);
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
 	} else if (jiffies_since_last_check > idle_period) {
diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index 9cb4b62..0a36617 100644
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -306,7 +306,7 @@ mISDNStackd(void *data)
 	       "msg %d sleep %d stopped\n",
 	       dev_name(&st->dev->dev), st->msg_cnt, st->sleep_cnt,
 	       st->stopped_cnt);
-	task_cputime(st->thread, &utime, &stime);
+	task_cputime_t(st->thread, &utime, &stime);
 	printk(KERN_DEBUG
 	       "mISDNStackd daemon for %s utime(%ld) stime(%ld)\n",
 	       dev_name(&st->dev->dev), utime, stime);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d8fc060..84149e2 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1293,19 +1293,19 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
-		struct task_cputime cputime;
+		struct task_cputime_t cputime;
 
 		/*
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime_t(p, &cputime);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
 		cputime_t utime, stime;
 
-		task_cputime(p, &utime, &stime);
+		task_cputime_t(p, &utime, &stime);
 		cputime_to_timeval(utime, &prstatus->pr_utime);
 		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d3634bf..3dc8e5d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1336,19 +1336,19 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
-		struct task_cputime cputime;
+		struct task_cputime_t cputime;
 
 		/*
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime_t(p, &cputime);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
 		cputime_t utime, stime;
 
-		task_cputime(p, &utime, &stime);
+		task_cputime_t(p, &utime, &stime);
 		cputime_to_timeval(utime, &prstatus->pr_utime);
 		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 77fc43f..9aaf2c9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -50,7 +50,7 @@ extern struct fs_struct init_fs;
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
 	.cputimer	= { 						\
-		.cputime = INIT_CPUTIME,				\
+		.cputime = INIT_CPUTIME_T,				\
 		.running = 0,						\
 		.lock = __RAW_SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9e49bae..83f77bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -511,6 +511,14 @@ struct task_cputime {
 	cputime_t stime;
 	unsigned long long sum_exec_runtime;
 };
+
+/* Temporary type to ease cputime_t to nsecs conversion */
+struct task_cputime_t {
+	cputime_t utime;
+	cputime_t stime;
+	unsigned long long sum_exec_runtime;
+};
+
 /* Alternate field names when used to cache expirations. */
 #define prof_exp	stime
 #define virt_exp	utime
@@ -523,6 +531,13 @@ struct task_cputime {
 		.sum_exec_runtime = 0,				\
 	}
 
+#define INIT_CPUTIME_T	\
+	(struct task_cputime_t) {				\
+		.utime = 0,					\
+		.stime = 0,					\
+		.sum_exec_runtime = 0,				\
+	}
+
 #ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_DISABLED	(1 + PREEMPT_ENABLED)
 #else
@@ -549,7 +564,7 @@ struct task_cputime {
  * used for thread group CPU timer calculations.
  */
 struct thread_group_cputimer {
-	struct task_cputime cputime;
+	struct task_cputime_t cputime;
 	int running;
 	raw_spinlock_t lock;
 };
@@ -627,7 +642,7 @@ struct signal_struct {
 	struct thread_group_cputimer cputimer;
 
 	/* Earliest-expiration cache. */
-	struct task_cputime cputime_expires;
+	struct task_cputime_t cputime_expires;
 
 	struct list_head cpu_timers[3];
 
@@ -1385,7 +1400,7 @@ struct task_struct {
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
-	struct task_cputime cputime_expires;
+	struct task_cputime_t cputime_expires;
 	struct list_head cpu_timers[3];
 
 /* process credentials */
@@ -1892,6 +1907,20 @@ static inline u64 task_gtime(struct task_struct *t)
 	return t->gtime;
 }
 #endif
+
+static inline void task_cputime_t(struct task_struct *t,
+				  cputime_t *utime, cputime_t *stime)
+{
+	task_cputime(t, utime, stime);
+}
+
+static inline void task_cputime_t_scaled(struct task_struct *t,
+					 cputime_t *utimescaled,
+					 cputime_t *stimescaled)
+{
+	task_cputime_scaled(t, utimescaled, stimescaled);
+}
+
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
@@ -2892,7 +2921,13 @@ static __always_inline bool need_resched(void)
  * Thread group CPU time accounting.
  */
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
-void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime_t *times);
+
+static inline void thread_group_cputime_t(struct task_struct *tsk,
+					  struct task_cputime_t *times)
+{
+	thread_group_cputime(tsk, (struct task_cputime *)times);
+}
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
diff --git a/kernel/acct.c b/kernel/acct.c
index 33738ef..acfa901 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -561,7 +561,7 @@ void acct_collect(long exitcode, int group_dead)
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
-	task_cputime(current, &utime, &stime);
+	task_cputime_t(current, &utime, &stime);
 	pacct->ac_utime += utime;
 	pacct->ac_stime += stime;
 	pacct->ac_minflt += current->min_flt;
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index ef90b04..8cf2179 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -87,12 +87,12 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	unsigned long flags, t1;
 	s64 tmp;
 
-	task_cputime(tsk, &utime, &stime);
+	task_cputime_t(tsk, &utime, &stime);
 	tmp = (s64)d->cpu_run_real_total;
 	tmp += cputime_to_nsecs(utime + stime);
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
-	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	task_cputime_t_scaled(tsk, &utimescaled, &stimescaled);
 	tmp = (s64)d->cpu_scaled_run_real_total;
 	tmp += cputime_to_nsecs(utimescaled + stimescaled);
 	d->cpu_scaled_run_real_total =
diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f..b0f1f39 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1656,7 +1656,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 				       task_uid(tsk));
 	rcu_read_unlock();
 
-	task_cputime(tsk, &utime, &stime);
+	task_cputime_t(tsk, &utime, &stime);
 	info.si_utime = cputime_to_clock_t(utime + tsk->signal->utime);
 	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
 
@@ -1741,7 +1741,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
 	rcu_read_unlock();
 
-	task_cputime(tsk, &utime, &stime);
+	task_cputime_t(tsk, &utime, &stime);
 	info.si_utime = cputime_to_clock_t(utime);
 	info.si_stime = cputime_to_clock_t(stime);
 
diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index 8d262b4..1b9ddae 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -53,7 +53,7 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	cval = it->expires;
 	cinterval = it->incr;
 	if (cval) {
-		struct task_cputime cputime;
+		struct task_cputime_t cputime;
 		cputime_t t;
 
 		thread_group_cputimer(tsk, &cputime);
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 492b986..429c782 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -116,7 +116,7 @@ static void bump_cpu_timer(struct k_itimer *timer,
  * Checks @cputime to see if all fields are zero.  Returns true if all fields
  * are zero, false if any field is nonzero.
  */
-static inline int task_cputime_zero(const struct task_cputime *cputime)
+static inline int task_cputime_zero(const struct task_cputime_t *cputime)
 {
 	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
 		return 1;
@@ -127,7 +127,7 @@ static inline unsigned long long prof_ticks(struct task_struct *p)
 {
 	cputime_t utime, stime;
 
-	task_cputime(p, &utime, &stime);
+	task_cputime_t(p, &utime, &stime);
 
 	return cputime_to_expires(utime + stime);
 }
@@ -135,7 +135,7 @@ static inline unsigned long long virt_ticks(struct task_struct *p)
 {
 	cputime_t utime;
 
-	task_cputime(p, &utime, NULL);
+	task_cputime_t(p, &utime, NULL);
 
 	return cputime_to_expires(utime);
 }
@@ -196,7 +196,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
-static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
+static void update_gt_cputime(struct task_cputime_t *a, struct task_cputime_t *b)
 {
 	if (b->utime > a->utime)
 		a->utime = b->utime;
@@ -208,10 +208,10 @@ static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 		a->sum_exec_runtime = b->sum_exec_runtime;
 }
 
-void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime_t *times)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
-	struct task_cputime sum;
+	struct task_cputime_t sum;
 	unsigned long flags;
 
 	if (!cputimer->running) {
@@ -221,7 +221,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * to synchronize the timer to the clock every time we start
 		 * it.
 		 */
-		thread_group_cputime(tsk, &sum);
+		thread_group_cputime_t(tsk, &sum);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
 		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
@@ -240,21 +240,21 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
 				  unsigned long long *sample)
 {
-	struct task_cputime cputime;
+	struct task_cputime_t cputime;
 
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime_t(p, &cputime);
 		*sample = cputime_to_expires(cputime.utime + cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime_t(p, &cputime);
 		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime_t(p, &cputime);
 		*sample = cputime.sum_exec_runtime;
 		break;
 	}
@@ -448,7 +448,7 @@ static void arm_timer(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	struct list_head *head, *listpos;
-	struct task_cputime *cputime_expires;
+	struct task_cputime_t *cputime_expires;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
 
@@ -540,7 +540,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
 				  unsigned long long *sample)
 {
-	struct task_cputime cputime;
+	struct task_cputime_t cputime;
 
 	thread_group_cputimer(p, &cputime);
 	switch (CPUCLOCK_WHICH(which_clock)) {
@@ -772,7 +772,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		/*
 		 * Protect against sighand release/switch in exit/exec and
 		 * also make timer sampling safe if it ends up calling
-		 * thread_group_cputime().
+		 * thread_group_cputime_t().
 		 */
 		sighand = lock_task_sighand(p, &flags);
 		if (unlikely(sighand == NULL)) {
@@ -836,7 +836,7 @@ static void check_thread_timers(struct task_struct *tsk,
 {
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
-	struct task_cputime *tsk_expires = &tsk->cputime_expires;
+	struct task_cputime_t *tsk_expires = &tsk->cputime_expires;
 	unsigned long long expires;
 	unsigned long soft;
 
@@ -936,7 +936,7 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
-	struct task_cputime cputime;
+	struct task_cputime_t cputime;
 	unsigned long soft;
 
 	/*
@@ -1024,7 +1024,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	} else {
 		/*
 		 * Protect arm_timer() and timer sampling in case of call to
-		 * thread_group_cputime().
+		 * thread_group_cputime_t().
 		 */
 		sighand = lock_task_sighand(p, &flags);
 		if (unlikely(sighand == NULL)) {
@@ -1069,8 +1069,8 @@ out:
  * Returns true if any field of the former is greater than the corresponding
  * field of the latter if the latter field is set.  Otherwise returns false.
  */
-static inline int task_cputime_expired(const struct task_cputime *sample,
-					const struct task_cputime *expires)
+static inline int task_cputime_expired(const struct task_cputime_t *sample,
+					const struct task_cputime_t *expires)
 {
 	if (expires->utime && sample->utime >= expires->utime)
 		return 1;
@@ -1097,10 +1097,10 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	struct signal_struct *sig;
 	cputime_t utime, stime;
 
-	task_cputime(tsk, &utime, &stime);
+	task_cputime_t(tsk, &utime, &stime);
 
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
-		struct task_cputime task_sample = {
+		struct task_cputime_t task_sample = {
 			.utime = utime,
 			.stime = stime,
 			.sum_exec_runtime = tsk->se.sum_exec_runtime
@@ -1112,7 +1112,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 
 	sig = tsk->signal;
 	if (sig->cputimer.running) {
-		struct task_cputime group_sample;
+		struct task_cputime_t group_sample;
 
 		raw_spin_lock(&sig->cputimer.lock);
 		group_sample = sig->cputimer.cputime;
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 975cb49..4133e94 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -66,11 +66,11 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
 	rcu_read_unlock();
 
-	task_cputime(tsk, &utime, &stime);
+	task_cputime_t(tsk, &utime, &stime);
 	stats->ac_utime = cputime_to_usecs(utime);
 	stats->ac_stime = cputime_to_usecs(stime);
 
-	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	task_cputime_t_scaled(tsk, &utimescaled, &stimescaled);
 	stats->ac_utimescaled = cputime_to_usecs(utimescaled);
 	stats->ac_stimescaled = cputime_to_usecs(stimescaled);
 
@@ -154,7 +154,7 @@ void acct_update_integrals(struct task_struct *tsk)
 {
 	cputime_t utime, stime;
 
-	task_cputime(tsk, &utime, &stime);
+	task_cputime_t(tsk, &utime, &stime);
 	__acct_update_integrals(tsk, utime, stime);
 }
 
-- 
2.1.3

