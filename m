Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaK1SYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:30 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54446 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaK1SY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:28 -0500
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
Subject: [RFC PATCH 10/30] cputime: Convert guest time accounting to nsecs
Date: Fri, 28 Nov 2014 19:23:40 +0100
Message-Id: <1417199040-21044-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 fs/proc/array.c        |  6 +++---
 include/linux/sched.h  | 10 +++++-----
 kernel/sched/cputime.c |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cd3653e..e4a8ef1 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -384,7 +384,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
 	cputime_t cutime, cstime, utime, stime;
-	cputime_t cgtime, gtime;
+	u64 cgtime, gtime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -511,8 +511,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	seq_put_decimal_ull(m, ' ', task->rt_priority);
 	seq_put_decimal_ull(m, ' ', task->policy);
 	seq_put_decimal_ull(m, ' ', delayacct_blkio_ticks(task));
-	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(gtime));
-	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cgtime));
+	seq_put_decimal_ull(m, ' ', nsec_to_clock_t(gtime));
+	seq_put_decimal_ll(m, ' ', nsec_to_clock_t(cgtime));
 
 	if (mm && permitted) {
 		seq_put_decimal_ull(m, ' ', mm->start_data);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..9e49bae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -649,8 +649,8 @@ struct signal_struct {
 	 */
 	seqlock_t stats_lock;
 	cputime_t utime, stime, cutime, cstime;
-	cputime_t gtime;
-	cputime_t cgtime;
+	u64 gtime;
+	u64 cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
 #endif
@@ -1366,7 +1366,7 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	cputime_t utime, stime, utimescaled, stimescaled;
-	cputime_t gtime;
+	u64 gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	struct cputime prev_cputime;
 #endif
@@ -1866,7 +1866,7 @@ extern void task_cputime(struct task_struct *t,
 			 cputime_t *utime, cputime_t *stime);
 extern void task_cputime_scaled(struct task_struct *t,
 				cputime_t *utimescaled, cputime_t *stimescaled);
-extern cputime_t task_gtime(struct task_struct *t);
+extern u64 task_gtime(struct task_struct *t);
 #else
 static inline void task_cputime(struct task_struct *t,
 				cputime_t *utime, cputime_t *stime)
@@ -1887,7 +1887,7 @@ static inline void task_cputime_scaled(struct task_struct *t,
 		*stimescaled = t->stimescaled;
 }
 
-static inline cputime_t task_gtime(struct task_struct *t)
+static inline u64 task_gtime(struct task_struct *t)
 {
 	return t->gtime;
 }
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 6cfdc2b..f3701ab 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -166,7 +166,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
-	p->gtime += cputime;
+	p->gtime += cptime_to_nsecs(cputime);
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
@@ -763,10 +763,10 @@ void vtime_init_idle(struct task_struct *t, int cpu)
 	write_sequnlock_irqrestore(&t->vtime_seqlock, flags);
 }
 
-cputime_t task_gtime(struct task_struct *t)
+u64 task_gtime(struct task_struct *t)
 {
 	unsigned int seq;
-	cputime_t gtime;
+	u64 gtime;
 
 	do {
 		seq = read_seqbegin(&t->vtime_seqlock);
-- 
2.1.3

