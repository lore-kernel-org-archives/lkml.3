Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465Ab3BMQkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:40:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:60013 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab3BMQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:40:52 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 13/16] smp: add func to IPI cpus based on parameter func
Date: Wed, 13 Feb 2013 17:12:08 +0100
Message-Id: <1360771932-27150-14-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

Add the on_each_cpu_cond() function that wraps on_each_cpu_mask() and
calculates the cpumask of cpus to IPI by calling a function supplied as a
parameter in order to determine whether to IPI each specific cpu.

The function works around allocation failure of cpumask variable in
CONFIG_CPUMASK_OFFSTACK=y by itereating over cpus sending an IPI a time
via smp_call_function_single().

The function is useful since it allows to seperate the specific code that
decided in each case whether to IPI a specific cpu for a specific request
from the common boilerplate code of handling creating the mask, handling
failures etc.

[akpm@linux-foundation.org: s/gfpflags/gfp_flags/]
[akpm@linux-foundation.org: avoid double-evaluation of `info' (per Michal), parenthesise evaluation of `cond_func']
[akpm@linux-foundation.org: s/CPU/CPUs, use all 80 cols in comment]
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Avi Kivity <avi@redhat.com>
Acked-by: Michal Nazarewicz <mina86@mina86.org>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
Reviewed-by: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/smp.h |   24 ++++++++++++++++++++
 kernel/smp.c        |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 742a45a..3001ba5 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -108,6 +108,15 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
 		void *info, bool wait);
 
 /*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		smp_call_func_t func, void *info, bool wait,
+		gfp_t gfp_flags);
+
+/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -152,6 +161,21 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 			local_irq_enable();		\
 		}					\
 	} while (0)
+/*
+ * Preemption is disabled here to make sure the cond_func is called under the
+ * same condtions in UP and SMP.
+ */
+#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
+	do {							\
+		void *__info = (info);				\
+		preempt_disable();				\
+		if ((cond_func)(0, __info)) {			\
+			local_irq_disable();			\
+			(func)(__info);				\
+			local_irq_enable();			\
+		}						\
+		preempt_enable();				\
+	} while (0)
 
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
diff --git a/kernel/smp.c b/kernel/smp.c
index a081e6c..2f8b10e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -730,3 +730,64 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
 	put_cpu();
 }
 EXPORT_SYMBOL(on_each_cpu_mask);
+
+/*
+ * on_each_cpu_cond(): Call a function on each processor for which
+ * the supplied function cond_func returns true, optionally waiting
+ * for all the required CPUs to finish. This may include the local
+ * processor.
+ * @cond_func:	A callback function that is passed a cpu id and
+ *		the the info parameter. The function is called
+ *		with preemption disabled. The function should
+ *		return a blooean value indicating whether to IPI
+ *		the specified CPU.
+ * @func:	The function to run on all applicable CPUs.
+ *		This must be fast and non-blocking.
+ * @info:	An arbitrary pointer to pass to both functions.
+ * @wait:	If true, wait (atomically) until function has
+ *		completed on other CPUs.
+ * @gfp_flags:	GFP flags to use when allocating the cpumask
+ *		used internally by the function.
+ *
+ * The function might sleep if the GFP flags indicates a non
+ * atomic allocation is allowed.
+ *
+ * Preemption is disabled to protect against CPUs going offline but not online.
+ * CPUs going online during the call will not be seen or sent an IPI.
+ *
+ * You must not call this function with disabled interrupts or
+ * from a hardware interrupt handler or from a bottom half handler.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+			smp_call_func_t func, void *info, bool wait,
+			gfp_t gfp_flags)
+{
+	cpumask_var_t cpus;
+	int cpu, ret;
+
+	might_sleep_if(gfp_flags & __GFP_WAIT);
+
+	if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
+		preempt_disable();
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info))
+				cpumask_set_cpu(cpu, cpus);
+		on_each_cpu_mask(cpus, func, info, wait);
+		preempt_enable();
+		free_cpumask_var(cpus);
+	} else {
+		/*
+		 * No free cpumask, bother. No matter, we'll
+		 * just have to IPI them one by one.
+		 */
+		preempt_disable();
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info)) {
+				ret = smp_call_function_single(cpu, func,
+								info, wait);
+				WARN_ON_ONCE(!ret);
+			}
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(on_each_cpu_cond);
-- 
1.7.10.4

