Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab3EGNqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:46:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44321 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3EGNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:31 -0400
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
Subject: [PATCH v3 09/14] rwsem: skip initial trylock in rwsem_down_write_failed
Date: Tue,  7 May 2013 06:45:57 -0700
Message-Id: <1367934362-10433-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can skip the initial trylock in rwsem_down_write_failed() if there are
known active lockers already, thus saving one likely-to-fail cmpxchg.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 lib/rwsem.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index edf3d9ca670e..0d50e46d5b0c 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -216,14 +216,15 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	/* wait until we successfully acquire the lock */
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (true) {
-
-		/* Try acquiring the write lock. */
-		count = RWSEM_ACTIVE_WRITE_BIAS;
-		if (!list_is_singular(&sem->wait_list))
-			count += RWSEM_WAITING_BIAS;
-		if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
+		if (!(count & RWSEM_ACTIVE_MASK)) {
+			/* Try acquiring the write lock. */
+			count = RWSEM_ACTIVE_WRITE_BIAS;
+			if (!list_is_singular(&sem->wait_list))
+				count += RWSEM_WAITING_BIAS;
+			if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
 							RWSEM_WAITING_BIAS)
-			break;
+				break;
+		}
 
 		raw_spin_unlock_irq(&sem->wait_lock);
 
@@ -231,7 +232,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		do {
 			schedule();
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		} while (sem->count & RWSEM_ACTIVE_MASK);
+		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
 
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
-- 
1.8.2.1

