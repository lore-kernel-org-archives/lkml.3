Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaK1QQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:16:57 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42304 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaK1QQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:16:54 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3.18-rc4 v12 2/5] irqchip: gic: Make gic_raise_softirq FIQ-safe
Date: Fri, 28 Nov 2014 16:16:11 +0000
Message-Id: <1417191374-26719-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417191374-26719-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1417191374-26719-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently possible for FIQ handlers to re-enter gic_raise_softirq()
and lock up.

    	gic_raise_softirq()
	   lock(x);
-~-> FIQ
        handle_fiq()
	   gic_raise_softirq()
	      lock(x);		<-- Lockup

arch/arm/ uses IPIs to implement arch_irq_work_raise(), thus this issue
renders it difficult for FIQ handlers to safely defer work to less
restrictive calling contexts.

This patch fixes the problem by converting the cpu_map_migration_lock
into a rwlock making it safe to re-enter the function.

Note that having made it safe to re-enter gic_raise_softirq() we no
longer need to mask interrupts during gic_raise_softirq() because the
b.L migration is always performed from task context.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index e875da93f24a..5d72823bc5e9 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -75,22 +75,25 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 /*
  * This lock is used by the big.LITTLE migration code to ensure no IPIs
  * can be pended on the old core after the map has been updated.
+ *
+ * This lock may be locked for reading from both IRQ and FIQ handlers
+ * and therefore must not be locked for writing when these are enabled.
  */
 #ifdef CONFIG_BL_SWITCHER
-static DEFINE_RAW_SPINLOCK(cpu_map_migration_lock);
+static DEFINE_RWLOCK(cpu_map_migration_lock);
 
-static inline void bl_migration_lock(unsigned long *flags)
+static inline void bl_migration_lock(void)
 {
-	raw_spin_lock_irqsave(&cpu_map_migration_lock, *flags);
+	read_lock(&cpu_map_migration_lock);
 }
 
-static inline void bl_migration_unlock(unsigned long flags)
+static inline void bl_migration_unlock(void)
 {
-	raw_spin_unlock_irqrestore(&cpu_map_migration_lock, flags);
+	read_unlock(&cpu_map_migration_lock);
 }
 #else
-static inline void bl_migration_lock(unsigned long *flags) {}
-static inline void bl_migration_unlock(unsigned long flags) {}
+static inline void bl_migration_lock(void) {}
+static inline void bl_migration_unlock(void) {}
 #endif
 
 /*
@@ -640,12 +643,20 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 #endif
 
 #ifdef CONFIG_SMP
+/*
+ * Raise the specified IPI on all cpus set in mask.
+ *
+ * This function is safe to call from all calling contexts, including
+ * FIQ handlers. It relies on bl_migration_lock() being multiply acquirable
+ * to avoid deadlocks when the function is re-entered at different
+ * exception levels.
+ */
 static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
 	int cpu;
-	unsigned long flags, map = 0;
+	unsigned long map = 0;
 
-	bl_migration_lock(&flags);
+	bl_migration_lock();
 
 	/* Convert our logical CPU mask into a physical one. */
 	for_each_cpu(cpu, mask)
@@ -660,7 +671,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	/* this always happens on GIC0 */
 	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
-	bl_migration_unlock(flags);
+	bl_migration_unlock();
 }
 #endif
 
@@ -708,7 +719,8 @@ int gic_get_cpu_id(unsigned int cpu)
  * Migrate all peripheral interrupts with a target matching the current CPU
  * to the interface corresponding to @new_cpu_id.  The CPU interface mapping
  * is also updated.  Targets to other CPU interfaces are unchanged.
- * This must be called with IRQs locally disabled.
+ * This must be called from a task context and with IRQ and FIQ locally
+ * disabled.
  */
 void gic_migrate_target(unsigned int new_cpu_id)
 {
@@ -739,9 +751,9 @@ void gic_migrate_target(unsigned int new_cpu_id)
 	 * pending on the old cpu static. That means we can defer the
 	 * migration until after we have released the irq_controller_lock.
 	 */
-	raw_spin_lock(&cpu_map_migration_lock);
+	write_lock(&cpu_map_migration_lock);
 	gic_cpu_map[cpu] = 1 << new_cpu_id;
-	raw_spin_unlock(&cpu_map_migration_lock);
+	write_unlock(&cpu_map_migration_lock);
 
 	/*
 	 * Find all the peripheral interrupts targetting the current
-- 
1.9.3

