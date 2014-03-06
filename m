Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaCFGOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:14:03 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:45356 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaCFGOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:14:00 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>
Subject: [PATCH 1/4] tile: Add support for handling PMC hardware
Thread-Topic: [PATCH 1/4] tile: Add support for handling PMC hardware
Thread-Index: Ac85AzzGirA9kpwRSmuKtpqeEoyE7g==
Date: Thu, 6 Mar 2014 06:13:48 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D67FF17@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PMC module is used by perf_events, oprofile and watchdogs.

Signed-off-by: Zhigang Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig            |   4 ++
 arch/tile/include/asm/pmc.h  |  64 +++++++++++++++++++++++
 arch/tile/kernel/Makefile    |   1 +
 arch/tile/kernel/intvec_32.S |  13 ++---
 arch/tile/kernel/intvec_64.S |  13 ++---
 arch/tile/kernel/pmc.c       | 121 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 204 insertions(+), 12 deletions(-)
 create mode 100644 arch/tile/include/asm/pmc.h
 create mode 100644 arch/tile/kernel/pmc.c

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index b3692ce..3067b15 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -66,6 +66,10 @@ config HUGETLB_SUPER_PAGES
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
+# Enable PMC if PERF_EVENTS, OPROFILE, or WATCHPOINTS are enabled.
+config USE_PMC
+	bool
+
 # FIXME: tilegx can implement a more efficient rwsem.
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
diff --git a/arch/tile/include/asm/pmc.h b/arch/tile/include/asm/pmc.h
new file mode 100644
index 0000000..7ae3956
--- /dev/null
+++ b/arch/tile/include/asm/pmc.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright 2014 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PMC_H
+#define _ASM_TILE_PMC_H
+
+#include <linux/ptrace.h>
+
+#define TILE_BASE_COUNTERS	2
+
+/* Bitfields below are derived from SPR PERF_COUNT_CTL*/
+#ifndef __tilegx__
+/* PERF_COUNT_CTL on TILEPro */
+#define TILE_CTL_EXCL_USER	(1 << 7) /* exclude user level */
+#define TILE_CTL_EXCL_KERNEL	(1 << 8) /* exclude kernel level */
+#define TILE_CTL_EXCL_HV	(1 << 9) /* exclude hypervisor level */
+
+#define TILE_SEL_MASK		0x7f	/* 7 bits for event SEL,
+					COUNT_0_SEL */
+#define TILE_PLM_MASK		0x780	/* 4 bits priv level msks,
+					COUNT_0_MASK*/
+#define TILE_EVENT_MASK	(TILE_SEL_MASK | TILE_PLM_MASK)
+
+#else /* __tilegx__*/
+/* PERF_COUNT_CTL on TILEGx*/
+#define TILE_CTL_EXCL_USER	(1 << 10) /* exclude user level */
+#define TILE_CTL_EXCL_KERNEL	(1 << 11) /* exclude kernel level */
+#define TILE_CTL_EXCL_HV	(1 << 12) /* exclude hypervisor level */
+
+#define TILE_SEL_MASK		0x3f	/* 6 bits for event SEL,
+					COUNT_0_SEL*/
+#define TILE_BOX_MASK		0x1c0	/* 3 bits box msks,
+					COUNT_0_BOX */
+#define TILE_PLM_MASK		0x3c00	/* 4 bits priv level msks,
+					COUNT_0_MASK */
+#define TILE_EVENT_MASK	(TILE_SEL_MASK | TILE_BOX_MASK | TILE_PLM_MASK)
+#endif /* __tilegx__*/
+
+/* Takes register and fault number.  Returns error to disable the interrupt. */
+typedef int (*perf_irq_t)(struct pt_regs *, int);
+
+int userspace_perf_handler(struct pt_regs *regs, int fault);
+
+perf_irq_t reserve_pmc_hardware(perf_irq_t new_perf_irq);
+void release_pmc_hardware(void);
+
+unsigned long pmc_get_overflow(void);
+void pmc_ack_overflow(unsigned long status);
+
+void unmask_pmc_interrupts(void);
+void mask_pmc_interrupts(void);
+
+#endif /* _ASM_TILE_PMC_H */
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 27a2bf3..71d8353 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_PCI)		+= pci_gx.o
 else
 obj-$(CONFIG_PCI)		+= pci.o
 endif
