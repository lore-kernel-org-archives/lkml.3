Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3K2Rt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:49:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50515 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3K2Rsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:41 -0500
Message-Id: <20131129174430.076978392@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:37:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 5/7] x86: Use latch data structure for cyc2ns
References: <20131129173657.252094369@infradead.org>
Content-Disposition: inline; filename=peterz-tsc-latch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the 'latch' data structure for cyc2ns.

This is a data structure first proposed by me and later named by
Mathieu. If anybody's got a better name; do holler.

Its a multi-version thing which allows always having a coherent
object; we use this to avoid having to disable IRQs while reading
sched_clock() and avoids a problem when getting an NMI while changing
the cyc2ns data.

The patch should have plenty comments actually explaining the thing.

The hope is that the extra logic is offset by no longer requiring the
sti;cli around reading the clock.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/timer.h     |   21 +++-
 arch/x86/kernel/cpu/perf_event.c |   19 ++-
 arch/x86/kernel/tsc.c            |  186 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 195 insertions(+), 31 deletions(-)

--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -13,7 +13,24 @@ extern int recalibrate_cpu_khz(void);
 
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
+};
+
+extern struct cyc2ns_data __percpu *cyc2ns_read_begin(unsigned int *tail);
+extern bool cyc2ns_read_retry(unsigned int tail);
 
 #endif /* _ASM_X86_TIMER_H */
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1890,6 +1890,9 @@ static struct pmu pmu = {
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
+	struct cyc2ns_data __percpu *data;
+	unsigned int tail;
+
 	userpg->cap_user_time = 0;
 	userpg->cap_user_time_zero = 0;
 	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
@@ -1898,13 +1901,17 @@ void arch_perf_update_userpage(struct pe
 	if (!sched_clock_stable)
 		return;
 
-	userpg->cap_user_time = 1;
-	userpg->time_mult = this_cpu_read(cyc2ns);
-	userpg->time_shift = CYC2NS_SCALE_FACTOR;
-	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
+	do {
+		data = cyc2ns_read_begin(&tail);
+
+		userpg->cap_user_time = 1;
+		userpg->time_mult = this_cpu_read(data->cyc2ns_mul);
+		userpg->time_shift = this_cpu_read(data->cyc2ns_shift);
+		userpg->time_offset = this_cpu_read(data->cyc2ns_offset) - now;
 
-	userpg->cap_user_time_zero = 1;
-	userpg->time_zero = this_cpu_read(cyc2ns_offset);
+		userpg->cap_user_time_zero = 1;
+		userpg->time_zero = this_cpu_read(data->cyc2ns_offset);
+	} while (cyc2ns_read_retry(tail));
 }
 
 /*
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -42,7 +42,119 @@ static struct static_key __use_tsc = STA
 
 int tsc_clocksource_reliable;
 
-/* Accelerators for sched_clock()
+/*
+ * The latch data structure below is a multi-version (mostly) wait-free data
+ * structure that guarantees there's always a consistent @data part; even
+ * during writing.
+ *
+ * The data structure is an array of two entries (which is suffient when we
+ * assume updates are sequential) with a head and tail counter; updates are
+ * ordered like:
+ *
+ *   head++                  t = tail
+ *   WMB    (A)              RMB    (C)
+ *   data[head & 1] = d      d = data[tail & 1]
+ *   WMB    (B)              RMB    (D)
+ *   tail++                  retry = (head - t) >= 2
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
+struct cyc2ns_latch {
+	unsigned int head, tail;
+	struct cyc2ns_data data[2];
+};
+
+static DEFINE_PER_CPU(struct cyc2ns_latch, cyc2ns);
+
+/*
+ * Use a {offset, mul} pair of this cpu.
+ *
+ * We use the @data entry that was completed last -- the tail entry.
+ */
+struct cyc2ns_data __percpu *cyc2ns_read_begin(unsigned int *tail)
+{
+	preempt_disable();
+	*tail = this_cpu_read(cyc2ns.tail);
+	/*
+	 * Ensure we read the tail value before we read the data corresponding
+	 * with it. This might actually be implied because of the data
+	 * dependency.
+	 */
+	smp_rmb(); /* C, matches B */
+	return cyc2ns.data + (*tail & 1);
+}
+
+/*
+ * We only need to retry when we observe two or more writes have happened since
+ * we started. This is because we only have storage for 2 @data entries.
+ *
+ * This still means the data structure is (mostly) wait-free because when
+ * writers are scarse this will (nearly) never happen; further it guarantees we
+ * can read while a writer is busy, because there's always the last completed
+ * state available.
+ */
+bool cyc2ns_read_retry(unsigned int tail)
+{
+	bool retry;
+
+	/*
+	 * Ensure we finish reading the data before reading the head entry.
+	 */
+	smp_rmb(); /* D, matches A */
+	retry = unlikely(this_cpu_read(cyc2ns.head) - tail >= 2);
+	preempt_enable();
+
+	return retry;
+}
+
+/*
+ * Begin writing a new @data entry for @cpu.
+ */
+static struct cyc2ns_data *cyc2ns_write_begin(int cpu)
+{
+	struct cyc2ns_latch *latch = &per_cpu(cyc2ns, cpu);
+
+	ACCESS_ONCE(latch->head)++;
+	/*
+	 * Order the head increment against the data writes; this guarantees
+	 * that a read will see this data entry invalidated before we actually
+	 * write to it.
+	 */
+	smp_wmb(); /* A, matches D */
+	return latch->data + (latch->head & 1);
+}
+
+/*
+ * Complete writing a new @data entry for @cpu.
+ */
+static void cyc2ns_write_end(int cpu)
+{
+	struct cyc2ns_latch *latch = &per_cpu(cyc2ns, cpu);
+
+	/*
+	 * Ensure the data entry is fully written before people can observe the
+	 * new tail index. This guarantees that if you observe a tail index,
+	 * the corresponding entry is indeed complete.
+	 */
+	smp_wmb(); /* B, matches C */
+	ACCESS_ONCE(latch->tail)++;
+}
+
+/*
+ * Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
  *              ns = cycles / (freq / ns_per_sec)
@@ -64,49 +176,67 @@ int tsc_clocksource_reliable;
  *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
 
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
-
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
-	unsigned long long ns = this_cpu_read(cyc2ns_offset);
-	ns += mul_u64_u32_shr(cyc, this_cpu_read(cyc2ns), CYC2NS_SCALE_FACTOR);
+	struct cyc2ns_data __percpu *data;
+	unsigned long long ns;
+	unsigned int tail;
+
+	do {
+		data = cyc2ns_read_begin(&tail);
+
+		ns = this_cpu_read(data->cyc2ns_offset);
+		ns += mul_u64_u32_shr(cyc, this_cpu_read(data->cyc2ns_mul),
+				CYC2NS_SCALE_FACTOR);
+	} while (cyc2ns_read_retry(tail));
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
+	data->cyc2ns_offset =
+		ns_now - mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
+
+	cyc2ns_write_end(cpu);
 
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
@@ -122,10 +252,10 @@ u64 native_sched_clock(void)
 	}
 
 	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
+	rdtscll(tsc_now);
 
 	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+	return cycles_2_ns(tsc_now);
 }
 
 /* We need to define a real function for sched_clock, to override the
@@ -681,11 +811,21 @@ void tsc_restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	__this_cpu_write(cyc2ns_offset, 0);
+	/*
+	 * We're comming out of suspend, there's no concurrency yet; don't
+	 * bother being nice about the latch stuff, just write to both
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


