Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbbAWALw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:11:52 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36410 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbbAWAJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:38 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/12] clocksource: Add max_cycles to clocksource structure
Date: Thu, 22 Jan 2015 16:09:19 -0800
Message-Id: <1421971767-17707-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to facilitate some clocksource validation,
add a max_cycles entry to the structure which will
hold the maximum cycle value that can safely be
multiplied without potentially causing an overflow.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/clocksource.h |  6 ++++--
 kernel/time/clocksource.c   | 15 ++++++++++++---
 kernel/time/sched_clock.c   |  2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index abcafaa..32dced9 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -158,6 +158,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @shift:		cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @maxadj:		maximum adjustment value to mult (~11%)
+ * @max_cycles:		maximum safe cycle value which won't overflow on mult
  * @flags:		flags describing special properties
  * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
@@ -178,7 +179,7 @@ struct clocksource {
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
 #endif
-
+	u64 max_cycles;
 	const char *name;
 	struct list_head list;
 	int rating;
@@ -291,7 +292,8 @@ extern struct clocksource * __init clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 extern u64
-clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask);
+clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask,
+							u64 *max_cycles);
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0696559..c2f8639 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -545,11 +545,14 @@ static u32 clocksource_max_adjustment(struct clocksource *cs)
  * @shift:	cycle to nanosecond divisor (power of two)
  * @maxadj:	maximum adjustment value to mult (~11%)
  * @mask:	bitmask for two's complement subtraction of non 64 bit counters
+ * @max_cyc:    maximum cycle value before potential overflow (does not include
+ *		any saftey margin)
  *
  * NOTE: This function includes a saftey margin of 50%, so that bad clock values
  * can be detected.
  */
-u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
+u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask,
+								u64 *max_cyc)
 {
 	u64 max_nsecs, max_cycles;
 
@@ -569,6 +572,10 @@ u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 	max_cycles = min(max_cycles, mask);
 	max_nsecs = clocksource_cyc2ns(max_cycles, mult - maxadj, shift);
 
+	/* return the max_cycles value as well if requested */
+	if (max_cyc)
+		*max_cyc = max_cycles;
+
 	/* Return 50% of the actual maximum, so we can detect bad values */
 	max_nsecs >>= 1;
 
@@ -747,7 +754,8 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	}
 
 	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
-						 cs->maxadj, cs->mask);
+						 cs->maxadj, cs->mask,
+						 &cs->max_cycles);
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
 
@@ -795,7 +803,8 @@ int clocksource_register(struct clocksource *cs)
 
 	/* calculate max idle time permitted for this clocksource */
 	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
-						 cs->maxadj, cs->mask);
+						 cs->maxadj, cs->mask,
+						 &cs->max_cycles);
 
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index c794b84..d43855b 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -126,7 +126,7 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 	new_mask = CLOCKSOURCE_MASK(bits);
 
 	/* calculate how many ns until we risk wrapping */
-	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
+	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask, NULL);
 	new_wrap_kt = ns_to_ktime(wrap);
 
 	/* update epoch for new counter and update epoch_ns from old counter*/
-- 
1.9.1

