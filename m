Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaB0Vhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:37:39 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44194 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbaB0Vhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:37:38 -0500
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com
Cc: Feng Kan <fkan@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: [PATCH V3] irqchip:gic: change access of gicc_ctrl register to read modify write.
Date: Thu, 27 Feb 2014 14:36:53 -0700
Message-Id: <1393537013-6264-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is made to preserve the GIC v2 releated bits in the
GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
The original code only set the enable/disable group bit in this register.
This code will preserve the bypass bits configured by the bootload except
the enable/disable bit. The main reason for this change is to allow the
bypass bits specified in the v2 spec to remain untouched by the current
GIC code. In the X-Gene platform, the bypass functionality is not used
and bypass must be disabled at all time.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Anup Patel <apatel@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
V3 Changes:
	- Sorry, forgot to change the mask for cpu_init path
          assumed bootloader setup bits correctly.
V2 Changes:
	- only mask off v2 bypass bits
 drivers/irqchip/irq-gic.c |   32 +++++++++++++++++++++++++++++---
 1 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 341c601..3ca7995 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	void __iomem *dist_base = gic_data_dist_base(gic);
 	void __iomem *base = gic_data_cpu_base(gic);
 	unsigned int cpu_mask, cpu = smp_processor_id();
+	unsigned int ctrl_mask;
 	int i;
 
 	/*
@@ -449,13 +450,29 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
 
 	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+
+	ctrl_mask = readl(base + GIC_CPU_CTRL);
+
+	/* Mask out the gic v2 bypass bits */
+	ctrl_mask &= 0x1e0;
+
+	/* Enable group 0 */
+	ctrl_mask |= 0x1;
+	writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
 {
+	unsigned int ctrl_mask;
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+
+	ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
+	/*
+	 * Disable grp enable bit, leave the bypass bits alone as changing
+	 * them could leave the system unstable
+	 */
+	ctrl_mask &= 0x1e0;
+	writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -566,6 +583,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 {
 	int i;
 	u32 *ptr;
+	unsigned int ctrl_mask;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
 
@@ -590,7 +608,15 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+
+	ctrl_mask = readl(cpu_base + GIC_CPU_CTRL);
+
+	/* Mask out the gic v2 bypass bits */
+	ctrl_mask &= 0x1e0;
+
+	/* Enable group 0 */
+	ctrl_mask |= 0x1;
+	writel_relaxed(ctrl_mask, cpu_base + GIC_CPU_CTRL);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
-- 
1.7.1

