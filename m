Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaEIOHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaEIOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:07:50 -0400
Date: Fri, 9 May 2014 16:07:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: can't we kill DIE_GPF ? (Was: x86/traps: cleanup DO_ERROR*() to
	prepare for uprobes fixes)
Message-ID: <20140509140723.GA22532@redhat.com>
References: <20140508191140.GA16892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508191140.GA16892@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Oleg Nesterov wrote:
>
> For example, after this series
> we can convert math_error() into the "normal" DO_ERROR() user, and most probably
> we can do the same with do_general_protection().

As for do_general_protection(), the problem is DIE_GPF.

Masami, could you explain why it is needed ? kprobe_exceptions_notify()
is the only user, can't it use DIE_TRAP and check trapnr = X86_TRAP_GP ?

And if it can, probably we can do notify_die() at the start like other
DO_ERROR() functions do ?

IOW, any reason why the patch below is wrong?

Oleg.

--- x/arch/x86/include/asm/kdebug.h
+++ x/arch/x86/include/asm/kdebug.h
@@ -15,7 +15,6 @@ enum die_val {
 	DIE_DIE,
 	DIE_KERNELDEBUG,
 	DIE_TRAP,
-	DIE_GPF,
 	DIE_CALL,
 	DIE_PAGE_FAULT,
 	DIE_NMIUNKNOWN,
--- x/arch/x86/kernel/traps.c
+++ x/arch/x86/kernel/traps.c
@@ -283,6 +283,9 @@ do_general_protection(struct pt_regs *re
 	enum ctx_state prev_state;
 
 	prev_state = exception_enter();
+	if (notify_die(DIE_TRAP, "general protection fault", regs, error_code,
+			X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
+		goto exit;
 	conditional_sti(regs);
 
 #ifdef CONFIG_X86_32
@@ -300,10 +303,7 @@ do_general_protection(struct pt_regs *re
 
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
-		if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
-			       X86_TRAP_GP, SIGSEGV) != NOTIFY_STOP)
-			die("general protection fault", regs, error_code);
-		goto exit;
+		die("general protection fault", regs, error_code);
 	}
 
 	tsk->thread.error_code = error_code;
--- x/arch/x86/kernel/kprobes/core.c
+++ x/arch/x86/kernel/kprobes/core.c
@@ -979,13 +979,14 @@ kprobe_exceptions_notify(struct notifier
 			ret = NOTIFY_STOP;
 		}
 		break;
-	case DIE_GPF:
+	case DIE_TRAP:
 		/*
 		 * To be potentially processing a kprobe fault and to
 		 * trust the result from kprobe_running(), we have
 		 * be non-preemptible.
 		 */
-		if (!preemptible() && kprobe_running() &&
+		if (args->trapnr == X86_TRAP_GP &&
+		    !preemptible() && kprobe_running() &&
 		    kprobe_fault_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
 		break;

