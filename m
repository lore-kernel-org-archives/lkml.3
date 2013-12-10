Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3LJQHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:07:33 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40456 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3LJQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:07:32 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v6 1/7] arm64: introduce basic aarch64 instruction decoding helpers
Date: Wed, 11 Dec 2013 00:03:47 +0800
Message-Id: <1386691433-6827-2-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce basic aarch64 instruction decoding helper
aarch64_get_insn_class() and aarch64_insn_hotpatch_safe().

Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/include/asm/insn.h | 77 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile    |  2 +-
 arch/arm64/kernel/insn.c      | 91 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/insn.h
 create mode 100644 arch/arm64/kernel/insn.c

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
new file mode 100644
index 0000000..1bdc44c
--- /dev/null
+++ b/arch/arm64/include/asm/insn.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2013 Huawei Ltd.
+ * Author: Jiang Liu <liuj97@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef	__ASM_INSN_H
+#define	__ASM_INSN_H
+#include <linux/types.h>
+
+/*
+ * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
+ * Section C3.1 "A64 instruction index by encoding":
+ * AArch64 main encoding table
+ *  Bit position
+ *   28 27 26 25	Encoding Group
+ *   0  0  -  -		Unallocated
+ *   1  0  0  -		Data processing, immediate
+ *   1  0  1  -		Branch, exception generation and system instructions
+ *   -  1  -  0		Loads and stores
+ *   -  1  0  1		Data processing - register
+ *   0  1  1  1		Data processing - SIMD and floating point
+ *   1  1  1  1		Data processing - SIMD and floating point
+ * "-" means "don't care"
+ */
+enum aarch64_insn_encoding_class {
+	AARCH64_INSN_CLS_UNKNOWN,	/* UNALLOCATED */
+	AARCH64_INSN_CLS_DP_IMM,	/* Data processing - immediate */
+	AARCH64_INSN_CLS_DP_REG,	/* Data processing - register */
+	AARCH64_INSN_CLS_DP_FPSIMD,	/* Data processing - SIMD and FP */
+	AARCH64_INSN_CLS_LDST,		/* Loads and stores */
+	AARCH64_INSN_CLS_BR_SYS,	/* Branch, exception generation and
+					 * system instructions */
+};
+
+enum aarch64_insn_hint_op {
+	AARCH64_INSN_HINT_NOP	= 0x0 << 5,
+	AARCH64_INSN_HINT_YIELD	= 0x1 << 5,
+	AARCH64_INSN_HINT_WFE	= 0x2 << 5,
+	AARCH64_INSN_HINT_WFI	= 0x3 << 5,
+	AARCH64_INSN_HINT_SEV	= 0x4 << 5,
+	AARCH64_INSN_HINT_SEVL	= 0x5 << 5,
+};
+
+#define	__AARCH64_INSN_FUNCS(abbr, mask, val)	\
+static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
+{ return (code & (mask)) == (val); } \
+static __always_inline u32 aarch64_insn_get_##abbr##_value(void) \
+{ return (val); }
+
+__AARCH64_INSN_FUNCS(b,		0xFC000000, 0x14000000)
+__AARCH64_INSN_FUNCS(bl,	0xFC000000, 0x94000000)
+__AARCH64_INSN_FUNCS(svc,	0xFFE0001F, 0xD4000001)
+__AARCH64_INSN_FUNCS(hvc,	0xFFE0001F, 0xD4000002)
+__AARCH64_INSN_FUNCS(smc,	0xFFE0001F, 0xD4000003)
+__AARCH64_INSN_FUNCS(brk,	0xFFE0001F, 0xD4200000)
+__AARCH64_INSN_FUNCS(hint,	0xFFFFF01F, 0xD503201F)
+
+#undef	__AARCH64_INSN_FUNCS
+
+bool aarch64_insn_is_nop(u32 insn);
+
+enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
+
+bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
+
+#endif	/* __ASM_INSN_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 5ba2fd4..cd95a25 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -9,7 +9,7 @@ AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
-			   hyp-stub.o psci.o cpu_ops.o
+			   hyp-stub.o psci.o cpu_ops.o insn.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
new file mode 100644
index 0000000..56a2498
--- /dev/null
+++ b/arch/arm64/kernel/insn.c
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2013 Huawei Ltd.
+ * Author: Jiang Liu <liuj97@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <asm/insn.h>
+
+static int aarch64_insn_encoding_class[] = {
+	AARCH64_INSN_CLS_UNKNOWN,
+	AARCH64_INSN_CLS_UNKNOWN,
+	AARCH64_INSN_CLS_UNKNOWN,
+	AARCH64_INSN_CLS_UNKNOWN,
+	AARCH64_INSN_CLS_LDST,
+	AARCH64_INSN_CLS_DP_REG,
+	AARCH64_INSN_CLS_LDST,
+	AARCH64_INSN_CLS_DP_FPSIMD,
+	AARCH64_INSN_CLS_DP_IMM,
+	AARCH64_INSN_CLS_DP_IMM,
+	AARCH64_INSN_CLS_BR_SYS,
+	AARCH64_INSN_CLS_BR_SYS,
+	AARCH64_INSN_CLS_LDST,
+	AARCH64_INSN_CLS_DP_REG,
+	AARCH64_INSN_CLS_LDST,
+	AARCH64_INSN_CLS_DP_FPSIMD,
+};
+
+enum aarch64_insn_encoding_class __kprobes aarch64_get_insn_class(u32 insn)
+{
+	return aarch64_insn_encoding_class[(insn >> 25) & 0xf];
+}
+
+/* NOP is an alias of HINT */
+bool __kprobes aarch64_insn_is_nop(u32 insn)
+{
+	if (!aarch64_insn_is_hint(insn))
+		return false;
+
+	switch (insn & 0xFE0) {
+	case AARCH64_INSN_HINT_YIELD:
+	case AARCH64_INSN_HINT_WFE:
+	case AARCH64_INSN_HINT_WFI:
+	case AARCH64_INSN_HINT_SEV:
+	case AARCH64_INSN_HINT_SEVL:
+		return false;
+	default:
+		return true;
+	}
+}
+
+static bool __kprobes __aarch64_insn_hotpatch_safe(u32 insn)
+{
+	if (aarch64_get_insn_class(insn) != AARCH64_INSN_CLS_BR_SYS)
+		return false;
+
+	return	aarch64_insn_is_b(insn) ||
+		aarch64_insn_is_bl(insn) ||
+		aarch64_insn_is_svc(insn) ||
+		aarch64_insn_is_hvc(insn) ||
+		aarch64_insn_is_smc(insn) ||
+		aarch64_insn_is_brk(insn) ||
+		aarch64_insn_is_nop(insn);
+}
+
+/*
+ * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
+ * Section B2.6.5 "Concurrent modification and execution of instructions":
+ * Concurrent modification and execution of instructions can lead to the
+ * resulting instruction performing any behavior that can be achieved by
+ * executing any sequence of instructions that can be executed from the
+ * same Exception level, except where the instruction before modification
+ * and the instruction after modification is a B, BL, NOP, BKPT, SVC, HVC,
+ * or SMC instruction.
+ */
+bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
+{
+	return __aarch64_insn_hotpatch_safe(old_insn) &&
+	       __aarch64_insn_hotpatch_safe(new_insn);
+}
-- 
1.8.1.2

