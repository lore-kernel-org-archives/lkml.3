Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3CFXWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:22:12 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52222 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3CFXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:22:09 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] rwsem: use cmpxchg for trying to steal write lock
Date: Wed,  6 Mar 2013 15:21:46 -0800
Message-Id: <1362612111-28673-8-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using rwsem_atomic_update to try stealing the write lock forced us to
undo the adjustment in the failure path. We can have simpler and faster
code by using cmpxchg instead.

Signed-off-by: Michel Lespinasse <walken@google.com>

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
1.8.1.3
