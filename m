Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaJWEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:16:28 -0400
Received: from mail-by2on0145.outbound.protection.outlook.com ([207.46.100.145]:21504
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbaJWEQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:16:27 -0400
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH v2 2/2] arm: pm: add deep sleep support for LS1
Date: Thu, 23 Oct 2014 12:16:13 +0800
Message-ID: <1414037773-7735-2-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1414037773-7735-1-git-send-email-chenhui.zhao@freescale.com>
References: <1414037773-7735-1-git-send-email-chenhui.zhao@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(62966002)(47776003)(89996001)(105606002)(6806004)(44976005)(19580405001)(106466001)(107046002)(120916001)(20776003)(87286001)(76482002)(64706001)(84676001)(85852003)(50466002)(95666004)(50226001)(99396003)(87936001)(88136002)(48376002)(93916002)(76176999)(85306004)(50986999)(102836001)(26826002)(92726001)(2201001)(86362001)(92566001)(46102003)(31966008)(21056001)(229853001)(80022003)(104166001)(36756003)(68736004)(4396001)(19580395003)(33646002)(97736003)(77156001)(104016003)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0734;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0734;
X-Forefront-PRVS: 0373D94D15
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=chenhui.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LS1 supports deep sleep feature that can switch off most parts of
the SoC when it is in deep sleep state.

The DDR controller will also be powered off in deep sleep. Therefore,
copy the last stage code to enter deep sleep to SRAM and run it
with disabling MMU and caches.

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
Changes for v2:
 * use identity mapping to smooth the process of disabling MMU
 * change the value of registers

 arch/arm/mach-imx/Kconfig     |    1 +
 arch/arm/mach-imx/Makefile    |    1 +
 arch/arm/mach-imx/pm-ls1.c    |  341 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-imx/sleep-ls1.S |  132 ++++++++++++++++
 4 files changed, 475 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-imx/pm-ls1.c
 create mode 100644 arch/arm/mach-imx/sleep-ls1.S

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index b85534c..716bb1b 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -866,6 +866,7 @@ config SOC_LS1021A
 	select HAVE_SMP
 	select ARCH_LAYERSCAPE
 	select ZONE_DMA if ARM_LPAE
+	select FSL_SLEEP_FSM if PM
 
 	help
 	  This enable support for Freescale Layerscape LS1021A  processor.
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index 41b8044..9931528 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_SOC_IMX6SL) += clk-imx6sl.o mach-imx6sl.o
 
 ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o headsmp.o
+obj-$(CONFIG_SOC_LS1021A) += pm-ls1.o sleep-ls1.o
 endif
 
 # i.MX5 based machines
