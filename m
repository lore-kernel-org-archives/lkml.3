Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3KWPi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:38:59 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:37199 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab3KWPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:33 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/10] posix-timers: Consolidate posix_cpu_clock_get()
Date: Sat, 23 Nov 2013 16:37:16 +0100
Message-Id: <1385221040-24731-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the clock sampling common code used for both local
and remote targets.

Note that this introduces a tiny user ABI change: if a
PID is passed to clock_gettime() along the clockid,
we used to forbid a process wide clock sample when that
PID doesn't belong to a group leader. Now after this patch
we allow process wide clock samples if that PID belongs to
the current task, even if the current task is not the
group leader.

But local process wide clock samples are allowed if PID == 0
(current task) even if the current task is not the group leader.
So in the end this should be no big deal as this actually harmonize
the behaviour when the remote sample is actually a local one.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 64 ++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 34 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bf49832..7117f6d 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -260,30 +260,43 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	return 0;
 }
 
+static int posix_cpu_clock_get_task(struct task_struct *tsk,
+				    const clockid_t which_clock,
+				    struct timespec *tp)
+{
+	int err = -EINVAL;
+	unsigned long long rtn;
+
+	if (CPUCLOCK_PERTHREAD(which_clock)) {
+		if (same_thread_group(tsk, current))
+			err = cpu_clock_sample(which_clock, tsk, &rtn);
+	} else {
+		read_lock(&tasklist_lock);
+
+		if (tsk->sighand && (tsk == current || thread_group_leader(tsk)))
+			err = cpu_clock_sample_group(which_clock, tsk, &rtn);
+
+		read_unlock(&tasklist_lock);
+	}
+
+	if (!err)
+		sample_to_timespec(which_clock, rtn, tp);
+
+	return err;
+}
+
 
 static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
-	int error = -EINVAL;
-	unsigned long long rtn;
+	int err = -EINVAL;
 
 	if (pid == 0) {
 		/*
 		 * Special case constant value for our own clocks.
 		 * We don't have to do any lookup to find ourselves.
 		 */
-		if (CPUCLOCK_PERTHREAD(which_clock)) {
-			/*
-			 * Sampling just ourselves we can do with no locking.
-			 */
-			error = cpu_clock_sample(which_clock,
-						 current, &rtn);
-		} else {
-			read_lock(&tasklist_lock);
-			error = cpu_clock_sample_group(which_clock,
-						       current, &rtn);
-			read_unlock(&tasklist_lock);
-		}
+		err = posix_cpu_clock_get_task(current, which_clock, tp);
 	} else {
 		/*
 		 * Find the given PID, and validate that the caller
@@ -292,29 +305,12 @@ static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 		struct task_struct *p;
 		rcu_read_lock();
 		p = find_task_by_vpid(pid);
-		if (p) {
-			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
-					error = cpu_clock_sample(which_clock,
-								 p, &rtn);
-				}
-			} else {
-				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->sighand) {
-					error =
-					    cpu_clock_sample_group(which_clock,
-							           p, &rtn);
-				}
-				read_unlock(&tasklist_lock);
-			}
-		}
+		if (p)
+			err = posix_cpu_clock_get_task(p, which_clock, tp);
 		rcu_read_unlock();
 	}
 
-	if (error)
-		return error;
-	sample_to_timespec(which_clock, rtn, tp);
-	return 0;
+	return err;
 }
 
 
-- 
1.8.3.1

