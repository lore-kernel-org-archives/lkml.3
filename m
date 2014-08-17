Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaHQRbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:31:34 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:48101
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbaHQRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:30 -0400
Message-Id: <20140817173036.329086654@linux.com>
Date: Sun, 17 Aug 2014 12:30:45 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 22/35] [PATCH 22/36] s390: Replace __get_cpu_var uses
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0022-s390-Replace-__get_cpu_var-uses.patch
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
---
 arch/s390/include/asm/cputime.h |  2 +-
 arch/s390/include/asm/irq.h     |  2 +-
 arch/s390/include/asm/percpu.h  | 16 ++++++++--------
 arch/s390/kernel/irq.c          |  2 +-
 arch/s390/kernel/kprobes.c      |  8 ++++----
 arch/s390/kernel/nmi.c          | 10 +++++++---
 arch/s390/kernel/perf_cpum_cf.c | 22 +++++++++++-----------
 arch/s390/kernel/perf_cpum_sf.c | 16 ++++++++--------
 arch/s390/kernel/processor.c    |  4 ++--
 arch/s390/kernel/time.c         |  6 +++---
 arch/s390/kernel/vtime.c        |  2 +-
 arch/s390/oprofile/hwsampler.c  |  2 +-
 12 files changed, 48 insertions(+), 44 deletions(-)

Index: linux/arch/s390/include/asm/cputime.h
===================================================================
--- linux.orig/arch/s390/include/asm/cputime.h
+++ linux/arch/s390/include/asm/cputime.h
@@ -184,7 +184,7 @@ cputime64_t s390_get_idle_time(int cpu);
 
 static inline int s390_nohz_delay(int cpu)
 {
-	return __get_cpu_var(s390_idle).nohz_delay != 0;
+	return __this_cpu_read(s390_idle.nohz_delay) != 0;
 }
 
 #define arch_needs_cpu(cpu) s390_nohz_delay(cpu)
