Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaIXUdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:33:54 -0400
Received: from mail-by2on0053.outbound.protection.outlook.com ([207.46.100.53]:7554
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbaIXUdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:33:52 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 2/2] socfpga: support suspend to ram
Date: Wed, 24 Sep 2014 15:27:29 -0500
Message-ID: <1411590449-9794-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA036.namprd06.prod.outlook.com (10.141.250.154) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(22564002)(189002)(199003)(74662003)(107046002)(53416004)(106356001)(46102003)(15202345003)(50466002)(4396001)(50226001)(92726001)(93916002)(79102003)(90102001)(92566001)(64706001)(42186005)(229853001)(86152002)(87286001)(10300001)(105586002)(88136002)(66066001)(50986999)(62966002)(33646002)(86362001)(104166001)(89996001)(85852003)(19580405001)(83322001)(21056001)(69596002)(15975445006)(80022003)(20776003)(81542003)(76176999)(77156001)(120916001)(19580395003)(101416001)(74502003)(83072002)(77982003)(81156004)(81342003)(48376002)(76482002)(95666004)(87976001)(85306004)(47776003)(77096002)(99396003)(102836001)(31966008)(97736003)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add code that requests that the sdr controller go into
self-refresh mode.  This code is run from ocram.

This patch assumes that u-boot has already configured sdr:
  sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
  sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
  sdr.ctrlcfg.dramtiming4.selfrfshexit = 512

How to suspend to ram:
 $ echo enabled > \
/sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup

 $ echo -n mem > /sys/power/state

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 arch/arm/mach-socfpga/Makefile       |    1 +
 arch/arm/mach-socfpga/core.h         |    4 +
 arch/arm/mach-socfpga/pm.c           |  141 ++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/self-refresh.S |  148 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c      |   10 +++
 5 files changed, 304 insertions(+)
 create mode 100644 arch/arm/mach-socfpga/pm.c
 create mode 100644 arch/arm/mach-socfpga/self-refresh.S

diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
index 6dd7a93..0591927 100644
--- a/arch/arm/mach-socfpga/Makefile
+++ b/arch/arm/mach-socfpga/Makefile
@@ -4,3 +4,4 @@
 
 obj-y					:= socfpga.o
 obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
+obj-$(CONFIG_SUSPEND)	+= pm.o self-refresh.o
diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
index c4a0929..cc1a2fb 100644
--- a/arch/arm/mach-socfpga/core.h
+++ b/arch/arm/mach-socfpga/core.h
@@ -38,6 +38,7 @@ extern void socfpga_sysmgr_init(void);
 
 extern void __iomem *sys_manager_base_addr;
 extern void __iomem *rst_manager_base_addr;
+extern void __iomem *sdr_ctl_base_addr;
 
 extern struct smp_operations socfpga_smp_ops;
 extern char secondary_trampoline, secondary_trampoline_end;
@@ -46,4 +47,7 @@ extern unsigned long cpu1start_addr;
 
 #define SOCFPGA_SCU_VIRT_BASE   0xfffec000
 
+u32 socfpga_sdram_self_refresh(u32 sdr_base, u32 scu_base);
+extern unsigned int socfpga_sdram_self_refresh_sz;
+
 #endif
