Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3BDMcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:32:00 -0500
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:59919 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751571Ab3BDMb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:31:59 -0500
From: Izik Eidus <izik.eidus@ravellosystems.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        leonid Shatz <leonid.shatz@ravellosystems.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>
Subject: [PATCH] fix hrtimer_enqueue_reprogram race
Date: Mon,  4 Feb 2013 14:33:37 +0200
Message-Id: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: leonid Shatz <leonid.shatz@ravellosystems.com>

it seems like hrtimer_enqueue_reprogram contain a race which could result in
timer.base switch during unlock/lock sequence.

See the code at __hrtimer_start_range_ns where it calls
hrtimer_enqueue_reprogram. The later is releasing lock protecting the timer
base for a short time and timer base switch can occur from a different CPU
thread. Later when __hrtimer_start_range_ns calls unlock_hrtimer_base, a base
switch could have happened and this causes the bug

Try to start the same hrtimer from two different threads in kernel running
each one on a different CPU. Eventually one of the calls will cause timer base
switch while another thread is not expecting it.

This can happen in virtualized environment where one thread can be delayed by
lower hypervisor, and due to time delay a different CPU is taking care of
missed timer start and runs the timer start logic on its own.

Signed-off-by: Leonid Shatz <leonid.shatz@ravellosystems.com>
Signed-off-by: Izik Eidus <izik.eidus@ravellosystems.com>
---
 kernel/hrtimer.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..0c8c6cd 100644
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
@@ -995,8 +982,17 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases))
-		hrtimer_enqueue_reprogram(timer, new_base, wakeup);
+	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+		if (wakeup) {
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
1.7.10.4

