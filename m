Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3EGNqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:46:15 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:55035 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3EGNqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:10 -0400
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
Subject: [PATCH v3 02/14] rwsem: shorter spinlocked section in rwsem_down_failed_common()
Date: Tue,  7 May 2013 06:45:50 -0700
Message-Id: <1367934362-10433-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change reduces the size of the spinlocked and TASK_UNINTERRUPTIBLE
sections in rwsem_down_failed_common():

- We only need the sem->wait_lock to insert ourselves on the wait_list;
  the waiter node can be prepared outside of the wait_lock.

- The task state only needs to be set to TASK_UNINTERRUPTIBLE immediately
  before checking if we actually need to sleep; it doesn't need to protect
  the entire function.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rwsem.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 672eb33218ac..40636454cf3c 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -188,14 +188,12 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	struct task_struct *tsk = current;
 	signed long count;
 
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-
 	/* set up my own style of waitqueue */
-	raw_spin_lock_irq(&sem->wait_lock);
 	waiter.task = tsk;
 	waiter.type = type;
 	get_task_struct(tsk);
 
+	raw_spin_lock_irq(&sem->wait_lock);
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter.list, &sem->wait_list);
@@ -218,7 +216,8 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	raw_spin_unlock_irq(&sem->wait_lock);
 
 	/* wait to be given the lock */
-	for (;;) {
+	while (true) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		if (!waiter.task)
 			break;
 
@@ -231,7 +230,6 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 			}
 		raw_spin_unlock_irq(&sem->wait_lock);
 		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 
 	tsk->state = TASK_RUNNING;
-- 
1.8.2.1

