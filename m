Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3HZUvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:51:38 -0400
Received: from a10-13.smtp-out.amazonses.com ([54.240.10.13]:55536 "EHLO
	a10-13.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab3HZUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:51:35 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 16:51:34 EDT
Message-ID: <00000140bc5f2f67-5accf952-d656-4033-af93-07c2dce30305-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:49 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 21/31] sparc: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.10.13
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

Index: linux/arch/sparc/include/asm/cpudata_32.h
===================================================================
--- linux.orig/arch/sparc/include/asm/cpudata_32.h	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/include/asm/cpudata_32.h	2013-08-22 14:37:15.942964723 -0500
@@ -26,6 +26,6 @@ typedef struct {
 
 DECLARE_PER_CPU(cpuinfo_sparc, __cpu_data);
 #define cpu_data(__cpu) per_cpu(__cpu_data, (__cpu))
-#define local_cpu_data() __get_cpu_var(__cpu_data)
+#define local_cpu_data() __this_cpu_read(__cpu_data)
 
 #endif /* _SPARC_CPUDATA_H */
Index: linux/arch/sparc/include/asm/cpudata_64.h
===================================================================
--- linux.orig/arch/sparc/include/asm/cpudata_64.h	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/include/asm/cpudata_64.h	2013-08-22 14:37:15.942964723 -0500
@@ -33,7 +33,7 @@ typedef struct {
 
 DECLARE_PER_CPU(cpuinfo_sparc, __cpu_data);
 #define cpu_data(__cpu)		per_cpu(__cpu_data, (__cpu))
-#define local_cpu_data()	__get_cpu_var(__cpu_data)
+#define local_cpu_data()	__this_cpu_read(__cpu_data)
 
 extern const struct seq_operations cpuinfo_op;
 
Index: linux/arch/sparc/kernel/kprobes.c
===================================================================
--- linux.orig/arch/sparc/kernel/kprobes.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/kprobes.c	2013-08-22 14:37:15.942964723 -0500
@@ -82,7 +82,7 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_orig_tnpc = kcb->prev_kprobe.orig_tnpc;
 	kcb->kprobe_orig_tstate_pil = kcb->prev_kprobe.orig_tstate_pil;
@@ -91,7 +91,7 @@ static void __kprobes restore_previous_k
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_orig_tnpc = regs->tnpc;
 	kcb->kprobe_orig_tstate_pil = (regs->tstate & TSTATE_PIL);
 }
@@ -154,7 +154,7 @@ static int __kprobes kprobe_handler(stru
 				ret = 1;
 				goto no_kprobe;
 			}
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs))
 				goto ss_probe;
 		}
