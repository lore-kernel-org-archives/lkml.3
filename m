Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbbAWLV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:21:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbAWLVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:21:55 -0500
Date: Fri, 23 Jan 2015 03:21:41 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-9bc7491906b4113b4c5ae442157c7dfc4e10cd14@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, stfomichev@yandex-team.ru,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Reply-To: stfomichev@yandex-team.ru, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org
In-Reply-To: <alpine.DEB.2.11.1501202049190.5526@nanos>
References: <alpine.DEB.2.11.1501202049190.5526@nanos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer:
  Prevent stale expiry time in hrtimer_interrupt()
Git-Commit-ID: 9bc7491906b4113b4c5ae442157c7dfc4e10cd14
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bc7491906b4113b4c5ae442157c7dfc4e10cd14
Gitweb:     http://git.kernel.org/tip/9bc7491906b4113b4c5ae442157c7dfc4e10cd14
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 20 Jan 2015 21:24:10 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 12:13:20 +0100

hrtimer: Prevent stale expiry time in hrtimer_interrupt()

hrtimer_interrupt() has the following subtle issue:

hrtimer_interrupt()
  lock(cpu_base);
  expires_next = KTIME_MAX;

  expire_timers(CLOCK_MONOTONIC);
  expires = get_next_timer(CLOCK_MONOTONIC);
  if (expires < expires_next)
    expires_next = expires;

  expire_timers(CLOCK_REALTIME);
    unlock(cpu_base);
    wakeup()
    hrtimer_start(CLOCK_MONOTONIC, newtimer);
    lock(cpu_base();  
  expires = get_next_timer(CLOCK_REALTIME);
  if (expires < expires_next)
    expires_next = expires;

So because we already evaluated the next expiring timer of
CLOCK_MONOTONIC we ignore that the expiry time of newtimer might be
earlier than the overall next expiry time in hrtimer_interrupt().

To solve this, remove the caching of the next expiry value from
hrtimer_interrupt() and reevaluate all active clock bases for the next
expiry value. To avoid another code duplication, create a shared
evaluation function and use it for hrtimer_get_next_event(),
hrtimer_force_reprogram() and hrtimer_interrupt().

There is another subtlety in this mechanism:

While hrtimer_interrupt() is running, we want to avoid to touch the
hardware device because we will reprogram it anyway at the end of
hrtimer_interrupt(). This works nicely for hrtimers which get rearmed
via the HRTIMER_RESTART mechanism, because we drop out when the
callback on that CPU is running. But that fails, if a new timer gets
enqueued like in the example above.

This has another implication: While hrtimer_interrupt() is running we
refuse remote enqueueing of timers - see hrtimer_interrupt() and
hrtimer_check_target().

hrtimer_interrupt() tries to prevent this by setting cpu_base->expires
to KTIME_MAX, but that fails if a new timer gets queued.

Prevent both the hardware access and the remote enqueue
explicitely. We can loosen the restriction on the remote enqueue now
due to reevaluation of the next expiry value, but that needs a
seperate patch.

Folded in a fix from Vignesh Radhakrishnan.

Reported-and-tested-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Based-on-patch-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: vigneshr@codeaurora.org
Cc: john.stultz@linaro.org
Cc: viresh.kumar@linaro.org
Cc: fweisbec@gmail.com
Cc: cl@linux.com
Cc: stuart.w.hayes@gmail.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1501202049190.5526@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |   2 +
 kernel/time/hrtimer.c   | 108 ++++++++++++++++++++++--------------------------
 2 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index a036d05..05f6df1 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -170,6 +170,7 @@ enum  hrtimer_base_type {
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
+ * @in_hrtirq:		hrtimer_interrupt() is currently executing
  * @hres_active:	State of high resolution mode
  * @hang_detected:	The last hrtimer interrupt detected a hang
  * @nr_events:		Total number of hrtimer interrupt events
@@ -185,6 +186,7 @@ struct hrtimer_cpu_base {
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
+	int				in_hrtirq;
 	int				hres_active;
 	int				hang_detected;
 	unsigned long			nr_events;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aa..b663653 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -440,6 +440,37 @@ static inline void debug_deactivate(struct hrtimer *timer)
 	trace_hrtimer_cancel(timer);
 }
 
+#if defined(CONFIG_NO_HZ_COMMON) || defined(CONFIG_HIGH_RES_TIMERS)
+ktime_t __hrtimer_get_next_event(struct hrtimer_cpu_base *cpu_base)
+{
+	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	ktime_t expires, expires_next = { .tv64 = KTIME_MAX };
+	int i;
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		struct timerqueue_node *next;
+		struct hrtimer *timer;
+
+		next = timerqueue_getnext(&base->active);
+		if (!next)
+			continue;
+
+		timer = container_of(next, struct hrtimer, node);
+		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		if (expires.tv64 < expires_next.tv64)
+			expires_next = expires;
+	}
+	/*
+	 * clock_was_set() might have changed base->offset of any of
+	 * the clock bases so the result might be negative. Fix it up
+	 * to prevent a false positive in clockevents_program_event().
+	 */
+	if (expires_next.tv64 < 0)
+		expires_next.tv64 = 0;
+	return expires_next;
+}
+#endif
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -488,32 +519,7 @@ static inline int hrtimer_hres_active(void)
 static void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
-	int i;
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t expires, expires_next;
-
-	expires_next.tv64 = KTIME_MAX;
-
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-		struct hrtimer *timer;
-		struct timerqueue_node *next;
-
-		next = timerqueue_getnext(&base->active);
-		if (!next)
-			continue;
-		timer = container_of(next, struct hrtimer, node);
-
-		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
-		/*
-		 * clock_was_set() has changed base->offset so the
-		 * result might be negative. Fix it up to prevent a
-		 * false positive in clockevents_program_event()
-		 */
-		if (expires.tv64 < 0)
-			expires.tv64 = 0;
-		if (expires.tv64 < expires_next.tv64)
-			expires_next = expires;
-	}
+	ktime_t expires_next = __hrtimer_get_next_event(cpu_base);
 
 	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
 		return;
