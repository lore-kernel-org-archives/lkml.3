Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaENIVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:21:17 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39395 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaENIVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:21:11 -0400
Subject: [PATCH -tip v11 4/7] kprobes/x86: Remove unneeded
 preempt_disable/enable in interrupt handlers
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 May 2014 17:21:03 +0900
Message-ID: <20140514082103.5791.47404.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140514082034.5791.38607.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140514082034.5791.38607.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the int3 itself disables the local_irq and kprobes
keeps it disabled while the single step has done, the
kernel preemption never happen while processing a kprobe.
This means that we don't need to disable/enable preemption.
Also, this changes kprobe_int3_handler to use goto-out style.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/kprobes/core.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index c7e29f7..cec5879 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -506,7 +506,6 @@ static void setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 		 * stepping.
 		 */
 		regs->ip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
 		return;
 	}
 #endif
@@ -575,13 +574,6 @@ int kprobe_int3_handler(struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb;
 
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing. We conditionally
-	 * re-enable preemption at the end of this function,
-	 * and also in reenter_kprobe() and setup_singlestep().
-	 */
-	preempt_disable();
 
 	kcb = get_kprobe_ctlblk();
 	p = get_kprobe(addr);
@@ -589,7 +581,7 @@ int kprobe_int3_handler(struct pt_regs *regs)
 	if (p) {
 		if (kprobe_running()) {
 			if (reenter_kprobe(p, regs, kcb))
-				return 1;
+				goto handled;
 		} else {
 			set_current_kprobe(p, regs, kcb);
 			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
@@ -604,7 +596,7 @@ int kprobe_int3_handler(struct pt_regs *regs)
 			 */
 			if (!p->pre_handler || !p->pre_handler(p, regs))
 				setup_singlestep(p, regs, kcb, 0);
-			return 1;
+			goto handled;
 		}
 	} else if (*addr != BREAKPOINT_INSTRUCTION) {
 		/*
@@ -617,19 +609,20 @@ int kprobe_int3_handler(struct pt_regs *regs)
 		 * the original instruction.
 		 */
 		regs->ip = (unsigned long)addr;
-		preempt_enable_no_resched();
-		return 1;
+		goto handled;
 	} else if (kprobe_running()) {
 		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			if (!skip_singlestep(p, regs, kcb))
 				setup_singlestep(p, regs, kcb, 0);
-			return 1;
+			goto handled;
 		}
 	} /* else: not a kprobe fault; let the kernel handle it */
 
-	preempt_enable_no_resched();
 	return 0;
+
+handled:
+	return 1;
 }
 NOKPROBE_SYMBOL(kprobe_int3_handler);
 
@@ -894,7 +887,6 @@ int kprobe_debug_handler(struct pt_regs *regs)
 	}
 	reset_current_kprobe();
 out:
-	preempt_enable_no_resched();
 
 	/*
 	 * if somebody else is singlestepping across a probe point, flags
@@ -930,7 +922,6 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 			restore_previous_kprobe(kcb);
 		else
 			reset_current_kprobe();
-		preempt_enable_no_resched();
 	} else if (kcb->kprobe_status == KPROBE_HIT_ACTIVE ||
 		   kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 		/*
@@ -1061,7 +1052,6 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
 		       kcb->jprobes_stack,
 		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
-		preempt_enable_no_resched();
 		return 1;
 	}
 	return 0;


