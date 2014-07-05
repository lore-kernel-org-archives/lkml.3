Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbaGEKsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:48:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbaGEKso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:48:44 -0400
Date: Sat, 5 Jul 2014 03:47:50 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-0d968dd8c6aced585b86fa7ba8ce4573bf19e848@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tglx@linutronix.de
In-Reply-To: <1402511843-4721-4-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-4-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes:
  Try to acquire mutex only if it is unlocked
Git-Commit-ID: 0d968dd8c6aced585b86fa7ba8ce4573bf19e848
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

Commit-ID:  0d968dd8c6aced585b86fa7ba8ce4573bf19e848
Gitweb:     http://git.kernel.org/tip/0d968dd8c6aced585b86fa7ba8ce4573bf19e848
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Wed, 11 Jun 2014 11:37:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:25:42 +0200

locking/mutexes: Try to acquire mutex only if it is unlocked

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
Acked-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org
Cc: tim.c.chen@linux.intel.com
Cc: paulmck@linux.vnet.ibm.com
Cc: rostedt@goodmis.org
Cc: davidlohr@hp.com
Cc: scott.norton@hp.com
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1402511843-4721-4-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
