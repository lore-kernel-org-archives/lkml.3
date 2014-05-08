Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaEHTMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaEHTM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:28 -0400
Date: Thu, 8 May 2014 21:11:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] x86/traps: Introduce do_error_trap()
Message-ID: <20140508191159.GA16917@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the common code from DO_ERROR() and DO_ERROR_INFO() into the new
helper, do_error_trap(). This simplifies define's and shaves 527 bytes
from traps.o.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/traps.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2cd4291..ab8dad7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -171,41 +171,37 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	force_sig_info(signr, info ?: SEND_SIG_PRIV, tsk);
 }
 
+static void do_error_trap(struct pt_regs *regs, long error_code, char *str,
+			  unsigned long trapnr, int signr, siginfo_t *info)
+{
+	enum ctx_state prev_state = exception_enter();
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) !=
+			NOTIFY_STOP) {
+		conditional_sti(regs);
+		do_trap(trapnr, signr, str, regs, error_code, info);
+	}
+
+	exception_exit(prev_state);
+}
+
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	enum ctx_state prev_state;					\
-									\
-	prev_state = exception_enter();					\
-	if (notify_die(DIE_TRAP, str, regs, error_code,			\
-			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(prev_state);				\
-		return;							\
-	}								\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
-	exception_exit(prev_state);					\
+	do_error_trap(regs, error_code, str, trapnr, signr, NULL);	\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
-	enum ctx_state prev_state;					\
 									\
 	info.si_signo = signr;						\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	prev_state = exception_enter();					\
-	if (notify_die(DIE_TRAP, str, regs, error_code,			\
-			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(prev_state);				\
-		return;							\
-	}								\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, &info);		\
-	exception_exit(prev_state);					\
+									\
+	do_error_trap(regs, error_code, str, trapnr, signr, &info);	\
 }
 
 DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error,		     FPE_INTDIV, regs->ip )
-- 
1.5.5.1

