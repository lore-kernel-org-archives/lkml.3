Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaAMP6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:58:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAMP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:58:12 -0500
Date: Mon, 13 Jan 2014 07:57:35 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-s567in1e5ekq2nlyhn8f987r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock, x86: Rewrite cyc2ns()
  to avoid the need to disable IRQs
Git-Commit-ID: 20d1c86a57762f0a33a78988e3fc8818316badd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:57:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20d1c86a57762f0a33a78988e3fc8818316badd4
Gitweb:     http://git.kernel.org/tip/20d1c86a57762f0a33a78988e3fc8818316badd4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 29 Nov 2013 15:40:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 15:13:06 +0100

sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs

Use a ring-buffer like multi-version object structure which allows
always having a coherent object; we use this to avoid having to
disable IRQs while reading sched_clock() and avoids a problem when
getting an NMI while changing the cyc2ns data.

                        MAINLINE   PRE        POST

    sched_clock_stable: 1          1          1
    (cold) sched_clock: 329841     331312     257223
    (cold) local_clock: 301773     310296     309889
    (warm) sched_clock: 38375      38247      25280
    (warm) local_clock: 100371     102713     85268
    (warm) rdtsc:       27340      27289      24247
    sched_clock_stable: 0          0          0
    (cold) sched_clock: 382634     372706     301224
    (cold) local_clock: 396890     399275     399870
    (warm) sched_clock: 38194      38124      25630
    (warm) local_clock: 143452     148698     129629
    (warm) rdtsc:       27345      27365      24307

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-s567in1e5ekq2nlyhn8f987r@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/timer.h     |  23 +++-
 arch/x86/kernel/cpu/perf_event.c |  14 ++-
 arch/x86/kernel/tsc.c            | 229 +++++++++++++++++++++++++++++++++++----
 arch/x86/platform/uv/tlb_uv.c    |  66 ++++++-----
 4 files changed, 276 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index b4c6676..3de54ef 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -13,7 +13,26 @@ extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
 
-DECLARE_PER_CPU(unsigned long, cyc2ns);
-DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
+/*
+ * We use the full linear equation: f(x) = a + b*x, in order to allow
+ * a continuous function in the face of dynamic freq changes.
+ *
+ * Continuity means that when our frequency changes our slope (b); we want to
+ * ensure that: f(t) == f'(t), which gives: a + b*t == a' + b'*t.
+ *
+ * Without an offset (a) the above would not be possible.
+ *
+ * See the comment near cycles_2_ns() for details on how we compute (b).
+ */
+struct cyc2ns_data {
+	u32 cyc2ns_mul;
+	u32 cyc2ns_shift;
+	u64 cyc2ns_offset;
+	u32 __count;
+	/* u32 hole */
+}; /* 24 bytes -- do not grow */
+
+extern struct cyc2ns_data *cyc2ns_read_begin(void);
+extern void cyc2ns_read_end(struct cyc2ns_data *);
 
 #endif /* _ASM_X86_TIMER_H */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8e13293..9f97bd0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1883,6 +1883,8 @@ static struct pmu pmu = {
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
+	struct cyc2ns_data *data;
+
 	userpg->cap_user_time = 0;
 	userpg->cap_user_time_zero = 0;
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
@@ -1891,13 +1893,17 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	if (!sched_clock_stable)
 		return;
 
+	data = cyc2ns_read_begin();
+
 	userpg->cap_user_time = 1;
-	userpg->time_mult = this_cpu_read(cyc2ns);
-	userpg->time_shift = CYC2NS_SCALE_FACTOR;
-	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
+	userpg->time_mult = data->cyc2ns_mul;
+	userpg->time_shift = data->cyc2ns_shift;
+	userpg->time_offset = data->cyc2ns_offset - now;
 
 	userpg->cap_user_time_zero = 1;
