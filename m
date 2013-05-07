Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab3EGNsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:48:31 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:54829 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933558Ab3EGNq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:28 -0400
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
Subject: [PATCH v3 08/14] rwsem: avoid taking wait_lock in rwsem_down_write_failed
Date: Tue,  7 May 2013 06:45:56 -0700
Message-Id: <1367934362-10433-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rwsem_down_write_failed(), if there are active locks after we wake up
(i.e. the lock got stolen from us), skip taking the wait_lock and go back
to sleep immediately.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 lib/rwsem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 64c2dc007be2..edf3d9ca670e 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -214,8 +214,8 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	/* wait until we successfully acquire the lock */
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (true) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 
 		/* Try acquiring the write lock. */
 		count = RWSEM_ACTIVE_WRITE_BIAS;
@@ -226,7 +226,13 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 			break;
 
 		raw_spin_unlock_irq(&sem->wait_lock);
-		schedule();
+
+		/* Block until there are no active lockers. */
+		do {
+			schedule();
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		} while (sem->count & RWSEM_ACTIVE_MASK);
+
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
 
-- 
1.8.2.1

