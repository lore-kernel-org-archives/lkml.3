Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947517Ab3BICqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 21:46:34 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59196 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3BICpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 21:45:47 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: [PATCH 2/4] rwsem: shorter spinlocked section in rwsem_down_failed_common()
Date: Fri,  8 Feb 2013 18:45:35 -0800
Message-Id: <1360377937-16297-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360377937-16297-1-git-send-email-walken@google.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change reduces the size of the spinlocked and TASK_UNINTERRUPTIBLE
sections in rwsem_down_failed_common():

- We only need the sem->wait_lock to insert ourselves on the wait_list;
  the waiter node can be prepared outside of the wait_lock.

- The task state only needs to be set to TASK_UNINTERRUPTIBLE immediately
  before testing waiter.task to see if someone woke us; it doesn't need to
  protect the entire function.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 4a6ff093a433..cd2d803cbbe4 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -180,14 +180,12 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
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
@@ -210,11 +208,11 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	raw_spin_unlock_irq(&sem->wait_lock);
 
 	/* wait to be given the lock */
-	for (;;) {
+	while (true) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		if (!waiter.task)
 			break;
 		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 
 	tsk->state = TASK_RUNNING;
-- 
1.8.1
