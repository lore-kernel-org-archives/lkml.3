Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaCFEmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:42:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59771 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaCFEmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:42:18 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 1/3] power: perf: Enable saving the user stack in a sample.
Date: Wed,  5 Mar 2014 20:41:57 -0800
Message-Id: <1394080919-17957-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030604-1542-0000-0000-00000024F85E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requested, have the kernel save the user stack in each perf sample
so 'perf report' can use libunwind and produce better backtraces.

The downside of course is that the kernel has to copy the user-stack
on each sample which has both performance and file-size implications
(of the perf.data file).

But we save the user-stack only when user explicitly requests it:

	perf record --call-graph=dwarf,8192 <application>

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig                      |    2 +
 arch/powerpc/include/uapi/asm/perf_regs.h |   70 +++++++++++++++++++
 arch/powerpc/perf/Makefile                |    1 +
 arch/powerpc/perf/perf-regs.c             |  104 +++++++++++++++++++++++++++++
 4 files changed, 177 insertions(+)
 create mode 100644 arch/powerpc/include/uapi/asm/perf_regs.h
 create mode 100644 arch/powerpc/perf/perf-regs.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 957bf34..e79ce6e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -113,6 +113,8 @@ config PPC
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_PERF_EVENTS
+	select HAVE_PERF_REGS
+	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/powerpc/include/uapi/asm/perf_regs.h b/arch/powerpc/include/uapi/asm/perf_regs.h
new file mode 100644
index 0000000..b6120dc
--- /dev/null
+++ b/arch/powerpc/include/uapi/asm/perf_regs.h
@@ -0,0 +1,70 @@
+#ifndef _ASM_POWERPC_PERF_REGS_H
+#define _ASM_POWERPC_PERF_REGS_H
+
+#ifndef __powerpc64__
+#error Support for 32bit processors is TBD.
+#endif
+
+enum perf_event_powerpc_regs {
+	/*
+	 * The order of these values are based on the corresponding
+	 * macros in arch/powerpc/include/uapi/asm/ptrace.h .
+	 */
+	PERF_REG_POWERPC_GPR0,
+	PERF_REG_POWERPC_GPR1,
+	PERF_REG_POWERPC_GPR2,
+	PERF_REG_POWERPC_GPR3,
+	PERF_REG_POWERPC_GPR4,
+	PERF_REG_POWERPC_GPR5,
+	PERF_REG_POWERPC_GPR6,
+	PERF_REG_POWERPC_GPR7,
+	PERF_REG_POWERPC_GPR8,
+	PERF_REG_POWERPC_GPR9,
+
+	PERF_REG_POWERPC_GPR10,
+	PERF_REG_POWERPC_GPR11,
+	PERF_REG_POWERPC_GPR12,
+	PERF_REG_POWERPC_GPR13,
+	PERF_REG_POWERPC_GPR14,
+	PERF_REG_POWERPC_GPR15,
+	PERF_REG_POWERPC_GPR16,
+	PERF_REG_POWERPC_GPR17,
+	PERF_REG_POWERPC_GPR18,
+	PERF_REG_POWERPC_GPR19,
+
+	PERF_REG_POWERPC_GPR20,
+	PERF_REG_POWERPC_GPR21,
+	PERF_REG_POWERPC_GPR22,
+	PERF_REG_POWERPC_GPR23,
+	PERF_REG_POWERPC_GPR24,
+	PERF_REG_POWERPC_GPR25,
+	PERF_REG_POWERPC_GPR26,
+	PERF_REG_POWERPC_GPR27,
+	PERF_REG_POWERPC_GPR28,
+	PERF_REG_POWERPC_GPR29,
+
+	PERF_REG_POWERPC_GPR30,
+	PERF_REG_POWERPC_GPR31,
+
+	PERF_REG_POWERPC_NIP,
+	PERF_REG_POWERPC_MSR,
+	PERF_REG_POWERPC_ORIG_GPR3,
+	PERF_REG_POWERPC_CTR,		/* 35 */
+
+	PERF_REG_POWERPC_LINK,
+	PERF_REG_POWERPC_XER,
+	PERF_REG_POWERPC_CCR,
+#ifdef __powerpc64__
+	PERF_REG_POWERPC_SOFTE,
+#else
+	PERF_REG_POWERPC_MQ, 
+#endif
+	PERF_REG_POWERPC_TRAP,		/* 40 */
+
+	PERF_REG_POWERPC_DAR,
+	PERF_REG_POWERPC_DSISR,
+	PERF_REG_POWERPC_RESULT,
+	PERF_REG_POWERPC_DSCR,
+	PERF_REG_POWERPC_MAX
+};
+#endif
diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 60d71ee..44fec45 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -2,6 +2,7 @@ subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 obj-$(CONFIG_PERF_EVENTS)	+= callchain.o
 