@@ -587,6 +593,15 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 		return 0;
 
 	/*
+	 * When the target cpu of the timer is currently executing
+	 * hrtimer_interrupt(), then we do not touch the clock event
+	 * device. hrtimer_interrupt() will reevaluate all clock bases
+	 * before reprogramming the device.
+	 */
+	if (cpu_base->in_hrtirq)
+		return 0;
+
+	/*
 	 * If a hang was detected in the last timer interrupt then we
 	 * do not schedule a timer which is earlier than the expiry
 	 * which we enforced in the hang detection. We want the system
@@ -1104,29 +1119,14 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 ktime_t hrtimer_get_next_event(void)
 {
 	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
+	ktime_t mindelta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
-	int i;
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-			struct hrtimer *timer;
-			struct timerqueue_node *next;
-
-			next = timerqueue_getnext(&base->active);
-			if (!next)
-				continue;
-
-			timer = container_of(next, struct hrtimer, node);
-			delta.tv64 = hrtimer_get_expires_tv64(timer);
-			delta = ktime_sub(delta, base->get_time());
-			if (delta.tv64 < mindelta.tv64)
-				mindelta.tv64 = delta.tv64;
-		}
-	}
+	if (!hrtimer_hres_active())
+		mindelta = ktime_sub(__hrtimer_get_next_event(cpu_base),
+				     ktime_get());
 
 	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
 
@@ -1253,7 +1253,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	raw_spin_lock(&cpu_base->lock);
 	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
-	expires_next.tv64 = KTIME_MAX;
+	cpu_base->in_hrtirq = 1;
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1291,28 +1291,20 @@ retry:
 			 * are right-of a not yet expired timer, because that
 			 * timer will have to trigger a wakeup anyway.
 			 */
-
-			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
-				ktime_t expires;
-
-				expires = ktime_sub(hrtimer_get_expires(timer),
-						    base->offset);
-				if (expires.tv64 < 0)
-					expires.tv64 = KTIME_MAX;
-				if (expires.tv64 < expires_next.tv64)
-					expires_next = expires;
+			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer))
 				break;
-			}
 
 			__run_hrtimer(timer, &basenow);
 		}
 	}
-
+	/* Reevaluate the clock bases for the next expiry */
+	expires_next = __hrtimer_get_next_event(cpu_base);
 	/*
 	 * Store the new expiry value so the migration code can verify
 	 * against it.
 	 */
 	cpu_base->expires_next = expires_next;
+	cpu_base->in_hrtirq = 0;
 	raw_spin_unlock(&cpu_base->lock);
 
 	/* Reprogramming necessary ? */
