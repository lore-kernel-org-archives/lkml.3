Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3EGNrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:47:49 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35085 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab3EGNqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:36 -0400
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
Subject: [PATCH v3 12/14] rwsem: do not block readers at head of queue if other readers are active
Date: Tue,  7 May 2013 06:46:00 -0700
Message-Id: <1367934362-10433-13-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes a race condition where a reader might determine it
needs to block, but by the time it acquires the wait_lock the rwsem
has active readers and no queued waiters.

In this situation the reader can run in parallel with the existing active
readers; it does not need to block until the active readers complete.

Thanks to Peter Hurley for noticing this possible race.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rwsem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index bbe48c04f363..61f91ca75e40 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -163,8 +163,14 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* If there are no active locks, wake the front queued process(es). */
-	if (!(count & RWSEM_ACTIVE_MASK))
+	/* If there are no active locks, wake the front queued process(es).
+	 *
+	 * If there are no writers and we are first in the queue,
+	 * wake our own waiter to join the existing active readers !
+	 */
+	if (count == RWSEM_WAITING_BIAS ||
+	    (count > RWSEM_WAITING_BIAS &&
+	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
-- 
1.8.2.1

