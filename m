Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaLRI0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:26:39 -0500
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:54241
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017AbaLRI0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:26:38 -0500
From: Zhuoyu Zhang <Zhuoyu.Zhang@freescale.com>
To: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <leoli@freescale.com>, <Jason.Jin@freescale.com>,
        <chenhui.zhao@freescale.com>
Subject: [PATCH v3 1/1] arm: ls1: add CPU hotplug platform support
Date: Thu, 18 Dec 2014 16:24:52 +0800
Message-ID: <1418891092-14591-1-git-send-email-Zhuoyu.Zhang@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Zhuoyu.Zhang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(50466002)(92566001)(21056001)(50226001)(229853001)(120916001)(106466001)(36756003)(19580395003)(575784001)(46102003)(86362001)(107046002)(62966003)(4396001)(64706001)(105606002)(87936001)(97736003)(20776003)(6806004)(77096005)(19580405001)(84676001)(85426001)(104016003)(31966008)(50986999)(68736005)(77156002)(89996001)(47776003)(48376002)(2201001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1294;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1294;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB1294;
X-Forefront-PRVS: 042957ACD7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1294;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Zhuoyu <Zhuoyu.Zhang@freescale.com>

This implements CPU hotplug for ls1. When cpu is down, it will be put
in boot holdoff state. When cpu is up, it will always soft reset and
boots up the same path as a cold boot.

Signed-off-by: Zhang Zhuoyu <Zhuoyu.Zhang@freescale.com>
---
 arch/arm/mach-imx/common.h  |  16 +++++
 arch/arm/mach-imx/hotplug.c |  29 +++++++++
 arch/arm/mach-imx/platsmp.c | 153 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 186 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index cfcdb62..c2acb81 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -13,6 +13,17 @@
 
 #include <linux/reboot.h>
 
+#define	SCFG_CORE0_SFT_RST	0x130
+#define	SCFG_CORESRENCR		0x204
+#define	DCFG_CCSR_BRR		0x0E4
+#define	DCFG_CCSR_SCRATCHRW1	0x200
+#define	CCSR_TWAITSR0		0x04C
+
+#define	STRIDE_4B		4
+
+#define	SCFG_CORE_SOFT_RST_EN	0x80000000
+#define	SCFG_CORE_SOFT_RST	0x80000000
+
 struct irq_data;
 struct platform_device;
 struct pt_regs;
@@ -92,6 +103,7 @@ void imx_print_silicon_rev(const char *cpu, int srev);
 void imx_enable_cpu(int cpu, bool enable);
 void imx_set_cpu_jump(int cpu, void *jump_addr);
 u32 imx_get_cpu_arg(int cpu);
+u32 ls1_get_cpu_arg(int cpu);
 void imx_set_cpu_arg(int cpu, u32 arg);
 #ifdef CONFIG_SMP
 void v7_secondary_startup(void);
@@ -134,6 +146,10 @@ void imx6sl_pm_init(void);
 void imx6sx_pm_init(void);
 void imx6q_pm_set_ccm_base(void __iomem *base);
 
+extern int ls1021a_holdoff(unsigned int cpu);
+extern void ls1021a_cpu_die(unsigned int cpu);
+extern int ls1021a_cpu_kill(unsigned int cpu);
+
 #ifdef CONFIG_PM
 void imx51_pm_init(void);
 void imx53_pm_init(void);
diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
index b35e99c..8f5f082 100644
--- a/arch/arm/mach-imx/hotplug.c
+++ b/arch/arm/mach-imx/hotplug.c
@@ -14,6 +14,7 @@
 #include <linux/jiffies.h>
 #include <asm/cp15.h>
 #include <asm/proc-fns.h>
+#include <asm/cacheflush.h>
 
 #include "common.h"
 
@@ -68,3 +69,31 @@ int imx_cpu_kill(unsigned int cpu)
 	imx_set_cpu_arg(cpu, 0);
 	return 1;
 }
+
+void __ref ls1021a_cpu_die(unsigned int cpu)
+{
+	v7_exit_coherency_flush(louis);
+
+	/* LS1021a platform can't really power down an offline CPU.
+	 * So we put offline core into WFI, then reset it and put it into
+	 * boot holdoff state as a workaround method. It is a little tricky,
+	 * but we have no better choice due to hardware limitation for now.
+	 */
+	wfi();
+
+	/* We should never get here. */
+	BUG();
+
+}
+
+int ls1021a_cpu_kill(unsigned int cpu)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(50);
+
+	while (!ls1_get_cpu_arg(cpu))
+		if (time_after(jiffies, timeout))
+			return 0;
+
+	/* Reset offline core and put it into boot holdoff state */
+	return ls1021a_holdoff(cpu);
+}
diff --git a/arch/arm/mach-imx/platsmp.c b/arch/arm/mach-imx/platsmp.c
index 7f27001..6bc1320 100644
--- a/arch/arm/mach-imx/platsmp.c
+++ b/arch/arm/mach-imx/platsmp.c
@@ -14,17 +14,23 @@
 #include <linux/of_address.h>
 #include <linux/of.h>
 #include <linux/smp.h>
+#include <linux/delay.h>
 
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 #include <asm/smp_scu.h>
 #include <asm/mach/map.h>
+#include <asm/smp_plat.h>
 
 #include "common.h"
 #include "hardware.h"
 
 u32 g_diag_reg;
 static void __iomem *scu_base;
