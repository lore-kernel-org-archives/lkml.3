Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880Ab3DSOwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:52:10 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60579 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030702Ab3DSOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:51:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] posix_timers: New API to prevent from stopping the tick when timers are running
Date: Fri, 19 Apr 2013 16:51:40 +0200
Message-Id: <1366383100-17053-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
References: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring a new helper that the full dynticks infrastructure can
call in order to know if it can safely stop the tick from
the posix cpu timers subsystem point of view.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/posix-timers.h |    2 ++
 kernel/posix-cpu-timers.c    |   41 ++++++++++++++++++++++++++---------------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 042058f..3698d9d 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -122,6 +122,8 @@ void run_posix_cpu_timers(struct task_struct *task);
 void posix_cpu_timers_exit(struct task_struct *task);
 void posix_cpu_timers_exit_group(struct task_struct *task);
 
+bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk);
+
 void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 0bc3356..84d5cb3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -155,6 +155,21 @@ static void bump_cpu_timer(struct k_itimer *timer,
 	}
 }
 
+/**
+ * task_cputime_zero - Check a task_cputime struct for all zero fields.
+ *
+ * @cputime:	The struct to compare.
+ *
+ * Checks @cputime to see if all fields are zero.  Returns true if all fields
+ * are zero, false if any field is nonzero.
+ */
+static inline int task_cputime_zero(const struct task_cputime *cputime)
+{
+	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
+		return 1;
+	return 0;
+}
+
 static inline cputime_t prof_ticks(struct task_struct *p)
 {
 	cputime_t utime, stime;
@@ -654,6 +669,17 @@ static void posix_cpu_timer_kick_nohz(void)
 {
 	schedule_work(&nohz_kick_work);
 }
+
+bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk)
+{
+	if (!task_cputime_zero(&tsk->cputime_expires))
+		return true;
+
+	if (tsk->signal->cputimer.running)
+		return true;
+
+	return false;
+}
 #else
 static inline void posix_cpu_timer_kick_nohz(void) { }
 #endif
@@ -1032,21 +1058,6 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 	}
 }
 
-/**
- * task_cputime_zero - Check a task_cputime struct for all zero fields.
- *
- * @cputime:	The struct to compare.
- *
- * Checks @cputime to see if all fields are zero.  Returns true if all fields
- * are zero, false if any field is nonzero.
- */
-static inline int task_cputime_zero(const struct task_cputime *cputime)
-{
-	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
-		return 1;
-	return 0;
-}
-
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
-- 
1.7.5.4

