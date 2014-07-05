Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbaGEKsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:48:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaGEKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:48:34 -0400
Date: Sat, 5 Jul 2014 03:47:36 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-1e820c9608eace237e2c519d8fd9074aec479d81@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tglx@linutronix.de
In-Reply-To: <1402511843-4721-3-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-3-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes:
  Delete the MUTEX_SHOW_NO_WAITER macro
Git-Commit-ID: 1e820c9608eace237e2c519d8fd9074aec479d81
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

Commit-ID:  1e820c9608eace237e2c519d8fd9074aec479d81
Gitweb:     http://git.kernel.org/tip/1e820c9608eace237e2c519d8fd9074aec479d81
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Wed, 11 Jun 2014 11:37:21 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:25:41 +0200

locking/mutexes: Delete the MUTEX_SHOW_NO_WAITER macro

MUTEX_SHOW_NO_WAITER() is a macro which checks for if there are
"no waiters" on a mutex by checking if the lock count is non-negative.
Based on feedback from the discussion in the earlier version of this
patchset, the macro is not very readable.

Furthermore, checking lock->count isn't always the correct way to
determine if there are "no waiters" on a mutex. For example, a negative
count on a mutex really only means that there "potentially" are
waiters. Likewise, there can be waiters on the mutex even if the count is
non-negative. Thus, "MUTEX_SHOW_NO_WAITER" doesn't always do what the name
of the macro suggests.

So this patch deletes the MUTEX_SHOW_NO_WAITERS() macro, directly
use atomic_read() instead of the macro, and adds comments which
elaborate on how the extra atomic_read() checks can help reduce
unnecessary xchg() operations.

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
Link: http://lkml.kernel.org/r/1402511843-4721-3-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index dd26bf6de..4bd9546 100644
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
@@ -483,8 +477,11 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
-	/* once more, can we acquire the lock? */
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+	/*
+	 * Once more, try to acquire the lock. Only try-lock the mutex if
+	 * lock->count >= 0 to reduce unnecessary xchg operations.
+	 */
+	if (atomic_read(&lock->count) >= 0 && (atomic_xchg(&lock->count, 0) == 1))
 		goto skip_wait;
 
 	debug_mutex_lock_common(lock, &waiter);
@@ -504,9 +501,10 @@ slowpath:
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
 
