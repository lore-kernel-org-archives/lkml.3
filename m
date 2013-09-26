Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3IZLhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:37:01 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:44813 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3IZLg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:36:58 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/4] ARM: perf: add support for perf registers API
Date: Thu, 26 Sep 2013 13:36:35 +0200
Message-Id: <1380195398-4402-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

This patch implements the functions required for the perf registers API,
allowing the perf tool to interface kernel register dumps with libunwind
in order to provide userspace backtracing.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 arch/arm/Kconfig                      |  2 ++
 arch/arm/include/uapi/asm/Kbuild      |  1 +
 arch/arm/include/uapi/asm/perf_regs.h | 23 +++++++++++++++++++++++
 arch/arm/kernel/Makefile              |  1 +
 arch/arm/kernel/perf_regs.c           | 30 ++++++++++++++++++++++++++++++
 5 files changed, 57 insertions(+)
 create mode 100644 arch/arm/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm/kernel/perf_regs.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3f7714d..5595888 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -51,6 +51,8 @@ config ARM
 	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_PERF_EVENTS
+	select HAVE_PERF_REGS
+	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
diff --git a/arch/arm/include/uapi/asm/Kbuild b/arch/arm/include/uapi/asm/Kbuild
index 18d76fd..70a1c9d 100644
--- a/arch/arm/include/uapi/asm/Kbuild
+++ b/arch/arm/include/uapi/asm/Kbuild
@@ -7,6 +7,7 @@ header-y += hwcap.h
 header-y += ioctls.h
 header-y += kvm_para.h
 header-y += mman.h
+header-y += perf_regs.h
 header-y += posix_types.h
 header-y += ptrace.h
 header-y += setup.h
diff --git a/arch/arm/include/uapi/asm/perf_regs.h b/arch/arm/include/uapi/asm/perf_regs.h
new file mode 100644
index 0000000..ce59448
--- /dev/null
+++ b/arch/arm/include/uapi/asm/perf_regs.h
@@ -0,0 +1,23 @@
+#ifndef _ASM_ARM_PERF_REGS_H
+#define _ASM_ARM_PERF_REGS_H
+
+enum perf_event_arm_regs {
+	PERF_REG_ARM_R0,
+	PERF_REG_ARM_R1,
+	PERF_REG_ARM_R2,
+	PERF_REG_ARM_R3,
+	PERF_REG_ARM_R4,
+	PERF_REG_ARM_R5,
+	PERF_REG_ARM_R6,
+	PERF_REG_ARM_R7,
+	PERF_REG_ARM_R8,
+	PERF_REG_ARM_R9,
+	PERF_REG_ARM_R10,
+	PERF_REG_ARM_FP,
+	PERF_REG_ARM_IP,
+	PERF_REG_ARM_SP,
+	PERF_REG_ARM_LR,
+	PERF_REG_ARM_PC,
+	PERF_REG_ARM_MAX,
+};
+#endif /* _ASM_ARM_PERF_REGS_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5140df5f..9b818ca 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_CPU_XSC3)		+= xscale-cp0.o
 obj-$(CONFIG_CPU_MOHAWK)	+= xscale-cp0.o
 obj-$(CONFIG_CPU_PJ4)		+= pj4-cp0.o
 obj-$(CONFIG_IWMMXT)		+= iwmmxt.o
+obj-$(CONFIG_PERF_EVENTS)	+= perf_regs.o
 obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o perf_event_cpu.o
 AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
 obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
diff --git a/arch/arm/kernel/perf_regs.c b/arch/arm/kernel/perf_regs.c
new file mode 100644
index 0000000..6e4379c
--- /dev/null
+++ b/arch/arm/kernel/perf_regs.c
@@ -0,0 +1,30 @@
+
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
+	return regs->uregs[idx];
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
+	return PERF_SAMPLE_REGS_ABI_32;
+}
-- 
1.7.11.7

