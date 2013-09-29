Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3I2TlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:41:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3I2T3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        Lin Ming <minggr@gmail.com>, John Stultz <john.stultz@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 08/71] timekeeping: Fix HRTICK related deadlock from ntp lock changes
Date: Sun, 29 Sep 2013 12:27:20 -0700
Message-Id: <20130929192644.109252439@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 7bd36014460f793c19e7d6c94dab67b0afcfcb7f upstream.

Gerlando Falauto reported that when HRTICK is enabled, it is
possible to trigger system deadlocks. These were hard to
reproduce, as HRTICK has been broken in the past, but seemed
to be connected to the timekeeping_seq lock.

Since seqlock/seqcount's aren't supported w/ lockdep, I added
some extra spinlock based locking and triggered the following
lockdep output:

[   15.849182] ntpd/4062 is trying to acquire lock:
[   15.849765]  (&(&pool->lock)->rlock){..-...}, at: [<ffffffff810aa9b5>] __queue_work+0x145/0x480
[   15.850051]
[   15.850051] but task is already holding lock:
[   15.850051]  (timekeeper_lock){-.-.-.}, at: [<ffffffff810df6df>] do_adjtimex+0x7f/0x100

<snip>

[   15.850051] Chain exists of: &(&pool->lock)->rlock --> &p->pi_lock --> timekeeper_lock
[   15.850051]  Possible unsafe locking scenario:
[   15.850051]
[   15.850051]        CPU0                    CPU1
[   15.850051]        ----                    ----
[   15.850051]   lock(timekeeper_lock);
[   15.850051]                                lock(&p->pi_lock);
[   15.850051] lock(timekeeper_lock);
[   15.850051] lock(&(&pool->lock)->rlock);
[   15.850051]
[   15.850051]  *** DEADLOCK ***

The deadlock was introduced by 06c017fdd4dc48451a ("timekeeping:
Hold timekeepering locks in do_adjtimex and hardpps") in 3.10

This patch avoids this deadlock, by moving the call to
schedule_delayed_work() outside of the timekeeper lock
critical section.

Reported-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Tested-by: Lin Ming <minggr@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: http://lkml.kernel.org/r/1378943457-27314-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/timex.h     |    1 +
 kernel/time/ntp.c         |    6 ++----
 kernel/time/timekeeping.c |    2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -141,6 +141,7 @@ extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
 int read_current_timer(unsigned long *timer_val);
+void ntp_notify_cmos_timer(void);
 
 /* The clock frequency of the i8253/i8254 PIT */
 #define PIT_TICK_RATE 1193182ul
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -516,13 +516,13 @@ static void sync_cmos_clock(struct work_
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
 
 
@@ -687,8 +687,6 @@ int __do_adjtimex(struct timex *txc, str
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
-	notify_cmos_timer();
-
 	return result;
 }
 
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1703,6 +1703,8 @@ int do_adjtimex(struct timex *txc)
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
+	ntp_notify_cmos_timer();
+
 	return ret;
 }
 


