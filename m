Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3JQLTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:19:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64744 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3JQLTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:19:12 -0400
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, dsaxena@linaro.org,
        jiang.liu@huawei.com, Vijaya.Kumar@caviumnetworks.com,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH RFC 4/6] arm64: Add kernel return probes support(kretprobes)
Date: Thu, 17 Oct 2013 16:47:49 +0530
Message-Id: <1382008671-4515-5-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AArch64 ISA does not instructions to pop PC register value
from stack(like ARM v7 has ldmia {...,pc}) without using
one of the general purpose registers. This means return probes
cannot return to the actual return address directly without
modifying register context, and without trapping into debug exception.

So like many other architectures, we prepare a global routine
with NOPs, which serve as trampoline to hack away the
function return address, by placing an extra kprobe on the
trampoline entry.

The pre-handler of this special trampoline' kprobe execute return
probe handler functions and restore original return address in ELR_EL1,
this way, saved pt_regs still hold the original register context to be
carried back to the probed kernel function.

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
---
 arch/arm64/Kconfig               |   1 +
 arch/arm64/include/asm/kprobes.h |   1 +
 arch/arm64/include/asm/ptrace.h  |   5 ++
 arch/arm64/kernel/kprobes.c      | 125 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2e89059..73eff55 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -28,6 +28,7 @@ config ARM64
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
 	select HAVE_KPROBES if !XIP_KERNEL
+	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
index 9b491d0..eaca849 100644
--- a/arch/arm64/include/asm/kprobes.h
+++ b/arch/arm64/include/asm/kprobes.h
@@ -55,5 +55,6 @@ void arch_remove_kprobe(struct kprobe *);
 int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
 int kprobe_exceptions_notify(struct notifier_block *self,
 			     unsigned long val, void *data);
+void kretprobe_trampoline(void);
 
 #endif /* _ARM_KPROBES_H */
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 89f1727..58b2589 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -166,6 +166,11 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
 #define instruction_pointer(regs)	(regs)->pc
 #define stack_pointer(regs)		((regs)->sp)
 
+static inline long regs_return_value(struct pt_regs *regs)
+{
+	return regs->regs[0];
+}
+
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
 #else
diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
index 1fa8690..0a6f31f 100644
--- a/arch/arm64/kernel/kprobes.c
+++ b/arch/arm64/kernel/kprobes.c
@@ -219,9 +219,16 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 
 		/*
 		 * Needs restoring of return address after stepping xol.
+		 * If this happens to be a return probe, the exception
+		 * return address would have been hacked by the pre_handler
+		 * to point to trampoline, so we shall restore trampoline
+		 * address after stepping. Other cases, it is just next pc.
 		 */
-		p->ainsn.restore.addr = instruction_pointer(regs) +
-				sizeof(kprobe_opcode_t);
+		if ((long)p->addr == instruction_pointer(regs))
+			p->ainsn.restore.addr = instruction_pointer(regs) +
+				sizeof(kprobe_opcode_t); /* next pc */
+		else	/* hacked ret addr, could be kretprobe */
+			p->ainsn.restore.addr = regs->pc;
 
 		p->ainsn.restore.type = RESTORE_PC;
 
@@ -542,6 +549,117 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+/*
+ * Kretprobes: kernel return probes handling
+ *
+ * AArch64 mode does not support popping the PC value from the
+ * stack like on ARM 32-bit (ldmia {..,pc}), so atleast one
+ * register need to be used to achieve branching/return.
+ * It means return probes cannot return back to the original
+ * return address directly without modifying the register context.
+ *
+ * So like other architectures, we prepare a global routine
+ * with NOPs, which serve as trampoline address that hack away the
+ * function return, with the exact register context.
+ * Placing a kprobe on trampoline routine entry will trap again to
+ * execute return probe handlers and restore original return address
+ * in ELR_EL1, this way saved pt_regs still hold the original
+ * register values to be carried back to the caller.
+ */
+static void __used kretprobe_trampoline_holder(void)
+{
+	asm volatile (".global kretprobe_trampoline\n"
+			"kretprobe_trampoline:\n"
+			"NOP\n\t"
+			"NOP\n\t");
+}
+
+static int __kprobes
+trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *tmp;
+	unsigned long flags, orig_ret_addr = 0;
+	unsigned long trampoline_address =
+		(unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	kretprobe_hash_lock(current, &head, &flags);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because multiple functions in the call path have
+	 * a return probe installed on them, and/or more than one return
+	 * probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler) {
+			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->rp->handler(ri, regs);
+			__get_cpu_var(current_kprobe) = NULL;
+		}
+
+		orig_ret_addr = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_addr != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_addr, trampoline_address);
+	/* restore the original return address */
+	instruction_pointer(regs) = orig_ret_addr;
+	reset_current_kprobe();
+	kretprobe_hash_unlock(current, &flags);
+	preempt_enable_no_resched();
+
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+
+	/* return 1 so that post handlers not called */
+	return 1;
+}
+
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	ri->ret_addr = (kprobe_opcode_t *)
+		(instruction_pointer(regs) + sizeof(kprobe_opcode_t));
+
+	/* Replace the return addr with trampoline addr */
+	instruction_pointer(regs) = (unsigned long)&kretprobe_trampoline;
+}
+
+static struct kprobe trampoline = {
+	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	return p->addr == (kprobe_opcode_t *) &kretprobe_trampoline;
+}
+
 /* Break Handler hook */
 static struct break_hook kprobes_break_hook = {
 	.esr_mask = BRK64_ESR_MASK,
@@ -559,5 +677,6 @@ int __init arch_init_kprobes()
 	register_break_hook(&kprobes_break_hook);
 	register_step_hook(&kprobes_step_hook);
 
-	return 0;
+	/* register trampoline for kret probe */
+	return register_kprobe(&trampoline);
 }
-- 
1.8.1.2

