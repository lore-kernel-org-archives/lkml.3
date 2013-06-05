Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3FEP32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:29:28 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:45598 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab3FEP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:29:24 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: OMAP: DM816x: add clock domain support for DM816x
Date: Wed,  5 Jun 2013 19:29:15 +0400
Message-Id: <1370446156-11788-5-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
References: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds required definitions and structures for clockdomain
initialization:

1. register offsets for DM81xx and DM816x clock domain modules;
2. clock domain register bits;
3. additional OMAP2/3 common clock domains: prm_clkdm and cm_clkdm;
4. clockdomain structure definitions for DM816x.

Also, omap3xxx_clockdomains_init() was substituted by new
dm81xx_clockdomains_init().

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/Makefile                     |    2 +
 arch/arm/mach-omap2/clockdomain.h                |    3 +
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c |   10 +
 arch/arm/mach-omap2/clockdomains_dm81xx_data.c   |  213 ++++++++++++++++++++++
 arch/arm/mach-omap2/cm-regbits-dm81xx.h          |   22 +++
 arch/arm/mach-omap2/cm_dm81xx.h                  |   61 +++++++
 arch/arm/mach-omap2/io.c                         |    2 +-
 7 files changed, 312 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-omap2/clockdomains_dm81xx_data.c
 create mode 100644 arch/arm/mach-omap2/cm-regbits-dm81xx.h
 create mode 100644 arch/arm/mach-omap2/cm_dm81xx.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 03121cc..132a1e2 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -158,6 +158,8 @@ obj-$(CONFIG_ARCH_OMAP4)		+= $(clockdomain-common)
 obj-$(CONFIG_ARCH_OMAP4)		+= clockdomains44xx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(clockdomain-common)
 obj-$(CONFIG_SOC_AM33XX)		+= clockdomains_am33xx_data.o
+obj-$(CONFIG_SOC_DM81XX)		+= $(clockdomain-common)
+obj-$(CONFIG_SOC_DM81XX)		+= clockdomains_dm81xx_data.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(clockdomain-common)
 
 # Clock framework
diff --git a/arch/arm/mach-omap2/clockdomain.h b/arch/arm/mach-omap2/clockdomain.h
index 2da3765..0a9d4fc 100644
--- a/arch/arm/mach-omap2/clockdomain.h
+++ b/arch/arm/mach-omap2/clockdomain.h
@@ -215,6 +215,7 @@ extern void __init omap242x_clockdomains_init(void);
 extern void __init omap243x_clockdomains_init(void);
 extern void __init omap3xxx_clockdomains_init(void);
 extern void __init am33xx_clockdomains_init(void);
+extern void __init dm81xx_clockdomains_init(void);
 extern void __init omap44xx_clockdomains_init(void);
 
 extern void clkdm_add_autodeps(struct clockdomain *clkdm);
@@ -228,5 +229,7 @@ extern struct clkdm_ops am33xx_clkdm_operations;
 extern struct clkdm_dep gfx_24xx_wkdeps[];
 extern struct clkdm_dep dsp_24xx_wkdeps[];
 extern struct clockdomain wkup_common_clkdm;
+extern struct clockdomain cm_common_clkdm;
+extern struct clockdomain prm_common_clkdm;
 
 #endif
diff --git a/arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c b/arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c
index 49722196..8a62c7f 100644
--- a/arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c
+++ b/arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c
@@ -90,3 +90,13 @@ struct clockdomain wkup_common_clkdm = {
 	.dep_bit	= OMAP_EN_WKUP_SHIFT,
 	.flags		= CLKDM_ACTIVE_WITH_MPU,
 };
