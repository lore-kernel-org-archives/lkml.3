Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbaFKShk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:37:40 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55273 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaFKShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:37:37 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, davidlohr@hp.com,
        Waiman.Long@hp.com, scott.norton@hp.com, aswin@hp.com,
        jason.low2@hp.com
Subject: [PATCH v2 3/4] mutex: Try to acquire mutex only if it is unlocked
Date: Wed, 11 Jun 2014 11:37:22 -0700
Message-Id: <1402511843-4721-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon entering the slowpath in __mutex_lock_common(), we try once more to
acquire the mutex. We only try to acquire if (lock->count >= 0). However,
what we actually want here is to try to acquire if the mutex is unlocked
(lock->count == 1). 
  
This patch changes it so that we only try-acquire the mutex upon entering
the slowpath if it is unlocked, rather than if the lock count is non-negative.
This helps further reduce unnecessary atomic xchg() operations.

Furthermore, this patch uses !mutex_is_locked(lock) to do the initial
checks for if the lock is free rather than directly calling atomic_read()
on the lock->count, in order to improve readability.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4bd9546..e4d997b 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -432,7 +432,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if ((atomic_read(&lock->count) == 1) &&
+		/* Try to acquire the mutex if it is unlocked. */
+		if (!mutex_is_locked(lock) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			if (use_ww_ctx) {
@@ -479,9 +480,9 @@ slowpath:
 
 	/*
 	 * Once more, try to acquire the lock. Only try-lock the mutex if
-	 * lock->count >= 0 to reduce unnecessary xchg operations.
+	 * it is unlocked to reduce unnecessary xchg() operations.
 	 */
-	if (atomic_read(&lock->count) >= 0 && (atomic_xchg(&lock->count, 0) == 1))
+	if (!mutex_is_locked(lock) && (atomic_xchg(&lock->count, 0) == 1))
 		goto skip_wait;
 
 	debug_mutex_lock_common(lock, &waiter);
-- 
1.7.1

