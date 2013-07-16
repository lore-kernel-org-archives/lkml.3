Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab3GPRgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:36:00 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:62812 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab3GPRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:08 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 08/10] alpha: Always enable the rpcc clocksource for single processor
Date: Tue, 16 Jul 2013 10:34:16 -0700
Message-Id: <1373996058-13399-9-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't depend on SMP, just check the number of processors online.
This allows a single distribution kernel to use the clocksource
when run on a single processor machine.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/time.c | 58 +++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index dbd56ec..cadb82b 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -186,6 +186,31 @@ common_init_rtc(void)
 	init_rtc_irq();
 }
 
+
+/*
+ * The RPCC as a clocksource primitive.
+ *
+ * While we have free-running timecounters running on all CPUs, and we make
+ * a half-hearted attempt in init_rtc_rpcc_info to sync the timecounter
+ * with the wall clock, that initialization isn't kept up-to-date across
+ * different time counters in SMP mode.  Therefore we can only use this
+ * method when there's only one CPU enabled.
+ */
+
+static cycle_t read_rpcc(struct clocksource *cs)
+{
+	return rpcc();
+}
+
+static struct clocksource clocksource_rpcc = {
+	.name                   = "rpcc",
+	.rating                 = 300,
+	.read                   = read_rpcc,
+	.mask                   = CLOCKSOURCE_MASK(32),
+	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS
+};
+
+
 /* Validate a computed cycle counter result against the known bounds for
    the given processor core.  There's too much brokenness in the way of
    timing hardware for any one method to work everywhere.  :-(
@@ -296,33 +321,6 @@ rpcc_after_update_in_progress(void)
 	return rpcc();
 }
 
-#ifndef CONFIG_SMP
-/* Until and unless we figure out how to get cpu cycle counters
-   in sync and keep them there, we can't use the rpcc.  */
-static cycle_t read_rpcc(struct clocksource *cs)
-{
-	cycle_t ret = (cycle_t)rpcc();
-	return ret;
-}
-
-static struct clocksource clocksource_rpcc = {
-	.name                   = "rpcc",
-	.rating                 = 300,
-	.read                   = read_rpcc,
-	.mask                   = CLOCKSOURCE_MASK(32),
-	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS
-};
-
-static inline void register_rpcc_clocksource(long cycle_freq)
-{
-	clocksource_register_hz(&clocksource_rpcc, cycle_freq);
-}
-#else /* !CONFIG_SMP */
-static inline void register_rpcc_clocksource(long cycle_freq)
-{
-}
-#endif /* !CONFIG_SMP */
-
 void __init
 time_init(void)
 {
@@ -364,20 +362,20 @@ time_init(void)
 		       "and unable to estimate a proper value!\n");
 	}
 
+	if (hwrpb->nr_processors == 1)
+		clocksource_register_hz(&clocksource_rpcc, cycle_freq);
+
 	/* From John Bowman <bowman@math.ualberta.ca>: allow the values
 	   to settle, as the Update-In-Progress bit going low isn't good
 	   enough on some hardware.  2ms is our guess; we haven't found 
 	   bogomips yet, but this is close on a 500Mhz box.  */
 	__delay(1000000);
 
-
 	if (HZ > (1<<16)) {
 		extern void __you_loose (void);
 		__you_loose();
 	}
 
-	register_rpcc_clocksource(cycle_freq);
-
 	state.last_time = cc1;
 	state.scaled_ticks_per_cycle
 		= ((unsigned long) HZ << FIX_SHIFT) / cycle_freq;
-- 
1.8.1.4

