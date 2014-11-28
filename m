Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaK1S3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:29:19 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37109 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaK1SYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:32 -0500
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
Subject: [RFC PATCH 12/30] cputime: Convert task/group cputime to nsecs
Date: Fri, 28 Nov 2014 19:23:42 +0100
Message-Id: <1417199040-21044-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that most cputime readers use the transition API which return the
task cputime in old style cputime_t, we can safely store the cputime in
nsecs.

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
 arch/alpha/kernel/osf_sys.c |  4 +--
 fs/binfmt_elf.c             | 11 ++++++--
 fs/binfmt_elf_fdpic.c       |  4 +--
 fs/proc/array.c             |  9 +++++--
 include/linux/cputime.h     | 12 +++++++++
 include/linux/sched.h       | 51 ++++++++++++++++++++++++------------
 kernel/exit.c               |  4 +--
 kernel/sched/cputime.c      | 63 ++++++++++++++++++++++-----------------------
 kernel/sys.c                | 16 ++++++------
 9 files changed, 107 insertions(+), 67 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 5451c10..a6e4491 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1155,8 +1155,8 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 		r.ru_majflt = current->maj_flt;
 		break;
 	case RUSAGE_CHILDREN:
-		utime_jiffies = cputime_to_jiffies(current->signal->cutime);
-		stime_jiffies = cputime_to_jiffies(current->signal->cstime);
+		utime_jiffies = nsecs_to_jiffies(current->signal->cutime);
+		stime_jiffies = nsecs_to_jiffies(current->signal->cstime);
 		jiffies_to_timeval32(utime_jiffies, &r.ru_utime);
 		jiffies_to_timeval32(stime_jiffies, &r.ru_stime);
 		r.ru_minflt = current->signal->cmin_flt;
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 84149e2..646cfc3 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1283,6 +1283,8 @@ static void fill_note(struct memelfnote *note, const char *name, int type,
 static void fill_prstatus(struct elf_prstatus *prstatus,
 		struct task_struct *p, long signr)
 {
+	struct timeval tv;
+
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
@@ -1309,8 +1311,13 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		cputime_to_timeval(utime, &prstatus->pr_utime);
 		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
-	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
-	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
+	tv = ns_to_timeval(p->signal->cutime);
+	prstatus->pr_cutime.tv_sec = tv.tv_sec;
+	prstatus->pr_cutime.tv_usec = tv.tv_usec;
+
+	tv = ns_to_timeval(p->signal->cstime);
+	prstatus->pr_cstime.tv_sec = tv.tv_sec;
+	prstatus->pr_cstime.tv_usec = tv.tv_usec;
 }
 
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 3dc8e5d..fecdb6d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1352,8 +1352,8 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		cputime_to_timeval(utime, &prstatus->pr_utime);
 		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
-	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
-	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
+	prstatus->pr_cutime = ns_to_timeval(p->signal->cutime);
+	prstatus->pr_cstime = ns_to_timeval(p->signal->cstime);
 
 	prstatus->pr_exec_fdpic_loadmap = p->mm->context.exec_fdpic_loadmap;
 	prstatus->pr_interp_fdpic_loadmap = p->mm->context.interp_fdpic_loadmap;
diff --git a/fs/proc/array.c b/fs/proc/array.c
index e4a8ef1..de4fe51 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -385,6 +385,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long  min_flt = 0,  maj_flt = 0;
 	cputime_t cutime, cstime, utime, stime;
 	u64 cgtime, gtime;
+	u64 nutime, nstime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -439,7 +440,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime_adjusted(task, &utime, &stime);
+			thread_group_cputime_adjusted(task, &nutime, &nstime);
+			utime = nsecs_to_cputime(nutime);
+			stime = nsecs_to_cputime(nstime);
 			gtime += sig->gtime;
 		}
 
@@ -455,7 +458,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_cputime_adjusted(task, &utime, &stime);
+		task_cputime_adjusted(task, &nutime, &nstime);
+		utime = nsecs_to_cputime(nutime);
+		stime = nsecs_to_cputime(nstime);
 		gtime = task_gtime(task);
 	}
 
diff --git a/include/linux/cputime.h b/include/linux/cputime.h
index a225ab9..ff843a9 100644
--- a/include/linux/cputime.h
+++ b/include/linux/cputime.h
@@ -23,4 +23,16 @@
 	((__force cputime64_t) nsecs_to_cputime(__nsecs))
 #endif
 