-	userpg->time_zero = this_cpu_read(cyc2ns_offset);
+	userpg->time_zero = data->cyc2ns_offset;
+
+	cyc2ns_read_end(data);
 }
 
 /*
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b4a04ac..92b090b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -39,7 +39,119 @@ static int __read_mostly tsc_disabled = -1;
 
 int tsc_clocksource_reliable;
 
-/* Accelerators for sched_clock()
+/*
+ * Use a ring-buffer like data structure, where a writer advances the head by
+ * writing a new data entry and a reader advances the tail when it observes a
+ * new entry.
+ *
+ * Writers are made to wait on readers until there's space to write a new
+ * entry.
+ *
+ * This means that we can always use an {offset, mul} pair to compute a ns
+ * value that is 'roughly' in the right direction, even if we're writing a new
+ * {offset, mul} pair during the clock read.
+ *
+ * The down-side is that we can no longer guarantee strict monotonicity anymore
+ * (assuming the TSC was that to begin with), because while we compute the
+ * intersection point of the two clock slopes and make sure the time is
+ * continuous at the point of switching; we can no longer guarantee a reader is
+ * strictly before or after the switch point.
+ *
+ * It does mean a reader no longer needs to disable IRQs in order to avoid
+ * CPU-Freq updates messing with his times, and similarly an NMI reader will
+ * no longer run the risk of hitting half-written state.
+ */
+
+struct cyc2ns {
+	struct cyc2ns_data data[2];	/*  0 + 2*24 = 48 */
+	struct cyc2ns_data *head;	/* 48 + 8    = 56 */
+	struct cyc2ns_data *tail;	/* 56 + 8    = 64 */
+}; /* exactly fits one cacheline */
+
+static DEFINE_PER_CPU_ALIGNED(struct cyc2ns, cyc2ns);
+
+struct cyc2ns_data *cyc2ns_read_begin(void)
+{
+	struct cyc2ns_data *head;
+
+	preempt_disable();
+
+	head = this_cpu_read(cyc2ns.head);
+	/*
+	 * Ensure we observe the entry when we observe the pointer to it.
+	 * matches the wmb from cyc2ns_write_end().
+	 */
+	smp_read_barrier_depends();
+	head->__count++;
+	barrier();
+
+	return head;
+}
+
+void cyc2ns_read_end(struct cyc2ns_data *head)
+{
+	barrier();
+	/*
+	 * If we're the outer most nested read; update the tail pointer
+	 * when we're done. This notifies possible pending writers
+	 * that we've observed the head pointer and that the other
+	 * entry is now free.
+	 */
+	if (!--head->__count) {
+		/*
+		 * x86-TSO does not reorder writes with older reads;
+		 * therefore once this write becomes visible to another
+		 * cpu, we must be finished reading the cyc2ns_data.
+		 *
+		 * matches with cyc2ns_write_begin().
+		 */
+		this_cpu_write(cyc2ns.tail, head);
+	}
+	preempt_enable();
+}
+
+/*
+ * Begin writing a new @data entry for @cpu.
+ *
+ * Assumes some sort of write side lock; currently 'provided' by the assumption
+ * that cpufreq will call its notifiers sequentially.
+ */
+static struct cyc2ns_data *cyc2ns_write_begin(int cpu)
+{
+	struct cyc2ns *c2n = &per_cpu(cyc2ns, cpu);
+	struct cyc2ns_data *data = c2n->data;
+
+	if (data == c2n->head)
+		data++;
+
+	/* XXX send an IPI to @cpu in order to guarantee a read? */
+
+	/*
+	 * When we observe the tail write from cyc2ns_read_end(),
+	 * the cpu must be done with that entry and its safe
+	 * to start writing to it.
+	 */
+	while (c2n->tail == data)
+		cpu_relax();
+
+	return data;
+}
+
+static void cyc2ns_write_end(int cpu, struct cyc2ns_data *data)
+{
+	struct cyc2ns *c2n = &per_cpu(cyc2ns, cpu);
+
+	/*
+	 * Ensure the @data writes are visible before we publish the
+	 * entry. Matches the data-depencency in cyc2ns_read_begin().
+	 */
+	smp_wmb();
+
+	ACCESS_ONCE(c2n->head) = data;
+}
+
+/*
+ * Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
  *              ns = cycles / (freq / ns_per_sec)
@@ -61,49 +173,106 @@ int tsc_clocksource_reliable;
  *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
 
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
-
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
+static void cyc2ns_data_init(struct cyc2ns_data *data)
+{
+	data->cyc2ns_mul = 1U << CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_offset = 0;
+	data->__count = 0;
+}
+
+static void cyc2ns_init(int cpu)
+{
+	struct cyc2ns *c2n = &per_cpu(cyc2ns, cpu);
+
+	cyc2ns_data_init(&c2n->data[0]);
+	cyc2ns_data_init(&c2n->data[1]);
+
+	c2n->head = c2n->data;
+	c2n->tail = c2n->data;
+}
+
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
-	unsigned long long ns = this_cpu_read(cyc2ns_offset);
-	ns += mul_u64_u32_shr(cyc, this_cpu_read(cyc2ns), CYC2NS_SCALE_FACTOR);
+	struct cyc2ns_data *data, *tail;
+	unsigned long long ns;
+
+	/*
+	 * See cyc2ns_read_*() for details; replicated in order to avoid
+	 * an extra few instructions that came with the abstraction.
+	 * Notable, it allows us to only do the __count and tail update
+	 * dance when its actually needed.
+	 */
+
+	preempt_disable();
+	data = this_cpu_read(cyc2ns.head);
+	tail = this_cpu_read(cyc2ns.tail);
+
+	if (likely(data == tail)) {
+		ns = data->cyc2ns_offset;
+		ns += mul_u64_u32_shr(cyc, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+	} else {
+		data->__count++;
+
+		barrier();
+
+		ns = data->cyc2ns_offset;
+		ns += mul_u64_u32_shr(cyc, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+
+		barrier();
+
+		if (!--data->__count)
+			this_cpu_write(cyc2ns.tail, data);
+	}
+	preempt_enable();
+
 	return ns;
 }
 
+/* XXX surely we already have this someplace in the kernel?! */
+#define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
+
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now, *offset;
-	unsigned long flags, *scale;
+	unsigned long long tsc_now, ns_now;
+	struct cyc2ns_data *data;
+	unsigned long flags;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
-	scale = &per_cpu(cyc2ns, cpu);
-	offset = &per_cpu(cyc2ns_offset, cpu);
+	if (!cpu_khz)
+		goto done;
+
+	data = cyc2ns_write_begin(cpu);
 
 	rdtscll(tsc_now);
 	ns_now = cycles_2_ns(tsc_now);
 
-	if (cpu_khz) {
-		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
-				cpu_khz / 2) / cpu_khz;
-		*offset = ns_now - mult_frac(tsc_now, *scale,
-					     (1UL << CYC2NS_SCALE_FACTOR));
-	}
+	/*
+	 * Compute a new multiplier as per the above comment and ensure our
+	 * time function is continuous; see the comment near struct
+	 * cyc2ns_data.
+	 */
+	data->cyc2ns_mul = DIV_ROUND(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR, cpu_khz);
+	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_offset = ns_now -
+		mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+
+	cyc2ns_write_end(cpu, data);
 
