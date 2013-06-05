Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3FEXyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:54:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60368 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3FEXyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:54:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCHv3 1/3] sched_clock: Add support for >32 bit sched_clock
Date: Wed,  5 Jun 2013 16:54:43 -0700
Message-Id: <1370476485-468-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370476485-468-1-git-send-email-sboyd@codeaurora.org>
References: <1370476485-468-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM architected system counter has at least 56 useable bits.
Add support for counters with more than 32 bits to the generic
sched_clock implementation so we can avoid the complexity of
dealing with wrap-around on these devices while benefiting from
the irqtime accounting and suspend/resume handling that the
generic sched_clock code already has.

All users should switch over to the 64bit read function so we can
deprecate setup_sched_clock() in favor of sched_clock_setup().

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I've noticed that we probably need to update the mult/shift
calculation similar to how clocksources are done. Should we
just copy/paste the maxsec calculation code here or do something
smarter?

 include/linux/sched_clock.h |  1 +
 kernel/time/sched_clock.c   | 41 +++++++++++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index fa7922c..81baaef 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -15,6 +15,7 @@ static inline void sched_clock_postinit(void) { }
 #endif
 
 extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
+extern void sched_clock_setup(u64 (*read)(void), int bits, unsigned long rate);
 
 extern unsigned long long (*sched_clock_func)(void);
 
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index aad1ae6..3478b6d 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -14,11 +14,12 @@
 #include <linux/syscore_ops.h>
 #include <linux/timer.h>
 #include <linux/sched_clock.h>
+#include <linux/bitops.h>
 
 struct clock_data {
 	u64 epoch_ns;
-	u32 epoch_cyc;
-	u32 epoch_cyc_copy;
+	u64 epoch_cyc;
+	u64 epoch_cyc_copy;
 	unsigned long rate;
 	u32 mult;
 	u32 shift;
@@ -35,24 +36,31 @@ static struct clock_data cd = {
 	.mult	= NSEC_PER_SEC / HZ,
 };
 
-static u32 __read_mostly sched_clock_mask = 0xffffffff;
+static u64 __read_mostly sched_clock_mask;
 
-static u32 notrace jiffy_sched_clock_read(void)
+static u64 notrace jiffy_sched_clock_read(void)
 {
-	return (u32)(jiffies - INITIAL_JIFFIES);
+	return (u64)(jiffies - INITIAL_JIFFIES);
 }
 
-static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
+static u32 __read_mostly (*read_sched_clock_32)(void);
+
+static u64 notrace read_sched_clock_32_wrapper(void)
+{
+	return read_sched_clock_32();
+}
+
+static u64 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
 static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace cyc_to_sched_clock(u64 cyc, u64 mask)
 {
 	u64 epoch_ns;
-	u32 epoch_cyc;
+	u64 epoch_cyc;
 
 	/*
 	 * Load the epoch_cyc and epoch_ns atomically.  We do this by
@@ -77,7 +85,7 @@ static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 static void notrace update_sched_clock(void)
 {
 	unsigned long flags;
-	u32 cyc;
+	u64 cyc;
 	u64 ns;
 
 	cyc = read_sched_clock();
@@ -103,7 +111,7 @@ static void sched_clock_poll(unsigned long wrap_ticks)
 	update_sched_clock();
 }
 
-void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+void __init sched_clock_setup(u64 (*read)(void), int bits, unsigned long rate)
 {
 	unsigned long r, w;
 	u64 res, wrap;
@@ -112,10 +120,9 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	if (cd.rate > rate)
 		return;
 
-	BUG_ON(bits > 32);
 	WARN_ON(!irqs_disabled());
 	read_sched_clock = read;
-	sched_clock_mask = (1 << bits) - 1;
+	sched_clock_mask = (1ULL << bits) - 1;
 	cd.rate = rate;
 
 	/* calculate the mult/shift to convert counter ticks to ns. */
@@ -160,9 +167,15 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
+void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
+{
+	read_sched_clock_32 = read;
+	sched_clock_setup(read_sched_clock_32_wrapper, bits, rate);
+}
+
 static unsigned long long notrace sched_clock_32(void)
 {
-	u32 cyc = read_sched_clock();
+	u64 cyc = read_sched_clock();
 	return cyc_to_sched_clock(cyc, sched_clock_mask);
 }
 
@@ -183,7 +196,7 @@ void __init sched_clock_postinit(void)
 	 * make it the final one one.
 	 */
 	if (read_sched_clock == jiffy_sched_clock_read)
-		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
+		sched_clock_setup(jiffy_sched_clock_read, BITS_PER_LONG, HZ);
 
 	sched_clock_poll(sched_clock_timer.data);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

