Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaBWVkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:52206 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaBWVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:02 -0500
Message-Id: <20140223212736.664624945@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Chris Zankel <chris@zankel.net>,
        xtensa <linux-xtensa@linux-xtensa.org>
Subject: [patch 04/26] xtensa: Use irq_set_affinity instead of homebrewn code
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=xtensa-irq-use-the-proper-core-functions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in having an incomplete copy of irq_set_affinity()
for the hotplug irq migration code.

Use the core function instead and while at it switch to
for_each_active_irq()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: xtensa <linux-xtensa@linux-xtensa.org>
---
 arch/xtensa/kernel/irq.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

Index: tip/arch/xtensa/kernel/irq.c
===================================================================
--- tip.orig/arch/xtensa/kernel/irq.c
+++ tip/arch/xtensa/kernel/irq.c
@@ -155,18 +155,6 @@ void __init init_IRQ(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = irq_data_get_irq_chip(data);
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	if (chip->irq_set_affinity)
-		chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 /*
  * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
  * the affinity settings do not allow other CPUs, force them onto any
@@ -175,10 +163,9 @@ static void route_irq(struct irq_data *d
 void migrate_irqs(void)
 {
 	unsigned int i, cpu = smp_processor_id();
-	struct irq_desc *desc;
 
-	for_each_irq_desc(i, desc) {
-		struct irq_data *data = irq_desc_get_irq_data(desc);
+	for_each_active_irq(i) {
+		struct irq_data *data = irq_get_irq_data(i);
 		unsigned int newcpu;
 
 		if (irqd_is_per_cpu(data))
@@ -197,8 +184,7 @@ void migrate_irqs(void)
 			newcpu = cpumask_any_and(data->affinity,
 						 cpu_online_mask);
 		}
-
-		route_irq(data, i, newcpu);
+		irq_set_affinity(i, cpumask_of(newcpu));
 	}
 }
 #endif /* CONFIG_HOTPLUG_CPU */