+done:
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);
 }
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
 u64 native_sched_clock(void)
 {
-	u64 this_offset;
+	u64 tsc_now;
 
 	/*
 	 * Fall back to jiffies if there's no TSC available:
@@ -119,10 +288,10 @@ u64 native_sched_clock(void)
 	}
 
 	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
+	rdtscll(tsc_now);
 
 	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+	return cycles_2_ns(tsc_now);
 }
 
 /* We need to define a real function for sched_clock, to override the
@@ -678,11 +847,21 @@ void tsc_restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	__this_cpu_write(cyc2ns_offset, 0);
+	/*
+	 * We're comming out of suspend, there's no concurrency yet; don't
+	 * bother being nice about the RCU stuff, just write to both
+	 * data fields.
+	 */
+
+	this_cpu_write(cyc2ns.data[0].cyc2ns_offset, 0);
+	this_cpu_write(cyc2ns.data[1].cyc2ns_offset, 0);
+
 	offset = cyc2ns_suspend - sched_clock();
 
-	for_each_possible_cpu(cpu)
-		per_cpu(cyc2ns_offset, cpu) = offset;
+	for_each_possible_cpu(cpu) {
+		per_cpu(cyc2ns.data[0].cyc2ns_offset, cpu) = offset;
+		per_cpu(cyc2ns.data[1].cyc2ns_offset, cpu) = offset;
+	}
 
 	local_irq_restore(flags);
 }
