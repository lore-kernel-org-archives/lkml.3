Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3BZX5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870Ab3BZX5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 009/150] hrtimer: Prevent hrtimer_enqueue_reprogram race
Date: Tue, 26 Feb 2013 15:54:26 -0800
Message-Id: <20130226235525.045799638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


