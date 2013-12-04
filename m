Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3LDBeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:34:44 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34708 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3LDBei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:34:38 -0500
Subject: [PATCH -tip v4 6/6] [RFC] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 04 Dec 2013 01:28:56 +0000
Message-ID: <20131204012856.22118.91079.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
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

So I think this is not a crazy thing.

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
index c01e70f..4d7dbe1 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -558,7 +558,7 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
+int __kprobes kprobe_int3_handler(struct pt_regs *regs)
 {
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
@@ -856,7 +856,7 @@ no_change:
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+int __kprobes kprobe_debug_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -964,22 +964,7 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
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
@@ -988,9 +973,6 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
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
index b857ed8..da2b0c1 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -338,6 +338,11 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
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
@@ -444,6 +449,11 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
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


