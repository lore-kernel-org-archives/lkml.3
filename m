Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbbABXRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:17:53 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38089 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbABXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:17:51 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] time: Add debugging checks to warn if we see delays
Date: Fri,  2 Jan 2015 15:17:41 -0800
Message-Id: <1420240661-8115-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently there's been some request for better sanity
checking in the time code, so that its more clear
when something is going wrong since timekeeping issues
could manifest in a large number of strange ways with
various subsystems.

Thus, this patch adds some extra infrastructure to
save the maximum cycle value that can be used before
we see multiplicaiton overflows, and adds a check
in update_wall_time to print warnings if we see the
call delayed beyond the overflow point, or beyond the
clocksource max_idle_ns value which is currently 87.5%
of the overflow point.

Tested this a bit by halting qemu for specified
lengths of time to trigger the warnings.

This still needs some work, but wanted to send it out
for some initial feedback and testing.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Mason <clm@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/clocksource.h |  3 +++
 kernel/time/clocksource.c   | 27 +++++++++++++++++++++++----
 kernel/time/jiffies.c       |  1 +
 kernel/time/timekeeping.c   | 18 ++++++++++++++++++
 4 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index abcafaa..5c892e1 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -174,6 +174,7 @@ struct clocksource {
 	u32 mult;
 	u32 shift;
 	u64 max_idle_ns;
+	cycle_t max_cycles;
 	u32 maxadj;
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
@@ -291,6 +292,8 @@ extern struct clocksource * __init clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 extern u64
+clocks_calc_max_cycles(u32 mult, u32 maxadj, u64 mask);
+extern u64
 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask);
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index b79f39b..6384783 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -540,15 +540,14 @@ static u32 clocksource_max_adjustment(struct clocksource *cs)
 }
 
 /**
- * clocks_calc_max_nsecs - Returns maximum nanoseconds that can be converted
+ * clocks_calc_max_cycles - Returns maximum cycles that can be converted to nsecs
  * @mult:	cycle to nanosecond multiplier
- * @shift:	cycle to nanosecond divisor (power of two)
  * @maxadj:	maximum adjustment value to mult (~11%)
  * @mask:	bitmask for two's complement subtraction of non 64 bit counters
  */
-u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
+u64 clocks_calc_max_cycles(u32 mult, u32 maxadj, u64 mask)
 {
-	u64 max_nsecs, max_cycles;
+	u64 max_cycles;
 
 	/*
 	 * Calculate the maximum number of cycles that we can pass to the
@@ -569,6 +568,24 @@ u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 	/*
 	 * The actual maximum number of cycles we can defer the clocksource is
 	 * determined by the minimum of max_cycles and mask.
+	 */
+	return min(max_cycles, mask);
+}
+
+
+/**
+ * clocks_calc_max_nsecs - Returns maximum nanoseconds that can be converted
+ * @mult:	cycle to nanosecond multiplier
+ * @shift:	cycle to nanosecond divisor (power of two)
+ * @maxadj:	maximum adjustment value to mult (~11%)
+ * @mask:	bitmask for two's complement subtraction of non 64 bit counters
+ */
+u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
+{
+	u64 max_nsecs, max_cycles;
+
+	max_cycles = clocks_calc_max_cycles(mult, maxadj, mask);
+	/*
 	 * Note: Here we subtract the maxadj to make sure we don't sleep for
 	 * too long if there's a large negative adjustment.
 	 */
@@ -771,6 +788,7 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 		cs->maxadj = clocksource_max_adjustment(cs);
 	}
 
+	cs->max_cycles = clocks_calc_max_cycles(cs->mult, cs->maxadj, cs->mask);
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
@@ -818,6 +836,7 @@ int clocksource_register(struct clocksource *cs)
 		cs->name);
 
 	/* calculate max idle time permitted for this clocksource */
+	cs->max_cycles = clocks_calc_max_cycles(cs->mult, cs->maxadj, cs->mask);
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 
 	mutex_lock(&clocksource_mutex);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a6a5bf5..7e41390 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -71,6 +71,7 @@ static struct clocksource clocksource_jiffies = {
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
+	.max_cycles	= 10,
 };
 
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(jiffies_lock);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..c7f0dd6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1319,6 +1319,22 @@ static int __init timekeeping_init_ops(void)
 }
 device_initcall(timekeeping_init_ops);
 
+static void timekeeping_check_offset(struct timekeeper *tk, cycle_t offset)
+{
+
+	cycle_t max_cycles = tk->tkr.clock->max_cycles;
+	const char *name = tk->tkr.clock->name;
+
+	if (offset > max_cycles)
+		printk("ERROR: cycle offset (%lld) is larger then"
+			" allowed %s max_cycles (%lld)\n",
+			offset, name, max_cycles);
+	else if (offset > (max_cycles - (max_cycles >> 3)))
+		printk("WARNING: cycle offset (%lld) is too close"
+			" to %s max_cycles overflow margin (%lld)\n",
+			offset, name, max_cycles);
+}
+
 /*
  * Apply a multiplier adjustment to the timekeeper
  */
@@ -1602,6 +1618,8 @@ void update_wall_time(void)
 	if (offset < real_tk->cycle_interval)
 		goto out;
 
+	timekeeping_check_offset(real_tk, offset);
+
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
-- 
1.9.1

