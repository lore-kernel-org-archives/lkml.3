Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262Ab3LIKz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:55:59 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53994 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab3LIKxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:25 -0500
Subject: [PATCH -tip v5 10/18] x86: Use NOKPROBE_SYMBOL() instead of
 __kprobes annotation
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 09 Dec 2013 10:47:41 +0000
Message-ID: <20131209104741.13397.83462.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro for protecting functions
from kprobes instead of __kprobes annotation under
arch/x86.

This applies __always_inline annotation for some cases,
because NOKPROBE_SYMBOL() will inhibit inlining by
referring the symbol address.

This just folds a bunch of previous NOKPROBE_SYMBOL()
cleanup patches for x86 to one patch.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/traps.h             |    2 -
 arch/x86/kernel/alternative.c            |    3 +
 arch/x86/kernel/apic/hw_nmi.c            |    3 +
 arch/x86/kernel/cpu/perf_event.c         |    3 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    3 +
 arch/x86/kernel/dumpstack.c              |    9 ++--
 arch/x86/kernel/hw_breakpoint.c          |    6 ++
 arch/x86/kernel/kprobes/core.c           |   77 +++++++++++++++++++-----------
 arch/x86/kernel/kprobes/ftrace.c         |   15 ++++--
 arch/x86/kernel/kprobes/opt.c            |    8 ++-
 arch/x86/kernel/kvm.c                    |    4 +-
 arch/x86/kernel/nmi.c                    |   18 +++++--
 arch/x86/kernel/traps.c                  |   20 +++++---
 arch/x86/mm/fault.c                      |   28 +++++++----
 14 files changed, 127 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe..ca32508 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -68,7 +68,7 @@ dotraplinkage void do_segment_not_present(struct pt_regs *, long);
 dotraplinkage void do_stack_segment(struct pt_regs *, long);
 #ifdef CONFIG_X86_64
 dotraplinkage void do_double_fault(struct pt_regs *, long);
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
+asmlinkage struct pt_regs *sync_regs(struct pt_regs *);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598..7cfd6d7 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -551,7 +551,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
  *
  * Note: Must be called under text_mutex.
  */
-void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+void *text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
@@ -585,6 +585,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	local_irq_restore(flags);
 	return addr;
 }
+NOKPROBE_SYMBOL(text_poke);
 
 static void do_sync_core(void *info)
 {
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..73eb5b3 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -60,7 +60,7 @@ void arch_trigger_all_cpu_backtrace(void)
 	smp_mb__after_clear_bit();
 }
 
-static int __kprobes
+static int
 arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int cpu;
@@ -80,6 +80,7 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return NMI_DONE;
 }
+NOKPROBE_SYMBOL(arch_trigger_all_cpu_backtrace_handler);
 
 static int __init register_trigger_all_cpu_backtrace(void)
 {
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8e13293..863cc04 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1273,7 +1273,7 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-static int __kprobes
+static int
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	u64 start_clock;
@@ -1291,6 +1291,7 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return ret;
 }
+NOKPROBE_SYMBOL(perf_event_nmi_handler);
 
 struct event_constraint emptyconstraint;
 struct event_constraint unconstrained;
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..c668309 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -592,7 +592,7 @@ out:
 	return 1;
 }
 
-static int __kprobes
+static int
 perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int handled = 0;
@@ -605,6 +605,7 @@ perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return handled;
 }
+NOKPROBE_SYMBOL(perf_ibs_nmi_handler);
 
 static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 {
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index d9c12d3..b74ebc7 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -200,7 +200,7 @@ static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
-unsigned __kprobes long oops_begin(void)
+unsigned long oops_begin(void)
 {
 	int cpu;
 	unsigned long flags;
@@ -223,8 +223,9 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 EXPORT_SYMBOL_GPL(oops_begin);
+NOKPROBE_SYMBOL(oops_begin);
 
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
@@ -247,8 +248,9 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		panic("Fatal exception");
 	do_exit(signr);
 }
+NOKPROBE_SYMBOL(oops_end);
 
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+int __die(const char *str, struct pt_regs *regs, long err)
 {
 #ifdef CONFIG_X86_32
 	unsigned short ss;
@@ -291,6 +293,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #endif
 	return 0;
 }
+NOKPROBE_SYMBOL(__die);
 
 /*
  * This is gone through when something in the kernel has done something bad
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index f66ff16..cb4df84 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -425,7 +425,7 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
  * NOTIFY_STOP returned for all other cases
  *
  */
-static int __kprobes hw_breakpoint_handler(struct die_args *args)
+static int hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct perf_event *bp;
@@ -508,11 +508,12 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 
 	return rc;
 }
