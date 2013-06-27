Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3F0Kgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:36:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13420 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab3F0Kf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:35:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,951,1363132800"; 
   d="scan'208";a="33766443"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] time: indicate that the clock was set in the pvclock gtod notifier chain
Date: Thu, 27 Jun 2013 11:35:46 +0100
Message-ID: <1372329348-20841-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

If the clock was set (stepped), set the action parameter to functions
in the pvclock gtod notifier chain to non-zero.  This allows the
callee to only do work if the clock was stepped.

This will be used on Xen as the synchronization of the Xen wallclock
to the control domain's (dom0) system time will be done with this
notifier and updating on every timer tick is unnecessary and too
expensive.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 include/linux/pvclock_gtod.h |    7 +++++++
 kernel/time/timekeeping.c    |   30 ++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/include/linux/pvclock_gtod.h b/include/linux/pvclock_gtod.h
index 0ca7582..a71d2db 100644
--- a/include/linux/pvclock_gtod.h
+++ b/include/linux/pvclock_gtod.h
@@ -3,6 +3,13 @@
 
 #include <linux/notifier.h>
 
+/*
+ * The pvclock gtod notifier is called when the system time is updated
+ * and is used to keep guest time synchronized with host time.
+ *
+ * The 'action' parameter in the notifier function is false (0), or
+ * true (non-zero) if system time was stepped.
+ */
 extern int pvclock_gtod_register_notifier(struct notifier_block *nb);
 extern int pvclock_gtod_unregister_notifier(struct notifier_block *nb);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7aed2b0..dd1b94d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -28,6 +28,7 @@
 
 #define TK_CLEAR_NTP (1 << 0)
 #define TK_MIRROR (1 << 1)
+#define TK_CLOCK_WAS_SET (1 << 2)
 
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
@@ -203,9 +204,9 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
-static void update_pvclock_gtod(struct timekeeper *tk)
+static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
 {
-	raw_notifier_call_chain(&pvclock_gtod_chain, 0, tk);
+	raw_notifier_call_chain(&pvclock_gtod_chain, was_set, tk);
 }
 
 /**
@@ -219,7 +220,7 @@ int pvclock_gtod_register_notifier(struct notifier_block *nb)
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, true);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
@@ -251,7 +252,7 @@ static void timekeeping_update(struct timekeeper *tk, unsigned action)
 		ntp_clear();
 	}
 	update_vsyscall(tk);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
@@ -511,7 +512,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -555,7 +556,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -636,7 +637,7 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -875,7 +876,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -957,7 +958,7 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, TK_MIRROR);
+	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1239,9 +1240,10 @@ out_adjust:
  * It also calls into the NTP code to handle leapsecond processing.
  *
  */
-static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
+static inline bool accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+	unsigned action = 0;
 
 	while (tk->xtime_nsec >= nsecps) {
 		int leap;
@@ -1264,8 +1266,10 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
 			clock_was_set_delayed();
+			action = TK_CLOCK_WAS_SET;
 		}
 	}
+	return action;
 }
 
 /**
@@ -1350,6 +1354,7 @@ static void update_wall_time(void)
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	unsigned action;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1402,7 +1407,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	accumulate_nsecs_to_secs(tk);
+	action = accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
@@ -1418,7 +1423,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, 0);
+	timekeeping_update(real_tk, action);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -1680,6 +1685,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
+		update_pvclock_gtod(tk, true);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
-- 
1.7.2.5

