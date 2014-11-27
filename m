Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaK0UQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:16:50 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52762 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaK0ULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:11:05 -0500
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
Subject: [PATCH 3.18-rc4 v11 1/6] irqchip: gic: Finer grain locking for gic_raise_softirq
Date: Thu, 27 Nov 2014 20:10:19 +0000
Message-Id: <1417119024-22844-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_controller_lock is used for multiple purposes within the gic driver.
Primarily it is used to make register read-modify-write sequences atomic.
It is also used by gic_raise_softirq() in order that the big.LITTLE
migration logic can figure out when it is safe to migrate interrupts
between physical cores.

The second usage of irq_controller_lock is difficult to discern when
reviewing the code because the migration itself takes place outside
the lock.

This patch makes the second usage more explicit by splitting it out into
a separate lock and providing better comments.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 38493ff28fa5..94d77118efa8 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -73,6 +73,12 @@ struct gic_chip_data {
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
 /*
+ * This lock is used by the big.LITTLE migration code to ensure no IPIs
+ * can be pended on the old core after the map has been updated.
+ */
+static DEFINE_RAW_SPINLOCK(cpu_map_migration_lock);
+
+/*
  * The GIC mapping of CPU interfaces does not necessarily match
  * the logical CPU numbering.  Let's use a mapping as returned
  * by the GIC itself.
@@ -624,7 +630,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	int cpu;
 	unsigned long flags, map = 0;
 
-	raw_spin_lock_irqsave(&irq_controller_lock, flags);
+	raw_spin_lock_irqsave(&cpu_map_migration_lock, flags);
 
 	/* Convert our logical CPU mask into a physical one. */
 	for_each_cpu(cpu, mask)
@@ -639,7 +645,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	/* this always happens on GIC0 */
 	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
-	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_map_migration_lock, flags);
 }
 #endif
 
@@ -710,8 +716,17 @@ void gic_migrate_target(unsigned int new_cpu_id)
 
 	raw_spin_lock(&irq_controller_lock);
 
-	/* Update the target interface for this logical CPU */
+	/*
+	 * Update the target interface for this logical CPU
+	 *
+	 * From the point we release the cpu_map_migration_lock any new
+	 * SGIs will be pended on the new cpu which makes the set of SGIs
+	 * pending on the old cpu static. That means we can defer the
+	 * migration until after we have released the irq_controller_lock.
+	 */
+	raw_spin_lock(&cpu_map_migration_lock);
 	gic_cpu_map[cpu] = 1 << new_cpu_id;
+	raw_spin_unlock(&cpu_map_migration_lock);
 
 	/*
 	 * Find all the peripheral interrupts targetting the current
-- 
1.9.3

