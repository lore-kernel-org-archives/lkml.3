Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbaDNQ1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:27:12 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51518 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaDNQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 26/38] tick-sched: don't call update_wall_time() when delta is lesser than tick_period
Date: Mon, 14 Apr 2014 21:53:48 +0530
Message-Id: <8cf944ba5c78a47f83db9391f423150202816e61.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tick_do_update_jiffies64() we are processing ticks only if delta is greater
than tick_period. This is what we are supposed to do here and it broke a bit
with this patch:

commit 47a1b796306356f358e515149d86baf0cc6bf007
Author: John Stultz <john.stultz@linaro.org>
Date:   Thu Dec 12 13:10:55 2013 -0800

    tick/timekeeping: Call update_wall_time outside the jiffies lock

With above patch, we might end up calling update_wall_time() even if delta is
found to be smaller that tick_period. Fix this by reversing the check and
returning early.

Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b7b09b9..bff7f97 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -65,26 +65,28 @@ static void tick_do_update_jiffies64(ktime_t now)
 	write_seqlock(&jiffies_lock);
 
 	delta = ktime_sub(now, last_jiffies_update);
-	if (delta.tv64 >= tick_period.tv64) {
-
-		delta = ktime_sub(delta, tick_period);
-		last_jiffies_update = ktime_add(last_jiffies_update,
-						tick_period);
+	if (delta.tv64 < tick_period.tv64) {
+		write_sequnlock(&jiffies_lock);
+		return;
+	}
 
-		/* Slow path for long timeouts */
-		if (unlikely(delta.tv64 >= tick_period.tv64)) {
-			s64 incr = ktime_to_ns(tick_period);
+	delta = ktime_sub(delta, tick_period);
+	last_jiffies_update = ktime_add(last_jiffies_update, tick_period);
 
-			ticks = ktime_divns(delta, incr);
+	/* Slow path for long timeouts */
+	if (unlikely(delta.tv64 >= tick_period.tv64)) {
+		s64 incr = ktime_to_ns(tick_period);
 
-			last_jiffies_update = ktime_add_ns(last_jiffies_update,
-							   incr * ticks);
-		}
-		do_timer(++ticks);
+		ticks = ktime_divns(delta, incr);
 
-		/* Keep the tick_next_period variable up to date */
-		tick_next_period = ktime_add(last_jiffies_update, tick_period);
+		last_jiffies_update = ktime_add_ns(last_jiffies_update,
+						   incr * ticks);
 	}
+	do_timer(++ticks);
+
+	/* Keep the tick_next_period variable up to date */
+	tick_next_period = ktime_add(last_jiffies_update, tick_period);
+
 	write_sequnlock(&jiffies_lock);
 	update_wall_time();
 }
-- 
1.7.12.rc2.18.g61b472e

