Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaGPVED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:59600 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaGPVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:03:57 -0400
Message-Id: <20140716205052.597729567@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 05/64] ktime: Sanitize ktime_to_us/ms conversion
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=ktime-sanitize-conversion.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the plain nanoseconds based ktime_t we can simply use
ktime_divns() instead of going through loops and hoops of
timespec/timeval conversion.

Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |    6 ------
 include/linux/ktime.h   |   12 ++++++++----
 kernel/time/hrtimer.c   |    1 +
 3 files changed, 9 insertions(+), 10 deletions(-)

Index: tip/include/linux/hrtimer.h
===================================================================
--- tip.orig/include/linux/hrtimer.h
+++ tip/include/linux/hrtimer.h
@@ -457,12 +457,6 @@ extern void hrtimer_run_pending(void);
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
-#if BITS_PER_LONG < 64
-extern u64 ktime_divns(const ktime_t kt, s64 div);
-#else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
-#endif
-
 /* Show pending timers: */
 extern void sysrq_timer_list_show(void);
 
Index: tip/include/linux/ktime.h
===================================================================
--- tip.orig/include/linux/ktime.h
+++ tip/include/linux/ktime.h
@@ -157,16 +157,20 @@ static inline bool ktime_before(const kt
 	return ktime_compare(cmp1, cmp2) < 0;
 }
 
+#if BITS_PER_LONG < 64
+extern u64 ktime_divns(const ktime_t kt, s64 div);
+#else /* BITS_PER_LONG < 64 */
+# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
+#endif
+
 static inline s64 ktime_to_us(const ktime_t kt)
 {
-	struct timeval tv = ktime_to_timeval(kt);
-	return (s64) tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	return ktime_divns(kt, NSEC_PER_USEC);
 }
 
 static inline s64 ktime_to_ms(const ktime_t kt)
 {
-	struct timeval tv = ktime_to_timeval(kt);
-	return (s64) tv.tv_sec * MSEC_PER_SEC + tv.tv_usec / USEC_PER_MSEC;
+	return ktime_divns(kt, NSEC_PER_MSEC);
 }
 
 static inline s64 ktime_us_delta(const ktime_t later, const ktime_t earlier)
Index: tip/kernel/time/hrtimer.c
===================================================================
--- tip.orig/kernel/time/hrtimer.c
+++ tip/kernel/time/hrtimer.c
@@ -280,6 +280,7 @@ u64 ktime_divns(const ktime_t kt, s64 di
 
 	return dclc;
 }
+EXPORT_SYMBOL_GPL(ktime_divns);
 #endif /* BITS_PER_LONG >= 64 */
 
 /*


