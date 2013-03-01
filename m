Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3CAQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:09:28 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:35332 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3CAQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:09:25 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] context_tracking: Move exception handling to generic code
Date: Fri,  1 Mar 2013 17:08:55 +0100
Message-Id: <1362154139-1139-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
References: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exceptions handling on context tracking should share common
treatment: on entry we exit user mode if the exception triggered
in that context. Then on exception exit we return to that previous
context.

Generalize this to avoid duplication across archs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/context_tracking.h |   21 ---------------------
 arch/x86/kernel/kvm.c                   |    2 +-
 arch/x86/kernel/traps.c                 |    3 +--
 arch/x86/mm/fault.c                     |    2 +-
 include/linux/context_tracking.h        |   17 ++++++++++++++++-
 5 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/context_tracking.h b/arch/x86/include/asm/context_tracking.h
index 1616562..1fe4970 100644
--- a/arch/x86/include/asm/context_tracking.h
+++ b/arch/x86/include/asm/context_tracking.h
@@ -1,31 +1,10 @@
 #ifndef _ASM_X86_CONTEXT_TRACKING_H
 #define _ASM_X86_CONTEXT_TRACKING_H
 
-#ifndef __ASSEMBLY__
-#include <linux/context_tracking.h>
-#include <asm/ptrace.h>
-
-static inline void exception_enter(struct pt_regs *regs)
-{
-	user_exit();
-}
-
-static inline void exception_exit(struct pt_regs *regs)
-{
-#ifdef CONFIG_CONTEXT_TRACKING
-	if (user_mode(regs))
-		user_enter();
-#endif
-}
-
-#else /* __ASSEMBLY__ */
-
 #ifdef CONFIG_CONTEXT_TRACKING
 # define SCHEDULE_USER call schedule_user
 #else
 # define SCHEDULE_USER call schedule
 #endif
 
-#endif /* !__ASSEMBLY__ */
-
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 2b44ea5..1effefa 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -20,6 +20,7 @@
  *   Authors: Anthony Liguori <aliguori@us.ibm.com>
  */
 
+#include <linux/context_tracking.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/kvm_para.h>
@@ -43,7 +44,6 @@
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
 #include <asm/kvm_guest.h>
-#include <asm/context_tracking.h>
 
 static int kvmapf = 1;
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ecffca1..be079a6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/context_tracking.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
@@ -55,8 +56,6 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
-#include <asm/context_tracking.h>
-
 #include <asm/mach_traps.h>
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fb674fd..6d1e11f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -13,12 +13,12 @@
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
+#include <linux/context_tracking.h>	/* exception_enter(), ...	*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
-#include <asm/context_tracking.h>	/* exception_enter(), ...	*/
 
 /*
  * Page fault error code bits:
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index b28d161..5a69273 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -1,10 +1,11 @@
 #ifndef _LINUX_CONTEXT_TRACKING_H
 #define _LINUX_CONTEXT_TRACKING_H
 
-#ifdef CONFIG_CONTEXT_TRACKING
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <asm/ptrace.h>
 
+#ifdef CONFIG_CONTEXT_TRACKING
 struct context_tracking {
 	/*
 	 * When active is false, probes are unset in order
@@ -33,12 +34,26 @@ static inline bool context_tracking_active(void)
 
 extern void user_enter(void);
 extern void user_exit(void);
+
+static inline void exception_enter(struct pt_regs *regs)
+{
+	user_exit();
+}
+
+static inline void exception_exit(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		user_enter();
+}
+
 extern void context_tracking_task_switch(struct task_struct *prev,
 					 struct task_struct *next);
 #else
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
+static inline void exception_enter(struct pt_regs *regs) { }
+static inline void exception_exit(struct pt_regs *regs) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
 						struct task_struct *next) { }
 #endif /* !CONFIG_CONTEXT_TRACKING */
-- 
1.7.5.4

