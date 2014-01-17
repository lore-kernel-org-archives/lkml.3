Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaAQPV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:21:28 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:45673
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbaAQPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:18:46 -0500
Message-Id: <20140117151838.048751141@linux.com>
Date: Fri, 17 Jan 2014 09:18:47 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 35/41] tile: Replace __get_cpu_var uses
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_tile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch depends on another patch in this series that introduces raw_cpu_ops]

__get_cpu_var() is used for multiple purposes in the kernel source. One of
them is address calculation via the form &__get_cpu_var(x).  This calculates
the address for the instance of the percpu variable of the current processor
based on an offset.

Other use cases are for storing and retrieving data from the current
processors percpu area.  __get_cpu_var() can be used as an lvalue when
writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does an address determination. However, store
and retrieve operations could use a segment prefix (or global register on
other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a
percpu area and use optimized assembly code to read and write per cpu
variables.


This patch converts __get_cpu_var into either an explicit address
calculation using this_cpu_ptr() or into a use of this_cpu operations that
use the offset.  Thereby address calculations are avoided and less registers
are used when code is generated.

At the end of the patch set all uses of __get_cpu_var have been removed so
the macro is removed too.

The patch set includes passes over all arches as well. Once these operations
are used throughout then specialized macros can be defined in non -x86
arches as well in order to optimize per cpu access by f.e.  using a global
register that may be set to the per cpu base.




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


3. Retrieve the content of the current processors instance of a per cpu
variable.

	DEFINE_PER_CPU(int, y);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(&x, this_cpu_ptr(&y), sizeof(x));


5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	__this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	__this_cpu_inc(y)


Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/tile/include/asm/mmu_context.h
===================================================================
--- linux.orig/arch/tile/include/asm/mmu_context.h	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/include/asm/mmu_context.h	2013-12-18 13:40:08.322514483 -0600
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
+		__this_cpu_write(current_asid, asid);
 
 		/* Clear cpu from the old mm, and set it in the new one. */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
Index: linux/arch/tile/kernel/irq.c
===================================================================
--- linux.orig/arch/tile/kernel/irq.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/irq.c	2013-12-18 13:40:08.322514483 -0600
@@ -79,7 +79,7 @@ static DEFINE_SPINLOCK(available_irqs_lo
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
-	int depth = __get_cpu_var(irq_depth)++;
+	int depth = __this_cpu_inc_return(irq_depth);
 	unsigned long original_irqs;
 	unsigned long remaining_irqs;
 	struct pt_regs *old_regs;
@@ -126,7 +126,7 @@ void tile_dev_intr(struct pt_regs *regs,
 
 		/* Count device irqs; Linux IPIs are counted elsewhere. */
 		if (irq != IRQ_RESCHEDULE)
-			__get_cpu_var(irq_stat).irq_dev_intr_count++;
+			__this_cpu_inc(irq_stat.irq_dev_intr_count);
 
 		generic_handle_irq(irq);
 	}
@@ -136,10 +136,10 @@ void tile_dev_intr(struct pt_regs *regs,
 	 * including any that were reenabled during interrupt
 	 * handling.
 	 */
-	if (depth == 0)
-		unmask_irqs(~__get_cpu_var(irq_disable_mask));
+	if (depth == 1)
+		unmask_irqs(~__this_cpu_read(irq_disable_mask));
 
-	__get_cpu_var(irq_depth)--;
+	__this_cpu_dec(irq_depth);
 
 	/*
 	 * Track time spent against the current process again and
@@ -157,7 +157,7 @@ void tile_dev_intr(struct pt_regs *regs,
 static void tile_irq_chip_enable(struct irq_data *d)
 {
 	get_cpu_var(irq_disable_mask) &= ~(1UL << d->irq);
-	if (__get_cpu_var(irq_depth) == 0)
+	if (__this_cpu_read(irq_depth) == 0)
 		unmask_irqs(1UL << d->irq);
 	put_cpu_var(irq_disable_mask);
 }
@@ -203,7 +203,7 @@ static void tile_irq_chip_ack(struct irq
  */
 static void tile_irq_chip_eoi(struct irq_data *d)
 {
-	if (!(__get_cpu_var(irq_disable_mask) & (1UL << d->irq)))
+	if (!(__this_cpu_read(irq_disable_mask) & (1UL << d->irq)))
 		unmask_irqs(1UL << d->irq);
 }
 
Index: linux/arch/tile/kernel/messaging.c
===================================================================
--- linux.orig/arch/tile/kernel/messaging.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/messaging.c	2013-12-18 13:40:08.322514483 -0600
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
--- linux.orig/arch/tile/kernel/process.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/process.c	2013-12-18 13:40:08.322514483 -0600
@@ -64,7 +64,7 @@ early_param("idle", idle_setup);
 
 void arch_cpu_idle(void)
 {
-	__get_cpu_var(irq_stat).idle_timestamp = jiffies;
+	__this_cpu_write(irq_stat.idle_timestamp, jiffies);
 	_cpu_idle();
 }
 
Index: linux/arch/tile/kernel/setup.c
===================================================================
--- linux.orig/arch/tile/kernel/setup.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/setup.c	2013-12-18 13:40:08.322514483 -0600
@@ -1220,7 +1220,8 @@ static void __init validate_hv(void)
 	 * various asid variables to their appropriate initial states.
 	 */
 	asid_range = hv_inquire_asid(0);
-	__get_cpu_var(current_asid) = min_asid = asid_range.start;
+	min_asid = asid_range.start;
+	__this_cpu_write(current_asid, min_asid);
 	max_asid = asid_range.start + asid_range.size - 1;
 
 	if (hv_confstr(HV_CONFSTR_CHIP_MODEL, (HV_VirtAddr)chip_model,
Index: linux/arch/tile/kernel/single_step.c
===================================================================
--- linux.orig/arch/tile/kernel/single_step.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/single_step.c	2013-12-18 13:40:08.322514483 -0600
@@ -740,7 +740,7 @@ static DEFINE_PER_CPU(unsigned long, ss_
 
 void gx_singlestep_handle(struct pt_regs *regs, int fault_num)
 {
-	unsigned long *ss_pc = &__get_cpu_var(ss_saved_pc);
+	unsigned long *ss_pc = this_cpu_ptr(&ss_saved_pc);
 	struct thread_info *info = (void *)current_thread_info();
 	int is_single_step = test_ti_thread_flag(info, TIF_SINGLESTEP);
 	unsigned long control = __insn_mfspr(SPR_SINGLE_STEP_CONTROL_K);
@@ -766,7 +766,7 @@ void gx_singlestep_handle(struct pt_regs
 
 void single_step_once(struct pt_regs *regs)
 {
-	unsigned long *ss_pc = &__get_cpu_var(ss_saved_pc);
+	unsigned long *ss_pc = this_cpu_ptr(&ss_saved_pc);
 	unsigned long control = __insn_mfspr(SPR_SINGLE_STEP_CONTROL_K);
 
 	*ss_pc = regs->pc;
Index: linux/arch/tile/kernel/smp.c
===================================================================
--- linux.orig/arch/tile/kernel/smp.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/smp.c	2013-12-18 13:40:08.322514483 -0600
@@ -188,7 +188,7 @@ void flush_icache_range(unsigned long st
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
 static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
-	__get_cpu_var(irq_stat).irq_resched_count++;
+	__this_cpu_inc(irq_stat.irq_resched_count);
 	scheduler_ipi();
 
 	return IRQ_HANDLED;
Index: linux/arch/tile/kernel/smpboot.c
===================================================================
--- linux.orig/arch/tile/kernel/smpboot.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/smpboot.c	2013-12-18 13:40:08.322514483 -0600
@@ -41,7 +41,7 @@ void __init smp_prepare_boot_cpu(void)
 	int cpu = smp_processor_id();
 	set_cpu_online(cpu, 1);
 	set_cpu_present(cpu, 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
+	__this_cpu_write(cpu_state, CPU_ONLINE);
 
 	init_messaging();
 }
@@ -158,7 +158,7 @@ static void start_secondary(void)
 	/* printk(KERN_DEBUG "Initializing CPU#%d\n", cpuid); */
 
 	/* Initialize the current asid for our first page table. */
-	__get_cpu_var(current_asid) = min_asid;
+	__this_cpu_write(current_asid, min_asid);
 
 	/* Set up this thread as another owner of the init_mm */
 	atomic_inc(&init_mm.mm_count);
@@ -201,7 +201,7 @@ void online_secondary(void)
 	notify_cpu_starting(smp_processor_id());
 
 	set_cpu_online(smp_processor_id(), 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
+	__this_cpu_write(cpu_state, CPU_ONLINE);
 
 	/* Set up tile-specific state for this cpu. */
 	setup_cpu(0);
Index: linux/arch/tile/kernel/time.c
===================================================================
--- linux.orig/arch/tile/kernel/time.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/kernel/time.c	2013-12-18 13:40:08.322514483 -0600
@@ -162,7 +162,7 @@ static DEFINE_PER_CPU(struct clock_event
 
 void setup_tile_timer(void)
 {
-	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+	struct clock_event_device *evt = this_cpu_ptr(&tile_timer);
 
 	/* Fill in fields that are speed-specific. */
 	clockevents_calc_mult_shift(evt, cycles_per_sec, TILE_MINSEC);
@@ -182,7 +182,7 @@ void setup_tile_timer(void)
 void do_timer_interrupt(struct pt_regs *regs, int fault_num)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+	struct clock_event_device *evt = this_cpu_ptr(&tile_timer);
 
 	/*
 	 * Mask the timer interrupt here, since we are a oneshot timer
@@ -194,7 +194,7 @@ void do_timer_interrupt(struct pt_regs *
 	irq_enter();
 
 	/* Track interrupt count. */
-	__get_cpu_var(irq_stat).irq_timer_count++;
+	__this_cpu_inc(irq_stat.irq_timer_count);
 
 	/* Call the generic timer handler */
 	evt->event_handler(evt);
@@ -235,7 +235,7 @@ cycles_t ns2cycles(unsigned long nsecs)
 	 * We do not have to disable preemption here as each core has the same
 	 * clock frequency.
 	 */
-	struct clock_event_device *dev = &__raw_get_cpu_var(tile_timer);
+	struct clock_event_device *dev = raw_cpu_ptr(&tile_timer);
 	return ((u64)nsecs * dev->mult) >> dev->shift;
 }
 
Index: linux/arch/tile/mm/highmem.c
===================================================================
--- linux.orig/arch/tile/mm/highmem.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/mm/highmem.c	2013-12-18 13:40:08.322514483 -0600
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
--- linux.orig/arch/tile/mm/init.c	2013-12-18 13:40:08.322514483 -0600
+++ linux/arch/tile/mm/init.c	2013-12-18 13:40:08.322514483 -0600
@@ -593,14 +593,14 @@ static void __init kernel_physical_mappi
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
Index: linux/arch/tile/include/asm/irqflags.h
===================================================================
--- linux.orig/arch/tile/include/asm/irqflags.h	2013-12-18 13:37:21.000000000 -0600
+++ linux/arch/tile/include/asm/irqflags.h	2013-12-18 13:40:24.781984237 -0600
@@ -140,12 +140,12 @@ extern unsigned int debug_smp_processor_
 
 /*
  * Read the set of maskable interrupts.
- * We avoid the preemption warning here via __this_cpu_ptr since even
+ * We avoid the preemption warning here via raw_cpu_ptr since even
  * if irqs are already enabled, it's harmless to read the wrong cpu's
  * enabled mask.
  */
 #define arch_local_irqs_enabled() \
-	(*__this_cpu_ptr(&interrupts_enabled_mask))
+	(*raw_cpu_ptr(&interrupts_enabled_mask))
 
 /* Re-enable all maskable interrupts. */
 #define arch_local_irq_enable() \

