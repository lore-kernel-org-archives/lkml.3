Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3LCXlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:41:16 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:52546 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664Ab3LCXjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:11 -0500
Message-Id: <20131203233302.346905245@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:33:05 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 33/41] powerpc: Replace __get_cpu_var uses
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_powerpc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

	this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)


Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/powerpc/include/asm/cputime.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/cputime.h	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/include/asm/cputime.h	2013-12-02 16:07:59.394366791 -0600
@@ -56,10 +56,10 @@ static inline unsigned long cputime_to_j
 static inline cputime_t cputime_to_scaled(const cputime_t ct)
 {
 	if (cpu_has_feature(CPU_FTR_SPURR) &&
-	    __get_cpu_var(cputime_last_delta))
+	    __this_cpu_read(cputime_last_delta))
 		return (__force u64) ct *
-			__get_cpu_var(cputime_scaled_last_delta) /
-			__get_cpu_var(cputime_last_delta);
+			__this_cpu_read(cputime_scaled_last_delta) /
+			__this_cpu_read(cputime_last_delta);
 	return ct;
 }
 
Index: linux/arch/powerpc/include/asm/hardirq.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/hardirq.h	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/include/asm/hardirq.h	2013-12-02 16:07:59.394366791 -0600
@@ -19,7 +19,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define __ARCH_IRQ_STAT
 
