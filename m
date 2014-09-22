Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaIVRKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:10:53 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58212 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaIVRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:43 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 6/9] ARM: imx: gpc: Support vf610 global power controller
Date: Mon, 22 Sep 2014 19:09:27 +0200
Message-Id: <cb9924da68e800bffa27aa30fb16dcf92e10ae70.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Vybrid SoC which has a similar global power controller
found in i.MX6 SoC's. The extension for the GIC interrupt
controller can be reused. However, Vybrid's GPC has no CPU
powerdown flag, hence we write this conditional.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/Kconfig       |  1 +
 arch/arm/mach-imx/common.h      |  3 +-
 arch/arm/mach-imx/gpc.c         | 61 +++++++++++++++++++++++++++--------------
 arch/arm/mach-imx/mach-imx6q.c  |  2 +-
 arch/arm/mach-imx/mach-imx6sl.c |  2 +-
 arch/arm/mach-imx/mach-vf610.c  |  7 +++++
 6 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index a566fbf3..70e6d56 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -633,6 +633,7 @@ config SOC_VF610
 	bool "Vybrid Family VF610 support"
 	select ARM_GIC
 	select PINCTRL_VF610
+	select HAVE_IMX_GPC
 	select ARM_GLOBAL_TIMER
 	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
 	select PL310_ERRATA_769419 if CACHE_L2X0
diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index 1dabf43..4b753f5 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -103,7 +103,8 @@ static inline void imx_scu_map_io(void) {}
 static inline void imx_smp_prepare(void) {}
 #endif
 void imx_src_init(void);
-void imx_gpc_init(void);
+void imx6_gpc_init(void);
+void vf610_gpc_init(void);
 void imx_gpc_pre_suspend(bool arm_power_off);
 void imx_gpc_post_resume(void);
 void imx_gpc_mask_all(void);
diff --git a/arch/arm/mach-imx/gpc.c b/arch/arm/mach-imx/gpc.c
index 82ea74e..4ac7a48 100644
--- a/arch/arm/mach-imx/gpc.c
+++ b/arch/arm/mach-imx/gpc.c
@@ -18,40 +18,42 @@
 #include <linux/irqchip/arm-gic.h>
 #include "common.h"
 
-#define GPC_IMR1		0x008
+#define IMX6_GPC_IMR1		0x008
+#define VF610_GPC_IMR1		0x044
 #define GPC_PGC_CPU_PDN		0x2a0
 
 #define IMR_NUM			4
 
 static void __iomem *gpc_base;
+static void __iomem *gpc_imr_base;
+static bool has_cpu_pdn;
 static u32 gpc_wake_irqs[IMR_NUM];
 static u32 gpc_saved_imrs[IMR_NUM];
 
 void imx_gpc_pre_suspend(bool arm_power_off)
 {
-	void __iomem *reg_imr1 = gpc_base + GPC_IMR1;
 	int i;
 
 	/* Tell GPC to power off ARM core when suspend */
-	if (arm_power_off)
+	if (arm_power_off && has_cpu_pdn)
 		writel_relaxed(0x1, gpc_base + GPC_PGC_CPU_PDN);
 
 	for (i = 0; i < IMR_NUM; i++) {
-		gpc_saved_imrs[i] = readl_relaxed(reg_imr1 + i * 4);
-		writel_relaxed(~gpc_wake_irqs[i], reg_imr1 + i * 4);
+		gpc_saved_imrs[i] = readl_relaxed(gpc_imr_base + i * 4);
+		writel_relaxed(~gpc_wake_irqs[i], gpc_imr_base + i * 4);
 	}
 }
 
 void imx_gpc_post_resume(void)
 {
-	void __iomem *reg_imr1 = gpc_base + GPC_IMR1;
 	int i;
 
 	/* Keep ARM core powered on for other low-power modes */
-	writel_relaxed(0x0, gpc_base + GPC_PGC_CPU_PDN);
+	if (has_cpu_pdn)
+		writel_relaxed(0x0, gpc_base + GPC_PGC_CPU_PDN);
 
 	for (i = 0; i < IMR_NUM; i++)
-		writel_relaxed(gpc_saved_imrs[i], reg_imr1 + i * 4);
+		writel_relaxed(gpc_saved_imrs[i], gpc_imr_base + i * 4);
 }
 
 static int imx_gpc_irq_set_wake(struct irq_data *d, unsigned int on)
