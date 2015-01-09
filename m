Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbbAIJfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:35:00 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42312 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbbAIJez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:34:55 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: [PATCH] cxl: Add tracepoints
Date: Fri,  9 Jan 2015 20:34:36 +1100
Message-Id: <1420796076-20393-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010909-0005-0000-0000-0000012BB548
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch adds tracepoints throughout the cxl driver, which can provide
insight into:

- Context lifetimes
- Commands sent to the PSL and AFU and their completion status
- Segment and page table misses and their resolution
- PSL and AFU interrupts
- slbia calls from the powerpc copro_fault code

These tracepoints are mostly intended to aid in debugging (particularly
for new AFU designs), and may be useful standalone or in conjunction
with hardware traces collected by the PSL (read out via the trace
interface in debugfs) and AFUs.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/Makefile |   5 +-
 drivers/misc/cxl/fault.c  |   5 +
 drivers/misc/cxl/file.c   |   3 +
 drivers/misc/cxl/irq.c    |   4 +
 drivers/misc/cxl/main.c   |   2 +
 drivers/misc/cxl/native.c |  38 +++-
 drivers/misc/cxl/trace.c  |  13 ++
 drivers/misc/cxl/trace.h  | 459 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 520 insertions(+), 9 deletions(-)
 create mode 100644 drivers/misc/cxl/trace.c
 create mode 100644 drivers/misc/cxl/trace.h

diff --git a/drivers/misc/cxl/Makefile b/drivers/misc/cxl/Makefile
index 165e98f..edb494d 100644
--- a/drivers/misc/cxl/Makefile
+++ b/drivers/misc/cxl/Makefile
@@ -1,3 +1,6 @@
-cxl-y				+= main.o file.o irq.o fault.o native.o context.o sysfs.o debugfs.o pci.o
+cxl-y				+= main.o file.o irq.o fault.o native.o context.o sysfs.o debugfs.o pci.o trace.o
 obj-$(CONFIG_CXL)		+= cxl.o
 obj-$(CONFIG_CXL_BASE)		+= base.o
+
+# For tracepoints to include our trace.h from tracepoint infrastructure:
+CFLAGS_trace.o := -I$(src)
diff --git a/drivers/misc/cxl/fault.c b/drivers/misc/cxl/fault.c
index e010302..5286b8b 100644
--- a/drivers/misc/cxl/fault.c
+++ b/drivers/misc/cxl/fault.c
@@ -20,6 +20,7 @@
 #include <asm/mmu.h>
 
 #include "cxl.h"
