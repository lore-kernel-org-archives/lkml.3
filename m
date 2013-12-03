Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3LCXlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:41:19 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:42375 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755668Ab3LCXjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:11 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 18:38:04 EST
Message-Id: <20131203233303.972122408@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:33:08 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 36/41] blackfin: Replace __get_cpu_var uses
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_blackfin
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


CC: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/blackfin/include/asm/ipipe.h
===================================================================
--- linux.orig/arch/blackfin/include/asm/ipipe.h	2013-12-02 16:08:00.474336781 -0600
+++ linux/arch/blackfin/include/asm/ipipe.h	2013-12-02 16:08:00.474336781 -0600
@@ -157,7 +157,7 @@ static inline unsigned long __ipipe_ffnz
 }
 
 #define __ipipe_do_root_xirq(ipd, irq)					\
-	((ipd)->irqs[irq].handler(irq, &__raw_get_cpu_var(__ipipe_tick_regs)))
+	((ipd)->irqs[irq].handler(irq, raw_cpu_ptr(&__ipipe_tick_regs)))
 
 #define __ipipe_run_irqtail(irq)  /* Must be a macro */			\
 	do {								\
Index: linux/arch/blackfin/kernel/perf_event.c
===================================================================
--- linux.orig/arch/blackfin/kernel/perf_event.c	2013-12-02 16:08:00.474336781 -0600
+++ linux/arch/blackfin/kernel/perf_event.c	2013-12-02 16:08:00.474336781 -0600
@@ -300,7 +300,7 @@ again:
 
 static void bfin_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -318,7 +318,7 @@ static void bfin_pmu_stop(struct perf_ev
 
 static void bfin_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -335,7 +335,7 @@ static void bfin_pmu_start(struct perf_e
 
 static void bfin_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	bfin_pmu_stop(event, PERF_EF_UPDATE);
 	__clear_bit(event->hw.idx, cpuc->used_mask);
@@ -345,7 +345,7 @@ static void bfin_pmu_del(struct perf_eve
 
 static int bfin_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	int ret = -EAGAIN;
@@ -429,7 +429,7 @@ static int bfin_pmu_event_init(struct pe
 
 static void bfin_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	int i;
Index: linux/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux.orig/arch/blackfin/mach-common/ints-priority.c	2013-12-02 16:08:00.474336781 -0600
+++ linux/arch/blackfin/mach-common/ints-priority.c	2013-12-02 16:08:00.474336781 -0600
@@ -1312,12 +1312,12 @@ asmlinkage int __ipipe_grab_irq(int vec,
 		bfin_write_TIMER_STATUS(1); /* Latch TIMIL0 */
 #endif
 		/* This is basically what we need from the register frame. */
-		__raw_get_cpu_var(__ipipe_tick_regs).ipend = regs->ipend;
-		__raw_get_cpu_var(__ipipe_tick_regs).pc = regs->pc;
+		__this_cpu_write(__ipipe_tick_regs.ipend, regs->ipend);
+		__this_cpu_write(__ipipe_tick_regs.pc, regs->pc);
 		if (this_domain != ipipe_root_domain)
-			__raw_get_cpu_var(__ipipe_tick_regs).ipend &= ~0x10;
+			__this_cpu_and(__ipipe_tick_regs.ipend, ~0x10);
 		else
-			__raw_get_cpu_var(__ipipe_tick_regs).ipend |= 0x10;
+			__this_cpu_or(__ipipe_tick_regs.ipend, 0x10);
 	}
 
 	/*
Index: linux/arch/blackfin/mach-common/smp.c
===================================================================
--- linux.orig/arch/blackfin/mach-common/smp.c	2013-12-02 16:08:00.474336781 -0600
+++ linux/arch/blackfin/mach-common/smp.c	2013-12-02 16:08:00.474336781 -0600
@@ -147,7 +147,7 @@ static irqreturn_t ipi_handler_int1(int
 	platform_clear_ipi(cpu, IRQ_SUPPLE_1);
 
 	smp_rmb();
-	bfin_ipi_data = &__get_cpu_var(bfin_ipi);
+	bfin_ipi_data = this_cpu_ptr(&bfin_ipi);
 	while ((pending = atomic_xchg(&bfin_ipi_data->bits, 0)) != 0) {
 		msg = 0;
 		do {

