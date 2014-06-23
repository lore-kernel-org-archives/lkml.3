Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaFWJe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:34:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaFWJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:34:53 -0400
Date: Mon, 23 Jun 2014 02:34:41 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-9e1e01dd79ac4cf936623399abe57dfba4528ae6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <1403393357-2070-6-git-send-email-fweisbec@gmail.com>
References: <1403393357-2070-6-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer: Remove hrtimer_enqueue_reprogram()
Git-Commit-ID: 9e1e01dd79ac4cf936623399abe57dfba4528ae6
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

Commit-ID:  9e1e01dd79ac4cf936623399abe57dfba4528ae6
Gitweb:     http://git.kernel.org/tip/9e1e01dd79ac4cf936623399abe57dfba4528ae6
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Sun, 22 Jun 2014 01:29:17 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 23 Jun 2014 11:23:47 +0200

hrtimer: Remove hrtimer_enqueue_reprogram()

We call hrtimer_enqueue_reprogram() only when we are in high resolution
mode now so we don't need to check that again in hrtimer_enqueue_reprogram().

Once the check is removed, hrtimer_enqueue_reprogram() turns to be an
useless wrapper over hrtimer_reprogram() and can be dropped.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1403393357-2070-6-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/hrtimer.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index f900747..66a6dc1 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -602,6 +602,11 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
  * timers, we have to check, whether it expires earlier than the timer for
  * which the clock event device was armed.
  *
+ * Note, that in case the state has HRTIMER_STATE_CALLBACK set, no reprogramming
+ * and no expiry check happens. The timer gets enqueued into the rbtree. The
+ * reprogramming and expiry check is done in the hrtimer_interrupt or in the
+ * softirq.
+ *
  * Called with interrupts disabled and base->cpu_base.lock held
  */
 static int hrtimer_reprogram(struct hrtimer *timer,
@@ -662,18 +667,6 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 	base->hres_active = 0;
 }
 
-/*
- * When High resolution timers are active, try to reprogram. Note, that in case
- * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
- * check happens. The timer gets enqueued into the rbtree. The reprogramming
- * and expiry check is done in the hrtimer_interrupt or in the softirq.
- */
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
-{
-	return base->cpu_base->hres_active && hrtimer_reprogram(timer, base);
-}
-
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
 {
 	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
@@ -755,8 +748,8 @@ static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+static inline int hrtimer_reprogram(struct hrtimer *timer,
+				    struct hrtimer_clock_base *base)
 {
 	return 0;
 }
@@ -1025,7 +1018,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		 */
 		wake_up_nohz_cpu(new_base->cpu_base->cpu);
 	} else if (new_base->cpu_base == &__get_cpu_var(hrtimer_bases) &&
-			hrtimer_enqueue_reprogram(timer, new_base)) {
+			hrtimer_reprogram(timer, new_base)) {
 		/*
 		 * Only allow reprogramming if the new base is on this CPU.
 		 * (it might still be on another CPU if the timer was pending)
