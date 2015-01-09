Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbbAIP6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:58:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58951 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbbAIP5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:57:40 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] arm64: Implement the compat_sys_call_table in C
Date: Fri,  9 Jan 2015 15:57:26 +0000
Message-Id: <1420819048-3515-4-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
References: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the sys_call_table[], the compat one was implemented in sys32.S
making it impossible to notice discrepancies between the number of
compat syscalls and the __NR_compat_syscalls macro, the latter having to
be defined in asm/unistd.h as including asm/unistd32.h would cause
conflicts on __NR_* definitions. With this patch, incorrect
__NR_compat_syscalls values will result in a build-time error.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/unistd.h          |  3 ++
 arch/arm64/kernel/Makefile               |  2 +-
 arch/arm64/kernel/entry.S                |  2 +-
 arch/arm64/kernel/{sys32.S => entry32.S} | 34 ++++++++-------------
 arch/arm64/kernel/sys32.c                | 51 ++++++++++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 24 deletions(-)
 rename arch/arm64/kernel/{sys32.S => entry32.S} (80%)
 create mode 100644 arch/arm64/kernel/sys32.c

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index b780c6c76eec..159b44fff258 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -48,6 +48,9 @@
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
+
+#ifndef __COMPAT_SYSCALL_NR
 #include <uapi/asm/unistd.h>
+#endif
 
 #define NR_syscalls (__NR_syscalls)
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index eaa77ed7766a..54be7dc906f0 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -19,7 +19,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   cpuinfo.o cpu_errata.o alternative.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
-					   sys_compat.o 			\
+					   sys_compat.o entry32.o		\
 					   ../../arm/kernel/opcodes.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index fd4fa374e5d2..39811ad31537 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -433,7 +433,7 @@ el0_svc_compat:
 	/*
 	 * AArch32 syscall handling
 	 */
-	adr	stbl, compat_sys_call_table	// load compat syscall table pointer
+	adrp	stbl, compat_sys_call_table	// load compat syscall table pointer
 	uxtw	scno, w7			// syscall number in w7 (r7)
 	mov     sc_nr, #__NR_compat_syscalls
 	b	el0_svc_naked
diff --git a/arch/arm64/kernel/sys32.S b/arch/arm64/kernel/entry32.S
similarity index 80%
rename from arch/arm64/kernel/sys32.S
rename to arch/arm64/kernel/entry32.S
index 423a5b3fc2be..9a8f6ae2530e 100644
--- a/arch/arm64/kernel/sys32.S
+++ b/arch/arm64/kernel/entry32.S
@@ -27,26 +27,26 @@
  * System call wrappers for the AArch32 compatibility layer.
  */
 
-compat_sys_sigreturn_wrapper:
+ENTRY(compat_sys_sigreturn_wrapper)
 	mov	x0, sp
 	mov	x27, #0		// prevent syscall restart handling (why)
 	b	compat_sys_sigreturn
 ENDPROC(compat_sys_sigreturn_wrapper)
 
-compat_sys_rt_sigreturn_wrapper:
+ENTRY(compat_sys_rt_sigreturn_wrapper)
 	mov	x0, sp
 	mov	x27, #0		// prevent syscall restart handling (why)
 	b	compat_sys_rt_sigreturn
 ENDPROC(compat_sys_rt_sigreturn_wrapper)
 
-compat_sys_statfs64_wrapper:
+ENTRY(compat_sys_statfs64_wrapper)
 	mov	w3, #84
 	cmp	w1, #88
 	csel	w1, w3, w1, eq
 	b	compat_sys_statfs64
 ENDPROC(compat_sys_statfs64_wrapper)
 
-compat_sys_fstatfs64_wrapper:
+ENTRY(compat_sys_fstatfs64_wrapper)
 	mov	w3, #84
 	cmp	w1, #88
 	csel	w1, w3, w1, eq
@@ -58,33 +58,33 @@ ENDPROC(compat_sys_fstatfs64_wrapper)
  * in registers or that take 32-bit parameters which require sign
  * extension.
  */
-compat_sys_pread64_wrapper:
+ENTRY(compat_sys_pread64_wrapper)
 	regs_to_64	x3, x4, x5
 	b	sys_pread64
 ENDPROC(compat_sys_pread64_wrapper)
 
-compat_sys_pwrite64_wrapper:
+ENTRY(compat_sys_pwrite64_wrapper)
 	regs_to_64	x3, x4, x5
 	b	sys_pwrite64
 ENDPROC(compat_sys_pwrite64_wrapper)
 
-compat_sys_truncate64_wrapper:
+ENTRY(compat_sys_truncate64_wrapper)
 	regs_to_64	x1, x2, x3
 	b	sys_truncate
 ENDPROC(compat_sys_truncate64_wrapper)
 
-compat_sys_ftruncate64_wrapper:
+ENTRY(compat_sys_ftruncate64_wrapper)
 	regs_to_64	x1, x2, x3
 	b	sys_ftruncate
 ENDPROC(compat_sys_ftruncate64_wrapper)
 
-compat_sys_readahead_wrapper:
+ENTRY(compat_sys_readahead_wrapper)
 	regs_to_64	x1, x2, x3
 	mov	w2, w4
 	b	sys_readahead
 ENDPROC(compat_sys_readahead_wrapper)
 
-compat_sys_fadvise64_64_wrapper:
+ENTRY(compat_sys_fadvise64_64_wrapper)
 	mov	w6, w1
 	regs_to_64	x1, x2, x3
 	regs_to_64	x2, x4, x5
@@ -92,24 +92,14 @@ compat_sys_fadvise64_64_wrapper:
 	b	sys_fadvise64_64
 ENDPROC(compat_sys_fadvise64_64_wrapper)
 
-compat_sys_sync_file_range2_wrapper:
+ENTRY(compat_sys_sync_file_range2_wrapper)
 	regs_to_64	x2, x2, x3
 	regs_to_64	x3, x4, x5
 	b	sys_sync_file_range2
 ENDPROC(compat_sys_sync_file_range2_wrapper)
 
-compat_sys_fallocate_wrapper:
+ENTRY(compat_sys_fallocate_wrapper)
 	regs_to_64	x2, x2, x3
 	regs_to_64	x3, x4, x5
 	b	sys_fallocate
 ENDPROC(compat_sys_fallocate_wrapper)
-
-#undef __SYSCALL
-#define __SYSCALL(x, y)		.quad	y	// x
-
-/*
- * The system calls table must be 4KB aligned.
- */
-	.align	12
-ENTRY(compat_sys_call_table)
-#include <asm/unistd32.h>
diff --git a/arch/arm64/kernel/sys32.c b/arch/arm64/kernel/sys32.c
new file mode 100644
index 000000000000..2d5ab3c90b82
--- /dev/null
+++ b/arch/arm64/kernel/sys32.c
@@ -0,0 +1,51 @@
+/*
+ * arch/arm64/kernel/sys32.c
+ *
+ * Copyright (C) 2015 ARM Ltd.
+ *
+ * This program is free software(void); you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http(void);//www.gnu.org/licenses/>.
+ */
+
+/*
+ * Needed to avoid conflicting __NR_* macros between uapi/asm/unistd.h and
+ * asm/unistd32.h.
+ */
+#define __COMPAT_SYSCALL_NR
+
+#include <linux/compiler.h>
+#include <linux/syscalls.h>
+
+asmlinkage long compat_sys_sigreturn_wrapper(void);
+asmlinkage long compat_sys_rt_sigreturn_wrapper(void);
+asmlinkage long compat_sys_statfs64_wrapper(void);
+asmlinkage long compat_sys_fstatfs64_wrapper(void);
+asmlinkage long compat_sys_pread64_wrapper(void);
+asmlinkage long compat_sys_pwrite64_wrapper(void);
+asmlinkage long compat_sys_truncate64_wrapper(void);
+asmlinkage long compat_sys_ftruncate64_wrapper(void);
+asmlinkage long compat_sys_readahead_wrapper(void);
+asmlinkage long compat_sys_fadvise64_64_wrapper(void);
+asmlinkage long compat_sys_sync_file_range2_wrapper(void);
+asmlinkage long compat_sys_fallocate_wrapper(void);
+
+#undef __SYSCALL
+#define __SYSCALL(nr, sym)	[nr] = sym,
+
+/*
+ * The sys_call_table array must be 4K aligned to be accessible from
+ * kernel/entry.S.
+ */
+void * const compat_sys_call_table[__NR_compat_syscalls] __aligned(4096) = {
+	[0 ... __NR_compat_syscalls - 1] = sys_ni_syscall,
+#include <asm/unistd32.h>
+};
