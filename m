Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaAMKpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:45:34 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38042 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaAMKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:45:27 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-b6-52d3c3c5d031
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, cw00.choi@samsung.com,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v2 3/3] timerfd: Add support for deferrable timers
Date: Mon, 13 Jan 2014 14:43:55 +0400
Message-id: <1389609835-24377-4-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsVy+t/xa7pHD18OMvh7Q9li7t3zLBZz1q9h
	szi4VdPi+pfnrBZnfutanG16w25xedccNgd2jwn9nxg97lzbw+ZxYsZvFo++LasYPT5vkgtg
	jeKySUnNySxLLdK3S+DK+LJrIlPBCauKkwd+MjYwPtXrYuTkkBAwkWh7s4wZwhaTuHBvPVsX
	IxeHkMBSRomNp1YwQzgzmCQu/v/B3sXIwcEmYCCx754tSIOIgIXEnVf/WUFqmAUWM0qc2rKN
	CSQhLOAk8fr+SjCbRUBV4srbbawgvbwC7hKPF4uBmBICChJzJtmAVHAKeEgcX7KVEcQWAqo4
	Pv8r4wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsLp6w7GpcesDjEKcDAq8fDu
	ELocJMSaWFZcmXuIUYKDWUmEt/AQUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjRePivg0Z2u8N
	45bnza2tEPtoL5jEZhyw2GOR56G4Yr0Di44dNl7E/W+nfcRmrf8XthTe2832+nz5+6xzYSVt
	a3X2rEqf+OplXs9HbdVbz/cf98g8+HhL2+lltswJtc7nzT+mHyoqvMLydmX8ZcbD1sHrtul5
	ZlSt5PNj6tDYptL8OV09ofO5EktxRqKhFnNRcSIABwu0ngUCAAA=
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

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 fs/timerfd.c            |   89 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/timerfd.h |    4 ++-
 2 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 3561ce7..9677a66 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -31,6 +31,8 @@ struct timerfd_ctx {
 		struct hrtimer tmr;
 		struct alarm alarm;
 	} t;
+	struct timer_list dtmr;
+	bool deferrable;
 	ktime_t tintv;
 	ktime_t moffs;
 	wait_queue_head_t wqh;
@@ -51,6 +53,11 @@ static inline bool isalarm(struct timerfd_ctx *ctx)
 		ctx->clockid == CLOCK_BOOTTIME_ALARM;
 }
 
+static inline bool isdeferrable(struct timerfd_ctx *ctx)
+{
+	return ctx->deferrable;
+}
+
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
@@ -84,6 +91,11 @@ static enum alarmtimer_restart timerfd_alarmproc(struct alarm *alarm,
 	return ALARMTIMER_NORESTART;
 }
 
