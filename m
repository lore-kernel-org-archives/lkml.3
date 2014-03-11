Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaCKMnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:43:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaCKMlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:41:53 -0400
Date: Tue, 11 Mar 2014 05:41:23 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com
In-Reply-To: <1390936396-3962-4-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-4-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mutexes:
  Unlock the mutex without the wait_lock
Git-Commit-ID: 1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8
Gitweb:     http://git.kernel.org/tip/1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue, 28 Jan 2014 11:13:14 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:14:54 +0100

locking/mutexes: Unlock the mutex without the wait_lock

When running workloads that have high contention in mutexes on an 8 socket
machine, mutex spinners would often spin for a long time with no lock owner.

The main reason why this is occuring is in __mutex_unlock_common_slowpath(),
if __mutex_slowpath_needs_to_unlock(), then the owner needs to acquire the
mutex->wait_lock before releasing the mutex (setting lock->count to 1). When
the wait_lock is contended, this delays the mutex from being released.
We should be able to release the mutex without holding the wait_lock.

Signed-off-by: Jason Low <jason.low2@hp.com>
Cc: chegu_vinod@hp.com
Cc: paulmck@linux.vnet.ibm.com
Cc: Waiman.Long@hp.com
Cc: torvalds@linux-foundation.org
Cc: tglx@linutronix.de
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: scott.norton@hp.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390936396-3962-4-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 82dad2c..dc3d6f2 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -671,10 +671,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
-	spin_lock_mutex(&lock->wait_lock, flags);
-	mutex_release(&lock->dep_map, nested, _RET_IP_);
-	debug_mutex_unlock(lock);
-
 	/*
 	 * some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
@@ -683,6 +679,10 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
 
+	spin_lock_mutex(&lock->wait_lock, flags);
+	mutex_release(&lock->dep_map, nested, _RET_IP_);
+	debug_mutex_unlock(lock);
+
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =
