Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3HXOCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 10:02:31 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:58321 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3HXOC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 10:02:29 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk
Subject: [PATCH] ARM: OMAP: TI816X: add clock domain support for TI816x
Date: Sat, 24 Aug 2013 18:02:21 +0400
Message-Id: <1377352941-29699-1-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds required definitions and structures for clockdomain
initialization, so omap3xxx_clockdomains_init() was substituted by
new ti81xx_clockdomains_init() while early initialization of
TI81XX platform.

signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/Makefile                   |   2 +
 arch/arm/mach-omap2/clockdomain.h              |   1 +
 arch/arm/mach-omap2/clockdomains_ti81xx_data.c | 208 +++++++++++++++++++++++++
 arch/arm/mach-omap2/cm-regbits-ti81xx.h        |  22 +++
 arch/arm/mach-omap2/cm_ti81xx.h                |  61 ++++++++
 arch/arm/mach-omap2/io.c                       |   2 +-
 6 files changed, 295 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-omap2/clockdomains_ti81xx_data.c
 create mode 100644 arch/arm/mach-omap2/cm-regbits-ti81xx.h
 create mode 100644 arch/arm/mach-omap2/cm_ti81xx.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index d4f6715..44c19b5 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -157,6 +157,8 @@ obj-$(CONFIG_ARCH_OMAP4)		+= $(clockdomain-common)
 obj-$(CONFIG_ARCH_OMAP4)		+= clockdomains44xx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(clockdomain-common)
 obj-$(CONFIG_SOC_AM33XX)		+= clockdomains33xx_data.o
+obj-$(CONFIG_SOC_TI81XX)		+= $(clockdomain-common)
+obj-$(CONFIG_SOC_TI81XX)		+= clockdomains_ti81xx_data.o
 obj-$(CONFIG_SOC_AM43XX)		+= $(clockdomain-common)
 obj-$(CONFIG_SOC_OMAP5)			+= $(clockdomain-common)
 obj-$(CONFIG_SOC_OMAP5)			+= clockdomains54xx_data.o
diff --git a/arch/arm/mach-omap2/clockdomain.h b/arch/arm/mach-omap2/clockdomain.h
index daeecf1..5c42bcf 100644
--- a/arch/arm/mach-omap2/clockdomain.h
+++ b/arch/arm/mach-omap2/clockdomain.h
@@ -215,6 +215,7 @@ extern void __init omap242x_clockdomains_init(void);
 extern void __init omap243x_clockdomains_init(void);
 extern void __init omap3xxx_clockdomains_init(void);
 extern void __init am33xx_clockdomains_init(void);
+extern void __init ti81xx_clockdomains_init(void);
 extern void __init omap44xx_clockdomains_init(void);
 extern void __init omap54xx_clockdomains_init(void);
 
