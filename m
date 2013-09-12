Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3ILSJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:09:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3ILSFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:05:30 -0400
Date: Thu, 12 Sep 2013 11:04:54 -0700
From: tip-bot for Daisuke Nishimura <tipbot@zytor.com>
Message-ID: <tip-6c9a27f5da9609fca46cb2b183724531b48f71ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de,
        nishimura@mxp.nes.nec.co.jp
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, stable@vger.kernel.org,
        nishimura@mxp.nes.nec.co.jp
In-Reply-To: <039601ceae06$733d3130$59b79390$@mxp.nes.nec.co.jp>
References: <039601ceae06$733d3130$59b79390$@mxp.nes.nec.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix small race where child->
 se.parent,cfs_rq might point to invalid ones
Git-Commit-ID: 6c9a27f5da9609fca46cb2b183724531b48f71ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:05:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c9a27f5da9609fca46cb2b183724531b48f71ad
Gitweb:     http://git.kernel.org/tip/6c9a27f5da9609fca46cb2b183724531b48f71ad
Author:     Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
AuthorDate: Tue, 10 Sep 2013 18:16:36 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:14 +0200

sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/039601ceae06$733d3130$59b79390$@mxp.nes.nec.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b3fe1c..11cd136 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5928,11 +5928,15 @@ static void task_fork_fair(struct task_struct *p)
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
 
