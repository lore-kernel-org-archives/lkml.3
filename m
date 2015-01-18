Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbbARLqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:46:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49149 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbbARLpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:45:30 -0500
X-Sasl-enc: 3hx7lvGo2E+sDwwUQKEqylBB8EcjAHbBdVr99zlmZOsw 1421581529
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCHv2 3/4] i386: clean up KERNEL_STACK_OFFSET
Date: Sun, 18 Jan 2015 12:45:19 +0100
Message-Id: <1421581520-2816-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i386, 8 bytes are reserved above the user ptregs frame. The area is
unused, but "necessary to guarantee that the entire "struct pt_regs" is
accessible even if the CPU haven't stored the SS/ESP registers on the
stack (interrupt gate does not save these registers when switching to
the same priv ring)."

Use KERNEL_STACK_OFFSET to make the size of this area configurable and
remove the difference between the sp0 setting in the tss and the percpu
variable kernel_stack.

For i386, KERNEL_STACK_OFFSET must be at least 8 bytes for the reason
mentioned above and must be a multiple of 4 bytes, the minimal stack
alignment.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/include/asm/processor.h   | 32 +++++++-------------------------
 arch/x86/include/asm/thread_info.h | 10 ++++++----
 arch/x86/kernel/entry_32.S         |  5 +++--
 3 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 97117d1..f424e5f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -842,7 +842,8 @@ static inline void spin_lock_prefetch(const void *x)
 #define STACK_TOP_MAX		STACK_TOP
 
 #define INIT_THREAD  {							  \
-	.sp0			= sizeof(init_stack) + (long)&init_stack, \
+	.sp0			= sizeof(init_stack) + (long)&init_stack  \
+						- KERNEL_STACK_OFFSET,    \
 	.vm86_info		= NULL,					  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
@@ -856,7 +857,8 @@ static inline void spin_lock_prefetch(const void *x)
  */
 #define INIT_TSS  {							  \
 	.x86_tss = {							  \
-		.sp0		= sizeof(init_stack) + (long)&init_stack, \
+		.sp0		= sizeof(init_stack) + (long)&init_stack  \
+						- KERNEL_STACK_OFFSET,    \
 		.ss0		= __KERNEL_DS,				  \
 		.ss1		= __KERNEL_CS,				  \
 		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,		  \
@@ -866,29 +868,9 @@ static inline void spin_lock_prefetch(const void *x)
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
-#define THREAD_SIZE_LONGS      (THREAD_SIZE/sizeof(unsigned long))
-#define KSTK_TOP(info)                                                 \
-({                                                                     \
-       unsigned long *__ptr = (unsigned long *)(info);                 \
-       (unsigned long)(&__ptr[THREAD_SIZE_LONGS]);                     \
-})
-
-/*
- * The below -8 is to reserve 8 bytes on top of the ring0 stack.
- * This is necessary to guarantee that the entire "struct pt_regs"
- * is accessible even if the CPU haven't stored the SS/ESP registers
- * on the stack (interrupt gate does not save these registers
- * when switching to the same priv ring).
- * Therefore beware: accessing the ss/esp fields of the
- * "struct pt_regs" is possible, but they may contain the
- * completely wrong values.
- */
-#define task_pt_regs(task)                                             \
-({                                                                     \
-       struct pt_regs *__regs__;                                       \
-       __regs__ = (struct pt_regs *)(KSTK_TOP(task_stack_page(task))-8); \
-       __regs__ - 1;                                                   \
-})
+#define task_pt_regs(task) \
+	((struct pt_regs *)((unsigned long)task_stack_page(task) + \
+			THREAD_SIZE - KERNEL_STACK_OFFSET) - 1)
 
 #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 9f0c47f..36b8a10 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -153,14 +153,16 @@ struct thread_info {
 /*
  * Amount of reserved space between the top of the kernel stack page and the
  * user ptregs frame.
+ * On i386, this is necessary to guarantee that the entire "struct pt_regs"
+ * is accessible even if the CPU hasn't stored the SS/ESP registers on the
+ * stack (an interrupt gate does not save these registers when switching to
+ * the same priv ring). Therefore beware: accessing the ss/esp fields of the
+ * "struct pt_regs" is possible, but they may contain the completely wrong
+ * values.
  * On x86_64, KERNEL_STACK_OFFSET must be set to a multiple of 16 bytes due
  * to its automatic stack alignment for interrupts, traps, and exceptions.
  */
-#ifdef CONFIG_X86_32
-#define KERNEL_STACK_OFFSET	(5*(BITS_PER_LONG/8))
-#else
 #define KERNEL_STACK_OFFSET	(2*(BITS_PER_LONG/8))
-#endif
 
 /*
  * macros/functions for gaining access to the thread information structure
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 000d419..e94b994 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -396,9 +396,10 @@ sysenter_past_esp:
 	/*
 	 * Push current_thread_info()->sysenter_return to the stack.
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
-	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
+	 * pushed above; KERNEL_STACK_OFFSET corresponds to copy_thread's
+	 * esp0 setting.
 	 */
-	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE+8+4*4)(%esp)
+	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE+KERNEL_STACK_OFFSET+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
-- 
2.1.0

