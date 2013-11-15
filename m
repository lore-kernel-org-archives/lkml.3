Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab3KOEy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:54:59 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40735 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab3KOExk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:53:40 -0500
X-AuditID: 85900ec0-d0927b9000001514-e6-5285a8d0d776
Subject: [PATCH -tip RFC v2 07/22] kprobes/x86: Use NOKPROBE_SYMBOL instead
 of __kprobes
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:53:35 +0000
Message-ID: <20131115045335.27580.48631.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro for protecting functions
from kprobes instead of __kprobes annotation in x86
kprobes code.
This applies __always_inline annotation for some cases,
because NOKPROBE_SYMBOL() will inhibit inlining by
referring the symbol address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/kernel/kprobes/core.c   |   77 ++++++++++++++++++++++++--------------
 arch/x86/kernel/kprobes/ftrace.c |   15 ++++---
 arch/x86/kernel/kprobes/opt.c    |    8 ++--
 3 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7ccb3d3..6cfa5d3 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -112,7 +112,8 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
-static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
+static __always_inline
+void __synthesize_relative_insn(void *from, void *to, u8 op)
 {
 	struct __arch_relative_insn {
 		u8 op;
@@ -125,21 +126,23 @@ static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
 }
 
 /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-void __kprobes synthesize_reljump(void *from, void *to)
+void synthesize_reljump(void *from, void *to)
 {
 	__synthesize_relative_insn(from, to, RELATIVEJUMP_OPCODE);
 }
+NOKPROBE_SYMBOL(synthesize_reljump);
 
 /* Insert a call instruction at address 'from', which calls address 'to'.*/
-void __kprobes synthesize_relcall(void *from, void *to)
+void synthesize_relcall(void *from, void *to)
 {
 	__synthesize_relative_insn(from, to, RELATIVECALL_OPCODE);
 }
+NOKPROBE_SYMBOL(synthesize_relcall);
 
 /*
  * Skip the prefixes of the instruction.
  */
-static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
+static kprobe_opcode_t *skip_prefixes(kprobe_opcode_t *insn)
 {
 	insn_attr_t attr;
 
@@ -154,6 +157,7 @@ static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
 #endif
 	return insn;
 }
+NOKPROBE_SYMBOL(skip_prefixes);
 
 /*
  * Returns non-zero if opcode is boostable.
@@ -425,7 +429,8 @@ void arch_remove_kprobe(struct kprobe *p)
 	}
 }
 
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+static __always_inline
+void save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
@@ -433,7 +438,8 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }
 
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+static __always_inline
+void restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
@@ -441,8 +447,9 @@ static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }
 
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
+static __always_inline
+void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+			struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
@@ -451,7 +458,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
 }
 
-static void __kprobes clear_btf(void)
+static __always_inline void clear_btf(void)
 {
 	if (test_thread_flag(TIF_BLOCKSTEP)) {
 		unsigned long debugctl = get_debugctlmsr();
@@ -461,7 +468,7 @@ static void __kprobes clear_btf(void)
 	}
 }
 
-static void __kprobes restore_btf(void)
+static __always_inline void restore_btf(void)
 {
 	if (test_thread_flag(TIF_BLOCKSTEP)) {
 		unsigned long debugctl = get_debugctlmsr();
@@ -471,8 +478,7 @@ static void __kprobes restore_btf(void)
 	}
 }
 
-void __kprobes
-arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
+void arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	unsigned long *sara = stack_addr(regs);
 
@@ -481,9 +487,10 @@ arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
+NOKPROBE_SYMBOL(arch_prepare_kretprobe);
 
-static void __kprobes
-setup_singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb, int reenter)
+static void setup_singlestep(struct kprobe *p, struct pt_regs *regs,
+			     struct kprobe_ctlblk *kcb, int reenter)
 {
 	if (setup_detour_execution(p, regs, reenter))
 		return;
@@ -519,14 +526,15 @@ setup_singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *k
 	else
 		regs->ip = (unsigned long)p->ainsn.insn;
 }
+NOKPROBE_SYMBOL(setup_singlestep);
 
 /*
  * We have reentered the kprobe_handler(), since another probe was hit while
  * within the handler. We save the original kprobes variables and just single
  * step on the instruction of the new probe without calling any user handlers.
  */
-static int __kprobes
-reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+static int reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
+			  struct kprobe_ctlblk *kcb)
 {
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
@@ -553,12 +561,13 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 
 	return 1;
 }
+NOKPROBE_SYMBOL(reenter_kprobe);
 
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
+static int kprobe_handler(struct pt_regs *regs)
 {
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
@@ -621,12 +630,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	preempt_enable_no_resched();
 	return 0;
 }
