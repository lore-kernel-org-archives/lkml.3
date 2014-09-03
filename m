Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaICKRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:17:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:23332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaICKR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:17:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="380745589"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v2] semaphore: Resolve some shadow warnings
Date: Wed,  3 Sep 2014 03:17:24 -0700
Message-Id: <1409739444-13635-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve some shadow warnings resulting from using the name
jiffies, which is a well-known global. This is not a problem
of course, but it could be a trap for someone copying and
pasting code, and it just makes W=2 a little cleaner.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
v2: change the renaming from njiffies to timeout based on feedback
    from Peter Zijlstra

 kernel/locking/semaphore.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index 6815171..7782dbc 100644
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
-- 
1.9.3

