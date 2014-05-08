Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaEHTNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:13:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaEHTMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:31 -0400
Date: Thu, 8 May 2014 21:12:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] x86/traps: Shift fill_trap_info() from DO_ERROR_INFO()
	to do_error_trap()
Message-ID: <20140508191206.GA16930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the callsite of fill_trap_info() into do_error_trap() and remove
the "siginfo_t *info" argument.

This obviously breaks DO_ERROR() which passed info == NULL, we simply
change fill_trap_info() to return "siginfo_t *" and add the "default"
case which returns SEND_SIG_PRIV.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/traps.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1cf8a4c..c9dd741 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -136,13 +136,16 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	return -1;
 }
 
-static void fill_trap_info(struct pt_regs *regs, int signr, int trapnr,
-			   siginfo_t *info)
+static siginfo_t *fill_trap_info(struct pt_regs *regs, int signr, int trapnr,
+				siginfo_t *info)
 {
 	unsigned long siaddr;
 	int sicode;
 
 	switch (trapnr) {
+	default:
+		return SEND_SIG_PRIV;
+
 	case X86_TRAP_DE:
 		sicode = FPE_INTDIV;
 		siaddr = regs->ip;
@@ -161,6 +164,7 @@ static void fill_trap_info(struct pt_regs *regs, int signr, int trapnr,
 	info->si_errno = 0;
 	info->si_code = sicode;
 	info->si_addr = (void __user *)siaddr;
+	return info;
 }
 
 static void __kprobes
@@ -199,14 +203,16 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 }
 
 static void do_error_trap(struct pt_regs *regs, long error_code, char *str,
-			  unsigned long trapnr, int signr, siginfo_t *info)
+			  unsigned long trapnr, int signr)
 {
 	enum ctx_state prev_state = exception_enter();
+	siginfo_t info;
 
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) !=
 			NOTIFY_STOP) {
 		conditional_sti(regs);
-		do_trap(trapnr, signr, str, regs, error_code, info);
+		do_trap(trapnr, signr, str, regs, error_code,
+			fill_trap_info(regs, signr, trapnr, &info));
 	}
 
 	exception_exit(prev_state);
@@ -215,16 +221,13 @@ static void do_error_trap(struct pt_regs *regs, long error_code, char *str,
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	do_error_trap(regs, error_code, str, trapnr, signr, NULL);	\
+	do_error_trap(regs, error_code, str, trapnr, signr);		\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	siginfo_t info;							\
-									\
-	fill_trap_info(regs, signr, trapnr, &info);			\
-	do_error_trap(regs, error_code, str, trapnr, signr, &info);	\
+	do_error_trap(regs, error_code, str, trapnr, signr);		\
 }
 
 DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error)
-- 
1.5.5.1

