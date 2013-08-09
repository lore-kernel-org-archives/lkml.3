Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031119Ab3HIUro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:47:44 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55220 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031057Ab3HIUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:47:39 -0400
Message-ID: <3f0e750c818fd0cfa5e840c973fa58583c81f633.1376080997.git.cmetcalf@tilera.com>
In-Reply-To: <377cf030524ac2530f7651699ca812aa6e53978c.1376080997.git.cmetcalf@tilera.com>
References: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 15:34:38 -0400
Subject: [PATCH v2 2/2] tile: implement dynamic frequency changing
To: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change provides a cpufreq driver for tilegx, and also the
associated machinery to support the fact that we use the core frequency
as the actual timekeeper clock, so we have to go to some trouble to keep
everything lined up as we change the core frequency.

A newer hypervisor is required that implements the hv_set_speed() API.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
v1: If these patches are OK, I can push them as part of the tile tree.
Otherwise, they should probably be pushed through a single tree either
by the timekeeping folks or (more likely?) the cpu frequency driver folks.
Let me know what makes the most sense; for now they are in tile-next.

v2: use do_div() in timekeeping_chfreq() to avoid build failures on i386
(no change to patch 2/2, the cpufreq driver)

 MAINTAINERS                       |   1 +
 arch/tile/Kconfig                 |  17 ++++
 arch/tile/include/asm/timex.h     |   4 +
 arch/tile/include/hv/hypervisor.h |  40 +++++++++
 arch/tile/kernel/hvglue.S         |   1 +
 arch/tile/kernel/hvglue_trace.c   |   4 +
 arch/tile/kernel/time.c           | 170 +++++++++++++++++++++++++++++++++-----
 drivers/cpufreq/Makefile          |   1 +
 drivers/cpufreq/tilegx-cpufreq.c  | 169 +++++++++++++++++++++++++++++++++++++
 9 files changed, 387 insertions(+), 20 deletions(-)
 create mode 100644 drivers/cpufreq/tilegx-cpufreq.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f49198..b8e3bea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8289,6 +8289,7 @@ W:	http://www.tilera.com/scm/
 S:	Supported
 F:	arch/tile/
 F:	drivers/char/tile-srom.c
+F:	drivers/cpufreq/tilegx-cpufreq.c
 F:	drivers/edac/tile_edac.c
 F:	drivers/net/ethernet/tile/
 F:	drivers/rtc/rtc-tile.c
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 7b87318..e76180e 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -451,3 +451,20 @@ source "crypto/Kconfig"
 source "lib/Kconfig"
 
 source "arch/tile/kvm/Kconfig"
+
+menu "CPU Frequency scaling"
+	depends on TILEGX
+
+source "drivers/cpufreq/Kconfig"
+
+config CPU_FREQ_TILEGX
+	tristate "CPUfreq driver for TILE-Gx"
+	depends on CPU_FREQ && TILEGX
+	default n
+	select STOP_MACHINE
+	---help---
+	  This enables the CPUfreq driver for TILE-Gx CPUs.  Say Y here
+	  if you want to be able to dynamically adjust CPU frequency
+	  while the system is running.
+
+endmenu
diff --git a/arch/tile/include/asm/timex.h b/arch/tile/include/asm/timex.h
index dc987d5..edbd7e4 100644
--- a/arch/tile/include/asm/timex.h
+++ b/arch/tile/include/asm/timex.h
@@ -40,6 +40,10 @@ static inline cycles_t get_cycles(void)
 
 cycles_t get_clock_rate(void);
 
+#ifdef __tilegx__
+unsigned int set_clock_rate(unsigned int new_rate);
+#endif
+
 /* Convert nanoseconds to core clock cycles. */
 cycles_t ns2cycles(unsigned long nsecs);
 
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 0971ebb..f71b08e 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -318,6 +318,9 @@
 /** hv_set_pte_super_shift */
 #define HV_DISPATCH_SET_PTE_SUPER_SHIFT           57
 