diff --git a/arch/arm/mach-socfpga/pm.c b/arch/arm/mach-socfpga/pm.c
new file mode 100644
index 0000000..02c3719
--- /dev/null
+++ b/arch/arm/mach-socfpga/pm.c
@@ -0,0 +1,141 @@
+/*
+ *  arch/arm/mach-socfpga/pm.c
+ *
+ * Copyright (C) 2014 Altera Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/bitops.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+#include <linux/suspend.h>
+#include <asm/suspend.h>
+#include <asm/fncpy.h>
+#include "core.h"
+
+/* Pointer to function copied to ocram */
+static u32 (*socfpga_sdram_self_refresh_in_ocram)(u32 sdr_base, u32 scu_base);
+
+/* Round up a pointer address to fix aligment for fncpy() */
+static void *fncpy_align(void *ptr)
+{
+	u32 value = (u32)ptr;
+
+	if ((value & (FNCPY_ALIGN - 1)) != 0)
+		value = ((value & ~(FNCPY_ALIGN - 1)) + FNCPY_ALIGN);
+
+	return (void *)value;
+}
+
+static void *socfpga_init_ocram_exec(void)
+{
+	struct device_node *np;
+	const __be32 *prop;
+	u32 ocram_hwaddr, len;
+	void __iomem  *iomem_exec_ocram;
+	size_t size;
+
+	np = of_find_compatible_node(NULL, NULL, "mmio-sram");
+	if (!np) {
+		pr_err("SOCFPGA: Unable to find mmio-sram in dtb\n");
+		return 0;
+	}
+
+	/* Determine the OCRAM address and size */
+	prop = of_get_property(np, "reg", &size);
+	ocram_hwaddr = be32_to_cpup(prop++);
+	len = be32_to_cpup(prop);
+
+	if (!prop || size < sizeof(*prop)) {
+		pr_err("SOCFPGA: Unable to find OCRAM mapping in dtb\n");
+		return 0;
+	}
+
+	iomem_exec_ocram = __arm_ioremap_exec(ocram_hwaddr, len, 0);
+
+	/* Fix alignment to work with fncpy */
+	iomem_exec_ocram = fncpy_align(iomem_exec_ocram);
+
+	return iomem_exec_ocram;
+}
+
+static int socfpga_setup_ocram_self_refresh(void)
+{
+	void *ocram_addr;
+
+	/* Configure ocram and make it executable */
+	ocram_addr = socfpga_init_ocram_exec();
+	WARN(!ocram_addr, "Unable to initialize ocram for pm");
+	if (!ocram_addr)
+		return -EFAULT;
+
+	/* Copy the code that puts DDR in self refresh to ocram */
+	socfpga_sdram_self_refresh_in_ocram =
+		(void *)fncpy((void *)ocram_addr,
+		      &socfpga_sdram_self_refresh,
+		      socfpga_sdram_self_refresh_sz);
+
+	WARN(!socfpga_sdram_self_refresh_in_ocram,
+	     "could not copy function to ocram");
+	if (!socfpga_sdram_self_refresh_in_ocram)
+		return -EFAULT;
+
+	return 0;
+}
+
+static int socfpga_pm_suspend(unsigned long arg)
+{
+	u32 ret;
+
+	ret = socfpga_sdram_self_refresh_in_ocram((u32)sdr_ctl_base_addr,
+						  (u32)socfpga_scu_base_addr);
+
+	pr_debug("%s self-refresh loops request=%d exit=%d\n", __func__,
+		 ret & 0xffff, (ret >> 16) & 0xffff);
+
+	return 0;
+}
+
+static int socfpga_pm_enter(suspend_state_t state)
+{
+	switch (state) {
+	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_MEM:
+		outer_disable();
+		cpu_suspend(0, socfpga_pm_suspend);
+		outer_resume();
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct platform_suspend_ops socfpga_pm_ops = {
+	.valid	= suspend_valid_only_mem,
+	.enter	= socfpga_pm_enter,
+};
+
+static int __init socfpga_pm_init(void)
+{
+	if (socfpga_setup_ocram_self_refresh())
+		return -EFAULT;
+
+	suspend_set_ops(&socfpga_pm_ops);
+	pr_info("SoCFPGA initialized for DDR self-refresh during suspend.\n");
+
+	return 0;
+}
+arch_initcall(socfpga_pm_init);
diff --git a/arch/arm/mach-socfpga/self-refresh.S b/arch/arm/mach-socfpga/self-refresh.S
new file mode 100644
index 0000000..a58b58f
--- /dev/null
+++ b/arch/arm/mach-socfpga/self-refresh.S
@@ -0,0 +1,148 @@
+/*
+ * Copyright (C) 2014 Altera Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+#define SOCFPGA_SCU_CTRL_OFFS	0
+#define SCU_STANDBY_ENA		0x20
+#define MAX_LOOP_COUNT		1000
+
+/* Register offset */
+#define SDR_CTRLGRP_LOWPWREQ_ADDR       0x54
+#define SDR_CTRLGRP_LOWPWRACK_ADDR      0x58
+
+/* Bitfield positions */
+#define SELFRSHREQ_POS                  3
+#define SELFRSHREQ_MASK                 0x8
+
+#define SELFRFSHACK_POS                 1
+#define SELFRFSHACK_MASK                0x2
+
+	.arch   armv7-a
+	.text
+	.align 3
+
+	/*
+	 * socfpga_sdram_self_refresh
+	 *
+	 *  r0 : sdr_ctl_base_addr
+	 *  r1 : socfpga_scu_base_addr
+	 *  r2 : temp storage of register values
+	 *  r3 : loop counter
+	 *  r4 : temp storage of return value
+	 *
+	 *  return value: lower 16 bits: loop count going into self refresh
+	 *                upper 16 bits: loop count exiting self refresh
+	 */
+ENTRY(socfpga_sdram_self_refresh)
+	stmfd	sp!, {r4}
+
+	/*
+	 * Enable SCU (snoop) standby mode.
+	 *
+	 * From the ARM Cortex-A9 MPCore Technical Reference Manual:
+	 * "When set, SCU CLK is turned off when all processors are in WFI
+	 *  mode, there is no pending request on the ACP (if implemented), and
+	 *  there is no remaining activity in the SCU."
+	 */
+	ldr	r2, [r1, #SOCFPGA_SCU_CTRL_OFFS]
+	orr	r2, r2, #SCU_STANDBY_ENA
+	str	r2, [r1, #SOCFPGA_SCU_CTRL_OFFS]
+
+	/* Enable dynamic clock gating in the Power Control Register. */
+	mrc	p15, 0, r2, c15, c0, 0
+	orr	r2, r2, #1
+	mcr	p15, 0, r2, c15, c0, 0
+
+	/* Enable self refresh: set sdr.ctrlgrp.lowpwreq.selfrshreq = 1 */
+	ldr	r2, [r0, #SDR_CTRLGRP_LOWPWREQ_ADDR]
+	orr	r2, r2, #SELFRSHREQ_MASK
+	str	r2, [r0, #SDR_CTRLGRP_LOWPWREQ_ADDR]
+
+	/* Poll until sdr.ctrlgrp.lowpwrack.selfrfshack == 1 or hit max loops */
+	mov	r3, #0
+while_ack_0:
+	ldr	r2, [r0, #SDR_CTRLGRP_LOWPWRACK_ADDR]
+	and	r2, r2, #SELFRFSHACK_MASK
+	cmp	r2, #SELFRFSHACK_MASK
+	beq	ack_1
+
+	add	r3, #1
+	cmp	r3, #MAX_LOOP_COUNT
+	bne	while_ack_0
+
+ack_1:
+	mov	r4, r3
+
+	/*
+	 * Execute an ISB instruction to ensure that all of the
+	 * CP15 register changes have been committed.
+	 */
+	isb
+
+	/*
+	 * Execute a barrier instruction to ensure that all cache,
+	 * TLB and branch predictor maintenance operations issued
+	 * by any CPU in the cluster have completed.
+	 */
+	dsb
+	dmb
+
+	wfi
+
+	/* Disable self-refresh: set sdr.ctrlgrp.lowpwreq.selfrshreq = 0 */
+	ldr	r2, [r0, #SDR_CTRLGRP_LOWPWREQ_ADDR]
+	bic	r2, r2, #SELFRSHREQ_MASK
+	str	r2, [r0, #SDR_CTRLGRP_LOWPWREQ_ADDR]
+
+	/* Poll until sdr.ctrlgrp.lowpwrack.selfrfshack == 0 or hit max loops */
+	mov	r3, #0
+while_ack_1:
+	ldr	r2, [r0, #SDR_CTRLGRP_LOWPWRACK_ADDR]
+	and	r2, r2, #SELFRFSHACK_MASK
+	cmp	r2, #SELFRFSHACK_MASK
+	bne	ack_0
+
+	add	r3, #1
+	cmp	r3, #MAX_LOOP_COUNT
+	bne	while_ack_1
+
+ack_0:
+	/*
+	 * Prepare return value:
+	 * Shift loop count for exiting self refresh into upper 16 bits.
+	 * Leave loop count for requesting self refresh in lower 16 bits.
+	 */
+	mov	r3, r3, lsl #16
+	add	r4, r4, r3
+
+	/* Disable dynamic clock gating in the Power Control Register. */
+	mrc	p15, 0, r2, c15, c0, 0
+	bic	r2, r2, #1
+	mcr	p15, 0, r2, c15, c0, 0
+
+	/* Disable SCU standby mode */
+	ldr	r2, [r1, #SOCFPGA_SCU_CTRL_OFFS]
+	bic	r2, r2, #SCU_STANDBY_ENA
+	str	r2, [r1, #SOCFPGA_SCU_CTRL_OFFS]
+
+	mov     r0, r4                  @ return value
+	ldmfd	sp!, {r4}
+	bx	lr			@ return
+
+ENDPROC(socfpga_sdram_self_refresh)
+ENTRY(socfpga_sdram_self_refresh_sz)
+	.word	. - socfpga_sdram_self_refresh
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index adbf383..34b4cc5 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -30,6 +30,7 @@ void __iomem *socfpga_scu_base_addr = ((void __iomem *)(SOCFPGA_SCU_VIRT_BASE));
 void __iomem *sys_manager_base_addr;
 void __iomem *rst_manager_base_addr;
 unsigned long cpu1start_addr;
+void __iomem *sdr_ctl_base_addr;
 
 static struct map_desc scu_io_desc __initdata = {
 	.virtual	= SOCFPGA_SCU_VIRT_BASE,
@@ -77,6 +78,15 @@ void __init socfpga_sysmgr_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "altr,rst-mgr");
 	rst_manager_base_addr = of_iomap(np, 0);
+
+	np = of_find_compatible_node(NULL, NULL, "altr,sdr-ctl");
+	if (!np) {
+		pr_err("SOCFPGA: Unable to find sdr-ctl\n");
+		return;
+	}
+
+	sdr_ctl_base_addr = of_iomap(np, 0);
+	WARN_ON(!sdr_ctl_base_addr);
 }
 
 static void __init socfpga_init_irq(void)
-- 
1.7.9.5

