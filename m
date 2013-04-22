Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3DVTAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:00:10 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41667 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3DVTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:00:08 -0400
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
Subject: [PATCH 07/10] nohz: Implement full dynticks kick
Date: Mon, 22 Apr 2013 20:59:43 +0200
Message-Id: <1366657186-20556-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the full dynticks kick that is performed from
IPIs sent by various subsystems (scheduler, posix timers, ...)
when they want to notify about a new event that may
reconsider the dependency on the tick.

Most of the time, such an event end up restarting the tick.

(Part of the design with subsystems providing *_can_stop_tick()
helpers suggested by Peter Zijlstra a while ago).

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
 kernel/time/tick-sched.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4d74a68..95d79ae 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
+#include <linux/posix-timers.h>
+#include <linux/perf_event.h>
 
 #include <asm/irq_regs.h>
 
@@ -147,16 +149,48 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 static cpumask_var_t nohz_full_mask;
 bool have_nohz_full_mask;
 
+static bool can_stop_full_tick(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (!sched_can_stop_tick())
+		return false;
+
+	if (!posix_cpu_timers_can_stop_tick(current))
+		return false;
+
+	if (!perf_event_can_stop_tick())
+		return false;
+
+	/* sched_clock_tick() needs us? */
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+	/*
+	 * TODO: kick full dynticks CPUs when
+	 * sched_clock_stable is set.
+	 */
+	if (!sched_clock_stable)
+		return false;
+#endif
+
+	return true;
+}
+
+static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
+
 /*
  * Re-evaluate the need for the tick on the current CPU
  * and restart it if necessary.
  */
 void tick_nohz_full_check(void)
 {
-	/*
-	 * STUB for now, will be filled with the full tick stop/restart
-	 * infrastructure patches
-	 */
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (tick_nohz_full_cpu(smp_processor_id())) {
+		if (ts->tick_stopped && !is_idle_task(current)) {
+			if (!can_stop_full_tick())
+				tick_nohz_restart_sched_tick(ts, ktime_get());
+		}
+	}
 }
 
 static void nohz_full_kick_work_func(struct irq_work *work)
-- 
1.7.5.4

