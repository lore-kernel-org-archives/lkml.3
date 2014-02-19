Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaBSQLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:11:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaBSQLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:11:23 -0500
Date: Wed, 19 Feb 2014 08:10:18 -0800
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-5ae8aabeaec3fe69c4fb21cbe5b17b72b35b5892@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, peterz@infradead.org, sboyd@codeaurora.org,
        john.stultz@linaro.org, joshc@codeaurora.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, peterz@infradead.org, sboyd@codeaurora.org,
        john.stultz@linaro.org, joshc@codeaurora.org, tglx@linutronix.de
In-Reply-To: <1392662736-7803-2-git-send-email-john.stultz@linaro.org>
References: <1392662736-7803-2-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] sched_clock:
  Prevent callers from seeing half-updated data
Git-Commit-ID: 5ae8aabeaec3fe69c4fb21cbe5b17b72b35b5892
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ae8aabeaec3fe69c4fb21cbe5b17b72b35b5892
Gitweb:     http://git.kernel.org/tip/5ae8aabeaec3fe69c4fb21cbe5b17b72b35b5892
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Mon, 17 Feb 2014 10:45:36 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Feb 2014 17:07:22 +0100

sched_clock: Prevent callers from seeing half-updated data

The generic sched_clock registration function was previously
done lockless, due to the fact that it was expected to be called
only once. However, now there are systems that may register
multiple sched_clock sources, for which the lack of locking has
casued problems:

If two sched_clock sources are registered we may end up in a
situation where a call to sched_clock() may be accessing the
epoch cycle count for the old counter and the cycle count for the
new counter. This can lead to confusing results where
sched_clock() values jump and then are reset to 0 (due to the way
the registration function forces the epoch_ns to be 0).

Fix this by reorganizing the registration function to hold the
seqlock for as short a time as possible while we update the
clock_data structure for a new counter. We also put any
accumulated time into epoch_ns instead of resetting the time to
0 so that the clock doesn't reset after each successful
registration.

[jstultz: Added extra context to the commit message]

Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Link: http://lkml.kernel.org/r/1392662736-7803-2-git-send-email-john.stultz@linaro.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/sched_clock.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 0abb364..4d23dc4 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -116,20 +116,42 @@ static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
 void __init sched_clock_register(u64 (*read)(void), int bits,
 				 unsigned long rate)
 {
+	u64 res, wrap, new_mask, new_epoch, cyc, ns;
+	u32 new_mult, new_shift;
+	ktime_t new_wrap_kt;
 	unsigned long r;
-	u64 res, wrap;
 	char r_unit;
 
 	if (cd.rate > rate)
 		return;
 
 	WARN_ON(!irqs_disabled());
-	read_sched_clock = read;
-	sched_clock_mask = CLOCKSOURCE_MASK(bits);
-	cd.rate = rate;
 
 	/* calculate the mult/shift to convert counter ticks to ns. */
-	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 3600);
+	clocks_calc_mult_shift(&new_mult, &new_shift, rate, NSEC_PER_SEC, 3600);
+
+	new_mask = CLOCKSOURCE_MASK(bits);
+
+	/* calculate how many ns until we wrap */
+	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
+	new_wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
+
+	/* update epoch for new counter and update epoch_ns from old counter*/
+	new_epoch = read();
+	cyc = read_sched_clock();
+	ns = cd.epoch_ns + cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
+			  cd.mult, cd.shift);
+
+	raw_write_seqcount_begin(&cd.seq);
+	read_sched_clock = read;
+	sched_clock_mask = new_mask;
+	cd.rate = rate;
+	cd.wrap_kt = new_wrap_kt;
+	cd.mult = new_mult;
+	cd.shift = new_shift;
+	cd.epoch_cyc = new_epoch;
+	cd.epoch_ns = ns;
+	raw_write_seqcount_end(&cd.seq);
 
 	r = rate;
 	if (r >= 4000000) {
@@ -141,22 +163,12 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 	} else
 		r_unit = ' ';
 
-	/* calculate how many ns until we wrap */
-	wrap = clocks_calc_max_nsecs(cd.mult, cd.shift, 0, sched_clock_mask);
-	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
-
 	/* calculate the ns resolution of this counter */
-	res = cyc_to_ns(1ULL, cd.mult, cd.shift);
+	res = cyc_to_ns(1ULL, new_mult, new_shift);
+
 	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lluns\n",
 		bits, r, r_unit, res, wrap);
 
-	update_sched_clock();
-
-	/*
-	 * Ensure that sched_clock() starts off at 0ns
-	 */
-	cd.epoch_ns = 0;
-
 	/* Enable IRQ time accounting if we have a fast enough sched_clock */
 	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
 		enable_sched_clock_irqtime();
