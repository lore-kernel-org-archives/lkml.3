Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaBSGX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:23:27 -0500
Received: from koorogi.info ([198.74.62.75]:34674 "EHLO mail.koorogi.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaBSGWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:22:37 -0500
From: Bobby Bingham <koorogi@koorogi.info>
To: akpm@linux-foundation.org, linux-sh@vger.kernel.org
Cc: Bobby Bingham <koorogi@koorogi.info>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] sh: push extra copy of r0-r2 for syscall parameters
Date: Wed, 19 Feb 2014 00:03:14 -0600
Message-Id: <1f63c4a163e891cf7910627a89cd2aa3826ea657.1392789383.git.koorogi@koorogi.info>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <cover.1392789383.git.koorogi@koorogi.info>
References: <cover.1392789383.git.koorogi@koorogi.info>
In-Reply-To: <cover.1392789383.git.koorogi@koorogi.info>
References: <cover.1392789383.git.koorogi@koorogi.info>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace registers are stored at the top of the stack when the syscall
handler is invoked, which allows r0-r2 to act as parameters 5-7. Parameters
passed on the stack may be clobbered by the syscall handler. The solution
is to push an extra copy of the registers which might be used as syscall
parameters to the stack, so that the authoritative set of saved register
values does not get clobbered.

A few system call handlers are also updated to get the userspace registers
using current_pt_regs() instead of from the stack.

Signed-off-by: Bobby Bingham <koorogi@koorogi.info>
---
 arch/sh/include/asm/syscalls_32.h | 12 +++---------
 arch/sh/kernel/entry-common.S     | 15 +++++++++++----
 arch/sh/kernel/signal_32.c        | 12 ++++--------
 arch/sh/kernel/sys_sh32.c         |  7 ++-----
 4 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/sh/include/asm/syscalls_32.h b/arch/sh/include/asm/syscalls_32.h
index 4f97df8..4f643aa 100644
--- a/arch/sh/include/asm/syscalls_32.h
+++ b/arch/sh/include/asm/syscalls_32.h
@@ -9,15 +9,9 @@
 
 struct pt_regs;
 
-asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
-			     unsigned long r6, unsigned long r7,
-			     struct pt_regs __regs);
-asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage int sys_sh_pipe(unsigned long r4, unsigned long r5,
-			   unsigned long r6, unsigned long r7,
-			   struct pt_regs __regs);
+asmlinkage int sys_sigreturn(void);
+asmlinkage int sys_rt_sigreturn(void);
+asmlinkage int sys_sh_pipe(void);
 asmlinkage ssize_t sys_pread_wrapper(unsigned int fd, char __user *buf,
 				     size_t count, long dummy, loff_t pos);
 asmlinkage ssize_t sys_pwrite_wrapper(unsigned int fd, const char __user *buf,
diff --git a/arch/sh/kernel/entry-common.S b/arch/sh/kernel/entry-common.S
index ca46834..13047a4 100644
--- a/arch/sh/kernel/entry-common.S
+++ b/arch/sh/kernel/entry-common.S
@@ -193,10 +193,10 @@ syscall_trace_entry:
 	!			Reload R0-R4 from kernel stack, where the
 	!   	    	    	parent may have modified them using
 	!   	    	    	ptrace(POKEUSR).  (Note that R0-R2 are
-	!   	    	    	used by the system call handler directly
-	!   	    	    	from the kernel stack anyway, so don't need
-	!   	    	    	to be reloaded here.)  This allows the parent
-	!   	    	    	to rewrite system calls and args on the fly.
+	!   	    	    	reloaded from the kernel stack by syscall_call
+	!   	    	    	below, so don't need to be reloaded here.)
+	!   	    	    	This allows the parent to rewrite system calls
+	!   	    	    	and args on the fly.
 	mov.l	@(OFF_R4,r15), r4   ! arg0
 	mov.l	@(OFF_R5,r15), r5
 	mov.l	@(OFF_R6,r15), r6
@@ -357,8 +357,15 @@ syscall_call:
 	mov.l	3f, r8		! Load the address of sys_call_table
 	add	r8, r3
 	mov.l	@r3, r8
+	mov.l	@(OFF_R2,r15), r2
+	mov.l	@(OFF_R1,r15), r1
+	mov.l	@(OFF_R0,r15), r0
+	mov.l	r2, @-r15
+	mov.l	r1, @-r15
+	mov.l	r0, @-r15
 	jsr	@r8	    	! jump to specific syscall handler
 	 nop
+	add	#12, r15
 	mov.l	@(OFF_R0,r15), r12		! save r0
 	mov.l	r0, @(OFF_R0,r15)		! save the return value
 	!
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 6af6e7c..594cd37 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -148,11 +148,9 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p
 	return err;
 }
 
-asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
-			     unsigned long r6, unsigned long r7,
-			     struct pt_regs __regs)
+asmlinkage int sys_sigreturn(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	struct sigframe __user *frame = (struct sigframe __user *)regs->regs[15];
 	sigset_t set;
 	int r0;
@@ -180,11 +178,9 @@ badframe:
 	return 0;
 }
 
-asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage int sys_rt_sigreturn(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame = (struct rt_sigframe __user *)regs->regs[15];
 	sigset_t set;
 	int r0;
diff --git a/arch/sh/kernel/sys_sh32.c b/arch/sh/kernel/sys_sh32.c
index 497bab3..b66d1c6 100644
--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -21,17 +21,14 @@
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
-asmlinkage int sys_sh_pipe(unsigned long r4, unsigned long r5,
-	unsigned long r6, unsigned long r7,
-	struct pt_regs __regs)
+asmlinkage int sys_sh_pipe(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	int fd[2];
 	int error;
 
 	error = do_pipe_flags(fd, 0);
 	if (!error) {
-		regs->regs[1] = fd[1];
+		current_pt_regs()->regs[1] = fd[1];
 		return fd[0];
 	}
 	return error;
-- 
1.8.5.5

