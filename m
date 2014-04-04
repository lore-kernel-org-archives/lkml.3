Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaDDGoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:44:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35795 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDDGnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:43:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 34/36] hrtimer: make enqueue_hrtimer() return void
Date: Fri,  4 Apr 2014 12:06:17 +0530
Message-Id: <2ea42c62aa005f9d3aa593e10ff8bd51dafbe989.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
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
 kernel/hrtimer.c        | 10 ++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d1836cb..435ac4c 100644
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
index ea620e5..d62fe32 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -856,7 +856,7 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
  *
  * Returns 1 when the new timer is the leftmost timer in the tree.
  */
-static int enqueue_hrtimer(struct hrtimer *timer)
+static void enqueue_hrtimer(struct hrtimer *timer)
 {
 	struct hrtimer_clock_base *base = timer->base;
 
@@ -870,8 +870,6 @@ static int enqueue_hrtimer(struct hrtimer *timer)
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
-
-	return (&timer->node == base->active.next);
 }
 
 /*
@@ -943,7 +941,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 {
 	struct hrtimer_clock_base *base;
 	unsigned long flags;
-	int ret, leftmost;
+	int ret;
 
 	lock_hrtimer_base(timer, &flags);
 	base = timer->base;
@@ -972,7 +970,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	timer_stats_hrtimer_set_start_info(timer);
 
-	leftmost = enqueue_hrtimer(timer);
+	enqueue_hrtimer(timer);
 
 	/*
 	 * Only allow reprogramming if the new base is on this CPU.
@@ -980,7 +978,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && base_on_this_cpu(timer->base)
+	if (hrtimer_is_leftmost(timer) && base_on_this_cpu(timer->base)
 		&& hrtimer_enqueue_reprogram(timer)) {
 		if (wakeup) {
 			/*
-- 
1.7.12.rc2.18.g61b472e

