Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbbAWALK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:11:10 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36646 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbbAWAJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:45 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 10/12] clocksource: Mostly kill clocksource_register()
Date: Thu, 22 Jan 2015 16:09:25 -0800
Message-Id: <1421971767-17707-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long running project has been to cleanup remaining uses
of clocksource_register(), replacing it with the simpler
clocksource_register_khz/hz().

However, there are a few cases where we need to self-define
our mult/shift values, so switch the function to a more
obviously internal __clocksource_register(), and consolidate
much of the internal logic so we don't have duplication.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/s390/kernel/time.c     |  2 +-
 arch/sparc/kernel/time_32.c |  2 +-
 include/linux/clocksource.h | 10 +++++-
 kernel/time/clocksource.c   | 83 +++++++++++++++++++--------------------------
 kernel/time/jiffies.c       |  4 +--
 5 files changed, 47 insertions(+), 54 deletions(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 20660dd..6c273cd 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -283,7 +283,7 @@ void __init time_init(void)
 	if (register_external_irq(EXT_IRQ_TIMING_ALERT, timing_alert_interrupt))
 		panic("Couldn't request external interrupt 0x1406");
 
-	if (clocksource_register(&clocksource_tod) != 0)
+	if (__clocksource_register(&clocksource_tod) != 0)
 		panic("Could not register TOD clock source");
 
 	/* Enable TOD clock interrupts on the boot cpu. */
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 2f80d23..a31c0c8 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -191,7 +191,7 @@ static __init int setup_timer_cs(void)
 	timer_cs.mult = clocksource_hz2mult(sparc_config.clock_rate,
 	                                    timer_cs.shift);
 
-	return clocksource_register(&timer_cs);
+	return __clocksource_register(&timer_cs);
 }
 
 #ifdef CONFIG_SMP
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 32dced9..61236f8 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -281,7 +281,6 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 }
 
 
-extern int clocksource_register(struct clocksource*);
 extern int clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
@@ -306,6 +305,15 @@ __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
 extern void
 __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq);
 
+/*
+ * Dont' call this unless you're a default clocksource
+ * (AKA: jiffies) and absolutely have to.
+ */
+static inline int __clocksource_register(struct clocksource *cs)
+{
+	return __clocksource_register_scale(cs, 1, 0);
+}
+
 static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
 {
 	return __clocksource_register_scale(cs, 1, hz);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 4aca66d..b56f4b9 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -724,38 +724,52 @@ static void clocksource_enqueue(struct clocksource *cs)
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 	u64 sec;
+
 	/*
-	 * Calc the maximum number of seconds which we can run before
-	 * wrapping around. For clocksources which have a mask > 32bit
-	 * we need to limit the max sleep time to have a good
-	 * conversion precision. 10 minutes is still a reasonable
-	 * amount. That results in a shift value of 24 for a
-	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
-	 * ~ 0.06ppm granularity for NTP.
+	 * Default clocksources are *special* and self-define their mult/shift.
+	 * But, you're not special, so you should specify a freq value.
 	 */
-	sec = cs->mask;
-	do_div(sec, freq);
-	do_div(sec, scale);
-	if (!sec)
-		sec = 1;
-	else if (sec > 600 && cs->mask > UINT_MAX)
-		sec = 600;
-
-	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
-			       NSEC_PER_SEC / scale, sec * scale);
-
+	if (freq) {
+		/*
+		 * Calc the maximum number of seconds which we can run before
+		 * wrapping around. For clocksources which have a mask > 32bit
+		 * we need to limit the max sleep time to have a good
+		 * conversion precision. 10 minutes is still a reasonable
+		 * amount. That results in a shift value of 24 for a
+		 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
+		 * ~ 0.06ppm granularity for NTP.
+		 */
+		sec = cs->mask;
+		do_div(sec, freq);
+		do_div(sec, scale);
+		if (!sec)
+			sec = 1;
+		else if (sec > 600 && cs->mask > UINT_MAX)
+			sec = 600;
+
+		clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
+				       NSEC_PER_SEC / scale, sec * scale);
+	}
 	/*
 	 * Ensure clocksources that have large mults don't overflow
 	 * when adjusted.
 	 */
 	cs->maxadj = clocksource_max_adjustment(cs);
-	while ((cs->mult + cs->maxadj < cs->mult)
-		|| (cs->mult - cs->maxadj > cs->mult)) {
+	while (freq && ((cs->mult + cs->maxadj < cs->mult)
+		|| (cs->mult - cs->maxadj > cs->mult))) {
 		cs->mult >>= 1;
 		cs->shift--;
 		cs->maxadj = clocksource_max_adjustment(cs);
 	}
 
+	/*
+	 * Only warn for *special* clocksources that self-define
+	 * their mult/shift values and don't specify a freq.
+	 */
+	WARN_ONCE(cs->mult + cs->maxadj < cs->mult,
+		"Clocksource %s might overflow on 11%% adjustment\n",
+		cs->name);
+
 	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
 						 cs->maxadj, cs->mask,
 						 &cs->max_cycles);
@@ -789,35 +803,6 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 }
 EXPORT_SYMBOL_GPL(__clocksource_register_scale);
 
-
-/**
- * clocksource_register - Used to install new clocksources
- * @cs:		clocksource to be registered
- *
- * Returns -EBUSY if registration fails, zero otherwise.
- */
-int clocksource_register(struct clocksource *cs)
-{
-	/* calculate max adjustment for given mult/shift */
-	cs->maxadj = clocksource_max_adjustment(cs);
-	WARN_ONCE(cs->mult + cs->maxadj < cs->mult,
-		"Clocksource %s might overflow on 11%% adjustment\n",
-		cs->name);
-
-	/* calculate max idle time permitted for this clocksource */
-	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
-						 cs->maxadj, cs->mask,
-						 &cs->max_cycles);
-
-	mutex_lock(&clocksource_mutex);
-	clocksource_enqueue(cs);
-	clocksource_enqueue_watchdog(cs);
-	clocksource_select();
-	mutex_unlock(&clocksource_mutex);
-	return 0;
-}
-EXPORT_SYMBOL(clocksource_register);
-
 static void __clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	list_del(&cs->list);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 7e41390..c4bb518 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -95,7 +95,7 @@ EXPORT_SYMBOL(jiffies);
 
 static int __init init_jiffies_clocksource(void)
 {
-	return clocksource_register(&clocksource_jiffies);
+	return __clocksource_register(&clocksource_jiffies);
 }
 
 core_initcall(init_jiffies_clocksource);
@@ -131,6 +131,6 @@ int register_refined_jiffies(long cycles_per_second)
 
 	refined_jiffies.mult = ((u32)nsec_per_tick) << JIFFIES_SHIFT;
 
-	clocksource_register(&refined_jiffies);
+	__clocksource_register(&refined_jiffies);
 	return 0;
 }
-- 
1.9.1

