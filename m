Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaIKImD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:42:03 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:30234 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaIKIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:35 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 09/10] MIPS: ELF: set FP mode according to .MIPS.abiflags
Date: Thu, 11 Sep 2014 08:30:22 +0100
Message-ID: <1410420623-11691-10-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reads the .MIPS.abiflags section when it is present, and sets
the FP mode of the task accordingly. Any loaded ELF files which do not
contain a .MIPS.abiflags section will continue to observe the previous
behaviour, that is FR=1 if EF_MIPS_FP64 is set else FR=0.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 arch/mips/Kconfig           |   1 +
 arch/mips/include/asm/elf.h |  50 ++++++++-----
 arch/mips/kernel/Makefile   |   7 +-
 arch/mips/kernel/elf.c      | 173 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 211 insertions(+), 20 deletions(-)
 create mode 100644 arch/mips/kernel/elf.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 900c7e5..8d73ed0 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -52,6 +52,7 @@ config MIPS
 	select HAVE_CC_STACKPROTECTOR
 	select CPU_PM if CPU_IDLE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_BINFMT_ELF_STATE
 
 menu "Machine selection"
 
diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index bfa4bbd..eb4d95d 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_ELF_H
 #define _ASM_ELF_H
 
+#include <linux/fs.h>
+#include <uapi/linux/elf.h>
 
 /* ELF header e_flags defines. */
 /* MIPS architecture level. */
@@ -287,18 +289,13 @@ extern struct mips_abi mips_abi_n32;
 
 #ifdef CONFIG_32BIT
 
-#define SET_PERSONALITY(ex)						\
+#define SET_PERSONALITY2(ex, state)					\
 do {									\
-	if ((ex).e_flags & EF_MIPS_FP64)				\
-		clear_thread_flag(TIF_32BIT_FPREGS);			\
-	else								\
-		set_thread_flag(TIF_32BIT_FPREGS);			\
-									\
-	clear_thread_flag(TIF_HYBRID_FPREGS);				\
-									\
 	if (personality(current->personality) != PER_LINUX)		\
 		set_personality(PER_LINUX);				\
 									\
+	mips_set_personality_fp(state);					\
+									\
 	current->thread.abi = &mips_abi;				\
 } while (0)
 
