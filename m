Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaFKShx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:37:53 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:8109 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaFKShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:37:51 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, davidlohr@hp.com,
        Waiman.Long@hp.com, scott.norton@hp.com, aswin@hp.com,
        jason.low2@hp.com
Subject: [PATCH v2 4/4] mutex: Optimize mutex trylock slowpath
Date: Wed, 11 Jun 2014 11:37:23 -0700
Message-Id: <1402511843-4721-5-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-1-git-send-email-jason.low2@hp.com>
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

