Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967447Ab3DRRYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:24:11 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:36176 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967156Ab3DRRYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:24:00 -0400
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
Subject: [PATCH 3/3] posix_timers: Kick full dynticks CPUs when a posix cpu timer is armed
Date: Thu, 18 Apr 2013 19:23:42 +0200
Message-Id: <1366305822-5499-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kick the full dynticks CPUs when a posix cpu timer is enqueued by
way of a standard call to posix_cpu_timer_set() or set_process_cpu_timer().

This way they can re-evaluate the state of (and possibly restart) their
tick against the new expiry modification.

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
 kernel/posix-cpu-timers.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 3b73ae8..a9053ad7 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -10,6 +10,8 @@
 #include <linux/kernel_stat.h>
 #include <trace/events/timer.h>
 #include <linux/random.h>
+#include <linux/tick.h>
+#include <linux/workqueue.h>
 
 /*
  * Called after updating RLIMIT_CPU to run cpu timer and update
@@ -636,6 +638,26 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 	return 0;
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+static void nohz_kick_work_fn(struct work_struct *work)
+{
+	tick_nohz_full_kick_all();
+}
+
+static DECLARE_WORK(nohz_kick_work, nohz_kick_work_fn);
+
+/*
+ * We need the IPIs to be sent from sane process context.
+ * The posix cpu timers are always set with irqs disabled.
+ */
+static void posix_cpu_timer_kick_nohz(void)
+{
+	schedule_work(&nohz_kick_work);
+}
+#else
+static inline void posix_cpu_timer_kick_nohz(void) { }
+#endif
+
 /*
  * Guts of sys_timer_settime for CPU timers.
  * This is called with the timer locked and interrupts disabled.
@@ -794,6 +816,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		sample_to_timespec(timer->it_clock,
 				   old_incr, &old->it_interval);
 	}
+	if (!ret)
+		posix_cpu_timer_kick_nohz();
 	return ret;
 }
 
@@ -1369,7 +1393,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		}
 
 		if (!*newval)
-			return;
+			goto out;
 		*newval += now.cpu;
 	}
 
@@ -1387,6 +1411,8 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			tsk->signal->cputime_expires.virt_exp = *newval;
 		break;
 	}
+out:
+	posix_cpu_timer_kick_nohz();
 }
 
 static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
-- 
1.7.5.4

