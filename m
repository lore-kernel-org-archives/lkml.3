Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3HWTIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:08:30 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:48814 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab3HWTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:08:29 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:08:28 EDT
Message-ID: <00000140ac8e32d2-969b19c7-553b-41b3-9415-d99f927cb3ab-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:17 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 15/16] misc arches __get_cpu_var conversion
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/alpha/kernel/perf_event.c
===================================================================
--- linux.orig/arch/alpha/kernel/perf_event.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/alpha/kernel/perf_event.c	2013-08-22 14:57:32.570610889 -0500
@@ -422,7 +422,7 @@ static void maybe_change_configuration(s
  */
 static int alpha_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int n0;
 	int ret;
@@ -474,7 +474,7 @@ static int alpha_pmu_add(struct perf_eve
  */
 static void alpha_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long irq_flags;
 	int j;
@@ -522,7 +522,7 @@ static void alpha_pmu_read(struct perf_e
 static void alpha_pmu_stop(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!(hwc->state & PERF_HES_STOPPED)) {
 		cpuc->idx_mask &= ~(1UL<<hwc->idx);
@@ -542,7 +542,7 @@ static void alpha_pmu_stop(struct perf_e
 static void alpha_pmu_start(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
 		return;
@@ -713,7 +713,7 @@ static int alpha_pmu_event_init(struct p
  */
 static void alpha_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (cpuc->enabled)
 		return;
@@ -739,7 +739,7 @@ static void alpha_pmu_enable(struct pmu
 
 static void alpha_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	if (!cpuc->enabled)
 		return;
@@ -804,7 +804,7 @@ static void alpha_perf_event_irq_handler
 	int idx, j;
 
 	__this_cpu_inc(irq_pmi_count);
-	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	/* Completely counting through the PMC's period to trigger a new PMC
 	 * overflow interrupt while in this interrupt routine is utterly
Index: linux/arch/alpha/kernel/time.c
===================================================================
--- linux.orig/arch/alpha/kernel/time.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/alpha/kernel/time.c	2013-08-22 14:57:32.570610889 -0500
@@ -86,9 +86,9 @@ unsigned long est_cycle_freq;
 
 DEFINE_PER_CPU(u8, irq_work_pending);
 
-#define set_irq_work_pending_flag()  __get_cpu_var(irq_work_pending) = 1
-#define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
-#define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
+#define set_irq_work_pending_flag()  __this_cpu_write(irq_work_pending, 1)
+#define test_irq_work_pending()      __this_cpu_read(irq_work_pending)
+#define clear_irq_work_pending()     __this_cpu_writeirq_work_pending, 0)
 
 void arch_irq_work_raise(void)
 {
Index: linux/arch/arc/kernel/kprobes.c
===================================================================
--- linux.orig/arch/arc/kernel/kprobes.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/arc/kernel/kprobes.c	2013-08-22 14:57:32.570610889 -0500
@@ -87,13 +87,13 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
 static inline void __kprobes set_current_kprobe(struct kprobe *p)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 static void __kprobes resume_execution(struct kprobe *p, unsigned long addr,
@@ -237,7 +237,7 @@ int __kprobes arc_kprobe_handler(unsigne
 
 		return 1;
 	} else if (kprobe_running()) {
-		p = __get_cpu_var(current_kprobe);
+		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			setup_singlestep(p, regs);
 			kcb->kprobe_status = KPROBE_HIT_SS;
Index: linux/arch/arc/kernel/time.c
===================================================================
--- linux.orig/arch/arc/kernel/time.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/arc/kernel/time.c	2013-08-22 14:57:32.570610889 -0500
@@ -206,7 +206,7 @@ static DEFINE_PER_CPU(struct clock_event
 
 static irqreturn_t timer_irq_handler(int irq, void *dev_id)
 {
-	struct clock_event_device *clk = &__get_cpu_var(arc_clockevent_device);
+	struct clock_event_device *clk = this_cpu_ptr(&arc_clockevent_device);
 
 	arc_timer_event_ack(clk->mode == CLOCK_EVT_MODE_PERIODIC);
 	clk->event_handler(clk);
Index: linux/arch/avr32/kernel/kprobes.c
===================================================================
--- linux.orig/arch/avr32/kernel/kprobes.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/avr32/kernel/kprobes.c	2013-08-22 14:57:32.570610889 -0500
@@ -104,7 +104,7 @@ static void __kprobes resume_execution(s
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)
Index: linux/arch/blackfin/include/asm/ipipe.h
===================================================================
--- linux.orig/arch/blackfin/include/asm/ipipe.h	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/blackfin/include/asm/ipipe.h	2013-08-22 14:57:32.570610889 -0500
@@ -157,7 +157,7 @@ static inline unsigned long __ipipe_ffnz
 }
 
 #define __ipipe_do_root_xirq(ipd, irq)					\
-	((ipd)->irqs[irq].handler(irq, &__raw_get_cpu_var(__ipipe_tick_regs)))
+	((ipd)->irqs[irq].handler(irq, __this_cpu_ptr(&__ipipe_tick_regs)))
 
 #define __ipipe_run_irqtail(irq)  /* Must be a macro */			\
 	do {								\
Index: linux/arch/blackfin/kernel/perf_event.c
===================================================================
--- linux.orig/arch/blackfin/kernel/perf_event.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/blackfin/kernel/perf_event.c	2013-08-22 14:57:32.570610889 -0500
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
Index: linux/arch/blackfin/mach-common/smp.c
===================================================================
--- linux.orig/arch/blackfin/mach-common/smp.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/blackfin/mach-common/smp.c	2013-08-22 14:57:32.570610889 -0500
@@ -146,7 +146,7 @@ static irqreturn_t ipi_handler_int1(int
 
 	platform_clear_ipi(cpu, IRQ_SUPPLE_1);
 
-	bfin_ipi_data = &__get_cpu_var(bfin_ipi);
+	bfin_ipi_data = this_cpu_ptr(&bfin_ipi);
 	while ((pending = atomic_xchg(&bfin_ipi_data->bits, 0)) != 0) {
 		msg = 0;
 		do {
Index: linux/arch/metag/kernel/perf/perf_event.c
===================================================================
--- linux.orig/arch/metag/kernel/perf/perf_event.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/metag/kernel/perf/perf_event.c	2013-08-22 14:57:32.570610889 -0500
@@ -258,7 +258,7 @@ int metag_pmu_event_set_period(struct pe
 
 static void metag_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -306,7 +306,7 @@ static void metag_pmu_stop(struct perf_e
 
 static int metag_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = 0, ret = 0;
 
@@ -348,7 +348,7 @@ out:
 
 static void metag_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -607,7 +607,7 @@ static int _hw_perf_event_init(struct pe
 
 static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	unsigned int config = event->config;
 	unsigned int tmp = config & 0xf0;
 	unsigned long flags;
@@ -680,7 +680,7 @@ unlock:
 
 static void metag_pmu_disable_counter(struct hw_perf_event *event, int idx)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	unsigned int tmp = 0;
 	unsigned long flags;
 
@@ -728,7 +728,7 @@ out:
 
 static void metag_pmu_write_counter(int idx, u32 val)
 {
-	struct cpu_hw_events *events = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *events = this_cpu_ptr(&cpu_hw_events);
 	u32 tmp = 0;
 	unsigned long flags;
 
@@ -761,7 +761,7 @@ static int metag_pmu_event_map(int idx)
 static irqreturn_t metag_pmu_counter_overflow(int irq, void *dev)
 {
 	int idx = (int)dev;
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct perf_event *event = cpuhw->events[idx];
 	struct hw_perf_event *hwc = &event->hw;
 	struct pt_regs *regs = get_irq_regs();
Index: linux/arch/parisc/lib/memcpy.c
===================================================================
--- linux.orig/arch/parisc/lib/memcpy.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/parisc/lib/memcpy.c	2013-08-22 14:57:32.570610889 -0500
@@ -470,7 +470,7 @@ static unsigned long pa_memcpy(void *dst
 		return 0;
 
 	/* if a load or store fault occured we can get the faulty addr */
-	d = &__get_cpu_var(exception_data);
+	d = this_cpu_ptr(&exception_data);
 	fault_addr = d->fault_addr;
 
 	/* error in load or store? */
Index: linux/arch/parisc/mm/fault.c
===================================================================
--- linux.orig/arch/parisc/mm/fault.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/parisc/mm/fault.c	2013-08-22 14:57:32.570610889 -0500
@@ -145,7 +145,7 @@ int fixup_exception(struct pt_regs *regs
 	fix = search_exception_tables(regs->iaoq[0]);
 	if (fix) {
 		struct exception_data *d;
-		d = &__get_cpu_var(exception_data);
+		d = this_cpu_ptr(&exception_data);
 		d->fault_ip = regs->iaoq[0];
 		d->fault_space = regs->isr;
 		d->fault_addr = regs->ior;
Index: linux/arch/sh/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/sh/kernel/hw_breakpoint.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/sh/kernel/hw_breakpoint.c	2013-08-22 14:57:32.570610889 -0500
@@ -52,7 +52,7 @@ int arch_install_hw_breakpoint(struct pe
 	int i;
 
 	for (i = 0; i < sh_ubc->num_events; i++) {
-		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
 
 		if (!*slot) {
 			*slot = bp;
@@ -84,7 +84,7 @@ void arch_uninstall_hw_breakpoint(struct
 	int i;
 
 	for (i = 0; i < sh_ubc->num_events; i++) {
-		struct perf_event **slot = &__get_cpu_var(bp_per_reg[i]);
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
 
 		if (*slot == bp) {
 			*slot = NULL;
Index: linux/arch/sh/kernel/kprobes.c
===================================================================
--- linux.orig/arch/sh/kernel/kprobes.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/sh/kernel/kprobes.c	2013-08-22 14:57:32.570610889 -0500
@@ -102,7 +102,7 @@ int __kprobes kprobe_handle_illslot(unsi
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
-	struct kprobe *saved = &__get_cpu_var(saved_next_opcode);
+	struct kprobe *saved = this_cpu_ptr(&saved_next_opcode);
 
 	if (saved->addr) {
 		arch_disarm_kprobe(p);
@@ -111,7 +111,7 @@ void __kprobes arch_remove_kprobe(struct
 		saved->addr = NULL;
 		saved->opcode = 0;
 
-		saved = &__get_cpu_var(saved_next_opcode2);
+		saved = this_cpu_ptr(&saved_next_opcode2);
 		if (saved->addr) {
 			arch_disarm_kprobe(saved);
 
@@ -129,14 +129,14 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 					 struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 /*
@@ -146,15 +146,15 @@ static void __kprobes set_current_kprobe
  */
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
-	__get_cpu_var(saved_current_opcode).addr = (kprobe_opcode_t *)regs->pc;
+	__this_cpu_write(saved_current_opcode.addr, (kprobe_opcode_t *)regs->pc);
 
 	if (p != NULL) {
 		struct kprobe *op1, *op2;
 
 		arch_disarm_kprobe(p);
 
-		op1 = &__get_cpu_var(saved_next_opcode);
-		op2 = &__get_cpu_var(saved_next_opcode2);
+		op1 = this_cpu_ptr(&saved_next_opcode);
+		op2 = this_cpu_ptr(&saved_next_opcode2);
 
 		if (OPCODE_JSR(p->opcode) || OPCODE_JMP(p->opcode)) {
 			unsigned int reg_nr = ((p->opcode >> 8) & 0x000F);
@@ -249,7 +249,7 @@ static int __kprobes kprobe_handler(stru
 			kcb->kprobe_status = KPROBE_REENTER;
 			return 1;
 		} else {
-			p = __get_cpu_var(current_kprobe);
+			p = __this_cpu_read(current_kprobe);
 			if (p->break_handler && p->break_handler(p, regs)) {
 				goto ss_probe;
 			}
@@ -336,9 +336,9 @@ int __kprobes trampoline_probe_handler(s
 			continue;
 
 		if (ri->rp && ri->rp->handler) {
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			__this_cpu_write(current_kprobe, &ri->rp->kp);
 			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
+			__this_cpu_write(current_kprobe, NULL);
 		}
 
 		orig_ret_address = (unsigned long)ri->ret_addr;
@@ -383,19 +383,19 @@ static int __kprobes post_kprobe_handler
 		cur->post_handler(cur, regs, 0);
 	}
 
-	p = &__get_cpu_var(saved_next_opcode);
+	p = this_cpu_ptr(&saved_next_opcode);
 	if (p->addr) {
 		arch_disarm_kprobe(p);
 		p->addr = NULL;
 		p->opcode = 0;
 
-		addr = __get_cpu_var(saved_current_opcode).addr;
-		__get_cpu_var(saved_current_opcode).addr = NULL;
+		addr = __this_cpu_read(saved_current_opcode).addr;
+		__this_cpu_write(saved_current_opcode.addr, NULL);
 
 		p = get_kprobe(addr);
 		arch_arm_kprobe(p);
 
-		p = &__get_cpu_var(saved_next_opcode2);
+		p = this_cpu_ptr(&saved_next_opcode2);
 		if (p->addr) {
 			arch_disarm_kprobe(p);
 			p->addr = NULL;
@@ -511,7 +511,7 @@ int __kprobes kprobe_exceptions_notify(s
 				if (kprobe_handler(args->regs)) {
 					ret = NOTIFY_STOP;
 				} else {
-					p = __get_cpu_var(current_kprobe);
+					p = __this_cpu_read(current_kprobe);
 					if (p->break_handler &&
 					    p->break_handler(p, args->regs))
 						ret = NOTIFY_STOP;
Index: linux/arch/sh/kernel/localtimer.c
===================================================================
--- linux.orig/arch/sh/kernel/localtimer.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/sh/kernel/localtimer.c	2013-08-22 14:57:32.570610889 -0500
@@ -32,7 +32,7 @@ static DEFINE_PER_CPU(struct clock_event
  */
 void local_timer_interrupt(void)
 {
-	struct clock_event_device *clk = &__get_cpu_var(local_clockevent);
+	struct clock_event_device *clk = this_cpu_ptr(&local_clockevent);
 
 	irq_enter();
 	clk->event_handler(clk);
Index: linux/arch/sh/kernel/perf_event.c
===================================================================
--- linux.orig/arch/sh/kernel/perf_event.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/sh/kernel/perf_event.c	2013-08-22 14:57:32.570610889 -0500
@@ -227,7 +227,7 @@ again:
 
 static void sh_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -245,7 +245,7 @@ static void sh_pmu_stop(struct perf_even
 
 static void sh_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
@@ -262,7 +262,7 @@ static void sh_pmu_start(struct perf_eve
 
 static void sh_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
 	sh_pmu_stop(event, PERF_EF_UPDATE);
 	__clear_bit(event->hw.idx, cpuc->used_mask);
@@ -272,7 +272,7 @@ static void sh_pmu_del(struct perf_event
 
 static int sh_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 	int ret = -EAGAIN;
Index: linux/arch/sh/kernel/smp.c
===================================================================
--- linux.orig/arch/sh/kernel/smp.c	2013-08-22 14:57:32.574610848 -0500
+++ linux/arch/sh/kernel/smp.c	2013-08-22 14:57:32.570610889 -0500
@@ -111,7 +111,7 @@ void play_dead_common(void)
 	irq_ctx_exit(raw_smp_processor_id());
 	mb();
 
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);
 	local_irq_disable();
 }
 
Index: linux/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux.orig/arch/blackfin/mach-common/ints-priority.c	2013-08-08 02:54:33.132984370 -0500
+++ linux/arch/blackfin/mach-common/ints-priority.c	2013-08-22 14:59:17.705553303 -0500
@@ -1675,12 +1675,12 @@ asmlinkage int __ipipe_grab_irq(int vec,
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

