Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3FBGkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:40:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35563 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3FBGjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
Date: Sat,  1 Jun 2013 23:39:41 -0700
Message-Id: <1370155183-31421-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM architected system counter has at least 56 useable bits.
Add support for counters with more than 32 bits to the generic
sched_clock implementation so we can avoid the complexity of
dealing with wrap-around on these devices while benefiting from
the irqtime accounting and suspend/resume handling that the
generic sched_clock code already has.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/sched_clock.h |   2 +
 kernel/time/sched_clock.c   | 101 ++++++++++++++++++++++++++++++++------------
 2 files changed, 77 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index fa7922c..e732b39 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -18,4 +18,6 @@ extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 
 extern unsigned long long (*sched_clock_func)(void);
 
+extern void setup_sched_clock_64(u64 (*read)(void), int bits,
+				 unsigned long rate);
 #endif
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index aad1ae6..482242c 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -43,6 +43,7 @@ static u32 notrace jiffy_sched_clock_read(void)
 }
 
 static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
+static u64 __read_mostly (*read_sched_clock_64)(void);
 
 static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
@@ -103,24 +104,12 @@ static void sched_clock_poll(unsigned long wrap_ticks)
 	update_sched_clock();
 }
 
-void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+static u64 __init sched_clock_calc_wrap(int bits, unsigned long rate)
 {
-	unsigned long r, w;
+	unsigned long r;
 	u64 res, wrap;
 	char r_unit;
 
-	if (cd.rate > rate)
-		return;
-
-	BUG_ON(bits > 32);
-	WARN_ON(!irqs_disabled());
-	read_sched_clock = read;
-	sched_clock_mask = (1 << bits) - 1;
-	cd.rate = rate;
-
-	/* calculate the mult/shift to convert counter ticks to ns. */
-	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
-
 	r = rate;
 	if (r >= 4000000) {
 		r /= 1000000;
@@ -134,12 +123,39 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	/* calculate how many ns until we wrap */
 	wrap = cyc_to_ns((1ULL << bits) - 1, cd.mult, cd.shift);
 	do_div(wrap, NSEC_PER_MSEC);
-	w = wrap;
 
 	/* calculate the ns resolution of this counter */
 	res = cyc_to_ns(1ULL, cd.mult, cd.shift);
-	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lums\n",
-		bits, r, r_unit, res, w);
+	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %llums\n",
+		bits, r, r_unit, res, wrap);
+
+	return wrap;
+}
+
+static void __init try_to_enable_irqtime(unsigned long rate)
+{
+	/* Enable IRQ time accounting if we have a fast enough sched_clock */
+	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
+		enable_sched_clock_irqtime();
+}
+
+void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+{
+	unsigned long w;
+
+	if (cd.rate > rate)
+		return;
+
+	BUG_ON(bits > 32);
+	WARN_ON(!irqs_disabled());
+	read_sched_clock = read;
+	sched_clock_mask = (1 << bits) - 1;
+	cd.rate = rate;
+
+	/* calculate the mult/shift to convert counter ticks to ns. */
+	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 0);
+
+	w = sched_clock_calc_wrap(bits, rate);
 
 	/*
 	 * Start the timer to keep sched_clock() properly updated and
@@ -153,9 +169,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	 */
 	cd.epoch_ns = 0;
 
-	/* Enable IRQ time accounting if we have a fast enough sched_clock */
-	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
-		enable_sched_clock_irqtime();
+	try_to_enable_irqtime(rate);
 
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
@@ -168,6 +182,32 @@ static unsigned long long notrace sched_clock_32(void)
 
 unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
 
+static unsigned long long notrace sched_clock_64(void)
+{
+	u64 cyc = read_sched_clock_64() - cd.epoch_ns;
+	return cyc * cd.mult;
+}
+
+void __init
+setup_sched_clock_64(u64 (*read)(void), int bits, unsigned long rate)
+{
+	if (cd.rate > rate)
+		return;
+
+	BUG_ON(bits <= 32);
+	WARN_ON(!irqs_disabled());
+	read_sched_clock_64 = read;
+	sched_clock_func = sched_clock_64;
+	cd.rate = rate;
+	cd.mult = NSEC_PER_SEC / rate;
+	cd.epoch_ns = read_sched_clock_64();
+
+	sched_clock_calc_wrap(bits, rate);
+
+	try_to_enable_irqtime(rate);
+	pr_debug("Registered %pF as %u bit sched_clock source\n", read, bits);
+}
+
 unsigned long long notrace sched_clock(void)
 {
 	if (cd.suspended)
@@ -180,25 +220,34 @@ void __init sched_clock_postinit(void)
 {
 	/*
 	 * If no sched_clock function has been provided at that point,
-	 * make it the final one one.
+	 * make it the final one.
 	 */
-	if (read_sched_clock == jiffy_sched_clock_read)
+	if (read_sched_clock == jiffy_sched_clock_read && !read_sched_clock_64)
 		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
 
-	sched_clock_poll(sched_clock_timer.data);
+	if (sched_clock_func == sched_clock_32)
+		sched_clock_poll(sched_clock_timer.data);
 }
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(sched_clock_timer.data);
+	if (sched_clock_func == sched_clock_32)
+		sched_clock_poll(sched_clock_timer.data);
+	else
+		cd.epoch_ns = read_sched_clock_64();
+
 	cd.suspended = true;
 	return 0;
 }
 
 static void sched_clock_resume(void)
 {
-	cd.epoch_cyc = read_sched_clock();
-	cd.epoch_cyc_copy = cd.epoch_cyc;
+	if (sched_clock_func == sched_clock_32) {
+		cd.epoch_cyc = read_sched_clock();
+		cd.epoch_cyc_copy = cd.epoch_cyc;
+	} else {
+		cd.epoch_ns += read_sched_clock_64() - cd.epoch_ns;
+	}
 	cd.suspended = false;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

