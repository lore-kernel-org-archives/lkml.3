Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3JJSRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:17:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3JJSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:17:34 -0400
Date: Thu, 10 Oct 2013 20:17:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, riel@redhat.com, aarcange@redhat.com,
        srikar@linux.vnet.ibm.com, mgorman@suse.de, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/numa: Introduce migrate_swap()
Message-ID: <20131010181722.GO13848@laptop.programming.kicks-ass.net>
References: <1381141781-10992-39-git-send-email-mgorman@suse.de>
 <tip-ac66f5477239ebd3c4e2cbf2f591ef387aa09884@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ac66f5477239ebd3c4e2cbf2f591ef387aa09884@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 10:30:13AM -0700, tip-bot for Peter Zijlstra wrote:
> sched/numa: Introduce migrate_swap()

Thanks to Rik for writing the Changelog!

---
From: Peter Zijlstra <peterz@infradead.org>
Subject: sched: Fix race in migrate_swap_stop

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

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Joe Mario <jmario@redhat.com>
---
 kernel/sched/core.c  |  4 ++++
 kernel/sched/fair.c  |  9 ---------
 kernel/sched/sched.h | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0c3feebcf112..a972acd468b0 100644
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
index 803e343d7c89..a60d57c5379a 100644
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
index d69cb325c27e..ffc708717b70 100644
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
