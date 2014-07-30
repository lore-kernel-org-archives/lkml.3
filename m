Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaG3V4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:56:16 -0400
Received: from exprod5og126.obsmtp.com ([64.18.0.251]:44891 "HELO
	exprod5og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752017AbaG3V4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:56:14 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 RESEND 1/2] irqchip: gic: replace hex numbers with defines.
Date: Wed, 30 Jul 2014 14:56:58 -0700
Message-Id: <1406757419-18729-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406757419-18729-1-git-send-email-fkan@apm.com>
References: <1406757419-18729-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to cleanup some hex numbers used in the code and replace
them with defines to make the code cleaner.

Signed-off-by: Feng Kan <fkan@apm.com>
Reviewed-by: Anup Patel <apatel@apm.com>
---
 drivers/irqchip/irq-gic-common.c | 15 +++++++++------
 drivers/irqchip/irq-gic.c        | 25 +++++++++++++------------
 include/linux/irqchip/arm-gic.h  | 15 +++++++++++++++
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
index 60ac704..61541ff 100644
--- a/drivers/irqchip/irq-gic-common.c
+++ b/drivers/irqchip/irq-gic-common.c
@@ -74,20 +74,22 @@ void __init gic_dist_config(void __iomem *base, int gic_irqs,
 	 * Set all global interrupts to be level triggered, active low.
 	 */
 	for (i = 32; i < gic_irqs; i += 16)
-		writel_relaxed(0, base + GIC_DIST_CONFIG + i / 4);
+		writel_relaxed(GICD_INT_ACTLOW_LVLTRIG,
+					base + GIC_DIST_CONFIG + i / 4);
 
 	/*
 	 * Set priority on all global interrupts.
 	 */
 	for (i = 32; i < gic_irqs; i += 4)
-		writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i);
+		writel_relaxed(GICD_INT_DEF_PRI_X4, base + GIC_DIST_PRI + i);
 
 	/*
 	 * Disable all interrupts.  Leave the PPI and SGIs alone
 	 * as they are enabled by redistributor registers.
 	 */
 	for (i = 32; i < gic_irqs; i += 32)
-		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i / 8);
+		writel_relaxed(GICD_INT_EN_CLR_X32,
+					base + GIC_DIST_ENABLE_CLEAR + i / 8);
 
 	if (sync_access)
 		sync_access();
@@ -101,14 +103,15 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void))
 	 * Deal with the banked PPI and SGI interrupts - disable all
 	 * PPI interrupts, ensure all SGI interrupts are enabled.
 	 */
-	writel_relaxed(0xffff0000, base + GIC_DIST_ENABLE_CLEAR);
-	writel_relaxed(0x0000ffff, base + GIC_DIST_ENABLE_SET);
+	writel_relaxed(GICD_INT_EN_CLR_PPI, base + GIC_DIST_ENABLE_CLEAR);
+	writel_relaxed(GICD_INT_EN_SET_SGI, base + GIC_DIST_ENABLE_SET);
 
 	/*
 	 * Set priority on PPI and SGI interrupts
 	 */
 	for (i = 0; i < 32; i += 4)
-		writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i * 4 / 4);
+		writel_relaxed(GICD_INT_DEF_PRI_X4,
+					base + GIC_DIST_PRI + i * 4 / 4);
 
 	if (sync_access)
 		sync_access();
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 508b815..2075d52 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -299,8 +299,8 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	status = readl_relaxed(gic_data_cpu_base(chip_data) + GIC_CPU_INTACK);
 	raw_spin_unlock(&irq_controller_lock);
 
-	gic_irq = (status & 0x3ff);
-	if (gic_irq == 1023)
+	gic_irq = (status & GICC_IAR_INT_ID_MASK);
+	if (gic_irq == GICC_INT_SPURIOUS)
 		goto out;
 
 	cascade_irq = irq_find_mapping(chip_data->domain, gic_irq);
@@ -361,7 +361,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	unsigned int gic_irqs = gic->gic_irqs;
 	void __iomem *base = gic_data_dist_base(gic);
 
-	writel_relaxed(0, base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_DISABLE, base + GIC_DIST_CTRL);
 
 	/*
 	 * Set all global interrupts to this CPU only.
@@ -374,7 +374,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 
 	gic_dist_config(base, gic_irqs, NULL);
 
-	writel_relaxed(1, base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_ENABLE, base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_init(struct gic_chip_data *gic)
@@ -401,8 +401,8 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 
 	gic_cpu_config(dist_base, NULL);
 
-	writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, base + GIC_CPU_CTRL);
+	writel_relaxed(GICC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
+	writel_relaxed(GICC_ENABLE, base + GIC_CPU_CTRL);
 }
 
 void gic_cpu_if_down(void)
@@ -468,14 +468,14 @@ static void gic_dist_restore(unsigned int gic_nr)
 	if (!dist_base)
 		return;
 
-	writel_relaxed(0, dist_base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_DISABLE, dist_base + GIC_DIST_CTRL);
 
 	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
 		writel_relaxed(gic_data[gic_nr].saved_spi_conf[i],
 			dist_base + GIC_DIST_CONFIG + i * 4);
 
 	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
-		writel_relaxed(0xa0a0a0a0,
+		writel_relaxed(GICD_INT_DEF_PRI_X4,
 			dist_base + GIC_DIST_PRI + i * 4);
 
 	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
@@ -486,7 +486,7 @@ static void gic_dist_restore(unsigned int gic_nr)
 		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
 			dist_base + GIC_DIST_ENABLE_SET + i * 4);
 
-	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
+	writel_relaxed(GICD_ENABLE, dist_base + GIC_DIST_CTRL);
 }
 
 static void gic_cpu_save(unsigned int gic_nr)
@@ -540,10 +540,11 @@ static void gic_cpu_restore(unsigned int gic_nr)
 		writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
 
 	for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
-		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
+		writel_relaxed(GICD_INT_DEF_PRI_X4,
+					dist_base + GIC_DIST_PRI + i * 4);
 
-	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+	writel_relaxed(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
+	writel_relaxed(GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 45e2d8c..5cb9d41 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -21,7 +21,10 @@
 #define GIC_CPU_ACTIVEPRIO		0xd0
 #define GIC_CPU_IDENT			0xfc
 
+#define GICC_ENABLE			0x1
+#define GICC_INT_PRI_THRESHOLD		0xf0
 #define GICC_IAR_INT_ID_MASK		0x3ff
+#define GICC_INT_SPURIOUS		1023
 
 #define GIC_DIST_CTRL			0x000
 #define GIC_DIST_CTR			0x004
@@ -39,6 +42,18 @@
 #define GIC_DIST_SGI_PENDING_CLEAR	0xf10
 #define GIC_DIST_SGI_PENDING_SET	0xf20
 
+#define GICD_ENABLE			0x1
+#define GICD_DISABLE			0x0
+#define GICD_INT_ACTLOW_LVLTRIG		0x0
+#define GICD_INT_EN_CLR_X32		0xffffffff
+#define GICD_INT_EN_SET_SGI		0x0000ffff
+#define GICD_INT_EN_CLR_PPI		0xffff0000
+#define GICD_INT_DEF_PRI		0xa0
+#define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
+					(GICD_INT_DEF_PRI << 16) |\
+					(GICD_INT_DEF_PRI << 8) |\
+					GICD_INT_DEF_PRI)
+
 #define GICH_HCR			0x0
 #define GICH_VTR			0x4
 #define GICH_VMCR			0x8
-- 
1.9.1

