Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaEXHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:09:58 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:44101 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaEXHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:09:30 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few syscalls need to be using the compat syscalls.
Date: Sat, 24 May 2014 00:02:17 -0700
Message-Id: <1400914939-9708-23-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some syscalls are still need to use the compat versions.  So we need to have a seperate syscall table for ILP32.  This patch adds them including documentation on why we need to use each one.
This list is based on the list from https://lkml.org/lkml/2013/9/11/478.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/syscalls.h |    4 +
 arch/arm64/include/asm/unistd.h   |    4 +
 arch/arm64/kernel/Makefile        |    1 +
 arch/arm64/kernel/entry.S         |   13 +++-
 arch/arm64/kernel/sys_ilp32.c     |  175 +++++++++++++++++++++++++++++++++++++
 5 files changed, 196 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm64/kernel/sys_ilp32.c

diff --git a/arch/arm64/include/asm/syscalls.h b/arch/arm64/include/asm/syscalls.h
index 48fe7c6..b58dad7 100644
--- a/arch/arm64/include/asm/syscalls.h
+++ b/arch/arm64/include/asm/syscalls.h
@@ -25,6 +25,10 @@
  */
 asmlinkage long sys_rt_sigreturn_wrapper(void);
 
+#ifdef CONFIG_ARM64_ILP32
+long ilp32_sys_sigaltstack(const stack_t __user *, stack_t __user *);
+#endif
+
 #include <asm-generic/syscalls.h>
 
 #endif	/* __ASM_SYSCALLS_H */
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 11502bd..831c7b6 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,6 +13,10 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+#ifdef CONFIG_ARM64_ILP32
+#define __ARCH_WANT_COMPAT_SYS_PREADV64
+#define __ARCH_WANT_COMPAT_SYS_PWRITEV64
+#endif
 #ifdef CONFIG_AARCH32_EL0
 #define __ARCH_WANT_COMPAT_SYS_GETDENTS64
 #define __ARCH_WANT_COMPAT_STAT64
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 986962d..b5884a1 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -13,6 +13,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 
 arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
+arm64-obj-$(CONFIG_ARM64_ILP32)		+= sys_ilp32.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o topology.o
 arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 1e1ebfc..8241ffe 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -620,9 +620,14 @@ ENDPROC(ret_from_fork)
  */
 	.align	6
 el0_svc:
-	adrp	stbl, sys_call_table		// load syscall table pointer
 	uxtw	scno, w8			// syscall number in w8
 	mov	sc_nr, #__NR_syscalls
