Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaJLQn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:43:58 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:56956 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaJLQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:43:57 -0400
Date: Sun, 12 Oct 2014 11:43:53 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Clean up stack access code in irq_32.c
Message-ID: <20141012114353.4aa73c00@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use C instead of asm for accessing the stack pointer. And define some
macros to make the code easier to understand.

Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>

diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index f48b17d..a8ca0cb 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -19,6 +19,8 @@
 
 #define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_SIZE_MASK	(THREAD_SIZE - 1)
+#define CURRENT_MASK		(~THREAD_SIZE_MASK)
 
 #define STACKFAULT_STACK 0
 #define DOUBLEFAULT_STACK 1
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 6782051..ded89b0 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -2,8 +2,9 @@
 #define _ASM_X86_PAGE_64_DEFS_H
 
 #define THREAD_SIZE_ORDER	2
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
-#define CURRENT_MASK (~(THREAD_SIZE - 1))
+#define THREAD_SIZE  		(PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_SIZE_MASK	(THREAD_SIZE - 1)
+#define CURRENT_MASK		(~THREAD_SIZE_MASK)
 
 #define EXCEPTION_STACK_ORDER 0
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 63ce838..bef90fc 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -27,6 +27,12 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
+/* how to get the current stack pointer from C */
+#define current_stack_pointer ({		\
+	register unsigned long sp asm("esp");	\
+	sp;					\
+})
+
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 
 int sysctl_panic_on_stackoverflow __read_mostly;
@@ -34,12 +40,8 @@ int sysctl_panic_on_stackoverflow __read_mostly;
 /* Debugging check for stack overflow: is there less than 1KB free? */
 static int check_stack_overflow(void)
 {
-	long sp;
-
-	__asm__ __volatile__("andl %%esp,%0" :
-			     "=r" (sp) : "0" (THREAD_SIZE - 1));
-
-	return sp < (sizeof(struct thread_info) + STACK_WARN);
+	return (current_stack_pointer & THREAD_SIZE_MASK)
+	       < sizeof(struct thread_info) + STACK_WARN;
 }
 
 static void print_stack_overflow(void)
@@ -69,16 +71,9 @@ static void call_on_stack(void *func, void *stack)
 		     : "memory", "cc", "edx", "ecx", "eax");
 }
 
-/* how to get the current stack pointer from C */
-#define current_stack_pointer ({		\
-	unsigned long sp;			\
-	asm("mov %%esp,%0" : "=g" (sp));	\
-	sp;					\
-})
-
 static inline void *current_stack(void)
 {
-	return (void *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+	return (void *)(current_stack_pointer & CURRENT_MASK);
 }
 
 static inline int
