Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3LCXjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:39:40 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:34748
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694Ab3LCXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:13 -0500
Message-Id: <20131203233305.570203419@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:33:11 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 39/41] sh: Replace __get_cpu_var uses
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_sh
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

Cc: Paul Mundt <lethal@linux-sh.org>
CC: linux-sh@vger.kernel.org
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/sh/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/sh/kernel/hw_breakpoint.c	2013-12-02 16:08:01.534307329 -0600
+++ linux/arch/sh/kernel/hw_breakpoint.c	2013-12-02 16:08:01.524307605 -0600
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
--- linux.orig/arch/sh/kernel/kprobes.c	2013-12-02 16:08:01.534307329 -0600
+++ linux/arch/sh/kernel/kprobes.c	2013-12-02 16:08:01.524307605 -0600
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
--- linux.orig/arch/sh/kernel/localtimer.c	2013-12-02 16:08:01.534307329 -0600
+++ linux/arch/sh/kernel/localtimer.c	2013-12-02 16:08:01.524307605 -0600
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
--- linux.orig/arch/sh/kernel/perf_event.c	2013-12-02 16:08:01.534307329 -0600
+++ linux/arch/sh/kernel/perf_event.c	2013-12-02 16:08:01.524307605 -0600
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
--- linux.orig/arch/sh/kernel/smp.c	2013-12-02 16:08:01.534307329 -0600
+++ linux/arch/sh/kernel/smp.c	2013-12-02 16:08:01.524307605 -0600
@@ -111,7 +111,7 @@ void play_dead_common(void)
 	irq_ctx_exit(raw_smp_processor_id());
 	mb();
 
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);
 	local_irq_disable();
 }
 

