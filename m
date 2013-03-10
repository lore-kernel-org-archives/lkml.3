Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3CJSlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab3CJSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:41:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/6] signal x86: Propage RF EFLAGS bit throught the signal restore call
Date: Sun, 10 Mar 2013 19:41:06 +0100
Message-Id: <1362940871-24486-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding RF EFLAGS bit to be restored on return from signal from
the original register context before the signal was entered.

This will prevent the RF flag to disappear when returning
from exception due to the signal handler being executed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/ia32/ia32_signal.c        | 2 --
 arch/x86/include/asm/sighandling.h | 4 ++--
 arch/x86/kernel/signal.c           | 6 ------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index cf1a471..bccfca6 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -34,8 +34,6 @@
 #include <asm/sys_ia32.h>
 #include <asm/smap.h>
 
-#define FIX_EFLAGS	__FIX_EFLAGS
-
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
index beff97f..7a95816 100644
--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -7,10 +7,10 @@
 
 #include <asm/processor-flags.h>
 
-#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+#define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
 			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
 			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
+			 X86_EFLAGS_CF | X86_EFLAGS_RF)
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 6956299..9df4c0b 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -43,12 +43,6 @@
 
 #include <asm/sigframe.h>
 
-#ifdef CONFIG_X86_32
-# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
-#else
-# define FIX_EFLAGS	__FIX_EFLAGS
-#endif
-
 #define COPY(x)			do {			\
 	get_user_ex(regs->x, &sc->x);			\
 } while (0)
-- 
1.7.11.7

