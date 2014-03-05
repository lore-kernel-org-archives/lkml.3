Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaCEL7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:59:51 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41688 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaCEL7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:59:48 -0500
Subject: [PATCH -tip v8 08/26] kprobes/x86: Call exception handlers directly
 from do_int3/do_debug
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 05 Mar 2014 20:59:39 +0900
Message-ID: <20140305115939.22766.21199.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid a kernel crash by probing on lockdep code, call
kprobe_int3_handler and kprobe_debug_handler directly
from do_int3 and do_debug. Since there is a locking code
in notify_die, lockdep code can be invoked. And because
the lockdep involves printk() related things, theoretically,
we need to prohibit probing on much more code...

Anyway, most of the int3 handlers in the kernel are already
called from do_int3 directly, e.g. ftrace_int3_handler,
poke_int3_handler, kgdb_ll_trap. Actually only
kprobe_exceptions_notify is on the notifier_call_chain.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/kprobes.h |    2 ++
 arch/x86/kernel/kprobes/core.c |   24 +++---------------------
 arch/x86/kernel/traps.c        |   10 ++++++++++
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 9454c16..53cdfb2 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -116,4 +116,6 @@ struct kprobe_ctlblk {
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kprobe_int3_handler(struct pt_regs *regs);
+extern int kprobe_debug_handler(struct pt_regs *regs);
 #endif /* _ASM_X86_KPROBES_H */
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 4708d6e..566958e 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -559,7 +559,7 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
+int __kprobes kprobe_int3_handler(struct pt_regs *regs)
 {
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
@@ -857,7 +857,7 @@ no_change:
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+int __kprobes kprobe_debug_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -960,22 +960,7 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
 	if (args->regs && user_mode_vm(args->regs))
 		return ret;
 
-	switch (val) {
-	case DIE_INT3:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs)) {
-			/*
-			 * Reset the BS bit in dr6 (pointed by args->err) to
-			 * denote completion of processing
-			 */
-			(*(unsigned long *)ERR_PTR(args->err)) &= ~DR_STEP;
-			ret = NOTIFY_STOP;
-		}
-		break;
-	case DIE_GPF:
+	if (val == DIE_GPF) {
 		/*
 		 * To be potentially processing a kprobe fault and to
 		 * trust the result from kprobe_running(), we have
@@ -984,9 +969,6 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
 		if (!preemptible() && kprobe_running() &&
 		    kprobe_fault_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
 	}
 	return ret;
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..e5d4a70 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -334,6 +334,11 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 		goto exit;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
+#ifdef CONFIG_KPROBES
+	if (kprobe_int3_handler(regs))
+		return;
+#endif
+
 	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
 		goto exit;
@@ -440,6 +445,11 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
+#ifdef CONFIG_KPROBES
+	if (kprobe_debug_handler(regs))
+		goto exit;
+#endif
+
 	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;