+#ifndef nsecs_to_scaled
+static inline u64 nsecs_to_scaled(u64 nsecs)
+{
+	cputime_t cputime, scaled;
+
+	cputime = nsecs_to_cputime(nsecs);
+	scaled = cputime_to_scaled(cputime);
+
+	return cputime_to_nsecs(scaled);
+}
+#endif
+
 #endif /* __LINUX_CPUTIME_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 83f77bf..3be3b0b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -488,8 +488,8 @@ struct cpu_itimer {
  * Gathers a generic snapshot of user and system time.
  */
 struct cputime {
-	cputime_t utime;
-	cputime_t stime;
+	u64 utime;
+	u64 stime;
 };
 
 /**
@@ -507,8 +507,8 @@ struct cputime {
  * of them in parallel.
  */
 struct task_cputime {
-	cputime_t utime;
-	cputime_t stime;
+	u64 utime;
+	u64 stime;
 	unsigned long long sum_exec_runtime;
 };
 
@@ -663,7 +663,7 @@ struct signal_struct {
 	 * in __exit_signal, except for the group leader.
 	 */
 	seqlock_t stats_lock;
-	cputime_t utime, stime, cutime, cstime;
+	u64 utime, stime, cutime, cstime;
 	u64 gtime;
 	u64 cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
@@ -1380,7 +1380,7 @@ struct task_struct {
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	cputime_t utime, stime, utimescaled, stimescaled;
+	u64 utime, stime, utimescaled, stimescaled;
 	u64 gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
@@ -1878,13 +1878,13 @@ static inline void put_task_struct(struct task_struct *t)
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 extern void task_cputime(struct task_struct *t,
-			 cputime_t *utime, cputime_t *stime);
+			 u64 *utime, u64 *stime);
 extern void task_cputime_scaled(struct task_struct *t,
-				cputime_t *utimescaled, cputime_t *stimescaled);
+				u64 *utimescaled, u64 *stimescaled);
 extern u64 task_gtime(struct task_struct *t);
 #else
 static inline void task_cputime(struct task_struct *t,
-				cputime_t *utime, cputime_t *stime)
+				u64 *utime, u64 *stime)
 {
 	if (utime)
 		*utime = t->utime;
@@ -1893,8 +1893,8 @@ static inline void task_cputime(struct task_struct *t,
 }
 
 static inline void task_cputime_scaled(struct task_struct *t,
-				       cputime_t *utimescaled,
-				       cputime_t *stimescaled)
+				       u64 *utimescaled,
+				       u64 *stimescaled)
 {
 	if (utimescaled)
 		*utimescaled = t->utimescaled;
@@ -1911,18 +1911,30 @@ static inline u64 task_gtime(struct task_struct *t)
 static inline void task_cputime_t(struct task_struct *t,
 				  cputime_t *utime, cputime_t *stime)
 {
-	task_cputime(t, utime, stime);
+	u64 ut, st;
+
+	task_cputime(t, &ut, &st);
+	if (utime)
+		*utime = nsecs_to_cputime(ut);
+	if (stime)
+		*stime = nsecs_to_cputime(st);
 }
 
 static inline void task_cputime_t_scaled(struct task_struct *t,
 					 cputime_t *utimescaled,
 					 cputime_t *stimescaled)
 {
-	task_cputime_scaled(t, utimescaled, stimescaled);
+	u64 ut, st;
+
+	task_cputime_scaled(t, &ut, &st);
+	if (utimescaled)
+		*utimescaled = nsecs_to_cputime(ut);
+	if (stimescaled)
+		*stimescaled = nsecs_to_cputime(st);
 }
 
-extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st);
+extern void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st);
 
 /*
  * Per process flags
@@ -2924,9 +2936,14 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime_t *times);
 
 static inline void thread_group_cputime_t(struct task_struct *tsk,
-					  struct task_cputime_t *times)
+					  struct task_cputime_t *cputime)
 {
-	thread_group_cputime(tsk, (struct task_cputime *)times);
+	struct task_cputime times;
+
+	thread_group_cputime(tsk, &times);
+	cputime->utime = nsecs_to_cputime(times.utime);
+	cputime->stime = nsecs_to_cputime(times.stime);
+	cputime->sum_exec_runtime = times.sum_exec_runtime;
 }
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
diff --git a/kernel/exit.c b/kernel/exit.c
index 5d30019..9df0729 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -86,7 +86,7 @@ static void __exit_signal(struct task_struct *tsk)
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
-	cputime_t utime, stime;
+	u64 utime, stime;
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					lockdep_tasklist_lock_is_held());
@@ -1022,7 +1022,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
-		cputime_t tgutime, tgstime;
+		u64 tgutime, tgstime;
 
 		/*
 		 * The resource counters for the group leader are in its
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index f3701ab..eefe1ec 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -138,8 +138,8 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	int index;
 
 	/* Add user time to process. */
