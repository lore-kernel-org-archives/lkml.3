Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaA1TNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:13:42 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32554 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaA1TNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:13:40 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH v2 3/5] mutex: Unlock the mutex without the wait_lock
Date: Tue, 28 Jan 2014 11:13:14 -0800
Message-Id: <1390936396-3962-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running workloads that have high contention in mutexes on an 8 socket
machine, mutex spinners would often spin for a long time with no lock owner.

The main reason why this is occuring is in __mutex_unlock_common_slowpath(),
if __mutex_slowpath_needs_to_unlock(), then the owner needs to acquire the
mutex->wait_lock before releasing the mutex (setting lock->count to 1). When
the wait_lock is contended, this delays the mutex from being released.
We should be able to release the mutex without holding the wait_lock.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 7519d27..6d85b08 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -718,10 +718,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
-	spin_lock_mutex(&lock->wait_lock, flags);
-	mutex_release(&lock->dep_map, nested, _RET_IP_);
-	debug_mutex_unlock(lock);
-
 	/*
 	 * some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
@@ -730,6 +726,10 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
 
+	spin_lock_mutex(&lock->wait_lock, flags);
+	mutex_release(&lock->dep_map, nested, _RET_IP_);
+	debug_mutex_unlock(lock);
+
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =
-- 
1.7.1

