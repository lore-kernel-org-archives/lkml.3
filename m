Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaIDFep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:34:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIDFeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:34:44 -0400
Date: Wed, 3 Sep 2014 22:33:42 -0700
From: tip-bot for Mark Rustad <tipbot@zytor.com>
Message-ID: <tip-315427691c7a064718b5ad7d378d7f1c1898a626@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, mark.d.rustad@intel.com,
        jeffrey.t.kirsher@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mark.d.rustad@intel.com, tglx@linutronix.de,
        jeffrey.t.kirsher@intel.com
In-Reply-To: <1409739444-13635-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1409739444-13635-1-git-send-email-jeffrey.t.kirsher@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/semaphore:
  Resolve some shadow warnings
Git-Commit-ID: 315427691c7a064718b5ad7d378d7f1c1898a626
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

Commit-ID:  315427691c7a064718b5ad7d378d7f1c1898a626
Gitweb:     http://git.kernel.org/tip/315427691c7a064718b5ad7d378d7f1c1898a626
Author:     Mark Rustad <mark.d.rustad@intel.com>
AuthorDate: Wed, 3 Sep 2014 03:17:24 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 4 Sep 2014 07:17:24 +0200

locking/semaphore: Resolve some shadow warnings

Resolve some shadow warnings resulting from using the name
jiffies, which is a well-known global. This is not a problem
of course, but it could be a trap for someone copying and
pasting code, and it just makes W=2 a little cleaner.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1409739444-13635-1-git-send-email-jeffrey.t.kirsher@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/semaphore.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index 6815171..b8120ab 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -36,7 +36,7 @@
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
 static noinline int __down_killable(struct semaphore *sem);
-static noinline int __down_timeout(struct semaphore *sem, long jiffies);
+static noinline int __down_timeout(struct semaphore *sem, long timeout);
 static noinline void __up(struct semaphore *sem);
 
 /**
@@ -145,14 +145,14 @@ EXPORT_SYMBOL(down_trylock);
 /**
  * down_timeout - acquire the semaphore within a specified time
  * @sem: the semaphore to be acquired
- * @jiffies: how long to wait before failing
+ * @timeout: how long to wait before failing
  *
  * Attempts to acquire the semaphore.  If no more tasks are allowed to
  * acquire the semaphore, calling this function will put the task to sleep.
  * If the semaphore is not released within the specified number of jiffies,
  * this function returns -ETIME.  It returns 0 if the semaphore was acquired.
  */
-int down_timeout(struct semaphore *sem, long jiffies)
+int down_timeout(struct semaphore *sem, long timeout)
 {
 	unsigned long flags;
 	int result = 0;
@@ -161,7 +161,7 @@ int down_timeout(struct semaphore *sem, long jiffies)
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
-		result = __down_timeout(sem, jiffies);
+		result = __down_timeout(sem, timeout);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -248,9 +248,9 @@ static noinline int __sched __down_killable(struct semaphore *sem)
 	return __down_common(sem, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT);
 }
 
-static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
+static noinline int __sched __down_timeout(struct semaphore *sem, long timeout)
 {
-	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
+	return __down_common(sem, TASK_UNINTERRUPTIBLE, timeout);
 }
 
 static noinline void __sched __up(struct semaphore *sem)