@@ -1005,8 +1184,10 @@ void __init tsc_init(void)
 	 * speed as the bootup CPU. (cpufreq notifiers will fix this
 	 * up if their speed diverges)
 	 */
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		cyc2ns_init(cpu);
 		set_cyc2ns_scale(cpu_khz, cpu);
+	}
 
 	if (tsc_disabled > 0)
 		return;
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index efe4d72..dfe605a 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -433,15 +433,49 @@ static void reset_with_ipi(struct pnmask *distribution, struct bau_control *bcp)
 	return;
 }
 
-static inline unsigned long cycles_2_us(unsigned long long cyc)
+/*
+ * Not to be confused with cycles_2_ns() from tsc.c; this gives a relative
+ * number, not an absolute. It converts a duration in cycles to a duration in
+ * ns.
+ */
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
+	struct cyc2ns_data *data = cyc2ns_read_begin();
 	unsigned long long ns;
-	unsigned long us;
-	int cpu = smp_processor_id();
 
-	ns =  (cyc * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR;
-	us = ns / 1000;
-	return us;
+	ns = mul_u64_u32_shr(cyc, data->cyc2ns_mul, data->cyc2ns_shift);
+
+	cyc2ns_read_end(data);
+	return ns;
+}
+
+/*
+ * The reverse of the above; converts a duration in ns to a duration in cycles.
+ */ 
+static inline unsigned long long ns_2_cycles(unsigned long long ns)
+{
+	struct cyc2ns_data *data = cyc2ns_read_begin();
+	unsigned long long cyc;
+
+	cyc = (ns << data->cyc2ns_shift) / data->cyc2ns_mul;
+
+	cyc2ns_read_end(data);
+	return cyc;
+}
+
+static inline unsigned long cycles_2_us(unsigned long long cyc)
+{
+	return cycles_2_ns(cyc) / NSEC_PER_USEC;
+}
+
+static inline cycles_t sec_2_cycles(unsigned long sec)
+{
+	return ns_2_cycles(sec * NSEC_PER_SEC);
+}
+
+static inline unsigned long long usec_2_cycles(unsigned long usec)
+{
+	return ns_2_cycles(usec * NSEC_PER_USEC);
 }
 
 /*
@@ -668,16 +702,6 @@ static int wait_completion(struct bau_desc *bau_desc,
 								bcp, try);
 }
 
-static inline cycles_t sec_2_cycles(unsigned long sec)
-{
-	unsigned long ns;
-	cycles_t cyc;
-
-	ns = sec * 1000000000;
-	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
-	return cyc;
-}
-
 /*
  * Our retries are blocked by all destination sw ack resources being
  * in use, and a timeout is pending. In that case hardware immediately
@@ -1327,16 +1351,6 @@ static void ptc_seq_stop(struct seq_file *file, void *data)
 {
 }
 
-static inline unsigned long long usec_2_cycles(unsigned long microsec)
-{
-	unsigned long ns;
-	unsigned long long cyc;
-
-	ns = microsec * 1000;
-	cyc = (ns << CYC2NS_SCALE_FACTOR)/(per_cpu(cyc2ns, smp_processor_id()));
-	return cyc;
-}
-
 /*
  * Display the statistics thru /proc/sgi_uv/ptc_statistics
  * 'data' points to the cpu number
