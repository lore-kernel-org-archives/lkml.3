Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbbAZHiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:38:07 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:56762 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbAZHgn (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:43 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/6] locking/rwsem: Document barrier need when waking tasks
Date: Sun, 25 Jan 2015 23:36:05 -0800
Message-Id: <1422257769-14083-3-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The need for the smp_mb in __rwsem_do_wake should be
properly documented. Applies to both xadd and spinlock
variants.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-spinlock.c | 5 +++++
 kernel/locking/rwsem-xadd.c     | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 2555ae1..54f7a17 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -85,6 +85,11 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 
 		list_del(&waiter->list);
 		tsk = waiter->task;
+		/*
+		 * Ensure that all cores see the read before
+		 * setting it to the waiter task to nil, as that
+		 * grants the read lock to the next task.
+		 */
 		smp_mb();
 		waiter->task = NULL;
 		wake_up_process(tsk);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 2f7cc40..149e8c7 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -186,6 +186,11 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 		waiter = list_entry(next, struct rwsem_waiter, list);
 		next = waiter->list.next;
 		tsk = waiter->task;
+		/*
+		 * Ensure that all cores see the read before
+		 * setting it to the waiter task to nil, as that
+		 * grants the read lock to the next task.
+		 */
 		smp_mb();
 		waiter->task = NULL;
 		wake_up_process(tsk);
-- 
2.1.2

