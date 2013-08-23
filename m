Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3HWTIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:08:07 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:58356 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194Ab3HWTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:08:04 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:08:04 EDT
Message-ID: <00000140ac8e315d-750c0fa0-6b7f-4a85-9486-c259d1112a74-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:19 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 13/16] arm: __get_cpu_var conversion
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/arm/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/arm/kernel/hw_breakpoint.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm/kernel/hw_breakpoint.c	2013-08-22 14:38:03.702474170 -0500
@@ -344,13 +344,13 @@ int arch_install_hw_breakpoint(struct pe
 		/* Breakpoint */
 		ctrl_base = ARM_BASE_BCR;
 		val_base = ARM_BASE_BVR;
-		slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
+		slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
 		max_slots = core_num_brps;
 	} else {
 		/* Watchpoint */
 		ctrl_base = ARM_BASE_WCR;
 		val_base = ARM_BASE_WVR;
-		slots = (struct perf_event **)__get_cpu_var(wp_on_reg);
+		slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
 		max_slots = core_num_wrps;
 	}
 
@@ -396,12 +396,12 @@ void arch_uninstall_hw_breakpoint(struct
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
 		/* Breakpoint */
 		base = ARM_BASE_BCR;
-		slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
+		slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
 		max_slots = core_num_brps;
 	} else {
 		/* Watchpoint */
 		base = ARM_BASE_WCR;
-		slots = (struct perf_event **)__get_cpu_var(wp_on_reg);
+		slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
 		max_slots = core_num_wrps;
 	}
 
