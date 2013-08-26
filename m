Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3HZUo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:44:56 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:46064 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab3HZUox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:44:53 -0400
Message-ID: <00000140bc5f3c35-f4075639-884b-4ae3-b7bd-d945b44d7cf5-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:52 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 22/31] arm: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Others usage cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does a address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
and less registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.

The patchset includes passes over all arches as well. Once these operations are used throughout then
specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
f.e. using a global register that may be set to the per cpu base.




Transformations done to __get_cpu_var()


1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);


2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);


3. Retrieve the content of the current processors instance of a per cpu variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&y), x, sizeof(x));


5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)



Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/arm/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/arm/kernel/hw_breakpoint.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm/kernel/hw_breakpoint.c	2013-08-26 13:48:40.952795024 -0500
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
--- linux.orig/arch/arm/kernel/kprobes.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm/kernel/kprobes.c	2013-08-26 13:48:40.952795024 -0500
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
--- linux.orig/arch/arm/kernel/perf_event_cpu.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm/kernel/perf_event_cpu.c	2013-08-26 13:48:40.952795024 -0500
@@ -68,7 +68,7 @@ EXPORT_SYMBOL_GPL(perf_num_counters);
 
 static struct pmu_hw_events *cpu_pmu_get_cpu_events(void)
 {
-	return &__get_cpu_var(cpu_hw_events);
+	return this_cpu_ptr(&cpu_hw_events);
 }
 
 static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
Index: linux/arch/arm/kvm/arm.c
===================================================================
--- linux.orig/arch/arm/kvm/arm.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm/kvm/arm.c	2013-08-26 13:48:40.952795024 -0500
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
--- linux.orig/arch/arm64/kernel/debug-monitors.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm64/kernel/debug-monitors.c	2013-08-26 13:48:40.952795024 -0500
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
--- linux.orig/arch/arm64/kernel/hw_breakpoint.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm64/kernel/hw_breakpoint.c	2013-08-26 13:48:40.952795024 -0500
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
--- linux.orig/arch/arm64/kernel/perf_event.c	2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm64/kernel/perf_event.c	2013-08-26 13:48:40.952795024 -0500
@@ -1041,7 +1041,7 @@ static irqreturn_t armv8pmu_handle_irq(i
 	 */
 	regs = get_irq_regs();
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
@@ -1254,7 +1254,7 @@ device_initcall(register_pmu_driver);
 
 static struct pmu_hw_events *armpmu_get_cpu_events(void)
 {
-	return &__get_cpu_var(cpu_hw_events);
+	return this_cpu_ptr(&cpu_hw_events);
 }
 
 static void __init cpu_pmu_init(struct arm_pmu *armpmu)