+NOKPROBE_SYMBOL(hw_breakpoint_handler);
 
 /*
  * Handle debug exception notifications.
  */
-int __kprobes hw_breakpoint_exceptions_notify(
+int hw_breakpoint_exceptions_notify(
 		struct notifier_block *unused, unsigned long val, void *data)
 {
 	if (val != DIE_DEBUG)
@@ -520,6 +521,7 @@ int __kprobes hw_breakpoint_exceptions_notify(
 
 	return hw_breakpoint_handler(data);
 }
+NOKPROBE_SYMBOL(hw_breakpoint_exceptions_notify);
 
 void hw_breakpoint_pmu_read(struct perf_event *bp)
 {
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 41a942f..a641327 100644
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
-int __kprobes kprobe_int3_handler(struct pt_regs *regs)
+int kprobe_int3_handler(struct pt_regs *regs)
 {
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
@@ -621,12 +630,13 @@ int __kprobes kprobe_int3_handler(struct pt_regs *regs)
 	preempt_enable_no_resched();
 	return 0;
 }
+NOKPROBE_SYMBOL(kprobe_int3_handler);
 
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
-int __kprobes kprobe_debug_handler(struct pt_regs *regs)
+int kprobe_debug_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -891,8 +905,9 @@ out:
 
 	return 1;
 }
+NOKPROBE_SYMBOL(kprobe_debug_handler);
 
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
@@ -976,8 +992,9 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
 	}
 	return ret;
 }
+NOKPROBE_SYMBOL(kprobe_exceptions_notify);
 
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+int setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 	unsigned long addr;
@@ -1001,8 +1018,9 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	regs->ip = (unsigned long)(jp->entry);
 	return 1;
 }
+NOKPROBE_SYMBOL(setjmp_pre_handler);
 
-void __kprobes jprobe_return(void)
+void jprobe_return(void)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
@@ -1018,8 +1036,10 @@ void __kprobes jprobe_return(void)
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
@@ -1047,6 +1067,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(longjmp_break_handler);
 
 bool arch_within_kprobe_blacklist(unsigned long addr)
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
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6dd802c..fb95987 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -251,8 +251,9 @@ u32 kvm_read_and_reset_pf_reason(void)
 	return reason;
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
+NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -276,6 +277,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		break;
 	}
 }
+NOKPROBE_SYMBOL(do_async_page_fault);
 
 static void __init paravirt_ops_setup(void)
 {
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6fcb49c..38ce829 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -95,7 +95,7 @@ static int __init nmi_warning_debugfs(void)
 }
 fs_initcall(nmi_warning_debugfs);
 
-static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
+static int nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *a;
@@ -137,6 +137,7 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	/* return total number of NMI events handled */
 	return handled;
 }
+NOKPROBE_SYMBOL(nmi_handle);
 
 int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 {
@@ -197,7 +198,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 }
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
-static __kprobes void
+static void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
 	/* check to see if anyone registered against these types of errors */
@@ -227,8 +228,9 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
 	outb(reason, NMI_REASON_PORT);
 }
+NOKPROBE_SYMBOL(pci_serr_error);
 
-static __kprobes void
+static void
 io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
@@ -258,8 +260,9 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	reason &= ~NMI_REASON_CLEAR_IOCHK;
 	outb(reason, NMI_REASON_PORT);
 }
+NOKPROBE_SYMBOL(io_check_error);
 
-static __kprobes void
+static void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	int handled;
@@ -287,11 +290,12 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	pr_emerg("Dazed and confused, but trying to continue\n");
 }
+NOKPROBE_SYMBOL(unknown_nmi_error);
 
 static DEFINE_PER_CPU(bool, swallow_nmi);
 static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
-static __kprobes void default_do_nmi(struct pt_regs *regs)
+static void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
@@ -390,6 +394,7 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 	else
 		unknown_nmi_error(reason, regs);
 }
+NOKPROBE_SYMBOL(default_do_nmi);
 
 /*
  * NMIs can hit breakpoints which will cause it to lose its
@@ -509,7 +514,7 @@ static inline void nmi_nesting_postprocess(void)
 }
 #endif
 
-dotraplinkage notrace __kprobes void
+dotraplinkage notrace void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_nesting_preprocess(regs);
@@ -526,6 +531,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 	/* On i386, may loop back to preprocess */
 	nmi_nesting_postprocess();
 }
