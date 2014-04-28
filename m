Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaD1TfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:35:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbaD1TfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:35:14 -0400
Date: Mon, 28 Apr 2014 12:33:44 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8cc3cfc5ccf1680b7c88f874912b6bec2797b76b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jason@lakedaemon.net, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org,
        gregory.clement@free-electrons.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        gregory.clement@free-electrons.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20140304203101.088889302@linutronix.de>
References: <20140304203101.088889302@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: armanda: Sanitize set_irq_affinity()
Git-Commit-ID: 8cc3cfc5ccf1680b7c88f874912b6bec2797b76b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cc3cfc5ccf1680b7c88f874912b6bec2797b76b
Gitweb:     http://git.kernel.org/tip/8cc3cfc5ccf1680b7c88f874912b6bec2797b76b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 4 Mar 2014 20:43:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Apr 2014 21:27:15 +0200

irqchip: armanda: Sanitize set_irq_affinity()

The set_irq_affinity() function has two issues:

1) It has no protection against selecting an offline cpu from the
   given mask.

2) It pointlessly restricts the affinity masks to have a single cpu
   set. This collides with the irq migration code of arm.

   irq affinity is set to core 3
   core 3 goes offline

   migration code sets mask to cpu_online_mask and calls the
   irq_set_affinity() callback of the irq_chip which fails due to bit
   0,1,2 set.

So instead of doing silly for_each_cpu() loops just pick any bit of
the mask which intersects with the online mask.

Get rid of fiddling with the default_irq_affinity as well.

[ Gregory: Fixed the access to the routing register ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/20140304203101.088889302@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/irqchip/irq-armada-370-xp.c | 37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 41be897..304a20d 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -41,6 +41,7 @@
 #define ARMADA_370_XP_INT_SET_ENABLE_OFFS	(0x30)
 #define ARMADA_370_XP_INT_CLEAR_ENABLE_OFFS	(0x34)
 #define ARMADA_370_XP_INT_SOURCE_CTL(irq)	(0x100 + irq*4)
+#define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
 
 #define ARMADA_370_XP_CPU_INTACK_OFFS		(0x44)
 #define ARMADA_375_PPI_CAUSE			(0x10)
@@ -244,35 +245,18 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 static int armada_xp_set_affinity(struct irq_data *d,
 				  const struct cpumask *mask_val, bool force)
 {
-	unsigned long reg;
-	unsigned long new_mask = 0;
-	unsigned long online_mask = 0;
-	unsigned long count = 0;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long reg, mask;
 	int cpu;
 
-	for_each_cpu(cpu, mask_val) {
-		new_mask |= 1 << cpu_logical_map(cpu);
-		count++;
-	}
-
-	/*
-	 * Forbid mutlicore interrupt affinity
-	 * This is required since the MPIC HW doesn't limit
-	 * several CPUs from acknowledging the same interrupt.
-	 */
-	if (count > 1)
-		return -EINVAL;
-
-	for_each_cpu(cpu, cpu_online_mask)
-		online_mask |= 1 << cpu_logical_map(cpu);
+	/* Select a single core from the affinity mask which is online */
+	cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	mask = 1UL << cpu_logical_map(cpu);
 
 	raw_spin_lock(&irq_controller_lock);
-
 	reg = readl(main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
-	reg = (reg & (~online_mask)) | new_mask;
+	reg = (reg & (~ARMADA_370_XP_INT_SOURCE_CPU_MASK)) | mask;
 	writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
-
 	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
@@ -494,15 +478,6 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 
 #ifdef CONFIG_SMP
 	armada_xp_mpic_smp_cpu_init();
-
-	/*
-	 * Set the default affinity from all CPUs to the boot cpu.
-	 * This is required since the MPIC doesn't limit several CPUs
-	 * from acknowledging the same interrupt.
-	 */
-	cpumask_clear(irq_default_affinity);
-	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
-
 #endif
 
 	armada_370_xp_msi_init(node, main_int_res.start);
