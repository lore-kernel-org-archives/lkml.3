Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaAMKpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:45:30 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38042 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaAMKpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:45:25 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a4-52d3c3c39d66
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, cw00.choi@samsung.com,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v2 2/3] timerfd: Factor out timer-type unspecific
 timerfd_expire()
Date: Mon, 13 Jan 2014 14:43:54 +0400
Message-id: <1389609835-24377-3-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xa7qHD18OMtiyQdRi7t3zLBZz1q9h
	s7jYepvF4uBWTYvrX56zWpz5rWtxtukNu8XlXXPYHDg8JvR/YvS4c20Pm8eJGb9ZPPq2rGL0
	+LxJLoA1issmJTUnsyy1SN8ugSvjw85e5oJtQhV3d51ibmC8wNfFyMkhIWAisf/UXiYIW0zi
	wr31bF2MXBxCAksZJVYdusYK4cxgkrg25wuQw8HBJmAgse+eLUiDiICFxJ1X/8FqmAUuM0o0
	HjvHCpIQFgiR+Nu/jxHEZhFQlejZB2HzCrhLHFp6nRlkjoSAgsScSTYgYU4BD4njS7aClQgB
	lRyf/5VxAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghofV1B+PSY1aHGAU4GJV4
	eHcIXQ4SYk0sK67MPcQowcGsJMJbeAgoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgfHoK9fu16a5
	bRMmMj/s/rVOsIHnxmvTZQtYT/zRqg2d8XjJz6nTwzY+zz/19ZVUsoH59YcbW084zZ1vPu+t
	H5/Jg1tbEl7u+hHc9j0/KT6zbXqnj+ecrD6N8Oqm78pipzbW7Xhz9XDcMmajGXttpp1VYeA/
	b1tt9nqyFcN7HfuvG7JW233MYf6hxFKckWioxVxUnAgA+JCgigsCAAA=
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

