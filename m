Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaGIG4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:56:22 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36212 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaGIG4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:56:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 4/7] sched: don't check for active hrtimer after adding it
Date: Wed,  9 Jul 2014 12:25:36 +0530
Message-Id: <9c72a8d137cfca4e67848a7bf9dc9942eea7452b.1404888801.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
only special case is when the hrtimer was in past. If it is getting enqueued to
local CPUs's clock-base, we raise a softirq and exit, else we handle that on
next interrupt on remote CPU.

At several places in the kernel, we try to make sure if hrtimer was added
properly or not by calling hrtimer_active(), like:

	hrtimer_start(timer, expires, mode);
	if (hrtimer_active(timer)) {
		/* Added successfully */
	} else {
		/* Was added in the past */
	}

As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
So, there is no point calling hrtimer_active().

Also this is done in while loop at several places, which isn't required anymore.

This patch updates sched core to get this fixed.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c     | 20 +++++++++-----------
 kernel/sched/deadline.c |  2 +-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..4a6ef8d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -111,19 +111,17 @@ void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 	unsigned long delta;
 	ktime_t soft, hard, now;
 
-	for (;;) {
-		if (hrtimer_active(period_timer))
-			break;
+	if (hrtimer_active(period_timer))
+		return;
 
-		now = hrtimer_cb_get_time(period_timer);
-		hrtimer_forward(period_timer, now, period);
+	now = hrtimer_cb_get_time(period_timer);
+	hrtimer_forward(period_timer, now, period);
 
-		soft = hrtimer_get_softexpires(period_timer);
-		hard = hrtimer_get_expires(period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(period_timer, soft, delta,
-					 HRTIMER_MODE_ABS_PINNED, 0);
-	}
+	soft = hrtimer_get_softexpires(period_timer);
+	hard = hrtimer_get_expires(period_timer);
+	delta = ktime_to_ns(ktime_sub(hard, soft));
+	__hrtimer_start_range_ns(period_timer, soft, delta,
+				 HRTIMER_MODE_ABS_PINNED, 0);
 }
 
 DEFINE_MUTEX(sched_domains_mutex);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..eeb6786 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -484,7 +484,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
 	__hrtimer_start_range_ns(&dl_se->dl_timer, soft,
 				 range, HRTIMER_MODE_ABS, 0);
 
-	return hrtimer_active(&dl_se->dl_timer);
+	return 1;
 }
 
 /*
-- 
2.0.0.rc2

