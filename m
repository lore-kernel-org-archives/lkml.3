Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3KWPiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:38:23 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49652 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab3KWPhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:36 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/10] posix-timers: Use sighand lock instead of tasklist_lock on timer deletion
Date: Sat, 23 Nov 2013 16:37:18 +0100
Message-Id: <1385221040-24731-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timer deletion doesn't need the tasklist lock.
We need to protect against:

* concurrent access to the lists p->cputime_expires and
  p->sighand->cputime_expires

* task reaping that may also delete the timer list entry

* timer firing

We already hold the timer lock which protects us against concurrent
timer firing.

The rest only need the targets sighand to be locked.
So hold it and drop the use of tasklist_lock there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index cd56e71..302e80e 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -377,27 +377,32 @@ static int posix_cpu_timer_create(struct k_itimer *new_timer)
  */
 static int posix_cpu_timer_del(struct k_itimer *timer)
 {
-	struct task_struct *p = timer->it.cpu.task;
 	int ret = 0;
+	unsigned long flags;
+	struct sighand_struct *sighand;
+	struct task_struct *p = timer->it.cpu.task;
 
 	WARN_ON_ONCE(p == NULL);
 
-	read_lock(&tasklist_lock);
-	if (unlikely(p->sighand == NULL)) {
+	/*
+	 * Protect against sighand release/switch in exit/exec and process/
+	 * thread timer list entry concurrent read/writes.
+	 */
+	sighand = lock_task_sighand(p, &flags);
+	if (unlikely(sighand == NULL)) {
 		/*
 		 * We raced with the reaping of the task.
 		 * The deletion should have cleared us off the list.
 		 */
 		BUG_ON(!list_empty(&timer->it.cpu.entry));
 	} else {
-		spin_lock(&p->sighand->siglock);
 		if (timer->it.cpu.firing)
 			ret = TIMER_RETRY;
 		else
 			list_del(&timer->it.cpu.entry);
-		spin_unlock(&p->sighand->siglock);
+
+		unlock_task_sighand(p, &flags);
 	}
-	read_unlock(&tasklist_lock);
 
 	if (!ret)
 		put_task_struct(p);
-- 
1.8.3.1

