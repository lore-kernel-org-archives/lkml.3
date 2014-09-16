Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaIPTCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:02:03 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38930 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaIPTCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:02:02 -0400
Message-ID: <1410894118.2447.4.camel@j-VirtualBox>
Subject: [PATCH v2] locking/rwsem: Avoid double checking before try
 acquiring write lock
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <dbueso@suse.de>
Cc: linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Jason Low <jason.low2@hp.com>
Date: Tue, 16 Sep 2014 12:01:58 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9b0fc9c09f1b checks for if there are known active lockers in
order to avoid write trylocking using expensive cmpxchg() when it
likely wouldn't get the lock.

However, a subsequent patch was added such that we directly check for
sem->count == RWSEM_WAITING_BIAS right before trying that cmpxchg().
Thus, commit 9b0fc9c09f1b now just adds extra overhead. This patch
deletes it.

Also, add a comment on why we do an "extra check" of sem->count before
the cmpxchg().

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/rwsem-xadd.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index d6203fa..63d3ef2 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -247,18 +247,20 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	return sem;
 }
 
-static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
+static inline bool rwsem_try_write_lock(struct rw_semaphore *sem)
 {
-	if (!(count & RWSEM_ACTIVE_MASK)) {
-		/* try acquiring the write lock */
-		if (sem->count == RWSEM_WAITING_BIAS &&
-		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
-			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
-			if (!list_is_singular(&sem->wait_list))
-				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
-			return true;
-		}
+	/*
+	 * Try acquiring the write lock. Check sem->count first
+	 * in order to reduce unnecessary expensive cmpxchg() operations.
+	 */
+	if (sem->count == RWSEM_WAITING_BIAS &&
+	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+		if (!list_is_singular(&sem->wait_list))
+			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+		return true;
 	}
+
 	return false;
 }
 
@@ -446,7 +448,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	/* wait until we successfully acquire the lock */
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	while (true) {
-		if (rwsem_try_write_lock(count, sem))
+		if (rwsem_try_write_lock(sem))
 			break;
 		raw_spin_unlock_irq(&sem->wait_lock);
 
-- 
1.7.1



