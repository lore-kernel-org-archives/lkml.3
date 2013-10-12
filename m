Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JLTGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:06:40 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43434 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab3JLTGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:06:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 04/10] posix-timers: Remove dead task special case
Date: Sat, 12 Oct 2013 21:06:20 +0200
Message-Id: <1381604786-21293-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381604786-21293-1-git-send-email-fweisbec@gmail.com>
References: <1381604786-21293-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we've removed all the optimizations that could
result in NULL timer's targets, we can remove all the
associated special case handling.

Also add some warnings on NULL targets to spot any possible
leftover.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 70 +++++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 45 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index f509f53..a815ddb 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -374,27 +374,27 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	struct task_struct *p = timer->it.cpu.task;
 	int ret = 0;
 
-	if (likely(p != NULL)) {
-		read_lock(&tasklist_lock);
-		if (unlikely(p->sighand == NULL)) {
-			/*
-			 * We raced with the reaping of the task.
-			 * The deletion should have cleared us off the list.
-			 */
-			BUG_ON(!list_empty(&timer->it.cpu.entry));
-		} else {
-			spin_lock(&p->sighand->siglock);
-			if (timer->it.cpu.firing)
-				ret = TIMER_RETRY;
-			else
-				list_del(&timer->it.cpu.entry);
-			spin_unlock(&p->sighand->siglock);
-		}
-		read_unlock(&tasklist_lock);
+	WARN_ON_ONCE(p == NULL);
 
-		if (!ret)
-			put_task_struct(p);
+	read_lock(&tasklist_lock);
+	if (unlikely(p->sighand == NULL)) {
+		/*
+		 * We raced with the reaping of the task.
+		 * The deletion should have cleared us off the list.
+		 */
+		BUG_ON(!list_empty(&timer->it.cpu.entry));
+	} else {
+		spin_lock(&p->sighand->siglock);
+		if (timer->it.cpu.firing)
+			ret = TIMER_RETRY;
+		else
+			list_del(&timer->it.cpu.entry);
+		spin_unlock(&p->sighand->siglock);
 	}
+	read_unlock(&tasklist_lock);
+
+	if (!ret)
+		put_task_struct(p);
 
 	return ret;
 }
@@ -621,12 +621,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	unsigned long long old_expires, new_expires, old_incr, val;
 	int ret;
 
-	if (unlikely(p == NULL)) {
-		/*
-		 * Timer refers to a dead task's clock.
-		 */
-		return -ESRCH;
-	}
+	WARN_ON_ONCE(p == NULL);
 
 	new_expires = timespec_to_sample(timer->it_clock, &new->it_value);
 
@@ -769,6 +764,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
 
+	WARN_ON_ONCE(p == NULL);
+
 	/*
 	 * Easy part: convert the reload time.
 	 */
@@ -780,18 +777,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		return;
 	}
 
-	if (unlikely(p == NULL)) {
-		WARN_ON_ONCE(CPUCLOCK_PERTHREAD(timer->it_clock));
-		/*
-		 * This task already died and the timer will never fire.
-		 * In this case, expires is actually the dead value.
-		 */
-	dead:
-		sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
-				   &itp->it_value);
-		return;
-	}
-
 	/*
 	 * Sample the clock to take the difference with the expiry time.
 	 */
@@ -806,8 +791,9 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			 * Call the timer disarmed, nothing else to do.
 			 */
 			timer->it.cpu.expires = 0;
+			sample_to_timespec(timer->it_clock, timer->it.cpu.expires,
+					   &itp->it_value);
 			read_unlock(&tasklist_lock);
-			goto dead;
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
 		}
@@ -1028,13 +1014,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	struct task_struct *p = timer->it.cpu.task;
 	unsigned long long now;
 
-	if (unlikely(p == NULL)) {
-		WARN_ON_ONCE(CPUCLOCK_PERTHREAD(timer->it_clock));
-		/*
-		 * The task was cleaned up already, no future firings.
-		 */
-		goto out;
-	}
+	WARN_ON_ONCE(p == NULL);
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
-- 
1.8.3.1

