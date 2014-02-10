Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaBJUmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:42:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35714 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBJUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:31 -0500
Message-Id: <20140210203659.601973720@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 4/8] mutex: Unlock the mutex without the wait_lock
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=jason_low-mutex-unlock_the_mutex_without_the_wait_lock.patch
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
Cc: mingo@kernel.org
Cc: scott.norton@hp.com
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390936396-3962-4-git-send-email-jason.low2@hp.com
---
 kernel/locking/mutex.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -673,10 +673,6 @@ __mutex_unlock_common_slowpath(atomic_t
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
-	spin_lock_mutex(&lock->wait_lock, flags);
-	mutex_release(&lock->dep_map, nested, _RET_IP_);
-	debug_mutex_unlock(lock);
-
 	/*
 	 * some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
@@ -685,6 +681,10 @@ __mutex_unlock_common_slowpath(atomic_t
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
 
+	spin_lock_mutex(&lock->wait_lock, flags);
+	mutex_release(&lock->dep_map, nested, _RET_IP_);
+	debug_mutex_unlock(lock);
+
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =


