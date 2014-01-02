Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaABSbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:31:38 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37824 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaABSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:31:36 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-aa-52c5b0856fac
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 3/3] timerfd: Add support for deferrable timers
Date: Thu, 02 Jan 2014 22:30:48 +0400
Message-id: <1388687448-12987-4-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xq7qtG44GGaw+zmox9+55Fos569ew
	WVxsvc1icXCrpsWZ37oWZ5vesFtc3jWHzYHdY0L/J0aPO9f2sHmcmPGbxaNvyypGj8+b5AJY
	o7hsUlJzMstSi/TtErgymq88YC64a1Ix+UQXawPjUq0uRk4OCQETiZtPV7NA2GISF+6tZwOx
	hQSWMkp0nTTqYuQCsmcwSdy++gYowcHBJmAgse+eLUiNiICFxJ1X/1lBapgFdjFKfP2/jxGk
	RljAXqJrVRhIDYuAqsSO5yuYQGxeAXeJ25tuMoOUSAgoSMyZZAMS5hTwkFh/5RYzxFp3ienr
	OxgnMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESTF93MC49ZnWIUYCDUYmH90Pd
	0SAh1sSy4srcQ4wSHMxKIrz6M4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGNUT57e3sF+5sWv1
	uUbzht27M5aoJfZ9vf0gvIpH4CHbtoUTbvA1TtXgZ3n5d8lhqRsHNGq3lzxcqpDzSKojdw33
	uykBDx64cubLfQqcu79nwayovklv4l6F3F2w/ANDw/e8bY+Wf5O2ZNux0XrhHi8p/5139/M/
	m3647Vzglm2CykVbwoVLM2yUWIozEg21mIuKEwEANeWtBAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton@enomsg.org>

This patch implements a userland-side API for generic deferrable timers,
per linux/timer.h:

 * A deferrable timer will work normally when the system is busy, but
 * will not cause a CPU to come out of idle just to service it; instead,
 * the timer will be serviced when the CPU eventually wakes up with a
 * subsequent non-deferrable timer.

These timers are crucial for power saving, i.e. periodic tasks that want
to work in background when the system is under use, but don't want to
cause wakeups themselves.

The deferred timers are somewhat orthogonal to high-res external timers,
since the deferred timer is tied to the system load, not just to some
external decrementer source.

So, currently, the implementation has a HZ precision, and the maximum
interval is jiffies resolution (i.e. with HZ=1000, on 32 bit that would
be around max 49 days).  Of course we can implement longer timeouts by
rearming the timer, although it probably  wouldn't make much sense in
real world, so we keep it simple and just return E2BIG if we don't like
the interval.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 fs/timerfd.c              |   59 ++++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/time.h |    1 +
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 3561ce7..331ce4b 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -30,6 +30,7 @@ struct timerfd_ctx {
 	union {
 		struct hrtimer tmr;
 		struct alarm alarm;
+		struct timer_list dtmr;
 	} t;
 	ktime_t tintv;
 	ktime_t moffs;
@@ -51,6 +52,11 @@ static inline bool isalarm(struct timerfd_ctx *ctx)
 		ctx->clockid == CLOCK_BOOTTIME_ALARM;
 }
 
+static inline bool isdeferrable(struct timerfd_ctx *ctx)
+{
+	return ctx->clockid == CLOCK_DEFERRABLE;
+}
+
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
@@ -75,6 +81,11 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 	return HRTIMER_NORESTART;
 }
 
+static void timerfd_dtmrproc(unsigned long data)
+{
+	timerfd_triggered((struct timerfd_ctx *)data);
+}
+
 static enum alarmtimer_restart timerfd_alarmproc(struct alarm *alarm,
 	ktime_t now)
 {
@@ -151,12 +162,36 @@ static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 
 	if (isalarm(ctx))
 		remaining = alarm_expires_remaining(&ctx->t.alarm);
-	else
+	else if (isdeferrable(ctx)) {
+		ktime_t expires;
+		jiffies_to_ktime(ctx->t.dtmr.expires, &expires);
+		remaining = ktime_sub(expires, ktime_get());
+	} else
 		remaining = hrtimer_expires_remaining(&ctx->t.tmr);
 
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
 
+static bool timerfd_deferrable_valid(ktime_t intv)
+{
+	ktime_t max;
+
+	jiffies_to_ktime(MAX_JIFFY_OFFSET, &max);
+	if (intv.tv64 > max.tv64)
+		return 0;
+	return 1;
+}
+
+static int timerfd_setup_deferrable(struct timerfd_ctx *ctx, ktime_t texp)
+{
+	if (!timerfd_deferrable_valid(ctx->tintv) ||
+			!timerfd_deferrable_valid(texp))
+		return -E2BIG;
+
+	mod_timer(&ctx->t.dtmr, ktime_to_jiffies(&texp) + 1);
+	return 0;
+}
+
 static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			 const struct itimerspec *ktmr)
 {
@@ -177,6 +212,9 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			   ctx->clockid == CLOCK_REALTIME_ALARM ?
 			   ALARM_REALTIME : ALARM_BOOTTIME,
 			   timerfd_alarmproc);
