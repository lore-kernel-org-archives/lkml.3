Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaJ1LDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:03:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJ1LDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:03:16 -0400
Date: Tue, 28 Oct 2014 04:02:22 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-1effd9f19324efb05fccc7421530e11a52db0278@git.kernel.org>
Cc: ktkhai@parallels.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, oleg@redhat.com, mingo@kernel.org,
        torvalds@linux-foundation.org
Reply-To: linux-kernel@vger.kernel.org, peterz@infradead.org,
        ktkhai@parallels.com, torvalds@linux-foundation.org, mingo@kernel.org,
        oleg@redhat.com, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1413962231.19914.130.camel@tkhai>
References: <1413962231.19914.130.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix unsafe get_task_struct()
  in task_numa_assign()
Git-Commit-ID: 1effd9f19324efb05fccc7421530e11a52db0278
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

Commit-ID:  1effd9f19324efb05fccc7421530e11a52db0278
Gitweb:     http://git.kernel.org/tip/1effd9f19324efb05fccc7421530e11a52db0278
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 22 Oct 2014 11:17:11 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:02 +0100

sched/numa: Fix unsafe get_task_struct() in task_numa_assign()

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

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413962231.19914.130.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 14 ++++++++++++--
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