+#ifdef CONFIG_ARM64_ILP32
+	get_thread_info tsk
+	ldr	x16, [tsk, #TI_FLAGS]
+	tbnz	x16, #TIF_32BIT_AARCH64, el0_ilp32_svc // We are using ILP32
+#endif
+	adrp	stbl, sys_call_table		// load syscall table pointer
 el0_svc_naked:					// compat entry point
 	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
 	disable_step x16
@@ -643,6 +648,12 @@ ni_sys:
 	b	do_ni_syscall
 ENDPROC(el0_svc)
 
+#ifdef CONFIG_ARM64_ILP32
+el0_ilp32_svc:
+	adrp	stbl, sys_call_ilp32_table // load syscall table pointer
+	b el0_svc_naked
+#endif
+
 	/*
 	 * This is the really slow path.  We're going to be doing context
 	 * switches, and waiting for our parent to respond.
diff --git a/arch/arm64/kernel/sys_ilp32.c b/arch/arm64/kernel/sys_ilp32.c
new file mode 100644
index 0000000..1da1d11
--- /dev/null
+++ b/arch/arm64/kernel/sys_ilp32.c
@@ -0,0 +1,175 @@
+/*
+ * AArch64- ILP32 specific system calls implementation
+ *
+ * Copyright (C) 2013 Cavium Inc.
+ * Author: Andrew Pinski <apinski@cavium.com>
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
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+
+/*
+ * Wrappers to pass the pt_regs argument.
+ */
+#define sys_rt_sigreturn sys_rt_sigreturn_wrapper
+
+
+/* Using Compat syscalls where necessary */
+#define sys_ioctl		compat_sys_ioctl
+/* iovec */
+#define sys_readv		compat_sys_readv
+#define sys_writev		compat_sys_writev
+#define sys_preadv		compat_sys_preadv64
+#define sys_pwritev		compat_sys_pwritev64
+#define sys_vmsplice		compat_sys_vmsplice
+/* robust_list_head */
+#define sys_set_robust_list	compat_sys_set_robust_list
+#define sys_get_robust_list	compat_sys_get_robust_list
+
+/* kexec_segment */
+#define sys_kexec_load		compat_sys_kexec_load
+
+/* Ptrace has some structures which are different between ILP32 and LP64 */
+#define sys_ptrace		compat_sys_ptrace
+
+/* struct msghdr */
+#define sys_recvfrom		compat_sys_recvfrom
+#define sys_recvmmsg		compat_sys_recvmmsg
+#define sys_sendmmsg		compat_sys_sendmmsg
+#define sys_sendmsg		compat_sys_sendmsg
+#define sys_recvmsg		compat_sys_recvmsg
+
+#define sys_setsockopt		compat_sys_setsockopt
+#define sys_getsockopt		compat_sys_getsockopt
+
+/* Array of pointers */
+#define sys_execve		compat_sys_execve
+#define sys_move_pages		compat_sys_move_pages
+
+/* iovec */
+#define sys_process_vm_readv	compat_sys_process_vm_readv
+#define sys_process_vm_writev	compat_sys_process_vm_writev
+
+/* Pointer in struct */
+#define sys_mount               compat_sys_mount
+
+/* NUMA */
+/* unsigned long bitmaps */
+#define sys_get_mempolicy       compat_sys_get_mempolicy
+#define sys_set_mempolicy       compat_sys_set_mempolicy
+#define sys_mbind               compat_sys_mbind
+/* array of pointers */
+/* unsigned long bitmaps */
+#define sys_migrate_pages       compat_sys_migrate_pages
+
+/* Scheduler */
+/* unsigned long bitmaps */
+#define sys_sched_setaffinity   compat_sys_sched_setaffinity
+#define sys_sched_getaffinity   compat_sys_sched_getaffinity
+
+/* iov usage */
+#define sys_keyctl              compat_sys_keyctl
+
+/* aio */
+/* Pointer to Pointer  */
+#define sys_io_setup		compat_sys_io_setup
+/* Array of pointers */
+#define sys_io_submit           compat_sys_io_submit
+
+/* We need to make sure the pointer gets copied correctly. */
+asmlinkage long ilp32_sys_mq_notify(mqd_t mqdes,
+			const struct sigevent __user *u_notification)
+{
+	struct sigevent __user *p = NULL;
+	if (u_notification) {
+		struct sigevent n;
+		p = compat_alloc_user_space(sizeof(*p));
+		if (copy_from_user(&n, u_notification, sizeof(*p)))
+			return -EFAULT;
+		if (n.sigev_notify == SIGEV_THREAD)
+			n.sigev_value.sival_ptr = compat_ptr((uintptr_t)n.sigev_value.sival_ptr);
+		if (copy_to_user(p, &n, sizeof(*p)))
+			return -EFAULT;
+	}
+	return sys_mq_notify(mqdes, p);
+}
+
+/* sigevent contains sigval_t which is now 64bit always
+   but need special handling due to padding for SIGEV_THREAD.  */
+#define sys_mq_notify		ilp32_sys_mq_notify
+
+
+/* sigaltstack needs some special handling as the
+   padding for stack_t might not be non-zero. */
+long ilp32_sys_sigaltstack(const stack_t __user *uss_ptr,
+			   stack_t __user *uoss_ptr)
+{
+	stack_t uss, uoss;
+	int ret;
+	mm_segment_t seg;
+
+	if (uss_ptr) {
+		if (!access_ok(VERIFY_READ, uss_ptr, sizeof(*uss_ptr)))
+			return -EFAULT;
+		if (__get_user(uss.ss_sp, &uss_ptr->ss_sp) |
+			__get_user(uss.ss_flags, &uss_ptr->ss_flags) |
+			__get_user(uss.ss_size, &uss_ptr->ss_size))
+			return -EFAULT;
+		/* Zero extend the sp address and the size. */
+		uss.ss_sp = (void *)(uintptr_t)(unsigned int)(uintptr_t)uss.ss_sp;
+		uss.ss_size = (size_t)(unsigned int)uss.ss_size;
+	}
+	seg = get_fs();
+	set_fs(KERNEL_DS);
+	/* Note we need to use uoss as we have changed the segment to the
+	   kernel one so passing an user one around is wrong. */
+	ret = sys_sigaltstack((stack_t __force __user *) (uss_ptr ? &uss : NULL),
+			      (stack_t __force __user *) &uoss);
+	set_fs(seg);
+	if (ret >= 0 && uoss_ptr)  {
+		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_t)) ||
+		    __put_user(uoss.ss_sp, &uoss_ptr->ss_sp) ||
+		    __put_user(uoss.ss_flags, &uoss_ptr->ss_flags) ||
+		    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
+			ret = -EFAULT;
+	}
+	return ret;
+}
+
+/* sigaltstack needs some special handling as the padding
+   for stack_t might not be non-zero. */
+#define sys_sigaltstack		ilp32_sys_sigaltstack
+
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, sym)	[nr] = sym,
+
+/*
+ * The sys_call_ilp32_table array must be 4K aligned to be accessible from
+ * kernel/entry.S.
+ */
+void *sys_call_ilp32_table[__NR_syscalls] __aligned(4096) = {
+	[0 ... __NR_syscalls - 1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
-- 
1.7.2.5

