Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJLQsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:48:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60958 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaJLQsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:48:08 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20141012114353.4aa73c00@as>
References: <20141012114353.4aa73c00@as>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86: Clean up stack access code in irq_32.c
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 12 Oct 2014 09:47:53 -0700
To: Chuck Ebbert <cebbert.lkml@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Message-ID: <17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed this to asm because the C broke some compilers.  Why are you changing it back?

On October 12, 2014 9:43:53 AM PDT, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
>Use C instead of asm for accessing the stack pointer. And define some
>macros to make the code easier to understand.
>
>Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>
>
>diff --git a/arch/x86/include/asm/page_32_types.h
>b/arch/x86/include/asm/page_32_types.h
>index f48b17d..a8ca0cb 100644
>--- a/arch/x86/include/asm/page_32_types.h
>+++ b/arch/x86/include/asm/page_32_types.h
>@@ -19,6 +19,8 @@
> 
> #define THREAD_SIZE_ORDER	1
> #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
>+#define THREAD_SIZE_MASK	(THREAD_SIZE - 1)
>+#define CURRENT_MASK		(~THREAD_SIZE_MASK)
> 
> #define STACKFAULT_STACK 0
> #define DOUBLEFAULT_STACK 1
>diff --git a/arch/x86/include/asm/page_64_types.h
>b/arch/x86/include/asm/page_64_types.h
>index 6782051..ded89b0 100644
>--- a/arch/x86/include/asm/page_64_types.h
>+++ b/arch/x86/include/asm/page_64_types.h
>@@ -2,8 +2,9 @@
> #define _ASM_X86_PAGE_64_DEFS_H
> 
> #define THREAD_SIZE_ORDER	2
>-#define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
>-#define CURRENT_MASK (~(THREAD_SIZE - 1))
>+#define THREAD_SIZE  		(PAGE_SIZE << THREAD_SIZE_ORDER)
>+#define THREAD_SIZE_MASK	(THREAD_SIZE - 1)
>+#define CURRENT_MASK		(~THREAD_SIZE_MASK)
> 
> #define EXCEPTION_STACK_ORDER 0
> #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
>diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
>index 63ce838..bef90fc 100644
>--- a/arch/x86/kernel/irq_32.c
>+++ b/arch/x86/kernel/irq_32.c
>@@ -27,6 +27,12 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
> DEFINE_PER_CPU(struct pt_regs *, irq_regs);
> EXPORT_PER_CPU_SYMBOL(irq_regs);
> 
>+/* how to get the current stack pointer from C */
>+#define current_stack_pointer ({		\
>+	register unsigned long sp asm("esp");	\
>+	sp;					\
>+})
>+
> #ifdef CONFIG_DEBUG_STACKOVERFLOW
> 
> int sysctl_panic_on_stackoverflow __read_mostly;
>@@ -34,12 +40,8 @@ int sysctl_panic_on_stackoverflow __read_mostly;
> /* Debugging check for stack overflow: is there less than 1KB free? */
> static int check_stack_overflow(void)
> {
>-	long sp;
>-
>-	__asm__ __volatile__("andl %%esp,%0" :
>-			     "=r" (sp) : "0" (THREAD_SIZE - 1));
>-
>-	return sp < (sizeof(struct thread_info) + STACK_WARN);
>+	return (current_stack_pointer & THREAD_SIZE_MASK)
>+	       < sizeof(struct thread_info) + STACK_WARN;
> }
> 
> static void print_stack_overflow(void)
>@@ -69,16 +71,9 @@ static void call_on_stack(void *func, void *stack)
> 		     : "memory", "cc", "edx", "ecx", "eax");
> }
> 
>-/* how to get the current stack pointer from C */
>-#define current_stack_pointer ({		\
>-	unsigned long sp;			\
>-	asm("mov %%esp,%0" : "=g" (sp));	\
>-	sp;					\
>-})
>-
> static inline void *current_stack(void)
> {
>-	return (void *)(current_stack_pointer & ~(THREAD_SIZE - 1));
>+	return (void *)(current_stack_pointer & CURRENT_MASK);
> }
> 
> static inline int

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
