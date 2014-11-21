Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaKUV1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:27:18 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55636 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaKUV0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:26:30 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 4/5] x86: Clean up current_stack_pointer
Date: Fri, 21 Nov 2014 13:26:10 -0800
Message-Id: <e771b0f24aaff5d3ed8d8934e202c7a7f9c54526.1416604491.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no good reason for it to be a macro, and x86_64 will want to
use it, so it should be in a header.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/thread_info.h | 11 +++++++++++
 arch/x86/kernel/irq_32.c           | 13 +++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 547e344a6dc6..8b13b0fbda8e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -170,6 +170,17 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
+static inline unsigned long current_stack_pointer(void)
+{
+	unsigned long sp;
+#ifdef CONFIG_X86_64
+	asm("mov %%rsp,%0" : "=g" (sp));
+#else
+	asm("mov %%esp,%0" : "=g" (sp));
+#endif
+	return sp;
+}
+
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 63ce838e5a54..28d28f5eb8f4 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -69,16 +69,9 @@ static void call_on_stack(void *func, void *stack)
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
+	return (void *)(current_stack_pointer() & ~(THREAD_SIZE - 1));
 }
 
 static inline int
@@ -103,7 +96,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 
 	/* Save the next esp at the bottom of the stack */
 	prev_esp = (u32 *)irqstk;
-	*prev_esp = current_stack_pointer;
+	*prev_esp = current_stack_pointer();
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -156,7 +149,7 @@ void do_softirq_own_stack(void)
 
 	/* Push the previous esp onto the stack */
 	prev_esp = (u32 *)irqstk;
-	*prev_esp = current_stack_pointer;
+	*prev_esp = current_stack_pointer();
 
 	call_on_stack(__do_softirq, isp);
 }
-- 
1.9.3