+	} else if (isdeferrable(ctx)) {
+		ctx->t.dtmr.function = timerfd_dtmrproc;
+	        ctx->t.dtmr.data = (unsigned long)ctx;
 	} else {
 		hrtimer_init(&ctx->t.tmr, clockid, htmode);
 		hrtimer_set_expires(&ctx->t.tmr, texp);
@@ -189,6 +227,8 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 				alarm_start(&ctx->t.alarm, texp);
 			else
 				alarm_start_relative(&ctx->t.alarm, texp);
+		} else if (isdeferrable(ctx)) {
+			timerfd_setup_deferrable(ctx, texp);
 		} else {
 			hrtimer_start(&ctx->t.tmr, texp, htmode);
 		}
@@ -207,6 +247,8 @@ static int timerfd_release(struct inode *inode, struct file *file)
 
 	if (isalarm(ctx))
 		alarm_cancel(&ctx->t.alarm);
+	else if (isdeferrable(ctx))
+		del_timer_sync(&ctx->t.dtmr);
 	else
 		hrtimer_cancel(&ctx->t.tmr);
 	kfree_rcu(ctx, rcu);
@@ -231,12 +273,15 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 
 static u64 timerfd_rearm(struct timerfd_ctx *ctx)
 {
-	u64 orun;
+	u64 orun = 0;
 
 	if (isalarm(ctx)) {
 		orun += alarm_forward_now(
 			&ctx->t.alarm, ctx->tintv) - 1;
 		alarm_restart(&ctx->t.alarm);
+	} else if (isdeferrable(ctx)) {
+		mod_timer(&ctx->t.dtmr, jiffies +
+			ktime_to_jiffies(&ctx->tintv) + 1);
 	} else {
 		orun += hrtimer_forward_now(&ctx->t.tmr,
 		     ctx->tintv) - 1;
@@ -326,7 +371,8 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	    (clockid != CLOCK_MONOTONIC &&
 	     clockid != CLOCK_REALTIME &&
 	     clockid != CLOCK_REALTIME_ALARM &&
-	     clockid != CLOCK_BOOTTIME_ALARM))
+	     clockid != CLOCK_BOOTTIME_ALARM &&
+	     clockid != CLOCK_DEFERRABLE))
 		return -EINVAL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -341,6 +387,8 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 			   ctx->clockid == CLOCK_REALTIME_ALARM ?
 			   ALARM_REALTIME : ALARM_BOOTTIME,
 			   timerfd_alarmproc);
+	else if (isdeferrable(ctx))
+		init_timer_deferrable(&ctx->t.dtmr);
 	else
 		hrtimer_init(&ctx->t.tmr, clockid, HRTIMER_MODE_ABS);
 
@@ -354,7 +402,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	return ufd;
 }
 
-static int do_timerfd_settime(int ufd, int flags, 
+static int do_timerfd_settime(int ufd, int flags,
 		const struct itimerspec *new,
 		struct itimerspec *old)
 {
@@ -384,6 +432,9 @@ static int do_timerfd_settime(int ufd, int flags,
 		if (isalarm(ctx)) {
 			if (alarm_try_to_cancel(&ctx->t.alarm) >= 0)
 				break;
+		} else if (isdeferrable(ctx)) {
+			if (try_to_del_timer_sync(&ctx->t.dtmr) >= 0)
+				break;
 		} else {
 			if (hrtimer_try_to_cancel(&ctx->t.tmr) >= 0)
 				break;
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index e75e1b6..3481cb3 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -56,6 +56,7 @@ struct itimerval {
 #define CLOCK_BOOTTIME_ALARM		9
 #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
 #define CLOCK_TAI			11
+#define CLOCK_DEFERRABLE		12
 
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
-- 
1.7.9.5