+#include "trace.h"
 
 static bool sste_matches(struct cxl_sste *sste, struct copro_slb *slb)
 {
@@ -75,6 +76,7 @@ static void cxl_load_segment(struct cxl_context *ctx, struct copro_slb *slb)
 
 	pr_devel("CXL Populating SST[%li]: %#llx %#llx\n",
 			sste - ctx->sstp, slb->vsid, slb->esid);
+	trace_cxl_ste_write(ctx, sste - ctx->sstp, slb->esid, slb->vsid);
 
 	sste->vsid_data = cpu_to_be64(slb->vsid);
 	sste->esid_data = cpu_to_be64(slb->esid);
@@ -116,6 +118,7 @@ static int cxl_handle_segment_miss(struct cxl_context *ctx,
 	int rc;
 
 	pr_devel("CXL interrupt: Segment fault pe: %i ea: %#llx\n", ctx->pe, ea);
+	trace_cxl_ste_miss(ctx, ea);
 
 	if ((rc = cxl_fault_segment(ctx, mm, ea)))
 		cxl_ack_ae(ctx);
@@ -135,6 +138,8 @@ static void cxl_handle_page_fault(struct cxl_context *ctx,
 	int result;
 	unsigned long access, flags, inv_flags = 0;
 
+	trace_cxl_pte_miss(ctx, dsisr, dar);
+
 	if ((result = copro_handle_mm_fault(mm, dar, dsisr, &flt))) {
 		pr_devel("copro_handle_mm_fault failed: %#x\n", result);
 		return cxl_ack_ae(ctx);
diff --git a/drivers/misc/cxl/file.c b/drivers/misc/cxl/file.c
index 4e85028..2364bca 100644
--- a/drivers/misc/cxl/file.c
+++ b/drivers/misc/cxl/file.c
@@ -23,6 +23,7 @@
 #include <asm/copro.h>
 
 #include "cxl.h"
+#include "trace.h"
 
 #define CXL_NUM_MINORS 256 /* Total to reserve */
 #define CXL_DEV_MINORS 13   /* 1 control + 4 AFUs * 3 (dedicated/master/shared) */
@@ -186,6 +187,8 @@ static long afu_ioctl_start_work(struct cxl_context *ctx,
 	 */
 	ctx->pid = get_pid(get_task_pid(current, PIDTYPE_PID));
 
+	trace_cxl_attach(ctx, work.work_element_descriptor, work.num_interrupts, amr);
+
 	if ((rc = cxl_attach_process(ctx, false, work.work_element_descriptor,
 				     amr))) {
 		afu_release_irqs(ctx);
diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
index c294925..ef52af7 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -17,6 +17,7 @@
 #include <misc/cxl.h>
 
 #include "cxl.h"
+#include "trace.h"
 
 /* XXX: This is implementation specific */
 static irqreturn_t handle_psl_slice_error(struct cxl_context *ctx, u64 dsisr, u64 errstat)
@@ -100,6 +101,8 @@ static irqreturn_t cxl_irq(int irq, void *data, struct cxl_irq_info *irq_info)
 	dsisr = irq_info->dsisr;
 	dar = irq_info->dar;
 
+	trace_cxl_psl_irq(ctx, irq, dsisr, dar);
+
 	pr_devel("CXL interrupt %i for afu pe: %i DSISR: %#llx DAR: %#llx\n", irq, ctx->pe, dsisr, dar);
 
 	if (dsisr & CXL_PSL_DSISR_An_DS) {
@@ -237,6 +240,7 @@ static irqreturn_t cxl_irq_afu(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
+	trace_cxl_afu_irq(ctx, afu_irq, irq, hwirq);
 	pr_devel("Received AFU interrupt %i for pe: %i (virq %i hwirq %lx)\n",
 	       afu_irq, ctx->pe, irq, hwirq);
 
diff --git a/drivers/misc/cxl/main.c b/drivers/misc/cxl/main.c
index 4cde9b6..8ccddce 100644
--- a/drivers/misc/cxl/main.c
+++ b/drivers/misc/cxl/main.c
@@ -23,6 +23,7 @@
 #include <misc/cxl.h>
 
 #include "cxl.h"
+#include "trace.h"
 
 static DEFINE_SPINLOCK(adapter_idr_lock);
 static DEFINE_IDR(cxl_adapter_idr);
@@ -48,6 +49,7 @@ static inline void _cxl_slbia(struct cxl_context *ctx, struct mm_struct *mm)
 		 ctx->afu->adapter->adapter_num, ctx->afu->slice, ctx->pe);
 
 	spin_lock_irqsave(&ctx->sste_lock, flags);
+	trace_cxl_slbia(ctx);
 	memset(ctx->sstp, 0, ctx->sst_size);
 	spin_unlock_irqrestore(&ctx->sste_lock, flags);
 	mb();
diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
index 0f24fa5..29185fc 100644
--- a/drivers/misc/cxl/native.c
+++ b/drivers/misc/cxl/native.c
@@ -18,24 +18,28 @@
 #include <misc/cxl.h>
 
 #include "cxl.h"
+#include "trace.h"
 
 static int afu_control(struct cxl_afu *afu, u64 command,
 		       u64 result, u64 mask, bool enabled)
 {
 	u64 AFU_Cntl = cxl_p2n_read(afu, CXL_AFU_Cntl_An);
 	unsigned long timeout = jiffies + (HZ * CXL_TIMEOUT);
+	int rc = 0;
 
 	spin_lock(&afu->afu_cntl_lock);
 	pr_devel("AFU command starting: %llx\n", command);
 
+	trace_cxl_afu_ctrl(afu, command);
+
 	cxl_p2n_write(afu, CXL_AFU_Cntl_An, AFU_Cntl | command);
 
 	AFU_Cntl = cxl_p2n_read(afu, CXL_AFU_Cntl_An);
 	while ((AFU_Cntl & mask) != result) {
 		if (time_after_eq(jiffies, timeout)) {
 			dev_warn(&afu->dev, "WARNING: AFU control timed out!\n");
-			spin_unlock(&afu->afu_cntl_lock);
-			return -EBUSY;
+			rc = -EBUSY;
+			goto out;
 		}
 		pr_devel_ratelimited("AFU control... (0x%.16llx)\n",
 				     AFU_Cntl | command);
@@ -44,9 +48,11 @@ static int afu_control(struct cxl_afu *afu, u64 command,
 	};
 	pr_devel("AFU command complete: %llx\n", command);
 	afu->enabled = enabled;
+out:
+	trace_cxl_afu_ctrl_done(afu, command, rc);
 	spin_unlock(&afu->afu_cntl_lock);
 
-	return 0;
+	return rc;
 }
 
 static int afu_enable(struct cxl_afu *afu)
@@ -91,6 +97,9 @@ int cxl_psl_purge(struct cxl_afu *afu)
 	u64 dsisr, dar;
 	u64 start, end;
 	unsigned long timeout = jiffies + (HZ * CXL_TIMEOUT);
+	int rc = 0;
+
+	trace_cxl_psl_ctrl(afu, CXL_PSL_SCNTL_An_Pc);
 
 	pr_devel("PSL purge request\n");
 
@@ -107,7 +116,8 @@ int cxl_psl_purge(struct cxl_afu *afu)
 			== CXL_PSL_SCNTL_An_Ps_Pending) {
 		if (time_after_eq(jiffies, timeout)) {
 			dev_warn(&afu->dev, "WARNING: PSL Purge timed out!\n");
-			return -EBUSY;
+			rc = -EBUSY;
+			goto out;
 		}
 		dsisr = cxl_p2n_read(afu, CXL_PSL_DSISR_An);
 		pr_devel_ratelimited("PSL purging... PSL_CNTL: 0x%.16llx  PSL_DSISR: 0x%.16llx\n", PSL_CNTL, dsisr);
@@ -128,7 +138,9 @@ int cxl_psl_purge(struct cxl_afu *afu)
 
 	cxl_p1n_write(afu, CXL_PSL_SCNTL_An,
 		       PSL_CNTL & ~CXL_PSL_SCNTL_An_Pc);
-	return 0;
+out:
+	trace_cxl_psl_ctrl_done(afu, CXL_PSL_SCNTL_An_Pc, rc);
+	return rc;
 }
 
 static int spa_max_procs(int spa_size)
@@ -279,6 +291,9 @@ static int do_process_element_cmd(struct cxl_context *ctx,
 {
 	u64 state;
 	unsigned long timeout = jiffies + (HZ * CXL_TIMEOUT);
+	int rc = 0;
+
+	trace_cxl_llcmd(ctx, cmd);
 
 	WARN_ON(!ctx->afu->enabled);
 
@@ -290,12 +305,14 @@ static int do_process_element_cmd(struct cxl_context *ctx,
 	while (1) {
 		if (time_after_eq(jiffies, timeout)) {
 			dev_warn(&ctx->afu->dev, "WARNING: Process Element Command timed out!\n");
-			return -EBUSY;
+			rc = -EBUSY;
+			goto out;
 		}
 		state = be64_to_cpup(ctx->afu->sw_command_status);
 		if (state == ~0ULL) {
 			pr_err("cxl: Error adding process element to AFU\n");
-			return -1;
+			rc = -1;
+			goto out;
 		}
 		if ((state & (CXL_SPA_SW_CMD_MASK | CXL_SPA_SW_STATE_MASK  | CXL_SPA_SW_LINK_MASK)) ==
 		    (cmd | (cmd >> 16) | ctx->pe))
@@ -310,7 +327,9 @@ static int do_process_element_cmd(struct cxl_context *ctx,
 		schedule();
 
 	}
-	return 0;
+out:
+	trace_cxl_llcmd_done(ctx, cmd, rc);
+	return rc;
 }
 
 static int add_process_element(struct cxl_context *ctx)
@@ -630,6 +649,8 @@ static inline int detach_process_native_afu_directed(struct cxl_context *ctx)
 
 int cxl_detach_process(struct cxl_context *ctx)
 {
+	trace_cxl_detach(ctx);
+
 	if (ctx->afu->current_mode == CXL_MODE_DEDICATED)
 		return detach_process_native_dedicated(ctx);
 
@@ -668,6 +689,7 @@ static void recover_psl_err(struct cxl_afu *afu, u64 errstat)
 
 int cxl_ack_irq(struct cxl_context *ctx, u64 tfc, u64 psl_reset_mask)
 {
+	trace_cxl_psl_irq_ack(ctx, tfc);
 	if (tfc)
 		cxl_p2n_write(ctx->afu, CXL_PSL_TFC_An, tfc);
 	if (psl_reset_mask)
diff --git a/drivers/misc/cxl/trace.c b/drivers/misc/cxl/trace.c
new file mode 100644
index 0000000..c2b06d3
--- /dev/null
+++ b/drivers/misc/cxl/trace.c
@@ -0,0 +1,13 @@
+/*
+ * Copyright 2015 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+#endif
diff --git a/drivers/misc/cxl/trace.h b/drivers/misc/cxl/trace.h
new file mode 100644
index 0000000..ae434d8
--- /dev/null
+++ b/drivers/misc/cxl/trace.h
@@ -0,0 +1,459 @@
+/*
+ * Copyright 2015 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cxl
+
+#if !defined(_CXL_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _CXL_TRACE_H
+
+#include <linux/tracepoint.h>
+
+#include "cxl.h"
+
+#define DSISR_FLAGS \
+	{ CXL_PSL_DSISR_An_DS,	"DS" }, \
+	{ CXL_PSL_DSISR_An_DM,	"DM" }, \
+	{ CXL_PSL_DSISR_An_ST,	"ST" }, \
+	{ CXL_PSL_DSISR_An_UR,	"UR" }, \
+	{ CXL_PSL_DSISR_An_PE,	"PE" }, \
+	{ CXL_PSL_DSISR_An_AE,	"AE" }, \
+	{ CXL_PSL_DSISR_An_OC,	"OC" }, \
+	{ CXL_PSL_DSISR_An_M,	"M" }, \
+	{ CXL_PSL_DSISR_An_P,	"P" }, \
+	{ CXL_PSL_DSISR_An_A,	"A" }, \
+	{ CXL_PSL_DSISR_An_S,	"S" }, \
+	{ CXL_PSL_DSISR_An_K,	"K" }
+
+#define TFC_FLAGS \
+	{ CXL_PSL_TFC_An_A,	"A" }, \
+	{ CXL_PSL_TFC_An_C,	"C" }, \
+	{ CXL_PSL_TFC_An_AE,	"AE" }, \
+	{ CXL_PSL_TFC_An_R,	"R" }
+
+#define LLCMD_NAMES \
+	{ CXL_SPA_SW_CMD_TERMINATE,	"TERMINATE" }, \
+	{ CXL_SPA_SW_CMD_REMOVE,	"REMOVE" }, \
+	{ CXL_SPA_SW_CMD_SUSPEND,	"SUSPEND" }, \
+	{ CXL_SPA_SW_CMD_RESUME,	"RESUME" }, \
+	{ CXL_SPA_SW_CMD_ADD,		"ADD" }, \
+	{ CXL_SPA_SW_CMD_UPDATE,	"UPDATE" }
+
+#define AFU_COMMANDS \
+	{ 0,			"DISABLE" }, \
+	{ CXL_AFU_Cntl_An_E,	"ENABLE" }, \
+	{ CXL_AFU_Cntl_An_RA,	"RESET" }
+
+#define PSL_COMMANDS \
+	{ CXL_PSL_SCNTL_An_Pc,	"PURGE" }, \
+	{ CXL_PSL_SCNTL_An_Sc,	"SUSPEND" }
+
+
+DECLARE_EVENT_CLASS(cxl_pe_class,
+	TP_PROTO(struct cxl_context *ctx),
+
+	TP_ARGS(ctx),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+	),
+
+	TP_printk("afu%i.%i pe=%i",
+		__entry->card,
+		__entry->afu,
+		__entry->pe
+	)
+);
+
+
+TRACE_EVENT(cxl_attach,
+	TP_PROTO(struct cxl_context *ctx, u64 wed, s16 num_interrupts, u64 amr),
+
+	TP_ARGS(ctx, wed, num_interrupts, amr),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(pid_t, pid)
+		__field(u64, wed)
+		__field(u64, amr)
+		__field(s16, num_interrupts)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->pid = pid_nr(ctx->pid);
+		__entry->wed = wed;
+		__entry->amr = amr;
+		__entry->num_interrupts = num_interrupts;
+	),
+
+	TP_printk("afu%i.%i pid=%i pe=%i wed=0x%.16llx irqs=%i amr=0x%llx",
+		__entry->card,
+		__entry->afu,
+		__entry->pid,
+		__entry->pe,
+		__entry->wed,
+		__entry->num_interrupts,
+		__entry->amr
+	)
+);
+
+DEFINE_EVENT(cxl_pe_class, cxl_detach,
+	TP_PROTO(struct cxl_context *ctx),
+	TP_ARGS(ctx)
+);
+
+TRACE_EVENT(cxl_afu_irq,
+	TP_PROTO(struct cxl_context *ctx, int afu_irq, int virq, irq_hw_number_t hwirq),
+
+	TP_ARGS(ctx, afu_irq, virq, hwirq),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(u16, afu_irq)
+		__field(int, virq)
+		__field(irq_hw_number_t, hwirq)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->afu_irq = afu_irq;
+		__entry->virq = virq;
+		__entry->hwirq = hwirq;
+	),
+
+	TP_printk("afu%i.%i pe=%i afu_irq=%i virq=%i hwirq=0x%lx",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__entry->afu_irq,
+		__entry->virq,
+		__entry->hwirq
+	)
+);
+
+TRACE_EVENT(cxl_psl_irq,
+	TP_PROTO(struct cxl_context *ctx, int irq, u64 dsisr, u64 dar),
+
+	TP_ARGS(ctx, irq, dsisr, dar),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(int, irq)
+		__field(u64, dsisr)
+		__field(u64, dar)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->irq = irq;
+		__entry->dsisr = dsisr;
+		__entry->dar = dar;
+	),
+
+	TP_printk("afu%i.%i pe=%i irq=%i dsisr=%s dar=0x%.16llx",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__entry->irq,
+		__print_flags(__entry->dsisr, "|", DSISR_FLAGS),
+		__entry->dar
+	)
+);
+
+TRACE_EVENT(cxl_psl_irq_ack,
+	TP_PROTO(struct cxl_context *ctx, u64 tfc),
+
+	TP_ARGS(ctx, tfc),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(u64, tfc)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->tfc = tfc;
+	),
+
+	TP_printk("afu%i.%i pe=%i tfc=%s",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__print_flags(__entry->tfc, "|", TFC_FLAGS)
+	)
+);
+
+TRACE_EVENT(cxl_ste_miss,
+	TP_PROTO(struct cxl_context *ctx, u64 dar),
+
+	TP_ARGS(ctx, dar),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(u64, dar)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->dar = dar;
+	),
+
+	TP_printk("afu%i.%i pe=%i dar=0x%.16llx",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__entry->dar
+	)
+);
+
+TRACE_EVENT(cxl_ste_write,
+	TP_PROTO(struct cxl_context *ctx, unsigned int idx, u64 e, u64 v),
+
+	TP_ARGS(ctx, idx, e, v),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(unsigned int, idx)
+		__field(u64, e)
+		__field(u64, v)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->idx = idx;
+		__entry->e = e;
+		__entry->v = v;
+	),
+
+	TP_printk("afu%i.%i pe=%i SSTE[%i] E=0x%.16llx V=0x%.16llx",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__entry->idx,
+		__entry->e,
+		__entry->v
+	)
+);
+
+TRACE_EVENT(cxl_pte_miss,
+	TP_PROTO(struct cxl_context *ctx, u64 dsisr, u64 dar),
+
+	TP_ARGS(ctx, dsisr, dar),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(u64, dsisr)
+		__field(u64, dar)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->dsisr = dsisr;
+		__entry->dar = dar;
+	),
+
+	TP_printk("afu%i.%i pe=%i dsisr=%s dar=0x%.16llx",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__print_flags(__entry->dsisr, "|", DSISR_FLAGS),
+		__entry->dar
+	)
+);
+
+TRACE_EVENT(cxl_llcmd,
+	TP_PROTO(struct cxl_context *ctx, u64 cmd),
+
+	TP_ARGS(ctx, cmd),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(u64, cmd)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->cmd = cmd;
+	),
+
+	TP_printk("afu%i.%i pe=%i cmd=%s",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__print_symbolic_u64(__entry->cmd, LLCMD_NAMES)
+	)
+);
+
+TRACE_EVENT(cxl_llcmd_done,
+	TP_PROTO(struct cxl_context *ctx, u64 cmd, int rc),
+
+	TP_ARGS(ctx, cmd, rc),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u16, pe)
+		__field(u64, cmd)
+		__field(int, rc)
+	),
+
+	TP_fast_assign(
+		__entry->card = ctx->afu->adapter->adapter_num;
+		__entry->afu = ctx->afu->slice;
+		__entry->pe = ctx->pe;
+		__entry->rc = rc;
+		__entry->cmd = cmd;
+	),
+
+	TP_printk("afu%i.%i pe=%i cmd=%s rc=%i",
+		__entry->card,
+		__entry->afu,
+		__entry->pe,
+		__print_symbolic_u64(__entry->cmd, LLCMD_NAMES),
+		__entry->rc
+	)
+);
+
+DECLARE_EVENT_CLASS(cxl_afu_psl_ctrl,
+	TP_PROTO(struct cxl_afu *afu, u64 cmd),
+
+	TP_ARGS(afu, cmd),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u64, cmd)
+	),
+
+	TP_fast_assign(
+		__entry->card = afu->adapter->adapter_num;
+		__entry->afu = afu->slice;
+		__entry->cmd = cmd;
+	),
+
+	TP_printk("afu%i.%i cmd=%s",
+		__entry->card,
+		__entry->afu,
+		__print_symbolic_u64(__entry->cmd, AFU_COMMANDS)
+	)
+);
+
+DECLARE_EVENT_CLASS(cxl_afu_psl_ctrl_done,
+	TP_PROTO(struct cxl_afu *afu, u64 cmd, int rc),
+
+	TP_ARGS(afu, cmd, rc),
+
+	TP_STRUCT__entry(
+		__field(u8, card)
+		__field(u8, afu)
+		__field(u64, cmd)
+		__field(int, rc)
+	),
+
+	TP_fast_assign(
+		__entry->card = afu->adapter->adapter_num;
+		__entry->afu = afu->slice;
+		__entry->rc = rc;
+		__entry->cmd = cmd;
+	),
+
+	TP_printk("afu%i.%i cmd=%s rc=%i",
+		__entry->card,
+		__entry->afu,
+		__print_symbolic_u64(__entry->cmd, AFU_COMMANDS),
+		__entry->rc
+	)
+);
+
+DEFINE_EVENT(cxl_afu_psl_ctrl, cxl_afu_ctrl,
+	TP_PROTO(struct cxl_afu *afu, u64 cmd),
+	TP_ARGS(afu, cmd)
+);
+
+DEFINE_EVENT(cxl_afu_psl_ctrl_done, cxl_afu_ctrl_done,
+	TP_PROTO(struct cxl_afu *afu, u64 cmd, int rc),
+	TP_ARGS(afu, cmd, rc)
+);
+
+DEFINE_EVENT_PRINT(cxl_afu_psl_ctrl, cxl_psl_ctrl,
+	TP_PROTO(struct cxl_afu *afu, u64 cmd),
+	TP_ARGS(afu, cmd),
+
+	TP_printk("psl%i.%i cmd=%s",
+		__entry->card,
+		__entry->afu,
+		__print_symbolic_u64(__entry->cmd, PSL_COMMANDS)
+	)
+);
+
+DEFINE_EVENT_PRINT(cxl_afu_psl_ctrl_done, cxl_psl_ctrl_done,
+	TP_PROTO(struct cxl_afu *afu, u64 cmd, int rc),
+	TP_ARGS(afu, cmd, rc),
+
+	TP_printk("psl%i.%i cmd=%s rc=%i",
+		__entry->card,
+		__entry->afu,
+		__print_symbolic_u64(__entry->cmd, PSL_COMMANDS),
+		__entry->rc
+	)
+);
+
+DEFINE_EVENT(cxl_pe_class, cxl_slbia,
+	TP_PROTO(struct cxl_context *ctx),
+	TP_ARGS(ctx)
+);
+
+#endif /* _CXL_TRACE_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 
2.1.4

