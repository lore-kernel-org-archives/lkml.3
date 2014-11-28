Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaK1Qnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:43:49 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56045 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaK1Qnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:43:47 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
Date: Fri, 28 Nov 2014 17:43:35 +0100
Message-Id: <1417193015-6033-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417193015-6033-1-git-send-email-stefan@agner.ch>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Vybrid SoC's system reset controller (SRC). Currently we
don't register a reset controller but only support the imx_cpu_jump
and imx_cpu_arg functions.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/Makefile     |  2 +-
 arch/arm/mach-imx/common.h     |  1 +
 arch/arm/mach-imx/mach-vf610.c |  8 +++++++
 arch/arm/mach-imx/src-vf610.c  | 53 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-imx/src-vf610.c

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index f5ac685..6f689fc 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -108,7 +108,7 @@ obj-$(CONFIG_SOC_IMX50) += mach-imx50.o
 obj-$(CONFIG_SOC_IMX51) += mach-imx51.o
 obj-$(CONFIG_SOC_IMX53) += mach-imx53.o
 
-obj-$(CONFIG_SOC_VF610) += clk-vf610.o mach-vf610.o
+obj-$(CONFIG_SOC_VF610) += clk-vf610.o src-vf610.o mach-vf610.o
 
 obj-$(CONFIG_SOC_LS1021A) += mach-ls1021a.o
 
diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index 59ce8f3..458db03 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -102,6 +102,7 @@ static inline void imx_scu_map_io(void) {}
 static inline void imx_smp_prepare(void) {}
 #endif
 void imx_src_init(void);
+void vf610_src_init(void);
 void imx_gpc_init(void);
 void imx_gpc_pre_suspend(bool arm_power_off);
 void imx_gpc_post_resume(void);
diff --git a/arch/arm/mach-imx/mach-vf610.c b/arch/arm/mach-imx/mach-vf610.c
index c11ab6a..391c2b5 100644
--- a/arch/arm/mach-imx/mach-vf610.c
+++ b/arch/arm/mach-imx/mach-vf610.c
@@ -11,6 +11,13 @@
 #include <linux/irqchip.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/cache-l2x0.h>
+#include "common.h"
+
+static void __init vf610_init_machine(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	vf610_src_init();
+};
 
 static const char * const vf610_dt_compat[] __initconst = {
 	"fsl,vf610",
@@ -20,5 +27,6 @@ static const char * const vf610_dt_compat[] __initconst = {
 DT_MACHINE_START(VYBRID_VF610, "Freescale Vybrid VF610 (Device Tree)")
 	.l2c_aux_val	= 0,
 	.l2c_aux_mask	= ~0,
+	.init_machine	= vf610_init_machine,
 	.dt_compat	= vf610_dt_compat,
 MACHINE_END
diff --git a/arch/arm/mach-imx/src-vf610.c b/arch/arm/mach-imx/src-vf610.c
new file mode 100644
index 0000000..5fba1d4
--- /dev/null
+++ b/arch/arm/mach-imx/src-vf610.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc.
+ * Copyright 2011 Linaro Ltd.
+ * Copyright 2014 Toradex AG
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/reboot.h>
+#include <linux/reset-controller.h>
+#include <linux/smp.h>
+#include <asm/smp_plat.h>
+#include "common.h"
+
+#define SRC_SCR				0x000
+#define SRC_GPR0			0x020
+#define BP_SRC_SCR_SW_RST		12
+
+static struct notifier_block restart_nb;
+static void __iomem *src_base;
+
+static int vf610_src_restart(struct notifier_block *nb, unsigned long action,
+			       void *data)
+{
+	writel(1 << BP_SRC_SCR_SW_RST, src_base + SRC_SCR);
+	return NOTIFY_DONE;
+}
+
+void __init vf610_src_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,vf610-src");
+	if (!np)
+		return;
+
+	src_base = of_iomap(np, 0);
+	WARN_ON(!src_base);
+
+	restart_nb.notifier_call = vf610_src_restart;
+	restart_nb.priority = 192;
+	if (register_restart_handler(&restart_nb))
+		printk(KERN_WARNING "failed to setup restart handler.\n");
+}
-- 
2.1.3

