Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3AXKv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:51:58 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47227 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3AXKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:51:50 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v3 17/71] ARC: Syscall support (no-legacy-syscall ABI)
Date: Thu, 24 Jan 2013 16:20:19 +0530
Message-ID: <1359024639-21915-6-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes support for generic clone/for/vfork/execve

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/Kconfig                |    1 +
 arch/arc/include/asm/ptrace.h   |    5 +++
 arch/arc/include/asm/syscall.h  |   72 +++++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/syscalls.h |   29 +++++++++++++++
 arch/arc/include/asm/unistd.h   |   34 ++++++++++++++++++
 arch/arc/kernel/entry.S         |   27 ++++++++++++++
 arch/arc/kernel/process.c       |   42 ++++++++++++++++++++++
 arch/arc/kernel/sys.c           |   18 ++++++++++
 8 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/syscall.h
 create mode 100644 arch/arc/include/asm/syscalls.h
 create mode 100644 arch/arc/include/asm/unistd.h
 create mode 100644 arch/arc/kernel/process.c
 create mode 100644 arch/arc/kernel/sys.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index b0b09ae..8789de1 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -9,6 +9,7 @@
 config ARC
 	def_bool y
 	select ARCH_NO_VIRT_TO_BUS
+	select CLONE_BACKWARDS
 	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
 	select DEVTMPFS if !INITRAMFS_SOURCE=""
 	select GENERIC_ATOMIC64
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 561c7eb..9abbb7c 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -125,6 +125,11 @@ struct user_regs_struct {
 		sp = -1;	\
 	sp;			\
 })
