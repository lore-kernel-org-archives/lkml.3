Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3CONov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:44:51 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34616 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3CONoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:38 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Robert Richter <rric@kernel.org>,
        <oprofile-list@lists.sf.net>
Subject: [PATCH 9/9] metag: OProfile support
Date: Fri, 15 Mar 2013 13:43:48 +0000
Message-ID: <1363355028-23278-10-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OProfile support for metag, using the perf backend, and falling back
to generic timer based sampling if perf counter interrupt support is
disabled.

The oprofile code prepends "metag/" to the perf pmu name to give
"metag/meta2" which is more consistent with other oprofile arch names.

The backtrace code makes use of <asm/stacktrace.h> for kernel
backtracing, and a simple frame pointer walk for userland backtracing.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net
---
 arch/metag/Kconfig              |  4 +++
 arch/metag/Makefile             |  2 ++
 arch/metag/oprofile/Makefile    | 17 +++++++++++
 arch/metag/oprofile/backtrace.c | 63 +++++++++++++++++++++++++++++++++++++++
 arch/metag/oprofile/backtrace.h |  6 ++++
 arch/metag/oprofile/common.c    | 66 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 158 insertions(+)
 create mode 100644 arch/metag/oprofile/Makefile
 create mode 100644 arch/metag/oprofile/backtrace.c
 create mode 100644 arch/metag/oprofile/backtrace.h
 create mode 100644 arch/metag/oprofile/common.c

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index afc8973..b06b418 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -25,6 +25,7 @@ config METAG
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_DOMAIN
@@ -209,6 +210,9 @@ config METAG_PERFCOUNTER_IRQS
 	  When disabled, Performance Counters information will be collected
 	  based on Timer Interrupt.
 
+config HW_PERF_EVENTS
+	def_bool METAG_PERFCOUNTER_IRQS && PERF_EVENTS
+
 config METAG_DA
 	bool "DA support"
 	help
diff --git a/arch/metag/Makefile b/arch/metag/Makefile
index 81bd6a1..b566116 100644
--- a/arch/metag/Makefile
+++ b/arch/metag/Makefile
@@ -49,6 +49,8 @@ core-y					+= arch/metag/mm/
 libs-y					+= arch/metag/lib/
 libs-y					+= arch/metag/tbx/
 
+drivers-$(CONFIG_OPROFILE)		+= arch/metag/oprofile/
+
 boot					:= arch/metag/boot
 
 boot_targets				+= uImage
