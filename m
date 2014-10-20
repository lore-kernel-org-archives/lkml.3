Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaJTKPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:15:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:48710 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbaJTKPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:15:51 -0400
Message-ID: <1413800145.19914.23.camel@tkhai>
Subject: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Mon, 20 Oct 2014 14:15:45 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unlocked access to dst_rq->curr in task_numa_compare() is racy.
If curr task is exiting this may be a reason of use-after-free:

task_numa_compare()                    do_exit()
    rcu_read_lock()                        schedule()
    cur = ACCESS_ONCE(dst_rq->curr)        ...
        ...                                rq->curr = next;
        ...                                    context_switch()
        ...                                        finish_task_switch()
        ...                                            put_task_struct()
        ...                                                __put_task_struct()
        ...                                                    free_task_struct()
        task_numa_assign()                                     ...
            get_task_struct()                                  ...

As noted by Oleg:

  <<The lockless get_task_struct(tsk) is only safe if tsk == current
    and didn't pass exit_notify(), or if this tsk was found on a rcu
    protected list (say, for_each_process() or find_task_by_vpid()).
    IOW, it is only safe if release_task() was not called before we
    take rcu_read_lock(), in this case we can rely on the fact that
    delayed_put_pid() can not drop the (potentially) last reference
    until rcu_read_unlock().

    And as Kirill pointed out task_numa_compare()->task_numa_assign()
    path does get_task_struct(dst_rq->curr) and this is not safe. The
    task_struct itself can't go away, but rcu_read_lock() can't save
    us from the final put_task_struct() in finish_task_switch(); this
    reference goes away without rcu gp>>

The patch adds SLAB_DESTROY_BY_RCU flag to task_struct allocation
cache options. This guarantees that dst_rq->curr memory can't become
unmapped during RCU gp, and we may safely directly read it.

Also it adds rq_curr_if_not_exiting() function, which returns dst->curr
(at time of call) only if delayed_put_task_struct() callback hasn't
been called for its task_struct yet. This means the returned memory
is still a task while we are under RCU lock (and its task_struct::usage
is not zero), so we can safely use {get,put}_task_struct() to manipulate
with it.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c       |    9 +++++++--
 kernel/sched/fair.c |   38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 9b7d746..72b5e73 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -259,10 +259,15 @@ void __init fork_init(unsigned long mempages)
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif
-	/* create a slab on which task_structs can be allocated */
+	/*
+	 * Create a slab on which task_structs can be allocated.
+	 * Note, we need SLAB_DESTROY_BY_RCU flag, when we access
+	 * rq::curr under RCU read lock. See scheduler code.
+	 */
 	task_struct_cachep =
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
+			ARCH_MIN_TASKALIGN,
+			SLAB_PANIC | SLAB_NOTRACK | SLAB_DESTROY_BY_RCU, NULL);
 #endif
 
 	/* do the arch specific task caches init */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..d2d1625 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1147,6 +1147,39 @@ static bool load_too_imbalanced(long src_load, long dst_load,
 }
 
 /*
+ * Return rq->curr if delayed_put_task_struct() callback hasn't
+ * been called for its task_struct yet).
+ *
+ * If result is not NULL, it is safe to use it like it'd be
+ * picked from RCU-protected list (use get_task_struct() etc).
+ */
+static struct task_struct *rq_curr_if_not_put(struct rq *rq)
+{
+	struct task_struct *cur = ACCESS_ONCE(rq->curr);
+
+	rcu_lockdep_assert(rcu_read_lock_held(), "RCU lock must be held");
+
+	if (cur->flags & PF_EXITING)
+		return NULL;
+
+	smp_rmb(); /* Pairs with smp_mb() in do_exit() */
+
+	/*
+	 * We've reached here. Three situations are possible:
+	 * 1)cur has gone, and dst_rq->curr is pointing to other memory.
+	 * 2)cur is pointing to a new task, which is using the memory of
+	 *   just gone and freed cur (and it is new dst_rq->curr). It is
+	 *   OK, because we've locked RCU even before the new task has been
+	 *   created (so delayed_put_task_struct() hasn't been called yet);
+	 * 3)we've taken a not exiting task (likely case). No need to worry.
+	 */
+	if (cur != ACCESS_ONCE(rq->curr))
+		cur = NULL;
+
+	return cur;
+}
+
+/*
  * This checks if the overall compute and NUMA accesses of the system would
  * be improved if the source tasks was migrated to the target dst_cpu taking
  * into account that it might be best if task running on the dst_cpu should
@@ -1164,8 +1197,9 @@ static void task_numa_compare(struct task_numa_env *env,
 	long moveimp = imp;
 
 	rcu_read_lock();
-	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+	cur = rq_curr_if_not_put(dst_rq);
+
+	if (cur && is_idle_task(cur))
 		cur = NULL;
 
 	/*



