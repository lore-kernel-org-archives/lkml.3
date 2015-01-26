Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbbAZHhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:37:17 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:39462 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbbAZHgq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:46 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 6/6] locking/rwsem: Check for active lock before bailing on spinning
Date: Sun, 25 Jan 2015 23:36:09 -0800
Message-Id: <1422257769-14083-7-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

37e9562453b (locking/rwsem: Allow conservative optimistic
spinning when readers have lock) forced the default for
optimistic spinning to be disabled if the lock owner was
nil, which makes much sense for readers. However, while
it is not our priority, we can make some optimizations
for write-mostly workloads. We can bail the spinning step
and still be conservative if there are any active tasks,
otherwise there's really no reason not to spin, as the
semaphore is most likely unlocked.

This patch recovers most of a Unixbench 'execl' benchmark
throughput by sleeping less and making better average system
usage:

before:
CPU     %user     %nice   %system   %iowait    %steal     %idle
all      0.60      0.00      8.02      0.00      0.00     91.38

after:
CPU     %user     %nice   %system   %iowait    %steal     %idle
all      1.22      0.00     70.18      0.00      0.00     28.60

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-xadd.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 88b3468..e0e9738 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -296,23 +296,30 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
-	bool on_cpu = false;
+	bool ret = true;
 
 	if (need_resched())
 		return false;
 
 	rcu_read_lock();
 	owner = ACCESS_ONCE(sem->owner);
-	if (owner)
-		on_cpu = owner->on_cpu;
-	rcu_read_unlock();
+	if (!owner) {
+		long count = ACCESS_ONCE(sem->count);
+		/*
+		 * If sem->owner is not set, yet we have just recently entered the
+		 * slowpath with the lock being active, then there is a possibility
+		 * reader(s) may have the lock. To be safe, bail spinning in these
+		 * situations.
+		 */
+		if (count & RWSEM_ACTIVE_MASK)
+			ret = false;
+		goto done;
+	}
 
-	/*
-	 * If sem->owner is not set, yet we have just recently entered the
-	 * slowpath, then there is a possibility reader(s) may have the lock.
-	 * To be safe, avoid spinning in these situations.
-	 */
-	return on_cpu;
+	ret = owner->on_cpu;
+done:
+	rcu_read_unlock();
+	return ret;
 }
 
 static inline bool owner_running(struct rw_semaphore *sem,
-- 
2.1.2

