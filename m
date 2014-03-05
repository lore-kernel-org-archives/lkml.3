Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbaCEMFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:05:33 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41716 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbaCEL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:59:54 -0500
Subject: [PATCH -tip v8 09/26] x86: Call exception_enter after kprobes
 handled
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 05 Mar 2014 20:59:46 +0900
Message-ID: <20140305115946.22766.73261.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move exception_enter() call after kprobes handler
is done. Since the exception_enter() involves
many other functions (like printk), it can cause
recursive int3/break loop when kprobes probe such
functions.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/traps.c |    5 ++---
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


