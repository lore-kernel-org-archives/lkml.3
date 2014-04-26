Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaDZIkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:40:16 -0400
Received: from [119.145.14.65] ([119.145.14.65]:2423 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaDZIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:40:11 -0400
Message-ID: <535B707F.7020802@huawei.com>
Date: Sat, 26 Apr 2014 16:38:23 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul Mackerras" <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <oprofile-list@lists.sf.net>, Xinwei Hu <huxinwei@huawei.com>
Subject: [PATCH] arm64: add OProfile support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OProfile support for arm64,  using the perf backend, and failing back
to generic timer based sampling if PMU interrupt is not supported.

I have test this patch on Cortex-A53 and Cortex-A57 motherboard, the OProfile
could work well by PMU irq or arch timer irq.

Signed-off-by: Xinwei Hu <huxinwei@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/Makefile                 |   2 +
 arch/arm64/include/asm/stacktrace.h |   1 +
 arch/arm64/kernel/perf_event.c      |  13 ++++-
 arch/arm64/oprofile/Makefile        |  13 +++++
 arch/arm64/oprofile/common.c        | 106 ++++++++++++++++++++++++++++++++++++
 6 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/oprofile/Makefile
 create mode 100644 arch/arm64/oprofile/common.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..f711445 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -40,6 +40,7 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
 	select HAVE_PATA_PLATFORM
+	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2fceb71..6bb3d66 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -48,6 +48,8 @@ core-$(CONFIG_XEN) += arch/arm64/xen/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
+drivers-$(CONFIG_OPROFILE)      += arch/arm64/oprofile/
+
 # Default target when executing plain make
 KBUILD_IMAGE	:= Image.gz
 KBUILD_DTBS	:= dtbs
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 7318f6d..fec7e84 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -19,6 +19,7 @@
 struct stackframe {
 	unsigned long fp;
 	unsigned long sp;
+	unsigned long lr;
 	unsigned long pc;
 };
 
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index baf5afb..a8fd1c1 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -51,6 +51,15 @@ static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
 /* Set at runtime when we know what CPU type we are. */
 static struct arm_pmu *cpu_pmu;
 
+const char *perf_pmu_name(void)
+{
+	if (!cpu_pmu)
+		return NULL;
+
+	return cpu_pmu->name;
+}
+EXPORT_SYMBOL_GPL(perf_pmu_name);
+
 int
 armpmu_get_max_events(void)
 {
@@ -640,7 +649,7 @@ enum armv8_pmuv3_perf_types {
 	ARMV8_PMUV3_PERFCTR_L1_DCACHE_REFILL			= 0x03,
 	ARMV8_PMUV3_PERFCTR_L1_DCACHE_ACCESS			= 0x04,
 	ARMV8_PMUV3_PERFCTR_PC_BRANCH_MIS_PRED			= 0x10,
-	ARMV8_PMUV3_PERFCTR_CLOCK_CYCLES			= 0x11,
+	ARMV8_PMUV3_PERFCTR_CPU_CYCLES				= 0x11,
 	ARMV8_PMUV3_PERFCTR_PC_BRANCH_PRED			= 0x12,
 
 	/* At least one of the following is required. */
@@ -672,6 +681,8 @@ enum armv8_pmuv3_perf_types {
 	ARMV8_PMUV3_PERFCTR_BUS_ACCESS				= 0x19,
 	ARMV8_PMUV3_PERFCTR_MEM_ERROR				= 0x1A,
 	ARMV8_PMUV3_PERFCTR_BUS_CYCLES				= 0x1D,
+
+	ARMV8_PMUV3_PERFCTR_CLOCK_CYCLES			= 0XFF,
 };
 
 /* PMUv3 HW events mapping. */
diff --git a/arch/arm64/oprofile/Makefile b/arch/arm64/oprofile/Makefile
new file mode 100644
index 0000000..b2215c6
--- /dev/null
+++ b/arch/arm64/oprofile/Makefile
@@ -0,0 +1,13 @@
+obj-$(CONFIG_OPROFILE) += oprofile.o
+
+DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
+		oprof.o cpu_buffer.o buffer_sync.o \
+		event_buffer.o oprofile_files.o \
+		oprofilefs.o oprofile_stats.o \
+		timer_int.o )
+
+ifeq ($(CONFIG_HW_PERF_EVENTS),y)
+DRIVER_OBJS += $(addprefix ../../../drivers/oprofile/, oprofile_perf.o)
+endif
+
+oprofile-y				:= $(DRIVER_OBJS) common.o
diff --git a/arch/arm64/oprofile/common.c b/arch/arm64/oprofile/common.c
new file mode 100644
index 0000000..7d1c19c
--- /dev/null
+++ b/arch/arm64/oprofile/common.c
@@ -0,0 +1,106 @@
+/**
+ * @file common.c
+ *
+ * @remark Copyright 2004 Oprofile Authors
+ * @remark Copyright 2010 ARM Ltd.
+ * @remark Read the file COPYING
+ *
+ * @author Zwane Mwaikambo
+ * @author Will Deacon [move to perf]
+ */
+
+#include <linux/cpumask.h>
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/oprofile.h>
+#include <linux/perf_event.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <asm/stacktrace.h>
+#include <linux/uaccess.h>
+
+#include <asm/perf_event.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_HW_PERF_EVENTS
+
+char *op_name_from_perf_id(void)
+{
+	return perf_pmu_name();
+}
+#endif
+
+static int report_trace(struct stackframe *frame, void *d)
+{
+	unsigned int *depth = d;
+
+	if (*depth) {
+		oprofile_add_trace(frame->pc);
+		(*depth)--;
+	}
+
+	return *depth == 0;
+}
+
+/*
+ * The registers we're interested in are at the end of the variable
+ * length saved register structure. The fp points at the end of this
+ * structure so the address of this struct is:
+ * (struct frame_tail *)(xxx->fp)-1
+ */
+struct frame_tail {
+	struct frame_tail *fp;
+	unsigned long sp;
+	unsigned long lr;
+} __attribute__((packed));
+
+static struct frame_tail *user_backtrace(struct frame_tail *tail)
+{
+	struct frame_tail buftail[2];
+
+	/* Also check accessibility of one struct frame_tail beyond */
+	if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
+		return NULL;
+	if (__copy_from_user_inatomic(buftail, tail, sizeof(buftail)))
+		return NULL;
+
+	oprofile_add_trace(buftail[0].lr);
+
+	/* frame pointers should strictly progress back up the stack
+	 * (towards higher addresses) */
+	if (tail + 1 >= buftail[0].fp)
+		return NULL;
+
+	return buftail[0].fp-1;
+}
+
+static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
+{
+	struct frame_tail *tail = ((struct frame_tail *) regs->regs[29]) - 1;
+
+	if (!user_mode(regs)) {
+		struct stackframe frame;
+		frame.fp = regs->regs[29];
+		frame.sp = regs->sp;
+		frame.lr = regs->regs[30];
+		frame.pc = regs->pc;
+		walk_stackframe(&frame, report_trace, &depth);
+		return;
+	}
+
+	while (depth-- && tail && !((unsigned long) tail & 3))
+		tail = user_backtrace(tail);
+}
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	/* provide backtrace support also in timer mode: */
+	ops->backtrace		= arm_backtrace;
+
+	return oprofile_perf_init(ops);
+}
+
+void oprofile_arch_exit(void)
+{
+	oprofile_perf_exit();
+}
-- 
1.8.0


