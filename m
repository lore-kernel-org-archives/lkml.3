Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaBUR4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:56:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:42639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaBUR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:56:08 -0500
Message-Id: <20140221174639.671080100@linutronix.de>
User-Agent: quilt/0.60-1
Date: Fri, 21 Feb 2014 17:56:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [RFC patch 3/5] hrtimer: Add support for deferrable hrtimers
References: <20140221173936.583477951@linutronix.de>
Content-Disposition: inline;
 filename=hrtimer-add-support-for-deferrable-timer-into-the-hrtimer.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deferrable timers have a relaxed expiry mode. The timers are not
guaranteed to expire at the programmed expiry time. They are always
batched with the expiry of non deferrrable timers. If the system goes
idle non deferrable timers are not taken into account for the
calculation of the next timer expiry. This helps for power saving as
the deferrable timers do not wake an idle system.

So far we have only support for deferrable timers for the timer wheel.
User space applications want to optimize their timer usage for power
consumption as well, but the user space interfaces are based on
hrtimers.

There is no way to bring back timer wheel timers to user space
interfaces as they would reintroduce the problems of CLOCK_REALTIME
and clock setting again and add quite some mess to the various
interfaces.

Add deferrable hrtimer support instead. The deferrable hrtimers are
stored in separate hrtimer bases which have the same underlying rules
as the non deferrable standard bases. The deferrable mode is selected
by the new HRTIMER_MODE_DEFERRABLE flag, which is ored on
HRTIMER_MODE_REL/ABS.

The new deferrable bases are not taken into account when the
underlying clock event device is programmed in high resolution mode
and they are not accounted for when the system retrieves the next
expiring timer for an extended idle sleep.

There is no impact on the non deferred hrtimers by the deferred ones
aside of a slightly larger memory footprint.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/hrtimer.h |    8 ++++-
 kernel/hrtimer.c        |   72 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 11 deletions(-)

Index: tip/include/linux/hrtimer.h
===================================================================
--- tip.orig/include/linux/hrtimer.h
+++ tip/include/linux/hrtimer.h
@@ -36,6 +36,7 @@ enum hrtimer_mode {
 	HRTIMER_MODE_PINNED = 0x02,	/* Timer is bound to CPU */
 	HRTIMER_MODE_ABS_PINNED = 0x02,
 	HRTIMER_MODE_REL_PINNED = 0x03,
+	HRTIMER_MODE_DEFERRABLE = 0x04, /* Timer is deferrable */
 };
 
 /*
@@ -158,7 +159,8 @@ enum  hrtimer_base_type {
 	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_BOOTTIME,
 	HRTIMER_BASE_TAI,
-	HRTIMER_MAX_CLOCK_BASES,
+	HRTIMER_MAX_STD_BASES,
+	HRTIMER_MAX_CLOCK_BASES = 2 * HRTIMER_MAX_STD_BASES,
 };
 
 /*
@@ -175,7 +177,9 @@ enum  hrtimer_base_type {
  * @nr_retries:		Total number of hrtimer interrupt retries
  * @nr_hangs:		Total number of hrtimer interrupt hangs
  * @max_hang_time:	Maximum time spent in hrtimer_interrupt
- * @clock_base:		array of clock bases for this cpu
+ * @clock_base:		array of clock bases for this cpu. The array size is
+ *			twice the MAX_STD_BASES size. The second part is
+ *			a duplication of the first for deferrable timers.
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
Index: tip/kernel/hrtimer.c
===================================================================
--- tip.orig/kernel/hrtimer.c
+++ tip/kernel/hrtimer.c
@@ -92,6 +92,30 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base,
 			.get_time = &ktime_get_clocktai,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = HRTIMER_BASE_MONOTONIC + HRTIMER_MAX_STD_BASES,
+			.clockid = CLOCK_MONOTONIC,
+			.get_time = &ktime_get,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_REALTIME + HRTIMER_MAX_STD_BASES,
+			.clockid = CLOCK_REALTIME,
+			.get_time = &ktime_get_real,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_BOOTTIME + HRTIMER_MAX_STD_BASES,
+			.clockid = CLOCK_BOOTTIME,
+			.get_time = &ktime_get_boottime,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_TAI + HRTIMER_MAX_STD_BASES,
+			.clockid = CLOCK_TAI,
+			.get_time = &ktime_get_clocktai,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
@@ -194,7 +218,9 @@ hrtimer_check_target(struct hrtimer *tim
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t expires;
 
-	if (!new_base->cpu_base->hres_active)
+	/* We do not touch hardware for deferrable timers */
+	if (!new_base->cpu_base->hres_active ||
+	    new_base->index >= HRTIMER_MAX_STD_BASES)
 		return 0;
 
 	expires = ktime_sub(hrtimer_get_expires(timer), new_base->offset);