+obj-$(CONFIG_USE_PMC)		+= pmc.o
 obj-$(CONFIG_TILE_USB)		+= usb.o
 obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount_64.o
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 2cbe6d5..605ffbd 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -313,13 +313,13 @@ intvec_\vecname:
 	 movei  r3, 0
 	}
 	.else
-	.ifc \c_routine, op_handle_perf_interrupt
+	.ifc \c_routine, handle_perf_interrupt
 	{
 	 mfspr  r2, PERF_COUNT_STS
 	 movei  r3, -1   /* not used, but set for consistency */
 	}
 	.else
-	.ifc \c_routine, op_handle_aux_perf_interrupt
+	.ifc \c_routine, handle_perf_interrupt
 	{
 	 mfspr  r2, AUX_PERF_COUNT_STS
 	 movei  r3, -1   /* not used, but set for consistency */
@@ -1835,8 +1835,9 @@ int_unalign:
 /* Include .intrpt array of interrupt vectors */
 	.section ".intrpt", "ax"
 
-#define op_handle_perf_interrupt bad_intr
-#define op_handle_aux_perf_interrupt bad_intr
+#ifndef CONFIG_USE_PMC
+#define handle_perf_interrupt bad_intr
+#endif
 
 #ifndef CONFIG_HARDWALL
 #define do_hardwall_trap bad_intr
@@ -1877,7 +1878,7 @@ int_unalign:
 	int_hand     INT_IDN_AVAIL, IDN_AVAIL, bad_intr
 	int_hand     INT_UDN_AVAIL, UDN_AVAIL, bad_intr
 	int_hand     INT_PERF_COUNT, PERF_COUNT, \
-		     op_handle_perf_interrupt, handle_nmi
+		     handle_perf_interrupt, handle_nmi
 	int_hand     INT_INTCTRL_3, INTCTRL_3, bad_intr
 #if CONFIG_KERNEL_PL == 2
 	dc_dispatch  INT_INTCTRL_2, INTCTRL_2
@@ -1902,7 +1903,7 @@ int_unalign:
 	int_hand     INT_SN_CPL, SN_CPL, bad_intr
 	int_hand     INT_DOUBLE_FAULT, DOUBLE_FAULT, do_trap
 	int_hand     INT_AUX_PERF_COUNT, AUX_PERF_COUNT, \
-		     op_handle_aux_perf_interrupt, handle_nmi
+		     handle_perf_interrupt, handle_nmi
 
 	/* Synthetic interrupt delivered only by the simulator */
 	int_hand     INT_BREAKPOINT, BREAKPOINT, do_breakpoint
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index b8fc497..8f892a5 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -509,10 +509,10 @@ intvec_\vecname:
 	.ifc \c_routine, do_trap
 	mfspr   r2, GPV_REASON
 	.else
-	.ifc \c_routine, op_handle_perf_interrupt
+	.ifc \c_routine, handle_perf_interrupt
 	mfspr   r2, PERF_COUNT_STS
 	.else
-	.ifc \c_routine, op_handle_aux_perf_interrupt
+	.ifc \c_routine, handle_perf_interrupt
 	mfspr   r2, AUX_PERF_COUNT_STS
 	.endif
 	.endif
@@ -1491,8 +1491,9 @@ STD_ENTRY(fill_ra_stack)
 	.global intrpt_start
 intrpt_start:
 
-#define op_handle_perf_interrupt bad_intr
-#define op_handle_aux_perf_interrupt bad_intr
+#ifndef CONFIG_USE_PMC
+#define handle_perf_interrupt bad_intr
+#endif
 
 #ifndef CONFIG_HARDWALL
 #define do_hardwall_trap bad_intr
@@ -1540,9 +1541,9 @@ intrpt_start:
 #endif
 	int_hand     INT_IPI_0, IPI_0, bad_intr
 	int_hand     INT_PERF_COUNT, PERF_COUNT, \
-		     op_handle_perf_interrupt, handle_nmi
+		     handle_perf_interrupt, handle_nmi
 	int_hand     INT_AUX_PERF_COUNT, AUX_PERF_COUNT, \
-		     op_handle_perf_interrupt, handle_nmi
+		     handle_perf_interrupt, handle_nmi
 	int_hand     INT_INTCTRL_3, INTCTRL_3, bad_intr
 #if CONFIG_KERNEL_PL == 2
 	dc_dispatch  INT_INTCTRL_2, INTCTRL_2
diff --git a/arch/tile/kernel/pmc.c b/arch/tile/kernel/pmc.c
new file mode 100644
index 0000000..db62cc3
--- /dev/null
+++ b/arch/tile/kernel/pmc.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright 2014 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/atomic.h>
+#include <linux/interrupt.h>
+
+#include <asm/processor.h>
+#include <asm/pmc.h>
+
+perf_irq_t perf_irq = NULL;
+int handle_perf_interrupt(struct pt_regs *regs, int fault)
+{
+	int retval;
+
+	if (!perf_irq)
+		panic("Unexpected PERF_COUNT interrupt %d\n", fault);
+
+	nmi_enter();
+	retval = perf_irq(regs, fault);
+	nmi_exit();
+	return retval;
+}
+
+/* Reserve PMC hardware if it is available. */
+perf_irq_t reserve_pmc_hardware(perf_irq_t new_perf_irq)
+{
+	return cmpxchg(&perf_irq, NULL, new_perf_irq);
+}
+EXPORT_SYMBOL(reserve_pmc_hardware);
+
+/* Release PMC hardware. */
+void release_pmc_hardware(void)
+{
+	perf_irq = NULL;
+}
+EXPORT_SYMBOL(release_pmc_hardware);
+
+
+/*
+ * Get current overflow status of each performance counter,
+ * and auxiliary performance counter.
+ */
+unsigned long
+pmc_get_overflow(void)
+{
+	unsigned long status;
+
+	/*
+	 * merge base+aux into a single vector
+	 */
+	status = __insn_mfspr(SPR_PERF_COUNT_STS);
+	status |= __insn_mfspr(SPR_AUX_PERF_COUNT_STS) << TILE_BASE_COUNTERS;
+	return status;
+}
+
+/*
+ * Clear the status bit for the corresponding counter, if written
+ * with a one.
+ */
+void
+pmc_ack_overflow(unsigned long status)
+{
+	/*
+	 * clear overflow status by writing ones
+	 */
+	__insn_mtspr(SPR_PERF_COUNT_STS, status);
+	__insn_mtspr(SPR_AUX_PERF_COUNT_STS, status >> TILE_BASE_COUNTERS);
+}
+
+/*
+ * The perf count interrupts are masked and unmasked explicitly,
+ * and only here.  The normal irq_enable() does not enable them,
+ * and irq_disable() does not disable them.  That lets these
+ * routines drive the perf count interrupts orthogonally.
+ *
+ * We also mask the perf count interrupts on entry to the perf count
+ * interrupt handler in assembly code, and by default unmask them
+ * again (with interrupt critical section protection) just before
+ * returning from the interrupt.  If the perf count handler returns
+ * a non-zero error code, then we don't re-enable them before returning.
+ *
+ * For Pro, we rely on both interrupts being in the same word to update
+ * them atomically so we never have one enabled and one disabled.
+ */
+
+#if CHIP_HAS_SPLIT_INTR_MASK()
+# if INT_PERF_COUNT < 32 || INT_AUX_PERF_COUNT < 32
+#  error Fix assumptions about which word PERF_COUNT interrupts are in
+# endif
+#endif
+
+static inline unsigned long long pmc_mask(void)
+{
+	unsigned long long mask = 1ULL << INT_PERF_COUNT;
+	mask |= 1ULL << INT_AUX_PERF_COUNT;
+	return mask;
+}
+
+void unmask_pmc_interrupts(void)
+{
+	interrupt_mask_reset_mask(pmc_mask());
+}
+
+void mask_pmc_interrupts(void)
+{
+	interrupt_mask_set_mask(pmc_mask());
+}
-- 
1.8.3.1

