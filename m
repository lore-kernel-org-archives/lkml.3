Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaBWVmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:42:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:52348 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaBWVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:14 -0500
Message-Id: <20140223212739.124207133@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 26/26] genirq: Move kstats_inc_irqs_this_cpu() to core
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=genirq-move-kstats-inc-irqs-to-core.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users outside the core code. Put it into the poison
cabinet. That also gets rid of the linux/irq.h include in
kernel_stat.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kernel_stat.h |    8 --------
 kernel/irq/internals.h      |    7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

Index: tip/include/linux/kernel_stat.h
===================================================================
--- tip.orig/include/linux/kernel_stat.h
+++ tip/include/linux/kernel_stat.h
@@ -51,15 +51,7 @@ DECLARE_PER_CPU(struct kernel_cpustat, k
 
 extern unsigned long long nr_context_switches(void);
 
-#include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
-
-static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
-{
-	__this_cpu_inc(*desc->kstat_irqs);
-	__this_cpu_inc(kstat.irqs_sum);
-}
-
 extern void kstat_incr_irq_this_cpu(unsigned int irq);
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
Index: tip/kernel/irq/internals.h
===================================================================
--- tip.orig/kernel/irq/internals.h
+++ tip/kernel/irq/internals.h
@@ -6,6 +6,7 @@
  * of this file for your non core code.
  */
 #include <linux/irqdesc.h>
+#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_SPARSE_IRQ
 # define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
@@ -180,3 +181,9 @@ static inline bool irqd_has_set(struct i
 {
 	return d->state_use_accessors & mask;
 }
+
+static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
+{
+	__this_cpu_inc(*desc->kstat_irqs);
+	__this_cpu_inc(kstat.irqs_sum);
+}


