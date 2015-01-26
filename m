Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbbAZHhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:37:25 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:41550 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbbAZHgq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:46 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/6] locking/rwsem: Avoid deceiving lock spinners
Date: Sun, 25 Jan 2015 23:36:07 -0800
Message-Id: <1422257769-14083-5-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When readers hold the semaphore, the ->owner is nil. As such,
and unlike mutexes, '!owner' does not necessarily imply that
the lock is free. This will cause writer spinners to potentially
spin excessively as they've been mislead to thinking they have
a chance of acquiring the lock, instead of blocking.

This patch therefore replaces this bogus check to solely rely on
the counter to know if the lock is available. Because we don't
hold the wait lock, we can obviously do this in an unqueued
manner.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-xadd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 5e425d8..18a50da 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -335,6 +335,8 @@ static inline bool owner_running(struct rw_semaphore *sem,
 static noinline
 bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
 {
+	long count;
+
 	rcu_read_lock();
 	while (owner_running(sem, owner)) {
 		if (need_resched())
@@ -347,9 +349,11 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
 	/*
 	 * We break out the loop above on need_resched() or when the
 	 * owner changed, which is a sign for heavy contention. Return
-	 * success only when sem->owner is NULL.
+	 * success only when the lock is available in order to attempt
+	 * another trylock.
 	 */
-	return sem->owner == NULL;
+	count = READ_ONCE(sem->count);
+	return count == 0 || count == RWSEM_WAITING_BIAS;
 }
 
 static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
-- 
2.1.2

