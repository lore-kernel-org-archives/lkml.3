Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaGPVD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:03:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:59585 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGPVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:03:52 -0400
Message-Id: <20140716205052.346708232@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch V2 02/64] timekeeping: Simplify arch_gettimeoffset()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-simplify-arch-offset.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a default stub function instead of having the extra
conditional. Cuts binary size on a m68k build by ~100 bytes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/time/timekeeping.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -153,16 +153,10 @@ static void tk_setup_internals(struct ti
 /* Timekeeper helper functions. */
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-u32 (*arch_gettimeoffset)(void);
-
-u32 get_arch_timeoffset(void)
-{
-	if (likely(arch_gettimeoffset))
-		return arch_gettimeoffset();
-	return 0;
-}
+static u32 default_arch_gettimeoffset(void) { return 0; }
+u32 (*arch_gettimeoffset)(void) = default_arch_gettimeoffset;
 #else
-static inline u32 get_arch_timeoffset(void) { return 0; }
+static inline u32 arch_gettimeoffset(void) { return 0; }
 #endif
 
 static inline s64 timekeeping_get_ns(struct timekeeper *tk)
@@ -182,7 +176,7 @@ static inline s64 timekeeping_get_ns(str
 	nsec >>= tk->shift;
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	return nsec + get_arch_timeoffset();
+	return nsec + arch_gettimeoffset();
 }
 
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
@@ -202,7 +196,7 @@ static inline s64 timekeeping_get_ns_raw
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	return nsec + get_arch_timeoffset();
+	return nsec + arch_gettimeoffset();
 }
 
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
@@ -282,7 +276,7 @@ static void timekeeping_forward_now(stru
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	tk->xtime_nsec += (u64)get_arch_timeoffset() << tk->shift;
+	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
 
 	tk_normalize_xtime(tk);
 


