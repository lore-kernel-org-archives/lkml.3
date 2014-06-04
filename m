Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaFDTBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:01:46 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:55911 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFDTBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:01:45 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, Waiman.Long@hp.com,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: [RFC PATCH] rwsem: Avoid double checking before trylock for rwsem_try_write_lock()
Date: Wed,  4 Jun 2014 12:01:11 -0700
Message-Id: <1401908471-8765-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies on top of linux-next.

Commit 9b0fc9c09f1b added an extra check in rwsem_down_write_failed()
for if there are known active lockers in order to avoid doing the cmpxchg()
that would likely be unnecessary.

However, a subsequent change was made such that we check for
sem->count == RWSEM_WAITING_BIAS right before trying that cmpxchg().
Thus, the first check added in commit 9b0fc9c09f1b now adds extra
overhead. This patch deletes it.

Note: we are now changing the rwsem_try_write_lock() as the relevant
code was recently moved into that function.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/rwsem-xadd.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 1f99664..6d01f2f 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -247,15 +247,13 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 
 static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
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
+	/* try acquiring the write lock */
+	if (sem->count == RWSEM_WAITING_BIAS &&
+	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+		if (!list_is_singular(&sem->wait_list))
+			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+		return true;
 	}
 	return false;
 }
-- 
1.7.1

