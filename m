Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaCGE6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:58:42 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53048
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbaCGE6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:58:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zze0eahc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH 3/9] powerpc/rcpm: add RCPM driver
Date: Fri, 7 Mar 2014 12:57:59 +0800
Message-ID: <1394168285-32275-3-git-send-email-chenhui.zhao@freescale.com>
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

There is a RCPM (Run Control/Power Management) in Freescale QorIQ
series processors. The device performs tasks associated with device
run control and power management.

The driver implements some features: mask/unmask irq, enter/exit low
power states, freeze time base, etc.

There are two versions of register map in RCPM, which is specified by
the compatible entry in the RCPM node of device tree.

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
 arch/powerpc/include/asm/fsl_guts.h           |  105 ++++++++
 arch/powerpc/platforms/85xx/Kconfig           |    1 +
 arch/powerpc/platforms/85xx/corenet_generic.c |    2 +
 arch/powerpc/sysdev/Kconfig                   |    5 +
 arch/powerpc/sysdev/Makefile                  |    1 +
 arch/powerpc/sysdev/fsl_rcpm.c                |  315 +++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_soc.h                 |   24 ++
 7 files changed, 453 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/sysdev/fsl_rcpm.c

diff --git a/arch/powerpc/include/asm/fsl_guts.h b/arch/powerpc/include/asm/fsl_guts.h
index 77ced0b..492534a 100644
--- a/arch/powerpc/include/asm/fsl_guts.h
+++ b/arch/powerpc/include/asm/fsl_guts.h
@@ -185,5 +185,110 @@ static inline void guts_set_pmuxcr_dma(struct ccsr_guts __iomem *guts,
 
 #endif
 
+struct ccsr_rcpm_v1 {
+	u8	res0000[4];
+	__be32	cdozsr;	    /* 0x0004 Core Doze Status Register */
+	u8	res0008[4];
+	__be32	cdozcr;	    /* 0x000c Core Doze Control Register */
+	u8	res0010[4];
+	__be32	cnapsr;	    /* 0x0014 Core Nap Status Register */
+	u8	res0018[4];
+	__be32	cnapcr;	    /* 0x001c Core Nap Control Register */
+	u8	res0020[4];
+	__be32	cdozpsr;    /* 0x0024 Core Doze Previous Status Register */
+	u8	res0028[4];
+	__be32	cnappsr;    /* 0x002c Core Nap Previous Status Register */
+	u8	res0030[4];
+	__be32	cwaitsr;    /* 0x0034 Core Wait Status Register */
+	u8	res0038[4];
+	__be32	cwdtdsr;    /* 0x003c Core Watchdog Detect Status Register */
+	__be32	powmgtcsr;  /* 0x0040 Power Mangement Control&Status Register */
+#define RCPM_POWMGTCSR_SLP	0x00020000
+	u8	res0044[12];
+	__be32	ippdexpcr;  /* 0x0050 IP Powerdown Exception Control Register */
+	u8	res0054[16];
+	__be32	cpmimr;	    /* 0x0064 Core PM IRQ Mask Register */
+	u8	res0068[4];
+	__be32	cpmcimr;    /* 0x006c Core PM Critical IRQ Mask Register */
+	u8	res0070[4];
+	__be32	cpmmcmr;    /* 0x0074 Core PM Machine Check Mask Register */
+	u8	res0078[4];
+	__be32	cpmnmimr;   /* 0x007c Core PM NMI Mask Register */
+	u8	res0080[4];
+	__be32	ctbenr;	    /* 0x0084 Core Time Base Enable Register */
+	u8	res0088[4];
+	__be32	ctbckselr;  /* 0x008c Core Time Base Clock Select Register */
+	u8	res0090[4];
+	__be32	ctbhltcr;   /* 0x0094 Core Time Base Halt Control Register */
+	u8	res0098[4];
+	__be32	cmcpmaskcr; /* 0x00a4 Core Machine Check Mask Register */
+};
+
+struct ccsr_rcpm_v2 {
+	u8	res_00[12];
+	u32	tph10sr0;	/* Thread PH10 Status Register */
+	u8	res_10[12];
+	u32	tph10setr0;	/* Thread PH10 Set Control Register */
+	u8	res_20[12];
+	u32	tph10clrr0;	/* Thread PH10 Clear Control Register */
+	u8	res_30[12];
+	u32	tph10psr0;	/* Thread PH10 Previous Status Register */
+	u8	res_40[12];
+	u32	twaitsr0;	/* Thread Wait Status Register */
+	u8	res_50[96];
+	u32	pcph15sr;	/* Physical Core PH15 Status Register */
+	u32	pcph15setr;	/* Physical Core PH15 Set Control Register */
+	u32	pcph15clrr;	/* Physical Core PH15 Clear Control Register */
+	u32	pcph15psr;	/* Physical Core PH15 Prev Status Register */
+	u8	res_c0[16];
+	u32	pcph20sr;	/* Physical Core PH20 Status Register */
+	u32	pcph20setr;	/* Physical Core PH20 Set Control Register */
+	u32	pcph20clrr;	/* Physical Core PH20 Clear Control Register */
+	u32	pcph20psr;	/* Physical Core PH20 Prev Status Register */
+	u32	pcpw20sr;	/* Physical Core PW20 Status Register */
+	u8	res_e0[12];
+	u32	pcph30sr;	/* Physical Core PH30 Status Register */
+	u32	pcph30setr;	/* Physical Core PH30 Set Control Register */
+	u32	pcph30clrr;	/* Physical Core PH30 Clear Control Register */
+	u32	pcph30psr;	/* Physical Core PH30 Prev Status Register */
+	u8	res_100[32];
+	u32	ippwrgatecr;	/* IP Power Gating Control Register */
+	u8	res_124[12];
+	u32	powmgtcsr;	/* Power Management Control & Status Reg */
+#define RCPM_POWMGTCSR_LPM20_RQ		0x00100000
+#define RCPM_POWMGTCSR_LPM20_ST		0x00000200
+#define RCPM_POWMGTCSR_P_LPM20_ST	0x00000100
+	u8	res_134[12];
+	u32	ippdexpcr[4];	/* IP Powerdown Exception Control Reg */
+	u8	res_150[12];
+	u32	tpmimr0;	/* Thread PM Interrupt Mask Reg */
+	u8	res_160[12];
+	u32	tpmcimr0;	/* Thread PM Crit Interrupt Mask Reg */
+	u8	res_170[12];
+	u32	tpmmcmr0;	/* Thread PM Machine Check Interrupt Mask Reg */
+	u8	res_180[12];
+	u32	tpmnmimr0;	/* Thread PM NMI Mask Reg */
+	u8	res_190[12];
+	u32	tmcpmaskcr0;	/* Thread Machine Check Mask Control Reg */
+	u32	pctbenr;	/* Physical Core Time Base Enable Reg */
+	u32	pctbclkselr;	/* Physical Core Time Base Clock Select */
+	u32	tbclkdivr;	/* Time Base Clock Divider Register */
+	u8	res_1ac[4];
+	u32	ttbhltcr[4];	/* Thread Time Base Halt Control Register */
+	u32	clpcl10sr;	/* Cluster PCL10 Status Register */
+	u32	clpcl10setr;	/* Cluster PCL30 Set Control Register */
+	u32	clpcl10clrr;	/* Cluster PCL30 Clear Control Register */
+	u32	clpcl10psr;	/* Cluster PCL30 Prev Status Register */
+	u32	cddslpsetr;	/* Core Domain Deep Sleep Set Register */
+	u32	cddslpclrr;	/* Core Domain Deep Sleep Clear Register */
+	u32	cdpwroksetr;	/* Core Domain Power OK Set Register */
+	u32	cdpwrokclrr;	/* Core Domain Power OK Clear Register */
+	u32	cdpwrensr;	/* Core Domain Power Enable Status Register */
+	u32	cddslsr;	/* Core Domain Deep Sleep Status Register */
+	u8	res_1e8[8];
+	u32	dslpcntcr[8];	/* Deep Sleep Counter Cfg Register */
+	u8	res_300[3568];
+};
+
 #endif
 #endif
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index c17aae8..54d8843 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -8,6 +8,7 @@ menuconfig FSL_SOC_BOOKE
 	select FSL_PCI if PCI
 	select SERIAL_8250_EXTENDED if SERIAL_8250
 	select SERIAL_8250_SHARE_IRQ if SERIAL_8250
+	select FSL_CORENET_RCPM if PPC_E500MC
 	default y
 
 if FSL_SOC_BOOKE
diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
index b756f3d..3fdf9f3 100644
--- a/arch/powerpc/platforms/85xx/corenet_generic.c
+++ b/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -56,6 +56,8 @@ void __init corenet_gen_setup_arch(void)
 
 	swiotlb_detect_4g();
 
+	fsl_rcpm_init();
+
 	pr_info("%s board from Freescale Semiconductor\n", ppc_md.name);
 }
 
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index 7baa70d..f6e7cde 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -34,3 +34,8 @@ config SCOM_DEBUGFS
 config GE_FPGA
 	bool
 	default n
