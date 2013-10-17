Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab3JQQvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:51:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab3JQQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:51:00 -0400
Date: Thu, 17 Oct 2013 09:49:29 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-746023159c40c523b08a3bc3d213dac212385895@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jmario@redhat.com, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, jmario@redhat.com, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <20131010181722.GO13848@laptop.programming.kicks-ass.net>
References: <20131010181722.GO13848@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix race in migrate_swap_stop()
Git-Commit-ID: 746023159c40c523b08a3bc3d213dac212385895
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 09:49:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  746023159c40c523b08a3bc3d213dac212385895
Gitweb:     http://git.kernel.org/tip/746023159c40c523b08a3bc3d213dac212385895
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 10 Oct 2013 20:17:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Oct 2013 14:22:14 +0200

sched: Fix race in migrate_swap_stop()

There is a subtle race in migrate_swap, when task P, on CPU A, decides to swap
places with task T, on CPU B.

Task P:
  - call migrate_swap
Task T:
  - go to sleep, removing itself from the runqueue
Task P:
  - double lock the runqueues on CPU A & B
Task T:
  - get woken up, place itself on the runqueue of CPU C
Task P:
  - see that task T is on a runqueue, and pretend to remove it
    from the runqueue on CPU B

Now CPUs B & C both have corrupted scheduler data structures.

This patch fixes it, by holding the pi_lock for both of the tasks
involved in the migrate swap. This prevents task T from waking up,
and placing itself onto another runqueue, until after migrate_swap
has released all locks.

This means that, when migrate_swap checks, task T will be either
on the runqueue where it was originally seen, or not on any
runqueue at all. Migrate_swap deals correctly with of those cases.

Tested-by: Joe Mario <jmario@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: hannes@cmpxchg.org
Cc: aarcange@redhat.com
Cc: srikar@linux.vnet.ibm.com
Cc: tglx@linutronix.de
Cc: hpa@zytor.com
Link: http://lkml.kernel.org/r/20131010181722.GO13848@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |  4 ++++
 kernel/sched/fair.c  |  9 ---------
 kernel/sched/sched.h | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c3feeb..a972acd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1049,6 +1049,8 @@ static int migrate_swap_stop(void *data)
 	src_rq = cpu_rq(arg->src_cpu);
 	dst_rq = cpu_rq(arg->dst_cpu);
 
+	double_raw_lock(&arg->src_task->pi_lock,
+			&arg->dst_task->pi_lock);
 	double_rq_lock(src_rq, dst_rq);
 	if (task_cpu(arg->dst_task) != arg->dst_cpu)
 		goto unlock;
@@ -1069,6 +1071,8 @@ static int migrate_swap_stop(void *data)
 
 unlock:
 	double_rq_unlock(src_rq, dst_rq);
+	raw_spin_unlock(&arg->dst_task->pi_lock);
+	raw_spin_unlock(&arg->src_task->pi_lock);
 
 	return ret;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4aa0b10..813dd61 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1448,15 +1448,6 @@ static inline void put_numa_group(struct numa_group *grp)
 		kfree_rcu(grp, rcu);
 }
 
-static void double_lock(spinlock_t *l1, spinlock_t *l2)
-{
-	if (l1 > l2)
-		swap(l1, l2);
-
-	spin_lock(l1);
-	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
-}
-
 static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 			int *priv)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d69cb32..ffc7087 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1249,6 +1249,24 @@ static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
 }
 
+static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	spin_lock(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
+static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	raw_spin_lock(l1);
+	raw_spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
 /*
  * double_rq_lock - safely lock two runqueues
  *