@@ -697,7 +697,7 @@ static void watchpoint_handler(unsigned
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__get_cpu_var(wp_on_reg);
+	slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
 
 	for (i = 0; i < core_num_wrps; ++i) {
 		rcu_read_lock();
@@ -768,7 +768,7 @@ static void watchpoint_single_step_handl
 	struct perf_event *wp, **slots;
 	struct arch_hw_breakpoint *info;
 
-	slots = (struct perf_event **)__get_cpu_var(wp_on_reg);
+	slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
 
 	for (i = 0; i < core_num_wrps; ++i) {
 		rcu_read_lock();
@@ -802,7 +802,7 @@ static void breakpoint_handler(unsigned
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
+	slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
 
 	/* The exception entry code places the amended lr in the PC. */
 	addr = regs->ARM_pc;
Index: linux/arch/arm/kernel/kprobes.c
===================================================================
--- linux.orig/arch/arm/kernel/kprobes.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm/kernel/kprobes.c	2013-08-22 14:38:03.702474170 -0500
@@ -171,13 +171,13 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 static void __kprobes
@@ -421,10 +421,10 @@ static __used __kprobes void *trampoline
 			continue;
 
 		if (ri->rp && ri->rp->handler) {
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			__this_cpu_write(current_kprobe, &ri->rp->kp);
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
+			__this_cpu_write(current_kprobe, NULL);
 		}
 
 		orig_ret_address = (unsigned long)ri->ret_addr;
Index: linux/arch/arm/kernel/perf_event_cpu.c
===================================================================
--- linux.orig/arch/arm/kernel/perf_event_cpu.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm/kernel/perf_event_cpu.c	2013-08-22 14:38:03.702474170 -0500
@@ -68,7 +68,7 @@ EXPORT_SYMBOL_GPL(perf_num_counters);
 
 static struct pmu_hw_events *cpu_pmu_get_cpu_events(void)
 {
-	return &__get_cpu_var(cpu_hw_events);
+	return this_cpu_ptr(&cpu_hw_events);
 }
 
 static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
Index: linux/arch/arm/kvm/arm.c
===================================================================
--- linux.orig/arch/arm/kvm/arm.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm/kvm/arm.c	2013-08-22 14:38:03.702474170 -0500
@@ -65,7 +65,7 @@ static bool vgic_present;
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(preemptible());
-	__get_cpu_var(kvm_arm_running_vcpu) = vcpu;
+	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
 }
 
 /**
@@ -75,7 +75,7 @@ static void kvm_arm_set_running_vcpu(str
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
 {
 	BUG_ON(preemptible());
-	return __get_cpu_var(kvm_arm_running_vcpu);
+	return __this_cpu_read(kvm_arm_running_vcpu);
 }
 
 /**
@@ -811,7 +811,7 @@ static void cpu_init_hyp_mode(void *dumm
 
 	boot_pgd_ptr = kvm_mmu_get_boot_httbr();
 	pgd_ptr = kvm_mmu_get_httbr();
-	stack_page = __get_cpu_var(kvm_arm_hyp_stack_page);
+	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
 	hyp_stack_ptr = stack_page + PAGE_SIZE;
 	vector_ptr = (unsigned long)__kvm_hyp_vector;
 
Index: linux/arch/arm64/kernel/debug-monitors.c
===================================================================
--- linux.orig/arch/arm64/kernel/debug-monitors.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm64/kernel/debug-monitors.c	2013-08-22 14:38:03.702474170 -0500
@@ -98,11 +98,11 @@ void enable_debug_monitors(enum debug_el
 
 	WARN_ON(preemptible());
 
-	if (local_inc_return(&__get_cpu_var(mde_ref_count)) == 1)
+	if (this_cpu_inc_return(mde_ref_count) == 1)
 		enable = DBG_MDSCR_MDE;
 
 	if (el == DBG_ACTIVE_EL1 &&
-	    local_inc_return(&__get_cpu_var(kde_ref_count)) == 1)
+	    this_cpu_inc_return(kde_ref_count) == 1)
 		enable |= DBG_MDSCR_KDE;
 
 	if (enable && debug_enabled) {
@@ -118,11 +118,11 @@ void disable_debug_monitors(enum debug_e
 
 	WARN_ON(preemptible());
 
-	if (local_dec_and_test(&__get_cpu_var(mde_ref_count)))
+	if (local_dec_and_test(this_cpu_ptr(&mde_ref_count)))
 		disable = ~DBG_MDSCR_MDE;
 
 	if (el == DBG_ACTIVE_EL1 &&
-	    local_dec_and_test(&__get_cpu_var(kde_ref_count)))
+	    local_dec_and_test(this_cpu_ptr(&kde_ref_count)))
 		disable &= ~DBG_MDSCR_KDE;
 
 	if (disable) {
Index: linux/arch/arm64/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/arm64/kernel/hw_breakpoint.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm64/kernel/hw_breakpoint.c	2013-08-22 14:38:03.706474130 -0500
@@ -184,14 +184,14 @@ int arch_install_hw_breakpoint(struct pe
 		/* Breakpoint */
 		ctrl_reg = AARCH64_DBG_REG_BCR;
 		val_reg = AARCH64_DBG_REG_BVR;
-		slots = __get_cpu_var(bp_on_reg);
+		slots = __this_cpu_read(bp_on_reg);
 		max_slots = core_num_brps;
 		reg_enable = !debug_info->bps_disabled;
 	} else {
 		/* Watchpoint */
 		ctrl_reg = AARCH64_DBG_REG_WCR;
 		val_reg = AARCH64_DBG_REG_WVR;
-		slots = __get_cpu_var(wp_on_reg);
+		slots = __this_cpu_read(wp_on_reg);
 		max_slots = core_num_wrps;
 		reg_enable = !debug_info->wps_disabled;
 	}
@@ -230,12 +230,12 @@ void arch_uninstall_hw_breakpoint(struct
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
 		/* Breakpoint */
 		base = AARCH64_DBG_REG_BCR;
-		slots = __get_cpu_var(bp_on_reg);
+		slots = __this_cpu_read(bp_on_reg);
 		max_slots = core_num_brps;
 	} else {
 		/* Watchpoint */
 		base = AARCH64_DBG_REG_WCR;
-		slots = __get_cpu_var(wp_on_reg);
+		slots = __this_cpu_read(wp_on_reg);
 		max_slots = core_num_wrps;
 	}
 
@@ -505,11 +505,11 @@ static void toggle_bp_registers(int reg,
 
 	switch (reg) {
 	case AARCH64_DBG_REG_BCR:
-		slots = __get_cpu_var(bp_on_reg);
+		slots = __this_cpu_read(bp_on_reg);
 		max_slots = core_num_brps;
 		break;
 	case AARCH64_DBG_REG_WCR:
-		slots = __get_cpu_var(wp_on_reg);
+		slots = __this_cpu_read(wp_on_reg);
 		max_slots = core_num_wrps;
 		break;
 	default:
@@ -546,7 +546,7 @@ static int breakpoint_handler(unsigned l
 	struct debug_info *debug_info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
+	slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
 	addr = instruction_pointer(regs);
 	debug_info = &current->thread.debug;
 
@@ -596,7 +596,7 @@ unlock:
 			user_enable_single_step(current);
 	} else {
 		toggle_bp_registers(AARCH64_DBG_REG_BCR, DBG_ACTIVE_EL1, 0);
-		kernel_step = &__get_cpu_var(stepping_kernel_bp);
+		kernel_step = this_cpu_ptr(&stepping_kernel_bp);
 
 		if (*kernel_step != ARM_KERNEL_STEP_NONE)
 			return 0;
@@ -623,7 +623,7 @@ static int watchpoint_handler(unsigned l
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__get_cpu_var(wp_on_reg);
+	slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
 	debug_info = &current->thread.debug;
 
 	for (i = 0; i < core_num_wrps; ++i) {
@@ -698,7 +698,7 @@ unlock:
 			user_enable_single_step(current);
 	} else {
 		toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL1, 0);
-		kernel_step = &__get_cpu_var(stepping_kernel_bp);
+		kernel_step = this_cpu_ptr(&stepping_kernel_bp);
 
 		if (*kernel_step != ARM_KERNEL_STEP_NONE)
 			return 0;
@@ -722,7 +722,7 @@ int reinstall_suspended_bps(struct pt_re
 	struct debug_info *debug_info = &current->thread.debug;
 	int handled_exception = 0, *kernel_step;
 
-	kernel_step = &__get_cpu_var(stepping_kernel_bp);
+	kernel_step = this_cpu_ptr(&stepping_kernel_bp);
 
 	/*
 	 * Called from single-step exception handler.
Index: linux/arch/arm64/kernel/perf_event.c
===================================================================
--- linux.orig/arch/arm64/kernel/perf_event.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/arm64/kernel/perf_event.c	2013-08-22 14:38:03.706474130 -0500
@@ -1033,7 +1033,7 @@ static irqreturn_t armv8pmu_handle_irq(i
 	 */
 	regs = get_irq_regs();
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
@@ -1246,7 +1246,7 @@ device_initcall(register_pmu_driver);
 
 static struct pmu_hw_events *armpmu_get_cpu_events(void)
 {
-	return &__get_cpu_var(cpu_hw_events);
+	return this_cpu_ptr(&cpu_hw_events);
 }
 
 static void __init cpu_pmu_init(struct arm_pmu *armpmu)

