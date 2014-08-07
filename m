Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaHGW1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:18 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:15442 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaHGW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:00 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 2/7] locking/rwsem: threshold limited spinning for active readers
Date: Thu,  7 Aug 2014 18:26:43 -0400
Message-Id: <1407450408-11679-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even thought only the writers can perform optimistic spinning, there
is still a chance that readers may take the lock before a spinning
writer can get it. In that case, the owner field will be NULL and the
spinning writer can spin indefinitely until its time quantum expires
when some lock owning readers are not running.

This patch tries to handle this special case by doing threshold limited
spinning when the owner field is NULL. The threshold is small enough
that even if the readers are not running, it will not cause a lot of
wasted spinning cycles.  With that change, the patch tries to strike a
balance between giving up too early and losing potential performance
gain and wasting too many precious CPU cycles when some lock owning
readers are not running.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index d38cfae..ddd56d2 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -304,6 +304,14 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 
 #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 /*
+ * Thresholds for optimistic spinning on readers
+ *
+ * This is the threshold for the number of spins that happens before the
+ * spinner gives up when the owner field is NULL.
+ */
+#define SPIN_READ_THRESHOLD	64
+
+/*
  * Try to acquire write lock before the writer has been put on wait queue.
  */
 static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
@@ -381,10 +389,20 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
 	return sem->owner == NULL;
 }
 
+/*
+ * With active writer, spinning is done by checking if that writer is on
+ * CPU. With active readers, there is no easy way to determine if all of
+ * them are active. So it falls back to spin a certain number of times
+ * (SPIN_READ_THRESHOLD) before giving up. The threshold is relatively
+ * small with the expectation that readers are quick. For slow readers,
+ * the spinners will still fall back to sleep. On the other hand, it won't
+ * waste too many cycles when the lock owning readers are not running.
+ */
 static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
 	bool taken = false;
+	int  spincnt = 0;
 
 	preempt_disable();
 
@@ -397,8 +415,18 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 
 	while (true) {
 		owner = ACCESS_ONCE(sem->owner);
-		if (owner && !rwsem_spin_on_owner(sem, owner))
+		if (!owner) {
+			/*
+			 * Give up spinning if spincnt reaches the threshold.
+			 */
+			if (spincnt++ >= SPIN_READ_THRESHOLD)
+				break;
+		} else if (!rwsem_spin_on_owner(sem, owner)) {
 			break;
+		} else {
+			/* Reset count when owner is defined */
+			spincnt = 0;
+		}
 
 		/* wait_lock will be acquired if write_lock is obtained */
 		if (rwsem_try_write_lock_unqueued(sem)) {
-- 
1.7.1

