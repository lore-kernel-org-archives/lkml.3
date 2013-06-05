Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3FEPaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:30:46 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:45605 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab3FEP31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:29:27 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: OMAP: DM816x: add powerdomains for DM816x
Date: Wed,  5 Jun 2013 19:29:14 +0400
Message-Id: <1370446156-11788-4-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
References: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds required structures for powerdomain initialization on
the DM816x. It is impossible to use OMAP3430 structures in order to
initialize powerdomains on DM816x, because there are big differences
between PRCM module base address offsets on these CPUs.

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/Makefile                     |    3 +
 arch/arm/mach-omap2/io.c                         |    2 +-
 arch/arm/mach-omap2/powerdomain.h                |    4 +
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c |   43 ++++++++
 arch/arm/mach-omap2/powerdomains3xxx_data.c      |   43 --------
 arch/arm/mach-omap2/powerdomains_dm81xx_data.c   |  115 ++++++++++++++++++++++
 arch/arm/mach-omap2/prm-regbits-dm81xx.h         |   24 +++++
 arch/arm/mach-omap2/prm_dm81xx.c                 |   79 +++++++++++++++
 arch/arm/mach-omap2/prm_dm81xx.h                 |   44 +++++++++
 9 files changed, 313 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm/mach-omap2/powerdomains_dm81xx_data.c
 create mode 100644 arch/arm/mach-omap2/prm-regbits-dm81xx.h
 create mode 100644 arch/arm/mach-omap2/prm_dm81xx.c
 create mode 100644 arch/arm/mach-omap2/prm_dm81xx.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 607a2bf..03121cc 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_SOC_AM33XX)		+= prm_am33xx.o cm_am33xx.o
 omap-prcm-4-5-common			=  cminst44xx.o cm44xx.o prm44xx.o \
 					   prcm_mpu44xx.o prminst44xx.o \
 					   vc44xx_data.o vp44xx_data.o
+obj-$(CONFIG_SOC_DM81XX)		+= prm_dm81xx.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(omap-prcm-4-5-common)
 obj-$(CONFIG_SOC_OMAP5)			+= $(omap-prcm-4-5-common)
 
@@ -140,6 +141,8 @@ obj-$(CONFIG_ARCH_OMAP4)		+= $(powerdomain-common)
 obj-$(CONFIG_ARCH_OMAP4)		+= powerdomains44xx_data.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(powerdomain-common)
 obj-$(CONFIG_SOC_AM33XX)		+= powerdomains_am33xx_data.o
+obj-$(CONFIG_SOC_DM81XX)		+= $(powerdomain-common)
+obj-$(CONFIG_SOC_DM81XX)		+= powerdomains_dm81xx_data.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(powerdomain-common)
 
 # PRCM clockdomain control
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 3deba6e..2a9e5b3 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -516,7 +516,7 @@ void __init dm81xx_init_early(void)
 	omap3xxx_check_revision();
 	dm81xx_check_features();
 	omap3xxx_voltagedomains_init();
-	omap3xxx_powerdomains_init();
+	dm81xx_powerdomains_init();
 	omap3xxx_clockdomains_init();
 	omap3xxx_hwmod_init();
 	omap_hwmod_init_postsetup();
diff --git a/arch/arm/mach-omap2/powerdomain.h b/arch/arm/mach-omap2/powerdomain.h
index 140c360..6d78990 100644
--- a/arch/arm/mach-omap2/powerdomain.h
+++ b/arch/arm/mach-omap2/powerdomain.h
@@ -252,11 +252,13 @@ extern void omap242x_powerdomains_init(void);
 extern void omap243x_powerdomains_init(void);
 extern void omap3xxx_powerdomains_init(void);
 extern void am33xx_powerdomains_init(void);
+extern void dm81xx_powerdomains_init(void);
 extern void omap44xx_powerdomains_init(void);
 
 extern struct pwrdm_ops omap2_pwrdm_operations;
 extern struct pwrdm_ops omap3_pwrdm_operations;
 extern struct pwrdm_ops am33xx_pwrdm_operations;
+extern struct pwrdm_ops dm81xx_pwrdm_operations;
 extern struct pwrdm_ops omap4_pwrdm_operations;
 
 /* Common Internal functions used across OMAP rev's */
@@ -266,6 +268,8 @@ extern u32 omap2_pwrdm_get_mem_bank_stst_mask(u8 bank);
 
 extern struct powerdomain wkup_omap2_pwrdm;
 extern struct powerdomain gfx_omap2_pwrdm;
+extern struct powerdomain mpu_3xxx_pwrdm;
+extern struct powerdomain core_3xxx_pre_es3_1_pwrdm;
 
 extern void pwrdm_lock(struct powerdomain *pwrdm);
 extern void pwrdm_unlock(struct powerdomain *pwrdm);
diff --git a/arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c b/arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c
index 7b946f1..2c2b630 100644
--- a/arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c
+++ b/arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c
@@ -63,3 +63,46 @@ struct powerdomain wkup_omap2_pwrdm = {
 	.pwrsts		= PWRSTS_ON,
 	.voltdm		= { .name = "wakeup" },
 };
+
+struct powerdomain mpu_3xxx_pwrdm = {
+	.name		  = "mpu_pwrdm",
+	.prcm_offs	  = MPU_MOD,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.flags		  = PWRDM_HAS_MPU_QUIRK,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRSTS_OFF_RET,
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRSTS_OFF_ON,
+	},
+	.voltdm		  = { .name = "mpu_iva" },
+};
+
+/*
+ * The USBTLL Save-and-Restore mechanism is broken on
+ * 3430s up to ES3.0 and 3630ES1.0. Hence this feature
+ * needs to be disabled on these chips.
+ * Refer: 3430 errata ID i459 and 3630 errata ID i579
+ *
+ * Note: setting the SAR flag could help for errata ID i478
+ *  which applies to 3430 <= ES3.1, but since the SAR feature
+ *  is broken, do not use it.
+ */
+struct powerdomain core_3xxx_pre_es3_1_pwrdm = {
+	.name		  = "core_pwrdm",
+	.prcm_offs	  = CORE_MOD,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.banks		  = 2,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRSTS_OFF_RET,	 /* MEM1RETSTATE */
+		[1] = PWRSTS_OFF_RET,	 /* MEM2RETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRSTS_OFF_RET_ON, /* MEM1ONSTATE */
+		[1] = PWRSTS_OFF_RET_ON, /* MEM2ONSTATE */
+	},
+	.voltdm		  = { .name = "core" },
+};
diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
index f0e14e9..6c3261b 100644
--- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
+++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
@@ -53,22 +53,6 @@ static struct powerdomain iva2_pwrdm = {
 	.voltdm		  = { .name = "mpu_iva" },
 };
 
-static struct powerdomain mpu_3xxx_pwrdm = {
-	.name		  = "mpu_pwrdm",
-	.prcm_offs	  = MPU_MOD,
-	.pwrsts		  = PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret = PWRSTS_OFF_RET,
-	.flags		  = PWRDM_HAS_MPU_QUIRK,
-	.banks		  = 1,
-	.pwrsts_mem_ret	  = {
-		[0] = PWRSTS_OFF_RET,
-	},
-	.pwrsts_mem_on	  = {
-		[0] = PWRSTS_OFF_ON,
-	},
-	.voltdm		  = { .name = "mpu_iva" },
-};
-
 static struct powerdomain mpu_am35x_pwrdm = {
 	.name		  = "mpu_pwrdm",
 	.prcm_offs	  = MPU_MOD,
@@ -85,33 +69,6 @@ static struct powerdomain mpu_am35x_pwrdm = {
 	.voltdm		  = { .name = "mpu_iva" },
 };
 
-/*
- * The USBTLL Save-and-Restore mechanism is broken on
- * 3430s up to ES3.0 and 3630ES1.0. Hence this feature
- * needs to be disabled on these chips.
- * Refer: 3430 errata ID i459 and 3630 errata ID i579
- *
- * Note: setting the SAR flag could help for errata ID i478
- *  which applies to 3430 <= ES3.1, but since the SAR feature
- *  is broken, do not use it.
- */
-static struct powerdomain core_3xxx_pre_es3_1_pwrdm = {
-	.name		  = "core_pwrdm",
-	.prcm_offs	  = CORE_MOD,
-	.pwrsts		  = PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret = PWRSTS_OFF_RET,
-	.banks		  = 2,
-	.pwrsts_mem_ret	  = {
-		[0] = PWRSTS_OFF_RET,	 /* MEM1RETSTATE */
-		[1] = PWRSTS_OFF_RET,	 /* MEM2RETSTATE */
-	},
-	.pwrsts_mem_on	  = {
-		[0] = PWRSTS_OFF_RET_ON, /* MEM1ONSTATE */
-		[1] = PWRSTS_OFF_RET_ON, /* MEM2ONSTATE */
-	},
-	.voltdm		  = { .name = "core" },
-};
-
 static struct powerdomain core_3xxx_es3_1_pwrdm = {
 	.name		  = "core_pwrdm",
 	.prcm_offs	  = CORE_MOD,
diff --git a/arch/arm/mach-omap2/powerdomains_dm81xx_data.c b/arch/arm/mach-omap2/powerdomains_dm81xx_data.c
new file mode 100644
index 0000000..878ca7d
--- /dev/null
+++ b/arch/arm/mach-omap2/powerdomains_dm81xx_data.c
@@ -0,0 +1,115 @@
+/*
+ * DM816X Power Domain data.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc. - http://www.ti.com/
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
+#ifndef __ARCH_ARM_MACH_OMAP2_POWERDOMAINS_DM81XX_H
+#define __ARCH_ARM_MACH_OMAP2_POWERDOMAINS_DM81XX_H
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include "powerdomain.h"
+
+#include "prcm-common.h"
+#include "prcm44xx.h"
+#include "prm-regbits-44xx.h"
+#include "prm44xx.h"
+#include "prcm_mpu44xx.h"
+#include "prm_dm81xx.h"
+
+
+#ifdef CONFIG_SOC_DM81XX
+
+/*
+ * DM81XX common
+ */
+
+static struct powerdomain alwon_dm81xx_pwrdm = {
+	.name		  = "alwon_pwrdm",
+	.prcm_offs	  = DM81XX_PRM_ALWON_MOD,
+	.voltdm           = { .name = "core" },
+};
+
+/*
+ * DM816X only
+ */
+
+static struct powerdomain active_dm816x_pwrdm = {
+	.name		  = "active_pwrdm",
+	.prcm_offs	  = DM816X_PRM_ACTIVE_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm           = { .name = "core" },
+};
+
+static struct powerdomain default_dm816x_pwrdm = {
+	.name		  = "default_pwrdm",
+	.prcm_offs	  = DM81XX_PRM_DEFAULT_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm           = { .name = "core" },
+};
+
+static struct powerdomain ivahd0_dm816x_pwrdm = {
+	.name		  = "ivahd0_pwrdm",
+	.prcm_offs	  = DM816X_PRM_IVAHD0_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm           = { .name = "mpu_iva" },
+};
+
+static struct powerdomain ivahd1_dm816x_pwrdm = {
+	.name		  = "ivahd1_pwrdm",
+	.prcm_offs	  = DM816X_PRM_IVAHD1_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm           = { .name = "mpu_iva" },
+};
+
+static struct powerdomain ivahd2_dm816x_pwrdm = {
+	.name		  = "ivahd2_pwrdm",
+	.prcm_offs	  = DM816X_PRM_IVAHD2_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm           = { .name = "mpu_iva" },
+};
+
+static struct powerdomain sgx_dm816x_pwrdm = {
+	.name		  = "sgx_pwrdm",
+	.prcm_offs	  = DM816X_PRM_SGX_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm           = { .name = "core" },
+};
+
+static struct powerdomain *powerdomains_dm81xx[] __initdata = {
+	&wkup_omap2_pwrdm,
+	&mpu_3xxx_pwrdm,
+	&core_3xxx_pre_es3_1_pwrdm,
+
+	&alwon_dm81xx_pwrdm,
+	&active_dm816x_pwrdm,
+	&default_dm816x_pwrdm,
+	&ivahd0_dm816x_pwrdm,
+	&ivahd1_dm816x_pwrdm,
+	&ivahd2_dm816x_pwrdm,
+	&sgx_dm816x_pwrdm,
+	NULL
+};
+
+void __init dm81xx_powerdomains_init(void)
+{
+	pwrdm_register_platform_funcs(&dm81xx_pwrdm_operations);
+	pwrdm_register_pwrdms(powerdomains_dm81xx);
+	pwrdm_complete_init();
+}
+
+
+#endif /* CONFIG_SOC_DM81XX */
+
+#endif
diff --git a/arch/arm/mach-omap2/prm-regbits-dm81xx.h b/arch/arm/mach-omap2/prm-regbits-dm81xx.h
new file mode 100644
index 0000000..adcf6cb
--- /dev/null
+++ b/arch/arm/mach-omap2/prm-regbits-dm81xx.h
@@ -0,0 +1,24 @@
+/*
+ * DM81XX PRM_XXX register bits
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
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
+#ifndef __ARCH_ARM_MACH_OMAP2_PRM_REGBITS_DM81XX_H
+#define __ARCH_ARM_MACH_OMAP2_PRM_REGBITS_DM81XX_H
+
+#include "prm.h"
+
+#define DM81XX_PM_PWSTCTRL              0x0000
+#define DM81XX_PM_PWSTST                0x0004
+
+#endif
diff --git a/arch/arm/mach-omap2/prm_dm81xx.c b/arch/arm/mach-omap2/prm_dm81xx.c
new file mode 100644
index 0000000..70185f3
--- /dev/null
+++ b/arch/arm/mach-omap2/prm_dm81xx.c
@@ -0,0 +1,79 @@
+/*
+ * DM81XX powerdomain control
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+
+#include "powerdomain.h"
+#include "prm_dm81xx.h"
+#include "prm-regbits-dm81xx.h"
+#include "prm-regbits-34xx.h"
+
+int dm81xx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst)
+{
+	omap2_prm_rmw_mod_reg_bits(OMAP_POWERSTATE_MASK,
+				(pwrst << OMAP_POWERSTATE_SHIFT),
+				pwrdm->prcm_offs, DM81XX_PM_PWSTCTRL);
+	return 0;
+}
+
+int dm81xx_pwrdm_read_next_pwrst(struct powerdomain *pwrdm)
+{
+	return omap2_prm_read_mod_bits_shift(pwrdm->prcm_offs,
+					DM81XX_PM_PWSTCTRL,
+					OMAP_POWERSTATE_MASK);
+}
+
+int dm81xx_pwrdm_read_pwrst(struct powerdomain *pwrdm)
+{
+	return omap2_prm_read_mod_bits_shift(pwrdm->prcm_offs,
+					DM81XX_PM_PWSTST,
+					OMAP_POWERSTATEST_MASK);
+}
+
+int dm81xx_pwrdm_read_logic_pwrst(struct powerdomain *pwrdm)
+{
+	/* Hack to fix GFX pwstst and rstctrl reg offsets to be removed */
+	return omap2_prm_read_mod_bits_shift(pwrdm->prcm_offs,
+					DM81XX_PM_PWSTST,
+					OMAP3430_LOGICSTATEST_MASK);
+}
+
+int dm81xx_pwrdm_wait_transition(struct powerdomain *pwrdm)
+{
+	u32 c = 0;
+
+	/*
+	 * REVISIT: pwrdm_wait_transition() may be better implemented
+	 * via a callback and a periodic timer check -- how long do we expect
+	 * powerdomain transitions to take?
+	 */
+
+	/* XXX Is this udelay() value meaningful? */
+	/* Hack to fix GFX pwstst and rstctrl reg offsets to be removed */
+	while ((omap2_prm_read_mod_reg(pwrdm->prcm_offs,
+						DM81XX_PM_PWSTST) &
+			OMAP_INTRANSITION_MASK) &&
+		(c++ < PWRDM_TRANSITION_BAILOUT))
+		udelay(1);
+
+	if (c > PWRDM_TRANSITION_BAILOUT) {
+		printk(KERN_ERR "powerdomain: waited too long for "
+			"powerdomain %s to complete transition\n", pwrdm->name);
+		return -EAGAIN;
+	}
+
+	pr_debug("powerdomain: completed transition in %d loops\n", c);
+
+	return 0;
+}
+
+struct pwrdm_ops dm81xx_pwrdm_operations = {
+	.pwrdm_set_next_pwrst	= dm81xx_pwrdm_set_next_pwrst,
+	.pwrdm_read_next_pwrst	= dm81xx_pwrdm_read_next_pwrst,
+	.pwrdm_read_pwrst	= dm81xx_pwrdm_read_pwrst,
+	.pwrdm_read_logic_pwrst	= dm81xx_pwrdm_read_logic_pwrst,
+	.pwrdm_wait_transition	= dm81xx_pwrdm_wait_transition,
+};
diff --git a/arch/arm/mach-omap2/prm_dm81xx.h b/arch/arm/mach-omap2/prm_dm81xx.h
new file mode 100644
index 0000000..4a43ce5
--- /dev/null
+++ b/arch/arm/mach-omap2/prm_dm81xx.h
@@ -0,0 +1,44 @@
+/*
+ * DM33XX PRM instance offset macros
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
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
+#ifndef __ARCH_ARM_MACH_OMAP2_PRM_DM81XX_H
+#define __ARCH_ARM_MACH_OMAP2_PRM_DM81XX_H
+
+#include "prcm-common.h"
+#include "prm.h"
+
+/* DM81XX common PRM module offsets */
+
+#define DM81XX_PRM_DEVICE_MOD			0x0000
+#define DM81XX_PRM_ALWON_MOD			0x1800
+#define DM81XX_PRM_DEFAULT_MOD			0x0b00
+
+/* DM816X PRM module offsets */
+
+#define DM816X_PRM_OCP_SOCKET_MOD		0x0200
+#define DM816X_PRM_ACTIVE_MOD			0x0a00
+#define DM816X_PRM_IVAHD0_MOD			0x0c00
+#define DM816X_PRM_IVAHD1_MOD			0x0d00
+#define DM816X_PRM_IVAHD2_MOD			0x0e00
+#define DM816X_PRM_SGX_MOD				0x0f00
+
+#ifndef __ASSEMBLER__
+int dm81xx_pwrdm_set_next_pwrst(struct powerdomain *pwrdm, u8 pwrst);
+int dm81xx_pwrdm_read_next_pwrst(struct powerdomain *pwrdm);
+int dm81xx_pwrdm_read_pwrst(struct powerdomain *pwrdm);
+int dm81xx_pwrdm_read_logic_pwrst(struct powerdomain *pwrdm);
+int dm81xx_pwrdm_wait_transition(struct powerdomain *pwrdm);
+#endif /* ASSEMBLER */
+#endif
-- 
1.7.10.4

