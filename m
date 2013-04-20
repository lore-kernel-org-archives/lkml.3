Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513Ab3DTA3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:29:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47875 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab3DTA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:29:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,512,1363158000"; 
   d="scan'208";a="39938637"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4] ARM: sched_clock: Add support for >32 bit sched_clock
Date: Fri, 19 Apr 2013 17:29:05 -0700
Message-Id: <1366417746-24990-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arm architected system counter has at least 56 bits of
useable bits. Add support to ARM's sched_clock implementation for
counters with more than 32 bits so we can avoid the complexity of
dealing with wraparound on these devices while benefiting from
the irqtime accounting and suspend/resume handling that the ARM
sched_clock code already has.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Maybe we need a union for the epoch_ns usage?

 arch/arm/include/asm/sched_clock.h |   2 +
 arch/arm/kernel/sched_clock.c      | 101 +++++++++++++++++++++++++++----------
 2 files changed, 77 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sched_clock.h
index 3d520dd..7fcd2ee 100644
--- a/arch/arm/include/asm/sched_clock.h
+++ b/arch/arm/include/asm/sched_clock.h
@@ -13,4 +13,6 @@ extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 
 extern unsigned long long (*sched_clock_func)(void);
 
+extern void setup_sched_clock_64(u64 (*read)(void), int bits,
+				 unsigned long rate);
 #endif
diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 29ac613..7875e9e 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -44,6 +44,7 @@ static u32 notrace jiffy_sched_clock_read(void)
 }
 
 static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
+static u64 __read_mostly (*read_sched_clock_64)(void);
 
 static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
@@ -104,24 +105,12 @@ static void sched_clock_poll(unsigned long wrap_ticks)
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
@@ -135,12 +124,39 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
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
@@ -154,9 +170,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	 */
 	cd.epoch_ns = 0;
 
-	/* Enable IRQ time accounting if we have a fast enough sched_clock */
-	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
-		enable_sched_clock_irqtime();
+	try_to_enable_irqtime(rate);
 
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
@@ -169,6 +183,32 @@ static unsigned long long notrace sched_clock_32(void)
 
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
@@ -181,25 +221,34 @@ void __init sched_clock_postinit(void)
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

