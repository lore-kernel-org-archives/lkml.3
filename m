Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaIDQbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:31:40 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35898 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572AbaIDQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:22 -0400
X-Yandex-Uniq: 73697f5b-8ceb-4ead-b146-68abc3f5e261
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru
Subject: [PATCH 18/19] hrtimers: calculate expires_next after all timers are executed
Date: Thu,  4 Sep 2014 20:31:04 +0400
Message-Id: <1409848265-17150-18-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

I think I'm hitting particularly subtle issue with NOHZ_IDLE kernel.

The sequence is as follows:
- CPU enters idle, we disable tick
- hrtimer interrupt fires (for hrtimer_wakeup)
- for clock base #1 (REALTIME) we wake up SCHED_RT thread and
  start RT period timer (from start_rt_bandwidth) for clock base #0 (MONOTONIC)
- because we already checked expiry time for clock base #0
  we end up programming wrong wake up time (minutes, from tick_sched_timer)
- then, we exit idle loop and restart tick;
  but because tick_sched_timer is not leftmost (the leftmost one
  is RT period timer) we don't program it

So in the end, I see working CPU without tick interrupt.
This eventually leads to RCU stall on that CPU: rcu_gp_kthread
is not woken up because there is no tick (this is the reason
I started digging this up).

The proposed fix runs expired timers first and only then tries to find
next expiry time for all clocks.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 include/linux/hrtimer.h |  2 ++
 kernel/hrtimer.c        | 41 +++++++++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..520a671 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -141,6 +141,7 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
+ * @next:		time of the next event on this clock base
  */
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
@@ -151,6 +152,7 @@ struct hrtimer_clock_base {
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
 	ktime_t			offset;
+	ktime_t			next;
 };
 
 enum  hrtimer_base_type {
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index aadf4b7..f4c028d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -900,6 +900,8 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
 static int enqueue_hrtimer(struct hrtimer *timer,
 			   struct hrtimer_clock_base *base)
 {
+	ktime_t expires;
+
 	debug_activate(timer);
 
 	timerqueue_add(&base->active, &timer->node);
@@ -911,6 +913,10 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
 
+	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+	if (ktime_compare(base->next, expires) > 0)
+		base->next = expires;
+
 	return (&timer->node == base->active.next);
 }
 
@@ -947,8 +953,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	if (!timerqueue_getnext(&base->active))
+	if (!timerqueue_getnext(&base->active)) {
 		base->cpu_base->active_bases &= ~(1 << base->index);
+		base->next = ktime_set(KTIME_SEC_MAX, 0);
+	}
 out:
 	timer->state = newstate;
 }
@@ -1300,6 +1308,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
  */
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
+	struct hrtimer_clock_base *base;
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
@@ -1322,7 +1331,6 @@ retry:
 	cpu_base->expires_next.tv64 = KTIME_MAX;
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		struct hrtimer_clock_base *base;
 		struct timerqueue_node *node;
 		ktime_t basenow;
 
@@ -1351,14 +1359,8 @@ retry:
 			 */
 
 			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
-				ktime_t expires;
-
-				expires = ktime_sub(hrtimer_get_expires(timer),
-						    base->offset);
-				if (expires.tv64 < 0)
-					expires.tv64 = KTIME_MAX;
-				if (expires.tv64 < expires_next.tv64)
-					expires_next = expires;
+				base->next = ktime_sub(hrtimer_get_expires(timer),
+						       base->offset);
 				break;
 			}
 
@@ -1367,6 +1369,25 @@ retry:
 	}
 
 	/*
+	 * Because timer handler may add new timer on a different clock base,
+	 * we need to find next expiry only after we execute all timers.
+	 */
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+		ktime_t expires;
+
+		if (!(cpu_base->active_bases & (1 << i)))
+			continue;
+
+		base = cpu_base->clock_base + i;
+		expires = base->next;
+
+		if (expires.tv64 < 0)
+			expires.tv64 = KTIME_MAX;
+		if (expires.tv64 < expires_next.tv64)
+			expires_next = expires;
+	}
+
+	/*
 	 * Store the new expiry value so the migration code can verify
 	 * against it.
 	 */
-- 
1.9.3