diff --git a/arch/metag/oprofile/Makefile b/arch/metag/oprofile/Makefile
new file mode 100644
index 0000000..c9639d4
--- /dev/null
+++ b/arch/metag/oprofile/Makefile
@@ -0,0 +1,17 @@
+obj-$(CONFIG_OPROFILE)	+= oprofile.o
+
+oprofile-core-y	+= buffer_sync.o
+oprofile-core-y	+= cpu_buffer.o
+oprofile-core-y	+= event_buffer.o
+oprofile-core-y	+= oprof.o
+oprofile-core-y	+= oprofile_files.o
+oprofile-core-y	+= oprofile_stats.o
+oprofile-core-y	+= oprofilefs.o
+oprofile-core-y	+= timer_int.o
+oprofile-core-$(CONFIG_HW_PERF_EVENTS)	+= oprofile_perf.o
+
+oprofile-y	+= backtrace.o
+oprofile-y	+= common.o
+oprofile-y	+= $(addprefix ../../../drivers/oprofile/,$(oprofile-core-y))
+
+ccflags-y	+= -Werror
diff --git a/arch/metag/oprofile/backtrace.c b/arch/metag/oprofile/backtrace.c
new file mode 100644
index 0000000..7cc3f37
--- /dev/null
+++ b/arch/metag/oprofile/backtrace.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) 2010-2013 Imagination Technologies Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/oprofile.h>
+#include <linux/uaccess.h>
+#include <asm/processor.h>
+#include <asm/stacktrace.h>
+
+#include "backtrace.h"
+
+static void user_backtrace_fp(unsigned long __user *fp, unsigned int depth)
+{
+	while (depth-- && access_ok(VERIFY_READ, fp, 8)) {
+		unsigned long addr;
+		unsigned long __user *fpnew;
+		if (__copy_from_user_inatomic(&addr, fp + 1, sizeof(addr)))
+			break;
+		addr -= 4;
+
+		oprofile_add_trace(addr);
+
+		/* stack grows up, so frame pointers must decrease */
+		if (__copy_from_user_inatomic(&fpnew, fp + 0, sizeof(fpnew)))
+			break;
+		if (fpnew >= fp)
+			break;
+		fp = fpnew;
+	}
+}
+
+static int kernel_backtrace_frame(struct stackframe *frame, void *data)
+{
+	unsigned int *depth = data;
+
+	oprofile_add_trace(frame->pc);
+
+	/* decrement depth and stop if we reach 0 */
+	if ((*depth)-- == 0)
+		return 1;
+
+	/* otherwise onto the next frame */
+	return 0;
+}
+
+void metag_backtrace(struct pt_regs * const regs, unsigned int depth)
+{
+	if (user_mode(regs)) {
+		unsigned long *fp = (unsigned long *)regs->ctx.AX[1].U0;
+		user_backtrace_fp((unsigned long __user __force *)fp, depth);
+	} else {
+		struct stackframe frame;
+		frame.fp = regs->ctx.AX[1].U0;		/* A0FrP */
+		frame.sp = user_stack_pointer(regs);	/* A0StP */
+		frame.lr = 0;				/* from stack */
+		frame.pc = regs->ctx.CurrPC;		/* PC */
+		walk_stackframe(&frame, &kernel_backtrace_frame, &depth);
+	}
+}
diff --git a/arch/metag/oprofile/backtrace.h b/arch/metag/oprofile/backtrace.h
new file mode 100644
index 0000000..c0fcc42
--- /dev/null
+++ b/arch/metag/oprofile/backtrace.h
@@ -0,0 +1,6 @@
+#ifndef _METAG_OPROFILE_BACKTRACE_H
+#define _METAG_OPROFILE_BACKTRACE_H
+
+void metag_backtrace(struct pt_regs * const regs, unsigned int depth);
+
+#endif
diff --git a/arch/metag/oprofile/common.c b/arch/metag/oprofile/common.c
new file mode 100644
index 0000000..ba26152
--- /dev/null
+++ b/arch/metag/oprofile/common.c
@@ -0,0 +1,66 @@
+/*
+ * arch/metag/oprofile/common.c
+ *
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * Based on arch/sh/oprofile/common.c:
+ *
+ * Copyright (C) 2003 - 2010  Paul Mundt
+ *
+ * Based on arch/mips/oprofile/common.c:
+ *
+ *	Copyright (C) 2004, 2005 Ralf Baechle
+ *	Copyright (C) 2005 MIPS Technologies, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/oprofile.h>
+#include <linux/perf_event.h>
+#include <linux/slab.h>
+
+#include "backtrace.h"
+
+#ifdef CONFIG_HW_PERF_EVENTS
+/*
+ * This will need to be reworked when multiple PMUs are supported.
+ */
+static char *metag_pmu_op_name;
+
+char *op_name_from_perf_id(void)
+{
+	return metag_pmu_op_name;
+}
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	ops->backtrace = metag_backtrace;
+
+	if (perf_num_counters() == 0)
+		return -ENODEV;
+
+	metag_pmu_op_name = kasprintf(GFP_KERNEL, "metag/%s",
+				      perf_pmu_name());
+	if (unlikely(!metag_pmu_op_name))
+		return -ENOMEM;
+
+	return oprofile_perf_init(ops);
+}
+
+void oprofile_arch_exit(void)
+{
+	oprofile_perf_exit();
+	kfree(metag_pmu_op_name);
+}
+#else
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	ops->backtrace = metag_backtrace;
+	/* fall back to timer interrupt PC sampling */
+	return -ENODEV;
+}
+void oprofile_arch_exit(void) {}
+#endif /* CONFIG_HW_PERF_EVENTS */
-- 
1.8.1.2


