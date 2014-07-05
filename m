Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbaGEKs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:48:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbaGEKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:48:54 -0400
Date: Sat, 5 Jul 2014 03:48:03 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-72d5305dcb3637913c2c37e847a4de9028e49244@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1402511843-4721-5-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-5-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes:
  Optimize mutex trylock slowpath
Git-Commit-ID: 72d5305dcb3637913c2c37e847a4de9028e49244
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

Commit-ID:  72d5305dcb3637913c2c37e847a4de9028e49244
Gitweb:     http://git.kernel.org/tip/72d5305dcb3637913c2c37e847a4de9028e49244
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Wed, 11 Jun 2014 11:37:23 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:25:42 +0200

locking/mutexes: Optimize mutex trylock slowpath

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
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org
Cc: tim.c.chen@linux.intel.com
Cc: paulmck@linux.vnet.ibm.com
Cc: rostedt@goodmis.org
Cc: Waiman.Long@hp.com
Cc: scott.norton@hp.com
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1402511843-4721-5-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 4 ++++
 1 file changed, 4 insertions(+)

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
