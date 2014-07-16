Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbaGPTVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:21:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaGPTVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:21:30 -0400
Date: Wed, 16 Jul 2014 12:20:19 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-37e9562453b813d2ea527bd9531fef2c3c592847@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com, dchinner@redhat.com,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com, dchinner@redhat.com,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1404532172.2572.30.camel@j-VirtualBox>
References: <1404532172.2572.30.camel@j-VirtualBox>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] locking/rwsem:
  Allow conservative optimistic spinning when readers have lock
Git-Commit-ID: 37e9562453b813d2ea527bd9531fef2c3c592847
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

Commit-ID:  37e9562453b813d2ea527bd9531fef2c3c592847
Gitweb:     http://git.kernel.org/tip/37e9562453b813d2ea527bd9531fef2c3c592847
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Fri, 4 Jul 2014 20:49:32 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:28:02 +0200

locking/rwsem: Allow conservative optimistic spinning when readers have lock

Commit 4fc828e24cd9 ("locking/rwsem: Support optimistic spinning")
introduced a major performance regression for workloads such as
xfs_repair which mix read and write locking of the mmap_sem across
many threads. The result was xfs_repair ran 5x slower on 3.16-rc2
than on 3.15 and using 20x more system CPU time.

Perf profiles indicate in some workloads that significant time can
be spent spinning on !owner. This is because we don't set the lock
owner when readers(s) obtain the rwsem.

In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll
return false if there is no lock owner. The rationale is that if we
just entered the slowpath, yet there is no lock owner, then there is
a possibility that a reader has the lock. To be conservative, we'll
avoid spinning in these situations.

This patch reduced the total run time of the xfs_repair workload from
about 4 minutes 24 seconds down to approximately 1 minute 26 seconds,
back to close to the same performance as on 3.15.

Retesting of AIM7, which were some of the workloads used to test the
original optimistic spinning code, confirmed that we still get big
performance gains with optimistic spinning, even with this additional
regression fix. Davidlohr found that while the 'custom' workload took
a performance hit of ~-14% to throughput for >300 users with this
additional patch, the overall gain with optimistic spinning is
still ~+45%. The 'disk' workload even improved by ~+15% at >1000 users.

Tested-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1404532172.2572.30.camel@j-VirtualBox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/rwsem-xadd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..c40c7d2 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -285,10 +285,10 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
-	bool on_cpu = true;
+	bool on_cpu = false;
 
 	if (need_resched())
-		return 0;
+		return false;
 
 	rcu_read_lock();
 	owner = ACCESS_ONCE(sem->owner);
@@ -297,9 +297,9 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 	rcu_read_unlock();
 
 	/*
-	 * If sem->owner is not set, the rwsem owner may have
-	 * just acquired it and not set the owner yet or the rwsem
-	 * has been released.
+	 * If sem->owner is not set, yet we have just recently entered the
+	 * slowpath, then there is a possibility reader(s) may have the lock.
+	 * To be safe, avoid spinning in these situations.
 	 */
 	return on_cpu;
 }
