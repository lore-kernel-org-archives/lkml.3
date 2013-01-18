Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3ARMjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:39:36 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:55947 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3ARMd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:33:28 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 40/76] ARC: Switch to generic sys_clone, fork, vfork
Date: Fri, 18 Jan 2013 17:54:54 +0530
Message-ID: <1358511930-7424-41-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We still need the low level asm wrappers to save CALLEE regs, however
the core handlers sys_xxx now come from generic code

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/Kconfig              |    1 +
 arch/arc/include/asm/unistd.h |    3 +++
 arch/arc/kernel/entry.S       |   10 ----------
 arch/arc/kernel/process.c     |   40 +++++-----------------------------------
 4 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 3d5f940..8fb9264 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -9,6 +9,7 @@
 config ARC
 	def_bool y
 	select ARCH_NO_VIRT_TO_BUS
+	select CLONE_BACKWARDS
 	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
 	# DEVTMPS in turn needs HOTPLUG
 	select DEVTMPFS if !INITRAMFS_SOURCE=""
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
index 7841827..6f30484 100644
--- a/arch/arc/include/asm/unistd.h
+++ b/arch/arc/include/asm/unistd.h
@@ -9,6 +9,9 @@
 /******** no-legacy-syscalls-ABI *******/
 
 #define __ARCH_WANT_SYS_EXECVE
+#define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_VFORK
+#define __ARCH_WANT_SYS_FORK
 
 #define sys_mmap2 sys_mmap_pgoff
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 69a0c9f..6823f30 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -594,8 +594,6 @@ ARC_EXIT ret_from_fork
 
 ; TBD: call do_fork directly from here
 ARC_ENTRY sys_fork_wrapper
-	; copy pointer to pt_regs as a parameter
-	mov  r0, sp
 	SAVE_CALLEE_SAVED_USER
 	bl  @sys_fork
 	DISCARD_CALLEE_SAVED_USER
@@ -604,8 +602,6 @@ ARC_ENTRY sys_fork_wrapper
 ARC_EXIT sys_fork_wrapper
 
 ARC_ENTRY sys_vfork_wrapper
-	; copy pointer to pt_regs as a parameter
-	mov  r0, sp
 	SAVE_CALLEE_SAVED_USER
 	bl  @sys_vfork
 	DISCARD_CALLEE_SAVED_USER
@@ -614,12 +610,6 @@ ARC_ENTRY sys_vfork_wrapper
 ARC_EXIT sys_vfork_wrapper
 
 ARC_ENTRY sys_clone_wrapper
-	; clone sys-call takes 2 mandatary args: @flags and @child-stack
-	; and it can take 3 var-args, depending on flags
-	; To keep sys_clone( ) signature constant, we assume all 5 args
-	; and set the helper @prtegs in next free reg
-	; this is cheap since our args are in regs, not on stack
-	mov r5, sp  ; pt_regs
 	SAVE_CALLEE_SAVED_USER
 	bl  @sys_clone
 	DISCARD_CALLEE_SAVED_USER
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 403de7e..e2b119d 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -20,39 +20,6 @@
 #include <linux/elf.h>
 #include <linux/tick.h>
 
-asmlinkage int sys_fork(struct pt_regs *regs)
-{
-	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
-}
-
-asmlinkage int sys_vfork(struct pt_regs *regs)
-{
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0,
-		       NULL, NULL);
-}
-
-/* Per man, C-lib clone( ) is as follows
- *
- * int clone(int (*fn)(void *), void *child_stack,
- *           int flags, void *arg, ...
- *           pid_t *ptid, struct user_desc *tls, pid_t *ctid);
- *
- * @fn and @arg are of userland thread-hnalder and thus of no use
- * in sys-call, hence excluded in sys_clone arg list.
- * The only addition is ptregs, needed by fork core, although now-a-days
- * task_pt_regs() can be called anywhere to get that.
- */
-asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
-			 int __user *parent_tidptr, void *tls,
-			 int __user *child_tidptr, struct pt_regs *regs)
-{
-	if (!newsp)
-		newsp = regs->sp;
-
-	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr,
-		       child_tidptr);
-}
-
 SYSCALL_DEFINE1(arc_settls, void *, user_tls_data_ptr)
 {
 	task_thread_info(current)->thr_ptr = (unsigned int)user_tls_data_ptr;
@@ -132,12 +99,13 @@ asmlinkage void ret_from_fork(void);
  */
 int copy_thread(unsigned long clone_flags,
 		unsigned long usp, unsigned long arg,
-		struct task_struct *p, struct pt_regs *regs)
+		struct task_struct *p)
 {
 	struct pt_regs *c_regs;        /* child's pt_regs */
 	unsigned long *childksp;       /* to unwind out of __switch_to() */
 	struct callee_regs *c_callee;  /* child's callee regs */
 	struct callee_regs *parent_callee;  /* paren't callee */
+	struct pt_regs *regs = current_pt_regs();
 
 	/* Mark the specific anchors to begin with (see pic above) */
 	c_regs = task_pt_regs(p);
@@ -176,7 +144,9 @@ int copy_thread(unsigned long clone_flags,
 	/* Copy parents pt regs on child's kernel mode stack */
 	*c_regs = *regs;
 
-	c_regs->sp = usp;
+	if (usp)
+		c_regs->sp = usp;
+
 	c_regs->r0 = 0;		/* fork returns 0 in child */
 
 	parent_callee = ((struct callee_regs *)regs) - 1;
-- 
1.7.4.1