@@ -556,7 +582,7 @@ hrtimer_force_reprogram(struct hrtimer_c
 
 	expires_next.tv64 = KTIME_MAX;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+	for (i = 0; i < HRTIMER_MAX_STD_BASES; i++, base++) {
 		struct hrtimer *timer;
 		struct timerqueue_node *next;
 
@@ -615,6 +641,13 @@ static int hrtimer_reprogram(struct hrti
 		return 0;
 
 	/*
+	 * Deferrable timers are not touching the underlying
+	 * hardware.
+	 */
+	if (base->index >= HRTIMER_MAX_STD_BASES)
+		return 0;
+
+	/*
 	 * CLOCK_REALTIME timer might be requested with an absolute
 	 * expiry time which is less than base->offset. Nothing wrong
 	 * about that, just avoid to call into the tick code, which
@@ -924,7 +957,10 @@ static void __remove_hrtimer(struct hrti
 
 			expires = ktime_sub(hrtimer_get_expires(timer),
 					    base->offset);
-			if (base->cpu_base->expires_next.tv64 == expires.tv64)
+
+			/* We only care about non deferrable timers here */
+			if (base->index < HRTIMER_MAX_STD_BASES &&
+			    base->cpu_base->expires_next.tv64 == expires.tv64)
 				hrtimer_force_reprogram(base->cpu_base, 1);
 		}
 #endif
@@ -1152,7 +1188,8 @@ ktime_t hrtimer_get_next_event(void)
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
 	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		/* We only care about non deferrable timers here */
+		for (i = 0; i < HRTIMER_MAX_STD_BASES; i++, base++) {
 			struct hrtimer *timer;
 			struct timerqueue_node *next;
 
@@ -1190,6 +1227,9 @@ static void __hrtimer_init(struct hrtime
 		clock_id = CLOCK_MONOTONIC;
 
 	base = hrtimer_clockid_to_base(clock_id);
+	if (mode & HRTIMER_MODE_DEFERRABLE)
+		base += HRTIMER_MAX_STD_BASES;
+
 	timer->base = &cpu_base->clock_base[base];
 	timerqueue_init(&timer->node);
 
@@ -1342,8 +1382,14 @@ retry:
 						    base->offset);
 				if (expires.tv64 < 0)
 					expires.tv64 = KTIME_MAX;
-				if (expires.tv64 < expires_next.tv64)
-					expires_next = expires;
+				if (expires.tv64 < expires_next.tv64) {
+					/*
+					 * We do not take deferrable timers
+					 * into account here:
+					 */
+					if (idx < HRTIMER_MAX_STD_BASES)
+						expires_next = expires;
+				}
 				break;
 			}
 
@@ -1584,14 +1630,20 @@ static int update_rmtp(struct hrtimer *t
 	return 1;
 }
 
+#define CLOCKID_DEFERRABLE	0x8000
+
 long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 {
-	struct hrtimer_sleeper t;
+	clockid_t clockid = restart->nanosleep.clockid & ~CLOCKID_DEFERRABLE;
+	enum hrtimer_mode mode = HRTIMER_MODE_ABS;
 	struct timespec __user  *rmtp;
+	struct hrtimer_sleeper t;
 	int ret = 0;
 
-	hrtimer_init_on_stack(&t.timer, restart->nanosleep.clockid,
-				HRTIMER_MODE_ABS);
+	if (restart->nanosleep.clockid & CLOCKID_DEFERRABLE)
+		mode |= HRTIMER_MODE_DEFERRABLE;
+
+	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
@@ -1643,6 +1695,8 @@ long hrtimer_nanosleep(struct timespec *
 	restart = &current_thread_info()->restart_block;
 	restart->fn = hrtimer_nanosleep_restart;
 	restart->nanosleep.clockid = t.timer.base->clockid;
+	if (mode & HRTIMER_MODE_DEFERRABLE)
+		restart->nanosleep.clockid |= CLOCKID_DEFERRABLE;
 	restart->nanosleep.rmtp = rmtp;
 	restart->nanosleep.expires = hrtimer_get_expires_tv64(&t.timer);
 