+/** hv_set_speed */
+#define HV_DISPATCH_SET_SPEED                     58
+
 /** hv_console_set_ipi */
 #define HV_DISPATCH_CONSOLE_SET_IPI               63
 
@@ -711,6 +714,43 @@ HV_RTCTime hv_get_rtc(void);
  */
 void hv_set_rtc(HV_RTCTime time);
 
+
+/** Value returned from hv_set_speed(). */
+typedef struct {
+  /** The new speed achieved, in Hertz, or a negative error code. */
+  long new_speed;
+
+  /** A cycle counter value, in the post-speed-change time domain. */
+  __hv64 end_cycle;
+
+  /** Time elapsed in nanoseconds between start_cycle (passed to
+   *  hv_set_speed(), in the pre-speed-change time domain) and end_cycle
+   *  (returned in this structure). */
+  __hv64 delta_ns;
+} HV_SetSpeed;
+
+
+/** Set the processor clock speed.
+ * @param speed Clock speed in hertz.
+ * @param start_cycle Initial cycle counter value; see the definition of
+ *  HV_SetSpeed for how this is used.
+ * @param flags Flags (HV_SET_SPEED_xxx).
+ * @return A HV_SetSpeed structure.
+ */
+HV_SetSpeed hv_set_speed(unsigned long speed, __hv64 start_cycle,
+                         unsigned long flags);
+
+/** Don't set the speed, just check the value and return the speed we would
+ *  have set if this flag had not been specified.  When this flag is
+ *  specified, the start_cycle parameter is ignored, and the end_cycle and
+ *  delta_ns values in the HV_SetSpeed structure are undefined. */
+#define HV_SET_SPEED_DRYRUN   0x1
+
+/** If the precise speed specified is not supported by the hardware, round
+ *  it up to the next higher supported frequency if necessary; without this
+ *  flag, we round down. */
+#define HV_SET_SPEED_ROUNDUP  0x2
+
 /** Installs a context, comprising a page table and other attributes.
  *
  *  Once this service completes, page_table will be used to translate
diff --git a/arch/tile/kernel/hvglue.S b/arch/tile/kernel/hvglue.S
index 2ab4566..16576c6 100644
--- a/arch/tile/kernel/hvglue.S
+++ b/arch/tile/kernel/hvglue.S
@@ -70,5 +70,6 @@ gensym hv_inquire_realpa, 0x6c0, 32
 gensym hv_flush_all, 0x6e0, 32
 gensym hv_get_ipi_pte, 0x700, 32
 gensym hv_set_pte_super_shift, 0x720, 32
+gensym hv_set_speed, 0x740, 32
 gensym hv_console_set_ipi, 0x7e0, 32
 gensym hv_glue_internals, 0x800, 30720
diff --git a/arch/tile/kernel/hvglue_trace.c b/arch/tile/kernel/hvglue_trace.c
index 85c74ad..16ef6c1 100644
--- a/arch/tile/kernel/hvglue_trace.c
+++ b/arch/tile/kernel/hvglue_trace.c
@@ -74,6 +74,7 @@
 #define hv_flush_all _hv_flush_all
 #define hv_get_ipi_pte _hv_get_ipi_pte
 #define hv_set_pte_super_shift _hv_set_pte_super_shift
+#define hv_set_speed _hv_set_speed
 #define hv_console_set_ipi _hv_console_set_ipi
 #include <hv/hypervisor.h>
 #undef hv_init
@@ -133,6 +134,7 @@
 #undef hv_flush_all
 #undef hv_get_ipi_pte
 #undef hv_set_pte_super_shift
+#undef hv_set_speed
 #undef hv_console_set_ipi
 
 /*
@@ -203,6 +205,8 @@ HV_WRAP3(int, hv_store_mapping, HV_VirtAddr, va, unsigned int, len,
 HV_WRAP2(HV_PhysAddr, hv_inquire_realpa, HV_PhysAddr, cpa, unsigned int, len)
 HV_WRAP0(HV_RTCTime, hv_get_rtc)
 HV_WRAP1(void, hv_set_rtc, HV_RTCTime, time)
+HV_WRAP3(HV_SetSpeed, hv_set_speed, unsigned long, speed, __hv64, start_cycle,
+	 unsigned long, flags)
 HV_WRAP4(int, hv_install_context, HV_PhysAddr, page_table, HV_PTE, access,
 	 HV_ASID, asid, __hv32, flags)
 HV_WRAP2(int, hv_set_pte_super_shift, int, level, int, log2_count)
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 36dc1e1..3c2dc87 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -23,6 +23,7 @@
 #include <linux/smp.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/stop_machine.h>
 #include <linux/timekeeper_internal.h>
 #include <asm/irq_regs.h>
 #include <asm/traps.h>
@@ -37,7 +38,7 @@
  */
 
 /* How many cycles per second we are running at. */
