Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaEHTMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbaEHTM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:27 -0400
Date: Thu, 8 May 2014 21:12:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] x86/traps: Introduce fill_trap_info(), simplify
	DO_ERROR_INFO()
Message-ID: <20140508191202.GA16923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the fill-siginfo code from DO_ERROR_INFO() into the new helper,
fill_trap_info().

It can calculate si_code and si_addr looking at trapnr, so we can remove
these arguments from DO_ERROR_INFO() and simplify the source code. The
generated code is the same, __builtin_constant_p(trapnr) == T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/traps.c |   53 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ab8dad7..1cf8a4c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -136,6 +136,33 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	return -1;
 }
 
+static void fill_trap_info(struct pt_regs *regs, int signr, int trapnr,
+			   siginfo_t *info)
+{
+	unsigned long siaddr;
+	int sicode;
+
+	switch (trapnr) {
+	case X86_TRAP_DE:
+		sicode = FPE_INTDIV;
+		siaddr = regs->ip;
+		break;
+	case X86_TRAP_UD:
+		sicode = ILL_ILLOPN;
+		siaddr = regs->ip;
+		break;
+	case X86_TRAP_AC:
+		sicode = BUS_ADRALN;
+		siaddr = 0;
+		break;
+	}
+
+	info->si_signo = signr;
+	info->si_errno = 0;
+	info->si_code = sicode;
+	info->si_addr = (void __user *)siaddr;
+}
+
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
@@ -191,30 +218,26 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	do_error_trap(regs, error_code, str, trapnr, signr, NULL);	\
 }
 
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
+#define DO_ERROR_INFO(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
 									\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-									\
+	fill_trap_info(regs, signr, trapnr, &info);			\
 	do_error_trap(regs, error_code, str, trapnr, signr, &info);	\
 }
 
-DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error,		     FPE_INTDIV, regs->ip )
-DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow					  )
-DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds						  )
-DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op,		     ILL_ILLOPN, regs->ip )
-DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun			  )
-DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS					  )
-DO_ERROR     (X86_TRAP_NP,     SIGBUS,  "segment not present",		segment_not_present				  )
+DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error)
+DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow)
+DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds)
+DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op)
+DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun)
+DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS)
+DO_ERROR     (X86_TRAP_NP,     SIGBUS,  "segment not present",		segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR     (X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment					  )
+DO_ERROR     (X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 #endif
-DO_ERROR_INFO(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check,	     BUS_ADRALN, 0	  )
+DO_ERROR_INFO(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
-- 
1.5.5.1

