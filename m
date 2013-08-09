Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031097Ab3HIUr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:47:29 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55214 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031057Ab3HIUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:47:27 -0400
Message-ID: <377cf030524ac2530f7651699ca812aa6e53978c.1376080997.git.cmetcalf@tilera.com>
In-Reply-To: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com>
References: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 15:34:38 -0400
Subject: [PATCH v2 1/2] time: allow changing the timekeeper clock frequency
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

On the tile architecture, we use the processor clock tick as the time
source.  However, when we perform dynamic frequency adjustment and
modify the clock rate of the core, we have to update the timekeeper
state to account for the new frequency, as well as for the time it took
to actually modify the frequency across the chip as a whole.

This change introduces two new functions, timekeeping_chfreq(), which
changes the frequency, plus timekeeping_chfreq_prep(), used to put the
timekeeping system in a state that is ready for a frequency change.
More information is in the comments for the new functions.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
v1: If these patches are OK, I can push them as part of the tile tree.
Otherwise, they should probably be pushed through a single tree either
by the timekeeping folks or (more likely?) the cpu frequency driver folks.
Let me know what makes the most sense; for now they are in tile-next.

v2: use do_div() in timekeeping_chfreq() to avoid build failures on i386
(no change to patch 2/2, the cpufreq driver)

 include/linux/clocksource.h |  5 +++
 kernel/time/timekeeping.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index dbbf8aa..423cb82 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -327,6 +327,11 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 
 extern int timekeeping_notify(struct clocksource *clock);
 
+extern int timekeeping_chfreq_prep(struct clocksource *clock, cycle_t
+				   *start_cycle);
+extern void timekeeping_chfreq(unsigned int freq, cycle_t end_cycle,
+			       u64 delta_ns);
+
 extern cycle_t clocksource_mmio_readl_up(struct clocksource *);
 extern cycle_t clocksource_mmio_readl_down(struct clocksource *);
 extern cycle_t clocksource_mmio_readw_up(struct clocksource *);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 48b9fff..03a14bf 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1737,3 +1737,84 @@ void xtime_update(unsigned long ticks)
 	do_timer(ticks);
 	write_sequnlock(&jiffies_lock);
 }
+
+/**
+ * timekeeping_chfreq_prep() - prepare to change the frequency of the
+ *    clocksource being used for timekeeping
+ * @clock:		Pointer to the clock source whose frequency will be
+ *			changed.  If this is not the clocksource being used
+ *			or timekeeping, the routine does nothing and
+ *			returns nonzero; otherwise, it prepares for the
+ *			frequency change and returns zero.
+ * @start_cycle:	Pointer to a value which will be set to the current
+ *			cycle count for @clock, in the old clock domain.
+ *
+ * This routine is used when changing processor speed on a system whose
+ * clocksource is dependent upon that speed.  The normal calling sequence
+ * is:
+ *
+ * - Call timekeeping_chfreq_prep(), to get ready for the change and to
+ *   ensure that the current clocksource is what you think it is.
+ *
+ * - Change the actual processor speed.
+ *
+ * - Call timkeeping_chfreq() to change the clocksource frequency and
+ *   adjust the timekeeping parameters to account for the time spent
+ *   doing the frequency change.
+ *
+ * Any timekeeping operations performed while this is happening are likely
+ * to cause problems.  The best way to prevent this from happening is to
+ * perform all of those steps in a routine run via stop_machine().
+ */
+int timekeeping_chfreq_prep(struct clocksource *clock, cycle_t *start_cycle)
+{
+	if (timekeeper.clock != clock)
+		return 1;
+
+	timekeeping_forward_now(&timekeeper);
+	*start_cycle = timekeeper.clock->cycle_last;
+
+	return 0;
+}
+
+/**
+ * timekeeping_chfreq() - change the frequency of the clocksource being
+ *   used for timekeeping, and then recompute the internal timekeeping
+ *   parameters which depend upon that
+ * @freq:		New frequency for the clocksource, in hertz.
+ * @end_cycle:		Cycle count, in the new clock domain.
+ * @delta_ns:		Time delta in ns between start_cycle (as returned
+ *			from timekeeping_chfreq_prep()) and end_cycle.
+ *
+ * See the timekeeping_chfreq_prep() description for how this routine is
+ * used.
+ */
+void timekeeping_chfreq(unsigned int freq, cycle_t end_cycle, u64 delta_ns)
+{
+	struct clocksource *clock = timekeeper.clock;
+	cycle_t delta_cycles;
+
+	write_seqlock(&jiffies_lock);
+	__clocksource_updatefreq_hz(clock, freq);
+	tk_setup_internals(&timekeeper, clock);
+
+	/*
+	 * The timekeeping_forward_now() done in timekeeping_chfreq_prep()
+	 * made xtime consistent with the timesource as of a cycle count
+	 * which was provided to the caller as *start_cycle.  Then, we
+	 * spent a bunch of time actually changing the processor frequency.
+	 * Finally, timekeeper_setup_internals() updated cycle_last in the
+	 * clocksource to match the current cycle count, but didn't update
+	 * xtime.  Thus, the current time is now wrong by the time we spent
+	 * doing the frequency change.  To fix this, we need to backdate
+	 * the clocksource's cycle_last so that it is again consistent with
+	 * xtime.
+	 */
+	delta_cycles = delta_ns * freq;
+	do_div(delta_cycles, 1000000000);
+	clock->cycle_last = end_cycle - delta_cycles;
+
+	write_sequnlock(&jiffies_lock);
+
+	tick_clock_notify();
+}
-- 
1.8.3.1