+
+struct clockdomain prm_common_clkdm = {
+	.name		= "prm_clkdm",
+	.pwrdm		= { .name = "wkup_pwrdm" },
+};
+
+struct clockdomain cm_common_clkdm = {
+	.name		= "cm_clkdm",
+	.pwrdm		= { .name = "core_pwrdm" },
+};
diff --git a/arch/arm/mach-omap2/clockdomains_dm81xx_data.c b/arch/arm/mach-omap2/clockdomains_dm81xx_data.c
new file mode 100644
index 0000000..daf390f
--- /dev/null
+++ b/arch/arm/mach-omap2/clockdomains_dm81xx_data.c
@@ -0,0 +1,213 @@
+/*
+ * DM81XX Clock Domain data.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ * Copyright (C) 2013 SKTB SKiT, http://www.skitlab.ru/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_CLOCKDOMAINS_DM81XX_H
+#define __ARCH_ARM_MACH_OMAP2_CLOCKDOMAINS_DM81XX_H
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+
+#include "clockdomain.h"
+
+#include "cm_dm81xx.h"
+#include "cm-regbits-dm81xx.h"
+
+/*
+ * TODO:
+ * - Add other domains as required
+ * - Fill up associated powerdomans (especially ALWON powerdomains are NULL at
+ *   the moment
+ * - Consider dependencies across domains (probably not applicable till now)
+ */
+
+/* Common DM81XX */
+static struct clockdomain alwon_l3_slow_dm81xx_clkdm = {
+	.name		= "alwon_l3_slow_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_ALWON_L3_SLOW_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain alwon_l3_med_dm81xx_clkdm = {
+	.name		= "alwon_l3_med_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_ALWON_L3_MED_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain alwon_l3_fast_dm81xx_clkdm = {
+	.name		= "alwon_l3_fast_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_ALWON_L3_FAST_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain alwon_ethernet_dm81xx_clkdm = {
+	.name		= "alwon_ethernet_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_ETHERNET_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+/* OCMC clock domain */
+static struct clockdomain mmu_dm81xx_clkdm = {
+	.name		= "mmu_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_MMU_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain mmu_cfg_dm81xx_clkdm = {
+	.name		= "mmu_cfg_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_MMUCFG_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+/* DM816X only */
+static struct clockdomain alwon_mpu_dm816x_clkdm = {
+	.name		= "alwon_mpu_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= DM81XX_CM_ALWON_MOD,
+	.clkdm_offs	= DM81XX_CM_ALWON_MPU_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain active_gem_dm816x_clkdm = {
+	.name		= "active_gem_clkdm",
+	.pwrdm		= { .name = "active_pwrdm" },
+	.cm_inst	= DM816X_CM_ACTIVE_MOD,
+	.clkdm_offs	= DM816X_CM_ACTIVE_GEM_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain ivahd0_dm816x_clkdm = {
+	.name		= "ivahd0_clkdm",
+	.pwrdm		= { .name = "ivahd0_pwrdm" },
+	.cm_inst	= DM816X_CM_IVAHD0_MOD,
+	.clkdm_offs	= DM816X_CM_IVAHD0_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain ivahd1_dm816x_clkdm = {
+	.name		= "ivahd1_clkdm",
+	.pwrdm		= { .name = "ivahd1_pwrdm" },
+	.cm_inst	= DM816X_CM_IVAHD1_MOD,
+	.clkdm_offs	= DM816X_CM_IVAHD1_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain ivahd2_dm816x_clkdm = {
+	.name		= "ivahd2_clkdm",
+	.pwrdm		= { .name = "ivahd2_pwrdm" },
+	.cm_inst	= DM816X_CM_IVAHD2_MOD,
+	.clkdm_offs	= DM816X_CM_IVAHD2_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain sgx_dm816x_clkdm = {
+	.name		= "sgx_clkdm",
+	.pwrdm		= { .name = "sgx_pwrdm" },
+	.cm_inst	= DM816X_CM_SGX_MOD,
+	.clkdm_offs	= DM816X_CM_SGX_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_l3_med_dm816x_clkdm = {
+	.name		= "default_l3_med_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= DM816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= DM816X_CM_DEFAULT_L3_MED_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_ducati_dm816x_clkdm = {
+	.name		= "default_ducati_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= DM816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= DM816X_CM_DEFAULT_DUCATI_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_pcie_dm816x_clkdm = {
+	.name		= "default_pcie_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= DM816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= DM816X_CM_DEFAULT_PCI_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_usb_dm816x_clkdm = {
+	.name		= "default_usb_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= DM816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= DM816X_CM_DEFAULT_L3_SLOW_CLKDM,
+	.clktrctrl_mask	= DM81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain *clockdomains_dm81xx[] __initdata = {
+	&wkup_common_clkdm,
+	&cm_common_clkdm,
+	&prm_common_clkdm,
+
+	&alwon_mpu_dm816x_clkdm,
+	&alwon_l3_slow_dm81xx_clkdm,
+	&alwon_l3_med_dm81xx_clkdm,
+	&alwon_l3_fast_dm81xx_clkdm,
+	&alwon_ethernet_dm81xx_clkdm,
+	&mmu_dm81xx_clkdm,
+	&mmu_cfg_dm81xx_clkdm,
+	&active_gem_dm816x_clkdm,
+	&ivahd0_dm816x_clkdm,
+	&ivahd1_dm816x_clkdm,
+	&ivahd2_dm816x_clkdm,
+	&sgx_dm816x_clkdm,
+	&default_l3_med_dm816x_clkdm,
+	&default_ducati_dm816x_clkdm,
+	&default_pcie_dm816x_clkdm,
+	&default_usb_dm816x_clkdm,
+	NULL,
+};
+
+void __init dm81xx_clockdomains_init(void)
+{
+	clkdm_register_platform_funcs(&omap3_clkdm_operations);
+	clkdm_register_clkdms(clockdomains_dm81xx);
+	clkdm_complete_init();
+}
+#endif
diff --git a/arch/arm/mach-omap2/cm-regbits-dm81xx.h b/arch/arm/mach-omap2/cm-regbits-dm81xx.h
new file mode 100644
index 0000000..536e19a
--- /dev/null
+++ b/arch/arm/mach-omap2/cm-regbits-dm81xx.h
@@ -0,0 +1,22 @@
+/*
+ * Clock Domain register bits for DM81xx.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ * Copyright (C) 2013 SKTB SKiT, http://www.skitlab.ru/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_CM_REGBITS_DM81XX_H
+#define __ARCH_ARM_MACH_OMAP2_CM_REGBITS_DM81XX_H
+
+#define DM81XX_CLKTRCTRL_MASK				(3 << 0)
+
+#endif
diff --git a/arch/arm/mach-omap2/cm_dm81xx.h b/arch/arm/mach-omap2/cm_dm81xx.h
new file mode 100644
index 0000000..f8988da
--- /dev/null
+++ b/arch/arm/mach-omap2/cm_dm81xx.h
@@ -0,0 +1,61 @@
+/*
+ * Clock domain register offsets for DM81xx.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
+ * Copyright (C) 2013 SKTB SKiT, http://www.skitlab.ru/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP2_CM_DM81XX_H
+#define __ARCH_ARM_MACH_OMAP2_CM_DM81XX_H
+
+/* DM81XX common CM module offsets */
+#define DM81XX_CM_ALWON_MOD				0x1400	/* 1KB */
+
+/* DM816X CM module offsets */
+#define DM816X_CM_ACTIVE_MOD			0x0400	/* 256B */
+#define DM816X_CM_DEFAULT_MOD			0x0500	/* 256B */
+#define DM816X_CM_IVAHD0_MOD			0x0600	/* 256B */
+#define DM816X_CM_IVAHD1_MOD			0x0700	/* 256B */
+#define DM816X_CM_IVAHD2_MOD			0x0800	/* 256B */
+#define DM816X_CM_SGX_MOD				0x0900	/* 256B */
+
+/* ALWON */
+#define DM81XX_CM_ALWON_MPU_CLKDM		0x001C
+#define DM81XX_CM_ALWON_L3_SLOW_CLKDM	0x0000
+#define DM81XX_CM_ALWON_L3_MED_CLKDM	0x0004
+#define DM81XX_CM_ALWON_L3_FAST_CLKDM	0x0030
+#define DM81XX_CM_ETHERNET_CLKDM		0x0004
+#define DM81XX_CM_MMU_CLKDM				0x000C
+#define DM81XX_CM_MMUCFG_CLKDM			0x0010
+
+/* ACTIVE */
+#define DM816X_CM_ACTIVE_GEM_CLKDM		0x0000
+
+/* IVAHD0 */
+#define DM816X_CM_IVAHD0_CLKDM			0x0000
+
+/* IVAHD1 */
+#define DM816X_CM_IVAHD1_CLKDM			0x0000
+
+/* IVAHD2 */
+#define DM816X_CM_IVAHD2_CLKDM			0x0000
+
+/* SGX */
+#define DM816X_CM_SGX_CLKDM				0x0000
+
+/* DEFAULT */
+#define DM816X_CM_DEFAULT_L3_MED_CLKDM	0x0004
+#define DM816X_CM_DEFAULT_DUCATI_CLKDM	0x0018
+#define DM816X_CM_DEFAULT_PCI_CLKDM		0x0010
+#define DM816X_CM_DEFAULT_L3_SLOW_CLKDM	0x0014
+
+#endif
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 2a9e5b3..f3808ce 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -517,7 +517,7 @@ void __init dm81xx_init_early(void)
 	dm81xx_check_features();
 	omap3xxx_voltagedomains_init();
 	dm81xx_powerdomains_init();
-	omap3xxx_clockdomains_init();
+	dm81xx_clockdomains_init();
 	omap3xxx_hwmod_init();
 	omap_hwmod_init_postsetup();
 	omap_clk_init = omap3xxx_clk_init;
-- 
1.7.10.4

