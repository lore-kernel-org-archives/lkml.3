Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab3CUPYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:24:48 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:39880 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CUPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:24:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] nohz: Wake up full dynticks CPUs when a timer gets enqueued
Date: Thu, 21 Mar 2013 16:24:20 +0100
Message-Id: <1363879460-21595-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up a CPU when a timer list timer is enqueued there and
the target is part of the full dynticks range. Sending an IPI
to it makes it reconsidering the next timer to program on top
of recent updates.

This may later be improved by checking if the tick is really
stopped on the target. This would need some careful
synchronization though. So deal with such optimization later
and start simple.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    4 ++--
 kernel/sched/core.c   |   20 +++++++++++++++++++-
 kernel/timer.c        |   12 ++++++------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9004f6e..10626e2e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1851,9 +1851,9 @@ static inline void idle_task_exit(void) {}
 #endif
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-extern void wake_up_idle_cpu(int cpu);
+extern void wake_up_nohz_cpu(int cpu);
 #else
-static inline void wake_up_idle_cpu(int cpu) { }
+static inline void wake_up_nohz_cpu(int cpu) { }
 #endif
 
 #ifdef CONFIG_SCHED_AUTOGROUP
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 849deb9..e91ee58 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -587,7 +587,7 @@ unlock:
  * account when the CPU goes back to idle and evaluates the timer
  * wheel for the next timer event.
  */
-void wake_up_idle_cpu(int cpu)
+static void wake_up_idle_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
@@ -617,6 +617,24 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static bool wake_up_extended_nohz_cpu(int cpu)
+{
+	if (tick_nohz_extended_cpu(cpu)) {
+		if (cpu != smp_processor_id() ||
+		    tick_nohz_tick_stopped())
+			smp_send_reschedule(cpu);
+		return true;
+	}
+
+	return false;
+}
+
+void wake_up_nohz_cpu(int cpu)
+{
+	if (!wake_up_extended_nohz_cpu(cpu))
+		wake_up_idle_cpu(cpu);
+}
+
 static inline bool got_nohz_idle_kick(void)
 {
 	int cpu = smp_processor_id();
diff --git a/kernel/timer.c b/kernel/timer.c
index dbf7a78..4e3040b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -930,14 +930,14 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	debug_activate(timer, timer->expires);
 	internal_add_timer(base, timer);
 	/*
-	 * Check whether the other CPU is idle and needs to be
-	 * triggered to reevaluate the timer wheel when nohz is
-	 * active. We are protected against the other CPU fiddling
+	 * Check whether the other CPU is in dynticks mode and needs
+	 * to be triggered to reevaluate the timer wheel.
+	 * We are protected against the other CPU fiddling
 	 * with the timer by holding the timer base lock. This also
-	 * makes sure that a CPU on the way to idle can not evaluate
-	 * the timer wheel.
+	 * makes sure that a CPU on the way to stop its tick can not
+	 * evaluate the timer wheel.
 	 */
-	wake_up_idle_cpu(cpu);
+	wake_up_nohz_cpu(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
-- 
1.7.5.4

