Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966013Ab3DQRlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:41:21 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:59048 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965148Ab3DQRlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:41:19 -0400
Message-ID: <1366220466.2855.14.camel@Wailaba2>
Subject: [PATCH] Remove spurious cputimer restart and eliminate its drift
From: Olivier Langlois <olivier@trillion01.com>
To: tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 13:41:06 -0400
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the call to stop_process_timers() in order to:

1. It catches the exceptionnal case where it would be
   started without arming any timers in posix_cpu_timer_set()
 2. You could end up with no process timers for a short
    period of time when they find themselves in the firing
    list. Let 1 tick to periodic timers to have the
    opportunity to get rearmed.

Also forbids the cputimer to drift ahead of its process clock by
blocking its update when a tick occurs while a autoreaping task
is currently in do_exit() between the call to release_task() and
its final call to schedule().

Any task stats update after having called release_task() will
be lost because they are added to the global process stats located
in the signal struct from release_task().

Ideally, you should postpone the release_task() call after the
final context switch to get all the stats added but this is
more complex to achieve.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 kernel/posix-cpu-timers.c | 44 +++++++++++++++++++++++++-------------------
 kernel/sched/fair.c       | 10 +++++++++-
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..7cecdb9 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1130,8 +1130,6 @@ static void check_process_timers(struct task_struct *tsk,
 	sig->cputime_expires.prof_exp = prof_expires;
 	sig->cputime_expires.virt_exp = virt_expires;
 	sig->cputime_expires.sched_exp = sched_expires;
-	if (task_cputime_zero(&sig->cputime_expires))
-		stop_process_timers(sig);
 }
 
 /*
@@ -1238,34 +1236,42 @@ static inline int task_cputime_expired(const struct task_cputime *sample,
  */
 static inline int fastpath_timer_check(struct task_struct *tsk)
 {
-	struct signal_struct *sig;
-	cputime_t utime, stime;
+	struct signal_struct *sig = tsk->signal;
 
-	task_cputime(tsk, &utime, &stime);
+	if (sig->cputimer.running) {
+		if (likely(!task_cputime_zero(&sig->cputime_expires))) {
+			struct task_cputime group_sample;
+
+			raw_spin_lock(&sig->cputimer.lock);
+			group_sample = sig->cputimer.cputime;
+			raw_spin_unlock(&sig->cputimer.lock);
+
+			if (task_cputime_expired(&group_sample, &sig->cputime_expires))
+				return 1;
+		} else
+		/*
+		 * Stopping the process timer here has 2 benefits.
+		 *
+		 * 1. It catches the exceptionnal case where it would be
+		 *   started without arming any timers in posix_cpu_timer_set()
+		 * 2. You could end up with no process timers for a short
+		 *    period of time when they find themselves in the firing
+		 *    list. Let 1 tick to periodic timers to have the
+		 *    opportunity to get rearmed.
+		 */
+			stop_process_timers(sig);
+	}
 
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
-			.utime = utime,
-			.stime = stime,
 			.sum_exec_runtime = tsk->se.sum_exec_runtime
 		};
+		task_cputime(tsk, &task_sample.utime, &task_sample.stime);
 
 		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
 			return 1;
 	}
 
-	sig = tsk->signal;
-	if (sig->cputimer.running) {
-		struct task_cputime group_sample;
-
-		raw_spin_lock(&sig->cputimer.lock);
-		group_sample = sig->cputimer.cputime;
-		raw_spin_unlock(&sig->cputimer.lock);
-
-		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
-			return 1;
-	}
-
 	return 0;
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..52d7b10 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -708,7 +708,15 @@ static void update_curr(struct cfs_rq *cfs_rq)
 
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
-		account_group_exec_runtime(curtask, delta_exec);
+		/*
+		 * Do not update the cputimer if the task is already released by
+		 * release_task().
+		 *
+		 * it would preferable to defer the autoreap release_task
+		 * after the last context switch but harder to do.
+		 */
+		if (likely(curtask->sighand))
+			account_group_exec_runtime(curtask, delta_exec);
 	}
 
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
-- 
1.8.2.1




