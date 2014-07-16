Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaGPVK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:10:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:59843 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaGPVFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:01 -0400
Message-Id: <20140716205056.278585187@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 48/64] timekeeping: Remove timekeeper.total_sleep_time
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-kill-total-sleep-time.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users. Remove it

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    6 ++----
 kernel/time/timekeeping.c           |   14 +++-----------
 2 files changed, 5 insertions(+), 15 deletions(-)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -20,8 +20,8 @@
  * the tv_nsec part positive so we can use the usual normalization.
  *
  * wall_to_monotonic is moved after resume from suspend for the
- * monotonic time not to jump. We need to add total_sleep_time to
- * wall_to_monotonic to get the real boot based time offset.
+ * monotonic time not to jump. To calculate the real boot time offset
+ * we need to do offs_real - offs_boot.
  *
  * - wall_to_monotonic is no longer the boot time, getboottime must be
  * used instead.
@@ -51,8 +51,6 @@ struct timekeeper {
 	/* Offset clock monotonic -> clock tai */
 	ktime_t			offs_tai;
 
-	/* time spent in suspend */
-	struct timespec64	total_sleep_time;
 	/* The current UTC to TAI offset in seconds */
 	s32			tai_offset;
 
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -97,13 +97,9 @@ static void tk_set_wall_to_mono(struct t
 	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
 
-static void tk_set_sleep_time(struct timekeeper *tk, struct timespec64 t)
+static inline void tk_update_sleep_time(struct timekeeper *tk, ktime_t delta)
 {
-	/* Verify consistency before modifying */
-	WARN_ON_ONCE(tk->offs_boot.tv64 != timespec64_to_ktime(tk->total_sleep_time).tv64);
-
-	tk->total_sleep_time	= t;
-	tk->offs_boot		= timespec64_to_ktime(t);
+	tk->offs_boot = ktime_add(tk->offs_boot, delta);
 }
 
 /**
@@ -919,10 +915,6 @@ void __init timekeeping_init(void)
 	set_normalized_timespec64(&tmp, -boot.tv_sec, -boot.tv_nsec);
 	tk_set_wall_to_mono(tk, tmp);
 
-	tmp.tv_sec = 0;
-	tmp.tv_nsec = 0;
-	tk_set_sleep_time(tk, tmp);
-
 	timekeeping_update(tk, TK_MIRROR);
 
 	write_seqcount_end(&tk_core.seq);
@@ -950,7 +942,7 @@ static void __timekeeping_inject_sleepti
 	}
 	tk_xtime_add(tk, delta);
 	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, *delta));
-	tk_set_sleep_time(tk, timespec64_add(tk->total_sleep_time, *delta));
+	tk_update_sleep_time(tk, timespec64_to_ktime(*delta));
 	tk_debug_account_sleep_time(delta);
 }
 