-	p->utime += cputime;
-	p->utimescaled += cputime_scaled;
+	p->utime += cputime_to_nsecs(cputime);
+	p->utimescaled += cputime_to_nsecs(cputime_scaled);
 	account_group_user_time(p, cputime);
 
 	index = (task_nice(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
@@ -163,10 +163,10 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	/* Add guest time to process. */
-	p->utime += cputime;
-	p->utimescaled += cputime_scaled;
+	p->utime += cputime_to_nsecs(cputime);
+	p->utimescaled += cputime_to_nsecs(cputime_scaled);
 	account_group_user_time(p, cputime);
-	p->gtime += cptime_to_nsecs(cputime);
+	p->gtime += cputime_to_nsecs(cputime);
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
@@ -190,8 +190,8 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 			cputime_t cputime_scaled, int index)
 {
 	/* Add system time to process. */
-	p->stime += cputime;
-	p->stimescaled += cputime_scaled;
+	p->stime += cputime_to_nsecs(cputime);
+	p->stimescaled += cputime_to_nsecs(cputime_scaled);
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
@@ -286,7 +286,7 @@ static __always_inline bool steal_account_process_tick(void)
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
 	struct signal_struct *sig = tsk->signal;
-	cputime_t utime, stime;
+	u64 utime, stime;
 	struct task_struct *t;
 	unsigned int seq, nextseq;
 	unsigned long flags;
@@ -440,13 +440,13 @@ EXPORT_SYMBOL_GPL(vtime_common_account_irq_enter);
 
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 {
 	*ut = p->utime;
 	*st = p->stime;
 }
 
-void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 {
 	struct task_cputime cputime;
 
@@ -515,7 +515,7 @@ void account_idle_ticks(unsigned long ticks)
  * Perform (stime * rtime) / total, but avoid multiplication overflow by
  * loosing precision when the numbers are big.
  */
-static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
+static u64 scale_stime(u64 stime, u64 rtime, u64 total)
 {
 	u64 scaled;
 
@@ -552,7 +552,7 @@ drop_precision:
 	 * followed by a 64/32->64 divide.
 	 */
 	scaled = div_u64((u64) (u32) stime * (u64) (u32) rtime, (u32)total);
-	return (__force cputime_t) scaled;
+	return scaled;
 }
 
 /*
@@ -564,12 +564,12 @@ drop_precision:
  * Normally a caller will only go through this loop once, or not
  * at all in case a previous caller updated counter the same jiffy.
  */
-static void cputime_advance(cputime_t *counter, cputime_t new)
+static void cputime_advance(u64 *counter, u64 new)
 {
-	cputime_t old;
+	u64 old;
 
 	while (new > (old = ACCESS_ONCE(*counter)))
-		cmpxchg_cputime(counter, old, new);
+		cmpxchg64(counter, old, new);
 }
 
 /*
@@ -578,9 +578,9 @@ static void cputime_advance(cputime_t *counter, cputime_t new)
  */
 static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
-			   cputime_t *ut, cputime_t *st)
+			   u64 *ut, u64 *st)
 {
-	cputime_t rtime, stime, utime;
+	u64 rtime, stime, utime;
 
 	/*
 	 * Tick based cputime accounting depend on random scheduling
@@ -592,7 +592,7 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * Fix this by scaling these tick based values against the total
 	 * runtime accounted by the CFS scheduler.
 	 */
-	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
+	rtime = curr->sum_exec_runtime;
 
 	/*
 	 * Update userspace visible utime/stime values only if actual execution
@@ -610,10 +610,9 @@ static void cputime_adjust(struct task_cputime *curr,
 	} else if (stime == 0) {
 		utime = rtime;
 	} else {
-		cputime_t total = stime + utime;
+		u64 total = stime + utime;
 
-		stime = scale_stime((__force u64)stime,
-				    (__force u64)rtime, (__force u64)total);
+		stime = scale_stime(stime, rtime, total);
 		utime = rtime - stime;
 	}
 
@@ -625,7 +624,7 @@ out:
 	*st = prev->stime;
 }
 
-void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 {
 	struct task_cputime cputime = {
 		.sum_exec_runtime = p->se.sum_exec_runtime,
@@ -635,7 +634,7 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
-void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 {
 	struct task_cputime cputime;
 
@@ -787,9 +786,9 @@ u64 task_gtime(struct task_struct *t)
  */
 static void
 fetch_task_cputime(struct task_struct *t,
-		   cputime_t *u_dst, cputime_t *s_dst,
-		   cputime_t *u_src, cputime_t *s_src,
-		   cputime_t *udelta, cputime_t *sdelta)
+		   u64 *u_dst, u64 *s_dst,
+		   u64 *u_src, u64 *s_src,
+		   u64 *udelta, u64 *sdelta)
 {
 	unsigned int seq;
 	unsigned long long delta;
@@ -826,9 +825,9 @@ fetch_task_cputime(struct task_struct *t,
 }
 
 
-void task_cputime(struct task_struct *t, cputime_t *utime, cputime_t *stime)
+void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 {
-	cputime_t udelta, sdelta;
+	u64 udelta, sdelta;
 
 	fetch_task_cputime(t, utime, stime, &t->utime,
 			   &t->stime, &udelta, &sdelta);
@@ -839,15 +838,15 @@ void task_cputime(struct task_struct *t, cputime_t *utime, cputime_t *stime)
 }
 
 void task_cputime_scaled(struct task_struct *t,
-			 cputime_t *utimescaled, cputime_t *stimescaled)
+			 u64 *utimescaled, u64 *stimescaled)
 {
-	cputime_t udelta, sdelta;
+	u64 udelta, sdelta;
 
 	fetch_task_cputime(t, utimescaled, stimescaled,
 			   &t->utimescaled, &t->stimescaled, &udelta, &sdelta);
 	if (utimescaled)
-		*utimescaled += cputime_to_scaled(udelta);
+		*utimescaled += nsecs_to_scaled(udelta);
 	if (stimescaled)
-		*stimescaled += cputime_to_scaled(sdelta);
+		*stimescaled += nsecs_to_scaled(sdelta);
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
diff --git a/kernel/sys.c b/kernel/sys.c
index 1eaa2f0..aa9dab9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -867,15 +867,15 @@ SYSCALL_DEFINE0(getegid)
 
 void do_sys_times(struct tms *tms)
 {
-	cputime_t tgutime, tgstime, cutime, cstime;
+	u64 tgutime, tgstime, cutime, cstime;
 
 	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
-	tms->tms_utime = cputime_to_clock_t(tgutime);
-	tms->tms_stime = cputime_to_clock_t(tgstime);
-	tms->tms_cutime = cputime_to_clock_t(cutime);
-	tms->tms_cstime = cputime_to_clock_t(cstime);
+	tms->tms_utime = nsec_to_clock_t(tgutime);
+	tms->tms_stime = nsec_to_clock_t(tgstime);
+	tms->tms_cutime = nsec_to_clock_t(cutime);
+	tms->tms_cstime = nsec_to_clock_t(cstime);
 }
 
 SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
@@ -1528,7 +1528,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
 	unsigned long flags;
-	cputime_t tgutime, tgstime, utime, stime;
+	u64 tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
 
 	memset((char *)r, 0, sizeof (*r));
@@ -1584,8 +1584,8 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	unlock_task_sighand(p, &flags);
 
 out:
-	cputime_to_timeval(utime, &r->ru_utime);
-	cputime_to_timeval(stime, &r->ru_stime);
+	r->ru_utime = ns_to_timeval(utime);
+	r->ru_stime = ns_to_timeval(stime);
 
 	if (who != RUSAGE_CHILDREN) {
 		struct mm_struct *mm = get_task_mm(p);
-- 
2.1.3

