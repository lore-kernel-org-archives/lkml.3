Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3KTJti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:49:38 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35379 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3KTJte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:49:34 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, tj@kernel.org, mingo@redhat.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, john.stultz@linaro.org,
        paulmck@linux.vnet.ibm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC] Timer: Migrate running timers
Date: Wed, 20 Nov 2013 15:19:18 +0530
Message-Id: <3a0ef8e5a838fcf1a3cdaecc029cc97dea5edf65.1384940804.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

This was earlier discussed here (Well, Not much :)):
https://lkml.org/lkml/2012/11/6/160

I am floating the idea again to get more attention on this patch. This is just
an idea for now, haven't seen much testing..

Migration of timers from idle cores to non-idle ones for power saving is very
well working and really saves a lot of power for us. What's currently not
working is the migration of running timers Or timers which re-arms themselves.

There are complications with migrating timers which schedules themselves again
from their handler. del_timer_sync() can't detect that the timer's handler
yet has not finished.

__mod_timer migrates the timer with following code:
	...
	spin_lock(&old_base->lock);
	...
	timer_set_base(timer, NULL);
	spin_unlock(&old_base->lock);		->A

	spin_lock(&new_base->lock);		->B
	timer_set_base(timer, new_base);
	...

After the unlock at time A, old_base->running_timer may get updated to the next
timer in queue. After lock at time B, lock_timer_base() will return new_base
where another timer might be running timer at that point of time.

Whereas, del_timer_sync() depends on below code to check if a timer's handler is
currently running or not.

	if (base->running_timer != timer)

Because there is window where timer's handler would be running and at the same
time it wasn't marked as running timer for any of the bases (well, it matters
only for its current base, i.e. new_base). del_timer_sync() wouldn't know this
and will go on and delete the timer, whose handler is currently running.

The new approach tries to mark such timers with wait_for_migration_to_complete
flag (can be named better and some memory can be saved as PeterZ suggested),
which will be used in del_timer_sync() to see if the timer is currently
migrating and so isn't marked as running_timer of its base.

Benefits: Well, obviously saving power for a core which is being interrupted
again and again in its idle loop by this timer event. Which will also prevent
the core to go in deeper idle states if possible.

Please share your feedback on this approach.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/timer.h |  1 +
 kernel/timer.c        | 29 +++++++++++++----------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 8c5a197..ad00ebe 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -20,6 +20,7 @@ struct timer_list {
 
 	void (*function)(unsigned long);
 	unsigned long data;
+	int wait_for_migration_to_complete;
 
 	int slack;
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 6582b82..30a93e6 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -748,21 +748,15 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
-		/*
-		 * We are trying to schedule the timer on the local CPU.
-		 * However we can't change timer's base while it is running,
-		 * otherwise del_timer_sync() can't detect that the timer's
-		 * handler yet has not finished. This also guarantees that
-		 * the timer is serialized wrt itself.
-		 */
-		if (likely(base->running_timer != timer)) {
-			/* See the comment in lock_timer_base() */
-			timer_set_base(timer, NULL);
-			spin_unlock(&base->lock);
-			base = new_base;
-			spin_lock(&base->lock);
-			timer_set_base(timer, base);
-		}
+		if (base->running_timer == timer)
+			timer->wait_for_migration_to_complete = 1;
+
+		/* See the comment in lock_timer_base() */
+		timer_set_base(timer, NULL);
+		spin_unlock(&base->lock);
+		base = new_base;
+		spin_lock(&base->lock);
+		timer_set_base(timer, base);
 	}
 
 	timer->expires = expires;
@@ -992,7 +986,8 @@ int try_to_del_timer_sync(struct timer_list *timer)
 
 	base = lock_timer_base(timer, &flags);
 
-	if (base->running_timer != timer) {
+	if ((base->running_timer != timer) &&
+			!timer->wait_for_migration_to_complete) {
 		timer_stats_timer_clear_start_info(timer);
 		ret = detach_if_pending(timer, base, true);
 	}
@@ -1185,6 +1180,8 @@ static inline void __run_timers(struct tvec_base *base)
 				call_timer_fn(timer, fn, data);
 				spin_lock_irq(&base->lock);
 			}
+			if (timer->wait_for_migration_to_complete)
+				timer->wait_for_migration_to_complete = 0;
 		}
 	}
 	base->running_timer = NULL;
-- 
1.7.12.rc2.18.g61b472e

