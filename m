Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaG3V4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:56:19 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:48705 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753471AbaG3V4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:56:16 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 RESEND 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register
Date: Wed, 30 Jul 2014 14:56:59 -0700
Message-Id: <1406757419-18729-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406757419-18729-1-git-send-email-fkan@apm.com>
References: <1406757419-18729-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is made to preserve the GIC v2 bypass bits in the
GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
This code will preserve all bits configured by the bootloader regarding
v2 bypass group bits. In the X-Gene platform, the bypass functionality
is not used and bypass bits should not be changed by the kernel gic
code as it could lead to incorrect behavior.

Signed-off-by: Feng Kan <fkan@apm.com>
Reviewed-by: Vinayak Kale <vkale@apm.com>
Reviewed-by: Anup Patel <apatel@apm.com>
---
 drivers/irqchip/irq-gic.c       | 25 ++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 2075d52..c31eea4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -354,6 +354,21 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 	return mask;
 }
 
+static void gic_cpu_if_up(void)
+{
+	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
+	u32 bypass = 0;
+
+	/*
+	* Preserve bypass disable bits to be written back later
+	*/
+	bypass = readl(cpu_base + GIC_CPU_CTRL);
+	bypass &= GICC_DIS_BYPASS_MASK;
+
+	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+}
+
+
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
 	unsigned int i;
@@ -402,13 +417,17 @@ static void gic_cpu_init(struct gic_chip_data *gic)
 	gic_cpu_config(dist_base, NULL);
 
 	writel_relaxed(GICC_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
-	writel_relaxed(GICC_ENABLE, base + GIC_CPU_CTRL);
+	gic_cpu_if_up();
 }
 
 void gic_cpu_if_down(void)
 {
 	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
-	writel_relaxed(0, cpu_base + GIC_CPU_CTRL);
+	u32 val = 0;
+
+	val = readl(cpu_base + GIC_CPU_CTRL);
+	val &= ~GICC_ENABLE;
+	writel_relaxed(val, cpu_base + GIC_CPU_CTRL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -544,7 +563,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 					dist_base + GIC_DIST_PRI + i * 4);
 
 	writel_relaxed(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
-	writel_relaxed(GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
+	gic_cpu_if_up();
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 5cb9d41..13eed92 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -25,6 +25,7 @@
 #define GICC_INT_PRI_THRESHOLD		0xf0
 #define GICC_IAR_INT_ID_MASK		0x3ff
 #define GICC_INT_SPURIOUS		1023
+#define GICC_DIS_BYPASS_MASK		0x1e0
 
 #define GIC_DIST_CTRL			0x000
 #define GIC_DIST_CTR			0x004
-- 
1.9.1