+static void timerfd_dtmrproc(unsigned long data)
+{
+	timerfd_triggered((struct timerfd_ctx *)data);
+}
+
 /*
  * Called when the clock was set to cancel the timers in the cancel
  * list. This will wake up processes waiting on these timers. The
@@ -151,12 +163,40 @@ static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 
 	if (isalarm(ctx))
 		remaining = alarm_expires_remaining(&ctx->t.alarm);
-	else
+	else if (isdeferrable(ctx)) {
+		ktime_t expires;
+		jiffies_to_ktime(ctx->dtmr.expires, &expires);
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
+static int timerfd_setup_deferrable(struct timerfd_ctx *ctx)
+{
+	ktime_t rem = timerfd_get_remaining(ctx);
+
+	if (ctx->clockid != CLOCK_MONOTONIC)
+		return -EINVAL;
+	if (!timerfd_deferrable_valid(ctx->tintv) ||
+			!timerfd_deferrable_valid(rem))
+		return -E2BIG;
+
+	mod_timer(&ctx->dtmr, jiffies + ktime_to_jiffies(&rem) + 1);
+	return 0;
+}
+
 static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			 const struct itimerspec *ktmr)
 {
@@ -177,6 +217,9 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			   ctx->clockid == CLOCK_REALTIME_ALARM ?
 			   ALARM_REALTIME : ALARM_BOOTTIME,
 			   timerfd_alarmproc);
+	} else if (isdeferrable(ctx)) {
+		ctx->dtmr.function = timerfd_dtmrproc;
+		ctx->dtmr.data = (unsigned long)ctx;
 	} else {
 		hrtimer_init(&ctx->t.tmr, clockid, htmode);
 		hrtimer_set_expires(&ctx->t.tmr, texp);
@@ -189,6 +232,13 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 				alarm_start(&ctx->t.alarm, texp);
 			else
 				alarm_start_relative(&ctx->t.alarm, texp);
+
+		} else if (isdeferrable(ctx)) {
+			int ret;
+
+			ret = timerfd_setup_deferrable(ctx);
+			if (ret)
+				return ret;
 		} else {
 			hrtimer_start(&ctx->t.tmr, texp, htmode);
 		}
@@ -207,8 +257,11 @@ static int timerfd_release(struct inode *inode, struct file *file)
 
 	if (isalarm(ctx))
 		alarm_cancel(&ctx->t.alarm);
-	else
+	else {
+		del_timer_sync(&ctx->dtmr);
 		hrtimer_cancel(&ctx->t.tmr);
+	}
+
 	kfree_rcu(ctx, rcu);
 	return 0;
 }
@@ -231,12 +284,15 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 
 static u64 timerfd_rearm(struct timerfd_ctx *ctx)
 {
-	u64 orun;
+	u64 orun = 0;
 
 	if (isalarm(ctx)) {
 		orun += alarm_forward_now(
 			&ctx->t.alarm, ctx->tintv) - 1;
 		alarm_restart(&ctx->t.alarm);
+	} else if (isdeferrable(ctx)) {
+		mod_timer(&ctx->dtmr, jiffies +
+			  ktime_to_jiffies(&ctx->tintv) + 1);
 	} else {
 		orun += hrtimer_forward_now(&ctx->t.tmr,
 		     ctx->tintv) - 1;
@@ -341,8 +397,11 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 			   ctx->clockid == CLOCK_REALTIME_ALARM ?
 			   ALARM_REALTIME : ALARM_BOOTTIME,
 			   timerfd_alarmproc);
-	else
+	else {
 		hrtimer_init(&ctx->t.tmr, clockid, HRTIMER_MODE_ABS);
+		/* Create deferrable timer in any none alarm case */
+		init_timer_deferrable(&ctx->dtmr);
+	}
 
 	ctx->moffs = ktime_get_monotonic_offset();
 
@@ -354,7 +413,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	return ufd;
 }
 
-static int do_timerfd_settime(int ufd, int flags, 
+static int do_timerfd_settime(int ufd, int flags,
 		const struct itimerspec *new,
 		struct itimerspec *old)
 {
@@ -379,19 +438,25 @@ static int do_timerfd_settime(int ufd, int flags,
 	 * it to the new values.
 	 */
 	for (;;) {
+		int canceled;
 		spin_lock_irq(&ctx->wqh.lock);
 
-		if (isalarm(ctx)) {
-			if (alarm_try_to_cancel(&ctx->t.alarm) >= 0)
-				break;
-		} else {
-			if (hrtimer_try_to_cancel(&ctx->t.tmr) >= 0)
-				break;
-		}
+		if (isalarm(ctx))
+			canceled = alarm_try_to_cancel(&ctx->t.alarm);
+		else if (isdeferrable(ctx))
+			canceled = try_to_del_timer_sync(&ctx->dtmr);
+		else
+			canceled = hrtimer_try_to_cancel(&ctx->t.tmr);
+
+		if (canceled >= 0)
+			break;
 		spin_unlock_irq(&ctx->wqh.lock);
 		cpu_relax();
 	}
 
+	/* Must set a new value after we cancel the previous timer. */
+	ctx->deferrable = flags & TFD_TIMER_DEFERRABLE;
+
 	/*
 	 * If the timer is expired and it's periodic, we need to advance it
 	 * because the caller may want to know the previous expiration time.
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index d3b57fa..e053105 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -20,6 +20,7 @@
  */
 #define TFD_TIMER_ABSTIME (1 << 0)
 #define TFD_TIMER_CANCEL_ON_SET (1 << 1)
+#define TFD_TIMER_DEFERRABLE (1 << 2)
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
@@ -27,6 +28,7 @@
 /* Flags for timerfd_create.  */
 #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
 /* Flags for timerfd_settime.  */
-#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
+#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET | \
+		TFD_TIMER_DEFERRABLE)
 
 #endif /* _LINUX_TIMERFD_H */
-- 
1.7.9.5

