Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaFDTIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:08:42 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:42607 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFDTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:08:40 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, Waiman.Long@hp.com,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        jason.low2@hp.com
Subject: [RFC PATCH 3/3] locking/mutex: Optimize mutex trylock slowpath
Date: Wed,  4 Jun 2014 12:08:31 -0700
Message-Id: <1401908911-8947-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __mutex_trylock_slowpath(), we acquire the wait_lock spinlock,
xchg() lock->count with -1, then set lock->count back to 0 if there
are no waiters, and return true if the prev lock count was 1.

However, if we the mutex is already locked, then there may not be
much point in attempting the above operations. In this patch, we only
attempt the above operations if the mutex is unlocked.

The new MUTEX_IS_UNLOCKED() macro is also used for this.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index fc55f72..c65680d 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -821,21 +821,26 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
-	int prev;
+	int prev = 0;
 
-	spin_lock_mutex(&lock->wait_lock, flags);
+	/*
+	 * Only need to trylock the mutex if it is unlocked.
+	 */
+	if (MUTEX_IS_UNLOCKED(lock)) {
+		spin_lock_mutex(&lock->wait_lock, flags);
 
-	prev = atomic_xchg(&lock->count, -1);
-	if (likely(prev == 1)) {
-		mutex_set_owner(lock);
-		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-	}
+		prev = atomic_xchg(&lock->count, -1);
+		if (likely(prev == 1)) {
+			mutex_set_owner(lock);
+			mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		}
 
-	/* Set it back to 0 if there are no waiters: */
-	if (likely(list_empty(&lock->wait_list)))
-		atomic_set(&lock->count, 0);
+		/* Set it back to 0 if there are no waiters: */
+		if (likely(list_empty(&lock->wait_list)))
+			atomic_set(&lock->count, 0);
 
-	spin_unlock_mutex(&lock->wait_lock, flags);
+		spin_unlock_mutex(&lock->wait_lock, flags);
+	}
 
 	return prev == 1;
 }
-- 
1.7.1

