Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaIUSoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 14:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaIUSop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 14:44:45 -0400
Date: Sun, 21 Sep 2014 20:41:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] x86: reimplement ___preempt_schedule*() using THUNK
	helpers
Message-ID: <20140921184125.GA23719@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Ingo, please consider for inclusion.

Changes:

	v3: added the acks from Andy, otherwise unchanged

	v2: fix the naming in thunk_32.S (thanks Denys!)

And it seems that the patch below (on top of 1/2) also makes sense...

Oleg.

 arch/x86/kernel/Makefile  |    2 --
 arch/x86/kernel/preempt.S |   25 -------------------------
 arch/x86/lib/Makefile     |    2 +-
 arch/x86/lib/thunk_32.S   |   20 ++++++++++++++++----
 arch/x86/lib/thunk_64.S   |    7 +++++++
 5 files changed, 24 insertions(+), 32 deletions(-)


--- x/arch/x86/include/asm/irqflags.h
+++ x/arch/x86/include/asm/irqflags.h
@@ -166,8 +166,9 @@ static inline int arch_irqs_disabled(voi
 
 #else
 
-#ifdef CONFIG_X86_64
 #define ARCH_LOCKDEP_SYS_EXIT		call lockdep_sys_exit_thunk
+
+#ifdef CONFIG_X86_64
 #define ARCH_LOCKDEP_SYS_EXIT_IRQ	\
 	TRACE_IRQS_ON; \
 	sti; \
@@ -176,17 +177,7 @@ static inline int arch_irqs_disabled(voi
 	RESTORE_REST; \
 	cli; \
 	TRACE_IRQS_OFF;
-
 #else
-#define ARCH_LOCKDEP_SYS_EXIT			\
-	pushl %eax;				\
-	pushl %ecx;				\
-	pushl %edx;				\
-	call lockdep_sys_exit;			\
-	popl %edx;				\
-	popl %ecx;				\
-	popl %eax;
-
 #define ARCH_LOCKDEP_SYS_EXIT_IRQ
 #endif
 
--- x/arch/x86/lib/thunk_32.S
+++ x/arch/x86/lib/thunk_32.S
@@ -33,6 +33,10 @@
 	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
+#endif
+
 #ifdef CONFIG_PREEMPT
 	THUNK ___preempt_schedule, preempt_schedule
 #ifdef CONFIG_CONTEXT_TRACKING

