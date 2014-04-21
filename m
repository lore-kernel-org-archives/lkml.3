Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaDUJ5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:57:47 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36411 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaDUJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:57:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 18/19] tick-sched: invert parameter of tick_check_oneshot_change()
Date: Mon, 21 Apr 2014 15:25:14 +0530
Message-Id: <0e5e2a44a07af7fe17d70bb4d45dd7b032e92a35.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one caller of tick_check_oneshot_change(), i.e.
hrtimer_run_pending(). hrtimer_run_pending() calls this routine after doing a
logical NOT (!) of its parameter and then tick_check_oneshot_change() also uses
its parameter after doing logical NOT (!) of it.

It would be more efficient and readable if we can just invert the meaning of
this parameter. It is called hres_enabled instead of allow_nohz now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h     |  6 +++---
 kernel/hrtimer.c         |  2 +-
 kernel/time/tick-sched.c | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index f538a4d..1065a51 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -120,7 +120,7 @@ extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 
 # ifdef CONFIG_TICK_ONESHOT
 extern void tick_clock_notify(void);
-extern int tick_check_oneshot_change(int allow_nohz);
+extern int tick_check_oneshot_change(int hres_enabled);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
 extern void tick_irq_enter(void);
 extern int tick_oneshot_mode_active(void);
@@ -129,7 +129,7 @@ extern int tick_oneshot_mode_active(void);
 #  endif
 # else
 static inline void tick_clock_notify(void) { }
-static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
+static inline int tick_check_oneshot_change(int hres_enabled) { return 0; }
 static inline void tick_irq_enter(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 # endif
@@ -138,7 +138,7 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 static inline void tick_init(void) { }
 static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
-static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
+static inline int tick_check_oneshot_change(int hres_enabled) { return 0; }
 static inline void tick_irq_enter(void) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 393f422..bfa7811 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1457,7 +1457,7 @@ void hrtimer_run_pending(void)
 	 * check bit in the tick_oneshot code, otherwise we might
 	 * deadlock vs. xtime_lock.
 	 */
-	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
+	if (tick_check_oneshot_change(hrtimer_is_hres_enabled()))
 		hrtimer_switch_to_hres();
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4a94412..77084fa 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1195,11 +1195,11 @@ void tick_oneshot_notify(void)
  * Check, if a change happened, which makes oneshot possible.
  *
  * Called cyclic from the hrtimer softirq (driven by the timer
- * softirq) allow_nohz signals, that we can switch into low-res nohz
- * mode, because high resolution timers are disabled (either compile
- * or runtime).
+ * softirq). If hres_enabled is non zero, it means we can't switch into low-res
+ * nohz mode, because high resolution timers are enabled(either compile or
+ * runtime).
  */
-int tick_check_oneshot_change(int allow_nohz)
+int tick_check_oneshot_change(int hres_enabled)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
@@ -1212,7 +1212,7 @@ int tick_check_oneshot_change(int allow_nohz)
 	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
 		return 0;
 
-	if (!allow_nohz)
+	if (hres_enabled)
 		return 1;
 
 	tick_nohz_switch_to_nohz();
-- 
1.7.12.rc2.18.g61b472e

