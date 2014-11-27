Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaK0ULM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:11:12 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33873 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaK0ULH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:11:07 -0500
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
Subject: [PATCH 3.18-rc4 v11 2/6] irqchip: gic: Optimize locking in gic_raise_softirq
Date: Thu, 27 Nov 2014 20:10:20 +0000
Message-Id: <1417119024-22844-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently gic_raise_softirq() unconditionally takes and releases a lock
whose only purpose is to synchronize with the b.L switcher.

Remove this lock if the b.L switcher is not compiled in.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 94d77118efa8..e875da93f24a 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -76,8 +76,23 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
  * This lock is used by the big.LITTLE migration code to ensure no IPIs
  * can be pended on the old core after the map has been updated.
  */
+#ifdef CONFIG_BL_SWITCHER
 static DEFINE_RAW_SPINLOCK(cpu_map_migration_lock);
 
+static inline void bl_migration_lock(unsigned long *flags)
+{
+	raw_spin_lock_irqsave(&cpu_map_migration_lock, *flags);
+}
+
+static inline void bl_migration_unlock(unsigned long flags)
+{
+	raw_spin_unlock_irqrestore(&cpu_map_migration_lock, flags);
+}
+#else
+static inline void bl_migration_lock(unsigned long *flags) {}
+static inline void bl_migration_unlock(unsigned long flags) {}
+#endif
+
 /*
  * The GIC mapping of CPU interfaces does not necessarily match
  * the logical CPU numbering.  Let's use a mapping as returned
@@ -630,7 +645,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	int cpu;
 	unsigned long flags, map = 0;
 
-	raw_spin_lock_irqsave(&cpu_map_migration_lock, flags);
+	bl_migration_lock(&flags);
 
 	/* Convert our logical CPU mask into a physical one. */
 	for_each_cpu(cpu, mask)
@@ -645,7 +660,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	/* this always happens on GIC0 */
 	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
 
-	raw_spin_unlock_irqrestore(&cpu_map_migration_lock, flags);
+	bl_migration_unlock(flags);
 }
 #endif
 
-- 
1.9.3

