Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537Ab3BNNRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:17:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab3BNNRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:17:07 -0500
Message-ID: <511CE3D0.8000308@redhat.com>
Date: Thu, 14 Feb 2013 14:17:04 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if 64-bit process
 entered kernel with int 80
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Determining personality of a ptraced process is a murky area.
On x86, for years strace was looking at segment selectors,
which is conceptually wrong: see, for example,
https://lkml.org/lkml/2012/1/18/320

strace recently changed detection method and current git code
(not released yet) does the following: it reads registers
with PTRACE_GETREGSET, and looks at returned regset size.
It is different for 64-bit and 32-bit processes,
and appears to be a reliable way to determine personality:
No need to check segment selectors for magic values.

This works for well-behaving processes.

But the hole described in the aforementioned lkml thread
still remains: 64-bit processes can perform 32-bit syscalls
using "int 80" entry method, and in this case, kernel returns
64-bit regset. For example, this:

asm("int $0x80": :"a" (29)); /* 32-bit sys_pause */

will be decoded by strace as a (64-bit) shmget syscall.

This patch makes it so that in syscall-entry-stop caused by
"int 80" instruction, PTRACE_GETREGSET returns 32-bit regset.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

--- linux-3.7.7/arch/x86/include/asm/uaccess.h
+++ linux-3.7.7_regset/arch/x86/include/asm/uaccess.h
@@ -594,5 +594,7 @@
 # include <asm/uaccess_64.h>
 #endif

+#define ARCH_HAS_SYSCALL_USER_REGSET_VIEW 1
+
 #endif /* _ASM_X86_UACCESS_H */

--- linux-3.7.7/arch/x86/kernel/ptrace.c
+++ linux-3.7.7_regset/arch/x86/kernel/ptrace.c
@@ -1443,6 +1443,22 @@
 #endif
 }

+const struct user_regset_view *syscall_user_regset_view(struct task_struct *task)
+{
+#ifdef CONFIG_IA32_EMULATION
+	/* Did task make 32-bit syscall just now?
+	 * Task can still be 64-bit: think "int 0x80 on x86_64".
+	 */
+	if (task_thread_info(task)->status & TS_COMPAT)
+#endif
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
+		return &user_x86_32_view;
+#endif
+#ifdef CONFIG_X86_64
+	return &user_x86_64_view;
+#endif
+}
+
 static void fill_sigtrap_info(struct task_struct *tsk,
 				struct pt_regs *regs,
 				int error_code, int si_code,
--- linux-3.7.7/include/linux/regset.h
+++ linux-3.7.7_regset/include/linux/regset.h
@@ -204,6 +204,12 @@
  */
 const struct user_regset_view *task_user_regset_view(struct task_struct *tsk);

+#ifdef ARCH_HAS_SYSCALL_USER_REGSET_VIEW
+const struct user_regset_view *syscall_user_regset_view(struct task_struct *tsk);
+#else
+# define syscall_user_regset_view task_user_regset_view
+#endif
+

 /*
  * These are helpers for writing regset get/set functions in arch code.
--- linux-3.7.7/kernel/ptrace.c
+++ linux-3.7.7_regset/kernel/ptrace.c
@@ -684,7 +684,7 @@
 static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 			 struct iovec *kiov)
 {
-	const struct user_regset_view *view = task_user_regset_view(task);
+	const struct user_regset_view *view = syscall_user_regset_view(task);
 	const struct user_regset *regset = find_regset(view, type);
 	int regset_no;

