Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3HZVGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:06:23 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:51063 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab3HZVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:05:57 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 17:05:56 EDT
Message-Id: <00000140bc69acdb-3b2967b0-e224-424b-ad08-973515704be6-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:56:17 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 23/31] tile: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 199.127.232.35
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

Index: linux/arch/tile/include/asm/irqflags.h
===================================================================
--- linux.orig/arch/tile/include/asm/irqflags.h	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/include/asm/irqflags.h	2013-08-22 14:39:57.453305409 -0500
@@ -134,7 +134,7 @@ DECLARE_PER_CPU(unsigned long long, inte
 
 /* Re-enable all maskable interrupts. */
 #define arch_local_irq_enable() \
-	interrupt_mask_reset_mask(__get_cpu_var(interrupts_enabled_mask))
+	interrupt_mask_reset_mask(__this_cpu_read(interrupts_enabled_mask))
 
 /* Disable or enable interrupts based on flag argument. */
 #define arch_local_irq_restore(disabled) do { \
@@ -161,7 +161,7 @@ DECLARE_PER_CPU(unsigned long long, inte
 
 /* Prevent the given interrupt from being enabled next time we enable irqs. */
 #define arch_local_irq_mask(interrupt) \
-	(__get_cpu_var(interrupts_enabled_mask) &= ~(1ULL << (interrupt)))
+	(__this_cpu_read(interrupts_enabled_mask) &= ~(1ULL << (interrupt)))
 
 /* Prevent the given interrupt from being enabled immediately. */
 #define arch_local_irq_mask_now(interrupt) do { \
@@ -171,7 +171,7 @@ DECLARE_PER_CPU(unsigned long long, inte
 
 /* Allow the given interrupt to be enabled next time we enable irqs. */
 #define arch_local_irq_unmask(interrupt) \
-	(__get_cpu_var(interrupts_enabled_mask) |= (1ULL << (interrupt)))
+	(__this_cpu_read(interrupts_enabled_mask) |= (1ULL << (interrupt)))
 
 /* Allow the given interrupt to be enabled immediately, if !irqs_disabled. */
 #define arch_local_irq_unmask_now(interrupt) do { \
Index: linux/arch/tile/include/asm/mmu_context.h
===================================================================
--- linux.orig/arch/tile/include/asm/mmu_context.h	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/include/asm/mmu_context.h	2013-08-22 14:39:57.453305409 -0500
@@ -84,7 +84,7 @@ static inline void enter_lazy_tlb(struct
 	 * clear any pending DMA interrupts.
 	 */
 	if (current->thread.tile_dma_state.enabled)
-		install_page_table(mm->pgd, __get_cpu_var(current_asid));
+		install_page_table(mm->pgd, __this_cpu_read(current_asid));
 #endif
 }
 
@@ -96,12 +96,12 @@ static inline void switch_mm(struct mm_s
 		int cpu = smp_processor_id();
 
 		/* Pick new ASID. */
-		int asid = __get_cpu_var(current_asid) + 1;
+		int asid = __this_cpu_read(current_asid) + 1;
 		if (asid > max_asid) {
 			asid = min_asid;
 			local_flush_tlb();
 		}
-		__get_cpu_var(current_asid) = asid;
+		__this_cpu_read(current_asid) = asid;
 
 		/* Clear cpu from the old mm, and set it in the new one. */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
Index: linux/arch/tile/kernel/irq.c
===================================================================
--- linux.orig/arch/tile/kernel/irq.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/irq.c	2013-08-22 14:39:57.453305409 -0500
@@ -77,7 +77,7 @@ static DEFINE_SPINLOCK(available_irqs_lo
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
-	int depth = __get_cpu_var(irq_depth)++;
+	int depth = __this_cpu_inc_return(irq_depth) - 1;
 	unsigned long original_irqs;
 	unsigned long remaining_irqs;
 	struct pt_regs *old_regs;
@@ -124,7 +124,7 @@ void tile_dev_intr(struct pt_regs *regs,
 
 		/* Count device irqs; Linux IPIs are counted elsewhere. */
 		if (irq != IRQ_RESCHEDULE)
-			__get_cpu_var(irq_stat).irq_dev_intr_count++;
+			__this_cpu_inc(irq_stat.irq_dev_intr_count);
 
 		generic_handle_irq(irq);
 	}
@@ -135,9 +135,9 @@ void tile_dev_intr(struct pt_regs *regs,
 	 * handling.
 	 */
 	if (depth == 0)
-		unmask_irqs(~__get_cpu_var(irq_disable_mask));
+		unmask_irqs(~__this_cpu_read(irq_disable_mask));
 
-	__get_cpu_var(irq_depth)--;
+	__this_cpu_dec(irq_depth);
 
 	/*
 	 * Track time spent against the current process again and
@@ -155,7 +155,7 @@ void tile_dev_intr(struct pt_regs *regs,
 static void tile_irq_chip_enable(struct irq_data *d)
 {
 	get_cpu_var(irq_disable_mask) &= ~(1UL << d->irq);
-	if (__get_cpu_var(irq_depth) == 0)
+	if (__this_cpu_read(irq_depth) == 0)
 		unmask_irqs(1UL << d->irq);
 	put_cpu_var(irq_disable_mask);
 }
@@ -201,7 +201,7 @@ static void tile_irq_chip_ack(struct irq
  */
 static void tile_irq_chip_eoi(struct irq_data *d)
 {
-	if (!(__get_cpu_var(irq_disable_mask) & (1UL << d->irq)))
+	if (!(__this_cpu_read(irq_disable_mask) & (1UL << d->irq)))
 		unmask_irqs(1UL << d->irq);
 }
 
Index: linux/arch/tile/kernel/messaging.c
===================================================================
--- linux.orig/arch/tile/kernel/messaging.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/messaging.c	2013-08-22 14:39:57.453305409 -0500
@@ -28,7 +28,7 @@ static DEFINE_PER_CPU(HV_MsgState, msg_s
 void init_messaging(void)
 {
 	/* Allocate storage for messages in kernel space */
-	HV_MsgState *state = &__get_cpu_var(msg_state);
+	HV_MsgState *state = this_cpu_ptr(&msg_state);
 	int rc = hv_register_message_state(state);
 	if (rc != HV_OK)
 		panic("hv_register_message_state: error %d", rc);
@@ -68,7 +68,7 @@ void hv_message_intr(struct pt_regs *reg
 #endif
 
 	while (1) {
-		rmi = hv_receive_message(__get_cpu_var(msg_state),
+		rmi = hv_receive_message(__this_cpu_read(msg_state),
 					 (HV_VirtAddr) message,
 					 sizeof(message));
 		if (rmi.msglen == 0)
@@ -96,7 +96,7 @@ void hv_message_intr(struct pt_regs *reg
 			struct hv_driver_cb *cb =
 				(struct hv_driver_cb *)him->intarg;
 			cb->callback(cb, him->intdata);
-			__get_cpu_var(irq_stat).irq_hv_msg_count++;
+			__this_cpu_inc(irq_stat.irq_hv_msg_count);
 		}
 	}
 
Index: linux/arch/tile/kernel/process.c
===================================================================
--- linux.orig/arch/tile/kernel/process.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/process.c	2013-08-22 14:39:57.453305409 -0500
@@ -63,7 +63,7 @@ early_param("idle", idle_setup);
 
 void arch_cpu_idle(void)
 {
-	__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+	__this_cpu_write(irq_stat.idle_timestamp, jiffies);
 	_cpu_idle();
 }
 
Index: linux/arch/tile/kernel/setup.c
===================================================================
--- linux.orig/arch/tile/kernel/setup.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/setup.c	2013-08-22 14:39:57.453305409 -0500
@@ -1119,7 +1119,7 @@ static void __init validate_hv(void)
 	 * various asid variables to their appropriate initial states.
 	 */
 	asid_range = hv_inquire_asid(0);
-	__get_cpu_var(current_asid) = min_asid = asid_range.start;
+	__this_cpu_write(current_asid, min_asid = asid_range.start);
 	max_asid = asid_range.start + asid_range.size - 1;
 
 	if (hv_confstr(HV_CONFSTR_CHIP_MODEL, (HV_VirtAddr)chip_model,
Index: linux/arch/tile/kernel/single_step.c
===================================================================
--- linux.orig/arch/tile/kernel/single_step.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/single_step.c	2013-08-22 14:39:57.453305409 -0500
@@ -732,7 +732,7 @@ static DEFINE_PER_CPU(unsigned long, ss_
 
 void gx_singlestep_handle(struct pt_regs *regs, int fault_num)
 {
-	unsigned long *ss_pc = &__get_cpu_var(ss_saved_pc);
+	unsigned long *ss_pc = this_cpu_ptr(&ss_saved_pc);
 	struct thread_info *info = (void *)current_thread_info();
 	int is_single_step = test_ti_thread_flag(info, TIF_SINGLESTEP);
 	unsigned long control = __insn_mfspr(SPR_SINGLE_STEP_CONTROL_K);
@@ -758,7 +758,7 @@ void gx_singlestep_handle(struct pt_regs
 
 void single_step_once(struct pt_regs *regs)
 {
-	unsigned long *ss_pc = &__get_cpu_var(ss_saved_pc);
+	unsigned long *ss_pc = this_cpu_ptr(&ss_saved_pc);
 	unsigned long control = __insn_mfspr(SPR_SINGLE_STEP_CONTROL_K);
 
 	*ss_pc = regs->pc;
Index: linux/arch/tile/kernel/smp.c
===================================================================
--- linux.orig/arch/tile/kernel/smp.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/smp.c	2013-08-22 14:39:57.453305409 -0500
@@ -176,7 +176,7 @@ void flush_icache_range(unsigned long st
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
 static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
-	__get_cpu_var(irq_stat).irq_resched_count++;
+	__this_cpu_inc(irq_stat.irq_resched_count);
 	scheduler_ipi();
 
 	return IRQ_HANDLED;
Index: linux/arch/tile/kernel/smpboot.c
===================================================================
--- linux.orig/arch/tile/kernel/smpboot.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/smpboot.c	2013-08-22 14:39:57.453305409 -0500
@@ -41,7 +41,7 @@ void __init smp_prepare_boot_cpu(void)
 	int cpu = smp_processor_id();
 	set_cpu_online(cpu, 1);
 	set_cpu_present(cpu, 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
+	__this_cpu_write(cpu_state, CPU_ONLINE);
 
 	init_messaging();
 }
@@ -156,7 +156,7 @@ static void start_secondary(void)
 	/* printk(KERN_DEBUG "Initializing CPU#%d\n", cpuid); */
 
 	/* Initialize the current asid for our first page table. */
-	__get_cpu_var(current_asid) = min_asid;
+	__this_cpu_write(current_asid, min_asid);
 
 	/* Set up this thread as another owner of the init_mm */
 	atomic_inc(&init_mm.mm_count);
@@ -199,7 +199,7 @@ void online_secondary(void)
 	notify_cpu_starting(smp_processor_id());
 
 	set_cpu_online(smp_processor_id(), 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
+	__this_cpu_write(cpu_state, CPU_ONLINE);
 
 	/* Set up tile-specific state for this cpu. */
 	setup_cpu(0);
Index: linux/arch/tile/kernel/time.c
===================================================================
--- linux.orig/arch/tile/kernel/time.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/kernel/time.c	2013-08-22 14:39:57.453305409 -0500
@@ -161,7 +161,7 @@ static DEFINE_PER_CPU(struct clock_event
 
 void setup_tile_timer(void)
 {
-	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+	struct clock_event_device *evt = this_cpu_ptr(&tile_timer);
 
 	/* Fill in fields that are speed-specific. */
 	clockevents_calc_mult_shift(evt, cycles_per_sec, TILE_MINSEC);
@@ -181,7 +181,7 @@ void setup_tile_timer(void)
 void do_timer_interrupt(struct pt_regs *regs, int fault_num)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+	struct clock_event_device *evt = this_cpu_ptr(&tile_timer);
 
 	/*
 	 * Mask the timer interrupt here, since we are a oneshot timer
@@ -193,7 +193,7 @@ void do_timer_interrupt(struct pt_regs *
 	irq_enter();
 
 	/* Track interrupt count. */
-	__get_cpu_var(irq_stat).irq_timer_count++;
+	__this_cpu_inc(irq_stat.irq_timer_count);
 
 	/* Call the generic timer handler */
 	evt->event_handler(evt);
@@ -234,6 +234,6 @@ cycles_t ns2cycles(unsigned long nsecs)
 	 * We do not have to disable preemption here as each core has the same
 	 * clock frequency.
 	 */
-	struct clock_event_device *dev = &__raw_get_cpu_var(tile_timer);
+	struct clock_event_device *dev = __this_cpu_ptr(&tile_timer);
 	return ((u64)nsecs * dev->mult) >> dev->shift;
 }
Index: linux/arch/tile/mm/highmem.c
===================================================================
--- linux.orig/arch/tile/mm/highmem.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/mm/highmem.c	2013-08-22 14:39:57.453305409 -0500
@@ -103,7 +103,7 @@ static void kmap_atomic_register(struct
 	spin_lock(&amp_lock);
 
 	/* With interrupts disabled, now fill in the per-cpu info. */
-	amp = &__get_cpu_var(amps).per_type[type];
+	amp = this_cpu_ptr(&amps.per_type[type]);
 	amp->page = page;
 	amp->cpu = smp_processor_id();
 	amp->va = va;
Index: linux/arch/tile/mm/init.c
===================================================================
--- linux.orig/arch/tile/mm/init.c	2013-08-22 14:39:14.000000000 -0500
+++ linux/arch/tile/mm/init.c	2013-08-22 14:39:57.453305409 -0500
@@ -625,14 +625,14 @@ static void __init kernel_physical_mappi
 	interrupt_mask_set_mask(-1ULL);
 	rc = flush_and_install_context(__pa(pgtables),
 				       init_pgprot((unsigned long)pgtables),
-				       __get_cpu_var(current_asid),
+				       __this_cpu_read(current_asid),
 				       cpumask_bits(my_cpu_mask));
 	interrupt_mask_restore_mask(irqmask);
 	BUG_ON(rc != 0);
 
 	/* Copy the page table back to the normal swapper_pg_dir. */
 	memcpy(pgd_base, pgtables, sizeof(pgtables));
-	__install_page_table(pgd_base, __get_cpu_var(current_asid),
+	__install_page_table(pgd_base, __this_cpu_read(current_asid),
 			     swapper_pgprot);
 
 	/*

