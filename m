Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaKEK21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:28:27 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49836 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaKEK2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:28:18 -0500
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
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3.18-rc3 v7 1/4] irqchip: gic: Make gic_raise_softirq() FIQ-safe
Date: Wed,  5 Nov 2014 10:27:37 +0000
Message-Id: <1415183260-6389-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org>
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently calling printk() from a FIQ can result in deadlock on
irq_controller_lock within gic_raise_softirq(). This occurs because
printk(), which is otherwise structured to survive calls from FIQ/NMI,
calls this function to raise an IPI when it needs to wake_up_klogd().

This patch fixes the problem by introducing an additional rwlock and
using that to prevent softirqs being raised whilst the b.L switcher
is updating the cpu map.

Other parts of the code are not updated to use the new
fiq_safe_cpu_map_lock because other users of gic_cpu_map either rely on
external locking or upon irq_controller_lock. Both locks are held by the
b.L switcher code.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 38493ff..0db62a6 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -73,6 +73,13 @@ struct gic_chip_data {
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
 /*
+ * This lock may be locked for reading by FIQ handlers. Thus although
+ * read locking may be used liberally, write locking must only take
+ * place only when local FIQ handling is disabled.
+ */
+static DEFINE_RWLOCK(fiq_safe_cpu_map_lock);
+
+/*
  * The GIC mapping of CPU interfaces does not necessarily match
  * the logical CPU numbering.  Let's use a mapping as returned
  * by the GIC itself.
@@ -624,7 +631,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	int cpu;
 	unsigned long flags, map = 0;
 
-	raw_spin_lock_irqsave(&irq_controller_lock, flags);
+	read_lock_irqsave(&fiq_safe_cpu_map_lock, flags);
 
 	/* Convert our logical CPU mask into a physical one. */
 	for_each_cpu(cpu, mask)
@@ -639,7 +646,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	/* this always happens on GIC0 */
 	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
-	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
+	read_unlock_irqrestore(&fiq_safe_cpu_map_lock, flags);
 }
 #endif
 
@@ -687,7 +694,7 @@ int gic_get_cpu_id(unsigned int cpu)
  * Migrate all peripheral interrupts with a target matching the current CPU
  * to the interface corresponding to @new_cpu_id.  The CPU interface mapping
  * is also updated.  Targets to other CPU interfaces are unchanged.
- * This must be called with IRQs locally disabled.
+ * This must be called with IRQ and FIQ locally disabled.
  */
 void gic_migrate_target(unsigned int new_cpu_id)
 {
@@ -709,6 +716,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
 	ror_val = (cur_cpu_id - new_cpu_id) & 31;
 
 	raw_spin_lock(&irq_controller_lock);
+	write_lock(&fiq_safe_cpu_map_lock);
 
 	/* Update the target interface for this logical CPU */
 	gic_cpu_map[cpu] = 1 << new_cpu_id;
@@ -728,6 +736,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
 		}
 	}
 
+	write_unlock(&fiq_safe_cpu_map_lock);
 	raw_spin_unlock(&irq_controller_lock);
 
 	/*
-- 
1.9.3

