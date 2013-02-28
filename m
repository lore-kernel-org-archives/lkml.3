Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3B1OrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41988 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3B1OrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 030/139] hrtimer: Prevent hrtimer_enqueue_reprogram race
Date: Thu, 28 Feb 2013 14:43:00 +0000
Message-Id: <1362062689-2567-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonid Shatz <leonid.shatz@ravellosystems.com>

commit b22affe0aef429d657bc6505aacb1c569340ddd2 upstream.

hrtimer_enqueue_reprogram contains a race which could result in
timer.base switch during unlock/lock sequence.

hrtimer_enqueue_reprogram is releasing the lock protecting the timer
base for calling raise_softirq_irqsoff() due to a lock ordering issue
versus rq->lock.

If during that time another CPU calls __hrtimer_start_range_ns() on
the same hrtimer, the timer base might switch, before the current CPU
can lock base->lock again and therefor the unlock_timer_base() call
will unlock the wrong lock.

[ tglx: Added comment and massaged changelog ]

Signed-off-by: Leonid Shatz <leonid.shatz@ravellosystems.com>
Signed-off-by: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Link: http://lkml.kernel.org/r/1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/hrtimer.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..cdd5607 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -640,21 +640,9 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
  * and expiry check is done in the hrtimer_interrupt or in the softirq.
  */
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base,
-					    int wakeup)
+					    struct hrtimer_clock_base *base)
 {
-	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-		if (wakeup) {
-			raw_spin_unlock(&base->cpu_base->lock);
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-			raw_spin_lock(&base->cpu_base->lock);
-		} else
-			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-
-		return 1;
-	}
-
-	return 0;
+	return base->cpu_base->hres_active && hrtimer_reprogram(timer, base);
 }
 
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
@@ -735,8 +723,7 @@ static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base,
-					    int wakeup)
+					    struct hrtimer_clock_base *base)
 {
 	return 0;
 }
@@ -995,8 +982,21 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases))
-		hrtimer_enqueue_reprogram(timer, new_base, wakeup);
+	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+		if (wakeup) {
+			/*
+			 * We need to drop cpu_base->lock to avoid a
+			 * lock ordering issue vs. rq->lock.
+			 */
+			raw_spin_unlock(&new_base->cpu_base->lock);
+			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+			local_irq_restore(flags);
+			return ret;
+		} else {
+			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+		}
+	}
 
 	unlock_hrtimer_base(timer, &flags);
 
-- 
1.8.1.2