+
+/* return 1 if in syscall, 0 if Intr or Exception */
+#define in_syscall(regs) (((regs->orig_r8) >= 0 && \
+			   (regs->orig_r8 <= NR_syscalls)) ? 1 : 0)
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/arc/include/asm/syscall.h b/arch/arc/include/asm/syscall.h
new file mode 100644
index 0000000..33ab304
--- /dev/null
+++ b/arch/arc/include/asm/syscall.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SYSCALL_H
+#define _ASM_ARC_SYSCALL_H  1
+
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <asm/unistd.h>
+#include <asm/ptrace.h>		/* in_syscall() */
+
+static inline long
+syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
+{
+	if (user_mode(regs) && in_syscall(regs))
+		return regs->orig_r8;
+	else
+		return -1;
+}
+
+static inline void
+syscall_rollback(struct task_struct *task, struct pt_regs *regs)
+{
+	/* XXX: I can't fathom how pt_regs->r8 will be clobbered ? */
+	regs->r8 = regs->orig_r8;
+}
+
+static inline long
+syscall_get_error(struct task_struct *task, struct pt_regs *regs)
+{
+	/* 0 if syscall succeeded, otherwise -Errorcode */
+	return IS_ERR_VALUE(regs->r0) ? regs->r0 : 0;
+}
+
+static inline long
+syscall_get_return_value(struct task_struct *task, struct pt_regs *regs)
+{
+	return regs->r0;
+}
+
+static inline void
+syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
+			 int error, long val)
+{
+	regs->r0 = (long) error ?: val;
+}
+
+/*
+ * @i:      argument index [0,5]
+ * @n:      number of arguments; n+i must be [1,6].
+ */
+static inline void
+syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
+		      unsigned int i, unsigned int n, unsigned long *args)
+{
+	unsigned long *inside_ptregs = &(regs->r0);
+	inside_ptregs -= i;
+
+	BUG_ON((i + n) > 6);
+
+	while (n--) {
+		args[i++] = (*inside_ptregs);
+		inside_ptregs--;
+	}
+}
+
+#endif
diff --git a/arch/arc/include/asm/syscalls.h b/arch/arc/include/asm/syscalls.h
new file mode 100644
index 0000000..e53a534
--- /dev/null
+++ b/arch/arc/include/asm/syscalls.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SYSCALLS_H
+#define _ASM_ARC_SYSCALLS_H  1
+
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+int sys_clone_wrapper(int, int, int, int, int);
+int sys_fork_wrapper(void);
+int sys_vfork_wrapper(void);
+int sys_cacheflush(uint32_t, uint32_t uint32_t);
+int sys_arc_settls(void *);
+int sys_arc_gettls(void);
+
+#include <asm-generic/syscalls.h>
+
+#endif	/* __KERNEL__ */
+
+#endif
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
new file mode 100644
index 0000000..6f30484
--- /dev/null
+++ b/arch/arc/include/asm/unistd.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/******** no-legacy-syscalls-ABI *******/
+
+#define __ARCH_WANT_SYS_EXECVE
+#define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_VFORK
+#define __ARCH_WANT_SYS_FORK
+
+#define sys_mmap2 sys_mmap_pgoff
+
+#include <asm-generic/unistd.h>
+
+#define NR_syscalls	__NR_syscalls
+
+/* ARC specific syscall */
+#define __NR_cacheflush		(__NR_arch_specific_syscall + 0)
+#define __NR_arc_settls		(__NR_arch_specific_syscall + 1)
+#define __NR_arc_gettls		(__NR_arch_specific_syscall + 2)
+
+__SYSCALL(__NR_cacheflush, sys_cacheflush)
+__SYSCALL(__NR_arc_settls, sys_arc_settls)
+__SYSCALL(__NR_arc_gettls, sys_arc_gettls)
+
+
+/* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
+#define __NR_sysfs		(__NR_arch_specific_syscall + 3)
+__SYSCALL(__NR_sysfs, sys_sysfs)
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index a4acc9e..0b0a190 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -569,3 +569,30 @@ ARC_ENTRY ret_from_fork
 	bl  @schedule_tail
 	b @ret_from_exception
 ARC_EXIT ret_from_fork
+
+;################### Special Sys Call Wrappers ##########################
+
+; TBD: call do_fork directly from here
+ARC_ENTRY sys_fork_wrapper
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_fork
+	DISCARD_CALLEE_SAVED_USER
+
+	b ret_from_system_call
+ARC_EXIT sys_fork_wrapper
+
+ARC_ENTRY sys_vfork_wrapper
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_vfork
+	DISCARD_CALLEE_SAVED_USER
+
+	b ret_from_system_call
+ARC_EXIT sys_vfork_wrapper
+
+ARC_ENTRY sys_clone_wrapper
+	SAVE_CALLEE_SAVED_USER
+	bl  @sys_clone
+	DISCARD_CALLEE_SAVED_USER
+
+	b ret_from_system_call
+ARC_EXIT sys_clone_wrapper
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
new file mode 100644
index 0000000..4d14e56
--- /dev/null
+++ b/arch/arc/kernel/process.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Kanika Nema: Codito Technologies 2004
+ */
+
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/elf.h>
+#include <linux/tick.h>
+
+SYSCALL_DEFINE1(arc_settls, void *, user_tls_data_ptr)
+{
+	task_thread_info(current)->thr_ptr = (unsigned int)user_tls_data_ptr;
+	return 0;
+}
+
+/*
+ * We return the user space TLS data ptr as sys-call return code
+ * Ideally it should be copy to user.
+ * However we can cheat by the fact that some sys-calls do return
+ * absurdly high values
+ * Since the tls dat aptr is not going to be in range of 0xFFFF_xxxx
+ * it won't be considered a sys-call error
+ * and it will be loads better than copy-to-user, which is a definite
+ * D-TLB Miss
+ */
+SYSCALL_DEFINE0(arc_gettls)
+{
+	return task_thread_info(current)->thr_ptr;
+}
diff --git a/arch/arc/kernel/sys.c b/arch/arc/kernel/sys.c
new file mode 100644
index 0000000..f6bdd07
--- /dev/null
+++ b/arch/arc/kernel/sys.c
@@ -0,0 +1,18 @@
+
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#define sys_clone	sys_clone_wrapper
+#define sys_fork	sys_fork_wrapper
+#define sys_vfork	sys_vfork_wrapper
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[NR_syscalls] = {
+	[0 ... NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
-- 
1.7.4.1

