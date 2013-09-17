Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3IQMoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:44:09 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35777 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab3IQMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:05 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 06/11] ARM: PIE: Add position independent executable embedding to ARM
Date: Tue, 17 Sep 2013 05:43:32 -0700
Message-Id: <1379421817-15759-7-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to ARM for embedding PIEs into the kernel, loading them into
genalloc pools (such as SRAM) and executing them. Support for ARM means
performing R_ARM_RELATIVE fixups within the .rel.dyn section.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 arch/arm/Kconfig              |  1 +
 arch/arm/Makefile             |  5 +++
 arch/arm/include/asm/elf.h    |  1 +
 arch/arm/kernel/.gitignore    |  1 +
 arch/arm/kernel/Makefile      |  4 ++-
 arch/arm/kernel/pie.c         | 83 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/pie.lds.S     | 40 +++++++++++++++++++++
 arch/arm/kernel/vmlinux.lds.S |  2 ++
 arch/arm/libpie/.gitignore    |  3 ++
 arch/arm/libpie/Makefile      | 32 +++++++++++++++++
 arch/arm/libpie/empty.S       | 12 +++++++
 11 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kernel/pie.c
 create mode 100644 arch/arm/kernel/pie.lds.S
 create mode 100644 arch/arm/libpie/.gitignore
 create mode 100644 arch/arm/libpie/Makefile
 create mode 100644 arch/arm/libpie/empty.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..de7b7603 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -49,6 +49,7 @@ config ARM
 	select HAVE_MEMBLOCK
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_PERF_EVENTS
+	select HAVE_PIE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 6fd2cea..a673d36 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -128,6 +128,8 @@ KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include asm/uni
 
 CHECKFLAGS	+= -D__arm__
 
+OBJCOPY_OUTPUT_FORMAT := elf32-littlearm
+
 #Default value
 head-y		:= arch/arm/kernel/head$(MMUEXT).o
 textofs-y	:= 0x00008000
@@ -273,6 +275,9 @@ drivers-$(CONFIG_OPROFILE)      += arch/arm/oprofile/
 
 libs-y				:= arch/arm/lib/ $(libs-y)
 
+PIE_LDS				:= arch/arm/kernel/pie.lds
+libpie-$(CONFIG_PIE)		+= arch/arm/libpie/
+
 # Default target when executing plain make
 ifeq ($(CONFIG_XIP_KERNEL),y)
 KBUILD_IMAGE := xipImage
diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 56211f2..a8d036b 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_NONE		0
 #define R_ARM_PC24		1
 #define R_ARM_ABS32		2
+#define R_ARM_RELATIVE		23
 #define R_ARM_CALL		28
 #define R_ARM_JUMP24		29
 #define R_ARM_V4BX		40
diff --git a/arch/arm/kernel/.gitignore b/arch/arm/kernel/.gitignore
index c5f676c..a055a48 100644
--- a/arch/arm/kernel/.gitignore
+++ b/arch/arm/kernel/.gitignore
@@ -1 +1,2 @@
 vmlinux.lds
+pie.lds
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 86d10dd..652312e 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -96,4 +96,6 @@ obj-y				+= psci.o
 obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