-#define local_softirq_pending()	__get_cpu_var(irq_stat).__softirq_pending
+#define local_softirq_pending()	__this_cpu_read(irq_stat.__softirq_pending)
 
 static inline void ack_bad_irq(unsigned int irq)
 {
Index: linux/arch/powerpc/include/asm/tlbflush.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/tlbflush.h	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/include/asm/tlbflush.h	2013-12-02 16:07:59.394366791 -0600
@@ -107,14 +107,14 @@ extern void __flush_tlb_pending(struct p
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	batch->active = 1;
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
Index: linux/arch/powerpc/include/asm/xics.h
===================================================================
--- linux.orig/arch/powerpc/include/asm/xics.h	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/include/asm/xics.h	2013-12-02 16:07:59.394366791 -0600
@@ -97,7 +97,7 @@ DECLARE_PER_CPU(struct xics_cppr, xics_c
 
 static inline void xics_push_cppr(unsigned int vec)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	if (WARN_ON(os_cppr->index >= MAX_NUM_PRIORITIES - 1))
 		return;
@@ -110,7 +110,7 @@ static inline void xics_push_cppr(unsign
 
 static inline unsigned char xics_pop_cppr(void)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	if (WARN_ON(os_cppr->index < 1))
 		return LOWEST_PRIORITY;
@@ -120,7 +120,7 @@ static inline unsigned char xics_pop_cpp
 
 static inline void xics_set_base_cppr(unsigned char cppr)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	/* we only really want to set the priority when there's
 	 * just one cppr value on the stack
@@ -132,7 +132,7 @@ static inline void xics_set_base_cppr(un
 
 static inline unsigned char xics_cppr_top(void)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 	
 	return os_cppr->stack[os_cppr->index];
 }
Index: linux/arch/powerpc/kernel/dbell.c
===================================================================
--- linux.orig/arch/powerpc/kernel/dbell.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/dbell.c	2013-12-02 16:07:59.394366791 -0600
@@ -41,7 +41,7 @@ void doorbell_exception(struct pt_regs *
 
 	may_hard_irq_enable();
 
-	__get_cpu_var(irq_stat).doorbell_irqs++;
+	__this_cpu_inc(irq_stat.doorbell_irqs);
 
 	smp_ipi_demux();
 
Index: linux/arch/powerpc/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/powerpc/kernel/hw_breakpoint.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/hw_breakpoint.c	2013-12-02 16:07:59.394366791 -0600
@@ -64,7 +64,7 @@ int hw_breakpoint_slots(int type)
 int arch_install_hw_breakpoint(struct perf_event *bp)
 {
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	struct perf_event **slot = &__get_cpu_var(bp_per_reg);
+	struct perf_event **slot = this_cpu_ptr(&bp_per_reg);
 
 	*slot = bp;
 
@@ -89,7 +89,7 @@ int arch_install_hw_breakpoint(struct pe
  */
 void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 {
-	struct perf_event **slot = &__get_cpu_var(bp_per_reg);
+	struct perf_event **slot = this_cpu_ptr(&bp_per_reg);
 
 	if (*slot != bp) {
 		WARN_ONCE(1, "Can't find the breakpoint");
@@ -227,7 +227,7 @@ int __kprobes hw_breakpoint_handler(stru
 	 */
 	rcu_read_lock();
 
-	bp = __get_cpu_var(bp_per_reg);
+	bp = __this_cpu_read(bp_per_reg);
 	if (!bp)
 		goto out;
 	info = counter_arch_bp(bp);
Index: linux/arch/powerpc/kernel/irq.c
===================================================================
--- linux.orig/arch/powerpc/kernel/irq.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/irq.c	2013-12-02 16:07:59.404366511 -0600
@@ -114,7 +114,7 @@ static inline notrace void set_soft_enab
 static inline notrace int decrementer_check_overflow(void)
 {
  	u64 now = get_tb_or_rtc();
- 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+	u64 *next_tb = this_cpu_ptr(&decrementers_next_tb);
  
 	return now >= *next_tb;
 }
Index: linux/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux.orig/arch/powerpc/kernel/kprobes.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/kprobes.c	2013-12-02 16:07:59.404366511 -0600
@@ -118,7 +118,7 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_saved_msr = kcb->prev_kprobe.saved_msr;
 }
@@ -126,7 +126,7 @@ static void __kprobes restore_previous_k
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_msr = regs->msr;
 }
 
@@ -191,7 +191,7 @@ static int __kprobes kprobe_handler(stru
 				ret = 1;
 				goto no_kprobe;
 			}
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs)) {
 				goto ss_probe;
 			}
Index: linux/arch/powerpc/kernel/process.c
===================================================================
--- linux.orig/arch/powerpc/kernel/process.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/process.c	2013-12-02 16:07:59.404366511 -0600
@@ -456,7 +456,7 @@ static inline int set_dawr(struct arch_h
 
 int set_breakpoint(struct arch_hw_breakpoint *brk)
 {
-	__get_cpu_var(current_brk) = *brk;
+	__this_cpu_write(current_brk, *brk);
 
 	if (cpu_has_feature(CPU_FTR_DAWR))
 		return set_dawr(brk);
@@ -690,7 +690,7 @@ struct task_struct *__switch_to(struct t
  * schedule DABR
  */
 #ifndef CONFIG_HAVE_HW_BREAKPOINT
-	if (unlikely(hw_brk_match(&__get_cpu_var(current_brk), &new->thread.hw_brk)))
+	if (unlikely(hw_brk_match(this_cpu_ptr(&current_brk), &new->thread.hw_brk)))
 		set_breakpoint(&new->thread.hw_brk);
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 #endif
@@ -704,7 +704,7 @@ struct task_struct *__switch_to(struct t
 	 * Collect processor utilization data per process
 	 */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
+		struct cpu_usage *cu = this_cpu_ptr(&cpu_usage_array);
 		long unsigned start_tb, current_tb;
 		start_tb = old_thread->start_tb;
 		cu->current_tb = current_tb = mfspr(SPRN_PURR);
@@ -714,7 +714,7 @@ struct task_struct *__switch_to(struct t
 #endif /* CONFIG_PPC64 */
 
 #ifdef CONFIG_PPC_BOOK3S_64
-	batch = &__get_cpu_var(ppc64_tlb_batch);
+	batch = this_cpu_ptr(&ppc64_tlb_batch);
 	if (batch->active) {
 		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
 		if (batch->index)
@@ -737,7 +737,7 @@ struct task_struct *__switch_to(struct t
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
 		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
-		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch = this_cpu_ptr(&ppc64_tlb_batch);
 		batch->active = 1;
 	}
 #endif /* CONFIG_PPC_BOOK3S_64 */
Index: linux/arch/powerpc/kernel/smp.c
===================================================================
--- linux.orig/arch/powerpc/kernel/smp.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/smp.c	2013-12-02 16:07:59.404366511 -0600
@@ -240,7 +240,7 @@ void smp_muxed_ipi_message_pass(int cpu,
 
 irqreturn_t smp_ipi_demux(void)
 {
-	struct cpu_messages *info = &__get_cpu_var(ipi_message);
+	struct cpu_messages *info = this_cpu_ptr(&ipi_message);
 	unsigned int all;
 
 	mb();	/* order any irq clear */
@@ -425,9 +425,9 @@ void generic_mach_cpu_die(void)
 	idle_task_exit();
 	cpu = smp_processor_id();
 	printk(KERN_DEBUG "CPU%d offline\n", cpu);
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);
 	smp_wmb();
-	while (__get_cpu_var(cpu_state) != CPU_UP_PREPARE)
+	while (__this_cpu_read(cpu_state) != CPU_UP_PREPARE)
 		cpu_relax();
 }
 
Index: linux/arch/powerpc/kernel/sysfs.c
===================================================================
--- linux.orig/arch/powerpc/kernel/sysfs.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/sysfs.c	2013-12-02 16:07:59.404366511 -0600
@@ -98,10 +98,10 @@ void ppc_enable_pmcs(void)
 	ppc_set_pmu_inuse(1);
 
 	/* Only need to enable them once */
-	if (__get_cpu_var(pmcs_enabled))
+	if (__this_cpu_read(pmcs_enabled))
 		return;
 
-	__get_cpu_var(pmcs_enabled) = 1;
+	__this_cpu_write(pmcs_enabled, 1);
 
 	if (ppc_md.enable_pmcs)
 		ppc_md.enable_pmcs();
Index: linux/arch/powerpc/kernel/time.c
===================================================================
--- linux.orig/arch/powerpc/kernel/time.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/time.c	2013-12-02 16:07:59.404366511 -0600
@@ -457,9 +457,9 @@ static inline void clear_irq_work_pendin
 
 DEFINE_PER_CPU(u8, irq_work_pending);
 
-#define set_irq_work_pending_flag()	__get_cpu_var(irq_work_pending) = 1
-#define test_irq_work_pending()		__get_cpu_var(irq_work_pending)
-#define clear_irq_work_pending()	__get_cpu_var(irq_work_pending) = 0
+#define set_irq_work_pending_flag()	__this_cpu_write(irq_work_pending, 1)
+#define test_irq_work_pending()		__this_cpu_read(irq_work_pending)
+#define clear_irq_work_pending()	__this_cpu_write(irq_work_pending, 0)
 
 #endif /* 32 vs 64 bit */
 
@@ -485,8 +485,8 @@ void arch_irq_work_raise(void)
 void timer_interrupt(struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
-	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
-	struct clock_event_device *evt = &__get_cpu_var(decrementers);
+	u64 *next_tb = this_cpu_ptr(&decrementers_next_tb);
+	struct clock_event_device *evt = this_cpu_ptr(&decrementers);
 	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
@@ -510,7 +510,7 @@ void timer_interrupt(struct pt_regs * re
 	 */
 	may_hard_irq_enable();
 
-	__get_cpu_var(irq_stat).timer_irqs++;
+	__this_cpu_inc(irq_stat.timer_irqs);
 
 #if defined(CONFIG_PPC32) && defined(CONFIG_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
@@ -541,7 +541,7 @@ void timer_interrupt(struct pt_regs * re
 #ifdef CONFIG_PPC64
 	/* collect purr register values often, for accurate calculations */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
+		struct cpu_usage *cu = this_cpu_ptr(&cpu_usage_array);
 		cu->current_tb = mfspr(SPRN_PURR);
 	}
 #endif
@@ -801,7 +801,7 @@ static void __init clocksource_init(void
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev)
 {
-	__get_cpu_var(decrementers_next_tb) = get_tb_or_rtc() + evt;
+	__this_cpu_write(decrementers_next_tb, get_tb_or_rtc() + evt);
 	set_dec(evt);
 	return 0;
 }
Index: linux/arch/powerpc/kernel/traps.c
===================================================================
--- linux.orig/arch/powerpc/kernel/traps.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/traps.c	2013-12-02 16:07:59.404366511 -0600
@@ -673,7 +673,7 @@ void machine_check_exception(struct pt_r
 	enum ctx_state prev_state = exception_enter();
 	int recover = 0;
 
-	__get_cpu_var(irq_stat).mce_exceptions++;
+	__this_cpu_inc(irq_stat.mce_exceptions);
 
 	/* See if any machine dependent calls. In theory, we would want
 	 * to call the CPU first, and call the ppc_md. one if the CPU
@@ -1456,7 +1456,7 @@ void vsx_unavailable_tm(struct pt_regs *
 
 void performance_monitor_exception(struct pt_regs *regs)
 {
-	__get_cpu_var(irq_stat).pmu_irqs++;
+	__this_cpu_inc(irq_stat.pmu_irqs);
 
 	perf_irq(regs);
 }
Index: linux/arch/powerpc/kvm/e500.c
===================================================================
--- linux.orig/arch/powerpc/kvm/e500.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kvm/e500.c	2013-12-02 16:07:59.404366511 -0600
@@ -74,11 +74,11 @@ static inline int local_sid_setup_one(st
 	unsigned long sid;
 	int ret = -1;
 
-	sid = ++(__get_cpu_var(pcpu_last_used_sid));
+	sid = __this_cpu_inc_return(pcpu_last_used_sid);
 	if (sid < NUM_TIDS) {
-		__get_cpu_var(pcpu_sids).entry[sid] = entry;
+		__this_cpu_write(pcpu_sids)entry[sid], entry);
 		entry->val = sid;
-		entry->pentry = &__get_cpu_var(pcpu_sids).entry[sid];
+		entry->pentry = this_cpu_ptr(&pcpu_sids.entry[sid]);
 		ret = sid;
 	}
 
@@ -106,8 +106,8 @@ static inline int local_sid_setup_one(st
 static inline int local_sid_lookup(struct id *entry)
 {
 	if (entry && entry->val != 0 &&
-	    __get_cpu_var(pcpu_sids).entry[entry->val] == entry &&
-	    entry->pentry == &__get_cpu_var(pcpu_sids).entry[entry->val])
+	    __this_cpu_read(pcpu_sids.entry[entry->val]) == entry &&
+	    entry->pentry == this_cpu_ptr(&pcpu_sids.entry[entry->val]))
 		return entry->val;
 	return -1;
 }
@@ -115,8 +115,8 @@ static inline int local_sid_lookup(struc
 /* Invalidate all id mappings on local core -- call with preempt disabled */
 static inline void local_sid_destroy_all(void)
 {
-	__get_cpu_var(pcpu_last_used_sid) = 0;
-	memset(&__get_cpu_var(pcpu_sids), 0, sizeof(__get_cpu_var(pcpu_sids)));
+	__this_cpu_write(pcpu_last_used_sid, 0);
+	memset(this_cpu_ptr(&pcpu_sids), 0, sizeof(pcpu_sids));
 }
 
 static void *kvmppc_e500_id_table_alloc(struct kvmppc_vcpu_e500 *vcpu_e500)
Index: linux/arch/powerpc/kvm/e500mc.c
===================================================================
--- linux.orig/arch/powerpc/kvm/e500mc.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kvm/e500mc.c	2013-12-02 16:07:59.404366511 -0600
@@ -139,9 +139,9 @@ static void kvmppc_core_vcpu_load_e500mc
 	mtspr(SPRN_GESR, vcpu->arch.shared->esr);
 
 	if (vcpu->arch.oldpir != mfspr(SPRN_PIR) ||
-	    __get_cpu_var(last_vcpu_on_cpu) != vcpu) {
+	    __this_cpu_read(last_vcpu_on_cpu) != vcpu) {
 		kvmppc_e500_tlbil_all(vcpu_e500);
-		__get_cpu_var(last_vcpu_on_cpu) = vcpu;
+		__this_cpu_read(last_vcpu_on_cpu) = vcpu;
 	}
 
 	kvmppc_load_guest_fp(vcpu);
Index: linux/arch/powerpc/mm/hash_native_64.c
===================================================================
--- linux.orig/arch/powerpc/mm/hash_native_64.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/mm/hash_native_64.c	2013-12-02 16:07:59.404366511 -0600
@@ -649,7 +649,7 @@ static void native_flush_hash_range(unsi
 	unsigned long want_v;
 	unsigned long flags;
 	real_pte_t pte;
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 	unsigned long psize = batch->psize;
 	int ssize = batch->ssize;
 	int i;
Index: linux/arch/powerpc/mm/hash_utils_64.c
===================================================================
--- linux.orig/arch/powerpc/mm/hash_utils_64.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/mm/hash_utils_64.c	2013-12-02 16:07:59.404366511 -0600
@@ -1283,7 +1283,7 @@ void flush_hash_range(unsigned long numb
 	else {
 		int i;
 		struct ppc64_tlb_batch *batch =
-			&__get_cpu_var(ppc64_tlb_batch);
+			this_cpu_ptr(&ppc64_tlb_batch);
 
 		for (i = 0; i < number; i++)
 			flush_hash_page(batch->vpn[i], batch->pte[i],
Index: linux/arch/powerpc/mm/hugetlbpage-book3e.c
===================================================================
--- linux.orig/arch/powerpc/mm/hugetlbpage-book3e.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/mm/hugetlbpage-book3e.c	2013-12-02 16:07:59.404366511 -0600
@@ -80,14 +80,14 @@ void book3e_hugetlb_preload(struct vm_ar
 	ncams = mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY;
 
 	/* We have to use the CAM(TLB1) on FSL parts for hugepages */
-	index = __get_cpu_var(next_tlbcam_idx);
+	index = __this_cpu_read(next_tlbcam_idx);
 	mtspr(SPRN_MAS0, MAS0_ESEL(index) | MAS0_TLBSEL(1));
 
 	/* Just round-robin the entries and wrap when we hit the end */
 	if (unlikely(index == ncams - 1))
-		__get_cpu_var(next_tlbcam_idx) = tlbcam_index;
+		__this_cpu_write(next_tlbcam_idx, tlbcam_index);
 	else
-		__get_cpu_var(next_tlbcam_idx)++;
+		__this_cpu_inc(next_tlbcam_idx);
 #endif
 	mas1 = MAS1_VALID | MAS1_TID(mm->context.id) | MAS1_TSIZE(tsize);
 	mas2 = ea & ~((1UL << shift) - 1);
Index: linux/arch/powerpc/mm/hugetlbpage.c
===================================================================
--- linux.orig/arch/powerpc/mm/hugetlbpage.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/mm/hugetlbpage.c	2013-12-02 16:07:59.404366511 -0600
@@ -472,7 +472,7 @@ static void hugepd_free(struct mmu_gathe
 {
 	struct hugepd_freelist **batchp;
 
-	batchp = &__get_cpu_var(hugepd_freelist_cur);
+	batchp = this_cpu_ptr(&hugepd_freelist_cur);
 
 	if (atomic_read(&tlb->mm->mm_users) < 2 ||
 	    cpumask_equal(mm_cpumask(tlb->mm),
Index: linux/arch/powerpc/mm/stab.c
===================================================================
--- linux.orig/arch/powerpc/mm/stab.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/mm/stab.c	2013-12-02 16:07:59.404366511 -0600
@@ -133,12 +133,12 @@ static int __ste_allocate(unsigned long
 	stab_entry = make_ste(get_paca()->stab_addr, GET_ESID(ea), vsid);
 
 	if (!is_kernel_addr(ea)) {
-		offset = __get_cpu_var(stab_cache_ptr);
+		offset = __this_cpu_read(stab_cache_ptr);
 		if (offset < NR_STAB_CACHE_ENTRIES)
-			__get_cpu_var(stab_cache[offset++]) = stab_entry;
+			__this_cpu_read(stab_cache[offset++]) = stab_entry;
 		else
 			offset = NR_STAB_CACHE_ENTRIES+1;
-		__get_cpu_var(stab_cache_ptr) = offset;
+		__this_cpu_write(stab_cache_ptr, offset);
 
 		/* Order update */
 		asm volatile("sync":::"memory");
@@ -177,12 +177,12 @@ void switch_stab(struct task_struct *tsk
 	 */
 	hard_irq_disable();
 
-	offset = __get_cpu_var(stab_cache_ptr);
+	offset = __this_cpu_read(stab_cache_ptr);
 	if (offset <= NR_STAB_CACHE_ENTRIES) {
 		int i;
 
 		for (i = 0; i < offset; i++) {
-			ste = stab + __get_cpu_var(stab_cache[i]);
+			ste = stab + __this_cpu_read(stab_cache[i]);
 			ste->esid_data = 0; /* invalidate entry */
 		}
 	} else {
@@ -206,7 +206,7 @@ void switch_stab(struct task_struct *tsk
 
 	asm volatile("sync; slbia; sync":::"memory");
 
-	__get_cpu_var(stab_cache_ptr) = 0;
+	__this_cpu_write(stab_cache_ptr, 0);
 
 	/* Now preload some entries for the new task */
 	if (test_tsk_thread_flag(tsk, TIF_32BIT))
Index: linux/arch/powerpc/perf/core-book3s.c
===================================================================
--- linux.orig/arch/powerpc/perf/core-book3s.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/perf/core-book3s.c	2013-12-02 16:07:59.404366511 -0600
@@ -332,7 +332,7 @@ static void power_pmu_bhrb_reset(void)
 
 static void power_pmu_bhrb_enable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!ppmu->bhrb_nr)
 		return;
@@ -347,7 +347,7 @@ static void power_pmu_bhrb_enable(struct
 
 static void power_pmu_bhrb_disable(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!ppmu->bhrb_nr)
 		return;
@@ -961,7 +961,7 @@ static void power_pmu_disable(struct pmu
 	if (!ppmu)
 		return;
 	local_irq_save(flags);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuhw->disabled) {
 		/*
@@ -1027,7 +1027,7 @@ static void power_pmu_enable(struct pmu
 		return;
 	local_irq_save(flags);
 
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	if (!cpuhw->disabled)
 		goto out;
 
@@ -1211,7 +1211,7 @@ static int power_pmu_add(struct perf_eve
 	 * Add the event to the list (if there is room)
 	 * and check whether the total set is still feasible.
 	 */
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	n0 = cpuhw->n_events;
 	if (n0 >= ppmu->n_counter)
 		goto out;
@@ -1277,7 +1277,7 @@ static void power_pmu_del(struct perf_ev
 
 	power_pmu_read(event);
 
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	for (i = 0; i < cpuhw->n_events; ++i) {
 		if (event == cpuhw->event[i]) {
 			while (++i < cpuhw->n_events) {
@@ -1383,7 +1383,7 @@ static void power_pmu_stop(struct perf_e
  */
 void power_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	perf_pmu_disable(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
@@ -1397,7 +1397,7 @@ void power_pmu_start_txn(struct pmu *pmu
  */
 void power_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 	perf_pmu_enable(pmu);
@@ -1415,7 +1415,7 @@ int power_pmu_commit_txn(struct pmu *pmu
 
 	if (!ppmu)
 		return -EAGAIN;
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	n = cpuhw->n_events;
 	if (check_excludes(cpuhw->event, cpuhw->flags, 0, n))
 		return -EAGAIN;
@@ -1772,7 +1772,7 @@ static void record_and_restart(struct pe
 
 		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK) {
 			struct cpu_hw_events *cpuhw;
-			cpuhw = &__get_cpu_var(cpu_hw_events);
+			cpuhw = this_cpu_ptr(&cpu_hw_events);
 			power_pmu_bhrb_read(cpuhw);
 			data.br_stack = &cpuhw->bhrb_stack;
 		}
@@ -1845,7 +1845,7 @@ static bool pmc_overflow(unsigned long v
 static void perf_event_interrupt(struct pt_regs *regs)
 {
 	int i, j;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	unsigned long val[8];
 	int found, active;
Index: linux/arch/powerpc/perf/core-fsl-emb.c
===================================================================
--- linux.orig/arch/powerpc/perf/core-fsl-emb.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/perf/core-fsl-emb.c	2013-12-02 16:07:59.404366511 -0600
@@ -210,7 +210,7 @@ static void fsl_emb_pmu_disable(struct p
 	unsigned long flags;
 
 	local_irq_save(flags);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuhw->disabled) {
 		cpuhw->disabled = 1;
@@ -249,7 +249,7 @@ static void fsl_emb_pmu_enable(struct pm
 	unsigned long flags;
 
 	local_irq_save(flags);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 	if (!cpuhw->disabled)
 		goto out;
 
@@ -653,7 +653,7 @@ static void record_and_restart(struct pe
 static void perf_event_interrupt(struct pt_regs *regs)
 {
 	int i;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	unsigned long val;
 	int found = 0;
Index: linux/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux.orig/arch/powerpc/platforms/cell/interrupt.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/cell/interrupt.c	2013-12-02 16:07:59.404366511 -0600
@@ -82,7 +82,7 @@ static void iic_unmask(struct irq_data *
 
 static void iic_eoi(struct irq_data *d)
 {
-	struct iic *iic = &__get_cpu_var(cpu_iic);
+	struct iic *iic = this_cpu_ptr(&cpu_iic);
 	out_be64(&iic->regs->prio, iic->eoi_stack[--iic->eoi_ptr]);
 	BUG_ON(iic->eoi_ptr < 0);
 }
@@ -148,7 +148,7 @@ static unsigned int iic_get_irq(void)
 	struct iic *iic;
 	unsigned int virq;
 
-	iic = &__get_cpu_var(cpu_iic);
+	iic = this_cpu_ptr(&cpu_iic);
 	*(unsigned long *) &pending =
 		in_be64((u64 __iomem *) &iic->regs->pending_destr);
 	if (!(pending.flags & CBE_IIC_IRQ_VALID))
@@ -163,7 +163,7 @@ static unsigned int iic_get_irq(void)
 
 void iic_setup_cpu(void)
 {
-	out_be64(&__get_cpu_var(cpu_iic).regs->prio, 0xff);
+	out_be64(this_cpu_ptr(&cpu_iic.regs->prio), 0xff);
 }
 
 u8 iic_get_target_id(int cpu)
Index: linux/arch/powerpc/platforms/ps3/interrupt.c
===================================================================
--- linux.orig/arch/powerpc/platforms/ps3/interrupt.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/ps3/interrupt.c	2013-12-02 16:07:59.404366511 -0600
@@ -711,7 +711,7 @@ void __init ps3_register_ipi_irq(unsigne
 
 static unsigned int ps3_get_irq(void)
 {
-	struct ps3_private *pd = &__get_cpu_var(ps3_private);
+	struct ps3_private *pd = this_cpu_ptr(&ps3_private);
 	u64 x = (pd->bmp.status & pd->bmp.mask);
 	unsigned int plug;
 
Index: linux/arch/powerpc/platforms/pseries/dtl.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/dtl.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/pseries/dtl.c	2013-12-02 16:07:59.404366511 -0600
@@ -75,7 +75,7 @@ static atomic_t dtl_count;
  */
 static void consume_dtle(struct dtl_entry *dtle, u64 index)
 {
-	struct dtl_ring *dtlr = &__get_cpu_var(dtl_rings);
+	struct dtl_ring *dtlr = this_cpu_ptr(&dtl_rings);
 	struct dtl_entry *wp = dtlr->write_ptr;
 	struct lppaca *vpa = local_paca->lppaca_ptr;
 
Index: linux/arch/powerpc/platforms/pseries/hvCall_inst.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/hvCall_inst.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/pseries/hvCall_inst.c	2013-12-02 16:07:59.404366511 -0600
@@ -109,7 +109,7 @@ static void probe_hcall_entry(void *igno
 	if (opcode > MAX_HCALL_OPCODE)
 		return;
 
-	h = &__get_cpu_var(hcall_stats)[opcode / 4];
+	h = this_cpu_ptr(&hcall_stats[opcode / 4]);
 	h->tb_start = mftb();
 	h->purr_start = mfspr(SPRN_PURR);
 }
@@ -122,7 +122,7 @@ static void probe_hcall_exit(void *ignor
 	if (opcode > MAX_HCALL_OPCODE)
 		return;
 
-	h = &__get_cpu_var(hcall_stats)[opcode / 4];
+	h = this_cpu_ptr(&hcall_stats[opcode / 4]);
 	h->num_calls++;
 	h->tb_total += mftb() - h->tb_start;
 	h->purr_total += mfspr(SPRN_PURR) - h->purr_start;
Index: linux/arch/powerpc/platforms/pseries/iommu.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/iommu.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/pseries/iommu.c	2013-12-02 16:07:59.404366511 -0600
@@ -200,7 +200,7 @@ static int tce_buildmulti_pSeriesLP(stru
 
 	local_irq_save(flags);	/* to protect tcep and the page behind it */
 
-	tcep = __get_cpu_var(tce_page);
+	tcep = __this_cpu_read(tce_page);
 
 	/* This is safe to do since interrupts are off when we're called
 	 * from iommu_alloc{,_sg}()
@@ -213,7 +213,7 @@ static int tce_buildmulti_pSeriesLP(stru
 			return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
 					    direction, attrs);
 		}
-		__get_cpu_var(tce_page) = tcep;
+		__this_cpu_write(tce_page, tcep);
 	}
 
 	rpn = __pa(uaddr) >> TCE_SHIFT;
@@ -399,7 +399,7 @@ static int tce_setrange_multi_pSeriesLP(
 	long l, limit;
 
 	local_irq_disable();	/* to protect tcep and the page behind it */
-	tcep = __get_cpu_var(tce_page);
+	tcep = __this_cpu_read(tce_page);
 
 	if (!tcep) {
 		tcep = (__be64 *)__get_free_page(GFP_ATOMIC);
@@ -407,7 +407,7 @@ static int tce_setrange_multi_pSeriesLP(
 			local_irq_enable();
 			return -ENOMEM;
 		}
-		__get_cpu_var(tce_page) = tcep;
+		__this_cpu_write(tce_page, tcep);
 	}
 
 	proto_tce = TCE_PCI_READ | TCE_PCI_WRITE;
Index: linux/arch/powerpc/platforms/pseries/lpar.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/lpar.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/pseries/lpar.c	2013-12-02 16:07:59.404366511 -0600
@@ -513,7 +513,7 @@ static void pSeries_lpar_flush_hash_rang
 	unsigned long vpn;
 	unsigned long i, pix, rc;
 	unsigned long flags = 0;
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = this_cpu_ptr(&ppc64_tlb_batch);
 	int lock_tlbie = !mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE);
 	unsigned long param[9];
 	unsigned long hash, index, shift, hidx, slot;
@@ -688,7 +688,7 @@ void __trace_hcall_entry(unsigned long o
 
 	local_irq_save(flags);
 
-	depth = &__get_cpu_var(hcall_trace_depth);
+	depth = this_cpu_ptr(&hcall_trace_depth);
 
 	if (*depth)
 		goto out;
@@ -713,7 +713,7 @@ void __trace_hcall_exit(long opcode, uns
 
 	local_irq_save(flags);
 
-	depth = &__get_cpu_var(hcall_trace_depth);
+	depth = this_cpu_ptr(&hcall_trace_depth);
 
 	if (*depth)
 		goto out;
Index: linux/arch/powerpc/platforms/pseries/ras.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/ras.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/platforms/pseries/ras.c	2013-12-02 16:07:59.404366511 -0600
@@ -301,8 +301,8 @@ static struct rtas_error_log *fwnmi_get_
 	/* If it isn't an extended log we can use the per cpu 64bit buffer */
 	h = (struct rtas_error_log *)&savep[1];
 	if (!h->extended) {
-		memcpy(&__get_cpu_var(mce_data_buf), h, sizeof(__u64));
-		errhdr = (struct rtas_error_log *)&__get_cpu_var(mce_data_buf);
+		memcpy(this_cpu_ptr(&mce_data_buf), h, sizeof(__u64));
+		errhdr = (struct rtas_error_log *)this_cpu_ptr(&mce_data_buf);
 	} else {
 		int len;
 
Index: linux/arch/powerpc/sysdev/xics/xics-common.c
===================================================================
--- linux.orig/arch/powerpc/sysdev/xics/xics-common.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/sysdev/xics/xics-common.c	2013-12-02 16:07:59.404366511 -0600
@@ -155,7 +155,7 @@ int __init xics_smp_probe(void)
 
 void xics_teardown_cpu(void)
 {
-	struct xics_cppr *os_cppr = &__get_cpu_var(xics_cppr);
+	struct xics_cppr *os_cppr = this_cpu_ptr(&xics_cppr);
 
 	/*
 	 * we have to reset the cppr index to 0 because we're
Index: linux/arch/powerpc/kernel/iommu.c
===================================================================
--- linux.orig/arch/powerpc/kernel/iommu.c	2013-12-02 16:07:59.404366511 -0600
+++ linux/arch/powerpc/kernel/iommu.c	2013-12-02 16:07:59.404366511 -0600
@@ -208,7 +208,7 @@ static unsigned long iommu_range_alloc(s
 	 * We don't need to disable preemption here because any CPU can
 	 * safely use any IOMMU pool.
 	 */
-	pool_nr = __raw_get_cpu_var(iommu_pool_hash) & (tbl->nr_pools - 1);
+	pool_nr = __this_cpu_read(iommu_pool_hash) & (tbl->nr_pools - 1);
 
 	if (largealloc)
 		pool = &(tbl->large_pool);

