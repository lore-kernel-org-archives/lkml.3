Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861Ab3GRXZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:25:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58717 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934595Ab3GRXVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 04/17] sched_clock: Add support for >32 bit sched_clock
Date: Thu, 18 Jul 2013 16:21:17 -0700
Message-Id: <1374189690-10810-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM architected system counter has at least 56 usable bits.
Add support for counters with more than 32 bits to the generic
sched_clock implementation so we can increase the time between
wakeups due to dealing with wrap-around on these devices while
benefiting from the irqtime accounting and suspend/resume
handling that the generic sched_clock code already has. On my
system using 56 bits over 32 bits changes the wraparound time
from a few minutes to an hour. For faster running counters (GHz
range) this is even more important because we may not be able to
execute the timer in time to deal with the wraparound if only 32
bits are used.

We choose a maxsec value of 3600 seconds because we assume no
system will go idle for more than an hour. In the future we may
need to increase this value.

Note: All users should switch over to the 64-bit read function so
we can remove setup_sched_clock() in favor of sched_clock_register().

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/sched_clock.h |  2 ++
 kernel/time/sched_clock.c   | 46 +++++++++++++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index fa7922c..eca7abe 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -15,6 +15,8 @@ static inline void sched_clock_postinit(void) { }
 #endif
 
 extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
+extern void sched_clock_register(u64 (*read)(void), int bits,
+				 unsigned long rate);
 
 extern unsigned long long (*sched_clock_func)(void);
 
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index a269890b..3aa83ba 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -16,11 +16,12 @@
 #include <linux/hrtimer.h>
 #include <linux/sched_clock.h>
 #include <linux/seqlock.h>
+#include <linux/bitops.h>
 
 struct clock_data {
 	ktime_t wrap_kt;
 	u64 epoch_ns;
-	u32 epoch_cyc;
+	u64 epoch_cyc;
 	seqcount_t seq;
 	unsigned long rate;
 	u32 mult;
@@ -37,14 +38,25 @@ static struct clock_data cd = {
 	.mult	= NSEC_PER_SEC / HZ,
 };
 
-static u32 __read_mostly sched_clock_mask = 0xffffffff;
+static u64 __read_mostly sched_clock_mask;
 
-static u32 notrace jiffy_sched_clock_read(void)
+static u64 notrace jiffy_sched_clock_read(void)
 {
-	return (u32)(jiffies - INITIAL_JIFFIES);
+	/*
+	 * We don't need to use get_jiffies_64 on 32-bit arches here
+	 * because we register with BITS_PER_LONG
+	 */
+	return (u64)(jiffies - INITIAL_JIFFIES);
+}
+
+static u32 __read_mostly (*read_sched_clock_32)(void);
+
+static u64 notrace read_sched_clock_32_wrapper(void)
+{
+	return read_sched_clock_32();
 }
 
-static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
+static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
 static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
@@ -54,8 +66,8 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 static unsigned long long notrace sched_clock_32(void)
 {
 	u64 epoch_ns;
-	u32 epoch_cyc;
-	u32 cyc;
+	u64 epoch_cyc;
+	u64 cyc;
 	unsigned long seq;
 
 	if (cd.suspended)
@@ -78,7 +90,7 @@ static unsigned long long notrace sched_clock_32(void)
 static void notrace update_sched_clock(void)
 {
 	unsigned long flags;
-	u32 cyc;
+	u64 cyc;
 	u64 ns;
 
 	cyc = read_sched_clock();
@@ -101,7 +113,8 @@ static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
 	return HRTIMER_RESTART;
 }
 
-void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+void __init sched_clock_register(u64 (*read)(void), int bits,
+				 unsigned long rate)
 {
 	unsigned long r;
 	u64 res, wrap;
@@ -110,14 +123,13 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	if (cd.rate > rate)
 		return;
 
-	BUG_ON(bits > 32);
 	WARN_ON(!irqs_disabled());
 	read_sched_clock = read;
-	sched_clock_mask = (1 << bits) - 1;
+	sched_clock_mask = CLOCKSOURCE_MASK(bits);
 	cd.rate = rate;
 
 	/* calculate the mult/shift to convert counter ticks to ns. */
-	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
+	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 3600);
 
 	r = rate;
 	if (r >= 4000000) {
@@ -130,7 +142,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 		r_unit = ' ';
 
 	/* calculate how many ns until we wrap */
-	wrap = cyc_to_ns((1ULL << bits) - 1, cd.mult, cd.shift);
+	wrap = clocks_calc_max_nsecs(cd.mult, cd.shift, 0, sched_clock_mask);
 	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
 
 	/* calculate the ns resolution of this counter */
@@ -158,6 +170,12 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
+void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+{
+	read_sched_clock_32 = read;
+	sched_clock_register(read_sched_clock_32_wrapper, bits, rate);
+}
+
 unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
 
 unsigned long long notrace sched_clock(void)
@@ -172,7 +190,7 @@ void __init sched_clock_postinit(void)
 	 * make it the final one one.
 	 */
 	if (read_sched_clock == jiffy_sched_clock_read)
-		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
+		sched_clock_register(jiffy_sched_clock_read, BITS_PER_LONG, HZ);
 
 	update_sched_clock();
 	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

