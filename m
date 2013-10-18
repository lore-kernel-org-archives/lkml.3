Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3JROzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:55:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57728 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3JROzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:55:03 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo <acme@ghostprotocols.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Jean Pihet <jean.pihet@newoldbits.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/2] ARM64: perf: add support for perf registers API
Date: Fri, 18 Oct 2013 16:54:37 +0200
Message-Id: <1382108078-8807-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382108078-8807-1-git-send-email-jean.pihet@linaro.org>
References: <1382108078-8807-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@newoldbits.com>

This patch implements the functions required for the perf registers API,
allowing the perf tool to interface kernel register dumps with libunwind
in order to provide userspace backtracing.
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
 arch/arm64/include/uapi/asm/Kbuild      |  1 +
 arch/arm64/include/uapi/asm/perf_regs.h | 40 +++++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile              |  1 +
 arch/arm64/kernel/perf_regs.c           | 29 ++++++++++++++++++++++++
 5 files changed, 73 insertions(+)
 create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm64/kernel/perf_regs.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..9bb5bc0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -26,6 +26,8 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
+	select HAVE_PERF_REGS
+	select HAVE_PERF_USER_STACK_DUMP
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
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
index 0000000..06bf360
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/perf_regs.h
@@ -0,0 +1,40 @@
+#ifndef _ASM_ARM_PERF_REGS_H
+#define _ASM_ARM_PERF_REGS_H
+
+enum perf_event_arm_regs {
+	PERF_REG_ARM_X0,
+	PERF_REG_ARM_X1,
+	PERF_REG_ARM_X2,
+	PERF_REG_ARM_X3,
+	PERF_REG_ARM_X4,
+	PERF_REG_ARM_X5,
+	PERF_REG_ARM_X6,
+	PERF_REG_ARM_X7,
+	PERF_REG_ARM_X8,
+	PERF_REG_ARM_X9,
+	PERF_REG_ARM_X10,
+	PERF_REG_ARM_X11,
+	PERF_REG_ARM_X12,
+	PERF_REG_ARM_X13,
+	PERF_REG_ARM_X14,
+	PERF_REG_ARM_X15,
+	PERF_REG_ARM_X16,
+	PERF_REG_ARM_X17,
+	PERF_REG_ARM_X18,
+	PERF_REG_ARM_X19,
+	PERF_REG_ARM_X20,
+	PERF_REG_ARM_X21,
+	PERF_REG_ARM_X22,
+	PERF_REG_ARM_X23,
+	PERF_REG_ARM_X24,
+	PERF_REG_ARM_X25,
+	PERF_REG_ARM_X26,
+	PERF_REG_ARM_X27,
+	PERF_REG_ARM_X28,
+	PERF_REG_ARM_FP,
+	PERF_REG_ARM_LR,
+	PERF_REG_ARM_SP,
+	PERF_REG_ARM_PC,
+	PERF_REG_ARM_MAX,
+};
+#endif /* _ASM_ARM_PERF_REGS_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7b4b564..c42df09 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -15,6 +15,7 @@ arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o smp_psci.o
+arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
new file mode 100644
index 0000000..bbcf63c
--- /dev/null
+++ b/arch/arm64/kernel/perf_regs.c
@@ -0,0 +1,29 @@
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <linux/bug.h>
+#include <asm/perf_regs.h>
+#include <asm/ptrace.h>
+
+u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	if (WARN_ON_ONCE((u32)idx >= PERF_REG_ARM_MAX))
+		return 0;
+
+	return regs->regs[idx];
+}
+
+#define REG_RESERVED (~((1ULL << PERF_REG_ARM_MAX) - 1))
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
+	return PERF_SAMPLE_REGS_ABI_64;
+}
-- 
1.7.11.7

