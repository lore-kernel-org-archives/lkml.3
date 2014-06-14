Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaFNGrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 02:47:18 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40483 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaFNGrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 02:47:16 -0400
X-AuditID: 85900ec0-d312bb9000001514-da-539beff017d2
Subject: [PATCH -tip ] [Bugfix] x86/kprobes: Fix build errors and blacklist
 context_track_user
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@suse.de>, Kees Cook <keescook@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 14 Jun 2014 06:47:12 +0000
Message-ID: <20140614064711.7865.45957.stgit@kbuild-fedora.novalocal>
In-Reply-To: <539BE132.2080008@hitachi.com>
References: <539BE132.2080008@hitachi.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ecd50f714c421c759354632dd00f70c718c95b10
since it causes build errors with CONFIG_CONTEXT_TRACKING and
that has been made from misunderstandings; context_track_user_*()
don't involve much in interrupt context, it just returns
if in_interrupt() is true.

Instead of changing the do_debug/int3(), this just adds
context_track_user_*() to kprobes blacklist, since those are
still can be called right before kprobes handles int3 and debug
exceptions, and probing those will cause infinit loop.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/kernel/traps.c   |    7 ++++---
 kernel/context_tracking.c |    3 +++
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

