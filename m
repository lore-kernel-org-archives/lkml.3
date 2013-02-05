Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3BELCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:02:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3BELCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:02:48 -0500
Date: Tue, 5 Feb 2013 03:02:29 -0800
From: tip-bot for Leonid Shatz <leonid.shatz@ravellosystems.com>
Message-ID: <tip-b22affe0aef429d657bc6505aacb1c569340ddd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        izik.eidus@ravellosystems.com, aarcange@redhat.com,
        leonid.shatz@ravellosystems.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        izik.eidus@ravellosystems.com, leonid.shatz@ravellosystems.com,
        aarcange@redhat.com, tglx@linutronix.de
In-Reply-To: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com>
References: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer: Prevent hrtimer_enqueue_reprogram race
Git-Commit-ID: b22affe0aef429d657bc6505aacb1c569340ddd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 05 Feb 2013 03:02:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b22affe0aef429d657bc6505aacb1c569340ddd2
Gitweb:     http://git.kernel.org/tip/b22affe0aef429d657bc6505aacb1c569340ddd2
Author:     Leonid Shatz <leonid.shatz@ravellosystems.com>
AuthorDate: Mon, 4 Feb 2013 14:33:37 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Feb 2013 11:52:41 +0100

hrtimer: Prevent hrtimer_enqueue_reprogram race

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