+NOKPROBE_SYMBOL(do_nmi);
 
 void stop_nmi(void)
 {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index da2b0c1..f61cae4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -106,7 +106,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	preempt_count_dec();
 }
 
-static int __kprobes
+static __always_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 		  struct pt_regs *regs,	long error_code)
 {
@@ -136,7 +136,7 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	return -1;
 }
 
-static void __kprobes
+static void
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
@@ -173,6 +173,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	else
 		force_sig(signr, tsk);
 }
+NOKPROBE_SYMBOL(do_trap);
 
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
@@ -267,7 +268,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
@@ -313,9 +314,10 @@ do_general_protection(struct pt_regs *regs, long error_code)
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_general_protection);
 
 /* May run on IST stack. */
-dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
 
@@ -359,6 +361,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_int3);
 
 #ifdef CONFIG_X86_64
 /*
@@ -366,7 +369,7 @@ exit:
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -385,6 +388,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 		*regs = *eregs;
 	return regs;
 }
+NOKPROBE_SYMBOL(sync_regs);
 #endif
 
 /*
@@ -411,7 +415,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
  *
  * May run on IST stack.
  */
-dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
+dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	enum ctx_state prev_state;
@@ -496,6 +500,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_debug);
 
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
@@ -667,7 +672,7 @@ void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
@@ -693,6 +698,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #endif
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_device_not_available);
 
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9ff85bb..7c9305c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -8,7 +8,7 @@
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/module.h>		/* search_exception_table	*/
 #include <linux/bootmem.h>		/* max_low_pfn			*/
-#include <linux/kprobes.h>		/* __kprobes, ...		*/
+#include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
@@ -45,7 +45,7 @@ enum x86_pf_error_code {
  * Returns 0 if mmiotrace is disabled, or if the fault is not
  * handled by mmiotrace:
  */
-static inline int __kprobes
+static __always_inline int
 kmmio_fault(struct pt_regs *regs, unsigned long addr)
 {
 	if (unlikely(is_kmmio_active()))
@@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
 	return 0;
 }
 
-static inline int __kprobes kprobes_fault(struct pt_regs *regs)
+static __always_inline int kprobes_fault(struct pt_regs *regs)
 {
 	int ret = 0;
 
@@ -261,7 +261,7 @@ void vmalloc_sync_all(void)
  *
  *   Handle a fault on the vmalloc or module mapping area
  */
-static noinline __kprobes int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 	unsigned long pgd_paddr;
 	pmd_t *pmd_k;
@@ -291,6 +291,7 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(vmalloc_fault);
 
 /*
  * Did it hit the DOS screen memory VA from vm86 mode?
@@ -358,7 +359,7 @@ void vmalloc_sync_all(void)
  *
  * This assumes no large pages in there.
  */
-static noinline __kprobes int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
@@ -425,6 +426,7 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(vmalloc_fault);
 
 #ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
@@ -904,7 +906,7 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
  * There are no security implications to leaving a stale TLB when
  * increasing the permissions on a page.
  */
-static noinline __kprobes int
+static noinline int
 spurious_fault(unsigned long error_code, unsigned long address)
 {
 	pgd_t *pgd;
@@ -952,6 +954,7 @@ spurious_fault(unsigned long error_code, unsigned long address)
 
 	return ret;
 }
+NOKPROBE_SYMBOL(spurious_fault);
 
 int show_unhandled_signals = 1;
 
@@ -997,7 +1000,7 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-static void __kprobes
+static void
 __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct vm_area_struct *vma;
@@ -1225,8 +1228,9 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+NOKPROBE_SYMBOL(__do_page_fault);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -1235,9 +1239,10 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_page_fault);
 
-static void trace_page_fault_entries(struct pt_regs *regs,
-				     unsigned long error_code)
+static __always_inline void
+trace_page_fault_entries(struct pt_regs *regs, unsigned long error_code)
 {
 	if (user_mode(regs))
 		trace_page_fault_user(read_cr2(), regs, error_code);
@@ -1245,7 +1250,7 @@ static void trace_page_fault_entries(struct pt_regs *regs,
 		trace_page_fault_kernel(read_cr2(), regs, error_code);
 }
 
-dotraplinkage void __kprobes
+dotraplinkage void
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -1255,3 +1260,4 @@ trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(trace_do_page_fault);