diff --git a/arch/arm/mach-imx/pm-ls1.c b/arch/arm/mach-imx/pm-ls1.c
new file mode 100644
index 0000000..8fd7aee
--- /dev/null
+++ b/arch/arm/mach-imx/pm-ls1.c
@@ -0,0 +1,341 @@
+/*
+ * Support deep sleep feature for LS1
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * This program is free software; you can redistribute	it and/or modify it
+ * under  the terms of	the GNU General	 Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/suspend.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/cpu_pm.h>
+#include <asm/suspend.h>
+#include <asm/delay.h>
+#include <asm/cp15.h>
+#include <asm/cacheflush.h>
+#include <asm/idmap.h>
+
+#include "common.h"
+
+#define FSL_SLEEP		0x1
+#define FSL_DEEP_SLEEP		0x2
+
+#define DCSR_EPU_EPSMCR15	0x278
+#define DCSR_EPU_EPECR0		0x300
+#define DCSR_RCPM_CG1CR0	0x31c
+#define DCSR_RCPM_CSTTACR0	0xb00
+
+#define CCSR_SCFG_DPSLPCR	0
+#define CCSR_SCFG_DPSLPCR_VAL	0x1
+#define CCSR_SCFG_SPARECR2	0x504
+#define CCSR_SCFG_SPARECR3	0x508
+
+#define CCSR_DCFG_CRSTSR	0x400
+#define CCSR_DCFG_CRSTSR_VAL	0x00000008
+
+#define CCSR_RCPM_POWMGTCSR		0x130
+#define CCSR_RCPM_POWMGTCSR_LPM20_REQ	0x00100000
+#define CCSR_RCPM_POWMGTCSR_LPM20_ST	0x00000200
+#define CCSR_RCPM_POWMGTCSR_P_LPM20_ST	0x00000100
+#define CCSR_RCPM_CLPCL10SETR		0x1c4
+#define CCSR_RCPM_CLPCL10SETR_C0	0x1
+
+#define OCRAM_BASE	0x10000000
+#define OCRAM_SIZE	0x10000		/* 64K */
+/* use the last page of SRAM */
+#define SRAM_CODE_BASE_PHY	(OCRAM_BASE + OCRAM_SIZE - PAGE_SIZE)
+
+struct ls1_pm_baseaddr {
+	void __iomem *epu;
+	void __iomem *dcsr_rcpm1;
+	void __iomem *dcsr_rcpm2;
+	void __iomem *rcpm;
+	void __iomem *scfg;
+	void __iomem *dcfg;
+	void __iomem *fpga;
+	void __iomem *sram;
+};
+
+/* 128 bytes buffer for restoring data broke by DDR training initialization */
+#define DDR_BUF_SIZE	128
+static u8 ddr_buff[DDR_BUF_SIZE] __aligned(64);
+static struct ls1_pm_baseaddr ls1_pm_base;
+/* supported sleep modes by the present platform */
+static unsigned int sleep_modes;
+
+extern void ls1_do_deepsleep(unsigned long addr);
+extern void ls1_start_fsm(void);
+extern void ls1_deepsleep_resume(void);
+extern void ls1021a_set_secondary_entry(void);
+extern int ls1_sram_code_size;
+extern void fsl_epu_setup_default(void __iomem *epu_base);
+
+static void ls1_pm_iomap(void)
+{
+	struct device_node *np;
+	void *base;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-dcsr-epu");
+	base = of_iomap(np, 0);
+	BUG_ON(!base);
+	ls1_pm_base.epu = base;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-dcsr-rcpm");
+	base = of_iomap(np, 0);
+	BUG_ON(!base);
+	ls1_pm_base.dcsr_rcpm1 = base;
+	base = of_iomap(np, 1);
+	BUG_ON(!base);
+	ls1_pm_base.dcsr_rcpm2 = base;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-scfg");
+	base = of_iomap(np, 0);
+	BUG_ON(!base);
+	ls1_pm_base.scfg = base;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-dcfg");
+	base = of_iomap(np, 0);
+	BUG_ON(!base);
+	ls1_pm_base.dcfg = base;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021aqds-fpga");
+	base = of_iomap(np, 0);
+	BUG_ON(!base);
+	ls1_pm_base.fpga = base;
+
+	base = ioremap(SRAM_CODE_BASE_PHY, PAGE_SIZE);
+	BUG_ON(!base);
+	ls1_pm_base.sram = base;
+}
+
+static void ls1_pm_uniomap(void)
+{
+	iounmap(ls1_pm_base.epu);
+	iounmap(ls1_pm_base.dcsr_rcpm1);
+	iounmap(ls1_pm_base.dcsr_rcpm2);
+	iounmap(ls1_pm_base.scfg);
+	iounmap(ls1_pm_base.dcfg);
+	iounmap(ls1_pm_base.fpga);
+	iounmap(ls1_pm_base.sram);
+}
+
+static void ls1_save_ddr(void *base)
+{
+	u32 ddr_buff_addr;
+
+	/*
+	 * DDR training initialization will break 128 bytes at the beginning
+	 * of DDR, therefore, save them so that the bootloader will restore
+	 * them. Assume that DDR is mapped to the address space started with
+	 * CONFIG_PAGE_OFFSET.
+	 */
+	memcpy(ddr_buff, (void *)CONFIG_PAGE_OFFSET, DDR_BUF_SIZE);
+
+	ddr_buff_addr = (u32)__pa(ddr_buff);
+
+	/*
+	 * the bootloader will restore the first 128 bytes of DDR from
+	 * the location indicated by the register SPARECR3
+	 */
+	iowrite32(ddr_buff_addr, base + CCSR_SCFG_SPARECR3);
+}
+
+static void ls1_set_resume_entry(void *base)
+{
+	u32 resume_addr;
+
+	/* the bootloader will finally jump to this address to resume kernel */
+	resume_addr = (u32)(__pa(ls1_deepsleep_resume));
+
+	/* use the register SPARECR2 to save the return entry */
+	iowrite32(resume_addr, base + CCSR_SCFG_SPARECR2);
+}
+
+static void ls1_copy_sram_code(void)
+{
+	memcpy(ls1_pm_base.sram, ls1_start_fsm, ls1_sram_code_size);
+}
+
+static int ls1_start_deepsleep(unsigned long addr)
+{
+	typedef void (*ls1_deepsleep_t)(unsigned long);
+	ls1_deepsleep_t ls1_do_deepsleep_phy;
+
+	/* Switch to the identity mapping */
+	setup_mm_for_reboot();
+	v7_exit_coherency_flush(all);
+
+	ls1_do_deepsleep_phy =
+		(ls1_deepsleep_t)(unsigned long)virt_to_phys(ls1_do_deepsleep);
+	ls1_do_deepsleep_phy(addr);
+
+	/* never get here  */
+	BUG();
+
+	return 0;
+}
+
+void ls1_fsm_setup(void)
+{
+	iowrite32be(0x00001001, ls1_pm_base.dcsr_rcpm1 + DCSR_RCPM_CSTTACR0);
+	iowrite32be(0x00000001, ls1_pm_base.dcsr_rcpm1 + DCSR_RCPM_CG1CR0);
+
+	fsl_epu_setup_default(ls1_pm_base.epu);
+
+	/*
+	 * pull the MCKE signal(EVT4_B pin) low before enabling
+	 * deep sleep signals by FPGA
+	 */
+	iowrite32be(0x5, ls1_pm_base.epu + DCSR_EPU_EPECR0);
+
+	iowrite32be(0x76300000, ls1_pm_base.epu + DCSR_EPU_EPSMCR15);
+}
+
+static inline void ls1_clrsetbits_be32(void __iomem *addr, u32 clear, u32 set)
+{
+	u32 tmp;
+
+	tmp = ioread32be(addr);
+	tmp = (tmp & ~clear) | set;
+	iowrite32be(tmp, addr);
+}
+
+static void ls1_enter_deepsleep(void)
+{
+	u32 tmp;
+
+	/* save DDR data */
+	ls1_save_ddr(ls1_pm_base.scfg);
+
+	/* save kernel resume entry */
+	ls1_set_resume_entry(ls1_pm_base.scfg);
+
+	/* Request to put cluster 0 in PCL10 state */
+	ls1_clrsetbits_be32(ls1_pm_base.rcpm + CCSR_RCPM_CLPCL10SETR,
+			    CCSR_RCPM_CLPCL10SETR_C0,
+			    CCSR_RCPM_CLPCL10SETR_C0);
+
+	/* setup the registers of the EPU FSM for deep sleep */
+	ls1_fsm_setup();
+
+	/* enable deep sleep signals in FPGA */
+	tmp = ioread8(ls1_pm_base.fpga + QIXIS_PWR_CTL2);
+	iowrite8(tmp | QIXIS_PWR_CTL2_PCTL, ls1_pm_base.fpga + QIXIS_PWR_CTL2);
+
+	/* enable Warm Device Reset */
+	ls1_clrsetbits_be32(ls1_pm_base.scfg + CCSR_SCFG_DPSLPCR,
+			    CCSR_SCFG_DPSLPCR_VAL, CCSR_SCFG_DPSLPCR_VAL);
+
+	ls1_clrsetbits_be32(ls1_pm_base.dcfg + CCSR_DCFG_CRSTSR,
+			    CCSR_DCFG_CRSTSR_VAL, CCSR_DCFG_CRSTSR_VAL);
+
+	/* copy the last stage code to sram */
+	ls1_copy_sram_code();
+
+	cpu_suspend(SRAM_CODE_BASE_PHY, ls1_start_deepsleep);
+
+	/* disable Warm Device Reset */
+	ls1_clrsetbits_be32(ls1_pm_base.scfg + CCSR_SCFG_DPSLPCR,
+			    CCSR_SCFG_DPSLPCR_VAL, 0);
+
+	/* disable deep sleep signals in FPGA */
+	tmp = ioread8(ls1_pm_base.fpga + QIXIS_PWR_CTL2);
+	iowrite8(tmp & ~QIXIS_PWR_CTL2_PCTL, ls1_pm_base.fpga + QIXIS_PWR_CTL2);
+
+	/* call smp_prepare_cpus */
+	ls1021a_set_secondary_entry();
+}
+
+static int ls1_suspend_enter(suspend_state_t state)
+{
+	int ret = 0;
+
+	switch (state) {
+	case PM_SUSPEND_STANDBY:
+		flush_cache_louis();
+		ls1_clrsetbits_be32(ls1_pm_base.rcpm + CCSR_RCPM_POWMGTCSR,
+				    CCSR_RCPM_POWMGTCSR_LPM20_REQ,
+				    CCSR_RCPM_POWMGTCSR_LPM20_REQ);
+
+		cpu_do_idle();
+		break;
+
+	case PM_SUSPEND_MEM:
+		ls1_enter_deepsleep();
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int ls1_suspend_valid(suspend_state_t state)
+{
+	if (state == PM_SUSPEND_STANDBY && (sleep_modes & FSL_SLEEP))
+		return 1;
+
+	if (state == PM_SUSPEND_MEM && (sleep_modes & FSL_DEEP_SLEEP))
+		return 1;
+
+	return 0;
+}
+
+static int ls1_suspend_begin(suspend_state_t state)
+{
+	ls1_pm_iomap();
+
+	return 0;
+}
+
+static void ls1_suspend_end(void)
+{
+	ls1_pm_uniomap();
+}
+
+static const struct platform_suspend_ops ls1_suspend_ops = {
+	.valid = ls1_suspend_valid,
+	.enter = ls1_suspend_enter,
+	.begin = ls1_suspend_begin,
+	.end = ls1_suspend_end,
+};
+
+
+static const struct of_device_id rcpm_matches[] = {
+	{
+		.compatible = "fsl,ls1021a-rcpm",
+		.data = (void *)(FSL_SLEEP | FSL_DEEP_SLEEP),
+	},
+	{}
+};
+
+static int __init ls1_pm_init(void)
+{
+	const struct of_device_id *match;
+	struct device_node *np;
+	void *base;
+
+	np = of_find_matching_node_and_match(NULL, rcpm_matches, &match);
+	if (!np) {
+		pr_err("%s: can't find the rcpm node.\n", __func__);
+		return -EINVAL;
+	}
+
+	base = of_iomap(np, 0);
+	of_node_put(np);
+	if (!base)
+		return -ENOMEM;
+
+	sleep_modes = (unsigned int)match->data;
+	ls1_pm_base.rcpm = base;
+	suspend_set_ops(&ls1_suspend_ops);
+	return 0;
+}
+arch_initcall(ls1_pm_init);
diff --git a/arch/arm/mach-imx/sleep-ls1.S b/arch/arm/mach-imx/sleep-ls1.S
new file mode 100644
index 0000000..deccfa8
--- /dev/null
+++ b/arch/arm/mach-imx/sleep-ls1.S
@@ -0,0 +1,132 @@
+/*
+ * Support deep sleep feature for LS1
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * This program is free software; you can redistribute	it and/or modify it
+ * under  the terms of	the GNU General	 Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/cache.h>
+#include <asm/cp15.h>
+
+#define CCSR_DDR_BASE			0x01080000
+#define CCSR_DDR_SDRAM_CFG_2		0x114
+
+#define CCSR_SCFG_BASE			0x01570000
+#define CCSR_SCFG_HRSTCR		0x1a8
+
+#define DCSR_EPU_BASE			0x20000000
+#define DCSR_EPU_EPGCR			0x0
+#define DCSR_EPU_EPECR0			0x300
+#define DCSR_EPU_EPECR15		0x33c
+
+/* for big endian registers */
+.macro ls1_set_bits, addr, value
+	ldr	r4, \addr
+	ldr	r5, [r4]
+	ldr	r6, \value
+	rev	r6, r6
+	orr	r5, r5, r6
+	str	r5, [r4]
+.endm
+
+/* 1000 loops per round */
+.macro ls1_delay, count
+	mov	r0, \count
+11:	mov	r7, #1000
+12:	subs	r7, r7, #1
+	bne	12b
+	subs	r0, r0, #1
+	bne	11b
+.endm
+
+/*
+ * r0: the physical entry address of SRAM code
+ *
+ */
+	.align L1_CACHE_SHIFT
+	.pushsection	.idmap.text,"ax"
+ENTRY(ls1_do_deepsleep)
+	/* disable MMU, M bit in SCTLR */
+	mrc	p15, 0, r3, c1, c0, 0
+	bic	r3, r3, #CR_M
+	mcr	p15, 0, r3, c1, c0, 0
+	isb
+
+	/* jump to sram code using physical address */
+	bx	r0
+ENDPROC(ls1_do_deepsleep)
+	.popsection
+
+/*
+ * The code will be copied to SRAM.
+ */
+	.align L1_CACHE_SHIFT
+ENTRY(ls1_start_fsm)
+	/* set HRSTCR */
+	ls1_set_bits	ls1_ccsr_scfg_hrstcr_addr, ls1_ccsr_scfg_hrstcr_val
+
+	/* Place DDR controller in self refresh mode */
+	ls1_set_bits	ls1_ddr_cfg2_addr, ls1_ddr_cfg2_val
+
+	ls1_delay	#2000
+
+	/* Set EVT4_B to lock the signal MCKE down */
+	ldr	r4, ls1_dcsr_epu_epecr0
+	ldr	r5, ls1_dcsr_epu_epecr0_val
+	rev	r5, r5
+	str	r5, [r4]
+
+	ls1_delay	#2000
+
+	/* Enable all EPU Counters */
+	ls1_set_bits	ls1_dcsr_epu_epgcr_addr, ls1_dcsr_epu_epgcr_val
+
+	/* Enable SCU15 */
+	ls1_set_bits	ls1_dcsr_epu_epecr15, ls1_dcsr_epu_epecr15_val
+
+	/* Enter WFI mode, and EPU FSM will start */
+20:	wfi
+	b	20b
+
+ls1_ccsr_scfg_hrstcr_addr:
+	.word	CCSR_SCFG_BASE + CCSR_SCFG_HRSTCR
+ls1_ccsr_scfg_hrstcr_val:
+	.word	0x80000000
+
+ls1_ddr_cfg2_addr:
+	.word	CCSR_DDR_BASE + CCSR_DDR_SDRAM_CFG_2
+ls1_ddr_cfg2_val:
+	.word	(1 << 31)
+
+ls1_dcsr_epu_epgcr_addr:
+	.word	DCSR_EPU_BASE + DCSR_EPU_EPGCR
+ls1_dcsr_epu_epgcr_val:
+	.word	0x80000000
+
+ls1_dcsr_epu_epecr0:
+	.word	DCSR_EPU_BASE + DCSR_EPU_EPECR0
+ls1_dcsr_epu_epecr0_val:
+	.word	0
+
+ls1_dcsr_epu_epecr15:
+	.word	DCSR_EPU_BASE + DCSR_EPU_EPECR15
+ls1_dcsr_epu_epecr15_val:
+	.word	0x90000004
+
+ENTRY(ls1_sram_code_size)
+	.word	. - ls1_start_fsm
+
+/* the bootloader will jump to here after wakeup from deep sleep  */
+	.align L1_CACHE_SHIFT
+ENTRY(ls1_deepsleep_resume)
+ THUMB(	adr	r6, BSYM(1f)	)
+ THUMB(	bx	r6		)
+ THUMB(	.thumb			)
+ THUMB(1:			)
+	b cpu_resume
-- 
1.7.3

