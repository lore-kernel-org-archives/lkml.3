Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaGPVKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:10:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:59847 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaGPVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:03 -0400
Message-Id: <20140716205056.366206086@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 49/64] timekeeping: Simplify timekeeping_clocktai()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-simplify-clocktai.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timekeeping_clocktai() is not used in fast pathes, so the extra
timespec conversion is not problematic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |    5 +++++
 kernel/time/timekeeping.c   |   31 -------------------------------
 2 files changed, 5 insertions(+), 31 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -166,6 +166,11 @@ static inline void get_monotonic_boottim
 	*ts = ktime_to_timespec(ktime_get_boottime());
 }
 
+static inline void timekeeping_clocktai(struct timespec *ts)
+{
+	*ts = ktime_to_timespec(ktime_get_clocktai());
+}
+
 /*
  * RTC specific
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -497,37 +497,6 @@ void ktime_get_ts64(struct timespec64 *t
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
-
-/**
- * timekeeping_clocktai - Returns the TAI time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
- */
-void timekeeping_clocktai(struct timespec *ts)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 ts64;
-	unsigned long seq;
-	u64 nsecs;
-
-	WARN_ON(timekeeping_suspended);
-
-	do {
-		seq = read_seqcount_begin(&tk_core.seq);
-
-		ts64.tv_sec = tk->xtime_sec + tk->tai_offset;
-		nsecs = timekeeping_get_ns(tk);
-
-	} while (read_seqcount_retry(&tk_core.seq, seq));
-
-	ts64.tv_nsec = 0;
-	timespec64_add_ns(&ts64, nsecs);
-	*ts = timespec64_to_timespec(ts64);
-
-}
-EXPORT_SYMBOL(timekeeping_clocktai);
-
 #ifdef CONFIG_NTP_PPS
 
 /**


