Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3KWPhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:37:32 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52226 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab3KWPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:28 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/10] posix-timers: Remove dead process posix cpu timers caching
Date: Sat, 23 Nov 2013 16:37:12 +0100
Message-Id: <1385221040-24731-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we removed dead thread posix cpu timers caching,
lets remove the dead process wide version. This caching
is similar to the per thread version but it should be even
more rare:

* If the process id dead, we are not reading its timers
status from a thread belonging to its group since they
are all dead. So this caching only concern remote process
timers reads. Now posix cpu timers using itimers or timer_settime()
can't do remote process timers anyway so it's not even clear if there
is actually a user for this caching.

* Unlike per thread timers caching, this only applies to
zombies targets. Buried targets' process wide timers return
0 values. But then again, timer_gettime() can't read remote
process timers, so if the process is dead, there can't be
any reader left anyway.

Then again this caching seem to complicate the code for
corner cases that are probably not worth it. So lets get
rid of it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 34 +---------------------------------
 1 file changed, 1 insertion(+), 33 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index b803265..dd75dc4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -453,23 +453,6 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
-{
-	struct cpu_timer_list *timer = &itimer->it.cpu;
-
-	/*
-	 * That's all for this thread or process.
-	 * We leave our residual in expires to be reported.
-	 */
-	put_task_struct(timer->task);
-	timer->task = NULL;
-	if (timer->expires < now) {
-		timer->expires = 0;
-	} else {
-		timer->expires -= now;
-	}
-}
-
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 {
 	return expires == 0 || expires > new_exp;
@@ -831,16 +814,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			goto dead;
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			if (unlikely(p->exit_state) && thread_group_empty(p)) {
-				read_unlock(&tasklist_lock);
-				/*
-				 * We've noticed that the thread is dead, but
-				 * not yet reaped.  Take this opportunity to
-				 * drop our task ref.
-				 */
-				clear_dead_task(timer, now);
-				goto dead;
-			}
 		}
 		read_unlock(&tasklist_lock);
 	}
@@ -1090,13 +1063,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			timer->it.cpu.expires = 0;
 			goto out_unlock;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
-			/*
-			 * We've noticed that the thread is dead, but
-			 * not yet reaped.  Take this opportunity to
-			 * drop our task ref.
-			 */
+			/* Optimizations: if the process is dying, no need to rearm */
 			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
 		spin_lock(&p->sighand->siglock);
-- 
1.8.3.1

