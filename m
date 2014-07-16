Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaGPVPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:15:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:59736 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaGPVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:35 -0400
Message-Id: <20140716205054.805405622@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 31/64] sched: Make task->start_time nanoseconds based
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=sched-make-start-time-nsec.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the timespec to nsec/usec conversions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    2 +-
 kernel/acct.c         |   10 +++-------
 kernel/fork.c         |    2 +-
 kernel/tsacct.c       |   19 +++++++++----------
 4 files changed, 14 insertions(+), 19 deletions(-)

Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1367,7 +1367,7 @@ struct task_struct {
 	} vtime_snap_whence;
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
-	struct timespec start_time; 		/* monotonic time */
+	u64 start_time;		/* monotonic time in nsec */
 	u64 real_start_time;	/* boot based time in nsec */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
Index: tip/kernel/acct.c
===================================================================
--- tip.orig/kernel/acct.c
+++ tip/kernel/acct.c
@@ -458,9 +458,7 @@ static void do_acct_process(struct bsd_a
 	acct_t ac;
 	mm_segment_t fs;
 	unsigned long flim;
-	u64 elapsed;
-	u64 run_time;
-	struct timespec uptime;
+	u64 elapsed, run_time;
 	struct tty_struct *tty;
 	const struct cred *orig_cred;
 
@@ -484,10 +482,8 @@ static void do_acct_process(struct bsd_a
 	strlcpy(ac.ac_comm, current->comm, sizeof(ac.ac_comm));
 
 	/* calculate run_time in nsec*/
-	ktime_get_ts(&uptime);
-	run_time = (u64)uptime.tv_sec*NSEC_PER_SEC + uptime.tv_nsec;
-	run_time -= (u64)current->group_leader->start_time.tv_sec * NSEC_PER_SEC
-		       + current->group_leader->start_time.tv_nsec;
+	run_time = ktime_get_ns();
+	run_time -= current->group_leader->start_time;
 	/* convert nsec -> AHZ */
 	elapsed = nsec_to_AHZ(run_time);
 #if ACCT_VERSION==3
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -1262,7 +1262,7 @@ static struct task_struct *copy_process(
 
 	posix_cpu_timers_init(p);
 
-	ktime_get_ts(&p->start_time);
+	p->start_time = ktime_get_ns();
 	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
 	p->audit_context = NULL;
Index: tip/kernel/tsacct.c
===================================================================
--- tip.orig/kernel/tsacct.c
+++ tip/kernel/tsacct.c
@@ -31,20 +31,19 @@ void bacct_add_tsk(struct user_namespace
 		   struct taskstats *stats, struct task_struct *tsk)
 {
 	const struct cred *tcred;
-	struct timespec uptime, ts;
 	cputime_t utime, stime, utimescaled, stimescaled;
-	u64 ac_etime;
+	u64 delta;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
-	/* calculate task elapsed time in timespec */
-	ktime_get_ts(&uptime);
-	ts = timespec_sub(uptime, tsk->start_time);
-	/* rebase elapsed time to usec (should never be negative) */
-	ac_etime = timespec_to_ns(&ts);
-	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
+	/* calculate task elapsed time in nsec */
+	delta = ktime_get_ns() - tsk->start_time;
+	/* Convert to micro seconds */
+	do_div(delta, NSEC_PER_USEC);
+	stats->ac_etime = delta;
+	/* Convert to seconds for btime */
+	do_div(delta, USEC_PER_SEC);
+	stats->ac_btime = get_seconds() - delta;
 	if (thread_group_leader(tsk)) {
 		stats->ac_exitcode = tsk->exit_code;
 		if (tsk->flags & PF_FORKNOEXEC)