-static cycles_t cycles_per_sec __write_once;
+static cycles_t cycles_per_sec;
 
 cycles_t get_clock_rate(void)
 {
@@ -68,7 +69,8 @@ EXPORT_SYMBOL(get_cycles);
  */
 #define SCHED_CLOCK_SHIFT 10
 
-static unsigned long sched_clock_mult __write_once;
+static unsigned long sched_clock_mult;
+static long long sched_clock_offset;
 
 static cycles_t clocksource_get_cycles(struct clocksource *cs)
 {
@@ -92,6 +94,7 @@ void __init setup_clock(void)
 	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
 	sched_clock_mult =
 		clocksource_hz2mult(cycles_per_sec, SCHED_CLOCK_SHIFT);
+	sched_clock_offset = 0;
 }
 
 void __init calibrate_delay(void)
@@ -118,14 +121,9 @@ void __init time_init(void)
  * counter, plus bit 31, which signifies that the counter has wrapped
  * from zero to (2**31) - 1.  The INT_TILE_TIMER interrupt will be
  * raised as long as bit 31 is set.
- *
- * The TILE_MINSEC value represents the largest range of real-time
- * we can possibly cover with the timer, based on MAX_TICK combined
- * with the slowest reasonable clock rate we might run at.
  */
 
 #define MAX_TICK 0x7fffffff   /* we have 31 bits of countdown timer */
-#define TILE_MINSEC 5         /* timer covers no more than 5 seconds */
 
 static int tile_timer_set_next_event(unsigned long ticks,
 				     struct clock_event_device *evt)
@@ -146,14 +144,9 @@ static void tile_timer_set_mode(enum clock_event_mode mode,
 	arch_local_irq_mask_now(INT_TILE_TIMER);
 }
 
-/*
- * Set min_delta_ns to 1 microsecond, since it takes about
- * that long to fire the interrupt.
- */
 static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
 	.name = "tile timer",
 	.features = CLOCK_EVT_FEAT_ONESHOT,
-	.min_delta_ns = 1000,
 	.rating = 100,
 	.irq = -1,
 	.set_next_event = tile_timer_set_next_event,
@@ -164,18 +157,18 @@ void __cpuinit setup_tile_timer(void)
 {
 	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
 
-	/* Fill in fields that are speed-specific. */
-	clockevents_calc_mult_shift(evt, cycles_per_sec, TILE_MINSEC);
-	evt->max_delta_ns = clockevent_delta2ns(MAX_TICK, evt);
-
 	/* Mark as being for this cpu only. */
 	evt->cpumask = cpumask_of(smp_processor_id());
 
 	/* Start out with timer not firing. */
 	arch_local_irq_mask_now(INT_TILE_TIMER);
 
-	/* Register tile timer. */
-	clockevents_register_device(evt);
+	/*
+	 * Register tile timer.  Set min_delta to 1 microsecond, since
+	 * it takes about that long to fire the interrupt.
+	 */
+	clockevents_config_and_register(evt, cycles_per_sec,
+					cycles_per_sec / 1000000, MAX_TICK);
 }
 
 /* Called from the interrupt vector. */
@@ -216,8 +209,8 @@ void do_timer_interrupt(struct pt_regs *regs, int fault_num)
  */
 unsigned long long sched_clock(void)
 {
-	return clocksource_cyc2ns(get_cycles(),
-				  sched_clock_mult, SCHED_CLOCK_SHIFT);
+	return clocksource_cyc2ns(get_cycles(), sched_clock_mult,
+				  SCHED_CLOCK_SHIFT) + sched_clock_offset;
 }
 
 int setup_profiling_timer(unsigned int multiplier)
@@ -272,3 +265,140 @@ void update_vsyscall(struct timekeeper *tk)
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
+
+
+#ifdef __tilegx__
+
+/* Arguments to the _set_clock_rate stop_machine() handler. */
+struct _set_clock_rate_args {
+	unsigned int new_rate;
+	int master_cpu;
+};
+
+/*
+ * Flag used to tell other CPUs to proceed once the master CPU has changed
+ * the actual CPU clock rate (barrier is positive), or failed to do so
+ * (barrier is negative).
+ */
+static int _set_clock_rate_barrier;
+
+/* Routine to actually do the clock rate change, called via stop_machine(). */
+static int _set_clock_rate(void *arg)
+{
+	struct _set_clock_rate_args *args = arg;
+	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+
+	/*
+	 * Only one CPU needs to change the timekeeping parameters and
+	 * change the clock rate.
+	 */
+	if (args->master_cpu == smp_processor_id()) {
+		unsigned long long old_sched_clock;
+		long new_speed;
+		cycle_t start_cycle;
+		HV_SetSpeed hvss;
+
+		/*
+		 * Sync up the time before changing the clock rate.  If we
+		 * aren't using the clocksource we think we are, bail.
+		 */
+		if (timekeeping_chfreq_prep(&cycle_counter_cs, &start_cycle)) {
+			smp_wmb();
+			_set_clock_rate_barrier = -1;
+			return -ESRCH;
+		}
+
+		/*
+		 * We'll adjust the offset below so that the new scheduler
+		 * clock matches the value we read here, plus the time
+		 * spent updating the CPU speed.  This causes us to lose a
+		 * tiny bit of time, but it stays monotonic.
+		 */
+		old_sched_clock = sched_clock();
+
+		/* Change the speed.  If that fails, bail. */
+		hvss = hv_set_speed(args->new_rate, start_cycle, 0);
+		new_speed = hvss.new_speed;
+		if (new_speed < 0) {
+			smp_wmb();
+			_set_clock_rate_barrier = -1;
+			return -ENOSYS;
+		}
+
+		/*
+		 * Change the clocksource frequency, and update the
+		 * timekeeping state to account for the time we spent
+		 * changing the speed, then update our internal state.
+		 */
+		timekeeping_chfreq(new_speed, hvss.end_cycle, hvss.delta_ns);
+
+		cycles_per_sec = new_speed;
+
+		sched_clock_mult =
+			clocksource_hz2mult(cycles_per_sec,
+					    SCHED_CLOCK_SHIFT);
+
+		sched_clock_offset = old_sched_clock -
+				     (sched_clock() - sched_clock_offset) +
+				     hvss.delta_ns;
+
+		loops_per_jiffy = cycles_per_sec / HZ;
+
+		smp_wmb();
+		_set_clock_rate_barrier = 1;
+	} else {
+		/* Wait until the master CPU changes the speed, or fails. */
+		while (!_set_clock_rate_barrier)
+			udelay(10);
+	}
+
+	/*
+	 * All CPUs need to change the event timer configuration, but we
+	 * don't want to do anything if the master CPU failed to
+	 * reconfigure the clocksource and change the speed.
+	 */
+	if (_set_clock_rate_barrier < 0)
+		return 0;
+
+	if (clockevents_update_freq(evt, cycles_per_sec) == -ETIME) {
+		/*
+		 * The event that we'd previously been set for is
+		 * in the past.  Instead of just losing it, which
+		 * causes havoc, make it happen right now.
+		 */
+		tile_timer_set_next_event(0, evt);
+	}
+
+	return 0;
+}
+
+/*
+ * Change the clock speed, and return the speed we ended up with; both are
+ * in hertz.
+ */
+unsigned int set_clock_rate(unsigned int new_rate)
+{
+	int stop_status;
+	struct _set_clock_rate_args args = {
+		.new_rate = new_rate,
+		/*
+		 * We just need a valid CPU here; we don't care if we get
+		 * rescheduled somewhere else after we set this.
+		 */
+		.master_cpu = raw_smp_processor_id(),
+	};
+
+	_set_clock_rate_barrier = 0;
+	smp_wmb();
+
+	stop_status = stop_machine(_set_clock_rate, &args,
+				   cpu_online_mask);
+
+	if (stop_status)
+		pr_err("Got unexpected status %d from stop_machine when "
+		       "changing clock speed\n", stop_status);
+
+	return cycles_per_sec;
+};
+
+#endif /* __tilegx__ */
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index d345b5a..6dd8086 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -100,4 +100,5 @@ obj-$(CONFIG_LOONGSON2_CPUFREQ)		+= loongson2_cpufreq.o
 obj-$(CONFIG_SH_CPU_FREQ)		+= sh-cpufreq.o
 obj-$(CONFIG_SPARC_US2E_CPUFREQ)	+= sparc-us2e-cpufreq.o
 obj-$(CONFIG_SPARC_US3_CPUFREQ)		+= sparc-us3-cpufreq.o
+obj-$(CONFIG_CPU_FREQ_TILEGX)		+= tilegx-cpufreq.o
 obj-$(CONFIG_UNICORE32)			+= unicore2-cpufreq.o
diff --git a/drivers/cpufreq/tilegx-cpufreq.c b/drivers/cpufreq/tilegx-cpufreq.c
new file mode 100644
index 0000000..0fc2ee5
--- /dev/null
+++ b/drivers/cpufreq/tilegx-cpufreq.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Support dynamic frequency changes for TILE-Gx.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/timex.h>
+
+static unsigned int tilegx_cpufreq_get(unsigned int cpu)
+{
+	return get_clock_rate() / 1000;
+}
+
+/**
+ * tilegx_cpufreq_target() - set a new CPUFreq policy
+ * @policy:		New policy.
+ * @target_freq:	The target frequency.
+ * @relation:		How that frequency relates to achieved frequency
+ *			(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H).
+ */
+static int tilegx_cpufreq_target(struct cpufreq_policy *policy,
+				 unsigned int target_freq,
+				 unsigned int relation)
+{
+	struct cpufreq_freqs freqs;
+	long new_freq;
+	HV_SetSpeed hvss = hv_set_speed(target_freq * 1000, 0,
+					HV_SET_SPEED_DRYRUN |
+					(relation == CPUFREQ_RELATION_L ?
+					 HV_SET_SPEED_ROUNDUP : 0));
+	new_freq = hvss.new_speed;
+
+	/* If hv_set_speed failed, give up now. */
+	if (new_freq < 0)
+		return -ENOSYS;
+
+	freqs.old = tilegx_cpufreq_get(0);
+	freqs.new = new_freq / 1000;
+
+	/* If they aren't changing the speed, nothing to do. */
+	if (freqs.old == freqs.new)
+		return 0;
+
+	pr_debug("Changing Gx core frequency from %u to %u kHz\n",
+		 freqs.old, freqs.new);
+
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+
+	freqs.new = set_clock_rate(new_freq);
+
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+
+	return 0;
+}
+
+/**
+ * tilegx_cpufreq_verify() - verify a new CPUFreq policy
+ * @policy:		New policy.
+ */
+static int tilegx_cpufreq_verify(struct cpufreq_policy *policy)
+{
+	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
+				     policy->cpuinfo.max_freq);
+	return 0;
+}
+
+/**
+ * tilegx_cpufreq_cpu_init() - configure the TILE-Gx CPUFreq driver
+ * @policy:		Policy.
+ */
+static int tilegx_cpufreq_cpu_init(struct cpufreq_policy *policy)
+{
+	unsigned int speed = tilegx_cpufreq_get(policy->cpu);
+	HV_SetSpeed hvss;
+
+	if (!speed)
+		return -EIO;
+
+	/* All of our CPUs share the same speed. */
+	cpumask_copy(policy->cpus, cpu_online_mask);
+
+	/* Set cpuinfo and default policy values. */
+	policy->cur = speed;
+
+	hvss = hv_set_speed(0, 0, HV_SET_SPEED_DRYRUN | HV_SET_SPEED_ROUNDUP);
+	if (hvss.new_speed < 0)
+		return -EPERM;
+	policy->cpuinfo.min_freq = hvss.new_speed / 1000;
+
+	hvss = hv_set_speed(LONG_MAX, 0, HV_SET_SPEED_DRYRUN);
+	if (hvss.new_speed < 0)
+		return -EPERM;
+	policy->cpuinfo.max_freq = hvss.new_speed / 1000;
+
+	/*
+	 * This is worst-case, going from 40 MHz to 1200 MHz with voltage
+	 * scaling enabled.  If you aren't doing anything that extreme,
+	 * it'll be a lot lower, and you could reasonably tweak the
+	 * governor sampling rate down via sysfs.
+	 */
+	policy->cpuinfo.transition_latency = 4200000;
+
+	policy->cur = speed;
+	policy->min = policy->cpuinfo.min_freq;
+	policy->max = policy->cpuinfo.max_freq;
+
+	policy->shared_type = CPUFREQ_SHARED_TYPE_ANY;
+
+	return 0;
+}
+
+/**
+ * tilegx_cpufreq_cpu_exit() - deconfigure the TILE-Gx CPUFreq driver
+ * @policy:		Policy.
+ */
+static int tilegx_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	return 0;
+}
+
+/* TILE-Gx CPUFreq attributes. */
+static struct freq_attr *tilegx_cpufreq_attr[] = {
+	NULL,
+};
+
+/* TILE-Gx CPUFreq operations vector. */
+static struct cpufreq_driver tilegx_cpufreq_driver = {
+	.name	= "tilegx_cpufreq",
+	.verify	= tilegx_cpufreq_verify,
+	.target	= tilegx_cpufreq_target,
+	.init	= tilegx_cpufreq_cpu_init,
+	.exit	= tilegx_cpufreq_cpu_exit,
+	.get	= tilegx_cpufreq_get,
+	.owner	= THIS_MODULE,
+	.attr	= tilegx_cpufreq_attr,
+};
+
+/* Initialize the TILE-Gx CPUFreq driver. */
+static int __init tilegx_cpufreq_init(void)
+{
+	return cpufreq_register_driver(&tilegx_cpufreq_driver);
+}
+
+/* Remove the TILE-Gx CPUFreq driver. */
+static void __exit tilegx_cpufreq_exit(void)
+{
+	cpufreq_unregister_driver(&tilegx_cpufreq_driver);
+}
+
+MODULE_AUTHOR("Tilera Corporation");
+MODULE_DESCRIPTION("CPU Frequency driver for TILE-Gx");
+MODULE_LICENSE("GPL");
+
+module_init(tilegx_cpufreq_init);
+module_exit(tilegx_cpufreq_exit);
-- 
1.8.3.1

