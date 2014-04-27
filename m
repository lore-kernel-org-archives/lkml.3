Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaD0PEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 11:04:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:57838 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaD0PEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 11:04:52 -0400
Date: Sun, 27 Apr 2014 17:05:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq fixes for 3.15
Message-ID: <alpine.DEB.2.02.1404271653300.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

A slighlty large fix for a subtle issue in the CPU hotplug code of
certain ARM SoCs, where the not yet online cpu needs to setup the cpu
local timer and needs to set the interrupt affinity to itself. Setting
interrupt affinity to a not online cpu is prohibited and therefor the
timer interrupt ends up on the wrong cpu, which leads to nasty
complications.

The SoC folks tried to hack around that in the SoC code in some more
than nasty ways. The proper solution is to have a way to enforce the
affinity setting to a not online cpu. The core patch to the genirq
code provides that facility and the follow up patches make use of it
in the GIC interrupt controller and the exynos timer driver.

The change to the core code has no implications to existing users,
except for the rename of the locked function and therefor the
necessary fixup in mips/cavium. Aside of that, no runtime impact is
possible, as none of the existing interrupt chips implements anything
which depends on the force argument of the irq_set_affinity()
callback.

Thanks,

	tglx

------------------>
Krzysztof Kozlowski (1):
      clocksource: Exynos_mct: Register clock event after request_irq()

Thomas Gleixner (3):
      genirq: Allow forcing cpu affinity of interrupts
      irqchip: Gic: Support forced affinity setting
      clocksource: Exynos_mct: Use irq_force_affinity() in cpu bringup


 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 drivers/clocksource/exynos_mct.c     |   12 +++---------
 drivers/irqchip/irq-gic.c            |    8 ++++++--
 include/linux/interrupt.h            |   35 +++++++++++++++++++++++++++++++++-
 include/linux/irq.h                  |    3 ++-
 kernel/irq/manage.c                  |   17 ++++++-----------
 6 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index c2bb4f8..3aa5b46 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -635,7 +635,7 @@ static void octeon_irq_cpu_offline_ciu(struct irq_data *data)
 		cpumask_clear(&new_affinity);
 		cpumask_set_cpu(cpumask_first(cpu_online_mask), &new_affinity);
 	}
-	__irq_set_affinity_locked(data, &new_affinity);
+	irq_set_affinity_locked(data, &new_affinity, false);
 }
 
 static int octeon_irq_ciu_set_affinity(struct irq_data *data,
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index a6ee6d7..acf5a32 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -416,8 +416,6 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 	evt->set_mode = exynos4_tick_set_mode;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = 450;
-	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
-					0xf, 0x7fffffff);
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
@@ -430,9 +428,12 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 				evt->irq);
 			return -EIO;
 		}
+		irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
+	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
+					0xf, 0x7fffffff);
 
 	return 0;
 }
@@ -450,7 +451,6 @@ static int exynos4_mct_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
 	struct mct_clock_event_device *mevt;
-	unsigned int cpu;
 
 	/*
 	 * Grab cpu pointer in each case to avoid spurious
@@ -461,12 +461,6 @@ static int exynos4_mct_cpu_notify(struct notifier_block *self,
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_setup(&mevt->evt);
 		break;
-	case CPU_ONLINE:
-		cpu = (unsigned long)hcpu;
-		if (mct_int_type == MCT_INT_SPI)
-			irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu],
-						cpumask_of(cpu));
-		break;
 	case CPU_DYING:
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_stop(&mevt->evt);
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4300b66..57d165e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -246,10 +246,14 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int shift = (gic_irq(d) % 4) * 8;
-	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
 	u32 val, mask, bit;
 
+	if (!force)
+		cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	else
+		cpu = cpumask_first(mask_val);
+
 	if (cpu >= NR_GIC_CPU_IF || cpu >= nr_cpu_ids)
 		return -EINVAL;
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c7bfac1..8834a7e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -203,7 +203,40 @@ static inline int check_wakeup_irqs(void) { return 0; }
 
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
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d278838..10a0b1a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -394,7 +394,8 @@ extern void remove_percpu_irq(unsigned int irq, struct irqaction *act);
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
-extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
+extern int irq_set_affinity_locked(struct irq_data *data,
+				   const struct cpumask *cpumask, bool force);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void irq_move_irq(struct irq_data *data);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2486a4c..d34131c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -180,7 +180,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
-	ret = chip->irq_set_affinity(data, mask, false);
+	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 		cpumask_copy(data->affinity, mask);
@@ -192,7 +192,8 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
-int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
+int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
@@ -202,7 +203,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = irq_do_set_affinity(data, mask, false);
+		ret = irq_do_set_affinity(data, mask, force);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -217,13 +218,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
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
@@ -233,7 +228,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
+	ret = irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask, force);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
