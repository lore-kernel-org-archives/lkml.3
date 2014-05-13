Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaEMOiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:38:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34206 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaEMOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:38:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/5] irq_work: Let arch tell us if it can raise irq work
Date: Tue, 13 May 2014 16:38:37 +0200
Message-Id: <1399991921-17618-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
References: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We prepare for executing the full nohz kick through an irq work. But
if we do this as is, we'll run into conflicting tick locking: the tick
holds the hrtimer lock and the nohz kick may do so too.

So we need to be able to force the execution of some irq works (more
precisely the non-lazy ones) to the arch irq work interrupt if any.

As a start we need to know if the arch support sending its own self-IPIs
and doesn't rely on the tick to execute the works.

This solution proposes weak function. Of course it's ugly and deemed
only for a draft. The best would be to call a generic
irq_work_set_raisable() only once per arch.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Not-Yet-Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/alpha/kernel/time.c   | 5 +++++
 arch/arm/kernel/smp.c      | 5 +++++
 arch/powerpc/kernel/time.c | 5 +++++
 arch/sparc/kernel/pcr.c    | 5 +++++
 arch/x86/kernel/irq_work.c | 7 +++++++
 kernel/irq_work.c          | 5 +++++
 6 files changed, 32 insertions(+)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index ee39cee..b30d7bd 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -65,6 +65,11 @@ void arch_irq_work_raise(void)
 	set_irq_work_pending_flag();
 }
 
+bool arch_irq_work_can_raise(void)
+{
+	return true;
+}
+
 #else  /* CONFIG_IRQ_WORK */
 
 #define test_irq_work_pending()      0
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 7c4fada..89ff3a3 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -459,6 +459,11 @@ void arch_irq_work_raise(void)
 	if (is_smp())
 		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
 }
+
+bool arch_irq_work_can_raise(void)
+{
+	return is_smp();
+}
 #endif
 
 static const char *ipi_types[NR_IPI] = {
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 122a580..e5381e8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -472,6 +472,11 @@ void arch_irq_work_raise(void)
 	preempt_enable();
 }
 
+bool arch_irq_work_can_raise(void)
+{
+	return true;
+}
+
 #else  /* CONFIG_IRQ_WORK */
 
 #define test_irq_work_pending()	0
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 269af58..658f4bc 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -48,6 +48,11 @@ void arch_irq_work_raise(void)
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
 
+bool arch_irq_work_can_raise(void)
+{
+	return true;
+}
+
 const struct pcr_ops *pcr_ops;
 EXPORT_SYMBOL_GPL(pcr_ops);
 
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 1de84e3..03e1ee4 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -48,3 +48,10 @@ void arch_irq_work_raise(void)
 	apic_wait_icr_idle();
 #endif
 }
+
+#ifdef CONFIG_X86_LOCAL_APIC
+bool arch_irq_work_can_raise(void)
+{
+	return cpu_has_apic;
+}
+#endif
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index a82170e..2a5aad4 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -55,6 +55,11 @@ void __weak arch_irq_work_raise(void)
 	 */
 }
 
+bool __weak arch_irq_work_can_raise(void)
+{
+	return false;
+}
+
 /*
  * Enqueue the irq_work @entry unless it's already pending
  * somewhere.
-- 
1.8.3.1

