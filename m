Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaFLVUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:20:31 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:26472 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFLVUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:20:19 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com, Waiman.Long@hp.com,
        scott.norton@hp.com, aswin@hp.com, jason.low2@hp.com
Subject: [PATCH v3 3/3] mutex: Optimize mutex trylock slowpath
Date: Thu, 12 Jun 2014 14:20:14 -0700
Message-Id: <1402608014-11473-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
References: <1402608014-11473-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex_trylock() function calls into __mutex_trylock_fastpath() when
trying to obtain the mutex. On 32 bit x86, in the !__HAVE_ARCH_CMPXCHG
case, __mutex_trylock_fastpath() calls directly into __mutex_trylock_slowpath()
regardless of whether or not the mutex is locked.
  
In __mutex_trylock_slowpath(), we then acquire the wait_lock spinlock, xchg()
lock->count with -1, then set lock->count back to 0 if there are no waiters,
and return true if the prev lock count was 1.

However, if the mutex is already locked, then there isn't much point
in attempting all of the above expensive operations. In this patch, we only
attempt the above trylock operations if the mutex is unlocked.

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index e4d997b..11b103d 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -820,6 +820,10 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	unsigned long flags;
 	int prev;
 
+	/* No need to trylock if the mutex is locked. */
+	if (mutex_is_locked(lock))
+		return 0;
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
-- 
1.7.1