diff --git a/arch/arm/mach-omap2/clockdomains_ti81xx_data.c b/arch/arm/mach-omap2/clockdomains_ti81xx_data.c
new file mode 100644
index 0000000..94d7439
--- /dev/null
+++ b/arch/arm/mach-omap2/clockdomains_ti81xx_data.c
@@ -0,0 +1,208 @@
+/*
+ * TI81XX Clock Domain data.
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
+#ifndef __ARCH_ARM_MACH_OMAP2_CLOCKDOMAINS_TI81XX_H
+#define __ARCH_ARM_MACH_OMAP2_CLOCKDOMAINS_TI81XX_H
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+
+#include "clockdomain.h"
+
+#include "cm_ti81xx.h"
+#include "cm-regbits-ti81xx.h"
+
+/*
+ * - Add other domains as required
+ * - Fill up associated powerdomans (especially ALWON powerdomains are NULL at
+ *   the moment
+ * - Consider dependencies across domains (probably not applicable till now)
+ */
+
+/* Common TI81XX */
+static struct clockdomain alwon_l3_slow_ti81xx_clkdm = {
+	.name		= "alwon_l3_slow_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_ALWON_L3_SLOW_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain alwon_l3_med_ti81xx_clkdm = {
+	.name		= "alwon_l3_med_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_ALWON_L3_MED_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain alwon_l3_fast_ti81xx_clkdm = {
+	.name		= "alwon_l3_fast_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_ALWON_L3_FAST_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain alwon_ethernet_ti81xx_clkdm = {
+	.name		= "alwon_ethernet_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_ETHERNET_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+/* OCMC clock domain */
+static struct clockdomain mmu_ti81xx_clkdm = {
+	.name		= "mmu_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_MMU_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain mmu_cfg_ti81xx_clkdm = {
+	.name		= "mmu_cfg_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_MMUCFG_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+/* TI816X only */
+static struct clockdomain alwon_mpu_ti816x_clkdm = {
+	.name		= "alwon_mpu_clkdm",
+	.pwrdm		= { .name = "alwon_pwrdm" },
+	.cm_inst	= TI81XX_CM_ALWON_MOD,
+	.clkdm_offs	= TI81XX_CM_ALWON_MPU_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain active_gem_ti816x_clkdm = {
+	.name		= "active_gem_clkdm",
+	.pwrdm		= { .name = "active_pwrdm" },
+	.cm_inst	= TI816X_CM_ACTIVE_MOD,
+	.clkdm_offs	= TI816X_CM_ACTIVE_GEM_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain ivahd0_ti816x_clkdm = {
+	.name		= "ivahd0_clkdm",
+	.pwrdm		= { .name = "ivahd0_pwrdm" },
+	.cm_inst	= TI816X_CM_IVAHD0_MOD,
+	.clkdm_offs	= TI816X_CM_IVAHD0_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain ivahd1_ti816x_clkdm = {
+	.name		= "ivahd1_clkdm",
+	.pwrdm		= { .name = "ivahd1_pwrdm" },
+	.cm_inst	= TI816X_CM_IVAHD1_MOD,
+	.clkdm_offs	= TI816X_CM_IVAHD1_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain ivahd2_ti816x_clkdm = {
+	.name		= "ivahd2_clkdm",
+	.pwrdm		= { .name = "ivahd2_pwrdm" },
+	.cm_inst	= TI816X_CM_IVAHD2_MOD,
+	.clkdm_offs	= TI816X_CM_IVAHD2_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain sgx_ti816x_clkdm = {
+	.name		= "sgx_clkdm",
+	.pwrdm		= { .name = "sgx_pwrdm" },
+	.cm_inst	= TI816X_CM_SGX_MOD,
+	.clkdm_offs	= TI816X_CM_SGX_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_l3_med_ti816x_clkdm = {
+	.name		= "default_l3_med_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= TI816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= TI816X_CM_DEFAULT_L3_MED_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_ducati_ti816x_clkdm = {
+	.name		= "default_ducati_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= TI816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= TI816X_CM_DEFAULT_DUCATI_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_pcie_ti816x_clkdm = {
+	.name		= "default_pcie_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= TI816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= TI816X_CM_DEFAULT_PCI_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain default_usb_ti816x_clkdm = {
+	.name		= "default_usb_clkdm",
+	.pwrdm		= { .name = "default_pwrdm" },
+	.cm_inst	= TI816X_CM_DEFAULT_MOD,
+	.clkdm_offs	= TI816X_CM_DEFAULT_L3_SLOW_CLKDM,
+	.clktrctrl_mask	= TI81XX_CLKTRCTRL_MASK,
+	.flags		= CLKDM_CAN_HWSUP_SWSUP,
+};
+
+static struct clockdomain *clockdomains_ti81xx[] __initdata = {
+	&alwon_mpu_ti816x_clkdm,
+	&alwon_l3_slow_ti81xx_clkdm,
+	&alwon_l3_med_ti81xx_clkdm,
+	&alwon_l3_fast_ti81xx_clkdm,
+	&alwon_ethernet_ti81xx_clkdm,
+	&mmu_ti81xx_clkdm,
+	&mmu_cfg_ti81xx_clkdm,
+	&active_gem_ti816x_clkdm,
+	&ivahd0_ti816x_clkdm,
+	&ivahd1_ti816x_clkdm,
+	&ivahd2_ti816x_clkdm,
+	&sgx_ti816x_clkdm,
+	&default_l3_med_ti816x_clkdm,
+	&default_ducati_ti816x_clkdm,
+	&default_pcie_ti816x_clkdm,
+	&default_usb_ti816x_clkdm,
+	NULL,
+};
+
+void __init ti81xx_clockdomains_init(void)
+{
+	clkdm_register_platform_funcs(&omap3_clkdm_operations);
+	clkdm_register_clkdms(clockdomains_ti81xx);
+	clkdm_complete_init();
+}
+#endif
diff --git a/arch/arm/mach-omap2/cm-regbits-ti81xx.h b/arch/arm/mach-omap2/cm-regbits-ti81xx.h
new file mode 100644
index 0000000..b2f7b19
--- /dev/null
+++ b/arch/arm/mach-omap2/cm-regbits-ti81xx.h
@@ -0,0 +1,22 @@
+/*
+ * Clock Domain register bits for TI81xx.
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
+#ifndef __ARCH_ARM_MACH_OMAP2_CM_REGBITS_TI81XX_H
+#define __ARCH_ARM_MACH_OMAP2_CM_REGBITS_TI81XX_H
+
+#define TI81XX_CLKTRCTRL_MASK				(3 << 0)
+
+#endif
diff --git a/arch/arm/mach-omap2/cm_ti81xx.h b/arch/arm/mach-omap2/cm_ti81xx.h
new file mode 100644
index 0000000..9abd0f9
--- /dev/null
+++ b/arch/arm/mach-omap2/cm_ti81xx.h
@@ -0,0 +1,61 @@
+/*
+ * Clock domain register offsets for TI81XX.
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
+#ifndef __ARCH_ARM_MACH_OMAP2_CM_TI81XX_H
+#define __ARCH_ARM_MACH_OMAP2_CM_TI81XX_H
+
+/* TI81XX common CM module offsets */
+#define TI81XX_CM_ALWON_MOD				0x1400	/* 1KB */
+
+/* TI816X CM module offsets */
+#define TI816X_CM_ACTIVE_MOD			0x0400	/* 256B */
+#define TI816X_CM_DEFAULT_MOD			0x0500	/* 256B */
+#define TI816X_CM_IVAHD0_MOD			0x0600	/* 256B */
+#define TI816X_CM_IVAHD1_MOD			0x0700	/* 256B */
+#define TI816X_CM_IVAHD2_MOD			0x0800	/* 256B */
+#define TI816X_CM_SGX_MOD				0x0900	/* 256B */
+
+/* ALWON */
+#define TI81XX_CM_ALWON_MPU_CLKDM		0x001C
+#define TI81XX_CM_ALWON_L3_SLOW_CLKDM	0x0000
+#define TI81XX_CM_ALWON_L3_MED_CLKDM	0x0004
+#define TI81XX_CM_ALWON_L3_FAST_CLKDM	0x0030
+#define TI81XX_CM_ETHERNET_CLKDM		0x0004
+#define TI81XX_CM_MMU_CLKDM				0x000C
+#define TI81XX_CM_MMUCFG_CLKDM			0x0010
+
+/* ACTIVE */
+#define TI816X_CM_ACTIVE_GEM_CLKDM		0x0000
+
+/* IVAHD0 */
+#define TI816X_CM_IVAHD0_CLKDM			0x0000
+
+/* IVAHD1 */
+#define TI816X_CM_IVAHD1_CLKDM			0x0000
+
+/* IVAHD2 */
+#define TI816X_CM_IVAHD2_CLKDM			0x0000
+
+/* SGX */
+#define TI816X_CM_SGX_CLKDM				0x0000
+
+/* DEFAULT */
+#define TI816X_CM_DEFAULT_L3_MED_CLKDM	0x0004
+#define TI816X_CM_DEFAULT_DUCATI_CLKDM	0x0018
+#define TI816X_CM_DEFAULT_PCI_CLKDM		0x0010
+#define TI816X_CM_DEFAULT_L3_SLOW_CLKDM	0x0014
+
+#endif
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 4a3f06f..83d95a9 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -517,7 +517,7 @@ void __init ti81xx_init_early(void)
 	ti81xx_check_features();
 	omap3xxx_voltagedomains_init();
 	omap3xxx_powerdomains_init();
-	omap3xxx_clockdomains_init();
+	ti81xx_clockdomains_init();
 	omap3xxx_hwmod_init();
 	omap_hwmod_init_postsetup();
 	omap_clk_init = omap3xxx_clk_init;
-- 
1.8.1.2

