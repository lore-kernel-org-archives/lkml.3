Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3ARMk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:40:57 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:59286 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3ARMbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:31:06 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 37/76] ARC: Switch to generic kernel_execve() and sys_execve()
Date: Fri, 18 Jan 2013 17:54:51 +0530
Message-ID: <1358511930-7424-38-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/include/asm/ptrace.h   |    8 +++++++
 arch/arc/include/asm/syscalls.h |    1 -
 arch/arc/include/asm/unistd.h   |    3 ++
 arch/arc/kernel/entry.S         |   18 ++++++++-------
 arch/arc/kernel/process.c       |   44 ---------------------------------------
 arch/arc/kernel/sys.c           |    1 -
 6 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 92ef198..e4e1ac6 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -133,6 +133,14 @@ struct user_regs_struct {
 #define syscall_wont_restart(regs) (regs->orig_r8 |= orig_r8_IS_SCALL_RESTARTED)
 #define syscall_restartable(regs) !(regs->orig_r8 & orig_r8_IS_SCALL_RESTARTED)
 
+#define current_pt_regs()					\
+({								\
+	/* open-coded current_thread_info() */			\
+	register unsigned long sp asm ("sp");			\
+	unsigned long pg_start = (sp & ~(THREAD_SIZE - 1));	\
+	(struct pt_regs *)(pg_start + THREAD_SIZE - 4) - 1;	\
+})
+
 #endif /* !__ASSEMBLY__ */
 
 #define orig_r8_IS_SCALL		0x0001
diff --git a/arch/arc/include/asm/syscalls.h b/arch/arc/include/asm/syscalls.h
index cf5d2f5..e53a534 100644
--- a/arch/arc/include/asm/syscalls.h
+++ b/arch/arc/include/asm/syscalls.h
@@ -15,7 +15,6 @@
 #include <linux/linkage.h>
 #include <linux/types.h>
 
-int sys_execve_wrapper(int, int, int);
 int sys_clone_wrapper(int, int, int, int, int);
 int sys_fork_wrapper(void);
 int sys_vfork_wrapper(void);
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
index 6a2d101..003b2cf 100644
--- a/arch/arc/include/asm/unistd.h
+++ b/arch/arc/include/asm/unistd.h
@@ -8,6 +8,9 @@
 
 /******** no-legacy-syscalls-ABI *******/
 
+#define __ARCH_WANT_KERNEL_EXECVE
+#define __ARCH_WANT_SYS_EXECVE
+
 #define sys_mmap2 sys_mmap_pgoff
 
 #include <asm-generic/unistd.h>
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index e76b432..d2cad3c 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -586,15 +586,17 @@ ARC_ENTRY ret_from_kernel_thread
 	j   @sys_exit
 ARC_EXIT ret_from_kernel_thread
 
-;################### Special Sys Call Wrappers ##########################
-
-ARC_ENTRY sys_execve_wrapper
-	; copy pointer to pt_regs as a parameter
-	mov  r3, sp
-	bl  @sys_execve
+; When we land here, pt_regs have already been updated in-place correctly
+; for return to user mode.
+; However the call stack leading to kernel_execve() from say
+; ____call_usermodehelper() would make SP != pt_regs.
+; Thus we need to set SP to pt_regs as passed by kernel_execve() to us.
+ARC_ENTRY ret_from_kernel_execve
+	b.d   ret_from_exception
+	mov   sp, r0
+ARC_EXIT ret_from_kernel_execve
 
-	b ret_from_system_call
-ARC_EXIT sys_execve_wrapper
+;################### Special Sys Call Wrappers ##########################
 
 ; TBD: call do_fork directly from here
 ARC_ENTRY sys_fork_wrapper
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index a468205..20d8b4d 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -53,50 +53,6 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
 		       child_tidptr);
 }
 
-int sys_execve(const char __user *filenamei, const char __user *__user *argv,
-	       const char __user *__user *envp, struct pt_regs *regs)
-{
-	long error;
-	struct filename *filename;
-
-	filename = getname(filenamei);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-
-	error = do_execve(filename->name, argv, envp, regs);
-	putname(filename);
-out:
-	return error;
-}
-
-int kernel_execve(const char *filename, const char *const argv[],
-		  const char *const envp[])
-{
-	/*
-	 * Although the arguments (order, number) to this function are
-	 * same as sys call, we don't need to setup args in regs again.
-	 * However in case mainline kernel changes the order of args to
-	 * kernel_execve, that assumtion will break.
-	 * So to be safe, let gcc know the args for sys call.
-	 * If they match no extra code will be generated
-	 */
-	register int arg2 asm("r1") = (int)argv;
-	register int arg3 asm("r2") = (int)envp;
-
-	register int filenm_n_ret asm("r0") = (int)filename;
-
-	__asm__ __volatile__(
-		"mov   r8, %1	\n\t"
-		"trap0		\n\t"
-		: "+r"(filenm_n_ret)
-		: "i"(__NR_execve), "r"(arg2), "r"(arg3)
-		: "r8", "memory");
-
-	return filenm_n_ret;
-}
-EXPORT_SYMBOL(kernel_execve);
-
 SYSCALL_DEFINE1(arc_settls, void *, user_tls_data_ptr)
 {
 	task_thread_info(current)->thr_ptr = (unsigned int)user_tls_data_ptr;
diff --git a/arch/arc/kernel/sys.c b/arch/arc/kernel/sys.c
index 4c30345..f6bdd07 100644
--- a/arch/arc/kernel/sys.c
+++ b/arch/arc/kernel/sys.c
@@ -5,7 +5,6 @@
 
 #include <asm/syscalls.h>
 
-#define sys_execve	sys_execve_wrapper
 #define sys_clone	sys_clone_wrapper
 #define sys_fork	sys_fork_wrapper
 #define sys_vfork	sys_vfork_wrapper
-- 
1.7.4.1

