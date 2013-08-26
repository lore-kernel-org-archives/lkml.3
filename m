Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3HZUy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:54:56 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:44932 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab3HZUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:54:09 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 16:54:09 EDT
Message-Id: <00000140bc5f0c7a-f532a36c-7ab9-4624-9857-34a0e68ac4b3-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:40 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 17/31] mips: Replace __get_cpu_var uses
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

Index: linux/arch/mips/include/asm/fpu_emulator.h
===================================================================
--- linux.orig/arch/mips/include/asm/fpu_emulator.h	2013-08-22 14:18:23.138568266 -0500
+++ linux/arch/mips/include/asm/fpu_emulator.h	2013-08-22 14:18:23.130568348 -0500
@@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator
 #define MIPS_FPU_EMU_INC_STATS(M)					\
 do {									\
 	preempt_disable();						\
-	__local_inc(&__get_cpu_var(fpuemustats).M);			\
+	__this_cpu_inc(fpuemustats.M);					\
 	preempt_enable();						\
 } while (0)
 
Index: linux/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- linux.orig/arch/mips/cavium-octeon/octeon-irq.c	2013-08-22 14:17:32.000000000 -0500
+++ linux/arch/mips/cavium-octeon/octeon-irq.c	2013-08-22 14:18:54.210250887 -0500
@@ -264,13 +264,13 @@ static void octeon_irq_ciu_enable_local(
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
@@ -279,7 +279,7 @@ static void octeon_irq_ciu_enable_local(
 		wmb();
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
-		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
 		__set_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -296,13 +296,13 @@ static void octeon_irq_ciu_disable_local
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
@@ -311,7 +311,7 @@ static void octeon_irq_ciu_disable_local
 		wmb();
 		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
 	} else {
-		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		pen = this_cpu_ptr(&octeon_irq_ciu1_en_mirror);
 		__clear_bit(cd.s.bit, pen);
 		/*
 		 * Must be visible to octeon_irq_ip{2,3}_ciu() before
@@ -431,11 +431,11 @@ static void octeon_irq_ciu_enable_local_
 
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
@@ -450,11 +450,11 @@ static void octeon_irq_ciu_disable_local
 
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
@@ -1063,7 +1063,7 @@ static void octeon_irq_ip2_ciu(void)
 	const unsigned long core_id = cvmx_get_core_num();
 	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INTX_SUM0(core_id * 2));
 
-	ciu_sum &= __get_cpu_var(octeon_irq_ciu0_en_mirror);
+	ciu_sum &= __this_cpu_read(octeon_irq_ciu0_en_mirror);
 	if (likely(ciu_sum)) {
 		int bit = fls64(ciu_sum) - 1;
 		int irq = octeon_irq_ciu_to_irq[0][bit];
@@ -1080,7 +1080,7 @@ static void octeon_irq_ip3_ciu(void)
 {
 	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INT_SUM1);
 
-	ciu_sum &= __get_cpu_var(octeon_irq_ciu1_en_mirror);
+	ciu_sum &= __this_cpu_read(octeon_irq_ciu1_en_mirror);
 	if (likely(ciu_sum)) {
 		int bit = fls64(ciu_sum) - 1;
 		int irq = octeon_irq_ciu_to_irq[1][bit];
@@ -1129,10 +1129,10 @@ static void octeon_irq_init_ciu_percpu(v
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
--- linux.orig/arch/mips/kernel/kprobes.c	2013-08-22 14:17:32.000000000 -0500
+++ linux/arch/mips/kernel/kprobes.c	2013-08-22 14:18:54.210250887 -0500
@@ -224,7 +224,7 @@ static void save_previous_kprobe(struct
 
 static void restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_old_SR = kcb->prev_kprobe.old_SR;
 	kcb->kprobe_saved_SR = kcb->prev_kprobe.saved_SR;
@@ -234,7 +234,7 @@ static void restore_previous_kprobe(stru
 static void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_SR = kcb->kprobe_old_SR = (regs->cp0_status & ST0_IE);
 	kcb->kprobe_saved_epc = regs->cp0_epc;
 }
@@ -385,7 +385,7 @@ static int __kprobes kprobe_handler(stru
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
--- linux.orig/arch/mips/kernel/perf_event_mipsxx.c	2013-08-22 14:17:32.000000000 -0500
+++ linux/arch/mips/kernel/perf_event_mipsxx.c	2013-08-22 14:18:54.210250887 -0500
@@ -340,7 +340,7 @@ static int mipsxx_pmu_alloc_counter(stru
 
 static void mipsxx_pmu_enable_event(struct hw_perf_event *evt, int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
 
@@ -360,7 +360,7 @@ static void mipsxx_pmu_enable_event(stru
 
 static void mipsxx_pmu_disable_event(int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	unsigned long flags;
 
 	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
@@ -460,7 +460,7 @@ static void mipspmu_stop(struct perf_eve
 
 static int mipspmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx;
 	int err = 0;
@@ -496,7 +496,7 @@ out:
 
 static void mipspmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -1270,7 +1270,7 @@ static int __hw_perf_event_init(struct p
 
 static void pause_local_counters(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int ctr = mipspmu.num_counters;
 	unsigned long flags;
 
@@ -1286,7 +1286,7 @@ static void pause_local_counters(void)
 
 static void resume_local_counters(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int ctr = mipspmu.num_counters;
 
 	do {
@@ -1297,7 +1297,7 @@ static void resume_local_counters(void)
 
 static int mipsxx_pmu_handle_shared_irq(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_sample_data data;
 	unsigned int counters = mipspmu.num_counters;
 	u64 counter;
Index: linux/arch/mips/kernel/smp-bmips.c
===================================================================
--- linux.orig/arch/mips/kernel/smp-bmips.c	2013-08-22 14:17:32.000000000 -0500
+++ linux/arch/mips/kernel/smp-bmips.c	2013-08-22 14:18:54.214250846 -0500
@@ -304,7 +304,7 @@ static irqreturn_t bmips_ipi_interrupt(i
 	int action, cpu = irq - IPI0_IRQ;
 
 	spin_lock_irqsave(&ipi_lock, flags);
-	action = __get_cpu_var(ipi_action_mask);
+	action = __this_cpu_read(ipi_action_mask);
 	per_cpu(ipi_action_mask, cpu) = 0;
 	clear_c0_cause(cpu ? C_SW1 : C_SW0);
 	spin_unlock_irqrestore(&ipi_lock, flags);