Index: linux/arch/s390/include/asm/irq.h
===================================================================
--- linux.orig/arch/s390/include/asm/irq.h
+++ linux/arch/s390/include/asm/irq.h
@@ -81,7 +81,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct ir
 
 static __always_inline void inc_irq_stat(enum interruption_class irq)
 {
-	__get_cpu_var(irq_stat).irqs[irq]++;
+	__this_cpu_inc(irq_stat.irqs[irq]);
 }
 
 struct ext_code {
Index: linux/arch/s390/include/asm/percpu.h
===================================================================
--- linux.orig/arch/s390/include/asm/percpu.h
+++ linux/arch/s390/include/asm/percpu.h
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
+	ptr__ = raw_cpu_ptr(&(pcp)); 				\
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
Index: linux/arch/s390/kernel/irq.c
===================================================================
--- linux.orig/arch/s390/kernel/irq.c
+++ linux/arch/s390/kernel/irq.c
@@ -258,7 +258,7 @@ static irqreturn_t do_ext_interrupt(int
 
 	ext_code = *(struct ext_code *) &regs->int_code;
 	if (ext_code.code != EXT_IRQ_CLK_COMP)
-		__get_cpu_var(s390_idle).nohz_delay = 1;
+		__this_cpu_write(s390_idle.nohz_delay, 1);
 
 	index = ext_hash(ext_code.code);
 	rcu_read_lock();
Index: linux/arch/s390/kernel/kprobes.c
===================================================================
--- linux.orig/arch/s390/kernel/kprobes.c
+++ linux/arch/s390/kernel/kprobes.c
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
--- linux.orig/arch/s390/kernel/nmi.c
+++ linux/arch/s390/kernel/nmi.c
@@ -53,8 +53,12 @@ void s390_handle_mcck(void)
 	 */
 	local_irq_save(flags);
 	local_mcck_disable();
-	mcck = __get_cpu_var(cpu_mcck);
-	memset(&__get_cpu_var(cpu_mcck), 0, sizeof(struct mcck_struct));
+	/*
+	 * Ummm... Does this make sense at all? Copying the percpu struct
+	 * and then zapping it one statement later?
+	 */
+	memcpy(&mcck, this_cpu_ptr(&cpu_mcck), sizeof(mcck));
+	memset(&mcck, 0, sizeof(struct mcck_struct));
 	clear_cpu_flag(CIF_MCCK_PENDING);
 	local_mcck_enable();
 	local_irq_restore(flags);
@@ -253,7 +257,7 @@ void notrace s390_do_machine_check(struc
 	nmi_enter();
 	inc_irq_stat(NMI_NMI);
 	mci = (struct mci *) &S390_lowcore.mcck_interruption_code;
-	mcck = &__get_cpu_var(cpu_mcck);
+	mcck = this_cpu_ptr(&cpu_mcck);
 	umode = user_mode(regs);
 
 	if (mci->sd) {
Index: linux/arch/s390/kernel/perf_cpum_cf.c
===================================================================
--- linux.orig/arch/s390/kernel/perf_cpum_cf.c
+++ linux/arch/s390/kernel/perf_cpum_cf.c
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
@@ -475,7 +475,7 @@ static void cpumf_pmu_read(struct perf_e
 
 static void cpumf_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
@@ -506,7 +506,7 @@ static void cpumf_pmu_start(struct perf_
 
 static void cpumf_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
 	if (!(hwc->state & PERF_HES_STOPPED)) {
@@ -527,7 +527,7 @@ static void cpumf_pmu_stop(struct perf_e
 
 static int cpumf_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	/* Check authorization for the counter set to which this
 	 * counter belongs.
@@ -551,7 +551,7 @@ static int cpumf_pmu_add(struct perf_eve
 
 static void cpumf_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	cpumf_pmu_stop(event, PERF_EF_UPDATE);
 
@@ -575,7 +575,7 @@ static void cpumf_pmu_del(struct perf_ev
  */
 static void cpumf_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	perf_pmu_disable(pmu);
 	cpuhw->flags |= PERF_EVENT_TXN;
@@ -589,7 +589,7 @@ static void cpumf_pmu_start_txn(struct p
  */
 static void cpumf_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 
 	WARN_ON(cpuhw->tx_state != cpuhw->state);
 
@@ -604,7 +604,7 @@ static void cpumf_pmu_cancel_txn(struct
  */
 static int cpumf_pmu_commit_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+	struct cpu_hw_events *cpuhw = this_cpu_ptr(&cpu_hw_events);
 	u64 state;
 
 	/* check if the updated state can be scheduled */
Index: linux/arch/s390/kernel/perf_cpum_sf.c
===================================================================
--- linux.orig/arch/s390/kernel/perf_cpum_sf.c
+++ linux/arch/s390/kernel/perf_cpum_sf.c
@@ -562,7 +562,7 @@ static DEFINE_MUTEX(pmc_reserve_mutex);
 static void setup_pmc_cpu(void *flags)
 {
 	int err;
-	struct cpu_hw_sf *cpusf = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpusf = this_cpu_ptr(&cpu_hw_sf);
 
 	err = 0;
 	switch (*((int *) flags)) {
@@ -849,7 +849,7 @@ static int cpumsf_pmu_event_init(struct
 
 static void cpumsf_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hw_perf_event *hwc;
 	int err;
 
@@ -898,7 +898,7 @@ static void cpumsf_pmu_enable(struct pmu
 
 static void cpumsf_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hws_lsctl_request_block inactive;
 	struct hws_qsi_info_block si;
 	int err;
@@ -1306,7 +1306,7 @@ static void cpumsf_pmu_read(struct perf_
  */
 static void cpumsf_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
 		return;
@@ -1327,7 +1327,7 @@ static void cpumsf_pmu_start(struct perf
  */
 static void cpumsf_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	if (event->hw.state & PERF_HES_STOPPED)
 		return;
@@ -1346,7 +1346,7 @@ static void cpumsf_pmu_stop(struct perf_
 
 static int cpumsf_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	int err;
 
 	if (cpuhw->flags & PMU_F_IN_USE)
@@ -1397,7 +1397,7 @@ out:
 
 static void cpumsf_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	perf_pmu_disable(event->pmu);
 	cpumsf_pmu_stop(event, PERF_EF_UPDATE);
@@ -1470,7 +1470,7 @@ static void cpumf_measurement_alert(stru
 	if (!(alert & CPU_MF_INT_SF_MASK))
 		return;
 	inc_irq_stat(IRQEXT_CMS);
-	cpuhw = &__get_cpu_var(cpu_hw_sf);
+	cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	/* Measurement alerts are shared and might happen when the PMU
 	 * is not reserved.  Ignore these alerts in this case. */
Index: linux/arch/s390/kernel/processor.c
===================================================================
--- linux.orig/arch/s390/kernel/processor.c
+++ linux/arch/s390/kernel/processor.c
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
--- linux.orig/arch/s390/kernel/time.c
+++ linux/arch/s390/kernel/time.c
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
--- linux.orig/arch/s390/kernel/vtime.c
+++ linux/arch/s390/kernel/vtime.c
@@ -154,7 +154,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void __kprobes vtime_stop_cpu(void)
 {
-	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
+	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
 	unsigned long long idle_time;
 	unsigned long psw_mask;
 
Index: linux/arch/s390/oprofile/hwsampler.c
===================================================================
--- linux.orig/arch/s390/oprofile/hwsampler.c
+++ linux/arch/s390/oprofile/hwsampler.c
@@ -178,7 +178,7 @@ static int smp_ctl_qsi(int cpu)
 static void hws_ext_handler(struct ext_code ext_code,
 			    unsigned int param32, unsigned long param64)
 {
-	struct hws_cpu_buffer *cb = &__get_cpu_var(sampler_cpu_buffer);
+	struct hws_cpu_buffer *cb = this_cpu_ptr(&sampler_cpu_buffer);
 
 	if (!(param32 & CPU_MF_INT_SF_MASK))
 		return;

