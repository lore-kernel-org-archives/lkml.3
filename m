Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbbAYOTC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:19:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:42355 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbAYOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:18:59 -0500
Date: Sun, 25 Jan 2015 15:18:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, apkm@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer fixes for 3.19
Message-ID: <alpine.DEB.2.11.1501251511260.5526@nanos>
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

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

A set of small fixes:
  - Regression fix for exynos_mct clocksource
  - Trivial build fix for kona clocksource
  - Functional one liner fix for the sh_tmu clocksource
  - Two validation fixes to prevent (root only) data corruption in the
    kernel via settimeofday and adjtimex. Tagged for stable.

Thanks,

	tglx

------------------>
Magnus Damm (1):
      clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast

Olof Johansson (1):
      clocksource: kona: fix __iomem annotation

Sasha Levin (2):
      time: settimeofday: Validate the values of tv from user
      time: adjtimex: Validate the ADJ_FREQUENCY values

Tobias Jakobi (1):
      clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write


 drivers/clocksource/bcm_kona_timer.c |  9 ++++-----
 drivers/clocksource/exynos_mct.c     |  4 ++--
 drivers/clocksource/sh_tmu.c         |  2 +-
 include/linux/time.h                 | 13 +++++++++++++
 kernel/time/ntp.c                    |  7 +++++++
 kernel/time/time.c                   |  4 ++++
 6 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0595dc6c453e..f1e33d08dd83 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -68,9 +68,8 @@ static void kona_timer_disable_and_clear(void __iomem *base)
 }
 
 static void
-kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
+kona_timer_get_counter(void __iomem *timer_base, uint32_t *msw, uint32_t *lsw)
 {
-	void __iomem *base = IOMEM(timer_base);
 	int loop_limit = 4;
 
 	/*
@@ -86,9 +85,9 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
 	 */
 
 	while (--loop_limit) {
-		*msw = readl(base + KONA_GPTIMER_STCHI_OFFSET);
-		*lsw = readl(base + KONA_GPTIMER_STCLO_OFFSET);
-		if (*msw == readl(base + KONA_GPTIMER_STCHI_OFFSET))
+		*msw = readl(timer_base + KONA_GPTIMER_STCHI_OFFSET);
+		*lsw = readl(timer_base + KONA_GPTIMER_STCLO_OFFSET);
+		if (*msw == readl(timer_base + KONA_GPTIMER_STCHI_OFFSET))
 			break;
 	}
 	if (!loop_limit) {
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 9403061a2acc..83564c9cfdbe 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -97,8 +97,8 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 	writel_relaxed(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
-		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
-		switch (offset & EXYNOS4_MCT_L_MASK) {
+		stat_addr = (offset & EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
+		switch (offset & ~EXYNOS4_MCT_L_MASK) {
 		case MCT_L_TCON_OFFSET:
 			mask = 1 << 3;		/* L_TCON write status */
 			break;
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 0f665b8f2461..f150ca82bfaf 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(struct sh_tmu_channel *ch,
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = 200;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
 	ced->suspend = sh_tmu_clock_event_suspend;
diff --git a/include/linux/time.h b/include/linux/time.h
index 203c2ad40d71..beebe3a02d43 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -110,6 +110,19 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
+static inline bool timeval_valid(const struct timeval *tv)
+{
+	/* Dates before 1970 are bogus */
+	if (tv->tv_sec < 0)
+		return false;
+
+	/* Can't have more microseconds then a second */
+	if (tv->tv_usec < 0 || tv->tv_usec >= USEC_PER_SEC)
+		return false;
+
+	return true;
+}
+
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 
 #define CURRENT_TIME		(current_kernel_time())
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 87a346fd6d61..28bf91c60a0b 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -633,6 +633,13 @@ int ntp_validate_timex(struct timex *txc)
 	if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
 		return -EPERM;
 
+	if (txc->modes & ADJ_FREQUENCY) {
+		if (LONG_MIN / PPM_SCALE > txc->freq)
+			return -EINVAL;
+		if (LONG_MAX / PPM_SCALE < txc->freq)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 65015ff2f07c..887e7d505974 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -196,6 +196,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
 	if (tv) {
 		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
 			return -EFAULT;
+
+		if (!timeval_valid(&user_tv))
+			return -EINVAL;
+
 		new_ts.tv_sec = user_tv.tv_sec;
 		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
 	}
