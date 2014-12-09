Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaLINVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:21:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:48445 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbaLINVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:21:48 -0500
Date: Tue, 9 Dec 2014 14:21:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer core changes for 3.19
Message-ID: <alpine.DEB.2.11.1412091416150.16275@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

The time(r) departement provides:
 - More infrastructure work on the year 2038 issue
 - A few fixes in the Armada SoC timers  
 - The usual pile of fixlets and improvements

Thanks,

	tglx

------------------>
Ezequiel Garcia (3):
      clocksource: armada-370-xp: Add missing clock enable
      watchdog: orion: Use the reference clock on Armada 375 SoC
      clocksource: armada-370-xp: Use the reference clock on A375 SoC

John Stultz (7):
      time: Rename udelay_test.c to test_udelay.c
      time: Expose getrawmonotonic64 for in-kernel uses
      time: Expose get_monotonic_coarse64() for in-kernel uses
      time: Fixup comments to reflect usage of timespec64
      rtc: Update suspend/resume timing to use 64bit time
      time: Remove timekeeping_inject_sleeptime()
      time: Fix sign bug in NTP mult overflow warning

Yanchang Li (1):
      clocksource: sirf: Remove hard-coded clock rate

pang.xunlei (6):
      time: Avoid possible NTP adjustment mult overflow.
      time: Complete NTP adjustment threshold judging conditions
      time: Provide y2038 safe do_settimeofday() replacement
      time: Provide y2038 safe timekeeping_inject_sleeptime() replacement
      time: Provide y2038 safe mktime() replacement
      rtc/lib: Provide y2038 safe rtc_tm_to_time()/rtc_time_to_tm() replacement


 .../bindings/timer/marvell,armada-370-xp-timer.txt |  9 ++--
 .../devicetree/bindings/watchdog/marvel.txt        | 13 +++++
 drivers/clocksource/time-armada-370-xp.c           | 30 +++++++++++
 drivers/clocksource/timer-marco.c                  | 23 ++++-----
 drivers/rtc/class.c                                | 30 +++++------
 drivers/rtc/rtc-lib.c                              | 38 +++++++-------
 drivers/watchdog/orion_wdt.c                       | 42 ++++++++++++++-
 include/linux/rtc.h                                | 21 +++++++-
 include/linux/time.h                               | 17 +++++--
 include/linux/timekeeping.h                        | 49 ++++++++++++++++--
 kernel/time/Makefile                               |  2 +-
 kernel/time/{udelay_test.c => test_udelay.c}       |  0
 kernel/time/time.c                                 | 20 +++-----
 kernel/time/timekeeping.c                          | 59 ++++++++++++----------
 14 files changed, 253 insertions(+), 100 deletions(-)
 rename kernel/time/{udelay_test.c => test_udelay.c} (100%)

diff --git a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
index f455182b1086..e9c78ce880e6 100644
--- a/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
+++ b/Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
@@ -2,8 +2,10 @@ Marvell Armada 370 and Armada XP Timers
 ---------------------------------------
 
 Required properties:
-- compatible: Should be either "marvell,armada-370-timer" or
-  "marvell,armada-xp-timer" as appropriate.
+- compatible: Should be one of the following
+              "marvell,armada-370-timer",
+	      "marvell,armada-375-timer",
+	      "marvell,armada-xp-timer".
 - interrupts: Should contain the list of Global Timer interrupts and
   then local timer interrupts
 - reg: Should contain location and length for timers register. First
@@ -13,7 +15,8 @@ Required properties:
 Clocks required for compatible = "marvell,armada-370-timer":
 - clocks : Must contain a single entry describing the clock input
 
-Clocks required for compatible = "marvell,armada-xp-timer":
+Clocks required for compatibles = "marvell,armada-xp-timer",
+				  "marvell,armada-375-timer":
 - clocks : Must contain an entry for each entry in clock-names.
 - clock-names : Must include the following entries:
   "nbclk" (L2/coherency fabric clock),