@@ -72,23 +74,21 @@ static int imx_gpc_irq_set_wake(struct irq_data *d, unsigned int on)
 
 void imx_gpc_mask_all(void)
 {
-	void __iomem *reg_imr1 = gpc_base + GPC_IMR1;
 	int i;
 
 	for (i = 0; i < IMR_NUM; i++) {
-		gpc_saved_imrs[i] = readl_relaxed(reg_imr1 + i * 4);
-		writel_relaxed(~0, reg_imr1 + i * 4);
+		gpc_saved_imrs[i] = readl_relaxed(gpc_imr_base + i * 4);
+		writel_relaxed(~0, gpc_imr_base + i * 4);
 	}
 
 }
 
 void imx_gpc_restore_all(void)
 {
-	void __iomem *reg_imr1 = gpc_base + GPC_IMR1;
 	int i;
 
 	for (i = 0; i < IMR_NUM; i++)
-		writel_relaxed(gpc_saved_imrs[i], reg_imr1 + i * 4);
+		writel_relaxed(gpc_saved_imrs[i], gpc_imr_base + i * 4);
 }
 
 void imx_gpc_irq_unmask(struct irq_data *d)
@@ -100,7 +100,7 @@ void imx_gpc_irq_unmask(struct irq_data *d)
 	if (d->irq < 32)
 		return;
 
-	reg = gpc_base + GPC_IMR1 + (d->irq / 32 - 1) * 4;
+	reg = gpc_imr_base + (d->irq / 32 - 1) * 4;
 	val = readl_relaxed(reg);
 	val &= ~(1 << d->irq % 32);
 	writel_relaxed(val, reg);
@@ -115,27 +115,48 @@ void imx_gpc_irq_mask(struct irq_data *d)
 	if (d->irq < 32)
 		return;
 
-	reg = gpc_base + GPC_IMR1 + (d->irq / 32 - 1) * 4;
+	reg = gpc_imr_base + (d->irq / 32 - 1) * 4;
 	val = readl_relaxed(reg);
 	val |= 1 << (d->irq % 32);
 	writel_relaxed(val, reg);
 }
 
-void __init imx_gpc_init(void)
+static void __init imx_gpc_init(void)
 {
-	struct device_node *np;
 	int i;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-gpc");
-	gpc_base = of_iomap(np, 0);
 	WARN_ON(!gpc_base);
 
 	/* Initially mask all interrupts */
 	for (i = 0; i < IMR_NUM; i++)
-		writel_relaxed(~0, gpc_base + GPC_IMR1 + i * 4);
+		writel_relaxed(~0, gpc_imr_base + i * 4);
 
 	/* Register GPC as the secondary interrupt controller behind GIC */
 	gic_arch_extn.irq_mask = imx_gpc_irq_mask;
 	gic_arch_extn.irq_unmask = imx_gpc_irq_unmask;
 	gic_arch_extn.irq_set_wake = imx_gpc_irq_set_wake;
 }
+
+void __init imx6_gpc_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-gpc");
+	gpc_base = of_iomap(np, 0);
+	gpc_imr_base = gpc_base + IMX6_GPC_IMR1;
+	has_cpu_pdn = true;
+
+	imx_gpc_init();
+}
+
+void __init vf610_gpc_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,vf610-gpc");
+	gpc_base = of_iomap(np, 0);
+	gpc_imr_base = gpc_base + VF610_GPC_IMR1;
+	has_cpu_pdn = false;
+
+	imx_gpc_init();
+}
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index d51c6e9..b26dc73 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -392,7 +392,7 @@ static void __init imx6q_init_irq(void)
 	imx_init_revision_from_anatop();
 	imx_init_l2cache();
 	imx_src_init();
-	imx_gpc_init();
+	imx6_gpc_init();
 	irqchip_init();
 }
 
diff --git a/arch/arm/mach-imx/mach-imx6sl.c b/arch/arm/mach-imx/mach-imx6sl.c
index ed263a2..df462d6 100644
--- a/arch/arm/mach-imx/mach-imx6sl.c
+++ b/arch/arm/mach-imx/mach-imx6sl.c
@@ -66,7 +66,7 @@ static void __init imx6sl_init_irq(void)
 	imx_init_revision_from_anatop();
 	imx_init_l2cache();
 	imx_src_init();
-	imx_gpc_init();
+	imx6_gpc_init();
 	irqchip_init();
 }
 
diff --git a/arch/arm/mach-imx/mach-vf610.c b/arch/arm/mach-imx/mach-vf610.c
index ee7e57b..532f18f 100644
--- a/arch/arm/mach-imx/mach-vf610.c
+++ b/arch/arm/mach-imx/mach-vf610.c
@@ -14,6 +14,12 @@
 
 #include "common.h"
 
+static void __init vf610_init_irq(void)
+{
+	vf610_gpc_init();
+	irqchip_init();
+}
+
 static void __init vf610_init_machine(void)
 {
 	mxc_arch_reset_init_dt();
@@ -29,6 +35,7 @@ DT_MACHINE_START(VYBRID_VF610, "Freescale Vybrid VF610 (Device Tree)")
 	.l2c_aux_val	= 0,
 	.l2c_aux_mask	= ~0,
 	.init_machine   = vf610_init_machine,
+	.init_irq	= vf610_init_irq,
 	.dt_compat	= vf610_dt_compat,
 	.restart	= mxc_restart,
 MACHINE_END
-- 
2.1.0

