Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3EVWK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3EVWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 21/21] x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)
Date: Wed, 22 May 2013 15:10:39 -0700
Message-Id: <20130522205235.095666610@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander van Heukelum <heukelum@fastmail.fm>

commit 5522ddb3fc0dfd4a503c8278eafd88c9f2d3fada upstream.

Commit 49cb25e9290 x86: 'get rid of pt_regs argument in vm86/vm86old'
got rid of the pt_regs stub for sys_vm86old and sys_vm86. The functions
were, however, not changed to use the calling convention for syscalls.

[AV: killed asmlinkage_protect() - it's done automatically now]

Backported-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Reported-and-tested-by: Hans de Bruin <jmdebruin@xmsnet.nl>
Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/syscalls.h |    4 ++--
 arch/x86/kernel/vm86_32.c       |   11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -37,8 +37,8 @@ asmlinkage int sys_get_thread_area(struc
 unsigned long sys_sigreturn(void);
 
 /* kernel/vm86_32.c */
-int sys_vm86old(struct vm86_struct __user *);
-int sys_vm86(unsigned long, unsigned long);
+asmlinkage long sys_vm86old(struct vm86_struct __user *);
+asmlinkage long sys_vm86(unsigned long, unsigned long);
 
 #else /* CONFIG_X86_32 */
 
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -33,6 +33,7 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/syscalls.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
@@ -48,7 +49,6 @@
 #include <asm/io.h>
 #include <asm/tlbflush.h>
 #include <asm/irq.h>
-#include <asm/syscalls.h>
 
 /*
  * Known problems:
@@ -202,17 +202,16 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-int sys_vm86old(struct vm86_struct __user *v86)
+SYSCALL_DEFINE1(vm86old, struct vm86_struct __user *, v86)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
 					 * This remains on the stack until we
 					 * return to 32 bit user space.
 					 */
-	struct task_struct *tsk;
+	struct task_struct *tsk = current;
 	int tmp, ret = -EPERM;
 
-	tsk = current;
 	if (tsk->thread.saved_sp0)
 		goto out;
 	tmp = copy_vm86_regs_from_user(&info.regs, &v86->regs,
@@ -227,11 +226,12 @@ int sys_vm86old(struct vm86_struct __use
 	do_sys_vm86(&info, tsk);
 	ret = 0;	/* we never return here */
 out:
+	asmlinkage_protect(1, ret, v86);
 	return ret;
 }
 
 
-int sys_vm86(unsigned long cmd, unsigned long arg)
+SYSCALL_DEFINE2(vm86, unsigned long, cmd, unsigned long, arg)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -278,6 +278,7 @@ int sys_vm86(unsigned long cmd, unsigned
 	do_sys_vm86(&info, tsk);
 	ret = 0;	/* we never return here */
 out:
+	asmlinkage_protect(2, ret, cmd, arg);
 	return ret;
 }
 


