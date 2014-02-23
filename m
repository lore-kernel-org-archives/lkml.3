Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaBWVrC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:47:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:52228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaBWVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:05 -0500
Message-Id: <20140223212737.422068876@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 11/26] genirq: Add a kstat helper to increment irq stats
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=genirq-add-stat-helper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a common pattern all over the place:

      kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));

This results in a call to core code anyway. So provide a function
which does the same thing in core.

While at it, replace the butt ugly macro with an inline.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kernel_stat.h |   12 +++++++-----
 kernel/irq/irqdesc.c        |    5 +++++
 2 files changed, 12 insertions(+), 5 deletions(-)

Index: tip/include/linux/kernel_stat.h
===================================================================
--- tip.orig/include/linux/kernel_stat.h
+++ tip/include/linux/kernel_stat.h
@@ -54,11 +54,13 @@ extern unsigned long long nr_context_swi
 #include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 
-#define kstat_incr_irqs_this_cpu(irqno, DESC)		\
-do {							\
-	__this_cpu_inc(*(DESC)->kstat_irqs);		\
-	__this_cpu_inc(kstat.irqs_sum);			\
-} while (0)
+static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
+{
+	__this_cpu_inc(*desc->kstat_irqs);
+	__this_cpu_inc(kstat.irqs_sum);
+}
+
+extern void kstat_incr_irq_this_cpu(unsigned int irq);
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
Index: tip/kernel/irq/irqdesc.c
===================================================================
--- tip.orig/kernel/irq/irqdesc.c
+++ tip/kernel/irq/irqdesc.c
@@ -489,6 +489,11 @@ void dynamic_irq_cleanup(unsigned int ir
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+void kstat_incr_irq_this_cpu(unsigned int irq)
+{
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+}
+
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);


