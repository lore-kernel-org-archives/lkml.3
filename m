Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaGPVSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:18:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:59670 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaGPVEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:16 -0400
Message-Id: <20140716205053.661519882@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 18/64] timekeeping: Use ktime_t based data for
 ktime_get_real()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-use-ktime-based-for-ktime-get-real.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speed up the readout.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |    9 ++++++++-
 kernel/time/timekeeping.c   |   15 ---------------
 2 files changed, 8 insertions(+), 16 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -108,11 +108,18 @@ enum tk_offsets {
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
-extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
 extern ktime_t ktime_get_clocktai(void);
 
+/**
+ * ktime_get_real - get the real (wall-) time in ktime_t format
+ */
+static inline ktime_t ktime_get_real(void)
+{
+	return ktime_get_with_offset(TK_OFFS_REAL);
+}
+
 /*
  * RTC specific
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -774,21 +774,6 @@ int timekeeping_notify(struct clocksourc
 }
 
 /**
- * ktime_get_real - get the real (wall-) time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get_real(void)
-{
-	struct timespec64 now;
-
-	getnstimeofday64(&now);
-
-	return timespec64_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get_real);
-
-/**
  * getrawmonotonic - Returns the raw monotonic time in a timespec
  * @ts:		pointer to the timespec to be set
  *


