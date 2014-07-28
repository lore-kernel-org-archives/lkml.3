Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaG1Rhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:37:48 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46646 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaG1Rhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:37:45 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 01/10] smp: Introduce void kick_cpu_async()
Date: Mon, 28 Jul 2014 19:37:27 +0200
Message-Id: <1406569056-30217-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to trigger an empty IPI appears to be useless in the first
place. Yet it is expected to be very useful for callers who just need
to execute irq_enter() or irq_exit() to a remote target.

More precisely this is going to be useful for the nohz subsystem which
often needs a remote CPU to reschedule its tick when some state changed
and require periodicity for any reason. Similar cases have been handled
with random IPIs until now. But they surely bring unwanted overhead
all along since they are all dedicated for specific tasks.

Triggering an smp_call_function IPI should be enough to solve that. If
competing and spurious IPIs become a problem, we can still optimize that
later.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/smp.h |  1 +
 kernel/smp.c        | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 34347f2..a8d9c9b 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -100,6 +100,7 @@ int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
 
 void kick_all_cpus_sync(void);
+void kick_cpu_async(int cpu);
 
 /*
  * Generic and arch helpers
diff --git a/kernel/smp.c b/kernel/smp.c
index a1812d1..12c5bea 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -658,3 +658,24 @@ void kick_all_cpus_sync(void)
 	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
+
+/**
+ * kick_cpu_async(): Run a void IRQ on the target
+ * @cpu: The cpu to run the IRQ on
+ *
+ * Run a void IRQ for its own sake on the target. It's generally
+ * useful for callers which want to run irq_enter() or irq_exit()
+ * on a remote CPU.
+ */
+void kick_cpu_async(int cpu)
+{
+	/*
+	 * NOTE: we could optimize that and spare some IPIs
+	 * after checking that call_single_queue isn't empty before raising.
+	 * This can't be done properly without cmpxchg() though so
+	 * it may make things worse after all. But lets leave that
+	 * possibility open in case people report such issue in the
+	 * future.
+	 */
+	arch_send_call_function_single_ipi(cpu);
+}
-- 
1.8.3.1

