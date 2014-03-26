Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaCZLW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:56 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:47154 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:53 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/14] hrtimer: remove active_bases field from struct hrtimer_cpu_base
Date: Wed, 26 Mar 2014 16:51:17 +0530
Message-Id: <dc479af0df0a087f24719237e7af687caa71e0d1.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Active_bases field of struct hrtimer_cpu_base is used at only one place, i.e.
hrtimer_interrupt() and at that place too we can easily use timerqueue_getnext()
instead to achieve the same result. I don't think this will have any performance
degradation issues and so removing this field.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h | 2 --
 kernel/hrtimer.c        | 8 ++------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6f524db..cb6a315 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,7 +165,6 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
- * @active_bases:	Bitfield to mark bases with active timers
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
@@ -179,7 +178,6 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
-	unsigned int			active_bases;
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1e4eedb..f14d861 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -865,7 +865,6 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	debug_activate(timer);
 
 	timerqueue_add(&base->active, &timer->node);
-	base->cpu_base->active_bases |= 1 << base->index;
 
 	/*
 	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
@@ -909,8 +908,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	if (!timerqueue_getnext(&base->active))
-		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
 	timer->state = newstate;
 }
@@ -1284,14 +1281,13 @@ retry:
 	cpu_base->expires_next.tv64 = KTIME_MAX;
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		struct hrtimer_clock_base *base;
+		struct hrtimer_clock_base *base = cpu_base->clock_base + i;
 		struct timerqueue_node *node;
 		ktime_t basenow;
 
-		if (!(cpu_base->active_bases & (1 << i)))
+		if (!timerqueue_getnext(&base->active))
 			continue;
 
-		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = timerqueue_getnext(&base->active))) {
-- 
1.7.12.rc2.18.g61b472e

