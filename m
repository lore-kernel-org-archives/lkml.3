Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaBTQZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:25:42 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23675 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaBTQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:44 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-7a-53062c499e0d
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v4 4/6] timerfd: Move repeated logic into timerfd_rearm()
Date: Thu, 20 Feb 2014 20:23:43 +0400
Message-id: <1392913425-29369-5-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e/4NV1PHbZgg48fzS3m3j3PYjFn/Ro2
	i4utt1ksDm7VtLj+5TmrxZnfuhZnm96wW1zeNYfNYvOmqcwOnB4T+j8xety5tofN4925c+we
	J2b8ZvHo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujL6vR1gLLgtWdPyvb2D8ztvFyMkhIWAi
	0fp9KhuELSZx4d56IJuLQ0hgKaPEr5M97BBOD5PEg/WzGbsYOTjYBAwk9t2zBWkQEfCR2DXx
	IxNIDbPAZUaJc71PmEASwgKeElt+rwWzWQRUJd53vWMBsXkF3CUe7z/EDjJHQkBBYs4kGxCT
	U8BDomudDEiFEFDFkYXn2CYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJqX3cw
	Lj1mdYhRgINRiYf3pBRbsBBrYllxZe4hRgkOZiURXncVoBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQbGqwtYT3xYfyf4JNepwry5Nx+cbtiox1P5oW8tg9+0GZb7kmdbH3bv8Xr25L/i9TlegnJ1
	Dg3c/888XL1JtUgszaM1vz4ko1TK8XRyw/8LhmfPBnPXFAfbqby8M/dW+tPGGnYDpa5JLDs3
	Okfs3sNjF1nzquzevwVc89dV6FjlzktfGBXdybtbiaU4I9FQi7moOBEAmqWsxRMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton@enomsg.org>

This patch introduces timerfd_rearm(), this small helper is used to
forward and restart the hrtimer.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 fs/timerfd.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..4a349cb 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -229,6 +229,23 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
+static u64 timerfd_rearm(struct timerfd_ctx *ctx)
+{
+	u64 orun = 0;
+
+	if (isalarm(ctx)) {
+		orun += alarm_forward_now(
+			&ctx->t.alarm, ctx->tintv) - 1;
+		alarm_restart(&ctx->t.alarm);
+	} else {
+		orun += hrtimer_forward_now(&ctx->t.tmr,
+		     ctx->tintv) - 1;
+		hrtimer_restart(&ctx->t.tmr);
+	}
+
+	return orun;
+}
+
 static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
@@ -265,15 +282,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			if (isalarm(ctx)) {
-				ticks += alarm_forward_now(
-					&ctx->t.alarm, ctx->tintv) - 1;
-				alarm_restart(&ctx->t.alarm);
-			} else {
-				ticks += hrtimer_forward_now(&ctx->t.tmr,
-							     ctx->tintv) - 1;
-				hrtimer_restart(&ctx->t.tmr);
-			}
+			ticks += timerfd_rearm(ctx);
 		}
 		ctx->expired = 0;
 		ctx->ticks = 0;
@@ -421,18 +430,7 @@ static int do_timerfd_gettime(int ufd, struct itimerspec *t)
 	spin_lock_irq(&ctx->wqh.lock);
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
-
-		if (isalarm(ctx)) {
-			ctx->ticks +=
-				alarm_forward_now(
-					&ctx->t.alarm, ctx->tintv) - 1;
-			alarm_restart(&ctx->t.alarm);
-		} else {
-			ctx->ticks +=
-				hrtimer_forward_now(&ctx->t.tmr, ctx->tintv)
-				- 1;
-			hrtimer_restart(&ctx->t.tmr);
-		}
+		ctx->ticks += timerfd_rearm(ctx);
 	}
 	t->it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	t->it_interval = ktime_to_timespec(ctx->tintv);
-- 
1.7.9.5