+static void __iomem *dcfg_base;
+static void __iomem *scfg_base;
+static void __iomem *rcpm_base;
+static u32 secondary_pre_boot_entry;
 
 static struct map_desc scu_io_desc __initdata = {
 	/* .virtual and .pfn are run-time assigned */
@@ -98,32 +104,155 @@ struct smp_operations  imx_smp_ops __initdata = {
 #endif
 };
 
-#define DCFG_CCSR_SCRATCHRW1	0x200
+static int ls1021a_secondary_iomap(void)
+{
+	struct device_node *np;
+	int ret;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-dcfg");
+	if (!np) {
+		pr_err("%s: failed to find dcfg node.\n", __func__);
+		ret = -ENODEV;
+		goto dcfg_err;
+	}
+
+	dcfg_base = of_iomap(np, 0);
+	of_node_put(np);
+	if (!dcfg_base) {
+		pr_err("%s: failed to map dcfg.\n", __func__);
+		ret = -ENOMEM;
+		goto dcfg_err;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-scfg");
+	if (!np) {
+		pr_err("%s: failed to find scfg node.\n", __func__);
+		ret = -ENODEV;
+		goto scfg_err;
+	}
+
+	scfg_base = of_iomap(np, 0);
+	of_node_put(np);
+	if (!scfg_base) {
+		pr_err("%s: failed to map scfg.\n", __func__);
+		ret = -ENOMEM;
+		goto scfg_err;
+	}
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.1");
+	if (!np) {
+		pr_err("%s(): failed to find rcpm node.\n", __func__);
+		return -ENODEV;
+		goto rcpm_err;
+	}
+
+	rcpm_base = of_iomap(np, 0);
+	of_node_put(np);
+	if (!rcpm_base) {
+		pr_err("%s: failed to map rcpm.\n", __func__);
+		ret = -ENOMEM;
+		goto rcpm_err;
+	}
+
+	return 0;
+
+rcpm_err:
+	iounmap(scfg_base);
+scfg_err:
+	iounmap(dcfg_base);
+dcfg_err:
+	return ret;
+}
+
+u32 ls1_get_cpu_arg(int cpu)
+{
+	cpu = cpu_logical_map(cpu);
+	return ioread32be(rcpm_base + CCSR_TWAITSR0) & (1 << cpu);
+}
+
+int ls1021a_holdoff(unsigned int cpu)
+{
+	if (!scfg_base || !dcfg_base)
+		return -ENOMEM;
+
+	iowrite32be(0, dcfg_base + DCFG_CCSR_SCRATCHRW1);
+
+	/* Soft reset secondary core, put it into boot holdoff state */
+	setbits32(scfg_base + SCFG_CORESRENCR, SCFG_CORE_SOFT_RST_EN);
+	setbits32(scfg_base + SCFG_CORE0_SFT_RST + STRIDE_4B * cpu,
+							SCFG_CORE_SOFT_RST);
+
+	/* Disable core soft reset register */
+	clrbits32(scfg_base + SCFG_CORESRENCR, SCFG_CORE_SOFT_RST_EN);
+
+	return 1;
+}
+
+void ls1021a_set_secondary_entry(void)
+{
+	unsigned long paddr;
+
+	if (dcfg_base) {
+		paddr = virt_to_phys(secondary_startup);
+		iowrite32be(paddr, dcfg_base + DCFG_CCSR_SCRATCHRW1);
+	}
+}
+
+static int ls1021a_reset_secondary(unsigned int cpu)
+{
+	if (!scfg_base || !dcfg_base)
+		return -ENOMEM;
+
+	iowrite32be(secondary_pre_boot_entry, dcfg_base + DCFG_CCSR_SCRATCHRW1);
+
+	/* Soft reset secondary core */
+	setbits32(scfg_base + SCFG_CORESRENCR, SCFG_CORE_SOFT_RST_EN);
+	setbits32(scfg_base + SCFG_CORE0_SFT_RST + STRIDE_4B * cpu,
+							SCFG_CORE_SOFT_RST);
+	mdelay(15);
+
+	/* Release secondary core */
+	setbits32(dcfg_base + DCFG_CCSR_BRR, 1 << cpu);
+
+	mdelay(1);
+
+	ls1021a_set_secondary_entry();
+
+	/* Disable core soft reset register */
+	clrbits32(scfg_base + SCFG_CORESRENCR, SCFG_CORE_SOFT_RST_EN);
+
+	return 0;
+}
 
 static int ls1021a_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
+	int ret = 0;
+
+	if (system_state == SYSTEM_RUNNING)
+		ret = ls1021a_reset_secondary(cpu);
+
+	udelay(1);
+
 	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 
-	return 0;
+	return ret;
 }
 
 static void __init ls1021a_smp_prepare_cpus(unsigned int max_cpus)
 {
-	struct device_node *np;
-	void __iomem *dcfg_base;
-	unsigned long paddr;
+	ls1021a_secondary_iomap();
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,ls1021a-dcfg");
-	dcfg_base = of_iomap(np, 0);
-	BUG_ON(!dcfg_base);
-
-	paddr = virt_to_phys(secondary_startup);
-	writel_relaxed(cpu_to_be32(paddr), dcfg_base + DCFG_CCSR_SCRATCHRW1);
+	secondary_pre_boot_entry = ioread32be(dcfg_base +
+						DCFG_CCSR_SCRATCHRW1);
 
-	iounmap(dcfg_base);
+	ls1021a_set_secondary_entry();
 }
 
 struct smp_operations  ls1021a_smp_ops __initdata = {
 	.smp_prepare_cpus	= ls1021a_smp_prepare_cpus,
 	.smp_boot_secondary	= ls1021a_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die                = ls1021a_cpu_die,
+	.cpu_kill               = ls1021a_cpu_kill,
+#endif
 };
-- 
2.1.0.27.g96db324

