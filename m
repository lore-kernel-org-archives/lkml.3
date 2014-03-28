Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaC1LnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:43:06 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:40629 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaC1LnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:43:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/16] hrtimer: make enqueue_hrtimer() return void
Date: Fri, 28 Mar 2014 17:11:29 +0530
Message-Id: <74a3a18c379fa500d122649daff7568b56827af6.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enqueue_hrtimer() routine is called from three places and only one of them
effectively uses its return value. Also, by its name enqueue_hrtimer() isn't
supposed to return "if the queued timer is the leftmost". So it makes more sense
to separate this routine into two parts, first one enqueues a timer and the
other one tells if the timer is leftmost or not.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h |  5 +++++
 kernel/hrtimer.c        | 11 +++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 377023b..7ca9fd0 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -263,6 +263,11 @@ static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
 	return ktime_sub(timer->node.expires, timer->base->get_time());
 }
 
+static inline int hrtimer_is_leftmost(struct hrtimer *timer)
+{
+	return &timer->node == timer->base->active.next;
+}
+
 #ifdef CONFIG_HIGH_RES_TIMERS
 struct clock_event_device;
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 7d85b8f..2702185 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -844,7 +844,7 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
  *
  * Returns 1 when the new timer is the leftmost timer in the tree.
  */
-static int enqueue_hrtimer(struct hrtimer *timer)
+static void enqueue_hrtimer(struct hrtimer *timer)
 {
 	struct hrtimer_clock_base *base = timer->base;
 
@@ -858,8 +858,6 @@ static int enqueue_hrtimer(struct hrtimer *timer)
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
-
-	return (&timer->node == base->active.next);
 }
 
 /*
@@ -936,7 +934,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret, leftmost;
+	int ret;
 
 	lock_hrtimer_base(timer, &flags);
 	base = timer->base;
@@ -966,7 +964,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	timer_stats_hrtimer_set_start_info(timer);
 
-	leftmost = enqueue_hrtimer(timer);
+	enqueue_hrtimer(timer);
 
 	/*
 	 * Only allow reprogramming if the new base is on this CPU.
@@ -974,7 +972,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+	if (hrtimer_is_leftmost(timer) &&
+	    new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
 		&& hrtimer_enqueue_reprogram(timer)) {
 		if (wakeup) {
 			/*
-- 
1.7.12.rc2.18.g61b472e

