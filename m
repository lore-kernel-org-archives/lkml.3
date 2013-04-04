Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3DDJK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab3DDJKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:10:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 1/4] cputime: change parameter of thread_group_cputime_adjusted
Date: Thu,  4 Apr 2013 11:10:32 +0200
Message-Id: <1365066635-2959-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation for further changes in cputime code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 fs/proc/array.c        |    5 ++++-
 include/linux/sched.h  |    2 +-
 kernel/exit.c          |    8 ++++----
 kernel/sched/cputime.c |   18 ++++++------------
 kernel/sys.c           |   18 ++++++++++--------
 5 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index f7ed9ee..fef7850 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -446,6 +446,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		/* add up live thread stats at the group level */
 		if (whole) {
 			struct task_struct *t = task;
+			struct task_cputime cputime;
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
@@ -455,7 +456,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime_adjusted(task, &utime, &stime);
+			thread_group_cputime_adjusted(task, &cputime);
+			utime = cputime.utime;
+			stime = cputime.stime;
 			gtime += sig->gtime;
 		}
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4c3925e..01fc6d4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1595,7 +1595,7 @@ static inline cputime_t task_gtime(struct task_struct *t)
 }
 #endif
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void thread_group_cputime_adjusted(struct task_struct *p, struct task_cputime *ct);
 
 /*
  * Per process flags
diff --git a/kernel/exit.c b/kernel/exit.c
index 60bc027..27f0907 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1067,7 +1067,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
-		cputime_t tgutime, tgstime;
+		struct task_cputime tg_cputime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1088,12 +1088,12 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
+		thread_group_cputime_adjusted(p, &tg_cputime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
-		psig->cutime += tgutime + sig->cutime;
-		psig->cstime += tgstime + sig->cstime;
+		psig->cutime += tg_cputime.utime + sig->cutime;
+		psig->cstime += tg_cputime.stime + sig->cstime;
 		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 4006b42..a600f7f 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -456,14 +456,9 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	*st = p->stime;
 }
 
-void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, struct task_cputime *cputime)
 {
-	struct task_cputime cputime;
-
-	thread_group_cputime(p, &cputime);
-
-	*ut = cputime.utime;
-	*st = cputime.stime;
+	thread_group_cputime(p, cputime);
 }
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 /*
@@ -618,12 +613,11 @@ void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 /*
  * Must be called with siglock held.
  */
-void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, struct task_cputime *cputime)
 {
-	struct task_cputime cputime;
-
-	thread_group_cputime(p, &cputime);
-	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
+	thread_group_cputime(p, cputime);
+	cputime_adjust(cputime, &p->signal->prev_cputime,
+		       &cputime->utime, &cputime->stime);
 }
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 39c9c4a..2f555c1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1045,15 +1045,16 @@ change_okay:
 
 void do_sys_times(struct tms *tms)
 {
-	cputime_t tgutime, tgstime, cutime, cstime;
+	cputime_t cutime, cstime;
+	struct task_cputime tg_cputime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
+	thread_group_cputime_adjusted(current, &tg_cputime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
-	tms->tms_utime = cputime_to_clock_t(tgutime);
-	tms->tms_stime = cputime_to_clock_t(tgstime);
+	tms->tms_utime = cputime_to_clock_t(tg_cputime.utime);
+	tms->tms_stime = cputime_to_clock_t(tg_cputime.stime);
 	tms->tms_cutime = cputime_to_clock_t(cutime);
 	tms->tms_cstime = cputime_to_clock_t(cstime);
 }
@@ -1699,8 +1700,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
 	unsigned long flags;
-	cputime_t tgutime, tgstime, utime, stime;
+	cputime_t utime, stime;
 	unsigned long maxrss = 0;
+	struct task_cputime tg_cputime;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = 0;
@@ -1732,9 +1734,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-			utime += tgutime;
-			stime += tgstime;
+			thread_group_cputime_adjusted(p, &tg_cputime);
+			utime += tg_cputime.utime;
+			stime += tg_cputime.stime;
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
-- 
1.7.1