+obj-$(CONFIG_HAVE_PERF_REGS)	+= perf-regs.o
 obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o bhrb.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o \
diff --git a/arch/powerpc/perf/perf-regs.c b/arch/powerpc/perf/perf-regs.c
new file mode 100644
index 0000000..3963038
--- /dev/null
+++ b/arch/powerpc/perf/perf-regs.c
@@ -0,0 +1,104 @@
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <asm/perf_regs.h>
+
+#define PT_REGS_GPR_OFFSET(g)	\
+	[PERF_REG_POWERPC_GPR##g] = offsetof(struct pt_regs, gpr[g])
+
+#define PT_REGS_OFFSET(n, r) 	\
+	[PERF_REG_POWERPC_##n] = offsetof(struct pt_regs, r)
+
+/*
+ * An enum in arch/powerpc/include/uapi/asm/perf_regs.h assigns an "id" to
+ * each register in Power. Build a table mapping each register id to its
+ * offset in 'struct pt_regs', that we can use to quickly read-from or
+ * write-to the register in pt_regs.
+ */
+static unsigned int pt_regs_offset[PERF_REG_POWERPC_MAX] = {
+	PT_REGS_GPR_OFFSET(0),
+	PT_REGS_GPR_OFFSET(1),
+	PT_REGS_GPR_OFFSET(2),
+	PT_REGS_GPR_OFFSET(3),
+	PT_REGS_GPR_OFFSET(4),
+	PT_REGS_GPR_OFFSET(5),
+	PT_REGS_GPR_OFFSET(6),
+	PT_REGS_GPR_OFFSET(7),
+	PT_REGS_GPR_OFFSET(8),
+	PT_REGS_GPR_OFFSET(9),
+	PT_REGS_GPR_OFFSET(10),
+
+	PT_REGS_GPR_OFFSET(11),
+	PT_REGS_GPR_OFFSET(12),
+	PT_REGS_GPR_OFFSET(13),
+	PT_REGS_GPR_OFFSET(14),
+	PT_REGS_GPR_OFFSET(15),
+	PT_REGS_GPR_OFFSET(16),
+	PT_REGS_GPR_OFFSET(17),
+	PT_REGS_GPR_OFFSET(18),
+	PT_REGS_GPR_OFFSET(19),
+	PT_REGS_GPR_OFFSET(20),
+
+	PT_REGS_GPR_OFFSET(21),
+	PT_REGS_GPR_OFFSET(22),
+	PT_REGS_GPR_OFFSET(23),
+	PT_REGS_GPR_OFFSET(24),
+	PT_REGS_GPR_OFFSET(25),
+	PT_REGS_GPR_OFFSET(26),
+	PT_REGS_GPR_OFFSET(27),
+	PT_REGS_GPR_OFFSET(28),
+	PT_REGS_GPR_OFFSET(29),
+	PT_REGS_GPR_OFFSET(30),
+
+	PT_REGS_GPR_OFFSET(31),
+
+	PT_REGS_OFFSET(NIP, nip),
+	PT_REGS_OFFSET(MSR, msr),
+	PT_REGS_OFFSET(ORIG_GPR3, orig_gpr3),
+	PT_REGS_OFFSET(CTR, ctr),
+
+	PT_REGS_OFFSET(LINK, link),
+	PT_REGS_OFFSET(XER, xer),
+	PT_REGS_OFFSET(CCR, ccr),
+#ifdef __powerpc64__
+	PT_REGS_OFFSET(SOFTE, softe),
+#else
+	PT_REGS_OFFSET(MQ, mq),
+#endif
+
+	PT_REGS_OFFSET(TRAP, trap),
+	PT_REGS_OFFSET(DAR, dar),
+	PT_REGS_OFFSET(DSISR, dsisr),
+	PT_REGS_OFFSET(RESULT, result),
+};
+
+u64 perf_reg_value(struct pt_regs *regs, int idx)
+{
+	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(pt_regs_offset)))
+		return 0;
+
+	return regs_get_register(regs, pt_regs_offset[idx]);
+}
+
+u64 perf_reg_validate(u64 mask)
+{
+	/*
+	 * TODO: Are there any registers to ignore/check here ?
+	 */
+	if (!mask)
+		return -EINVAL;
+
+	return 0;
+}
+
+u64 perf_reg_abi(struct task_struct *task)
+{
+	/*
+	 * TODO: WHAT SHOULD WE RETURN HERE ????
+	 *
+	 * 	x86 returns PERF_SAMPLE_REGS_ABI_32
+	 * 	perf tool needs this to be non-zero to process registers.
+	 */
+        return 1;
+}
-- 
1.7.9.5

