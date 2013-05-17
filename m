Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3EQWVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:21:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab3EQVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 027/102] x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)
Date: Fri, 17 May 2013 14:35:42 -0700
Message-Id: <20130517213247.228264908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
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

Reported-and-tested-by: Hans de Bruin <jmdebruin@xmsnet.nl>
Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/syscalls.h |    4 ++--
 arch/x86/kernel/vm86_32.c       |   38 ++++++++++++++------------------------
 2 files changed, 16 insertions(+), 26 deletions(-)

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
@@ -202,36 +202,32 @@ out:
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
-	int tmp, ret = -EPERM;
+	struct task_struct *tsk = current;
+	int tmp;
 
-	tsk = current;
 	if (tsk->thread.saved_sp0)
-		goto out;
+		return -EPERM;
 	tmp = copy_vm86_regs_from_user(&info.regs, &v86->regs,
 				       offsetof(struct kernel_vm86_struct, vm86plus) -
 				       sizeof(info.regs));
-	ret = -EFAULT;
 	if (tmp)
-		goto out;
+		return -EFAULT;
 	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
 	info.regs32 = current_pt_regs();
 	tsk->thread.vm86_info = v86;
 	do_sys_vm86(&info, tsk);
-	ret = 0;	/* we never return here */
-out:
-	return ret;
+	return 0;	/* we never return here */
 }
 
 
-int sys_vm86(unsigned long cmd, unsigned long arg)
+SYSCALL_DEFINE2(vm86, unsigned long, cmd, unsigned long, arg)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -239,7 +235,7 @@ int sys_vm86(unsigned long cmd, unsigned
 					 * return to 32 bit user space.
 					 */
 	struct task_struct *tsk;
-	int tmp, ret;
+	int tmp;
 	struct vm86plus_struct __user *v86;
 
 	tsk = current;
@@ -248,8 +244,7 @@ int sys_vm86(unsigned long cmd, unsigned
 	case VM86_FREE_IRQ:
 	case VM86_GET_IRQ_BITS:
 	case VM86_GET_AND_RESET_IRQ:
-		ret = do_vm86_irq_handling(cmd, (int)arg);
-		goto out;
+		return do_vm86_irq_handling(cmd, (int)arg);
 	case VM86_PLUS_INSTALL_CHECK:
 		/*
 		 * NOTE: on old vm86 stuff this will return the error
@@ -257,28 +252,23 @@ int sys_vm86(unsigned long cmd, unsigned
 		 *  interpreted as (invalid) address to vm86_struct.
 		 *  So the installation check works.
 		 */
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	/* we come here only for functions VM86_ENTER, VM86_ENTER_NO_BYPASS */
-	ret = -EPERM;
 	if (tsk->thread.saved_sp0)
-		goto out;
+		return -EPERM;
 	v86 = (struct vm86plus_struct __user *)arg;
 	tmp = copy_vm86_regs_from_user(&info.regs, &v86->regs,
 				       offsetof(struct kernel_vm86_struct, regs32) -
 				       sizeof(info.regs));
-	ret = -EFAULT;
 	if (tmp)
-		goto out;
+		return -EFAULT;
 	info.regs32 = current_pt_regs();
 	info.vm86plus.is_vm86pus = 1;
 	tsk->thread.vm86_info = (struct vm86_struct __user *)v86;
 	do_sys_vm86(&info, tsk);
-	ret = 0;	/* we never return here */
-out:
-	return ret;
+	return 0;	/* we never return here */
 }
 
 


