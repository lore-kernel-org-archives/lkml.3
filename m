Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaJVHRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:17:19 -0400
Received: from relay.parallels.com ([195.214.232.42]:40181 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaJVHRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:17:15 -0400
Message-ID: <1413962231.19914.130.camel@tkhai>
Subject: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Wed, 22 Oct 2014 11:17:11 +0400
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
    ...                                        current->flags |= PF_EXITING;
    ...                                    release_task()
    ...                                        ~~delayed_put_task_struct()~~
    ...                                    schedule()
    rcu_read_lock()                        ...
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

The patch provides simple check of PF_EXITING flag. If it's not set,
this guarantees that call_rcu() of delayed_put_task_struct() callback
hasn't happened yet, so we can safely do get_task_struct() in
task_numa_assign().

Locked dst_rq->lock protects from concurrency with the last schedule().
Reusing or unmapping of cur's memory may happen without it.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/fair.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..fbc0b82 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1164,9 +1164,19 @@ static void task_numa_compare(struct task_numa_env *env,
 	long moveimp = imp;
 
 	rcu_read_lock();
-	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+
+	raw_spin_lock_irq(&dst_rq->lock);
+	cur = dst_rq->curr;
+	/*
+	 * No need to move the exiting task, and this ensures that ->curr
+	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
+	 * is safe under RCU read lock.
+	 * Note that rcu_read_lock() itself can't protect from the final
+	 * put_task_struct() after the last schedule().
+	 */
+	if ((cur->flags & PF_EXITING) || is_idle_task(cur))
 		cur = NULL;
+	raw_spin_unlock_irq(&dst_rq->lock);
 
 	/*
 	 * "imp" is the fault differential for the source task between the



