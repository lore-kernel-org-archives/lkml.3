Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaFJPPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:15:32 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41629 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFJPP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:15:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/6] nohz: Support nohz full remote kick
Date: Tue, 10 Jun 2014 17:15:06 +0200
Message-Id: <1402413309-3415-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remotely kicking a full nohz CPU in order to make it re-evaluate its
next tick is currently implemented using the scheduler IPI.

However this bloats a scheduler fast path with an off-topic feature.
The scheduler tick was abused here for its cool "callable
anywhere/anytime" properties.

But now that the irq work subsystem can queue remote callbacks, it's
a perfect fit to safely queue IPIs when interrupts are disabled
without worrying about concurrent callers.

So lets implement remote kick on top of irq work. This is going to
be used when a new event requires the next tick to be recalculated:
more than 1 task competing on the CPU, timer armed, ...

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tick.h     |  9 ++++++++-
 kernel/time/tick-sched.c | 10 ++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..8a4987f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -181,7 +181,13 @@ static inline bool tick_nohz_full_cpu(int cpu)
 
 extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
-extern void tick_nohz_full_kick(void);
+extern void tick_nohz_full_kick_cpu(int cpu);
+
+static inline void tick_nohz_full_kick(void)
+{
+	tick_nohz_full_kick_cpu(smp_processor_id());
+}
+
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
@@ -189,6 +195,7 @@ static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
+static inline void tick_nohz_full_kick_cpu(int cpu) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..3d63944 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -224,13 +224,15 @@ static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 };
 
 /*
- * Kick the current CPU if it's full dynticks in order to force it to
+ * Kick the CPU if it's full dynticks in order to force it to
  * re-evaluate its dependency on the tick and restart it if necessary.
  */
-void tick_nohz_full_kick(void)
+void tick_nohz_full_kick_cpu(int cpu)
 {
-	if (tick_nohz_full_cpu(smp_processor_id()))
-		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+	if (!tick_nohz_full_cpu(cpu))
+		return;
+
+	irq_work_queue_on(&per_cpu(nohz_full_kick_work, cpu), cpu);
 }
 
 static void nohz_full_kick_ipi(void *info)
-- 
1.8.3.1

