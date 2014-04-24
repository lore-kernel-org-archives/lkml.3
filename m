Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaDXK7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:59:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaDXK7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:59:42 -0400
Date: Thu, 24 Apr 2014 03:59:20 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-ecd50f714c421c759354632dd00f70c718c95b10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, seiji.aguchi@hds.com, jkosina@suse.cz,
        keescook@chromium.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, seiji.aguchi@hds.com, jkosina@suse.cz,
        keescook@chromium.org, masami.hiramatsu.pt@hitachi.com,
        akpm@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de,
        bp@suse.de
In-Reply-To: <20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes, x86:
  Call exception_enter after kprobes handled
Git-Commit-ID: ecd50f714c421c759354632dd00f70c718c95b10
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

Commit-ID:  ecd50f714c421c759354632dd00f70c718c95b10
Gitweb:     http://git.kernel.org/tip/ecd50f714c421c759354632dd00f70c718c95b10
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:17:40 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:03:00 +0200

kprobes, x86: Call exception_enter after kprobes handled

Move exception_enter() call after kprobes handler
is done. Since the exception_enter() involves
many other functions (like printk), it can cause
recursive int3/break loop when kprobes probe such
functions.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index e5d4a70..ba9abe9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -327,7 +327,6 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	if (poke_int3_handler(regs))
 		return;
 
-	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -338,6 +337,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	if (kprobe_int3_handler(regs))
 		return;
 #endif
+	prev_state = exception_enter();
 
 	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
@@ -415,8 +415,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
-	prev_state = exception_enter();
-
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -449,6 +447,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (kprobe_debug_handler(regs))
 		goto exit;
 #endif
+	prev_state = exception_enter();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
