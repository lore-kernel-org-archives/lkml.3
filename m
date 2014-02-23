Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaBWVkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:52265 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBWVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:09 -0500
Message-Id: <20140223212736.774961401@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>, sh <linux-sh@vger.kernel.org>
Subject: [patch 05/26] sh: Use irq_set_affinity instead of homebrewn code
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=sh-irq-use-the-proper-core-functions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in having an incomplete copy of irq_set_affinity()
for the hotplug irq migration code.

Use the core function instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: sh <linux-sh@vger.kernel.org>
---
 arch/sh/kernel/irq.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

Index: tip/arch/sh/kernel/irq.c
===================================================================
--- tip.orig/arch/sh/kernel/irq.c
+++ tip/arch/sh/kernel/irq.c
@@ -217,19 +217,6 @@ void __init init_IRQ(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = irq_data_get_irq_chip(data);
-
-	printk(KERN_INFO "IRQ%u: moving from cpu%u to cpu%u\n",
-	       irq, data->node, cpu);
-
-	raw_spin_lock_irq(&desc->lock);
-	chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irq(&desc->lock);
-}
-
 /*
  * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
  * the affinity settings do not allow other CPUs, force them onto any
@@ -253,8 +240,7 @@ void migrate_irqs(void)
 				newcpu = cpumask_any_and(data->affinity,
 							 cpu_online_mask);
 			}
-
-			route_irq(data, irq, newcpu);
+			irq_set_affinity(irq, cpumask_of(newcpu));
 		}
 	}
 }


