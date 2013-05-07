Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab3EGNsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:48:45 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:65092 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933578Ab3EGNq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:27 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/14] rwsem: use cmpxchg for trying to steal write lock
Date: Tue,  7 May 2013 06:45:55 -0700
Message-Id: <1367934362-10433-8-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using rwsem_atomic_update to try stealing the write lock forced us to
undo the adjustment in the failure path. We can have simpler and faster
code by using cmpxchg instead.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 lib/rwsem.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 2360bf204098..64c2dc007be2 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -142,25 +142,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	return sem;
 }
 
-/* Try to get write sem, caller holds sem->wait_lock: */
-static int try_get_writer_sem(struct rw_semaphore *sem)
-{
-	long oldcount, adjustment;
-
-	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
-	if (list_is_singular(&sem->wait_list))
-		adjustment -= RWSEM_WAITING_BIAS;
-
-try_again_write:
-	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-	if (!(oldcount & RWSEM_ACTIVE_MASK))
-		return 1;
-	/* some one grabbed the sem already */
-	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
-		return 0;
-	goto try_again_write;
-}
-
 /*
  * wait for the read lock to be granted
  */
@@ -236,7 +217,12 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	while (true) {
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 
-		if (try_get_writer_sem(sem))
+		/* Try acquiring the write lock. */
+		count = RWSEM_ACTIVE_WRITE_BIAS;
+		if (!list_is_singular(&sem->wait_list))
+			count += RWSEM_WAITING_BIAS;
+		if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
+							RWSEM_WAITING_BIAS)
 			break;
 
 		raw_spin_unlock_irq(&sem->wait_lock);
-- 
1.8.2.1