@@ -318,35 +315,34 @@ do {									\
 #endif
 
 #ifdef CONFIG_MIPS32_O32
-#define __SET_PERSONALITY32_O32(ex)					\
+#define __SET_PERSONALITY32_O32(ex, state)				\
 	do {								\
 		set_thread_flag(TIF_32BIT_REGS);			\
 		set_thread_flag(TIF_32BIT_ADDR);			\
 									\
-		if (!((ex).e_flags & EF_MIPS_FP64))			\
-			set_thread_flag(TIF_32BIT_FPREGS);		\
+		mips_set_personality_fp(state);				\
 									\
 		current->thread.abi = &mips_abi_32;			\
 	} while (0)
 #else
-#define __SET_PERSONALITY32_O32(ex)					\
+#define __SET_PERSONALITY32_O32(ex, state)				\
 	do { } while (0)
 #endif
 
 #ifdef CONFIG_MIPS32_COMPAT
-#define __SET_PERSONALITY32(ex)						\
+#define __SET_PERSONALITY32(ex, state)					\
 do {									\
 	if ((((ex).e_flags & EF_MIPS_ABI2) != 0) &&			\
 	     ((ex).e_flags & EF_MIPS_ABI) == 0)				\
 		__SET_PERSONALITY32_N32();				\
 	else								\
-		__SET_PERSONALITY32_O32(ex);                            \
+		__SET_PERSONALITY32_O32(ex, state);			\
 } while (0)
 #else
-#define __SET_PERSONALITY32(ex) do { } while (0)
+#define __SET_PERSONALITY32(ex, state) do { } while (0)
 #endif
 
-#define SET_PERSONALITY(ex)						\
+#define SET_PERSONALITY2(ex, state)					\
 do {									\
 	unsigned int p;							\
 									\
@@ -356,7 +352,7 @@ do {									\
 	clear_thread_flag(TIF_32BIT_ADDR);				\
 									\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)			\
-		__SET_PERSONALITY32(ex);				\
+		__SET_PERSONALITY32(ex, state);				\
 	else								\
 		current->thread.abi = &mips_abi;			\
 									\
@@ -418,4 +414,24 @@ struct mm_struct;
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
+struct arch_elf_state {
+	int fp_abi;
+	int interp_fp_abi;
+	int overall_abi;
+};
+
+#define INIT_ARCH_ELF_STATE {			\
+	.fp_abi = -1,				\
+	.interp_fp_abi = -1,			\
+	.overall_abi = -1,			\
+}
+
+extern int arch_elf_pt_proc(void *ehdr, void *phdr, struct file *elf,
+			    bool is_interp, struct arch_elf_state *state);
+
+extern int arch_check_elf(void *ehdr, bool has_interpreter,
+			  struct arch_elf_state *state);
+
+extern void mips_set_personality_fp(struct arch_elf_state *state);
+
 #endif /* _ASM_ELF_H */
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 008a2fe..53a78d9 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -4,9 +4,10 @@
 
 extra-y		:= head.o vmlinux.lds
 
-obj-y		+= cpu-probe.o branch.o entry.o genex.o idle.o irq.o process.o \
-		   prom.o ptrace.o reset.o setup.o signal.o syscall.o \
-		   time.o topology.o traps.o unaligned.o watch.o vdso.o
+obj-y		+= cpu-probe.o branch.o elf.o entry.o genex.o idle.o irq.o \
+		   process.o prom.o ptrace.o reset.o setup.o signal.o \
+		   syscall.o time.o topology.o traps.o unaligned.o watch.o \
+		   vdso.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_ftrace.o = -pg
diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
new file mode 100644
index 0000000..0933e07
--- /dev/null
+++ b/arch/mips/kernel/elf.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (C) 2014 Imagination Technologies
+ * Author: Paul Burton <paul.burton@imgtec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/elf.h>
+#include <linux/sched.h>
+
+enum {
+	FP_ERROR = -1,
+	FP_DOUBLE_64A = -2,
+};
+
+int arch_elf_pt_proc(void *_ehdr, void *_phdr, struct file *elf,
+		     bool is_interp, struct arch_elf_state *state)
+{
+	struct elfhdr *ehdr = _ehdr;
+	struct elf_phdr *phdr = _phdr;
+	struct mips_elf_abiflags_v0 abiflags;
+	int ret;
+
+	if (config_enabled(CONFIG_64BIT) &&
+	    (ehdr->e_ident[EI_CLASS] != ELFCLASS32))
+		return 0;
+	if (phdr->p_type != PT_MIPS_ABIFLAGS)
+		return 0;
+	if (phdr->p_filesz < sizeof(abiflags))
+		return -EINVAL;
+
+	ret = kernel_read(elf, phdr->p_offset, (char *)&abiflags,
+			  sizeof(abiflags));
+	if (ret < 0)
+		return ret;
+	if (ret != sizeof(abiflags))
+		return -EIO;
+
+	/* Record the required FP ABIs for use by mips_check_elf */
+	if (is_interp)
+		state->interp_fp_abi = abiflags.fp_abi;
+	else
+		state->fp_abi = abiflags.fp_abi;
+
+	return 0;
+}
+
+static inline unsigned get_fp_abi(struct elfhdr *ehdr, int in_abi)
+{
+	/* If the ABI requirement is provided, simply return that */
+	if (in_abi != -1)
+		return in_abi;
+
+	/* If the EF_MIPS_FP64 flag was set, return MIPS_ABI_FP_64 */
+	if (ehdr->e_flags & EF_MIPS_FP64)
+		return MIPS_ABI_FP_64;
+
+	/* Default to MIPS_ABI_FP_DOUBLE */
+	return MIPS_ABI_FP_DOUBLE;
+}
+
+int arch_check_elf(void *_ehdr, bool has_interpreter,
+		   struct arch_elf_state *state)
+{
+	struct elfhdr *ehdr = _ehdr;
+	unsigned fp_abi, interp_fp_abi, abi0, abi1;
+
+	/* Ignore non-O32 binaries */
+	if (config_enabled(CONFIG_64BIT) &&
+	    (ehdr->e_ident[EI_CLASS] != ELFCLASS32))
+		return 0;
+
+	fp_abi = get_fp_abi(ehdr, state->fp_abi);
+
+	if (has_interpreter) {
+		interp_fp_abi = get_fp_abi(ehdr, state->interp_fp_abi);
+
+		abi0 = min(fp_abi, interp_fp_abi);
+		abi1 = max(fp_abi, interp_fp_abi);
+	} else {
+		abi0 = abi1 = fp_abi;
+	}
+
+	state->overall_abi = FP_ERROR;
+
+	if (abi0 == abi1) {
+		state->overall_abi = abi0;
+	} else if (abi0 == MIPS_ABI_FP_ANY) {
+		state->overall_abi = abi1;
+	} else if (abi0 == MIPS_ABI_FP_DOUBLE) {
+		switch (abi1) {
+		case MIPS_ABI_FP_XX:
+			state->overall_abi = MIPS_ABI_FP_DOUBLE;
+			break;
+
+		case MIPS_ABI_FP_64A:
+			state->overall_abi = FP_DOUBLE_64A;
+			break;
+		}
+	} else if (abi0 == MIPS_ABI_FP_SINGLE ||
+		   abi0 == MIPS_ABI_FP_SOFT) {
+		/* Cannot link with other ABIs */
+	} else if (abi0 == MIPS_ABI_FP_OLD_64) {
+		switch (abi1) {
+		case MIPS_ABI_FP_XX:
+		case MIPS_ABI_FP_64:
+		case MIPS_ABI_FP_64A:
+			state->overall_abi = MIPS_ABI_FP_64;
+			break;
+		}
+	} else if (abi0 == MIPS_ABI_FP_XX ||
+		   abi0 == MIPS_ABI_FP_64 ||
+		   abi0 == MIPS_ABI_FP_64A) {
+		state->overall_abi = MIPS_ABI_FP_64;
+	}
+
+	switch (state->overall_abi) {
+	case MIPS_ABI_FP_64:
+	case MIPS_ABI_FP_64A:
+	case FP_DOUBLE_64A:
+		if (!config_enabled(CONFIG_MIPS_O32_FP64_SUPPORT))
+			return -ELIBBAD;
+		break;
+
+	case FP_ERROR:
+		return -ELIBBAD;
+	}
+
+	return 0;
+}
+
+void mips_set_personality_fp(struct arch_elf_state *state)
+{
+	switch (state->overall_abi) {
+	case MIPS_ABI_FP_DOUBLE:
+	case MIPS_ABI_FP_SINGLE:
+	case MIPS_ABI_FP_SOFT:
+		/* FR=0 */
+		set_thread_flag(TIF_32BIT_FPREGS);
+		clear_thread_flag(TIF_HYBRID_FPREGS);
+		break;
+
+	case FP_DOUBLE_64A:
+		/* FR=1, FRE=1 */
+		clear_thread_flag(TIF_32BIT_FPREGS);
+		set_thread_flag(TIF_HYBRID_FPREGS);
+		break;
+
+	case MIPS_ABI_FP_64:
+	case MIPS_ABI_FP_64A:
+		/* FR=1, FRE=0 */
+		clear_thread_flag(TIF_32BIT_FPREGS);
+		clear_thread_flag(TIF_HYBRID_FPREGS);
+		break;
+
+	case MIPS_ABI_FP_XX:
+	case MIPS_ABI_FP_ANY:
+		if (!config_enabled(CONFIG_MIPS_O32_FP64_SUPPORT))
+			set_thread_flag(TIF_32BIT_FPREGS);
+		else
+			clear_thread_flag(TIF_32BIT_FPREGS);
+
+		clear_thread_flag(TIF_HYBRID_FPREGS);
+		break;
+
+	default:
+	case FP_ERROR:
+		BUG();
+	}
+}
-- 
2.0.4

