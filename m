Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaBTImj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:42:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58792 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaBTImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:42:36 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-d0-5305bffa1f85
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v3 4/6] timerfd: Factor out timer-type unspecific
 timerfd_expire()
Date: Thu, 20 Feb 2014 12:40:31 +0400
Message-id: <1392885633-7787-5-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Nd1f+1mDDY5dNbSYe/c8i8Wc9WvY
	LC623maxOLhV06L/VyerxfUvz1ktzvzWtTjb9Ibd4vKuOWwWmzdNZXbg8pjQ/4nR4861PWwe
	786dY/c4MeM3i8eXPXuZPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvjw85e5oJtQhV3d51i
	bmC8wNfFyMkhIWAicW7zRSYIW0ziwr31bF2MXBxCAksZJe70PGeFcHqYJGb/+8bcxcjBwSZg
	ILHvni1Ig4iAj8SuiR+ZQGqYBZ4wSqw+eAdskrBAiMSGV3vB6lkEVCWmvg4BCfMKuEn8+b8V
	LCwhoCAxZ5INiMkp4C7R8MQGpEIIqOLBlj8sExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvX
	S87P3cQICb8vOxgXH7M6xCjAwajEwxtxnSVYiDWxrLgy9xCjBAezkggvTyZrsBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbGaX9OfnMM2mNhxf3jS8nC70e/mglus377xDS5+ve6JXJzdA5WzHr6
	J0/mpNbdSL9GqflRpof5bwZdefl70jEJl10LZ3M6qctVFpxf4J6koCapHMuRwqVY7MHKr/ph
	tpp8z6P7QgGqodvKHubO/PZPbOKPiUpHFRLOnvH5opk07XfPSdtpBUJqSizFGYmGWsxFxYkA
	da02AR0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton@enomsg.org>

There is nothing hrtimer-specific inside the timerfd_tmrproc(), except
the function prototype. We're about to add other timer types, so factor
out generic timerfd_expire() helper from timerfd_tmrproc().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 fs/timerfd.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..3561ce7 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -229,6 +229,23 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
+static u64 timerfd_rearm(struct timerfd_ctx *ctx)
+{
+	u64 orun;
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

