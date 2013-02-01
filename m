Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3BAJ34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:29:56 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:58076 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3BAJ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:29:53 -0500
MIME-Version: 1.0
From: wolfwings@wolfwings.us
Date: Fri, 1 Feb 2013 03:29:30 -0600
X-Google-Sender-Auth: xLdLWX0swk9sPfaWPAlXHUd_l6A
Message-ID: <CAG+9BZU61ARAarJvmoS1jWQQmDOtRVsRh-RhL_4txE+17B_-2w@mail.gmail.com>
Subject: Load Average constants
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, please CC me directly if possible, I simply can't withstand the
firehose of subscribing to the full LKML but per the MAINTIANERS file this
was where this patch should go for open discussion.

If I should have posted it as two parts, I'll go do that straight away:

1) It's removing a "+1" from one constant and changing the relevant
   comparisons to use "or equals" thus the changes to kernel/sched/core.c

2) It's converting the constants there to take advantage of platforms where
   unsigned long is 64-bit, as well as making them more readable via making
   the formula's explicit.

The two steps can be done separately if preferred but they overlap and #1
improves readability of intent in the code as well as avoids duplication of
description of the issue since it's all modifying constants.

Historically (dating back to somewhere between 0.96c and 0.99.11) the load
average constants have been an opaque set of numbers tuned for 32-bit use,
allowing for a rating of just under 1024 and limiting the load-average
update math from running more than every 5 seconds.

On many newer architectures, the underlying datatype (unsigned long) ends up
being 64-bit, but the same fixed-point values are used. This results in an
upper bound of X<(2<<42) for the load-averages.

This patch detects when unsigned longs are 64-bit versus 32-bit, and adjusts
the underlying constants to allow for 1-second granularity of the load-
average calculation as well as reducing the load-average 'cap' back to
X<1024, while making the underlying math regarding the constants apparent.

One odd note this has brought up, it appears the original EXP_1 constant may
be incorrect, as the math (unless I grossly misunderstand the equations)
indicates 1884 only gives a roughly 55-second window, 1878 being what my
equations return. The equations sync for the 5-minute and 15-minute, and
are rounding-error on the 32-bit 2-second-granularity-1-minute-interval
(whew, what a mouthful) value so they appear to be correct.

diff -uprN linux-3.8-rc6-vanilla/include/linux/sched.h
linux-3.8-rc6-highprecisionloadavg/include/linux/sched.h
--- linux-3.8-rc6-vanilla/include/linux/sched.h	2013-01-31
19:08:14.000000000 -0600
+++ linux-3.8-rc6-highprecisionloadavg/include/linux/sched.h	2013-02-01
02:51:26.840030279 -0600
@@ -69,24 +69,31 @@ struct blk_plug;
 #define CLONE_KERNEL	(CLONE_FS | CLONE_FILES | CLONE_SIGHAND)

 /*
- * These are the constant used to fake the fixed-point load-average
+ * These are the constants used to fake the fixed-point load-average
  * counting. Some notes:
- *  - 11 bit fractions expand to 22 bits by the multiplies: this gives
- *    a load-average precision of 10 bits integer + 11 bits fractional
- *  - if you want to count load-averages more often, you need more
- *    precision, or rounding will get you. With 2-second counting freq,
- *    the EXP_n values would be 1981, 2034 and 2043 if still using only
- *    11 bit fractions.
+ *  - For historical reasons a LoadAVG of up to 1023 needs to be valid
+ *    so we need 10 bits of precision before the decimal point.
+ *  - Cut the remaining bits in half to see how much precision to use.
+ *  - This means for 32-bit? 22/2=11 bits. 64-bit? 54/2=27 bits.
+ *  - Higher precision allows for more frequent counting; while 32-bit
+ *    platforms run into precision problems below 5 second cycles, 64-
+ *    bit platforms are fine all the way down to sub-second speeds.
  */
 extern unsigned long avenrun[];		/* Load averages */
 extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);

-#define FSHIFT		11		/* nr of bits of precision */
-#define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
-#define LOAD_FREQ	(5*HZ+1)	/* 5 sec intervals */
-#define EXP_1		1884		/* 1/exp(5sec/1min) as fixed-point */
-#define EXP_5		2014		/* 1/exp(5sec/5min) */
-#define EXP_15		2037		/* 1/exp(5sec/15min) */
+#if (BITS_PER_LONG == 64)
+#define FSHIFT		27		/* bits of precision */
+#define LOAD_FREQ	(1*HZ)		/* 1 sec intervals */
+#else
+#define FSHIFT		11		/* bits of precision */
+#define LOAD_FREQ	(5*HZ)		/* 5 sec intervals */
+#endif
+
+#define FIXED_1		(1UL<<FSHIFT)	/* 1.0 as fixed-point */
+#define EXP_1		(FIXED_1-((FIXED_1*LOAD_FREQ)/(HZ*1*60UL)))
+#define EXP_5		(FIXED_1-((FIXED_1*LOAD_FREQ)/(HZ*5*60UL)))
+#define EXP_15		(FIXED_1-((FIXED_1*LOAD_FREQ)/(HZ*15*60UL)))

 #define CALC_LOAD(load,exp,n) \
 	load *= exp; \
diff -uprN linux-3.8-rc6-vanilla/kernel/sched/core.c
linux-3.8-rc6-highprecisionloadavg/kernel/sched/core.c
--- linux-3.8-rc6-vanilla/kernel/sched/core.c	2013-01-31
19:08:14.000000000 -0600
+++ linux-3.8-rc6-highprecisionloadavg/kernel/sched/core.c	2013-02-01
02:43:26.113342542 -0600
@@ -2191,7 +2191,7 @@ static inline int calc_load_write_idx(vo
 	 * If the folding window started, make sure we start writing in the
 	 * next idle-delta.
 	 */
-	if (!time_before(jiffies, calc_load_update))
+	if (!time_before_eq(jiffies, calc_load_update))
 		idx++;

 	return idx & 1;
@@ -2225,7 +2225,7 @@ void calc_load_exit_idle(void)
 	/*
 	 * If we're still before the sample window, we're done.
 	 */
-	if (time_before(jiffies, this_rq->calc_load_update))
+	if (time_before_eq(jiffies, this_rq->calc_load_update))
 		return;

 	/*
@@ -2234,7 +2234,7 @@ void calc_load_exit_idle(void)
 	 * sync up for the next window.
 	 */
 	this_rq->calc_load_update = calc_load_update;
-	if (time_before(jiffies, this_rq->calc_load_update + 10))
+	if (time_before_eq(jiffies, this_rq->calc_load_update + 10))
 		this_rq->calc_load_update += LOAD_FREQ;
 }

@@ -2330,7 +2330,7 @@ static void calc_global_nohz(void)
 {
 	long delta, active, n;

-	if (!time_before(jiffies, calc_load_update + 10)) {
+	if (!time_before_eq(jiffies, calc_load_update + 10)) {
 		/*
 		 * Catch-up, fold however many we are behind still
 		 */
@@ -2372,7 +2372,7 @@ void calc_global_load(unsigned long tick
 {
 	long active, delta;

-	if (time_before(jiffies, calc_load_update + 10))
+	if (time_before_eq(jiffies, calc_load_update + 10))
 		return;

 	/*
@@ -2405,7 +2405,7 @@ static void calc_load_account_active(str
 {
 	long delta;

-	if (time_before(jiffies, this_rq->calc_load_update))
+	if (time_before_eq(jiffies, this_rq->calc_load_update))
 		return;

 	delta  = calc_load_fold_active(this_rq);