+
+config FSL_CORENET_RCPM
+	bool
+	help
+	  This option enables support for RCPM (Run Control/Power Management).
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index f67ac90..a6ada64 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_MMIO_NVRAM)	+= mmio_nvram.o
 obj-$(CONFIG_FSL_SOC)		+= fsl_soc.o fsl_mpic_err.o
 obj-$(CONFIG_FSL_PCI)		+= fsl_pci.o $(fsl-msi-obj-y)
 obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
+obj-$(CONFIG_FSL_CORENET_RCPM)	+= fsl_rcpm.o
 obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
 obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
diff --git a/arch/powerpc/sysdev/fsl_rcpm.c b/arch/powerpc/sysdev/fsl_rcpm.c
new file mode 100644
index 0000000..493fcae
--- /dev/null
+++ b/arch/powerpc/sysdev/fsl_rcpm.c
@@ -0,0 +1,315 @@
+/*
+ * RCPM(Run Control/Power Management) support
+ *
+ * Copyright 2012-2014 Freescale Semiconductor Inc.
+ *
+ * Author: Chenhui Zhao <chenhui.zhao@freescale.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/of_address.h>
+#include <linux/export.h>
+
+#include <asm/io.h>
+#include <asm/fsl_guts.h>
+#include <asm/cputhreads.h>
+#include <sysdev/fsl_soc.h>
+
+const struct fsl_pm_ops *qoriq_pm_ops;
+
+static struct ccsr_rcpm_v1 __iomem *rcpm_v1_regs;
+static struct ccsr_rcpm_v2 __iomem *rcpm_v2_regs;
+
+static void rcpm_v1_irq_mask(int cpu)
+{
+	int hw_cpu = get_hard_smp_processor_id(cpu);
+	unsigned int mask = 1 << hw_cpu;
+
+	setbits32(&rcpm_v1_regs->cpmimr, mask);
+	setbits32(&rcpm_v1_regs->cpmcimr, mask);
+	setbits32(&rcpm_v1_regs->cpmmcmr, mask);
+	setbits32(&rcpm_v1_regs->cpmnmimr, mask);
+}
+
+static void rcpm_v1_irq_unmask(int cpu)
+{
+	int hw_cpu = get_hard_smp_processor_id(cpu);
+	unsigned int mask = 1 << hw_cpu;
+
+	clrbits32(&rcpm_v1_regs->cpmimr, mask);
+	clrbits32(&rcpm_v1_regs->cpmcimr, mask);
+	clrbits32(&rcpm_v1_regs->cpmmcmr, mask);
+	clrbits32(&rcpm_v1_regs->cpmnmimr, mask);
+}
+
+static void rcpm_v1_set_ip_power(int enable, u32 mask)
+{
+	if (enable)
+		setbits32(&rcpm_v1_regs->ippdexpcr, mask);
+	else
+		clrbits32(&rcpm_v1_regs->ippdexpcr, mask);
+}
+
+static void rcpm_v1_cpu_enter_state(int cpu, int state)
+{
+	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
+	unsigned int mask = 1 << hw_cpu;
+
+	switch (state) {
+	case E500_PM_PH10:
+		setbits32(&rcpm_v1_regs->cdozcr, mask);
+		break;
+	case E500_PM_PH15:
+		setbits32(&rcpm_v1_regs->cnapcr, mask);
+		break;
+	default:
+		pr_err("Unknown cpu PM state\n");
+		break;
+	}
+}
+
+static void rcpm_v1_cpu_exit_state(int cpu, int state)
+{
+	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
+	unsigned int mask = 1 << hw_cpu;
+
+	switch (state) {
+	case E500_PM_PH10:
+		clrbits32(&rcpm_v1_regs->cdozcr, mask);
+		break;
+	case E500_PM_PH15:
+		clrbits32(&rcpm_v1_regs->cnapcr, mask);
+		break;
+	default:
+		pr_err("Unknown cpu PM state\n");
+		break;
+	}
+}
+
+static int rcpm_v1_plat_enter_state(int state)
+{
+	u32 *pmcsr_reg = &rcpm_v1_regs->powmgtcsr;
+	int ret = 0;
+	int result;
+
+	switch (state) {
+	case PLAT_PM_SLEEP:
+		setbits32(pmcsr_reg, RCPM_POWMGTCSR_SLP);
+
+		/* At this point, the device is in sleep mode. */
+
+		/* Upon resume, wait for RCPM_POWMGTCSR_SLP bit to be clear. */
+		result = spin_event_timeout(
+		  !(in_be32(pmcsr_reg) & RCPM_POWMGTCSR_SLP), 10000, 10);
+		if (!result) {
+			pr_err("%s: timeout waiting for SLP bit to be cleared\n",
+			  __func__);
+			ret = -ETIMEDOUT;
+		}
+		break;
+	default:
+		pr_err("Unsupported platform PM state\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static void rcpm_v1_freeze_time_base(int freeze)
+{
+	u32 *tben_reg = &rcpm_v1_regs->ctbenr;
+	static u32 mask;
+
+	if (freeze) {
+		mask = in_be32(tben_reg);
+		clrbits32(tben_reg, mask);
+	} else {
+		setbits32(tben_reg, mask);
+	}
+
+	/* read back to push the previous write */
+	in_be32(tben_reg);
+}
+
+static void rcpm_v2_freeze_time_base(int freeze)
+{
+	u32 *tben_reg = &rcpm_v2_regs->pctbenr;
+	static u32 mask;
+
+	if (freeze) {
+		mask = in_be32(tben_reg);
+		clrbits32(tben_reg, mask);
+	} else {
+		setbits32(tben_reg, mask);
+	}
+
+	/* read back to push the previous write */
+	in_be32(tben_reg);
+}
+
+static void rcpm_v2_irq_mask(int cpu)
+{
+	int hw_cpu = get_hard_smp_processor_id(cpu);
+	unsigned int mask = 1 << hw_cpu;
+
+	setbits32(&rcpm_v2_regs->tpmimr0, mask);
+	setbits32(&rcpm_v2_regs->tpmcimr0, mask);
+	setbits32(&rcpm_v2_regs->tpmmcmr0, mask);
+	setbits32(&rcpm_v2_regs->tpmnmimr0, mask);
+}
+
+static void rcpm_v2_irq_unmask(int cpu)
+{
+	int hw_cpu = get_hard_smp_processor_id(cpu);
+	unsigned int mask = 1 << hw_cpu;
+
+	clrbits32(&rcpm_v2_regs->tpmimr0, mask);
+	clrbits32(&rcpm_v2_regs->tpmcimr0, mask);
+	clrbits32(&rcpm_v2_regs->tpmmcmr0, mask);
+	clrbits32(&rcpm_v2_regs->tpmnmimr0, mask);
+}
+
+static void rcpm_v2_set_ip_power(int enable, u32 mask)
+{
+	if (enable)
+		/* enable power of IP blocks in deep sleep mode */
+		setbits32(&rcpm_v2_regs->ippdexpcr[0], mask);
+	else
+		clrbits32(&rcpm_v2_regs->ippdexpcr[0], mask);
+}
+
+static void rcpm_v2_cpu_enter_state(int cpu, int state)
+{
+	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
+	u32 mask = 1 << cpu_core_index_of_thread(hw_cpu);
+
+	switch (state) {
+	case E500_PM_PH10:
+		/* one bit corresponds to one thread for PH10 of 6500 */
+		setbits32(&rcpm_v2_regs->tph10setr0, 1 << hw_cpu);
+		break;
+	case E500_PM_PH15:
+		setbits32(&rcpm_v2_regs->pcph15setr, mask);
+		break;
+	case E500_PM_PH20:
+		setbits32(&rcpm_v2_regs->pcph20setr, mask);
+		break;
+	case E500_PM_PH30:
+		setbits32(&rcpm_v2_regs->pcph30setr, mask);
+		break;
+	default:
+		pr_err("Unsupported cpu PM state\n");
+	}
+}
+
+static void rcpm_v2_cpu_exit_state(int cpu, int state)
+{
+	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
+	u32 mask = 1 << cpu_core_index_of_thread(hw_cpu);
+
+	switch (state) {
+	case E500_PM_PH10:
+		setbits32(&rcpm_v2_regs->tph10clrr0, 1 << hw_cpu);
+		break;
+	case E500_PM_PH15:
+		setbits32(&rcpm_v2_regs->pcph15clrr, mask);
+		break;
+	case E500_PM_PH20:
+		setbits32(&rcpm_v2_regs->pcph20clrr, mask);
+		break;
+	case E500_PM_PH30:
+		setbits32(&rcpm_v2_regs->pcph30clrr, mask);
+		break;
+	default:
+		pr_err("Unsupported cpu PM state\n");
+	}
+}
+
+static int rcpm_v2_plat_enter_state(int state)
+{
+	u32 *pmcsr_reg = &rcpm_v2_regs->powmgtcsr;
+	int ret = 0;
+	int result;
+
+	switch (state) {
+	case PLAT_PM_LPM20:
+		/* clear previous LPM20 status */
+		setbits32(pmcsr_reg, RCPM_POWMGTCSR_P_LPM20_ST);
+		/* enter LPM20 status */
+		setbits32(pmcsr_reg, RCPM_POWMGTCSR_LPM20_RQ);
+
+		/* At this point, the device is in LPM20 status. */
+
+		/* resume ... */
+		result = spin_event_timeout(
+		  !(in_be32(pmcsr_reg) & RCPM_POWMGTCSR_LPM20_ST), 10000, 10);
+		if (!result) {
+			pr_err("%s: timeout waiting for LPM20 bit to be cleared\n",
+				__func__);
+			ret = -ETIMEDOUT;
+		}
+		break;
+	default:
+		pr_err("Unsupported platform PM state\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct fsl_pm_ops qoriq_rcpm_v1_ops = {
+	.irq_mask = rcpm_v1_irq_mask,
+	.irq_unmask = rcpm_v1_irq_unmask,
+	.cpu_enter_state = rcpm_v1_cpu_enter_state,
+	.cpu_exit_state = rcpm_v1_cpu_exit_state,
+	.plat_enter_state = rcpm_v1_plat_enter_state,
+	.set_ip_power = rcpm_v1_set_ip_power,
+	.freeze_time_base = rcpm_v1_freeze_time_base,
+};
+
+static const struct fsl_pm_ops qoriq_rcpm_v2_ops = {
+	.irq_mask = rcpm_v2_irq_mask,
+	.irq_unmask = rcpm_v2_irq_unmask,
+	.cpu_enter_state = rcpm_v2_cpu_enter_state,
+	.cpu_exit_state = rcpm_v2_cpu_exit_state,
+	.plat_enter_state = rcpm_v2_plat_enter_state,
+	.set_ip_power = rcpm_v2_set_ip_power,
+	.freeze_time_base = rcpm_v2_freeze_time_base,
+};
+
+int fsl_rcpm_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
+	if (np) {
+		rcpm_v2_regs = of_iomap(np, 0);
+		of_node_put(np);
+		if (!rcpm_v2_regs)
+			return -ENOMEM;
+
+		qoriq_pm_ops = &qoriq_rcpm_v2_ops;
+
+	} else {
+		np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-1.0");
+		if (np) {
+			rcpm_v1_regs = of_iomap(np, 0);
+			of_node_put(np);
+			if (!rcpm_v1_regs)
+				return -ENOMEM;
+
+			qoriq_pm_ops = &qoriq_rcpm_v1_ops;
+
+		} else {
+			pr_err("%s: can't find the rcpm node.\n", __func__);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 4c5a19e..9b9a34a 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -45,5 +45,29 @@ extern struct platform_diu_data_ops diu_ops;
 void fsl_hv_restart(char *cmd);
 void fsl_hv_halt(void);
 
+struct fsl_pm_ops {
+	void (*irq_mask)(int cpu);
+	void (*irq_unmask)(int cpu);
+	void (*cpu_enter_state)(int cpu, int state);
+	void (*cpu_exit_state)(int cpu, int state);
+	int (*plat_enter_state)(int state);
+	void (*freeze_time_base)(int freeze);
+	void (*set_ip_power)(int enable, u32 mask);
+};
+
+extern const struct fsl_pm_ops *qoriq_pm_ops;
+
+#define E500_PM_PH10	1
+#define E500_PM_PH15	2
+#define E500_PM_PH20	3
+#define E500_PM_PH30	4
+#define E500_PM_DOZE	E500_PM_PH10
+#define E500_PM_NAP	E500_PM_PH15
+
+#define PLAT_PM_SLEEP	20
+#define PLAT_PM_LPM20	30
+
+extern int fsl_rcpm_init(void);
+
 #endif
 #endif
-- 
1.7.3


