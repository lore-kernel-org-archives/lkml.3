Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3I2TrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:47:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab3I2T2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [ 10/71] sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones
Date: Sun, 29 Sep 2013 12:27:22 -0700
Message-Id: <20130929192644.242170522@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

commit 6c9a27f5da9609fca46cb2b183724531b48f71ad upstream.

There is a small race between copy_process() and cgroup_attach_task()
where child->se.parent,cfs_rq points to invalid (old) ones.

        parent doing fork()      | someone moving the parent to another cgroup
  -------------------------------+---------------------------------------------
    copy_process()
      + dup_task_struct()
        -> parent->se is copied to child->se.
           se.parent,cfs_rq of them point to old ones.

                                     cgroup_attach_task()
                                       + cgroup_task_migrate()
                                         -> parent->cgroup is updated.
                                       + cpu_cgroup_attach()
                                         + sched_move_task()
                                           + task_move_group_fair()
                                             +- set_task_rq()
                                                -> se.parent,cfs_rq of parent
                                                   are updated.

      + cgroup_fork()
        -> parent->cgroup is copied to child->cgroup. (*1)
      + sched_fork()
        + task_fork_fair()
          -> se.parent,cfs_rq of child are accessed
             while they point to old ones. (*2)

In the worst case, this bug can lead to "use-after-free" and cause a panic,
because it's new cgroup's refcount that is incremented at (*1),
so the old cgroup(and related data) can be freed before (*2).

In fact, a panic caused by this bug was originally caught in RHEL6.4.

    BUG: unable to handle kernel NULL pointer dereference at (null)
    IP: [<ffffffff81051e3e>] sched_slice+0x6e/0xa0
    [...]
    Call Trace:
     [<ffffffff81051f25>] place_entity+0x75/0xa0
     [<ffffffff81056a3a>] task_fork_fair+0xaa/0x160
     [<ffffffff81063c0b>] sched_fork+0x6b/0x140
     [<ffffffff8106c3c2>] copy_process+0x5b2/0x1450
     [<ffffffff81063b49>] ? wake_up_new_task+0xd9/0x130
     [<ffffffff8106d2f4>] do_fork+0x94/0x460
     [<ffffffff81072a9e>] ? sys_wait4+0xae/0x100
     [<ffffffff81009598>] sys_clone+0x28/0x30
     [<ffffffff8100b393>] stub_clone+0x13/0x20
     [<ffffffff8100b072>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/039601ceae06$733d3130$59b79390$@mxp.nes.nec.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5818,11 +5818,15 @@ static void task_fork_fair(struct task_s
 	cfs_rq = task_cfs_rq(current);
 	curr = cfs_rq->curr;
 
-	if (unlikely(task_cpu(p) != this_cpu)) {
-		rcu_read_lock();
-		__set_task_cpu(p, this_cpu);
-		rcu_read_unlock();
-	}
+	/*
+	 * Not only the cpu but also the task_group of the parent might have
+	 * been changed after parent->se.parent,cfs_rq were copied to
+	 * child->se.parent,cfs_rq. So call __set_task_cpu() to make those
+	 * of child point to valid ones.
+	 */
+	rcu_read_lock();
+	__set_task_cpu(p, this_cpu);
+	rcu_read_unlock();
 
 	update_curr(cfs_rq);
 


