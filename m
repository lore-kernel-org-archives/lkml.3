Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030851Ab3DSOvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:51:50 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45456 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030702Ab3DSOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:51:48 -0400
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
Subject: [PATCH 1/3] nohz: New APIs to re-evaluate the tick on full dynticks CPUs
Date: Fri, 19 Apr 2013 16:51:38 +0200
Message-Id: <1366383100-17053-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
References: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide two new helpers in order to notify the full dynticks CPUs about
some internal system changes against which they may reconsider the state
of their tick. Some practical examples include: posix cpu timers, perf tick
and sched clock tick.

For now the notifying handler, implemented through IPIs, is a stub
that will be implemented when we get the tick stop/restart infrastructure
in.

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
 include/linux/tick.h     |    4 +++
 kernel/time/Kconfig      |    1 +
 kernel/time/tick-sched.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b4e3b0c..c2dcfb1 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -159,8 +159,12 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 
 #ifdef CONFIG_NO_HZ_FULL
 extern int tick_nohz_full_cpu(int cpu);
+extern void tick_nohz_full_kick(void);
+extern void tick_nohz_full_kick_all(void);
 #else
 static inline int tick_nohz_full_cpu(int cpu) { return 0; }
+static inline void tick_nohz_full_kick(void) { }
+static inline void tick_nohz_full_kick_all(void) { }
 #endif
 
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 358d601..fbb4c7e 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -111,6 +111,7 @@ config NO_HZ_FULL
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
 	select CONTEXT_TRACKING_FORCE
+	select IRQ_WORK
 	help
 	 Adaptively try to shutdown the tick whenever possible, even when
 	 the CPU is running tasks. Typically this requires running a single
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 369b576..2bcad5b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -147,6 +147,57 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 static cpumask_var_t nohz_full_mask;
 bool have_nohz_full_mask;
 
+/*
+ * Re-evaluate the need for the tick on the current CPU
+ * and restart it if necessary.
+ */
+static void tick_nohz_full_check(void)
+{
+	/*
+	 * STUB for now, will be filled with the full tick stop/restart
+	 * infrastructure patches
+	 */
+}
+
+static void nohz_full_kick_work_func(struct irq_work *work)
+{
+	tick_nohz_full_check();
+}
+
+static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
+	.func = nohz_full_kick_work_func,
+};
+
+/*
+ * Kick the current CPU if it's full dynticks in order to force it to
+ * re-evaluate its dependency on the tick and restart it if necessary.
+ */
+void tick_nohz_full_kick(void)
+{
+	if (tick_nohz_full_cpu(smp_processor_id()))
+		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+}
+
+static void nohz_full_kick_ipi(void *info)
+{
+	tick_nohz_full_check();
+}
+
+/*
+ * Kick all full dynticks CPUs in order to force these to re-evaluate
+ * their dependency on the tick and restart it if necessary.
+ */
+void tick_nohz_full_kick_all(void)
+{
+	if (!have_nohz_full_mask)
+		return;
+
+	preempt_disable();
+	smp_call_function_many(nohz_full_mask,
+			       nohz_full_kick_ipi, NULL, false);
+	preempt_enable();
+}
+
 int tick_nohz_full_cpu(int cpu)
 {
 	if (!have_nohz_full_mask)
-- 
1.7.5.4

