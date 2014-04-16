Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161554AbaDPOgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:36:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:39621 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161486AbaDPOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:36:31 -0400
Message-Id: <20140416143315.717251504@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 16 Apr 2014 14:36:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Subject: [patch 1/4] genirq: Allow forcing cpu affinity of interrupts
References: <20140416142106.537575971@linutronix.de>
Content-Disposition: inline; filename=genirq-allow-forcing-cpuaffinity.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of irq_set_affinity() refuses rightfully to
route an interrupt to an offline cpu.

But there is a special case, where this is actually desired. Some of
the ARM SoCs have per cpu timers which require setting the affinity
during cpu startup where the cpu is not yet in the online mask.

If we can't do that, then the local timer interrupt for the about to
become online cpu is routed to some random online cpu.

The developers of the affected machines tried to work around that
issue, but that results in a massive mess in that timer code.

We have a yet unused argument in the set_affinity callbacks of the irq
chips, which I added back then for a similar reason. It was never
required so it got not used. But I'm happy that I never removed it.

That allows us to implement a sane handling of the above scenario. So
the affected SoC drivers can add the required force handling to their
interrupt chip, switch the timer code to irq_force_affinity() and
things just work.

This does not affect any existing user of irq_set_affinity().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 include/linux/interrupt.h            |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/irq.h                  |    3 ++-
 kernel/irq/manage.c                  |   17 ++++++-----------
 4 files changed, 43 insertions(+), 14 deletions(-)

Index: tip/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- tip.orig/arch/mips/cavium-octeon/octeon-irq.c
+++ tip/arch/mips/cavium-octeon/octeon-irq.c
@@ -635,7 +635,7 @@ static void octeon_irq_cpu_offline_ciu(s
 		cpumask_clear(&new_affinity);
 		cpumask_set_cpu(cpumask_first(cpu_online_mask), &new_affinity);
 	}
-	__irq_set_affinity_locked(data, &new_affinity);
+	irq_set_affinity_locked(data, &new_affinity, false);
 }
 
 static int octeon_irq_ciu_set_affinity(struct irq_data *data,
Index: tip/include/linux/interrupt.h
===================================================================
--- tip.orig/include/linux/interrupt.h
+++ tip/include/linux/interrupt.h
@@ -203,7 +203,40 @@ static inline int check_wakeup_irqs(void
 
 extern cpumask_var_t irq_default_affinity;
 
-extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+/* Internal implementation. Use the helpers below */
+extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
+			      bool force);
+
+/**
+ * irq_set_affinity - Set the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @mask:	cpumask
+ *
+ * Fails if cpumask does not contain an online CPU
+ */
+static inline int
+irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, false);
+}
+
+/**
+ * irq_force_affinity - Force the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @mask:	cpumask
+ *
+ * Same as irq_set_affinity, but without checking the mask against
+ * online cpus.
+ *
+ * Solely for low level cpu hotplug code, where we need to make per
+ * cpu interrupts affine before the cpu becomes online.
+ */
+static inline int
+irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, true);
+}
+
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -394,7 +394,8 @@ extern void remove_percpu_irq(unsigned i
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
-extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
+extern int irq_set_affinity_locked(struct irq_data *data,
+				   const struct cpumask *cpumask, bool force);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void irq_move_irq(struct irq_data *data);
Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -180,7 +180,7 @@ int irq_do_set_affinity(struct irq_data
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
-	ret = chip->irq_set_affinity(data, mask, false);
+	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 		cpumask_copy(data->affinity, mask);
@@ -192,7 +192,8 @@ int irq_do_set_affinity(struct irq_data
 	return ret;
 }
 
-int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
+int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
@@ -202,7 +203,7 @@ int __irq_set_affinity_locked(struct irq
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = irq_do_set_affinity(data, mask, false);
+		ret = irq_do_set_affinity(data, mask, force);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -217,13 +218,7 @@ int __irq_set_affinity_locked(struct irq
 	return ret;
 }
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@mask:		cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -233,7 +228,7 @@ int irq_set_affinity(unsigned int irq, c
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
+	ret = irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask, force);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }


