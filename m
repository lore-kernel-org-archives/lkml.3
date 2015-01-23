Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbbAWALu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:11:50 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33103 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbbAWAJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 05/12] time: Add debugging checks to warn if we see delays
Date: Thu, 22 Jan 2015 16:09:20 -0800
Message-Id: <1421971767-17707-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently there's been some request for better sanity
checking in the time code, so that its more clear
when something is going wrong since timekeeping issues
could manifest in a large number of strange ways with
various subsystems.

Thus, this patch adds some extra infrastructure to
add a check update_wall_time to print warnings if we
see the call delayed beyond the max_cycles overflow
point, or beyond the clocksource max_idle_ns value
which is currently 50% of the overflow point.

This extra infrastructure is conditionalized
behind a new CONFIG_DEBUG_TIMEKEEPING option
also added in this patch.

Tested this a bit by halting qemu for specified
lengths of time to trigger the warnings.

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
 kernel/time/jiffies.c     |  1 +
 kernel/time/timekeeping.c | 23 +++++++++++++++++++++++
 lib/Kconfig.debug         | 12 ++++++++++++
 3 files changed, 36 insertions(+)

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
index 6a93185..daa0d43 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -118,6 +118,26 @@ static inline void tk_update_sleep_time(struct timekeeper *tk, ktime_t delta)
 	tk->offs_boot = ktime_add(tk->offs_boot, delta);
 }
 
+#ifdef CONFIG_DEBUG_TIMEKEEPING
+static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
+{
+
+	cycle_t max_cycles = tk->tkr.clock->max_cycles;
+	const char *name = tk->tkr.clock->name;
+
+	if (offset > max_cycles)
+		printk_deferred("ERROR: cycle offset (%lld) is larger then"
+			" allowed %s max_cycles (%lld)\n",
+			offset, name, max_cycles);
+	else if (offset > (max_cycles >> 1))
+		printk_deferred("WARNING: cycle offset (%lld) is past"
+			" the %s 50%% safety margin (%lld)\n",
+			offset, name, max_cycles>>1);
+}
+#else
+#define timekeeping_check_update(x, y)
+#endif
+
 /**
  * tk_setup_internals - Set up internals to use clocksource clock.
  *
@@ -1602,6 +1622,9 @@ void update_wall_time(void)
 	if (offset < real_tk->cycle_interval)
 		goto out;
 
+	/* Do some additional sanity checking */
+	timekeeping_check_update(real_tk, offset);
+
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5f2ce61..c7b040d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -852,6 +852,18 @@ config SCHED_STACK_END_CHECK
 	  data corruption or a sporadic crash at a later stage once the region
 	  is examined. The runtime overhead introduced is minimal.
 
+config DEBUG_TIMEKEEPING
+	bool "Enable extra timekeeping sanity checking"
+	help
+	  This option will enable additional timekeeping sanity checks
+	  which may be helpful when diagnoising issues where timekeeping
+	  problems are suspected.
+
+	  This may include checks in the timekeeping hotpaths, so this
+	  option may have a performance impact to some workloads.
+
+	  If unsure, say N.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.9.1

