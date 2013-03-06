Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3CFXWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:22:04 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56362 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3CFXV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:21:59 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] rwsem: shorter spinlocked section in rwsem_down_failed_common()
Date: Wed,  6 Mar 2013 15:21:41 -0800
Message-Id: <1362612111-28673-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
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
1.8.1.3
