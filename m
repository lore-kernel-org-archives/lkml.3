Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaFLVUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:20:20 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:44463 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaFLVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:20:18 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com, Waiman.Long@hp.com,
        scott.norton@hp.com, aswin@hp.com, jason.low2@hp.com
Subject: [PATCH v3 2/3] mutex: Try-acquire mutex only if unlocked and improve code clarity
Date: Thu, 12 Jun 2014 14:20:13 -0700
Message-Id: <1402608014-11473-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
References: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon entering the slowpath in __mutex_lock_common(), we try once more to
acquire the mutex if (lock->count >= 0). However, what we actually want
here is to try to acquire if the mutex is unlocked (lock->count == 1).

This patch changes it so that we only try-acquire the mutex upon entering
the slowpath if it is unlocked to further reduce unnecessary xchg() operations.

Furthermore, this patch uses !mutex_is_locked(lock) to do the initial
checks for if the lock is free rather than directly calling atomic_read()
on the lock->count, in order to improve readability.

Also, delete the MUTEX_SHOW_NO_WAITER() macro, because the macro doesn't
always do what its name suggests. Directly use atomic_read() instead of
the macro and add comments on how the extra atomic_read() can be helpful.

Acked-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index dd26bf6..e4d997b 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -46,12 +46,6 @@
 # include <asm/mutex.h>
 #endif
 
-/*
- * A negative mutex count indicates that waiters are sleeping waiting for the
- * mutex.
- */
-#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
-
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -438,7 +432,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if ((atomic_read(&lock->count) == 1) &&
+		/* Try to acquire the mutex if it is unlocked. */
+		if (!mutex_is_locked(lock) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			if (use_ww_ctx) {
@@ -483,8 +478,11 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
-	/* once more, can we acquire the lock? */
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+	/*
+	 * Once more, try to acquire the lock. Only try-lock the mutex if
+	 * it is unlocked to reduce unnecessary xchg() operations.
+	 */
+	if (!mutex_is_locked(lock) && (atomic_xchg(&lock->count, 0) == 1))
 		goto skip_wait;
 
 	debug_mutex_lock_common(lock, &waiter);
@@ -504,9 +502,10 @@ slowpath:
 		 * it's unlocked. Later on, if we sleep, this is the
 		 * operation that gives us the lock. We xchg it to -1, so
 		 * that when we release the lock, we properly wake up the
-		 * other waiters:
+		 * other waiters. We only attempt the xchg if the count is
+		 * non-negative in order to avoid unnecessary xchg operations:
 		 */
-		if (MUTEX_SHOW_NO_WAITER(lock) &&
+		if (atomic_read(&lock->count) >= 0 &&
 		    (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
-- 
1.7.1

