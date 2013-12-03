Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3LCXdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:33:07 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:36210 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755732Ab3LCXdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:33:04 -0500
Message-Id: <20131203233301.211048290@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:33:03 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 31/41] s390: Replace __get_cpu_var uses
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_s390
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

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux390@de.ibm.com
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/s390/include/asm/irq.h
===================================================================
--- linux.orig/arch/s390/include/asm/irq.h	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/include/asm/irq.h	2013-12-02 16:07:58.824382630 -0600
@@ -66,7 +66,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct ir
 
 static __always_inline void inc_irq_stat(enum interruption_class irq)
 {
-	__get_cpu_var(irq_stat).irqs[irq]++;
+	__this_cpu_inc(irq_stat.irqs[irq]);
 }
 
 struct ext_code {
Index: linux/arch/s390/include/asm/cputime.h
===================================================================
--- linux.orig/arch/s390/include/asm/cputime.h	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/include/asm/cputime.h	2013-12-02 16:07:58.824382630 -0600
@@ -184,7 +184,7 @@ cputime64_t s390_get_idle_time(int cpu);
 
 static inline int s390_nohz_delay(int cpu)
 {
-	return __get_cpu_var(s390_idle).nohz_delay != 0;
+	return __this_cpu_read(s390_idle.nohz_delay) != 0;
 }
 
 #define arch_needs_cpu(cpu) s390_nohz_delay(cpu)
Index: linux/arch/s390/kernel/kprobes.c
===================================================================
--- linux.orig/arch/s390/kernel/kprobes.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/kprobes.c	2013-12-02 16:07:58.824382630 -0600
@@ -366,9 +366,9 @@ static void __kprobes disable_singlestep
  */
 static void __kprobes push_kprobe(struct kprobe_ctlblk *kcb, struct kprobe *p)
 {
-	kcb->prev_kprobe.kp = __get_cpu_var(current_kprobe);
+	kcb->prev_kprobe.kp = __this_cpu_read(current_kprobe);
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 }
 
 /*
@@ -378,7 +378,7 @@ static void __kprobes push_kprobe(struct
  */
 static void __kprobes pop_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
@@ -459,7 +459,7 @@ static int __kprobes kprobe_handler(stru
 		enable_singlestep(kcb, regs, (unsigned long) p->ainsn.insn);
 		return 1;
 	} else if (kprobe_running()) {
-		p = __get_cpu_var(current_kprobe);
+		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			/*
 			 * Continuation after the jprobe completed and
Index: linux/arch/s390/kernel/nmi.c
===================================================================
--- linux.orig/arch/s390/kernel/nmi.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/nmi.c	2013-12-02 16:07:58.824382630 -0600
@@ -53,8 +53,8 @@ void s390_handle_mcck(void)
 	 */
 	local_irq_save(flags);
 	local_mcck_disable();
-	mcck = __get_cpu_var(cpu_mcck);
-	memset(&__get_cpu_var(cpu_mcck), 0, sizeof(struct mcck_struct));
+	mcck = __this_cpu_read(cpu_mcck);
+	memset(this_cpu_ptr(&cpu_mcck), 0, sizeof(struct mcck_struct));
 	clear_thread_flag(TIF_MCCK_PENDING);
 	local_mcck_enable();
 	local_irq_restore(flags);
@@ -253,7 +253,7 @@ void notrace s390_do_machine_check(struc
 	nmi_enter();
 	inc_irq_stat(NMI_NMI);
 	mci = (struct mci *) &S390_lowcore.mcck_interruption_code;
-	mcck = &__get_cpu_var(cpu_mcck);
+	mcck = this_cpu_ptr(&cpu_mcck);
 	umode = user_mode(regs);
 
 	if (mci->sd) {
Index: linux/arch/s390/kernel/perf_cpum_cf.c
===================================================================
--- linux.orig/arch/s390/kernel/perf_cpum_cf.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/perf_cpum_cf.c	2013-12-02 16:07:58.824382630 -0600
@@ -173,7 +173,7 @@ static int validate_ctr_auth(const struc
  */
 static void cpumf_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	int err;
 
 	if (cpuhw->flags & PMU_F_ENABLED)
@@ -196,7 +196,7 @@ static void cpumf_pmu_enable(struct pmu
  */
 static void cpumf_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	int err;
 	u64 inactive;
 
@@ -230,7 +230,7 @@ static void cpumf_measurement_alert(stru
 		return;
 
 	inc_irq_stat(IRQEXT_CMC);
-	cpuhw = &__get_cpu_var(cpu_hw_events);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	/* Measurement alerts are shared and might happen when the PMU
 	 * is not reserved.  Ignore these alerts in this case. */
@@ -250,7 +250,7 @@ static void cpumf_measurement_alert(stru
 #define PMC_RELEASE   1
 static void setup_pmc_cpu(void *flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	switch (*((int *) flags)) {
 	case PMC_INIT:
@@ -481,7 +481,7 @@ static void cpumf_pmu_read(struct perf_e
 
 static void cpumf_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
@@ -512,7 +512,7 @@ static void cpumf_pmu_start(struct perf_
 
 static void cpumf_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (!(hwc->state & PERF_HES_STOPPED)) {
@@ -533,7 +533,7 @@ static void cpumf_pmu_stop(struct perf_e
 
 static int cpumf_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	/* Check authorization for the counter set to which this
 	 * counter belongs.
@@ -557,7 +557,7 @@ static int cpumf_pmu_add(struct perf_eve
 
 static void cpumf_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	cpumf_pmu_stop(event, PERF_EF_UPDATE);
 
@@ -581,7 +581,7 @@ static void cpumf_pmu_del(struct perf_ev
  */
 static void cpumf_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	perf_pmu_disable(pmu);
 	cpuhw->flags |= PERF_EVENT_TXN;
@@ -595,7 +595,7 @@ static void cpumf_pmu_start_txn(struct p
  */
 static void cpumf_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	WARN_ON(cpuhw->tx_state != cpuhw->state);
 
@@ -610,7 +610,7 @@ static void cpumf_pmu_cancel_txn(struct
  */
 static int cpumf_pmu_commit_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	u64 state;
 
 	/* check if the updated state can be scheduled */
Index: linux/arch/s390/kernel/processor.c
===================================================================
--- linux.orig/arch/s390/kernel/processor.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/processor.c	2013-12-02 16:07:58.824382630 -0600
@@ -23,8 +23,8 @@ static DEFINE_PER_CPU(struct cpuid, cpu_
  */
 void cpu_init(void)
 {
-	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
-	struct cpuid *id = &__get_cpu_var(cpu_id);
+	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
+	struct cpuid *id = this_cpu_ptr(&cpu_id);
 
 	get_cpu_id(id);
 	atomic_inc(&init_mm.mm_count);
Index: linux/arch/s390/kernel/time.c
===================================================================
--- linux.orig/arch/s390/kernel/time.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/time.c	2013-12-02 16:07:58.824382630 -0600
@@ -92,7 +92,7 @@ void clock_comparator_work(void)
 	struct clock_event_device *cd;
 
 	S390_lowcore.clock_comparator = -1ULL;
-	cd = &__get_cpu_var(comparators);
+	cd = this_cpu_ptr(&comparators);
 	cd->event_handler(cd);
 }
 
@@ -360,7 +360,7 @@ EXPORT_SYMBOL(get_sync_clock);
  */
 static void disable_sync_clock(void *dummy)
 {
-	atomic_t *sw_ptr = &__get_cpu_var(clock_sync_word);
+	atomic_t *sw_ptr = this_cpu_ptr(&clock_sync_word);
 	/*
 	 * Clear the in-sync bit 2^31. All get_sync_clock calls will
 	 * fail until the sync bit is turned back on. In addition
@@ -377,7 +377,7 @@ static void disable_sync_clock(void *dum
  */
 static void enable_sync_clock(void)
 {
-	atomic_t *sw_ptr = &__get_cpu_var(clock_sync_word);
+	atomic_t *sw_ptr = this_cpu_ptr(&clock_sync_word);
 	atomic_set_mask(0x80000000, sw_ptr);
 }
 
Index: linux/arch/s390/kernel/vtime.c
===================================================================
--- linux.orig/arch/s390/kernel/vtime.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/vtime.c	2013-12-02 16:07:58.824382630 -0600
@@ -154,7 +154,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void __kprobes vtime_stop_cpu(void)
 {
-	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
+	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
 	unsigned long long idle_time;
 	unsigned long psw_mask;
 
Index: linux/arch/s390/oprofile/hwsampler.c
===================================================================
--- linux.orig/arch/s390/oprofile/hwsampler.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/oprofile/hwsampler.c	2013-12-02 16:07:58.824382630 -0600
@@ -228,7 +228,7 @@ static inline unsigned long *trailer_ent
 static void hws_ext_handler(struct ext_code ext_code,
 			    unsigned int param32, unsigned long param64)
 {
-	struct hws_cpu_buffer *cb = &__get_cpu_var(sampler_cpu_buffer);
+	struct hws_cpu_buffer *cb = this_cpu_ptr(&sampler_cpu_buffer);
 
 	if (!(param32 & CPU_MF_INT_SF_MASK))
 		return;
Index: linux/arch/s390/kernel/irq.c
===================================================================
--- linux.orig/arch/s390/kernel/irq.c	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/kernel/irq.c	2013-12-02 16:07:58.824382630 -0600
@@ -252,7 +252,7 @@ static irqreturn_t do_ext_interrupt(int
 
 	ext_code = *(struct ext_code *) &regs->int_code;
 	if (ext_code.code != 0x1004)
-		__get_cpu_var(s390_idle).nohz_delay = 1;
+		__this_cpu_write(s390_idle.nohz_delay, 1);
 
 	index = ext_hash(ext_code.code);
 	rcu_read_lock();
Index: linux/arch/s390/include/asm/percpu.h
===================================================================
--- linux.orig/arch/s390/include/asm/percpu.h	2013-12-02 16:07:58.824382630 -0600
+++ linux/arch/s390/include/asm/percpu.h	2013-12-02 16:07:58.824382630 -0600
@@ -31,7 +31,7 @@
 	pcp_op_T__ old__, new__, prev__;				\
 	pcp_op_T__ *ptr__;						\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp));					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
 	prev__ = *ptr__;						\
 	do {								\
 		old__ = prev__;						\
@@ -70,7 +70,7 @@
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp)); 				\
+	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	if (__builtin_constant_p(val__) &&				\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {		\
 		asm volatile(						\
@@ -97,7 +97,7 @@
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp)); 				\
+	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	asm volatile(							\
 		op "    %[old__],%[val__],%[ptr__]\n"			\
 		: [old__] "=d" (old__), [ptr__] "+Q" (*ptr__)		\
@@ -116,7 +116,7 @@
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp)); 				\
+	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	asm volatile(							\
 		op "    %[old__],%[val__],%[ptr__]\n"			\
 		: [old__] "=d" (old__), [ptr__] "+Q" (*ptr__)		\
@@ -138,7 +138,7 @@
 	pcp_op_T__ ret__;						\
 	pcp_op_T__ *ptr__;						\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp));					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = cmpxchg(ptr__, oval, nval);				\
 	preempt_enable();						\
 	ret__;								\
@@ -154,7 +154,7 @@
 	typeof(pcp) *ptr__;						\
 	typeof(pcp) ret__;						\
 	preempt_disable();						\
-	ptr__ = __this_cpu_ptr(&(pcp));					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = xchg(ptr__, nval);					\
 	preempt_enable();						\
 	ret__;								\
@@ -173,8 +173,8 @@
 	typeof(pcp2) *p2__;						\
 	int ret__;							\
 	preempt_disable();						\
-	p1__ = __this_cpu_ptr(&(pcp1));					\
-	p2__ = __this_cpu_ptr(&(pcp2));					\
+	p1__ = raw_cpu_ptr(&(pcp1));					\
+	p2__ = raw_cpu_ptr(&(pcp2));					\
 	ret__ = __cmpxchg_double(p1__, p2__, o1__, o2__, n1__, n2__);	\
 	preempt_enable();						\
 	ret__;								\

