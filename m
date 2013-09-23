Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3IWPi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:38:28 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3IWPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:38:25 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] um: Make stack trace reliable against kernel mode faults
Date: Mon, 23 Sep 2013 17:38:02 +0200
Message-Id: <1379950684-18710-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379950684-18710-1-git-send-email-richard@nod.at>
References: <1379950684-18710-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As UML uses an alternative signal stack we cannot use
the current stack pointer for stack dumping if UML itself
dies by SIGSEGV. To bypass this issue we save regs taken
from mcontext in our segv handler into thread_struct and
use these regs to obtain the stack pointer in show_stack().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/processor-generic.h |  1 +
 arch/um/include/shared/os.h             |  1 +
 arch/um/kernel/sysrq.c                  | 32 +++++++++++++++++++++++---------
 arch/um/kernel/trap.c                   | 14 +++++++++++---
 arch/um/os-Linux/signal.c               |  8 ++++++++
 5 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index c03cd5a..9046903 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -21,6 +21,7 @@ struct mm_struct;
 struct thread_struct {
 	struct task_struct *saved_task;
 	struct pt_regs regs;
+	struct pt_regs *segv_regs;
 	int singlestep_syscall;
 	void *fault_addr;
 	jmp_buf *fault_catcher;
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 021104d..75298d3 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -227,6 +227,7 @@ extern void block_signals(void);
 extern void unblock_signals(void);
 extern int get_signals(void);
 extern int set_signals(int enable);
+extern int os_is_signal_stack(void);
 
 /* util.c */
 extern void stack_protections(unsigned long address);
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 33cc72e..7122bf9 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <asm/sysrq.h>
+#include <os.h>
 
 struct stack_frame {
 	struct stack_frame *next_frame;
@@ -48,29 +49,42 @@ static void print_stack_trace(unsigned long *sp, unsigned long bp)
 /*Stolen from arch/i386/kernel/traps.c */
 static const int kstack_depth_to_print = 24;
 
-static unsigned long get_frame_pointer(struct task_struct *task)
+static unsigned long get_frame_pointer(struct task_struct *task,
+				       struct pt_regs *segv_regs)
 {
 	if (!task || task == current)
-		return current_bp();
+		return segv_regs ? PT_REGS_BP(segv_regs) : current_bp();
 	else
 		return KSTK_EBP(task);
 }
 
+static unsigned long *get_stack_pointer(struct task_struct *task,
+					struct pt_regs *segv_regs)
+{
+	if (!task || task == current)
+		return segv_regs ? (unsigned long *)PT_REGS_SP(segv_regs) : current_sp();
+	else
+		return (unsigned long *)KSTK_ESP(task);
+}
+
 void show_stack(struct task_struct *task, unsigned long *stack)
 {
 	unsigned long *sp = stack, bp = 0;
+	struct pt_regs *segv_regs = current->thread.segv_regs;
 	int i;
 
+	if (!segv_regs && os_is_signal_stack()) {
+		printk(KERN_ERR "Received SIGSEGV in SIGSEGV handler,"
+				" aborting stack trace!\n");
+		return;
+	}
+
 #ifdef CONFIG_FRAME_POINTER
-	bp = get_frame_pointer(task);
+	bp = get_frame_pointer(task, segv_regs);
 #endif
 
-	if (!stack) {
-		if (!task || task == current)
-			sp = current_sp();
-		else
-			sp = (unsigned long *)KSTK_ESP(task);
-	}
+	if (!stack)
+		sp = get_stack_pointer(task, segv_regs);
 
 	printk(KERN_INFO "Stack:\n");
 	stack = sp;
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 5c3aef7..974b874 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -206,9 +206,12 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 	int is_write = FAULT_WRITE(fi);
 	unsigned long address = FAULT_ADDRESS(fi);
 
+	if (regs)
+		current->thread.segv_regs = container_of(regs, struct pt_regs, regs);
+
 	if (!is_user && (address >= start_vm) && (address < end_vm)) {
 		flush_tlb_kernel_vm();
-		return 0;
+		goto out;
 	}
 	else if (current->mm == NULL) {
 		show_regs(container_of(regs, struct pt_regs, regs));
@@ -230,7 +233,7 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 
 	catcher = current->thread.fault_catcher;
 	if (!err)
-		return 0;
+		goto out;
 	else if (catcher != NULL) {
 		current->thread.fault_addr = (void *) address;
 		UML_LONGJMP(catcher, 1);
@@ -238,7 +241,7 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 	else if (current->thread.fault_addr != NULL)
 		panic("fault_addr set but no fault catcher");
 	else if (!is_user && arch_fixup(ip, regs))
-		return 0;
+		goto out;
 
 	if (!is_user) {
 		show_regs(container_of(regs, struct pt_regs, regs));
@@ -262,6 +265,11 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 		current->thread.arch.faultinfo = fi;
 		force_sig_info(SIGSEGV, &si, current);
 	}
+
+out:
+	if (regs)
+		current->thread.segv_regs = NULL;
+
 	return 0;
 }
 
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 905924b..7b605e4 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -304,3 +304,11 @@ int set_signals(int enable)
 
 	return ret;
 }
+
+int os_is_signal_stack(void)
+{
+	stack_t ss;
+	sigaltstack(NULL, &ss);
+
+	return ss.ss_flags & SS_ONSTACK;
+}
-- 
1.8.3.1

