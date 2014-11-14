Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152AbaKNPyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:54:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63797 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964875AbaKNPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:54:42 -0500
From: Andre Przywara <andre.przywara@arm.com>
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] arm64: add alternative runtime patching
Date: Fri, 14 Nov 2014 15:54:08 +0000
Message-Id: <1415980452-20366-3-git-send-email-andre.przywara@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
References: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a blatant copy of some x86 bits we introduce the alternative
runtime patching "framework" to arm64.
This is quite basic for now and we only provide the functions we need
at this time.
This is connected to the newly introduced feature bits.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/include/asm/alternative-asm.h |   16 ++++++++
 arch/arm64/include/asm/alternative.h     |   43 ++++++++++++++++++++
 arch/arm64/kernel/Makefile               |    2 +-
 arch/arm64/kernel/alternative.c          |   64 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c                  |    2 +
 arch/arm64/kernel/vmlinux.lds.S          |   11 +++++
 arch/arm64/mm/init.c                     |    2 +
 7 files changed, 139 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/alternative-asm.h
 create mode 100644 arch/arm64/include/asm/alternative.h
 create mode 100644 arch/arm64/kernel/alternative.c

diff --git a/arch/arm64/include/asm/alternative-asm.h b/arch/arm64/include/asm/alternative-asm.h
new file mode 100644
index 0000000..5ee9340
--- /dev/null
+++ b/arch/arm64/include/asm/alternative-asm.h
@@ -0,0 +1,16 @@
+#ifndef __ASM_ALTERNATIVE_ASM_H
+#define __ASM_ALTERNATIVE_ASM_H
+
+#ifdef __ASSEMBLY__
+
+.macro altinstruction_entry orig_offset alt_offset feature orig_len alt_len
+	.word \orig_offset - .
+	.word \alt_offset - .
+	.hword \feature
+	.byte \orig_len
+	.byte \alt_len
+.endm
+
+#endif  /*  __ASSEMBLY__  */
+
+#endif /* __ASM_ALTERNATIVE_ASM_H */
diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
new file mode 100644
index 0000000..f6d206e
--- /dev/null
+++ b/arch/arm64/include/asm/alternative.h
@@ -0,0 +1,43 @@
+#ifndef __ASM_ALTERNATIVE_H
+#define __ASM_ALTERNATIVE_H
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/stringify.h>
+
+struct alt_instr {
+	s32 orig_offset;	/* offset to original instruction */
+	s32 alt_offset;		/* offset to replacement instruction */
+	u16 cpufeature;		/* cpufeature bit set for replacement */
+	u8  orig_len;		/* size of original instruction(s) */
+	u8  alt_len;		/* size of new instruction(s), <= orig_len */
+};
+
+void apply_alternatives(void);
+void free_alternatives_memory(void);
+
+#define ALTINSTR_ENTRY(feature)						      \
+	" .word 661b - .\n"				/* label           */ \
+	" .word 663f - .\n"				/* new instruction */ \
+	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
+	" .byte 662b-661b\n"				/* source len      */ \
+	" .byte 664f-663f\n"				/* replacement len */
+
+/* alternative assembly primitive: */
+#define ALTERNATIVE(oldinstr, newinstr, feature)			\
+	"661:\n\t"							\
+	oldinstr "\n"							\
+	"662:\n"							\
+	".pushsection .altinstructions,\"a\"\n"				\
+	ALTINSTR_ENTRY(feature)						\
+	".popsection\n"							\
+	".pushsection .altinstr_replacement, \"a\"\n"			\
+	"663:\n\t"							\
+	newinstr "\n"							\
+	"664:\n\t"							\
+	".popsection\n\t"						\
+	".if ((664b-663b) != (662b-661b))\n\t"				\
+	"	.error \"Alternatives instruction length mismatch\"\n\t"\
+	".endif\n"
+
+#endif /* __ASM_ALTERNATIVE_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 5bd029b..65b5a8e 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -15,7 +15,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
 			   hyp-stub.o psci.o cpu_ops.o insn.o return_address.o	\
-			   cpuinfo.o
+			   cpuinfo.o alternative.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
new file mode 100644
index 0000000..5992ea4
--- /dev/null
+++ b/arch/arm64/kernel/alternative.c
@@ -0,0 +1,64 @@
+/*
+ * alternative runtime patching
+ * inspired by the x86 version
+ *
+ * Copyright (C) 2014 ARM Ltd.
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
+
+#define pr_fmt(fmt) "alternative: " fmt
+
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <asm/cacheflush.h>
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
+#include <linux/stop_machine.h>
+
+extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
+
+static int __apply_alternatives(void *dummy)
+{
+	struct alt_instr *alt;
+	u8 *origptr, *replptr;
+
+	for (alt = __alt_instructions; alt < __alt_instructions_end; alt++) {
+		if (!cpus_have_cap(alt->cpufeature))
+			continue;
+
+		BUG_ON(alt->alt_len > alt->orig_len);
+
+		pr_info_once("patching kernel code\n");
+
+		origptr = (u8 *)&alt->orig_offset + alt->orig_offset;
+		replptr = (u8 *)&alt->alt_offset + alt->alt_offset;
+		memcpy(origptr, replptr, alt->alt_len);
+		flush_icache_range((uintptr_t)origptr,
+				   (uintptr_t)(origptr + alt->alt_len));
+	}
+
+	return 0;
+}
+
+void apply_alternatives(void)
+{
+	/* better not try code patching on a live SMP system */
+	stop_machine(__apply_alternatives, NULL, NULL);
+}
+
+void free_alternatives_memory(void)
+{
+	free_reserved_area(__alt_instructions, __alt_instructions_end,
+			   0, "alternatives");
+}
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index b06d1d9..0ef8789 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -37,6 +37,7 @@
 #include <linux/of.h>
 #include <linux/irq_work.h>
 
+#include <asm/alternative.h>
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
@@ -309,6 +310,7 @@ void cpu_die(void)
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 	pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
+	apply_alternatives();
 }
 
 void __init smp_prepare_boot_cpu(void)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index edf8715..2f60029 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -100,6 +100,17 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 
+	. = ALIGN(4);
+	.altinstructions : {
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+	.altinstr_replacement : {
+		*(.altinstr_replacement)
+	}
+
+	. = ALIGN(PAGE_SIZE);
 	_data = .;
 	_sdata = .;
 	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 494297c..bac492c 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -39,6 +39,7 @@
 #include <asm/setup.h>
 #include <asm/sizes.h>
 #include <asm/tlb.h>
+#include <asm/alternative.h>
 
 #include "mm.h"
 
@@ -325,6 +326,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 	free_initmem_default(0);
+	free_alternatives_memory();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.7.9.5

