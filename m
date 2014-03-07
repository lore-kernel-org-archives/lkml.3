Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaCGE6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:58:50 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:38316
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbaCGE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:58:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Date: Fri, 7 Mar 2014 12:58:05 +0800
Message-ID: <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Chenhui <chenhui.zhao@freescale.com>

T1040 supports deep sleep feature, which can switch off most parts of
the SoC when it is in deep sleep mode. This way, it becomes more
energy-efficient.

The DDR controller will also be powered off in deep sleep. Therefore,
the last stage (the latter part of fsl_dp_enter_low) will run without DDR
access. This piece of code and related TLBs will be prefetched.

Due to the different initialization code between 32-bit and 64-bit, they
have seperate resume entry and precedure.

The feature supports 32-bit and 64-bit kernel mode.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/include/asm/booke_save_regs.h |    3 +
 arch/powerpc/kernel/cpu_setup_fsl_booke.S  |   17 ++
 arch/powerpc/kernel/head_fsl_booke.S       |   30 +++
 arch/powerpc/platforms/85xx/Makefile       |    2 +-
 arch/powerpc/platforms/85xx/deepsleep.c    |  201 +++++++++++++++++++
 arch/powerpc/platforms/85xx/qoriq_pm.c     |   38 ++++
 arch/powerpc/platforms/85xx/sleep.S        |  295 ++++++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_soc.h              |    7 +
 8 files changed, 592 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/platforms/85xx/deepsleep.c
 create mode 100644 arch/powerpc/platforms/85xx/sleep.S

diff --git a/arch/powerpc/include/asm/booke_save_regs.h b/arch/powerpc/include/asm/booke_save_regs.h
index 87c357a..37c1f6c 100644
--- a/arch/powerpc/include/asm/booke_save_regs.h
+++ b/arch/powerpc/include/asm/booke_save_regs.h
@@ -88,6 +88,9 @@
 #define HIBERNATION_FLAG	1
 #define DEEPSLEEP_FLAG		2
 
+#define CPLD_FLAG	1
+#define FPGA_FLAG	2
+
 #ifndef __ASSEMBLY__
 extern void booke_cpu_state_save(void *buf, int type);
 extern void *booke_cpu_state_restore(void *buf, int type);
diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
index e59d6de..ea9bc28 100644
--- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
+++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
@@ -318,6 +318,23 @@ flush_backside_L2_cache:
 2:
 	blr
 
+#define CPC_CPCCSR0		0x0
+#define CPC_CPCCSR0_CPCFL	0x800
+
+/* r3 : the base address of CPC  */
+_GLOBAL(fsl_flush_cpc_cache)
+	lwz	r6, CPC_CPCCSR0(r3)
+	ori	r6, r6, CPC_CPCCSR0_CPCFL
+	stw	r6, CPC_CPCCSR0(r3)
+	sync
+
+	/* Wait until completing the flush */
+1:	lwz	r6, CPC_CPCCSR0(r3)
+	andi.	r6, r6, CPC_CPCCSR0_CPCFL
+	bne	1b
+
+	blr
+
 _GLOBAL(__flush_caches_e500v2)
 	mflr r0
 	bl	flush_dcache_L1
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 20204fe..3285752 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -162,6 +162,19 @@ _ENTRY(__early_start)
 #include "fsl_booke_entry_mapping.S"
 #undef ENTRY_MAPPING_BOOT_SETUP
 
+#if defined(CONFIG_SUSPEND) && defined(CONFIG_FSL_CORENET_RCPM)
+	/* if deep_sleep_flag != 0, jump to the deep sleep resume entry */
+	LOAD_REG_ADDR(r4, deep_sleep_flag)
+	lwz	r3, 0(r4)
+	cmpwi	r3, 0
+	beq	11f
+	/* clear deep_sleep_flag */
+	li	r3, 0
+	stw	r3, 0(r4)
+	b	fsl_deepsleep_resume
+11:
+#endif
+
 set_ivor:
 	/* Establish the interrupt vector offsets */
 	SET_IVOR(0,  CriticalInput);
