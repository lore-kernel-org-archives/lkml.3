Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3IRQWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:22:22 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62787 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab3IRQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:22:20 -0400
Date: Wed, 18 Sep 2013 18:22:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20130918162217.GA10905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: 7bd36014460f793c19e7d6c94dab67b0afcfcb7f timekeeping: Fix HRTICK related deadlock from ntp lock changes

An NTP related lockup fix.

 Thanks,

	Ingo

------------------>
John Stultz (1):
      timekeeping: Fix HRTICK related deadlock from ntp lock changes


 include/linux/timex.h     | 1 +
 kernel/time/ntp.c         | 6 ++----
 kernel/time/timekeeping.c | 2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index b3726e6..dd3edd7 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -141,6 +141,7 @@ extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
 int read_current_timer(unsigned long *timer_val);
+void ntp_notify_cmos_timer(void);
 
 /* The clock frequency of the i8253/i8254 PIT */
 #define PIT_TICK_RATE 1193182ul
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8f5b3b9..bb22151 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -516,13 +516,13 @@ static void sync_cmos_clock(struct work_struct *work)
 	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
-static void notify_cmos_timer(void)
+void ntp_notify_cmos_timer(void)
 {
 	schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else
-static inline void notify_cmos_timer(void) { }
+void ntp_notify_cmos_timer(void) { }
 #endif
 
 
@@ -687,8 +687,6 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
-	notify_cmos_timer();
-
 	return result;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 48b9fff..947ba25 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1703,6 +1703,8 @@ int do_adjtimex(struct timex *txc)
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
+	ntp_notify_cmos_timer();
+
 	return ret;
 }
 
