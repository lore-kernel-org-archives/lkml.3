Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaFNI7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 04:59:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaFNI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 04:59:00 -0400
Date: Sat, 14 Jun 2014 01:58:06 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-4cdf77a828b056258f48a9f6078bd2f77d9704bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, seiji.aguchi@hds.com, jkosina@suse.cz,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        keescook@chromium.org, akpm@linux-foundation.org, rostedt@goodmis.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, seiji.aguchi@hds.com, jkosina@suse.cz,
        keescook@chromium.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <20140614064711.7865.45957.stgit@kbuild-fedora.novalocal>
References: <20140614064711.7865.45957.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/kprobes:
  Fix build errors and blacklist context_track_user
Git-Commit-ID: 4cdf77a828b056258f48a9f6078bd2f77d9704bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cdf77a828b056258f48a9f6078bd2f77d9704bb
Gitweb:     http://git.kernel.org/tip/4cdf77a828b056258f48a9f6078bd2f77d9704bb
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Sat, 14 Jun 2014 06:47:12 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 14 Jun 2014 09:07:44 +0200

x86/kprobes: Fix build errors and blacklist context_track_user

This essentially reverts commit:

  ecd50f714c42 ("kprobes, x86: Call exception_enter after kprobes handled")

since it causes build errors with CONFIG_CONTEXT_TRACKING and
that has been made from misunderstandings;
context_track_user_*() don't involve much in interrupt context,
it just returns if in_interrupt() is true.

Instead of changing the do_debug/int3(), this just adds
context_track_user_*() to kprobes blacklist, since those are
still can be called right before kprobes handles int3 and debug
exceptions, and probing those will cause an infinite loop.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20140614064711.7865.45957.stgit@kbuild-fedora.novalocal
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c   | 7 ++++---
 kernel/context_tracking.c | 3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c6eb418..0d0e922 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -343,6 +343,7 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 	if (poke_int3_handler(regs))
 		return;
 
+	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -351,9 +352,8 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 
 #ifdef CONFIG_KPROBES
 	if (kprobe_int3_handler(regs))
-		return;
+		goto exit;
 #endif
-	prev_state = exception_enter();
 
 	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
@@ -433,6 +433,8 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	prev_state = exception_enter();
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -465,7 +467,6 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 	if (kprobe_debug_handler(regs))
 		goto exit;
 #endif
-	prev_state = exception_enter();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 019d450..5664985 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/hardirq.h>
 #include <linux/export.h>
+#include <linux/kprobes.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/context_tracking.h>
@@ -104,6 +105,7 @@ void context_tracking_user_enter(void)
 	}
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(context_tracking_user_enter);
 
 #ifdef CONFIG_PREEMPT
 /**
@@ -181,6 +183,7 @@ void context_tracking_user_exit(void)
 	}
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(context_tracking_user_exit);
 
 /**
  * __context_tracking_task_switch - context switch the syscall callbacks
