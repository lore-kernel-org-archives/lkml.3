Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaFDTIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:08:38 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:20299 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFDTIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:08:36 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com, riel@redhat.com,
        hpa@zytor.com, walken@google.com, davidlohr@hp.com, Waiman.Long@hp.com,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        jason.low2@hp.com
Subject: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it is unlocked
Date: Wed,  4 Jun 2014 12:08:29 -0700
Message-Id: <1401908911-8947-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon entering the slowpath in __mutex_lock_common(), we try once more
to acquire the mutex. We only try to acquire it if MUTEX_SHOW_NO_WAITER
(lock->count >= 0) is true in order to avoid using the atomic xchg()
operation whenever it is not necessary. However, we really only need
to try to acquire if the mutex is free (lock->count == 1).

This patch changes it so that we only try-acquire the mutex upon
entering the slowpath if it is unlocked, rather than if there are
no waiters. This helps further reduce unncessary atomic xchg()
operations. Furthermore, this patch introduces and uses a new
MUTEX_IS_UNLOCKED() macro to improve readbability.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..0925968 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -48,9 +48,10 @@
 
 /*
  * A negative mutex count indicates that waiters are sleeping waiting for the
- * mutex.
+ * mutex, and a count of one indicates the mutex is unlocked.
  */
 #define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
+#define	MUTEX_IS_UNLOCKED(mutex)	(atomic_read(&(mutex)->count) == 1)
 
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
@@ -440,7 +441,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if ((atomic_read(&lock->count) == 1) &&
+		/* Try to acquire the lock if it is free. */
+		if (MUTEX_IS_UNLOCKED(lock) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			if (use_ww_ctx) {
@@ -485,8 +487,8 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
-	/* once more, can we acquire the lock? */
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+	/* once more, try to acquire the lock if it is free: */
+	if (MUTEX_IS_UNLOCKED(lock) && (atomic_xchg(&lock->count, 0) == 1))
 		goto skip_wait;
 
 	debug_mutex_lock_common(lock, &waiter);
-- 
1.7.1