diff --git a/Documentation/devicetree/bindings/watchdog/marvel.txt b/Documentation/devicetree/bindings/watchdog/marvel.txt
index 97223fddb7bd..858ed9221ac4 100644
--- a/Documentation/devicetree/bindings/watchdog/marvel.txt
+++ b/Documentation/devicetree/bindings/watchdog/marvel.txt
@@ -17,6 +17,18 @@ For "marvell,armada-375-wdt" and "marvell,armada-380-wdt":
 - reg		: A third entry is mandatory and should contain the
                   shared mask/unmask RSTOUT address.
 
+Clocks required for compatibles = "marvell,orion-wdt",
+				  "marvell,armada-370-wdt":
+- clocks : Must contain a single entry describing the clock input
+
+Clocks required for compatibles = "marvell,armada-xp-wdt"
+				  "marvell,armada-375-wdt"
+				  "marvell,armada-380-wdt":
+- clocks : Must contain an entry for each entry in clock-names.
+- clock-names : Must include the following entries:
+  "nbclk" (L2/coherency fabric clock),
+  "fixed" (Reference 25 MHz fixed-clock).
+
 Optional properties:
 
 - interrupts	: Contains the IRQ for watchdog expiration
@@ -30,4 +42,5 @@ Example:
 		interrupts = <3>;
 		timeout-sec = <10>;
 		status = "okay";
+		clocks = <&gate_clk 7>;
 	};
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 0451e62fac7a..3a0704b0d739 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -293,6 +293,7 @@ static void __init armada_xp_timer_init(struct device_node *np)
 
 	/* The 25Mhz fixed clock is mandatory, and must always be available */
 	BUG_ON(IS_ERR(clk));
+	clk_prepare_enable(clk);
 	timer_clk = clk_get_rate(clk);
 
 	armada_370_xp_timer_common_init(np);
@@ -300,11 +301,40 @@ static void __init armada_xp_timer_init(struct device_node *np)
 CLOCKSOURCE_OF_DECLARE(armada_xp, "marvell,armada-xp-timer",
 		       armada_xp_timer_init);
 
+static void __init armada_375_timer_init(struct device_node *np)
+{
+	struct clk *clk;
+
+	clk = of_clk_get_by_name(np, "fixed");
+	if (!IS_ERR(clk)) {
+		clk_prepare_enable(clk);
+		timer_clk = clk_get_rate(clk);
+	} else {
+
+		/*
+		 * This fallback is required in order to retain proper
+		 * devicetree backwards compatibility.
+		 */
+		clk = of_clk_get(np, 0);
+
+		/* Must have at least a clock */
+		BUG_ON(IS_ERR(clk));
+		clk_prepare_enable(clk);
+		timer_clk = clk_get_rate(clk) / TIMER_DIVIDER;
+		timer25Mhz = false;
+	}
+
+	armada_370_xp_timer_common_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(armada_375, "marvell,armada-375-timer",
+		       armada_375_timer_init);
+
 static void __init armada_370_timer_init(struct device_node *np)
 {
 	struct clk *clk = of_clk_get(np, 0);
 
 	BUG_ON(IS_ERR(clk));
+	clk_prepare_enable(clk);
 	timer_clk = clk_get_rate(clk) / TIMER_DIVIDER;
 	timer25Mhz = false;
 
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index caf7a2030461..361a789d4bee 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -20,8 +20,6 @@
 #include <linux/of_address.h>
 #include <linux/sched_clock.h>
 
-#define MARCO_CLOCK_FREQ 1000000
-
 #define SIRFSOC_TIMER_32COUNTER_0_CTRL			0x0000
 #define SIRFSOC_TIMER_32COUNTER_1_CTRL			0x0004
 #define SIRFSOC_TIMER_MATCH_0				0x0018
@@ -40,6 +38,8 @@
 
 #define SIRFSOC_TIMER_REG_CNT 6
 
+static unsigned long marco_timer_rate;
+
 static const u32 sirfsoc_timer_reg_list[SIRFSOC_TIMER_REG_CNT] = {
 	SIRFSOC_TIMER_WATCHDOG_EN,
 	SIRFSOC_TIMER_32COUNTER_0_CTRL,
@@ -195,7 +195,7 @@ static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
 	ce->rating = 200;
 	ce->set_mode = sirfsoc_timer_set_mode;
 	ce->set_next_event = sirfsoc_timer_set_next_event;
-	clockevents_calc_mult_shift(ce, MARCO_CLOCK_FREQ, 60);
+	clockevents_calc_mult_shift(ce, marco_timer_rate, 60);
 	ce->max_delta_ns = clockevent_delta2ns(-2, ce);
 	ce->min_delta_ns = clockevent_delta2ns(2, ce);
 	ce->cpumask = cpumask_of(cpu);
@@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
 /* initialize the kernel jiffy timer source */
 static void __init sirfsoc_marco_timer_init(struct device_node *np)
 {
-	unsigned long rate;
 	u32 timer_div;
 	struct clk *clk;
 
@@ -266,16 +265,12 @@ static void __init sirfsoc_marco_timer_init(struct device_node *np)
 
 	BUG_ON(clk_prepare_enable(clk));
 
-	rate = clk_get_rate(clk);
-
-	BUG_ON(rate < MARCO_CLOCK_FREQ);
-	BUG_ON(rate % MARCO_CLOCK_FREQ);
+	marco_timer_rate = clk_get_rate(clk);
 
-	/* Initialize the timer dividers */
-	timer_div = rate / MARCO_CLOCK_FREQ - 1;
-	writel_relaxed(timer_div << 16, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
-	writel_relaxed(timer_div << 16, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL);
-	writel_relaxed(timer_div << 16, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_1_CTRL);
+	/* timer dividers: 0, not divided */
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_1_CTRL);
 
 	/* Initialize timer counters to 0 */
 	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_LO);
@@ -288,7 +283,7 @@ static void __init sirfsoc_marco_timer_init(struct device_node *np)
 	/* Clear all interrupts */
 	writel_relaxed(0xFFFF, sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
 
-	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, MARCO_CLOCK_FREQ));
+	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, marco_timer_rate));
 
 	sirfsoc_clockevent_init();
 }
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 38e26be705be..472a5adc4642 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -45,14 +45,14 @@ int rtc_hctosys_ret = -ENODEV;
  * system's wall clock; restore it on resume().
  */
 
-static struct timespec old_rtc, old_system, old_delta;
+static struct timespec64 old_rtc, old_system, old_delta;
 
 
 static int rtc_suspend(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	struct timespec		delta, delta_delta;
+	struct timespec64	delta, delta_delta;
 	int err;
 
 	if (has_persistent_clock())
@@ -68,8 +68,8 @@ static int rtc_suspend(struct device *dev)
 		return 0;
 	}
 
-	getnstimeofday(&old_system);
-	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
+	getnstimeofday64(&old_system);
+	old_rtc.tv_sec = rtc_tm_to_time64(&tm);
 
 
 	/*
@@ -78,8 +78,8 @@ static int rtc_suspend(struct device *dev)
 	 * try to compensate so the difference in system time
 	 * and rtc time stays close to constant.
 	 */
-	delta = timespec_sub(old_system, old_rtc);
-	delta_delta = timespec_sub(delta, old_delta);
+	delta = timespec64_sub(old_system, old_rtc);
+	delta_delta = timespec64_sub(delta, old_delta);
 	if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
@@ -88,7 +88,7 @@ static int rtc_suspend(struct device *dev)
 		old_delta = delta;
 	} else {
 		/* Otherwise try to adjust old_system to compensate */
-		old_system = timespec_sub(old_system, delta_delta);
+		old_system = timespec64_sub(old_system, delta_delta);
 	}
 
 	return 0;
@@ -98,8 +98,8 @@ static int rtc_resume(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	struct timespec		new_system, new_rtc;
-	struct timespec		sleep_time;
+	struct timespec64	new_system, new_rtc;
+	struct timespec64	sleep_time;
 	int err;
 
 	if (has_persistent_clock())
@@ -110,7 +110,7 @@ static int rtc_resume(struct device *dev)
 		return 0;
 
 	/* snapshot the current rtc and system time at resume */
-	getnstimeofday(&new_system);
+	getnstimeofday64(&new_system);
 	err = rtc_read_time(rtc, &tm);
 	if (err < 0) {
 		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
@@ -121,7 +121,7 @@ static int rtc_resume(struct device *dev)
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
+	new_rtc.tv_sec = rtc_tm_to_time64(&tm);
 	new_rtc.tv_nsec = 0;
 
 	if (new_rtc.tv_sec < old_rtc.tv_sec) {
@@ -130,7 +130,7 @@ static int rtc_resume(struct device *dev)
 	}
 
 	/* calculate the RTC time delta (sleep time)*/
-	sleep_time = timespec_sub(new_rtc, old_rtc);
+	sleep_time = timespec64_sub(new_rtc, old_rtc);
 
 	/*
 	 * Since these RTC suspend/resume handlers are not called
@@ -139,11 +139,11 @@ static int rtc_resume(struct device *dev)
 	 * so subtract kernel run-time between rtc_suspend to rtc_resume
 	 * to keep things accurate.
 	 */
-	sleep_time = timespec_sub(sleep_time,
-			timespec_sub(new_system, old_system));
+	sleep_time = timespec64_sub(sleep_time,
+			timespec64_sub(new_system, old_system));
 
 	if (sleep_time.tv_sec >= 0)
-		timekeeping_inject_sleeptime(&sleep_time);
+		timekeeping_inject_sleeptime64(&sleep_time);
 	rtc_hctosys_ret = 0;
 	return 0;
 }
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index c4cf05731118..e6bfb9c42a10 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -45,16 +45,20 @@ int rtc_year_days(unsigned int day, unsigned int month, unsigned int year)
 }
 EXPORT_SYMBOL(rtc_year_days);
 
+
 /*
+ * rtc_time_to_tm64 - Converts time64_t to rtc_time.
  * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
  */
-void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+void rtc_time64_to_tm(time64_t time, struct rtc_time *tm)
 {
 	unsigned int month, year;
+	unsigned long secs;
 	int days;
 
-	days = time / 86400;
-	time -= (unsigned int) days * 86400;
+	/* time must be positive */
+	days = div_s64(time, 86400);
+	secs = time - (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;
@@ -81,14 +85,14 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 	tm->tm_mon = month;
 	tm->tm_mday = days + 1;
 
-	tm->tm_hour = time / 3600;
-	time -= tm->tm_hour * 3600;
-	tm->tm_min = time / 60;
-	tm->tm_sec = time - tm->tm_min * 60;
+	tm->tm_hour = secs / 3600;
+	secs -= tm->tm_hour * 3600;
+	tm->tm_min = secs / 60;
+	tm->tm_sec = secs - tm->tm_min * 60;
 
 	tm->tm_isdst = 0;
 }
-EXPORT_SYMBOL(rtc_time_to_tm);
+EXPORT_SYMBOL(rtc_time64_to_tm);
 
 /*
  * Does the rtc_time represent a valid date/time?
@@ -109,24 +113,22 @@ int rtc_valid_tm(struct rtc_time *tm)
 EXPORT_SYMBOL(rtc_valid_tm);
 
 /*
+ * rtc_tm_to_time64 - Converts rtc_time to time64_t.
  * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
  */
-int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
+time64_t rtc_tm_to_time64(struct rtc_time *tm)
 {
-	*time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+	return mktime64(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
 			tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return 0;
 }
-EXPORT_SYMBOL(rtc_tm_to_time);
+EXPORT_SYMBOL(rtc_tm_to_time64);
 
 /*
  * Convert rtc_time to ktime
  */
 ktime_t rtc_tm_to_ktime(struct rtc_time tm)
 {
-	time_t time;
-	rtc_tm_to_time(&tm, &time);
-	return ktime_set(time, 0);
+	return ktime_set(rtc_tm_to_time64(&tm), 0);
 }
 EXPORT_SYMBOL_GPL(rtc_tm_to_ktime);
 
@@ -135,14 +137,14 @@ EXPORT_SYMBOL_GPL(rtc_tm_to_ktime);
  */
 struct rtc_time rtc_ktime_to_tm(ktime_t kt)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	struct rtc_time ret;
 
-	ts = ktime_to_timespec(kt);
+	ts = ktime_to_timespec64(kt);
 	/* Round up any ns */
 	if (ts.tv_nsec)
 		ts.tv_sec++;
-	rtc_time_to_tm(ts.tv_sec, &ret);
+	rtc_time64_to_tm(ts.tv_sec, &ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rtc_ktime_to_tm);
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 00d0741228fc..8cb1ff3bcd90 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -114,6 +114,46 @@ static int armada370_wdt_clock_init(struct platform_device *pdev,
 	return 0;
 }
 
+static int armada375_wdt_clock_init(struct platform_device *pdev,
+				    struct orion_watchdog *dev)
+{
+	int ret;
+
+	dev->clk = of_clk_get_by_name(pdev->dev.of_node, "fixed");
+	if (!IS_ERR(dev->clk)) {
+		ret = clk_prepare_enable(dev->clk);
+		if (ret) {
+			clk_put(dev->clk);
+			return ret;
+		}
+
+		atomic_io_modify(dev->reg + TIMER_CTRL,
+				WDT_AXP_FIXED_ENABLE_BIT,
+				WDT_AXP_FIXED_ENABLE_BIT);
+		dev->clk_rate = clk_get_rate(dev->clk);
+
+		return 0;
+	}
+
+	/* Mandatory fallback for proper devicetree backward compatibility */
+	dev->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dev->clk))
+		return PTR_ERR(dev->clk);
+
+	ret = clk_prepare_enable(dev->clk);
+	if (ret) {
+		clk_put(dev->clk);
+		return ret;
+	}
+
+	atomic_io_modify(dev->reg + TIMER_CTRL,
+			WDT_A370_RATIO_MASK(WDT_A370_RATIO_SHIFT),
+			WDT_A370_RATIO_MASK(WDT_A370_RATIO_SHIFT));
+	dev->clk_rate = clk_get_rate(dev->clk) / WDT_A370_RATIO;
+
+	return 0;
+}
+
 static int armadaxp_wdt_clock_init(struct platform_device *pdev,
 				   struct orion_watchdog *dev)
 {
@@ -394,7 +434,7 @@ static const struct orion_watchdog_data armada375_data = {
 	.rstout_mask_bit = BIT(10),
 	.wdt_enable_bit = BIT(8),
 	.wdt_counter_offset = 0x34,
-	.clock_init = armada370_wdt_clock_init,
+	.clock_init = armada375_wdt_clock_init,
 	.enabled = armada375_enabled,
 	.start = armada375_start,
 	.stop = armada375_stop,
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c28975293c..6d6be09a2fe5 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -19,11 +19,28 @@
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
 extern int rtc_valid_tm(struct rtc_time *tm);
-extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
-extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
+extern time64_t rtc_tm_to_time64(struct rtc_time *tm);
+extern void rtc_time64_to_tm(time64_t time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
 
+/**
+ * Deprecated. Use rtc_time64_to_tm().
+ */
+static inline void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+{
+	rtc_time64_to_tm(time, tm);
+}
+
+/**
+ * Deprecated. Use rtc_tm_to_time64().
+ */
+static inline int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
+{
+	*time = rtc_tm_to_time64(tm);
+
+	return 0;
+}
 
 #include <linux/device.h>
 #include <linux/seq_file.h>
diff --git a/include/linux/time.h b/include/linux/time.h
index 8c42cf8d2444..203c2ad40d71 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -39,9 +39,20 @@ static inline int timeval_compare(const struct timeval *lhs, const struct timeva
 	return lhs->tv_usec - rhs->tv_usec;
 }
 
-extern unsigned long mktime(const unsigned int year, const unsigned int mon,
-			    const unsigned int day, const unsigned int hour,
-			    const unsigned int min, const unsigned int sec);
+extern time64_t mktime64(const unsigned int year, const unsigned int mon,
+			const unsigned int day, const unsigned int hour,
+			const unsigned int min, const unsigned int sec);
+
+/**
+ * Deprecated. Use mktime64().
+ */
+static inline unsigned long mktime(const unsigned int year,
+			const unsigned int mon, const unsigned int day,
+			const unsigned int hour, const unsigned int min,
+			const unsigned int sec)
+{
+	return mktime64(year, mon, day, hour, min, sec);
+}
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
 
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 1caa6b04fdc5..961fea373f83 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -10,7 +10,7 @@ extern int timekeeping_suspended;
  * Get and set timeofday
  */
 extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(const struct timespec *tv);
+extern int do_settimeofday64(const struct timespec64 *ts);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
 
@@ -25,14 +25,22 @@ struct timespec __current_kernel_time(void);
 /*
  * timespec based interfaces
  */
-struct timespec get_monotonic_coarse(void);
-extern void getrawmonotonic(struct timespec *ts);
+struct timespec64 get_monotonic_coarse64(void);
+extern void getrawmonotonic64(struct timespec64 *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
 
 #if BITS_PER_LONG == 64
+/**
+ * Deprecated. Use do_settimeofday64().
+ */
+static inline int do_settimeofday(const struct timespec *ts)
+{
+	return do_settimeofday64(ts);
+}
+
 static inline int __getnstimeofday(struct timespec *ts)
 {
 	return __getnstimeofday64(ts);
@@ -53,7 +61,27 @@ static inline void ktime_get_real_ts(struct timespec *ts)
 	getnstimeofday64(ts);
 }
 
+static inline void getrawmonotonic(struct timespec *ts)
+{
+	getrawmonotonic64(ts);
+}
+
+static inline struct timespec get_monotonic_coarse(void)
+{
+	return get_monotonic_coarse64();
+}
 #else
+/**
+ * Deprecated. Use do_settimeofday64().
+ */
+static inline int do_settimeofday(const struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	ts64 = timespec_to_timespec64(*ts);
+	return do_settimeofday64(&ts64);
+}
+
 static inline int __getnstimeofday(struct timespec *ts)
 {
 	struct timespec64 ts64;
@@ -86,6 +114,19 @@ static inline void ktime_get_real_ts(struct timespec *ts)
 	getnstimeofday64(&ts64);
 	*ts = timespec64_to_timespec(ts64);
 }
+
+static inline void getrawmonotonic(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	getrawmonotonic64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+
+static inline struct timespec get_monotonic_coarse(void)
+{
+	return timespec64_to_timespec(get_monotonic_coarse64());
+}
 #endif
 
 extern void getboottime(struct timespec *ts);
@@ -182,7 +223,7 @@ static inline void timekeeping_clocktai(struct timespec *ts)
 /*
  * RTC specific
  */
-extern void timekeeping_inject_sleeptime(struct timespec *delta);
+extern void timekeeping_inject_sleeptime64(struct timespec64 *delta);
 
 /*
  * PPS accessor
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 7347426fa68d..f622cf28628a 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
-obj-$(CONFIG_TEST_UDELAY)			+= udelay_test.o
+obj-$(CONFIG_TEST_UDELAY)			+= test_udelay.o
 
 $(obj)/time.o: $(obj)/timeconst.h
 
diff --git a/kernel/time/udelay_test.c b/kernel/time/test_udelay.c
similarity index 100%
rename from kernel/time/udelay_test.c
rename to kernel/time/test_udelay.c
diff --git a/kernel/time/time.c b/kernel/time/time.c
index a9ae20fb0b11..65015ff2f07c 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -304,7 +304,9 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-/* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
+/*
+ * mktime64 - Converts date to seconds.
+ * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
  *
@@ -314,15 +316,10 @@ EXPORT_SYMBOL(timespec_trunc);
  * -year/100+year/400 terms, and add 10.]
  *
  * This algorithm was first published by Gauss (I think).
- *
- * WARNING: this function will overflow on 2106-02-07 06:28:16 on
- * machines where long is 32-bit! (However, as time_t is signed, we
- * will already get problems at other places on 2038-01-19 03:14:08)
  */
-unsigned long
-mktime(const unsigned int year0, const unsigned int mon0,
-       const unsigned int day, const unsigned int hour,
-       const unsigned int min, const unsigned int sec)
+time64_t mktime64(const unsigned int year0, const unsigned int mon0,
+		const unsigned int day, const unsigned int hour,
+		const unsigned int min, const unsigned int sec)
 {
 	unsigned int mon = mon0, year = year0;
 
@@ -332,15 +329,14 @@ mktime(const unsigned int year0, const unsigned int mon0,
 		year -= 1;
 	}
 
-	return ((((unsigned long)
+	return ((((time64_t)
 		  (year/4 - year/100 + year/400 + 367*mon/12 + day) +
 		  year*365 - 719499
 	    )*24 + hour /* now have hours */
 	  )*60 + min /* now have minutes */
 	)*60 + sec; /* finally seconds */
 }
-
-EXPORT_SYMBOL(mktime);
+EXPORT_SYMBOL(mktime64);
 
 /**
  * set_normalized_timespec - set timespec sec and nsec parts and normalize
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791fae965..2dc0646258ae 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -519,9 +519,9 @@ EXPORT_SYMBOL(__getnstimeofday64);
 
 /**
  * getnstimeofday64 - Returns the time of day in a timespec64.
- * @ts:		pointer to the timespec to be set
+ * @ts:		pointer to the timespec64 to be set
  *
- * Returns the time of day in a timespec (WARN if suspended).
+ * Returns the time of day in a timespec64 (WARN if suspended).
  */
 void getnstimeofday64(struct timespec64 *ts)
 {
@@ -623,7 +623,7 @@ EXPORT_SYMBOL_GPL(ktime_get_raw);
  *
  * The function calculates the monotonic clock from the realtime
  * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
+ * in normalized timespec64 format in the variable pointed to by @ts.
  */
 void ktime_get_ts64(struct timespec64 *ts)
 {
@@ -703,18 +703,18 @@ void do_gettimeofday(struct timeval *tv)
 EXPORT_SYMBOL(do_gettimeofday);
 
 /**
- * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
+ * do_settimeofday64 - Sets the time of day.
+ * @ts:     pointer to the timespec64 variable containing the new time
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
  */
-int do_settimeofday(const struct timespec *tv)
+int do_settimeofday64(const struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 ts_delta, xt, tmp;
+	struct timespec64 ts_delta, xt;
 	unsigned long flags;
 
-	if (!timespec_valid_strict(tv))
+	if (!timespec64_valid_strict(ts))
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -723,13 +723,12 @@ int do_settimeofday(const struct timespec *tv)
 	timekeeping_forward_now(tk);
 
 	xt = tk_xtime(tk);
-	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
+	ts_delta.tv_sec = ts->tv_sec - xt.tv_sec;
+	ts_delta.tv_nsec = ts->tv_nsec - xt.tv_nsec;
 
 	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
 
-	tmp = timespec_to_timespec64(*tv);
-	tk_set_xtime(tk, &tmp);
+	tk_set_xtime(tk, ts);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
@@ -741,7 +740,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	return 0;
 }
-EXPORT_SYMBOL(do_settimeofday);
+EXPORT_SYMBOL(do_settimeofday64);
 
 /**
  * timekeeping_inject_offset - Adds or subtracts from the current time.
@@ -895,12 +894,12 @@ int timekeeping_notify(struct clocksource *clock)
 }
 
 /**
- * getrawmonotonic - Returns the raw monotonic time in a timespec
- * @ts:		pointer to the timespec to be set
+ * getrawmonotonic64 - Returns the raw monotonic time in a timespec
+ * @ts:		pointer to the timespec64 to be set
  *
  * Returns the raw monotonic time (completely un-modified by ntp)
  */
-void getrawmonotonic(struct timespec *ts)
+void getrawmonotonic64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 ts64;
@@ -915,9 +914,10 @@ void getrawmonotonic(struct timespec *ts)
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	timespec64_add_ns(&ts64, nsecs);
-	*ts = timespec64_to_timespec(ts64);
+	*ts = ts64;
 }
-EXPORT_SYMBOL(getrawmonotonic);
+EXPORT_SYMBOL(getrawmonotonic64);
+
 
 /**
  * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
@@ -1068,8 +1068,8 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 }
 
 /**
- * timekeeping_inject_sleeptime - Adds suspend interval to timeekeeping values
- * @delta: pointer to a timespec delta value
+ * timekeeping_inject_sleeptime64 - Adds suspend interval to timeekeeping values
+ * @delta: pointer to a timespec64 delta value
  *
  * This hook is for architectures that cannot support read_persistent_clock
  * because their RTC/persistent clock is only accessible when irqs are enabled.
@@ -1077,10 +1077,9 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  * This function should only be called by rtc_resume(), and allows
  * a suspend offset to be injected into the timekeeping values.
  */
-void timekeeping_inject_sleeptime(struct timespec *delta)
+void timekeeping_inject_sleeptime64(struct timespec64 *delta)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 tmp;
 	unsigned long flags;
 
 	/*
@@ -1095,8 +1094,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	timekeeping_forward_now(tk);
 
-	tmp = timespec_to_timespec64(*delta);
-	__timekeeping_inject_sleeptime(tk, &tmp);
+	__timekeeping_inject_sleeptime(tk, delta);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
@@ -1332,6 +1330,12 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
+	if ((mult_adj > 0) && (tk->tkr.mult + mult_adj < mult_adj)) {
+		/* NTP adjustment caused clocksource mult overflow */
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	tk->tkr.mult += mult_adj;
 	tk->xtime_interval += interval;
 	tk->tkr.xtime_nsec -= offset;
@@ -1397,7 +1401,8 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	}
 
 	if (unlikely(tk->tkr.clock->maxadj &&
-		(tk->tkr.mult > tk->tkr.clock->mult + tk->tkr.clock->maxadj))) {
+		(abs(tk->tkr.mult - tk->tkr.clock->mult)
+			> tk->tkr.clock->maxadj))) {
 		printk_once(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
 			tk->tkr.clock->name, (long)tk->tkr.mult,
@@ -1646,7 +1651,7 @@ struct timespec current_kernel_time(void)
 }
 EXPORT_SYMBOL(current_kernel_time);
 
-struct timespec get_monotonic_coarse(void)
+struct timespec64 get_monotonic_coarse64(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	struct timespec64 now, mono;
@@ -1662,7 +1667,7 @@ struct timespec get_monotonic_coarse(void)
 	set_normalized_timespec64(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
 
-	return timespec64_to_timespec(now);
+	return now;
 }
 
 /*
