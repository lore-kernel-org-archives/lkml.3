Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbbARLpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:45:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50998 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbbARLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:45:28 -0500
X-Sasl-enc: NTCv70KPO7LbhuMjzr6GU+vhOVefDfO3De9Zffnf4K14 1421581527
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCHv2 2/4] x86_64: embrace KERNEL_STACK_OFFSET
Date: Sun, 18 Jan 2015 12:45:18 +0100
Message-Id: <1421581520-2816-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERNEL_STACK_OFFSET is the offset from the top of the kernel stack
page to the value of the kernel_stack percpu variable. This patch
changes KERNEL_STACK_OFFSET to configure a reserved space of 16
bytes above the user ptregs frame. KERNEL_STACK_OFFSET must be
set to a multiple of 16 bytes due to the automatic stack alignment
of interrupts, traps, and exceptions on x86_64.

Also change task_pt_regs to be independant of the thread's current
sp0 setting, like i386, and use it to initialize thread.sp0 in
copy_thread.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/ia32/ia32entry.S          |  3 +--
 arch/x86/include/asm/processor.h   | 11 ++++++++---
 arch/x86/include/asm/thread_info.h | 13 ++++++++++++-
 arch/x86/kernel/entry_64.S         |  2 +-
 arch/x86/kernel/process_64.c       |  5 ++---
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 1c74f39..4c6c5d9 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -122,7 +122,6 @@ ENTRY(ia32_sysenter_target)
 	CFI_REGISTER	rsp,rbp
 	SWAPGS_UNSAFE_STACK
 	movq	PER_CPU_VAR(kernel_stack), %rsp
-	addq	$(KERNEL_STACK_OFFSET),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
@@ -304,7 +303,7 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,0,0
+	SAVE_ARGS 6*8,0,0	/* skip: hardware stackframe and orig_rax */
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq	%rcx,RIP-ARGOFFSET(%rsp)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a092a0c..97117d1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -919,11 +919,13 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 #define STACK_TOP_MAX		TASK_SIZE_MAX
 
 #define INIT_THREAD  { \
-	.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
+	.sp0 = (unsigned long)&init_stack + \
+		sizeof(init_stack) - KERNEL_STACK_OFFSET \
 }
 
 #define INIT_TSS  { \
-	.x86_tss.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
+	.x86_tss.sp0 = (unsigned long)&init_stack + \
+		sizeof(init_stack) - KERNEL_STACK_OFFSET \
 }
 
 /*
@@ -932,7 +934,10 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
  */
 #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
 
-#define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
+#define task_pt_regs(task) \
+	((struct pt_regs *)((unsigned long)task_stack_page(task) + \
+			THREAD_SIZE - KERNEL_STACK_OFFSET) - 1)
+
 extern unsigned long KSTK_ESP(struct task_struct *task);
 
 /*
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 471037d..9f0c47f 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -149,7 +149,18 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
 #define STACK_WARN		(THREAD_SIZE/8)
+
+/*
+ * Amount of reserved space between the top of the kernel stack page and the
+ * user ptregs frame.
+ * On x86_64, KERNEL_STACK_OFFSET must be set to a multiple of 16 bytes due
+ * to its automatic stack alignment for interrupts, traps, and exceptions.
+ */
+#ifdef CONFIG_X86_32
 #define KERNEL_STACK_OFFSET	(5*(BITS_PER_LONG/8))
+#else
+#define KERNEL_STACK_OFFSET	(2*(BITS_PER_LONG/8))
+#endif
 
 /*
  * macros/functions for gaining access to the thread information structure
@@ -190,7 +201,7 @@ static inline unsigned long current_stack_pointer(void)
  * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
  * a certain register (to be used in assembler memory operands).
  */
-#define THREAD_INFO(reg, off) PTREGS_SIZE-(off)-THREAD_SIZE(reg)
+#define THREAD_INFO(reg, off) PTREGS_SIZE+KERNEL_STACK_OFFSET-(off)-THREAD_SIZE(reg)
 
 #endif
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9f9ca20..6b95c2f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -339,7 +339,7 @@ GLOBAL(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8, 0, rax_enosys=1
+	SAVE_ARGS 6*8, 0, rax_enosys=1	/* skip: hardware stackframe and orig_rax */
 	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5a2c029..d579ebf 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -155,12 +155,11 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long arg, struct task_struct *p)
 {
 	int err;
-	struct pt_regs *childregs;
+	struct pt_regs *childregs = task_pt_regs(p);
 	struct task_struct *me = current;
 
-	p->thread.sp0 = (unsigned long)task_stack_page(p) + THREAD_SIZE;
-	childregs = task_pt_regs(p);
 	p->thread.sp = (unsigned long) childregs;
+	p->thread.sp0 = (unsigned long) (childregs + 1);
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
 	p->thread.io_bitmap_ptr = NULL;
-- 
2.1.0

