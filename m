Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3GXD4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:56:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3GXD4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:56:18 -0400
Date: Tue, 23 Jul 2013 20:55:43 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-ec83f425dbca47e19c6737e8e7db0d0924a5de1b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl, riel@redhat.com,
        tglx@linutronix.de, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl, riel@redhat.com,
        tglx@linutronix.de, maarten.lankhorst@canonical.com
In-Reply-To: <1372450398.2106.1.camel@buesod1.americas.hpqcorp.net>
References: <1372450398.2106.1.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Do not unnecessarily deal with waiters
Git-Commit-ID: ec83f425dbca47e19c6737e8e7db0d0924a5de1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:55:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec83f425dbca47e19c6737e8e7db0d0924a5de1b
Gitweb:     http://git.kernel.org/tip/ec83f425dbca47e19c6737e8e7db0d0924a5de1b
Author:     Davidlohr Bueso <davidlohr.bueso@hp.com>
AuthorDate: Fri, 28 Jun 2013 13:13:18 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 11:48:37 +0200

mutex: Do not unnecessarily deal with waiters

Upon entering the slowpath, we immediately attempt to acquire
the lock by checking if it is already unlocked. If we are lucky
enough that this is the case, then we don't need to deal with
any waiter related logic.

Furthermore any checks for an empty wait_list are unnecessary as
we already know that count is non-negative and hence no one is
waiting for the lock.

Move the count check and xchg calls to be done before any
waiters are setup - including waiter debugging. Upon failure to
acquire the lock, the xchg sets the counter to 0, instead of -1
as it was originally. This can be done here since we set it back
to -1 right at the beginning of the loop so other waiters are
woken up when the lock is released.

When tested on a 8-socket (80 core) system against a vanilla
3.10-rc1 kernel, this patch provides some small performance
benefits (+2-6%). While it could be considered in the noise
level, the average percentages were stable across multiple runs
and no performance regressions were seen. Two big winners, for
small amounts of users (10-100), were the short and compute
workloads had a +19.36% and +%15.76% in jobs per minute.

Also change some break statements to 'goto slowpath', which IMO
makes a little more intuitive to read.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1372450398.2106.1.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/mutex.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 7ff48c5..386ad5d 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -463,7 +463,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			 * performed the optimistic spinning cannot be done.
 			 */
 			if (ACCESS_ONCE(ww->ctx))
-				break;
+				goto slowpath;
 		}
 
 		/*
@@ -474,7 +474,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		owner = ACCESS_ONCE(lock->owner);
 		if (owner && !mutex_spin_on_owner(lock, owner)) {
 			mspin_unlock(MLOCK(lock), &node);
-			break;
+			goto slowpath;
 		}
 
 		if ((atomic_read(&lock->count) == 1) &&
@@ -489,8 +489,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 			mutex_set_owner(lock);
 			mspin_unlock(MLOCK(lock), &node);
-			preempt_enable();
-			return 0;
+			goto done;
 		}
 		mspin_unlock(MLOCK(lock), &node);
 
@@ -501,7 +500,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			break;
+			goto slowpath;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -515,6 +514,10 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
+	/* once more, can we acquire the lock? */
+	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+		goto skip_wait;
+
 	debug_mutex_lock_common(lock, &waiter);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
@@ -522,9 +525,6 @@ slowpath:
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, -1) == 1))
-		goto done;
-
 	lock_contended(&lock->dep_map, ip);
 
 	for (;;) {
@@ -538,7 +538,7 @@ slowpath:
 		 * other waiters:
 		 */
 		if (MUTEX_SHOW_NO_WAITER(lock) &&
-		   (atomic_xchg(&lock->count, -1) == 1))
+		    (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
 		/*
@@ -563,24 +563,25 @@ slowpath:
 		schedule_preempt_disabled();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
+	/* set it to 0 if there are no waiters left: */
+	if (likely(list_empty(&lock->wait_list)))
+		atomic_set(&lock->count, 0);
+	debug_mutex_free_waiter(&waiter);
 
-done:
+skip_wait:
+	/* got the lock - cleanup and rejoice! */
 	lock_acquired(&lock->dep_map, ip);
-	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
 	if (!__builtin_constant_p(ww_ctx == NULL)) {
-		struct ww_mutex *ww = container_of(lock,
-						      struct ww_mutex,
-						      base);
+		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 		struct mutex_waiter *cur;
 
 		/*
 		 * This branch gets optimized out for the common case,
 		 * and is only important for ww_mutex_lock.
 		 */
-
 		ww_mutex_lock_acquired(ww, ww_ctx);
 		ww->ctx = ww_ctx;
 
@@ -594,15 +595,9 @@ done:
 		}
 	}
 
-	/* set it to 0 if there are no waiters left: */
-	if (likely(list_empty(&lock->wait_list)))
-		atomic_set(&lock->count, 0);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
-
-	debug_mutex_free_waiter(&waiter);
+done:
 	preempt_enable();
-
 	return 0;
 
 err:
