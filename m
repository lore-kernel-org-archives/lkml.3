Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbbATIW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:22:56 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55808 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbATIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:22:55 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 08/12] pm: at91: rename file name: pm_slowclock.S -->pm_suspend.S
Date: Tue, 20 Jan 2015 16:17:01 +0800
Message-ID: <1421741825-18226-9-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the sram function is used for the suspend to standby mode as well,
more than suspend to memory, so renaming is more elegant.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Makefile       |    2 +-
 arch/arm/mach-at91/pm_slowclock.S |  280 -------------------------------------
 arch/arm/mach-at91/pm_suspend.S   |  280 +++++++++++++++++++++++++++++++++++++
 3 files changed, 281 insertions(+), 281 deletions(-)
 delete mode 100644 arch/arm/mach-at91/pm_slowclock.S
 create mode 100644 arch/arm/mach-at91/pm_suspend.S

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 9c755d9..80473d8 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SOC_SAMA5)		+= board-dt-sama5.o
 
 # Power Management
 obj-$(CONFIG_PM)		+= pm.o
-obj-$(CONFIG_PM)		+= pm_slowclock.o
+obj-$(CONFIG_PM)		+= pm_suspend.o
 
 ifeq ($(CONFIG_PM_DEBUG),y)
 CFLAGS_pm.o += -DDEBUG
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
deleted file mode 100644
index 92d7e63..0000000
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ /dev/null
@@ -1,280 +0,0 @@
-/*
- * arch/arm/mach-at91/pm_slow_clock.S
- *
- *  Copyright (C) 2006 Savin Zlobec
- *
- * AT91SAM9 support:
- *  Copyright (C) 2007 Anti Sullin <anti.sullin@artecdesign.ee
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-#include <linux/linkage.h>
-#include <linux/clk/at91_pmc.h>
-#include <mach/at91_ramc.h>
-
-#include "pm.h"
-
-pmc	.req	r0
-sdramc	.req	r1
-ramc1	.req	r2
-memctrl	.req	r3
-tmp1	.req	r4
-tmp2	.req	r5
-mode	.req	r6
-
-/*
- * Wait until master clock is ready (after switching master clock source)
- */
-	.macro wait_mckrdy
-1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
-	tst	tmp1, #AT91_PMC_MCKRDY
-	beq	1b
-	.endm
-
-/*
- * Wait until master oscillator has stabilized.
- */
-	.macro wait_moscrdy
-1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
-	tst	tmp1, #AT91_PMC_MOSCS
-	beq	1b
-	.endm
-
-/*
- * Wait until PLLA has locked.
- */
-	.macro wait_pllalock
-1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
-	tst	tmp1, #AT91_PMC_LOCKA
-	beq	1b
-	.endm
-
-	.text
-
-/* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc,
- *			void __iomem *ramc1, int memctrl)
- */
-ENTRY(at91_slow_clock)
-	/* Save registers on stack */
-	stmfd	sp!, {r4 - r12, lr}
-
-	/*
-	 * Register usage:
-	 *  R0 = Base address of AT91_PMC
-	 *  R1 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
-	 *  R2 = Base address of second RAM Controller or 0 if not present
-	 *  R3 = Memory controller
-	 *  R4 = temporary register
-	 *  R5 = temporary register
-	 */
-
-	/* Drain write buffer */
-	mov	tmp1, #0
-	mcr	p15, 0, tmp1, c7, c10, 4
-
-	mov	tmp1, memctrl
-	mov	tmp2, tmp1, lsr#AT91_PM_MODE_OFFSET
-	and	mode, tmp2, #AT91_PM_MODE_MASK
-
-	mov	tmp1, memctrl
-	and	memctrl, tmp1, #AT91_PM_MEMCTRL_MASK
-
-	cmp	memctrl, #AT91_MEMCTRL_MC
-	bne	ddr_sr_enable
-
-	/*
-	 * at91rm9200 Memory controller
-	 */
-	/* Put SDRAM in self-refresh mode */
-	mov	tmp1, #1
-	str	tmp1, [sdramc, #AT91RM9200_SDRAMC_SRR]
-	b	sdr_sr_done
-
-	/*
-	 * DDRSDR Memory controller
-	 */
-ddr_sr_enable:
-	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
-	bne	sdr_sr_enable
-
-	/* LPDDR1 --> force DDR2 mode during self-refresh */
-	ldr	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
-	str	tmp1, .saved_sam9_mdr
-	bic	tmp1, tmp1, #~AT91_DDRSDRC_MD
-	cmp	tmp1, #AT91_DDRSDRC_MD_LOW_POWER_DDR
-	ldreq	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
-	biceq	tmp1, tmp1, #AT91_DDRSDRC_MD
-	orreq	tmp1, tmp1, #AT91_DDRSDRC_MD_DDR2
-	streq	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
-
-	/* prepare for DDRAM self-refresh mode */
-	ldr	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
-	str	tmp1, .saved_sam9_lpr
-	bic	tmp1, #AT91_DDRSDRC_LPCB
-	orr	tmp1, #AT91_DDRSDRC_LPCB_SELF_REFRESH
-
-	/* figure out if we use the second ram controller */
-	cmp	ramc1, #0
-	beq	ddr_no_2nd_ctrl
-
-	ldr	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
-	str	tmp2, .saved_sam9_mdr1
-	bic	tmp2, tmp2, #~AT91_DDRSDRC_MD
-	cmp	tmp2, #AT91_DDRSDRC_MD_LOW_POWER_DDR
-	ldreq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
-	biceq	tmp2, tmp2, #AT91_DDRSDRC_MD
-	orreq	tmp2, tmp2, #AT91_DDRSDRC_MD_DDR2
-	streq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
-
-	ldr	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
-	str	tmp2, .saved_sam9_lpr1
-	bic	tmp2, #AT91_DDRSDRC_LPCB
-	orr	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
-
-	/* Enable DDRAM self-refresh mode */
-	str	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
-ddr_no_2nd_ctrl:
-	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
-
-	b	sdr_sr_done
-
-	/*
-	 * SDRAMC Memory controller
-	 */
-sdr_sr_enable:
-	/* Enable SDRAM self-refresh mode */
-	ldr	tmp1, [sdramc, #AT91_SDRAMC_LPR]
-	str	tmp1, .saved_sam9_lpr
-
-	bic	tmp1, #AT91_SDRAMC_LPCB
-	orr	tmp1, #AT91_SDRAMC_LPCB_SELF_REFRESH
-	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
-
-sdr_sr_done:
-	tst	mode, #AT91_PM_SLOW_CLOCK
-	beq	skip_disable_clock
-
-	/* Save Master clock setting */
-	ldr	tmp1, [pmc, #AT91_PMC_MCKR]
-	str	tmp1, .saved_mckr
-
-	/*
-	 * Set the Master clock source to slow clock
-	 */
-	bic	tmp1, tmp1, #AT91_PMC_CSS
-	str	tmp1, [pmc, #AT91_PMC_MCKR]
-
-	wait_mckrdy
-
-	/* Save PLLA setting and disable it */
-	ldr	tmp1, [pmc, #AT91_CKGR_PLLAR]
-	str	tmp1, .saved_pllar
-
-	mov	tmp1, #AT91_PMC_PLLCOUNT
-	orr	tmp1, tmp1, #(1 << 29)		/* bit 29 always set */
-	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
-
-	/* Turn off the main oscillator */
-	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
-	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
-	str	tmp1, [pmc, #AT91_CKGR_MOR]
-
-skip_disable_clock:
-	/* Wait for interrupt */
-	mcr	p15, 0, tmp1, c7, c0, 4
-
-	tst	mode, #AT91_PM_SLOW_CLOCK
-	beq	skip_enable_clock
-
-	/* Turn on the main oscillator */
-	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
-	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
-	str	tmp1, [pmc, #AT91_CKGR_MOR]
-
-	wait_moscrdy
-
-	/* Restore PLLA setting */
-	ldr	tmp1, .saved_pllar
-	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
-
-	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
-	bne	3f
-	tst	tmp1, #(AT91_PMC_MUL & ~0xff0000)
-	beq	4f
-3:
-	wait_pllalock
-4:
-
-	/*
-	 * Restore master clock setting
-	 */
-2:	ldr	tmp1, .saved_mckr
-	str	tmp1, [pmc, #AT91_PMC_MCKR]
-
-	wait_mckrdy
-
-skip_enable_clock:
-	/*
-	 * at91rm9200 Memory controller
-	 * Do nothing - self-refresh is automatically disabled.
-	 */
-	cmp	memctrl, #AT91_MEMCTRL_MC
-	beq	ram_restored
-
-	/*
-	 * DDRSDR Memory controller
-	 */
-	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
-	bne	sdr_en_restore
-	/* Restore MDR in case of LPDDR1 */
-	ldr	tmp1, .saved_sam9_mdr
-	str	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
-	/* Restore LPR on AT91 with DDRAM */
-	ldr	tmp1, .saved_sam9_lpr
-	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
-
-	/* if we use the second ram controller */
-	cmp	ramc1, #0
-	ldrne	tmp2, .saved_sam9_mdr1
-	strne	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
-	ldrne	tmp2, .saved_sam9_lpr1
-	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
-
-	b	ram_restored
-
-	/*
-	 * SDRAMC Memory controller
-	 */
-sdr_en_restore:
-	/* Restore LPR on AT91 with SDRAM */
-	ldr	tmp1, .saved_sam9_lpr
-	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
-
-ram_restored:
-	/* Restore registers, and return */
-	ldmfd	sp!, {r4 - r12, pc}
-
-
-.saved_mckr:
-	.word 0
-
-.saved_pllar:
-	.word 0
-
-.saved_sam9_lpr:
-	.word 0
-
-.saved_sam9_lpr1:
-	.word 0
-
-.saved_sam9_mdr:
-	.word 0
-
-.saved_sam9_mdr1:
-	.word 0
-
-ENTRY(at91_slow_clock_sz)
-	.word .-at91_slow_clock
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
new file mode 100644
index 0000000..420e730
--- /dev/null
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -0,0 +1,280 @@
+/*
+ * arch/arm/mach-at91/pm_suspend.S
+ *
+ *  Copyright (C) 2006 Savin Zlobec
+ *
+ * AT91SAM9 support:
+ *  Copyright (C) 2007 Anti Sullin <anti.sullin@artecdesign.ee
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/linkage.h>
+#include <linux/clk/at91_pmc.h>
+#include <mach/at91_ramc.h>
+
+#include "pm.h"
+
+pmc	.req	r0
+sdramc	.req	r1
+ramc1	.req	r2
+memctrl	.req	r3
+tmp1	.req	r4
+tmp2	.req	r5
+mode	.req	r6
+
+/*
+ * Wait until master clock is ready (after switching master clock source)
+ */
+	.macro wait_mckrdy
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
+	tst	tmp1, #AT91_PMC_MCKRDY
+	beq	1b
+	.endm
+
+/*
+ * Wait until master oscillator has stabilized.
+ */
+	.macro wait_moscrdy
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
+	tst	tmp1, #AT91_PMC_MOSCS
+	beq	1b
+	.endm
+
+/*
+ * Wait until PLLA has locked.
+ */
+	.macro wait_pllalock
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
+	tst	tmp1, #AT91_PMC_LOCKA
+	beq	1b
+	.endm
+
+	.text
+
+/* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc,
+ *			void __iomem *ramc1, int memctrl)
+ */
+ENTRY(at91_slow_clock)
+	/* Save registers on stack */
+	stmfd	sp!, {r4 - r12, lr}
+
+	/*
+	 * Register usage:
+	 *  R0 = Base address of AT91_PMC
+	 *  R1 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
+	 *  R2 = Base address of second RAM Controller or 0 if not present
+	 *  R3 = Memory controller
+	 *  R4 = temporary register
+	 *  R5 = temporary register
+	 */
+
+	/* Drain write buffer */
+	mov	tmp1, #0
+	mcr	p15, 0, tmp1, c7, c10, 4
+
+	mov	tmp1, memctrl
+	mov	tmp2, tmp1, lsr#AT91_PM_MODE_OFFSET
+	and	mode, tmp2, #AT91_PM_MODE_MASK
+
+	mov	tmp1, memctrl
+	and	memctrl, tmp1, #AT91_PM_MEMCTRL_MASK
+
+	cmp	memctrl, #AT91_MEMCTRL_MC
+	bne	ddr_sr_enable
+
+	/*
+	 * at91rm9200 Memory controller
+	 */
+	/* Put SDRAM in self-refresh mode */
+	mov	tmp1, #1
+	str	tmp1, [sdramc, #AT91RM9200_SDRAMC_SRR]
+	b	sdr_sr_done
+
+	/*
+	 * DDRSDR Memory controller
+	 */
+ddr_sr_enable:
+	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
+	bne	sdr_sr_enable
+
+	/* LPDDR1 --> force DDR2 mode during self-refresh */
+	ldr	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
+	str	tmp1, .saved_sam9_mdr
+	bic	tmp1, tmp1, #~AT91_DDRSDRC_MD
+	cmp	tmp1, #AT91_DDRSDRC_MD_LOW_POWER_DDR
+	ldreq	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
+	biceq	tmp1, tmp1, #AT91_DDRSDRC_MD
+	orreq	tmp1, tmp1, #AT91_DDRSDRC_MD_DDR2
+	streq	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
+
+	/* prepare for DDRAM self-refresh mode */
+	ldr	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
+	str	tmp1, .saved_sam9_lpr
+	bic	tmp1, #AT91_DDRSDRC_LPCB
+	orr	tmp1, #AT91_DDRSDRC_LPCB_SELF_REFRESH
+
+	/* figure out if we use the second ram controller */
+	cmp	ramc1, #0
+	beq	ddr_no_2nd_ctrl
+
+	ldr	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
+	str	tmp2, .saved_sam9_mdr1
+	bic	tmp2, tmp2, #~AT91_DDRSDRC_MD
+	cmp	tmp2, #AT91_DDRSDRC_MD_LOW_POWER_DDR
+	ldreq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
+	biceq	tmp2, tmp2, #AT91_DDRSDRC_MD
+	orreq	tmp2, tmp2, #AT91_DDRSDRC_MD_DDR2
+	streq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
+
+	ldr	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
+	str	tmp2, .saved_sam9_lpr1
+	bic	tmp2, #AT91_DDRSDRC_LPCB
+	orr	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
+
+	/* Enable DDRAM self-refresh mode */
+	str	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
+ddr_no_2nd_ctrl:
+	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
+
+	b	sdr_sr_done
+
+	/*
+	 * SDRAMC Memory controller
+	 */
+sdr_sr_enable:
+	/* Enable SDRAM self-refresh mode */
+	ldr	tmp1, [sdramc, #AT91_SDRAMC_LPR]
+	str	tmp1, .saved_sam9_lpr
+
+	bic	tmp1, #AT91_SDRAMC_LPCB
+	orr	tmp1, #AT91_SDRAMC_LPCB_SELF_REFRESH
+	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
+
+sdr_sr_done:
+	tst	mode, #AT91_PM_SLOW_CLOCK
+	beq	skip_disable_clock
+
+	/* Save Master clock setting */
+	ldr	tmp1, [pmc, #AT91_PMC_MCKR]
+	str	tmp1, .saved_mckr
+
+	/*
+	 * Set the Master clock source to slow clock
+	 */
+	bic	tmp1, tmp1, #AT91_PMC_CSS
+	str	tmp1, [pmc, #AT91_PMC_MCKR]
+
+	wait_mckrdy
+
+	/* Save PLLA setting and disable it */
+	ldr	tmp1, [pmc, #AT91_CKGR_PLLAR]
+	str	tmp1, .saved_pllar
+
+	mov	tmp1, #AT91_PMC_PLLCOUNT
+	orr	tmp1, tmp1, #(1 << 29)		/* bit 29 always set */
+	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
+
+	/* Turn off the main oscillator */
+	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
+	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
+	str	tmp1, [pmc, #AT91_CKGR_MOR]
+
+skip_disable_clock:
+	/* Wait for interrupt */
+	mcr	p15, 0, tmp1, c7, c0, 4
+
+	tst	mode, #AT91_PM_SLOW_CLOCK
+	beq	skip_enable_clock
+
+	/* Turn on the main oscillator */
+	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
+	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
+	str	tmp1, [pmc, #AT91_CKGR_MOR]
+
+	wait_moscrdy
+
+	/* Restore PLLA setting */
+	ldr	tmp1, .saved_pllar
+	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
+
+	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
+	bne	3f
+	tst	tmp1, #(AT91_PMC_MUL & ~0xff0000)
+	beq	4f
+3:
+	wait_pllalock
+4:
+
+	/*
+	 * Restore master clock setting
+	 */
+2:	ldr	tmp1, .saved_mckr
+	str	tmp1, [pmc, #AT91_PMC_MCKR]
+
+	wait_mckrdy
+
+skip_enable_clock:
+	/*
+	 * at91rm9200 Memory controller
+	 * Do nothing - self-refresh is automatically disabled.
+	 */
+	cmp	memctrl, #AT91_MEMCTRL_MC
+	beq	ram_restored
+
+	/*
+	 * DDRSDR Memory controller
+	 */
+	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
+	bne	sdr_en_restore
+	/* Restore MDR in case of LPDDR1 */
+	ldr	tmp1, .saved_sam9_mdr
+	str	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
+	/* Restore LPR on AT91 with DDRAM */
+	ldr	tmp1, .saved_sam9_lpr
+	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
+
+	/* if we use the second ram controller */
+	cmp	ramc1, #0
+	ldrne	tmp2, .saved_sam9_mdr1
+	strne	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
+	ldrne	tmp2, .saved_sam9_lpr1
+	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
+
+	b	ram_restored
+
+	/*
+	 * SDRAMC Memory controller
+	 */
+sdr_en_restore:
+	/* Restore LPR on AT91 with SDRAM */
+	ldr	tmp1, .saved_sam9_lpr
+	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
+
+ram_restored:
+	/* Restore registers, and return */
+	ldmfd	sp!, {r4 - r12, pc}
+
+
+.saved_mckr:
+	.word 0
+
+.saved_pllar:
+	.word 0
+
+.saved_sam9_lpr:
+	.word 0
+
+.saved_sam9_lpr1:
+	.word 0
+
+.saved_sam9_mdr:
+	.word 0
+
+.saved_sam9_mdr1:
+	.word 0
+
+ENTRY(at91_slow_clock_sz)
+	.word .-at91_slow_clock
-- 
1.7.9.5

