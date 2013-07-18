Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817Ab3GRXVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:21:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705Ab3GRXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 03/17] sched_clock: Use an hrtimer instead of timer
Date: Thu, 18 Jul 2013 16:21:16 -0700
Message-Id: <1374189690-10810-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the next patch we're going to increase the number of bits that
the generic sched_clock can handle to be greater than 32. With
more than 32 bits the wraparound time can be larger than what can
fit into the units that msecs_to_jiffies takes (unsigned int).
Luckily, the wraparound is initially calculated in nanoseconds
which we can easily use with hrtimers, so switch to using an
hrtimer.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/sched_clock.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 396f7b9..a269890b 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -8,15 +8,17 @@
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/syscore_ops.h>
-#include <linux/timer.h>
+#include <linux/hrtimer.h>
 #include <linux/sched_clock.h>
 #include <linux/seqlock.h>
 
 struct clock_data {
+	ktime_t wrap_kt;
 	u64 epoch_ns;
 	u32 epoch_cyc;
 	seqcount_t seq;
@@ -26,8 +28,7 @@ struct clock_data {
 	bool suspended;
 };
 
-static void sched_clock_poll(unsigned long wrap_ticks);
-static DEFINE_TIMER(sched_clock_timer, sched_clock_poll, 0, 0);
+static struct hrtimer sched_clock_timer;
 static int irqtime = -1;
 
 core_param(irqtime, irqtime, int, 0400);
@@ -93,15 +94,16 @@ static void notrace update_sched_clock(void)
 	raw_local_irq_restore(flags);
 }
 
-static void sched_clock_poll(unsigned long wrap_ticks)
+static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
 {
-	mod_timer(&sched_clock_timer, round_jiffies(jiffies + wrap_ticks));
 	update_sched_clock();
+	hrtimer_forward_now(hrt, cd.wrap_kt);
+	return HRTIMER_RESTART;
 }
 
 void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 {
-	unsigned long r, w;
+	unsigned long r;
 	u64 res, wrap;
 	char r_unit;
 
@@ -129,19 +131,19 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 
 	/* calculate how many ns until we wrap */
 	wrap = cyc_to_ns((1ULL << bits) - 1, cd.mult, cd.shift);
-	do_div(wrap, NSEC_PER_MSEC);
-	w = wrap;
+	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
 
 	/* calculate the ns resolution of this counter */
 	res = cyc_to_ns(1ULL, cd.mult, cd.shift);
-	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lums\n",
-		bits, r, r_unit, res, w);
+	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lluns\n",
+		bits, r, r_unit, res, wrap);
 
 	/*
 	 * Start the timer to keep sched_clock() properly updated and
 	 * sets the initial epoch.
 	 */
-	sched_clock_timer.data = msecs_to_jiffies(w - (w / 10));
+	hrtimer_init(&sched_clock_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	sched_clock_timer.function = sched_clock_poll;
 	update_sched_clock();
 
 	/*
@@ -172,12 +174,13 @@ void __init sched_clock_postinit(void)
 	if (read_sched_clock == jiffy_sched_clock_read)
 		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
 
-	sched_clock_poll(sched_clock_timer.data);
+	update_sched_clock();
+	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
 }
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(sched_clock_timer.data);
+	sched_clock_poll(&sched_clock_timer);
 	cd.suspended = true;
 	return 0;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