-extra-y := $(head-y) vmlinux.lds
+obj-$(CONFIG_PIE)		+= pie.o
+
+extra-y := $(head-y) vmlinux.lds pie.lds
diff --git a/arch/arm/kernel/pie.c b/arch/arm/kernel/pie.c
new file mode 100644
index 0000000..5dff5d6
--- /dev/null
+++ b/arch/arm/kernel/pie.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright 2013 Texas Instruments, Inc.
+ *	Russ Dill <russ.dill@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/pie.h>
+#include <linux/elf.h>
+
+#include <asm/elf.h>
+
+extern char __pie_rel_dyn_start[];
+extern char __pie_rel_dyn_end[];
+extern char __pie_tail_offset[];
+
+struct arm_pie_tail {
+	int count;
+	uintptr_t offset[0];
+};
+
+int pie_arch_fill_tail(void *tail, void *common_start, void *common_end,
+			void *overlay_start, void *code_start, void *code_end)
+{
+	Elf32_Rel *rel;
+	int records;
+	int i;
+	struct arm_pie_tail *pie_tail = tail;
+	int count;
+
+	rel = (Elf32_Rel *) __pie_rel_dyn_start;
+	records = (__pie_rel_dyn_end - __pie_rel_dyn_start) /
+						sizeof(*rel);
+
+	count = 0;
+	for (i = 0; i < records; i++, rel++) {
+		void *kern_off;
+		if (ELF32_R_TYPE(rel->r_info) != R_ARM_RELATIVE)
+			return -ENOEXEC;
+
+		/* Adjust offset to match area in kernel */
+		kern_off = common_start + rel->r_offset;
+
+		if (kern_off >= common_start && kern_off < code_end) {
+			if (tail)
+				pie_tail->offset[count] = rel->r_offset;
+			count++;
+		} else if (kern_off >= code_start && kern_off < code_end) {
+			if (tail)
+				pie_tail->offset[count] = rel->r_offset -
+						(code_start - overlay_start);
+			count++;
+		}
+	}
+
+	if (tail)
+		pie_tail->count = count;
+
+	return count * sizeof(uintptr_t) + sizeof(*pie_tail);
+}
+EXPORT_SYMBOL_GPL(pie_arch_fill_tail);
+
+/*
+ * R_ARM_RELATIVE: B(S) + A
+ * B(S) - Addressing origin of the output segment defining the symbol S.
+ * A - Addend for the relocation.
+ */
+int pie_arch_fixup(struct pie_chunk *chunk, void *base, void *tail,
+						unsigned long offset)
+{
+	struct arm_pie_tail *pie_tail = tail;
+	int i;
+
+	/* Perform relocation fixups for given offset */
+	for (i = 0; i < pie_tail->count; i++)
+		*((uintptr_t *) (pie_tail->offset[i] + base)) += offset;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pie_arch_fixup);
diff --git a/arch/arm/kernel/pie.lds.S b/arch/arm/kernel/pie.lds.S
new file mode 100644
index 0000000..4fd5ac5
--- /dev/null
+++ b/arch/arm/kernel/pie.lds.S
@@ -0,0 +1,40 @@
+/*
+ * ld script to make ARM PIEs
+ * taken from the ARM vmlinux.lds.S version by Russ Dill <russ.dill@ti.com.
+ */
+
+#include <asm-generic/pie.lds.h>
+
+OUTPUT_ARCH(arm)
+
+SECTIONS
+{
+	. = 0x0;
+
+	PIE_COMMON_START
+	.got.plt : {
+		*(.got)
+		*(.got.plt)
+	}
+	.text : {
+		PIE_TEXT_TEXT
+	}
+	PIE_COMMON_END
+
+	PIE_OVERLAY_START
+	OVERLAY : NOCROSSREFS {
+	}
+	PIE_OVERLAY_SEND
+
+	__pie_rel_dyn_start : {
+		VMLINUX_SYMBOL(__pie_rel_dyn_start) = .;
+	}
+	.rel.dyn : {
+		KEEP(*(.rel*))
+	}
+	__pie_rel_dyn_end : {
+		VMLINUX_SYMBOL(__pie_rel_dyn_end) = .;
+	}
+
+	PIE_DISCARDS
+}
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 7bcee5c..8c11235 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -77,6 +77,8 @@ SECTIONS
 #ifndef CONFIG_SMP_ON_UP
 		*(.alt.smp.init)
 #endif
+		*(.pie.*)
+		*(.ARM.exidx.pie.*.text)
 		*(.discard)
 		*(.discard.*)
 	}
diff --git a/arch/arm/libpie/.gitignore b/arch/arm/libpie/.gitignore
new file mode 100644
index 0000000..02e3cd5
--- /dev/null
+++ b/arch/arm/libpie/.gitignore
@@ -0,0 +1,3 @@
+lib1funcs.S
+ashldi3.S
+string.c
diff --git a/arch/arm/libpie/Makefile b/arch/arm/libpie/Makefile
new file mode 100644
index 0000000..5662e99
--- /dev/null
+++ b/arch/arm/libpie/Makefile
@@ -0,0 +1,32 @@
+#
+# linux/arch/arm/libpie/Makefile
+#
+ccflags-y	:= -fpic -mno-single-pic-base -fno-builtin
+
+obj-y		:= empty.o
+obj-y		+= lib1funcs.o ashldi3.o string.o
+
+# string library code (-Os is enforced to keep it much smaller)
+string = $(obj)/string.o
+CFLAGS_string.o := -Os
+
+$(obj)/string.c: $(srctree)/arch/$(SRCARCH)/boot/compressed/string.c
+	$(call cmd,shipped)
+
+# For __aeabi_uidivmod
+lib1funcs = $(obj)/lib1funcs.o
+
+$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S
+	$(call cmd,shipped)
+
+# For __aeabi_llsl
+ashldi3 = $(obj)/ashldi3.o
+
+$(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
+	$(call cmd,shipped)
+
+$(obj)/libpie.o: $(string) $(lib1funcs) $(ashldi3) $(addprefix $(obj)/,$(OBJS))
+	$(call if_changed,ld)
+
+# Make sure files are removed during clean
+extra-y		+= string.c lib1funcs.S ashldi3.S
diff --git a/arch/arm/libpie/empty.S b/arch/arm/libpie/empty.S
new file mode 100644
index 0000000..2416862
--- /dev/null
+++ b/arch/arm/libpie/empty.S
@@ -0,0 +1,12 @@
+#include <linux/linkage.h>
+
+ENTRY(__div0)
+ENTRY(__aeabi_unwind_cpp_pr0)
+ENTRY(__aeabi_unwind_cpp_pr1)
+ENTRY(__aeabi_unwind_cpp_pr2)
+	mov	pc, lr
+ENDPROC(__div0)
+ENDPROC(__aeabi_unwind_cpp_pr0)
+ENDPROC(__aeabi_unwind_cpp_pr1)
+ENDPROC(__aeabi_unwind_cpp_pr2)
+
-- 
1.8.3.2

