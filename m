Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaAVOLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:11:42 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53944 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaAVOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:11:36 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@newoldbits.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/4] ARM64: perf: add support for perf registers API
Date: Wed, 22 Jan 2014 15:11:16 +0100
Message-Id: <1390399879-5109-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390399879-5109-1-git-send-email-jean.pihet@linaro.org>
References: <1390399879-5109-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@newoldbits.com>

This patch implements the functions required for the perf registers API,
allowing the perf tool to interface kernel register dumps with libunwind
in order to provide userspace backtracing.
Compat mode is also supported.

Only the general purpose user space registers are exported, i.e.:
 PERF_REG_ARM_X0,
 ...
 PERF_REG_ARM_X28,
 PERF_REG_ARM_FP,
 PERF_REG_ARM_LR,
 PERF_REG_ARM_SP,
 PERF_REG_ARM_PC
and not the PERF_REG_ARM_V* registers.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig                      |  2 ++
 arch/arm64/include/asm/ptrace.h         |  1 +
 arch/arm64/include/uapi/asm/Kbuild      |  1 +
 arch/arm64/include/uapi/asm/perf_regs.h | 40 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile              |  1 +
 arch/arm64/kernel/perf_regs.c           | 44 +++++++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+)
 create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm64/kernel/perf_regs.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index dd4327f..e9899bb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -37,6 +37,8 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
+	select HAVE_PERF_REGS
+	select HAVE_PERF_USER_STACK_DUMP
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 0e7fa49..fbb0020 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -68,6 +68,7 @@
 
 /* Architecturally defined mapping between AArch32 and AArch64 registers */
 #define compat_usr(x)	regs[(x)]
+#define compat_fp	regs[11]
 #define compat_sp	regs[13]
 #define compat_lr	regs[14]
 #define compat_sp_hyp	regs[15]
diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
index e4b78bd..942376d 100644
--- a/arch/arm64/include/uapi/asm/Kbuild
+++ b/arch/arm64/include/uapi/asm/Kbuild
@@ -9,6 +9,7 @@ header-y += byteorder.h
 header-y += fcntl.h
 header-y += hwcap.h
 header-y += kvm_para.h
+header-y += perf_regs.h
 header-y += param.h
 header-y += ptrace.h
 header-y += setup.h
diff --git a/arch/arm64/include/uapi/asm/perf_regs.h b/arch/arm64/include/uapi/asm/perf_regs.h
new file mode 100644
index 0000000..172b831
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/perf_regs.h
@@ -0,0 +1,40 @@
+#ifndef _ASM_ARM64_PERF_REGS_H
+#define _ASM_ARM64_PERF_REGS_H
+
+enum perf_event_arm_regs {
+	PERF_REG_ARM64_X0,
+	PERF_REG_ARM64_X1,
+	PERF_REG_ARM64_X2,
+	PERF_REG_ARM64_X3,
+	PERF_REG_ARM64_X4,
+	PERF_REG_ARM64_X5,
+	PERF_REG_ARM64_X6,
+	PERF_REG_ARM64_X7,
+	PERF_REG_ARM64_X8,
+	PERF_REG_ARM64_X9,
+	PERF_REG_ARM64_X10,
+	PERF_REG_ARM64_X11,
+	PERF_REG_ARM64_X12,
+	PERF_REG_ARM64_X13,
+	PERF_REG_ARM64_X14,
+	PERF_REG_ARM64_X15,
+	PERF_REG_ARM64_X16,
+	PERF_REG_ARM64_X17,
+	PERF_REG_ARM64_X18,
+	PERF_REG_ARM64_X19,
+	PERF_REG_ARM64_X20,
+	PERF_REG_ARM64_X21,
+	PERF_REG_ARM64_X22,
+	PERF_REG_ARM64_X23,
+	PERF_REG_ARM64_X24,
+	PERF_REG_ARM64_X25,
+	PERF_REG_ARM64_X26,
+	PERF_REG_ARM64_X27,
+	PERF_REG_ARM64_X28,
+	PERF_REG_ARM64_X29,
+	PERF_REG_ARM64_LR,
+	PERF_REG_ARM64_SP,
+	PERF_REG_ARM64_PC,
+	PERF_REG_ARM64_MAX,
+};
+#endif /* _ASM_ARM64_PERF_REGS_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2d4554b..9a5d592 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -15,6 +15,7 @@ arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
+arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
new file mode 100644
index 0000000..f2d6f0a
--- /dev/null
+++ b/arch/arm64/kernel/perf_regs.c
@@ -0,0 +1,44 @@
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <linux/bug.h>
+#include <asm/perf_regs.h>
+#include <asm/ptrace.h>
+
+u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	if (WARN_ON_ONCE((u32)idx >= PERF_REG_ARM64_MAX))
+		return 0;
+
+	/*
+	 * Compat (i.e. 32 bit) mode:
+	 * - PC has been set in the pt_regs struct in kernel_entry,
+	 * - Handle SP and LR here.
+	 */
+	if (compat_user_mode(regs)) {
+		if ((u32)idx == PERF_REG_ARM64_SP)
+			return regs->compat_sp;
+		if ((u32)idx == PERF_REG_ARM64_LR)
+			return regs->compat_lr;
+	}
+
+	return regs->regs[idx];
+}
+
+#define REG_RESERVED (~((1ULL << PERF_REG_ARM64_MAX) - 1))
+
+int perf_reg_validate(u64 mask)
+{
+	if (!mask || mask & REG_RESERVED)
+		return -EINVAL;
+
+	return 0;
+}
+
+u64 perf_reg_abi(struct task_struct *task)
+{
+	if (is_compat_thread(task_thread_info(task)))
+		return PERF_SAMPLE_REGS_ABI_32;
+	else
+		return PERF_SAMPLE_REGS_ABI_64;
+}
-- 
1.7.11.7

