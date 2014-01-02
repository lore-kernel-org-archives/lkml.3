Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaABSbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:31:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37084 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaABSbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:31:33 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a4-52c5b0835f94
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 2/3] timerfd: Factor out timer-type unspecific timerfd_expire()
Date: Thu, 02 Jan 2014 22:30:47 +0400
Message-id: <1388687448-12987-3-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsVy+t/xq7rNG44GGew5LWwx9+55Fos569ew
	WVxsvc1icXCrpsWZ37oWZ5vesFtc3jWHzYHdY0L/J0aPO9f2sHmcmPGbxaNvyypGj8+b5AJY
	o7hsUlJzMstSi/TtErgyPuzsZS7YJlRxd9cp5gbGC3xdjJwcEgImEr1fn7JD2GISF+6tZ+ti
	5OIQEljKKLFjcyczhDODSeLa5htAGQ4ONgEDiX33bEEaRAQsJO68+s8KUsMssItR4uv/fYwg
	CWEBf4kVZ26zgdgsAqoSZ5/sYwfp5RVwl7jVkABiSggoSMyZZANSwSngIbH+yi1mEFsIqGL6
	+g7GCYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEhNPXHYxLj1kdYhTgYFTi4f1Q
	dzRIiDWxrLgy9xCjBAezkgiv/kygEG9KYmVValF+fFFpTmrxIUYmDk6pBsYJu+YWB324nX72
	xM5zO89KOBzTbvv5fB7XPTfW2NpgZecfKaKdqskXF/q2nbdQnst9veM/+9Wv3pK61+dM9p2x
	vfGlXmqFmsS5bPu+AI6CnQntoskuETObmrjnynvcOT9/qay1nZ3GrJN/g84eDF02V2Qr68vC
	kEh/rtbP/edbet5ur5Ja8VSJpTgj0VCLuag4EQAFUkXoBQIAAA==
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

