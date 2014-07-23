Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbaGWKy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:58 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59422 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986AbaGWKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:38 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 25/25] clocksource: exynos_mct: Only use 32-bits where possible
Date: Wed, 23 Jul 2014 12:54:07 +0200
Message-Id: <1406112847-26275-25-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

The MCT has a nice 64-bit counter.  That means that we _can_ register
as a 64-bit clocksource and sched_clock.  ...but that doesn't mean we
should.

The 64-bit counter is read by reading two 32-bit registers.  That
means reading needs to be something like:
- Read upper half
- Read lower half
- Read upper half and confirm that it hasn't changed.

That wouldn't be terrible, but:
- THe MCT isn't very fast to access (hundreds of nanoseconds).
- The clocksource is queried _all the time_.

In total system profiles of real workloads on ChromeOS, we've seen
exynos_frc_read() taking 2% or more of CPU time even after optimizing
the 3 reads above to 2 (see below).

The MCT is clocked at ~24MHz on all known systems.  That means that
the 32-bit half of the counter rolls over every ~178 seconds.  This
inspired an optimization in ChromeOS to cache the upper half between
calls, moving 3 reads to 2.  ...but we can do better!  Having a 32-bit
timer that flips every 178 seconds is more than sufficient for Linux.
Let's just use the lower half of the MCT.

Times on 5420 to do 1000000 gettimeofday() calls from userspace:
* Original code:                      1323852 us
* ChromeOS cache upper half:          1173084 us
* ChromeOS + ldmia to optimize:       1045674 us
* Use lower 32-bit only (this code):  1014429 us

As you can see, the time used doesn't increase linearly with the
number of reads and we can make 64-bit work almost as fast as 32-bit
with a bit of assembly code.  But since there's no real gain for
64-bit, let's go with the simplest and fastest implementation.

Note: with this change roughly half the time for gettimeofday() is
spent in exynos_frc_read().  The rest is timer / system call overhead.

Also note: this patch disables the use of the MCT on ARM64 systems
until we've sorted out how to make "cycles_t" always 32-bit.  Really
ARM64 systems should be using arch timers anyway.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/Kconfig      |    1 +
 drivers/clocksource/exynos_mct.c |   39 +++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 7ea7d7c..cfd6519d 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -127,6 +127,7 @@ config CLKSRC_METAG_GENERIC
 
 config CLKSRC_EXYNOS_MCT
 	def_bool y if ARCH_EXYNOS
+	depends on !ARM64
 	help
 	  Support for Multi Core Timer controller on Exynos SoCs.
 
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 2df03e2..9403061 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -162,7 +162,17 @@ static void exynos4_mct_frc_start(void)
 	exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
 }
 
-static cycle_t notrace _exynos4_frc_read(void)
+/**
+ * exynos4_read_count_64 - Read all 64-bits of the global counter
+ *
+ * This will read all 64-bits of the global counter taking care to make sure
+ * that the upper and lower half match.  Note that reading the MCT can be quite
+ * slow (hundreds of nanoseconds) so you should use the 32-bit (lower half
+ * only) version when possible.
+ *
+ * Returns the number of cycles in the global counter.
+ */
+static u64 exynos4_read_count_64(void)
 {
 	unsigned int lo, hi;
 	u32 hi2 = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_U);
@@ -176,9 +186,22 @@ static cycle_t notrace _exynos4_frc_read(void)
 	return ((cycle_t)hi << 32) | lo;
 }
 
+/**
+ * exynos4_read_count_32 - Read the lower 32-bits of the global counter
+ *
+ * This will read just the lower 32-bits of the global counter.  This is marked
+ * as notrace so it can be used by the scheduler clock.
+ *
+ * Returns the number of cycles in the global counter (lower 32 bits).
+ */
+static u32 notrace exynos4_read_count_32(void)
+{
+	return readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_L);
+}
+
 static cycle_t exynos4_frc_read(struct clocksource *cs)
 {
-	return _exynos4_frc_read();
+	return exynos4_read_count_32();
 }
 
 static void exynos4_frc_resume(struct clocksource *cs)
@@ -190,21 +213,23 @@ struct clocksource mct_frc = {
 	.name		= "mct-frc",
 	.rating		= 400,
 	.read		= exynos4_frc_read,
-	.mask		= CLOCKSOURCE_MASK(64),
+	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= exynos4_frc_resume,
 };
 
 static u64 notrace exynos4_read_sched_clock(void)
 {
-	return _exynos4_frc_read();
+	return exynos4_read_count_32();
 }
 
 static struct delay_timer exynos4_delay_timer;
 
 static cycles_t exynos4_read_current_timer(void)
 {
-	return _exynos4_frc_read();
+	BUILD_BUG_ON_MSG(sizeof(cycles_t) != sizeof(u32),
+			 "cycles_t needs to move to 32-bit for ARM64 usage");
+	return exynos4_read_count_32();
 }
 
 static void __init exynos4_clocksource_init(void)
@@ -218,7 +243,7 @@ static void __init exynos4_clocksource_init(void)
 	if (clocksource_register_hz(&mct_frc, clk_rate))
 		panic("%s: can't register clocksource\n", mct_frc.name);
 
-	sched_clock_register(exynos4_read_sched_clock, 64, clk_rate);
+	sched_clock_register(exynos4_read_sched_clock, 32, clk_rate);
 }
 
 static void exynos4_mct_comp0_stop(void)
@@ -245,7 +270,7 @@ static void exynos4_mct_comp0_start(enum clock_event_mode mode,
 		exynos4_mct_write(cycles, EXYNOS4_MCT_G_COMP0_ADD_INCR);
 	}
 
-	comp_cycle = exynos4_frc_read(&mct_frc) + cycles;
+	comp_cycle = exynos4_read_count_64() + cycles;
 	exynos4_mct_write((u32)comp_cycle, EXYNOS4_MCT_G_COMP0_L);
 	exynos4_mct_write((u32)(comp_cycle >> 32), EXYNOS4_MCT_G_COMP0_U);
 
-- 
1.7.9.5