+NOKPROBE_SYMBOL(kprobe_handler);
 
 /*
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
-static void __used __kprobes kretprobe_trampoline_holder(void)
+static void __used kretprobe_trampoline_holder(void)
 {
 	asm volatile (
 			".global kretprobe_trampoline\n"
@@ -657,11 +667,13 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 #endif
 			"	ret\n");
 }
+NOKPROBE_SYMBOL(kretprobe_trampoline_holder);
+NOKPROBE_SYMBOL(kretprobe_trampoline);
 
 /*
  * Called from kretprobe_trampoline
  */
-__visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+__visible __used void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -747,6 +759,7 @@ __visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	}
 	return (void *)orig_ret_address;
 }
+NOKPROBE_SYMBOL(trampoline_handler);
 
 /*
  * Called after single-stepping.  p->addr is the address of the
@@ -775,8 +788,8 @@ __visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
  * jump instruction after the copied instruction, that jumps to the next
  * instruction after the probepoint.
  */
-static void __kprobes
-resume_execution(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+static void resume_execution(struct kprobe *p, struct pt_regs *regs,
+			     struct kprobe_ctlblk *kcb)
 {
 	unsigned long *tos = stack_addr(regs);
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
@@ -851,12 +864,13 @@ resume_execution(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *k
 no_change:
 	restore_btf();
 }
+NOKPROBE_SYMBOL(resume_execution);
 
 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+static int post_kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -891,8 +905,9 @@ out:
 
 	return 1;
 }
+NOKPROBE_SYMBOL(post_kprobe_handler);
 
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -951,12 +966,13 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(kprobe_fault_handler);
 
 /*
  * Wrapper routine for handling exceptions.
  */
-int __kprobes
-kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *data)
+int kprobe_exceptions_notify(struct notifier_block *self, unsigned long val,
+			     void *data)
 {
 	struct die_args *args = data;
 	int ret = NOTIFY_DONE;
@@ -994,8 +1010,9 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
 	}
 	return ret;
 }
+NOKPROBE_SYMBOL(kprobe_exceptions_notify);
 
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+int setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 	unsigned long addr;
@@ -1019,8 +1036,9 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	regs->ip = (unsigned long)(jp->entry);
 	return 1;
 }
+NOKPROBE_SYMBOL(setjmp_pre_handler);
 
-void __kprobes jprobe_return(void)
+void jprobe_return(void)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
@@ -1036,8 +1054,10 @@ void __kprobes jprobe_return(void)
 			"       nop			\n"::"b"
 			(kcb->jprobe_saved_sp):"memory");
 }
+NOKPROBE_SYMBOL(jprobe_return);
+NOKPROBE_SYMBOL(jprobe_return_end);
 
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
@@ -1065,6 +1085,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(longjmp_break_handler);
 
 int __init arch_init_kprobes(void)
 {
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index dcaa131..068ea83a 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -25,8 +25,9 @@
 
 #include "common.h"
 
-static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-			     struct kprobe_ctlblk *kcb)
+static __always_inline
+int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+		      struct kprobe_ctlblk *kcb)
 {
 	/*
 	 * Emulate singlestep (and also recover regs->ip)
@@ -41,18 +42,19 @@ static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 	return 1;
 }
 
-int __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-			      struct kprobe_ctlblk *kcb)
+int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+		    struct kprobe_ctlblk *kcb)
 {
 	if (kprobe_ftrace(p))
 		return __skip_singlestep(p, regs, kcb);
 	else
 		return 0;
 }
+NOKPROBE_SYMBOL(skip_singlestep);
 
 /* Ftrace callback handler for kprobes */
-void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
-				     struct ftrace_ops *ops, struct pt_regs *regs)
+void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+			   struct ftrace_ops *ops, struct pt_regs *regs)
 {
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
@@ -84,6 +86,7 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 end:
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(kprobe_ftrace_handler);
 
 int arch_prepare_kprobe_ftrace(struct kprobe *p)
 {
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index fba7fb0..f304773 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -138,7 +138,8 @@ asm (
 #define INT3_SIZE sizeof(kprobe_opcode_t)
 
 /* Optimized kprobe call back function: called from optinsn */
-static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
+static void
+optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	unsigned long flags;
@@ -168,6 +169,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_
 	}
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(optimized_callback);
 
 static int copy_optimized_instructions(u8 *dest, u8 *src)
 {
@@ -424,8 +426,7 @@ extern void arch_unoptimize_kprobes(struct list_head *oplist,
 	}
 }
 
-int  __kprobes
-setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
+int setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 {
 	struct optimized_kprobe *op;
 
@@ -441,3 +442,4 @@ setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(setup_detour_execution);

