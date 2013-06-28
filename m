Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3F1VT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:19:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3F1VTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:19:21 -0400
Date: Fri, 28 Jun 2013 14:19:03 -0700
From: tip-bot for David Vrabel <tipbot@zytor.com>
Message-ID: <tip-780427f0e113b4c77dfff4d258c05a902cdb0eb9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1372329348-20841-4-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-4-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping:
  Indicate that clock was set in the pvclock gtod notifier
Git-Commit-ID: 780427f0e113b4c77dfff4d258c05a902cdb0eb9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 14:19:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  780427f0e113b4c77dfff4d258c05a902cdb0eb9
Gitweb:     http://git.kernel.org/tip/780427f0e113b4c77dfff4d258c05a902cdb0eb9
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Thu, 27 Jun 2013 11:35:46 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 23:15:06 +0200

timekeeping: Indicate that clock was set in the pvclock gtod notifier

If the clock was set (stepped), set the action parameter to functions
in the pvclock gtod notifier chain to non-zero.  This allows the
callee to only do work if the clock was stepped.

This will be used on Xen as the synchronization of the Xen wallclock
to the control domain's (dom0) system time will be done with this
notifier and updating on every timer tick is unnecessary and too
expensive.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>
Link: http://lkml.kernel.org/r/1372329348-20841-4-git-send-email-david.vrabel@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/pvclock_gtod.h |  7 +++++++
 kernel/time/timekeeping.c    | 30 ++++++++++++++++++------------
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
index d8b23a9..846d0a1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -29,6 +29,7 @@
 
 #define TK_CLEAR_NTP		(1 << 0)
 #define TK_MIRROR		(1 << 1)
+#define TK_CLOCK_WAS_SET	(1 << 2)
 
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
@@ -204,9 +205,9 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
-static void update_pvclock_gtod(struct timekeeper *tk)
+static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
 {
-	raw_notifier_call_chain(&pvclock_gtod_chain, 0, tk);
+	raw_notifier_call_chain(&pvclock_gtod_chain, was_set, tk);
 }
 
 /**
@@ -220,7 +221,7 @@ int pvclock_gtod_register_notifier(struct notifier_block *nb)
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, true);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
@@ -252,7 +253,7 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 		ntp_clear();
 	}
 	update_vsyscall(tk);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
@@ -512,7 +513,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -556,7 +557,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -646,7 +647,7 @@ static int change_clocksource(void *data)
 			module_put(new->owner);
 		}
 	}
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -887,7 +888,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -969,7 +970,7 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, TK_MIRROR);
+	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1243,9 +1244,10 @@ out_adjust:
  * It also calls into the NTP code to handle leapsecond processing.
  *
  */
-static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
+static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+	unsigned int action = 0;
 
 	while (tk->xtime_nsec >= nsecps) {
 		int leap;
@@ -1268,8 +1270,10 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
 			clock_was_set_delayed();
+			action = TK_CLOCK_WAS_SET;
 		}
 	}
+	return action;
 }
 
 /**
@@ -1354,6 +1358,7 @@ static void update_wall_time(void)
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	unsigned int action;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1406,7 +1411,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	accumulate_nsecs_to_secs(tk);
+	action = accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
@@ -1422,7 +1427,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, 0);
+	timekeeping_update(real_tk, action);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -1684,6 +1689,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
+		update_pvclock_gtod(tk, true);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
