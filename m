Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3GAJkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:40:42 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54051 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:40:41 -0400
X-AuditID: 9c930197-b7c79ae000003295-52-51d14e96793b
Date: Mon, 1 Jul 2013 18:40:40 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktime: add missing declaration of ktime_get() in ktime.h
Message-ID: <20130701094039.GB730@lge.com>
References: <1372657995-10903-1-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.02.1307011020260.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307011020260.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 10:20:46AM +0200, Thomas Gleixner wrote:
> On Mon, 1 Jul 2013, Joonsoo Kim wrote:
> 
> > We cannot use ktime_get() API even if we include ktime.h, because there is
> > no declaration of this API in ktime.h. So add it.
> 
> It's declared in hrtimer.h

Okay. How about this?

Thanks.

--------------------------------8<--------------------------------
>From 792b5ebc0b1450024db96bbf342399a31a5fc753 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 1 Jul 2013 14:30:40 +0900
Subject: [PATCH] ktime: move ktime related function declarations from
 hrtimer.h to ktime.h

We cannot use ktime_get() API even if we include ktime.h,
because there is no declaration of this API in ktime.h. Instead,
it is included in hrtimer.h.

It is natural that ktime related function declarations are in ktime.h.
It makes users use these APIs more easily.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..538ba54 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -324,14 +324,6 @@ static inline void timerfd_clock_was_set(void) { }
 #endif
 extern void hrtimers_resume(void);
 
-extern ktime_t ktime_get(void);
-extern ktime_t ktime_get_real(void);
-extern ktime_t ktime_get_boottime(void);
-extern ktime_t ktime_get_monotonic_offset(void);
-extern ktime_t ktime_get_clocktai(void);
-extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
-					 ktime_t *offs_tai);
-
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
 
@@ -452,12 +444,6 @@ extern void hrtimer_run_pending(void);
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
 
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index debf208..053022f 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -364,6 +364,20 @@ static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
 #define LOW_RES_NSEC		TICK_NSEC
 #define KTIME_LOW_RES		(ktime_t){ .tv64 = LOW_RES_NSEC }
 
+extern ktime_t ktime_get(void);
+extern ktime_t ktime_get_real(void);
+extern ktime_t ktime_get_boottime(void);
+extern ktime_t ktime_get_monotonic_offset(void);
+extern ktime_t ktime_get_clocktai(void);
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
+					 ktime_t *offs_tai);
+
+#if BITS_PER_LONG < 64
+extern u64 ktime_divns(const ktime_t kt, s64 div);
+#else /* BITS_PER_LONG < 64 */
+# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
+#endif
+
 /* Get the monotonic time in timespec format: */
 extern void ktime_get_ts(struct timespec *ts);
 
-- 
1.7.9.5