Index: linux/arch/sparc/kernel/leon_smp.c
===================================================================
--- linux.orig/arch/sparc/kernel/leon_smp.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/leon_smp.c	2013-08-22 14:37:15.942964723 -0500
@@ -354,7 +354,7 @@ static void leon_ipi_resched(int cpu)
 
 void leonsmp_ipi_interrupt(void)
 {
-	struct leon_ipi_work *work = &__get_cpu_var(leon_ipi_work);
+	struct leon_ipi_work *work = this_cpu_ptr(&leon_ipi_work);
 
 	if (work->single) {
 		work->single = 0;
Index: linux/arch/sparc/kernel/nmi.c
===================================================================
--- linux.orig/arch/sparc/kernel/nmi.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/nmi.c	2013-08-22 14:37:15.942964723 -0500
@@ -111,20 +111,20 @@ notrace __kprobes void perfctr_irq(int i
 		pcr_ops->write_pcr(0, pcr_ops->pcr_nmi_disable);
 
 	sum = local_cpu_data().irq0_irqs;
-	if (__get_cpu_var(nmi_touch)) {
-		__get_cpu_var(nmi_touch) = 0;
+	if (__this_cpu_read(nmi_touch)) {
+		__this_cpu_write(nmi_touch, 0);
 		touched = 1;
 	}
-	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
+	if (!touched && __this_cpu_read(last_irq_sum) == sum) {
 		__this_cpu_inc(alert_counter);
 		if (__this_cpu_read(alert_counter) == 30 * nmi_hz)
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
 				regs, panic_on_timeout);
 	} else {
-		__get_cpu_var(last_irq_sum) = sum;
+		__this_cpu_write(last_irq_sum, sum);
 		__this_cpu_write(alert_counter, 0);
 	}
-	if (__get_cpu_var(wd_enabled)) {
+	if (__this_cpu_read(wd_enabled)) {
 		pcr_ops->write_pic(0, pcr_ops->nmi_picl_value(nmi_hz));
 		pcr_ops->write_pcr(0, pcr_ops->pcr_nmi_enable);
 	}
@@ -166,7 +166,7 @@ static void report_broken_nmi(int cpu, i
 void stop_nmi_watchdog(void *unused)
 {
 	pcr_ops->write_pcr(0, pcr_ops->pcr_nmi_disable);
-	__get_cpu_var(wd_enabled) = 0;
+	__this_cpu_write(wd_enabled, 0);
 	atomic_dec(&nmi_active);
 }
 
@@ -219,7 +219,7 @@ error:
 
 void start_nmi_watchdog(void *unused)
 {
-	__get_cpu_var(wd_enabled) = 1;
+	__this_cpu_write(wd_enabled, 1);
 	atomic_inc(&nmi_active);
 
 	pcr_ops->write_pcr(0, pcr_ops->pcr_nmi_disable);
@@ -230,7 +230,7 @@ void start_nmi_watchdog(void *unused)
 
 static void nmi_adjust_hz_one(void *unused)
 {
-	if (!__get_cpu_var(wd_enabled))
+	if (!__this_cpu_read(wd_enabled))
 		return;
 
 	pcr_ops->write_pcr(0, pcr_ops->pcr_nmi_disable);
Index: linux/arch/sparc/kernel/pci_sun4v.c
===================================================================
--- linux.orig/arch/sparc/kernel/pci_sun4v.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/pci_sun4v.c	2013-08-22 14:37:15.942964723 -0500
@@ -48,7 +48,7 @@ static int iommu_batch_initialized;
 /* Interrupts must be disabled.  */
 static inline void iommu_batch_start(struct device *dev, unsigned long prot, unsigned long entry)
 {
-	struct iommu_batch *p = &__get_cpu_var(iommu_batch);
+	struct iommu_batch *p = this_cpu_ptr(&iommu_batch);
 
 	p->dev		= dev;
 	p->prot		= prot;
@@ -94,7 +94,7 @@ static long iommu_batch_flush(struct iom
 
 static inline void iommu_batch_new_entry(unsigned long entry)
 {
-	struct iommu_batch *p = &__get_cpu_var(iommu_batch);
+	struct iommu_batch *p = this_cpu_ptr(&iommu_batch);
 
 	if (p->entry + p->npages == entry)
 		return;
@@ -106,7 +106,7 @@ static inline void iommu_batch_new_entry
 /* Interrupts must be disabled.  */
 static inline long iommu_batch_add(u64 phys_page)
 {
-	struct iommu_batch *p = &__get_cpu_var(iommu_batch);
+	struct iommu_batch *p = this_cpu_ptr(&iommu_batch);
 
 	BUG_ON(p->npages >= PGLIST_NENTS);
 
@@ -120,7 +120,7 @@ static inline long iommu_batch_add(u64 p
 /* Interrupts must be disabled.  */
 static inline long iommu_batch_end(void)
 {
-	struct iommu_batch *p = &__get_cpu_var(iommu_batch);
+	struct iommu_batch *p = this_cpu_ptr(&iommu_batch);
 
 	BUG_ON(p->npages >= PGLIST_NENTS);
 
Index: linux/arch/sparc/kernel/perf_event.c
===================================================================
--- linux.orig/arch/sparc/kernel/perf_event.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/perf_event.c	2013-08-22 14:37:15.946964681 -0500
@@ -1013,7 +1013,7 @@ static void update_pcrs_for_enable(struc
 
 static void sparc_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int i;
 
 	if (cpuc->enabled)
@@ -1031,7 +1031,7 @@ static void sparc_pmu_enable(struct pmu
 
 static void sparc_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int i;
 
 	if (!cpuc->enabled)
@@ -1065,7 +1065,7 @@ static int active_event_index(struct cpu
 
 static void sparc_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx = active_event_index(cpuc, event);
 
 	if (flags & PERF_EF_RELOAD) {
@@ -1080,7 +1080,7 @@ static void sparc_pmu_start(struct perf_
 
 static void sparc_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx = active_event_index(cpuc, event);
 
 	if (!(event->hw.state & PERF_HES_STOPPED)) {
@@ -1096,7 +1096,7 @@ static void sparc_pmu_stop(struct perf_e
 
 static void sparc_pmu_del(struct perf_event *event, int _flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	unsigned long flags;
 	int i;
 
@@ -1133,7 +1133,7 @@ static void sparc_pmu_del(struct perf_ev
 
 static void sparc_pmu_read(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx = active_event_index(cpuc, event);
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -1145,7 +1145,7 @@ static DEFINE_MUTEX(pmc_grab_mutex);
 
 static void perf_stop_nmi_watchdog(void *unused)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int i;
 
 	stop_nmi_watchdog(NULL);
@@ -1356,7 +1356,7 @@ static int collect_events(struct perf_ev
 
 static int sparc_pmu_add(struct perf_event *event, int ef_flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int n0, ret = -EAGAIN;
 	unsigned long flags;
 
@@ -1498,7 +1498,7 @@ static int sparc_pmu_event_init(struct p
  */
 static void sparc_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	perf_pmu_disable(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
@@ -1511,7 +1511,7 @@ static void sparc_pmu_start_txn(struct p
  */
 static void sparc_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
 	perf_pmu_enable(pmu);
@@ -1524,13 +1524,13 @@ static void sparc_pmu_cancel_txn(struct
  */
 static int sparc_pmu_commit_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int n;
 
 	if (!sparc_pmu)
 		return -EINVAL;
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 	n = cpuc->n_events;
 	if (check_excludes(cpuc->event, 0, n))
 		return -EINVAL;
@@ -1601,7 +1601,7 @@ static int __kprobes perf_event_nmi_hand
 
 	regs = args->regs;
 
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	/* If the PMU has the TOE IRQ enable bits, we need to do a
 	 * dummy write to the %pcr to clear the overflow bits and thus
Index: linux/arch/sparc/kernel/sun4d_smp.c
===================================================================
--- linux.orig/arch/sparc/kernel/sun4d_smp.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/sun4d_smp.c	2013-08-22 14:37:15.946964681 -0500
@@ -204,7 +204,7 @@ static void __init smp4d_ipi_init(void)
 
 void sun4d_ipi_interrupt(void)
 {
-	struct sun4d_ipi_work *work = &__get_cpu_var(sun4d_ipi_work);
+	struct sun4d_ipi_work *work = this_cpu_ptr(&sun4d_ipi_work);
 
 	if (work->single) {
 		work->single = 0;
Index: linux/arch/sparc/kernel/time_64.c
===================================================================
--- linux.orig/arch/sparc/kernel/time_64.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/kernel/time_64.c	2013-08-22 14:37:15.946964681 -0500
@@ -766,7 +766,7 @@ void setup_sparc64_timer(void)
 			     : /* no outputs */
 			     : "r" (pstate));
 
-	sevt = &__get_cpu_var(sparc64_events);
+	sevt = this_cpu_ptr(&sparc64_events);
 
 	memcpy(sevt, &sparc64_clockevent, sizeof(*sevt));
 	sevt->cpumask = cpumask_of(smp_processor_id());
Index: linux/arch/sparc/mm/tlb.c
===================================================================
--- linux.orig/arch/sparc/mm/tlb.c	2013-08-22 14:34:54.000000000 -0500
+++ linux/arch/sparc/mm/tlb.c	2013-08-22 14:37:15.946964681 -0500
@@ -53,14 +53,14 @@ out:
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = &__get_cpu_var(tlb_batch);
+	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
 
 	tb->active = 1;
 }
 
 void arch_leave_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = &__get_cpu_var(tlb_batch);
+	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();