@@ -343,6 +356,23 @@ set_ivor:
 	lwz	r11, 0(r12);		/* Get Linux PTE */
 #endif
 
+#if defined(CONFIG_SUSPEND) && defined(CONFIG_FSL_CORENET_RCPM)
+_ENTRY(__entry_deep_sleep)
+/*
+ * Bootloader will jump to here when resuming from deep sleep.
+ * After executing the init code in fsl_booke_entry_mapping.S,
+ * will jump to the real resume entry.
+ */
+	li	r8, 1
+	bl	12f
+12:	mflr	r9
+	addi	r9, r9, (deep_sleep_flag - 12b)
+	stw	r8, 0(r9)
+	b __early_start
+deep_sleep_flag:
+	.long	0
+#endif
+
 /*
  * Interrupt vector entry code
  *
diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
index 7fae817..9a4ea86 100644
--- a/arch/powerpc/platforms/85xx/Makefile
+++ b/arch/powerpc/platforms/85xx/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_SMP) += smp.o
 ifeq ($(CONFIG_FSL_CORENET_RCPM), y)
-obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o
+obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o deepsleep.o sleep.o
 endif
 
 obj-y += common.o
diff --git a/arch/powerpc/platforms/85xx/deepsleep.c b/arch/powerpc/platforms/85xx/deepsleep.c
new file mode 100644
index 0000000..ddd7185
--- /dev/null
+++ b/arch/powerpc/platforms/85xx/deepsleep.c
@@ -0,0 +1,201 @@
+/*
+ * Support deep sleep feature
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * Author: Chenhui Zhao <chenhui.zhao@freescale.com>
+ *
+ * This program is free software; you can redistribute	it and/or modify it
+ * under  the terms of	the GNU General	 Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <asm/machdep.h>
+#include <sysdev/fsl_soc.h>
+#include <asm/booke_save_regs.h>
+
+#define SIZE_1MB	0x100000
+#define SIZE_2MB	0x200000
+
+#define CCSR_SCFG_DPSLPCR	0xfc000
+#define CCSR_SCFG_DPSLPCR_WDRR_EN	0x1
+#define CCSR_SCFG_SPARECR2	0xfc504
+#define CCSR_SCFG_SPARECR3	0xfc508
+
+#define CCSR_GPIO1_GPDIR	0x130000
+#define CCSR_GPIO1_GPODR	0x130004
+#define CCSR_GPIO1_GPDAT	0x130008
+#define CCSR_GPIO1_GPDIR_29		0x4
+
+/* 128 bytes buffer for restoring data broke by DDR training initialization */
+#define DDR_BUF_SIZE	128
+static u8 ddr_buff[DDR_BUF_SIZE] __aligned(64);
+
+static void *dcsr_base, *ccsr_base, *pld_base;
+static int pld_flag;
+
+int fsl_dp_iomap(void)
+{
+	struct device_node *np;
+	const u32 *prop;
+	int ret = 0;
+	u64 ccsr_phy_addr, dcsr_phy_addr;
+
+	np = of_find_node_by_type(NULL, "soc");
+	if (!np) {
+		pr_err("%s: Can't find the node of \"soc\"\n", __func__);
+		ret = -EINVAL;
+		goto ccsr_err;
+	}
+	prop = of_get_property(np, "ranges", NULL);
+	if (!prop) {
+		pr_err("%s: Can't find the property of \"ranges\"\n", __func__);
+		of_node_put(np);
+		ret = -EINVAL;
+		goto ccsr_err;
+	}
+	ccsr_phy_addr = of_translate_address(np, prop + 1);
+	ccsr_base = ioremap((phys_addr_t)ccsr_phy_addr, SIZE_2MB);
+	of_node_put(np);
+	if (!ccsr_base) {
+		ret = -ENOMEM;
+		goto ccsr_err;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,dcsr");
+	if (!np) {
+		pr_err("%s: Can't find the node of \"fsl,dcsr\"\n", __func__);
+		ret = -EINVAL;
+		goto dcsr_err;
+	}
+	prop = of_get_property(np, "ranges", NULL);
+	if (!prop) {
+		pr_err("%s: Can't find the property of \"ranges\"\n", __func__);
+		of_node_put(np);
+		ret = -EINVAL;
+		goto dcsr_err;
+	}
+	dcsr_phy_addr = of_translate_address(np, prop + 1);
+	dcsr_base = ioremap((phys_addr_t)dcsr_phy_addr, SIZE_1MB);
+	of_node_put(np);
+	if (!dcsr_base) {
+		ret = -ENOMEM;
+		goto dcsr_err;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,fpga-qixis");
+	if (np) {
+		pld_flag = FPGA_FLAG;
+	} else {
+		np = of_find_compatible_node(NULL, NULL, "fsl,p104xrdb-cpld");
+		if (np) {
+			pld_flag = CPLD_FLAG;
+		} else {
+			pr_err("%s: Can't find the FPGA/CPLD node\n",
+					__func__);
+			ret = -EINVAL;
+			goto pld_err;
+		}
+	}
+	pld_base = of_iomap(np, 0);
+	of_node_put(np);
+
+	return 0;
+
+pld_err:
+	iounmap(dcsr_base);
+dcsr_err:
+	iounmap(ccsr_base);
+ccsr_err:
+	ccsr_base = NULL;
+	dcsr_base = NULL;
+	pld_base = NULL;
+	return ret;
+}
+
+void fsl_dp_iounmap(void)
+{
+	if (dcsr_base) {
+		iounmap(dcsr_base);
+		dcsr_base = NULL;
+	}
+
+	if (ccsr_base) {
+		iounmap(ccsr_base);
+		ccsr_base = NULL;
+	}
+
+	if (pld_base) {
+		iounmap(pld_base);
+		pld_base = NULL;
+	}
+}
+
+static void fsl_dp_ddr_save(void *ccsr_base)
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
+	/* assume ddr_buff is in the physical address space of 4GB */
+	ddr_buff_addr = (u32)(__pa(ddr_buff) & 0xffffffff);
+
+	/*
+	 * the bootloader will restore the first 128 bytes of DDR from
+	 * the location indicated by the register SPARECR3
+	 */
+	out_be32(ccsr_base + CCSR_SCFG_SPARECR3, ddr_buff_addr);
+}
+
+static void fsl_dp_set_resume_pointer(void *ccsr_base)
+{
+	u32 resume_addr;
+
+	/* the bootloader will finally jump to this address to return kernel */
+#ifdef CONFIG_PPC32
+	resume_addr = (u32)(__pa(__entry_deep_sleep));
+#else
+	resume_addr = (u32)(__pa(*(u64 *)__entry_deep_sleep) & 0xffffffff);
+#endif
+
+	/* use the register SPARECR2 to save the resume address */
+	out_be32(ccsr_base + CCSR_SCFG_SPARECR2, resume_addr);
+
+}
+
+int fsl_enter_epu_deepsleep(void)
+{
+
+	fsl_dp_ddr_save(ccsr_base);
+
+	fsl_dp_set_resume_pointer(ccsr_base);
+
+	/*  enable Warm Device Reset request. */
+	setbits32(ccsr_base + CCSR_SCFG_DPSLPCR, CCSR_SCFG_DPSLPCR_WDRR_EN);
+
+	/* set GPIO1_29 as an output pin (not open-drain), and output 0 */
+	clrbits32(ccsr_base + CCSR_GPIO1_GPDAT, CCSR_GPIO1_GPDIR_29);
+	clrbits32(ccsr_base + CCSR_GPIO1_GPODR, CCSR_GPIO1_GPDIR_29);
+	setbits32(ccsr_base + CCSR_GPIO1_GPDIR, CCSR_GPIO1_GPDIR_29);
+
+	fsl_dp_fsm_setup(dcsr_base);
+
+	fsl_dp_enter_low(ccsr_base, dcsr_base, pld_base, pld_flag);
+
+	/* disable Warm Device Reset request */
+	clrbits32(ccsr_base + CCSR_SCFG_DPSLPCR, CCSR_SCFG_DPSLPCR_WDRR_EN);
+
+	fsl_dp_fsm_clean(dcsr_base);
+
+	return 0;
+}
diff --git a/arch/powerpc/platforms/85xx/qoriq_pm.c b/arch/powerpc/platforms/85xx/qoriq_pm.c
index 915b13b..5f2c016 100644
--- a/arch/powerpc/platforms/85xx/qoriq_pm.c
+++ b/arch/powerpc/platforms/85xx/qoriq_pm.c
@@ -20,6 +20,8 @@
 #define FSL_SLEEP		0x1
 #define FSL_DEEP_SLEEP		0x2
 
+int (*fsl_enter_deepsleep)(void);
+
 /* specify the sleep state of the present platform */
 int sleep_pm_state;
 /* supported sleep modes by the present platform */
@@ -28,6 +30,7 @@ static unsigned int sleep_modes;
 static int qoriq_suspend_enter(suspend_state_t state)
 {
 	int ret = 0;
+	int cpu;
 
 	switch (state) {
 	case PM_SUSPEND_STANDBY:
@@ -39,6 +42,17 @@ static int qoriq_suspend_enter(suspend_state_t state)
 
 		break;
 
+	case PM_SUSPEND_MEM:
+
+		cpu = smp_processor_id();
+		qoriq_pm_ops->irq_mask(cpu);
+
+		ret = fsl_enter_deepsleep();
+
+		qoriq_pm_ops->irq_unmask(cpu);
+
+		break;
+
 	default:
 		ret = -EINVAL;
 
@@ -52,12 +66,30 @@ static int qoriq_suspend_valid(suspend_state_t state)
 	if (state == PM_SUSPEND_STANDBY && (sleep_modes & FSL_SLEEP))
 		return 1;
 
+	if (state == PM_SUSPEND_MEM && (sleep_modes & FSL_DEEP_SLEEP))
+		return 1;
+
 	return 0;
 }
 
+static int qoriq_suspend_begin(suspend_state_t state)
+{
+	if (state == PM_SUSPEND_MEM)
+		return fsl_dp_iomap();
+
+	return 0;
+}
+
+static void qoriq_suspend_end(void)
+{
+	fsl_dp_iounmap();
+}
+
 static const struct platform_suspend_ops qoriq_suspend_ops = {
 	.valid = qoriq_suspend_valid,
 	.enter = qoriq_suspend_enter,
+	.begin = qoriq_suspend_begin,
+	.end = qoriq_suspend_end,
 };
 
 static int __init qoriq_suspend_init(void)
@@ -71,6 +103,12 @@ static int __init qoriq_suspend_init(void)
 	if (np)
 		sleep_pm_state = PLAT_PM_LPM20;
 
+	np = of_find_compatible_node(NULL, NULL, "fsl,t1040-rcpm");
+	if (np) {
+		fsl_enter_deepsleep = fsl_enter_epu_deepsleep;
+		sleep_modes |= FSL_DEEP_SLEEP;
+	}
+
 	suspend_set_ops(&qoriq_suspend_ops);
 
 	return 0;
diff --git a/arch/powerpc/platforms/85xx/sleep.S b/arch/powerpc/platforms/85xx/sleep.S
new file mode 100644
index 0000000..95a5746
--- /dev/null
+++ b/arch/powerpc/platforms/85xx/sleep.S
@@ -0,0 +1,295 @@
+/*
+ * Implement the low level part of deep sleep
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * This program is free software; you can redistribute	it and/or modify it
+ * under  the terms of	the GNU General	 Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <asm/page.h>
+#include <asm/ppc_asm.h>
+#include <asm/reg.h>
+#include <asm/asm-offsets.h>
+#include <asm/booke_save_regs.h>
+#include <asm/mmu.h>
+
+#define FSLDELAY(count)		\
+	li	r3, (count)@l;	\
+	slwi	r3, r3, 10;	\
+	mtctr	r3;		\
+101:	nop;			\
+	bdnz	101b;
+
+#define FSL_DIS_ALL_IRQ		\
+	mfmsr	r8;			\
+	rlwinm	r8, r8, 0, ~MSR_CE;	\
+	rlwinm	r8, r8, 0, ~MSR_ME;	\
+	rlwinm	r8, r8, 0, ~MSR_EE;	\
+	rlwinm	r8, r8, 0, ~MSR_DE;	\
+	mtmsr	r8;			\
+	isync
+
+
+	.section .data
+	.align	6
+booke_regs_buffer:
+	.space REGS_BUFFER_SIZE
+
+	.section .txt
+	.align 6
+
+_GLOBAL(fsl_dp_enter_low)
+deepsleep_start:
+	LOAD_REG_ADDR(r9, buf_tmp)
+	PPC_STL	r3, 0(r9)
+	PPC_STL	r4, 8(r9)
+	PPC_STL	r5, 16(r9)
+	PPC_STL	r6, 24(r9)
+
+	LOAD_REG_ADDR(r3, booke_regs_buffer)
+	/* save the return address */
+	mflr	r5
+	PPC_STL r5, SR_LR(r3)
+	mfmsr	r5
+	PPC_STL r5, SR_MSR(r3)
+	li	r4, DEEPSLEEP_FLAG
+	bl	booke_cpu_state_save
+
+	LOAD_REG_ADDR(r9, buf_tmp)
+	PPC_LL	r31, 0(r9)
+	PPC_LL	r30, 8(r9)
+	PPC_LL	r29, 16(r9)
+	PPC_LL	r28, 24(r9)
+
+	/* flush caches */
+	LOAD_REG_ADDR(r3, cur_cpu_spec)
+	PPC_LL	r3, 0(r3)
+	PPC_LL	r3, CPU_FLUSH_CACHES(r3)
+	PPC_LCMPI  0, r3, 0
+	beq	6f
+#ifdef CONFIG_PPC64
+	PPC_LL	r3, 0(r3)
+#endif
+	mtctr	r3
+	bctrl
+6:
+#define CPC_OFFSET	0x10000
+	mr	r3, r31
+	addis	r3, r3, CPC_OFFSET@h
+	bl	fsl_flush_cpc_cache
+
+	LOAD_REG_ADDR(r8, deepsleep_start)
+	LOAD_REG_ADDR(r9, deepsleep_end)
+
+	/* prefecth TLB */
+#define CCSR_GPIO1_GPDAT	0x130008
+#define CCSR_GPIO1_GPDAT_29	0x4
+	LOAD_REG_IMMEDIATE(r11, CCSR_GPIO1_GPDAT)
+	add	r11, r31, r11
+	lwz	r10, 0(r11)
+
+#define CCSR_RCPM_PCPH15SETR	0xe20b4
+#define CCSR_RCPM_PCPH15SETR_CORE0	0x1
+	LOAD_REG_IMMEDIATE(r12, CCSR_RCPM_PCPH15SETR)
+	add	r12, r31, r12
+	lwz	r10, 0(r12)
+
+#define CCSR_DDR_SDRAM_CFG_2	0x8114
+#define CCSR_DDR_SDRAM_CFG_2_FRC_SR	0x80000000
+	LOAD_REG_IMMEDIATE(r13, CCSR_DDR_SDRAM_CFG_2)
+	add	r13, r31, r13
+	lwz	r10, 0(r13)
+
+#define	DCSR_EPU_EPGCR		0x000
+#define DCSR_EPU_EPGCR_GCE	0x80000000
+	li	r14, DCSR_EPU_EPGCR
+	add	r14, r30, r14
+	lwz	r10, 0(r14)
+
+#define	DCSR_EPU_EPECR15	0x33C
+#define DCSR_EPU_EPECR15_IC0	0x80000000
+	li	r15, DCSR_EPU_EPECR15
+	add	r15, r30, r15
+	lwz	r10, 0(r15)
+
+#define CCSR_SCFG_QMCRDTRSTCR		0xfc40c
+#define CCSR_SCFG_QMCRDTRSTCR_CRDTRST	0x80000000
+	LOAD_REG_IMMEDIATE(r16, CCSR_SCFG_QMCRDTRSTCR)
+	add	r16, r31, r16
+	lwz	r10, 0(r16)
+
+/*
+ * There are two kind of register maps, one for CPLD and the other for FPGA
+ */
+#define CPLD_MISCCSR		0x17
+#define CPLD_MISCCSR_SLEEPEN	0x40
+#define QIXIS_PWR_CTL2		0x21
+#define QIXIS_PWR_CTL2_PCTL	0x2
+	PPC_LCMPI  0, r28, FPGA_FLAG
+	beq	20f
+	addi	r29, r29, CPLD_MISCCSR
+20:
+	addi	r29, r29, QIXIS_PWR_CTL2
+	lbz	r10, 0(r29)
+
+	/* prefecth code to cache so that executing code after disable DDR */
+1:	lwz	r3, 0(r8)
+	addi	r8, r8, 4
+	cmpw	r8, r9
+	blt	1b
+	msync
+
+	FSL_DIS_ALL_IRQ
+
+	/*
+	 * Place DDR controller in self refresh mode.
+	 * From here on, DDR can't be access any more.
+	 */
+	lwz	r10, 0(r13)
+	oris	r10, r10, CCSR_DDR_SDRAM_CFG_2_FRC_SR@h
+	stw	r10, 0(r13)
+
+	/* can't call udelay() here, so use a macro to delay */
+	FSLDELAY(50)
+
+	/*
+	 * Enable deep sleep signals by write external CPLD/FPGA register.
+	 * The bootloader will disable them when wakeup from deep sleep.
+	 */
+	lbz	r10, 0(r29)
+	PPC_LCMPI  0, r28, FPGA_FLAG
+	beq	22f
+	ori	r10, r10, CPLD_MISCCSR_SLEEPEN
+22:
+	ori	r10, r10, QIXIS_PWR_CTL2_PCTL
+	stb	r10, 0(r29)
+
+	/*
+	 * Set GPIO1_29 to lock the signal MCKE down during deep sleep.
+	 * The bootloader will clear it when wakeup.
+	 */
+	lwz	r10, 0(r11)
+	ori	r10, r10, CCSR_GPIO1_GPDAT_29
+	stw	r10, 0(r11)
+
+	FSLDELAY(10)
+
+	/* Clear the QMan CITI Credits */
+	lwz	r10, 0(r16)
+	oris	r10, r10, CCSR_SCFG_QMCRDTRSTCR_CRDTRST@h
+	stw	r10, 0(r16)
+
+	/* Enable all EPU Counters */
+	li	r10, 0
+	oris	r10, r10, DCSR_EPU_EPGCR_GCE@h
+	stw	r10, 0(r14)
+
+	/* Enable SCU15 to trigger on RCPM Concentrator 0 */
+	lwz	r10, 0(r15)
+	oris	r10, r10, DCSR_EPU_EPECR15_IC0@h
+	stw	r10, 0(r15)
+
+	/* put Core0 in PH15 mode, trigger EPU FSM */
+	lwz	r10, 0(r12)
+	ori	r10, r10, CCSR_RCPM_PCPH15SETR_CORE0
+	stw	r10, 0(r12)
+
+2:
+	b 2b
+
+	/*
+	 * Leave some space to prevent prefeching instruction
+	 * beyond deepsleep_end. The space also can be used as heap.
+	 */
+buf_tmp:
+	.space 128
+	.align 6
+deepsleep_end:
+
+#ifdef CONFIG_PPC32
+_GLOBAL(fsl_deepsleep_resume)
+	/* disable interrupts */
+	FSL_DIS_ALL_IRQ
+
+	li	r3, 0
+	mfspr   r4, SPRN_PIR
+	bl	call_setup_cpu
+
+	/* Load each CAM entry */
+	LOAD_REG_ADDR(r3, tlbcam_index)
+	lwz	r3, 0(r3)
+	mtctr	r3
+	li	r0, 0
+3:	mr	r3, r0
+	bl	loadcam_entry
+	addi	r0, r0, 1
+	bdnz	3b
+
+	/* restore cpu registers */
+	LOAD_REG_ADDR(r3, booke_regs_buffer)
+	li	r4, DEEPSLEEP_FLAG
+	bl	booke_cpu_state_restore
+
+	LOAD_REG_ADDR(r3, booke_regs_buffer)
+	lwz	r4, SR_MSR(r3)
+	mtmsr	r4
+	lwz	r4, SR_LR(r3)
+	mtlr	r4
+
+	blr
+
+#else /* CONFIG_PPC32 */
+
+_GLOBAL(__entry_deep_sleep)
+	/* disable interrupts */
+	FSL_DIS_ALL_IRQ
+
+	/* switch to 64-bit mode */
+	bl	.enable_64b_mode
+
+	/* set TOC pointer */
+	bl	.relative_toc
+
+	/* setup initial TLBs, switch to kernel space ... */
+	bl	.start_initialization_book3e
+
+	/* address space changed, set TOC pointer again */
+	bl	.relative_toc
+
+	/* call a cpu state restore handler */
+	LOAD_REG_ADDR(r23, cur_cpu_spec)
+	ld	r23,0(r23)
+	ld	r23,CPU_SPEC_RESTORE(r23)
+	cmpdi	0,r23,0
+	beq	1f
+	ld	r23,0(r23)
+	mtctr	r23
+	bctrl
+1:
+	LOAD_REG_ADDR(r3, booke_regs_buffer)
+	li	r4, DEEPSLEEP_FLAG
+	bl	booke_cpu_state_restore
+
+	/* Load each CAM entry */
+	LOAD_REG_ADDR(r3, tlbcam_index)
+	lwz	r3, 0(r3)
+	mtctr	r3
+	li	r0, 0
+3:	mr	r3, r0
+	bl	loadcam_entry
+	addi	r0, r0, 1
+	bdnz	3b
+
+	/* restore return address */
+	LOAD_REG_ADDR(r3, booke_regs_buffer)
+	ld	r4, SR_MSR(r3)
+	mtmsr	r4
+	ld	r4, SR_LR(r3)
+	mtlr	r4
+
+	blr
+
+#endif /* CONFIG_PPC32 */
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index eb83a30..7351c40 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -67,7 +67,14 @@ extern const struct fsl_pm_ops *qoriq_pm_ops;
 #define PLAT_PM_SLEEP	20
 #define PLAT_PM_LPM20	30
 
+extern int fsl_dp_iomap(void);
+extern void fsl_dp_iounmap(void);
+
 extern int fsl_rcpm_init(void);
+extern int fsl_enter_epu_deepsleep(void);
+extern void fsl_dp_enter_low(void *ccsr_base, void *dcsr_base,
+				void *pld_base, int pld_flag);
+extern void __entry_deep_sleep(void);
 
 extern void fsl_dp_fsm_setup(void *dcsr_base);
 extern void fsl_dp_fsm_clean(void *dcsr_base);
-- 
1.7.3


