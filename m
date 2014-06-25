Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbaFYWNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:13:51 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:60278 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755156AbaFYWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:13:50 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2014 18:13:50 EDT
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, patches@apm.com
Cc: Feng Kan <fkan@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: [PATCH V2 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register
Date: Wed, 25 Jun 2014 15:07:21 -0700
Message-Id: <1403734041-5112-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403734041-5112-1-git-send-email-fkan@apm.com>
References: <1403734041-5112-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is made to preserve the GIC v2 bypass bits in the
GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
This code will preserve all bits configured by the bootloader regarding
v2 bypass group bits. In the X-Gene platform, the bypass functionality
is not used and bypass bits should not be changed by the kernel gic
code as it could lead to incorrect behavior.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
Reviewed-by: Anup Patel <apatel@apm.com>
---
 drivers/irqchip/irq-gic.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 9ec3f4c..e70ef38 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -64,6 +64,7 @@
 #define GIC_CPU_INT_PRI_THRESHOLD	0xf0
 #define GIC_CPU_INT_SPURIOUS		1023
 #define GIC_CPU_INT_ID_MASK		0x3ff
+#define GIC_CPU_DIS_BYPASS_MASK		0x1e0
 
 union gic_base {
 	void __iomem *common_base;
@@ -394,6 +395,20 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 	return mask;
 }
 
+static void gic_cpu_if_up(void)
+{
+	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
+	u32 bypass;
+
+	/*
+	 * Preserve bypass disable bits to be written back later
+	 */
+	bypass = readl(cpu_base + GIC_CPU_CTRL);
+	bypass &= GIC_CPU_DIS_BYPASS_MASK;
+
+	writel_relaxed(bypass | GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
+}
+
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
 	unsigned int i;
@@ -476,13 +491,17 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 				dist_base + GIC_DIST_PRI + i * 4 / 4);
 
 	writel_relaxed(GIC_CPU_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
-	writel_relaxed(GIC_CPU_ENABLE, base + GIC_CPU_CTRL);
+	gic_cpu_if_up();
 }
 
 void gic_cpu_if_down(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+	u32 val;
+
+	val = readl(cpu_base + GIC_CPU_CTRL);
+	val &= ~GIC_CPU_ENABLE;
+	writel_relaxed(val, cpu_base + GIC_CPU_CTRL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -618,7 +637,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 					dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(GIC_CPU_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
+	gic_cpu_if_up();
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
-- 
1.9.1

