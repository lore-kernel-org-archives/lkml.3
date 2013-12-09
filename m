Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942Ab3LIR7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:59:03 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39155 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3LIR66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:58:58 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/10 v2] posix-timers: Remove dead process posix cpu timers caching
Date: Mon,  9 Dec 2013 18:58:51 +0100
Message-Id: <1386611931-4658-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
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

Also remove the sample snapshot on dying process timer
that is now useless, as suggested by Kosaki.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 3b7df86..c5d1ef5 100644
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
@@ -832,16 +815,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
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
@@ -1092,14 +1065,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			read_unlock(&tasklist_lock);
 			goto out;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
-			/*
-			 * We've noticed that the thread is dead, but
-			 * not yet reaped.  Take this opportunity to
-			 * drop our task ref.
-			 */
-			cpu_timer_sample_group(timer->it_clock, p, &now);
-			clear_dead_task(timer, now);
 			read_unlock(&tasklist_lock);
+			/* Optimizations: if the process is dying, no need to rearm */
 			goto out;
 		}
 		spin_lock(&p->sighand->siglock);
-- 
1.8.3.1

