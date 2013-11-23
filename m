Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3KWPhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:37:36 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41759 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3KWPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:28 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 03/10] posix-timers: Cleanup reaped target handling
Date: Sat, 23 Nov 2013 16:37:13 +0100
Message-Id: <1385221040-24731-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a timer's target is seen to be buried, for example on calls
to timer_gettime(), the posix cpu timers code behaves a bit
like a garbage collector and releases early the reference to the
task.

Then again, this optimization complicates the code for no much
value: it's up to the user to release the timer and its associated
ressources by calling timer_delete() after it buries the target
tasks.

Remove this to simplify the code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index dd75dc4..f509f53 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -638,8 +638,6 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 */
 	if (unlikely(p->sighand == NULL)) {
 		read_unlock(&tasklist_lock);
-		put_task_struct(p);
-		timer->it.cpu.task = NULL;
 		return -ESRCH;
 	}
 
@@ -807,8 +805,6 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			 * We can't even collect a sample any more.
 			 * Call the timer disarmed, nothing else to do.
 			 */
-			put_task_struct(p);
-			timer->it.cpu.task = NULL;
 			timer->it.cpu.expires = 0;
 			read_unlock(&tasklist_lock);
 			goto dead;
@@ -1058,8 +1054,6 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			 * The process has been reaped.
 			 * We can't even collect a sample any more.
 			 */
-			put_task_struct(p);
-			timer->it.cpu.task = p = NULL;
 			timer->it.cpu.expires = 0;
 			goto out_unlock;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
-- 
1.8.3.1

