Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaD2HYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:24:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46391 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599AbaD2HYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:24:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/2] fentry: x86, cleanup function_hook uses
Date: Tue, 29 Apr 2014 09:24:07 +0200
Message-Id: <1398756247-29536-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398756247-29536-1-git-send-email-jslaby@suse.cz>
References: <1398756247-29536-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's define fentry_hook depending on CC_USING_FENTRY and use that
macro all over. This saves some #ifdef's here and there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/include/asm/fentry.h    | 14 ++++++++++++++
 arch/x86/include/asm/ftrace.h    | 10 +++-------
 arch/x86/kernel/entry_64.S       | 15 +++++----------
 arch/x86/kernel/x8664_ksyms_64.c |  8 ++------
 4 files changed, 24 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/include/asm/fentry.h

diff --git a/arch/x86/include/asm/fentry.h b/arch/x86/include/asm/fentry.h
new file mode 100644
index 000000000000..febe8d272f0f
--- /dev/null
+++ b/arch/x86/include/asm/fentry.h
@@ -0,0 +1,14 @@
+#ifndef ASM_FENTRY_H
+#define ASM_FENTRY_H
+
+#ifdef CC_USING_FENTRY
+# define fentry_hook	__fentry__
+#else
+# define fentry_hook	mcount
+#endif
+
+#ifndef __ASSEMBLY__
+extern void fentry_hook(void);
+#endif /* __ASSEMBLY__ */
+
+#endif /* ASM_FENTRY_H */
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 0525a8bdf65d..7df5477e26ec 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
+#include <asm/fentry.h>
+
 #ifdef __ASSEMBLY__
 
 	/* skip is set if the stack was already partially adjusted */
@@ -35,11 +37,7 @@
 #endif
 
 #ifdef CONFIG_FUNCTION_TRACER
-#ifdef CC_USING_FENTRY
-# define MCOUNT_ADDR		((long)(__fentry__))
-#else
-# define MCOUNT_ADDR		((long)(mcount))
-#endif
+#define MCOUNT_ADDR		((long)(fentry_hook))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -47,9 +45,7 @@
 #endif
 
 #ifndef __ASSEMBLY__
-extern void mcount(void);
 extern atomic_t modifying_ftrace_code;
-extern void __fentry__(void);
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 43bb38951660..a3616e0a4e6c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -52,6 +52,7 @@
 #include <asm/hw_irq.h>
 #include <asm/page_types.h>
 #include <asm/irqflags.h>
+#include <asm/fentry.h>
 #include <asm/paravirt.h>
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
@@ -71,17 +72,11 @@
 
 #ifdef CONFIG_FUNCTION_TRACER
 
-#ifdef CC_USING_FENTRY
-# define function_hook	__fentry__
-#else
-# define function_hook	mcount
-#endif
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-ENTRY(function_hook)
+ENTRY(fentry_hook)
 	retq
-END(function_hook)
+END(fentry_hook)
 
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup skip=0
@@ -196,7 +191,7 @@ END(ftrace_regs_caller)
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
-ENTRY(function_hook)
+ENTRY(fentry_hook)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
@@ -230,7 +225,7 @@ trace:
 	MCOUNT_RESTORE_FRAME
 
 	jmp ftrace_stub
-END(function_hook)
+END(fentry_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
 
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 040681928e9d..ba9878e6ee8f 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -10,15 +10,11 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/desc.h>
-#include <asm/ftrace.h>
+#include <asm/fentry.h>
 
 #ifdef CONFIG_FUNCTION_TRACER
 /* mcount and __fentry__ are defined in assembly */
-#ifdef CC_USING_FENTRY
-EXPORT_SYMBOL(__fentry__);
-#else
-EXPORT_SYMBOL(mcount);
-#endif
+EXPORT_SYMBOL(fentry_hook);
 #endif
 
 EXPORT_SYMBOL(__get_user_1);
-- 
1.9.2

