Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3CFXWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:22:17 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37866 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3CFXWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:22:14 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] rwsem-spinlock: wake all readers when first waiter is a reader
Date: Wed,  6 Mar 2013 15:21:49 -0800
Message-Id: <1362612111-28673-11-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the first queued waiter is a reader, wake all readers instead of
just those that are at the front of the queue. This should result in
increased parallelism for workloads that mix readers and writers.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem-spinlock.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 5f117f37ac0a..d22948eeaeae 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -70,36 +70,29 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 
-	if (!wakewrite) {
-		if (waiter->type == RWSEM_WAITING_FOR_WRITE)
-			goto out;
-		goto dont_wake_writers;
-	}
-
-	/*
-	 * as we support write lock stealing, we can't set sem->activity
-	 * to -1 here to indicate we get the lock. Instead, we wake it up
-	 * to let it go get it again.
-	 */
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
-		wake_up_process(waiter->task);
+		if (wakewrite)
+			/* Wake up a writer. Note that we do not grant it the
+			 * lock - it will have to acquire it when it runs. */
+			wake_up_process(waiter->task);
 		goto out;
 	}
 
-	/* grant an infinite number of read locks to the front of the queue */
- dont_wake_writers:
+	/* grant read locks to all queued readers. */
 	woken = 0;
-	while (waiter->type == RWSEM_WAITING_FOR_READ) {
+	while (true) {
 		struct list_head *next = waiter->list.next;
 
-		list_del(&waiter->list);
-		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
-		woken++;
-		if (list_empty(&sem->wait_list))
+		if (waiter->type != RWSEM_WAITING_FOR_WRITE) {
+			list_del(&waiter->list);
+			tsk = waiter->task;
+			smp_mb();
+			waiter->task = NULL;
+			wake_up_process(tsk);
+			put_task_struct(tsk);
+			woken++;
+		}
+		if (next == &sem->wait_list)
 			break;
 		waiter = list_entry(next, struct rwsem_waiter, list);
 	}
-- 
1.8.1.3
