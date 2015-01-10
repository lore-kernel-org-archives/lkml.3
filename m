Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbbAJAen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:34:43 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46727 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbbAJAel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:34:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 05/10] time: Add debugging checks to warn if we see delays
Date: Fri,  9 Jan 2015 16:34:23 -0800
Message-Id: <1420850068-27828-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
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
 kernel/time/timekeeping.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

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
index 6a93185..0dcceba 100644
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
+	else if (offset > (max_cycles >> 1))
+		printk("WARNING: cycle offset (%lld) is past"
+			" the %s 50%% safety margin (%lld)\n",
+			offset, name, max_cycles>>1);
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

