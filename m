Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbbAZHhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:37:20 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:60006 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbbAZHgq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:46 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 5/6] locking/rwsem: Optimize slowpath/sleeping
Date: Sun, 25 Jan 2015 23:36:08 -0800
Message-Id: <1422257769-14083-6-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When blocking , we incur in multiple barriers when setting the
task's uninterruptable state. This is particularly bad when the
lock keeps getting stolen from the task trying to acquire the sem.
These changes propose delaying setting the task's new state until
we are sure that calling schedule is inevitable.

This implies that we do the trylock and active check (both basically
->counter checks) as TASK_RUNNING. For the trylock we hold the wait
lock with interrupts disabled, so no risk there. And for the active
check, the window for which we could get interrupted is quite small
and makes no tangible difference.

This patch increases Unixbench's 'execl' throughput by 25% on a 40
core machine.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-xadd.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 18a50da..88b3468 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -459,17 +459,27 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		count = rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
 
 	/* wait until we successfully acquire the lock */
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	while (true) {
 		if (rwsem_try_write_lock(count, sem))
 			break;
+
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		raw_spin_unlock_irq(&sem->wait_lock);
 
-		/* Block until there are no active lockers. */
-		do {
+		/*
+		 * When there are active locks after we wake up,
+		 * the lock was probably stolen from us. Thus,
+		 * go immediately back to sleep and avoid taking
+		 * the wait_lock.
+		 */
+		while (true) {
 			schedule();
-			set_current_state(TASK_UNINTERRUPTIBLE);
-		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
+
+			count = READ_ONCE(sem->count);
+			if (!(count & RWSEM_ACTIVE_MASK))
+				break;
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+		}
 
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
-- 
2.1.2

