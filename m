Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaAQPVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:21:23 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:46546 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbaAQPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:18:46 -0500
Message-Id: <20140117151837.507804830@linux.com>
Date: Fri, 17 Jan 2014 09:18:42 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 30/41] mips: Replace __get_cpu_var uses
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_mips
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

	__this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	__this_cpu_inc(y)


Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- linux.orig/arch/mips/cavium-octeon/octeon-irq.c	2013-12-20 11:45:14.113574366 -0600
+++ linux/arch/mips/cavium-octeon/octeon-irq.c	2013-12-20 11:45:14.103574558 -0600
@@ -264,13 +264,13 @@
 	unsigned long *pen;
 	unsigned long flags;
 	union octeon_ciu_chip_data cd;
-	raw_spinlock_t *lock = &__get_cpu_var(octeon_irq_ciu_spinlock);
+	raw_spinlock_t *lock = this_cpu_ptr(&octeon_irq_ciu_spinlock);
 
 	cd.p = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
 	if (cd.s.line == 0) {
-		pen = &__get_cpu_var(octeon_irq_ciu0_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu0_en_mirror);
 		__set_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -279,7 +279,7 @@
 		wmb();
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
-		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
 		__set_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -296,13 +296,13 @@
 	unsigned long *pen;
 	unsigned long flags;
 	union octeon_ciu_chip_data cd;
-	raw_spinlock_t *lock = &__get_cpu_var(octeon_irq_ciu_spinlock);
+	raw_spinlock_t *lock = this_cpu_ptr(&octeon_irq_ciu_spinlock);
 
 	cd.p = irq_data_get_irq_chip_data(data);
 
 	raw_spin_lock_irqsave(lock, flags);
 	if (cd.s.line == 0) {
-		pen = &__get_cpu_var(octeon_irq_ciu0_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu0_en_mirror);
 		__clear_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -311,7 +311,7 @@
 		wmb();
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
-		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
 		__clear_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -431,11 +431,11 @@
 
 	if (cd.s.line == 0) {
 		int index = cvmx_get_core_num() * 2;
-		set_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu0_en_mirror));
+		set_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 	} else {
 		int index = cvmx_get_core_num() * 2 + 1;
-		set_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu1_en_mirror));
+		set_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 	}
 }
@@ -450,11 +450,11 @@
 
 	if (cd.s.line == 0) {
 		int index = cvmx_get_core_num() * 2;
-		clear_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu0_en_mirror));
+		clear_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu0_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 	} else {
 		int index = cvmx_get_core_num() * 2 + 1;
-		clear_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu1_en_mirror));
+		clear_bit(cd.s.bit, this_cpu_ptr(&octeon_irq_ciu1_en_mirror));
 		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
 	}
 }
@@ -1063,7 +1063,7 @@
 	const unsigned long core_id = cvmx_get_core_num();
 	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INTX_SUM0(core_id * 2));
 
-	ciu_sum &= __get_cpu_var(octeon_irq_ciu0_en_mirror);
+	ciu_sum &= __this_cpu_read(octeon_irq_ciu0_en_mirror);
 	if (likely(ciu_sum)) {
 		int bit = fls64(ciu_sum) - 1;
 		int irq = octeon_irq_ciu_to_irq[0][bit];
@@ -1080,7 +1080,7 @@
 {
 	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INT_SUM1);
 
-	ciu_sum &= __get_cpu_var(octeon_irq_ciu1_en_mirror);
+	ciu_sum &= __this_cpu_read(octeon_irq_ciu1_en_mirror);
 	if (likely(ciu_sum)) {
 		int bit = fls64(ciu_sum) - 1;
 		int irq = octeon_irq_ciu_to_irq[1][bit];
@@ -1129,10 +1129,10 @@
 	int coreid = cvmx_get_core_num();
 
 
-	__get_cpu_var(octeon_irq_ciu0_en_mirror) = 0;
-	__get_cpu_var(octeon_irq_ciu1_en_mirror) = 0;
+	__this_cpu_write(octeon_irq_ciu0_en_mirror, 0);
+	__this_cpu_write(octeon_irq_ciu1_en_mirror, 0);
 	wmb();
-	raw_spin_lock_init(&__get_cpu_var(octeon_irq_ciu_spinlock));
+	raw_spin_lock_init(this_cpu_ptr(&octeon_irq_ciu_spinlock));
 	/*
 	 * Disable All CIU Interrupts. The ones we need will be
 	 * enabled later.  Read the SUM register so we know the write
Index: linux/arch/mips/kernel/kprobes.c
===================================================================
--- linux.orig/arch/mips/kernel/kprobes.c	2013-12-20 11:45:14.113574366 -0600
+++ linux/arch/mips/kernel/kprobes.c	2013-12-20 11:45:14.103574558 -0600
@@ -224,7 +224,7 @@
 
 static void restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_old_SR = kcb->prev_kprobe.old_SR;
 	kcb->kprobe_saved_SR = kcb->prev_kprobe.saved_SR;
@@ -234,7 +234,7 @@
 static void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_SR = kcb->kprobe_old_SR = (regs->cp0_status & ST0_IE);
 	kcb->kprobe_saved_epc = regs->cp0_epc;
 }
@@ -385,7 +385,7 @@
 				ret = 1;
 				goto no_kprobe;
 			}
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs))
 				goto ss_probe;
 		}
Index: linux/arch/mips/kernel/perf_event_mipsxx.c
===================================================================
--- linux.orig/arch/mips/kernel/perf_event_mipsxx.c	2013-12-20 11:45:14.113574366 -0600
+++ linux/arch/mips/kernel/perf_event_mipsxx.c	2013-12-20 11:45:14.103574558 -0600
@@ -340,7 +340,7 @@
 
 static void mipsxx_pmu_enable_event(struct hw_perf_event *evt, int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
 
@@ -360,7 +360,7 @@
 
 static void mipsxx_pmu_disable_event(int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	unsigned long flags;
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
@@ -460,7 +460,7 @@
 
 static int mipspmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx;
 	int err = 0;
@@ -496,7 +496,7 @@
 
 static void mipspmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -1270,7 +1270,7 @@
 
 static void pause_local_counters(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int ctr = mipspmu.num_counters;
 	unsigned long flags;
 
@@ -1286,7 +1286,7 @@
 
 static void resume_local_counters(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int ctr = mipspmu.num_counters;
 
 	do {
@@ -1297,7 +1297,7 @@
 
 static int mipsxx_pmu_handle_shared_irq(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_sample_data data;
 	unsigned int counters = mipspmu.num_counters;
 	u64 counter;
Index: linux/arch/mips/kernel/smp-bmips.c
===================================================================
--- linux.orig/arch/mips/kernel/smp-bmips.c	2013-12-20 11:45:14.113574366 -0600
+++ linux/arch/mips/kernel/smp-bmips.c	2013-12-20 11:45:14.103574558 -0600
@@ -304,7 +304,7 @@
 	int action, cpu = irq - IPI0_IRQ;
 
 	spin_lock_irqsave(&ipi_lock, flags);
-	action = __get_cpu_var(ipi_action_mask);
+	action = __this_cpu_read(ipi_action_mask);
 	per_cpu(ipi_action_mask, cpu) = 0;
 	clear_c0_cause(cpu ? C_SW1 : C_SW0);
 	spin_unlock_irqrestore(&ipi_lock, flags);

