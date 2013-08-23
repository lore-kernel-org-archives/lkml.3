Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3HWTLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:11:50 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:28279 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab3HWTLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:11:49 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:11:48 EDT
Message-Id: <00000140ac8e312e-2aaf6eb0-cd09-4e71-8986-4e595dc079aa-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:19 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 08/16] mips: __get_cpu_var conversion
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

