Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaABWZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:25:44 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44897 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaABWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:23:37 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4/9] tick/timekeeping: Call update_wall_time outside the jiffies lock
Date: Thu,  2 Jan 2014 14:23:22 -0800
Message-Id: <1388701407-5029-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
References: <52C5E6A0.7010507@linaro.org>
 <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the xtime lock was split into the timekeeping lock and
the jiffies lock, we no longer need to call update_wall_time()
while holding the jiffies lock.

Thus, this patch splits update_wall_time() out from do_timer().

This allows us to get away from calling clock_was_set_delayed()
in update_wall_time() and instead use the standard clock_was_set()
call that previously would deadlock, as it causes the jiffies lock
to be acquired.

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/tick-common.c   |  1 +
 kernel/time/tick-internal.h |  1 +
 kernel/time/tick-sched.c    |  1 +
 kernel/time/timekeeping.c   | 19 ++++---------------
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64522ec..91c5f27 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -70,6 +70,7 @@ static void tick_periodic(int cpu)
 
 		do_timer(1);
 		write_sequnlock(&jiffies_lock);
+		update_wall_time();
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index e2bced5..8329669 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -155,3 +155,4 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 #endif
 
 extern void do_timer(unsigned long ticks);
+extern void update_wall_time(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2afd43f..c58b03d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -86,6 +86,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&jiffies_lock);
+	update_wall_time();
 }
 
 /*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d62682b..44b7e6b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1360,7 +1360,7 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
  */
-static void update_wall_time(void)
+void update_wall_time(void)
 {
 	struct clocksource *clock;
 	struct timekeeper *real_tk = &timekeeper;
@@ -1441,19 +1441,8 @@ static void update_wall_time(void)
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-	if (clock_was_set) {
-		/*
-		 * XXX -  I'd rather we just call clock_was_set(), but
-		 * since we're currently holding the jiffies lock, calling
-		 * clock_was_set would trigger an ipi which would then grab
-		 * the jiffies lock and we'd deadlock. :(
-		 * The right solution should probably be droping
-		 * the jiffies lock before calling update_wall_time
-		 * but that requires some rework of the tick sched
-		 * code.
-		 */
-		clock_was_set_delayed();
-	}
+	if (clock_set)
+		clock_was_set();
 }
 
 /**
@@ -1598,7 +1587,6 @@ struct timespec get_monotonic_coarse(void)
 void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
-	update_wall_time();
 	calc_global_load(ticks);
 }
 
@@ -1756,4 +1744,5 @@ void xtime_update(unsigned long ticks)
 	write_seqlock(&jiffies_lock);
 	do_timer(ticks);
 	write_sequnlock(&jiffies_lock);
+	update_wall_time();
 }
-- 
1.8.3.2

