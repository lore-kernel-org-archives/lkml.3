Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab3CDDqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:46:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33195 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454Ab3CDDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:56 -0500
Message-Id: <20130304033710.212668386@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 027/153] hrtimer: Prevent hrtimer_enqueue_reprogram race
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/hrtimer.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -640,21 +640,9 @@ static inline void hrtimer_init_hres(str
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
@@ -735,8 +723,7 @@ static inline int hrtimer_switch_to_hres
 static inline void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base,
-					    int wakeup)
+					    struct hrtimer_clock_base *base)
 {
 	return 0;
 }
@@ -995,8 +982,21 @@ int __hrtimer_start_range_ns(struct hrti
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
 


