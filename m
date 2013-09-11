Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3IKXvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:51:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60157 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3IKXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:51:37 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] timekeeping: Fix HRTICK related deadlock from ntp lock changes
Date: Wed, 11 Sep 2013 16:50:56 -0700
Message-Id: <1378943457-27314-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was reported that when HRTICK is enabled, its possible to
trigger system deadlocks. These were hard to reproduce, as
HRTICK has been broken in the past, but seemed to be connected
to the timekeeping_seq lock.

Since seqlock/seqcount's aren't supported w/ lockdep, I added
some extra spinlock based locking and triggered the following
lockdep output:

[   15.849182] ntpd/4062 is trying to acquire lock:
[   15.849765]  (&(&pool->lock)->rlock){..-...}, at: [<ffffffff810aa9b5>] __queue_work+0x145/0x480
[   15.850051]
[   15.850051] but task is already holding lock:
[   15.850051]  (timekeeper_lock){-.-.-.}, at: [<ffffffff810df6df>] do_adjtimex+0x7f/0x100

<snip>

[   15.850051] Chain exists of:
  &(&pool->lock)->rlock --> &p->pi_lock --> timekeeper_lock
[   15.850051]  Possible unsafe locking scenario:
[   15.850051]
[   15.850051]        CPU0                    CPU1
[   15.850051]        ----                    ----
[   15.850051]   lock(timekeeper_lock);
[   15.850051]                                lock(&p->pi_lock);
[   15.850051]                                lock(timekeeper_lock);
[   15.850051]   lock(&(&pool->lock)->rlock);
[   15.850051]
[   15.850051]  *** DEADLOCK ***

The deadlock was introduced by 06c017fdd4dc48451a (timekeeping:
Hold timekeepering locks in do_adjtimex and hardpps) in 3.10

This patch avoids this deadlock, by moving the call to
schedule_delayed_work() outside of the timekeeper lock
critical section.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable <stable@vger.kernel.org> #3.11, 3.10
Reported-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Tested-by: Lin Ming <minggr@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
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
 
-- 
1.8.1.2

