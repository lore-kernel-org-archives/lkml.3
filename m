Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaEHQbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:31:05 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:40728 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625AbaEHQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:31:03 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, catalin.marinas@arm.com, marc.zyngier@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org, patches@apm.com
Cc: Feng Kan <fkan@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: [PATCH V6] gic: preserve gic V2 bypass bits in cpu ctrl register
Date: Thu,  8 May 2014 09:30:34 -0700
Message-Id: <1399566634-2537-1-git-send-email-fkan@apm.com>
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
V6: add gic_cpu_if_up function to replace macro used in v5
V5: Use macro to replace read modify write of cpu_ctrl register.
V4: Change to use bypass mask, change ot user more suitable variable name.
 drivers/irqchip/irq-gic.c       |   30 +++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h |    1 +
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4300b66..cb8eb92 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -449,13 +449,36 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
 
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+
+	gic_cpu_if_up();
+}
+
+void gic_cpu_if_up(void)
+{
+	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
+	u32 bypass;
+
+	/* 
+	 * Preserve bypass disable bits to be written back later
+	 */
+	bypass = readl(cpu_base + GIC_CPU_CTRL);
+	bypass &= 0x1e0;
+
+	writel_relaxed(bypass | 0x1, cpu_base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+	u32 bypass;
+
+	/* 
+	 * Preserve bypass disable bits to be written back later
+	 */
+	bypass = readl(cpu_base + GIC_CPU_CTRL);
+	bypass &= 0x1e0;
+
+	writel_relaxed(bypass, cpu_base + GIC_CPU_CTRL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -590,7 +613,8 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	
+	gic_cpu_if_up();
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 7ed92d0..762dea0 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -80,6 +80,7 @@ extern struct irq_chip gic_arch_extn;
 void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
 		    u32 offset, struct device_node *);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
+void gic_cpu_if_up(void);
 void gic_cpu_if_down(void);
 
 static inline void gic_init(unsigned int nr, int start,
-- 
1.7.6.1

