Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaEHACJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:02:09 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:50618 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbaEHACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:02:06 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, catalin.marinas@arm.com, marc.zyngier@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: [PATCH V5] gic: preserve gic V2 bypass bits in cpu ctrl register
Date: Wed,  7 May 2014 17:01:50 -0700
Message-Id: <1399507310-2791-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is made to preserve the GIC v2 bypass bits in the
GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
This code will preserve all bits configured by the bootload regarding
v2 bypass group bits. In the X-Gene platform, the bypass functionality
is not used and bypass bits should not be changed by the kernel gic
code as it could lead to incorrect behavior.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Anup Patel <apatel@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
V5: Use macro to replace read modify write of cpu_ctrl register.
V4: Change to use bypass mask, change ot user more suitable variable name.
 drivers/irqchip/irq-gic.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4300b66..42e9bf4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -97,6 +97,13 @@ struct irq_chip gic_arch_extn = {
 #define MAX_GIC_NR	1
 #endif
 
+#define set_cpuctrl(base, val)					\
+	do {							\
+		u32 bypass;					\
+		bypass = readl(base + GIC_CPU_CTRL) & 0x1e0;	\
+		writel_relaxed(bypass | val, base + GIC_CPU_CTRL);\
+	} while (0)
+
 static struct gic_chip_data gic_data[MAX_GIC_NR] __read_mostly;
 
 #ifdef CONFIG_GIC_NON_BANKED
@@ -449,13 +456,15 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
 
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+
+	set_cpuctrl(base, 1);
 }
 
 void gic_cpu_if_down(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+
+	set_cpuctrl(cpu_base, 0);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -590,7 +599,8 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	
+	set_cpuctrl(cpu_base, 1);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
-- 
1.7.6.1

