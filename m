Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaJTIz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:55:29 -0400
Received: from relay.parallels.com ([195.214.232.42]:34568 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaJTIzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:55:21 -0400
Message-ID: <1413795316.19914.13.camel@tkhai>
Subject: [PATCH v2] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Mon, 20 Oct 2014 12:55:16 +0400
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

The patch makes 3-stage check of dst_rq->curr; it ensures we've taken
the curr before delayed_put_task_struct() is called to put it. If so,
we may use the cur like we'd taken it from RCU-protected list.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/fair.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..ffc7c3b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1147,6 +1147,44 @@ static bool load_too_imbalanced(long src_load, long dst_load,
 }
 
 /*
+ * Return rq->curr if it is not exiting (delayed_put_task_struct() for it
+ * hasn't been called yet). If result is not NULL, it's safe to use it
+ * like it'd be picked from RCU-protected list (use get_task_struct() etc).
+ */
+static struct task_struct *rq_curr_if_not_exiting(struct rq *rq)
+{
+	struct task_struct *cur = ACCESS_ONCE(rq->curr);
+	unsigned int flags;
+
+	rcu_lockdep_assert(rcu_read_lock_held(), "RCU lock must be held");
+
+	/* This memory may become unmapped, so we can't read it directly */
+	if (probe_kernel_read(&flags, &cur->flags, sizeof(flags)) < 0)
+		return NULL;
+
+	if (flags & PF_EXITING)
+		return NULL;
+
+	smp_rmb(); /* Pairs with smp_mb() in do_exit() */
+
+	/*
+	 * We've reached here. Three situations are possible:
+	 * 1)cur has gone, and dst_rq->curr is pointing to other memory.
+	 *   In this case the check will fail;
+	 * 2)cur is pointing to a new task, which is using the memory of
+	 *   just gone and freed cur (and it is new dst_rq->curr). It is
+	 *   OK, because we've locked RCU even before the new task has been
+	 *   created (so delayed_put_task_struct() hasn't been called yet);
+	 * 3)we've taken a not exiting task (likely case). No need to worry.
+	 *   The above checks are necessary only for this case.
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
@@ -1164,8 +1202,9 @@ static void task_numa_compare(struct task_numa_env *env,
 	long moveimp = imp;
 
 	rcu_read_lock();
-	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+	cur = rq_curr_if_not_exiting(dst_rq);
+
+	if (cur && is_idle_task(cur))
 		cur = NULL;
 
 	/*



