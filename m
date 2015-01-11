Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbbAKIj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 03:39:29 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39765 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbAKIj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:39:27 -0500
Date: Sun, 11 Jan 2015 09:39:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking fixes
Message-ID: <20150111083921.GA1493@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-urgent-for-linus

   # HEAD: 8e654dd68f95ac5f990ed21b2b31967dacbe563f Merge branch 'core/urgent' into locking/urgent, to collect all pending locking fixes

A liblockdep fix and a mutex_unlock() mutex-debugging fix.

 Thanks,

	Ingo

------------------>
Chris Wilson (1):
      mutex: Always clear owner field upon mutex_unlock()

Kirill Smelkov (1):
      tools/liblockdep: Fix debug_check thinko in mutex destroy


 kernel/locking/mutex-debug.c | 2 +-
 tools/lib/lockdep/preload.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 5cf6731b98e9..3ef3736002d8 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -80,13 +80,13 @@ void debug_mutex_unlock(struct mutex *lock)
 			DEBUG_LOCKS_WARN_ON(lock->owner != current);
 
 		DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-		mutex_clear_owner(lock);
 	}
 
 	/*
 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
 	 * mutexes so that we can do it here after we've verified state.
 	 */
+	mutex_clear_owner(lock);
 	atomic_set(&lock->count, 1);
 }
 
diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
index 6f803609e498..0b0112c80f22 100644
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -317,7 +317,7 @@ int pthread_mutex_destroy(pthread_mutex_t *mutex)
 	 *
 	 * TODO: Hook into free() and add that check there as well.
 	 */
-	debug_check_no_locks_freed(mutex, mutex + sizeof(*mutex));
+	debug_check_no_locks_freed(mutex, sizeof(*mutex));
 	__del_lock(__get_lock(mutex));
 	return ll_pthread_mutex_destroy(mutex);
 }
@@ -341,7 +341,7 @@ int pthread_rwlock_destroy(pthread_rwlock_t *rwlock)
 {
 	try_init_preload();
 
-	debug_check_no_locks_freed(rwlock, rwlock + sizeof(*rwlock));
+	debug_check_no_locks_freed(rwlock, sizeof(*rwlock));
 	__del_lock(__get_lock(rwlock));
 	return ll_pthread_rwlock_destroy(rwlock);
 }
