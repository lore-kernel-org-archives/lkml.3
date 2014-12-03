Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbaLCAPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:15:45 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33473 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432AbaLCAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:25 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 06/12] ARM: imx: add support for MSCM interrupt router
Date: Wed,  3 Dec 2014 01:12:05 +0100
Message-Id: <1417565531-4507-7-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Vybrids interrupt router for the shared
peripherals. The router is part of the MSCM (Miscellaneous System
Control Module).

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/Kconfig      |   4 ++
 arch/arm/mach-imx/Makefile     |   1 +
 arch/arm/mach-imx/common.h     |   1 +
 arch/arm/mach-imx/mach-vf610.c |   7 ++
 arch/arm/mach-imx/mscm-vf610.c | 141 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 154 insertions(+)
 create mode 100644 arch/arm/mach-imx/mscm-vf610.c

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index e8627e0..2935972 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -58,6 +58,9 @@ config HAVE_IMX_SRC
 	def_bool y if SMP
 	select ARCH_HAS_RESET_CONTROLLER
 
+config HAVE_VF610_MSCM
+	bool
+
 config IMX_HAVE_IOMUX_V1
 	bool
 
@@ -631,6 +634,7 @@ config SOC_IMX6SX
 
 config SOC_VF610
 	bool "Vybrid Family VF610 support"
+	select HAVE_VF610_MSCM
 	select ARM_GIC
 	select PINCTRL_VF610
 	select PL310_ERRATA_769419 if CACHE_L2X0
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index f5ac685..82b1159 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -108,6 +108,7 @@ obj-$(CONFIG_SOC_IMX50) += mach-imx50.o
 obj-$(CONFIG_SOC_IMX51) += mach-imx51.o
 obj-$(CONFIG_SOC_IMX53) += mach-imx53.o
 
+obj-$(CONFIG_HAVE_VF610_MSCM) += mscm-vf610.o
 obj-$(CONFIG_SOC_VF610) += clk-vf610.o mach-vf610.o
 
 obj-$(CONFIG_SOC_LS1021A) += mach-ls1021a.o
diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index 59ce8f3..6b5cad9 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -103,6 +103,7 @@ static inline void imx_smp_prepare(void) {}
 #endif
 void imx_src_init(void);
 void imx_gpc_init(void);
+void vf610_mscm_init(void);
 void imx_gpc_pre_suspend(bool arm_power_off);
 void imx_gpc_post_resume(void);
 void imx_gpc_mask_all(void);
diff --git a/arch/arm/mach-imx/mach-vf610.c b/arch/arm/mach-imx/mach-vf610.c
index c11ab6a..d1d200d 100644
--- a/arch/arm/mach-imx/mach-vf610.c
+++ b/arch/arm/mach-imx/mach-vf610.c
@@ -12,6 +12,12 @@
 #include <asm/mach/arch.h>
 #include <asm/hardware/cache-l2x0.h>
 
+static void __init vf610_init_irq(void)
+{
+	vf610_mscm_init();
+	irqchip_init();
+}
+
 static const char * const vf610_dt_compat[] __initconst = {
 	"fsl,vf610",
 	NULL,
@@ -20,5 +26,6 @@ static const char * const vf610_dt_compat[] __initconst = {
 DT_MACHINE_START(VYBRID_VF610, "Freescale Vybrid VF610 (Device Tree)")
 	.l2c_aux_val	= 0,
 	.l2c_aux_mask	= ~0,
+	.init_irq	= vf610_init_irq,
 	.dt_compat	= vf610_dt_compat,
 MACHINE_END
diff --git a/arch/arm/mach-imx/mscm-vf610.c b/arch/arm/mach-imx/mscm-vf610.c
new file mode 100644
index 0000000..211ea10
--- /dev/null
+++ b/arch/arm/mach-imx/mscm-vf610.c
@@ -0,0 +1,141 @@
+/*
+ * Copyright 2014 Stefan Agner
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/cpu_pm.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/arm-nvic.h>
+#include "common.h"
+
+#define MSCM_CPxNUM		0x4
+#define MSCM_IRSPRC(n)		(0x880 + 2 * (n))
+#define MSCM_IRSPRC_CPEN_MASK	0x3
+
+#define MSCM_IRSPRC_NUM		112
+
+#ifdef CONFIG_ARM_GIC
+#define MSCM_IRQ_OFFSET		32
+#elif CONFIG_ARM_NVIC
+#define MSCM_IRQ_OFFSET		0
+#endif
+
+static void __iomem *mscm_base;
+static u16 mscm_saved_irsprc[MSCM_IRSPRC_NUM];
+static u16 cpu_id;
+
+static int vf610_mscm_notifier(struct notifier_block *self, unsigned long cmd,
+			       void *v)
+{
+	int i;
+
+	/* Only the primary (boot CPU) should do suspend/resume */
+	if (cpu_id > 0)
+		return NOTIFY_OK;
+
+	switch (cmd) {
+	case CPU_CLUSTER_PM_ENTER:
+		for (i = 0; i < MSCM_IRSPRC_NUM; i++)
+			mscm_saved_irsprc[i] =
+				readw_relaxed(mscm_base + MSCM_IRSPRC(i));
+		break;
+	case CPU_CLUSTER_PM_ENTER_FAILED:
+	case CPU_CLUSTER_PM_EXIT:
+		for (i = 0; i < MSCM_IRSPRC_NUM; i++)
+			writew_relaxed(mscm_saved_irsprc[i],
+				       mscm_base + MSCM_IRSPRC(i));
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mscm_notifier_block = {
+	.notifier_call = vf610_mscm_notifier,
+};
+
+static int vf610_mscm_domain_map(struct irq_domain *d, unsigned int irq,
+			       irq_hw_number_t hw)
+{
+	u16 irsprc;
+
+	/* Do not handle non interrupt router IRQs */
+	if (hw < MSCM_IRQ_OFFSET)
+		return 0;
+
+	hw -= MSCM_IRQ_OFFSET;
+	irsprc = readw_relaxed(mscm_base + MSCM_IRSPRC(hw));
+	irsprc &= MSCM_IRSPRC_CPEN_MASK;
+
+	WARN_ON(irsprc);
+
+	writew_relaxed(0x1 << cpu_id, mscm_base + MSCM_IRSPRC(hw));
+
+	return 0;
+}
+
+static void vf610_mscm_domain_unmap(struct irq_domain *d, unsigned int irq)
+{
+	irq_hw_number_t hw = irq_get_irq_data(irq)->hwirq;
+	u16 irsprc;
+
+	/* Do not handle non interrupt router IRQs */
+	if (hw < MSCM_IRQ_OFFSET)
+		return;
+
+	hw -= MSCM_IRQ_OFFSET;
+	irsprc = readw_relaxed(mscm_base + MSCM_IRSPRC(hw));
+	irsprc &= MSCM_IRSPRC_CPEN_MASK;
+
+	WARN_ON(irsprc & ~(0x1 << cpu_id));
+
+	writew_relaxed(0x1 << cpu_id, mscm_base + MSCM_IRSPRC(hw));
+}
+
+static int vf610_mscm_domain_xlate(struct irq_domain *d,
+				struct device_node *controller,
+				const u32 *intspec, unsigned int intsize,
+				unsigned long *out_hwirq,
+				unsigned int *out_type)
+{
+#ifdef CONFIG_ARM_GIC
+	*out_hwirq += 16;
+#endif
+	return 0;
+}
+static const struct irq_domain_ops routable_irq_domain_ops = {
+	.map = vf610_mscm_domain_map,
+	.unmap = vf610_mscm_domain_unmap,
+	.xlate = vf610_mscm_domain_xlate,
+};
+
+void __init vf610_mscm_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,vf610-mscm");
+	mscm_base = of_iomap(np, 0);
+
+	if (!mscm_base) {
+		WARN_ON(1);
+		return;
+	}
+
+	cpu_id = readl_relaxed(mscm_base + MSCM_CPxNUM);
+
+	/* Register MSCM as interrupt router */
+	register_routable_domain_ops(&routable_irq_domain_ops);
+
+	cpu_pm_register_notifier(&mscm_notifier_block);
+}
-- 
2.1.3

