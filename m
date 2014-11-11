Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaKKEjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:39:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:10838 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751545AbaKKEjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:39:04 -0500
Date: Mon, 10 Nov 2014 23:39:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [RFC][PATCH] sched: Protect call to ss->fork() with css_set_rwsem
Message-ID: <20141110233901.7e7a0934@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My tests tripped over the following RCU lockdep splat:

===============================
[ INFO: suspicious RCU usage. ]^M
3.18.0-rc4-test+ #3 Not tainted
-------------------------------
/work/autotest/nobackup/linux-test.git/kernel/sched/core.c:7449 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by swapper/0/0:
 #0:  (&p->pi_lock){......}, at: [<ffffffff8105c470>] task_rq_lock+0x33/0x9b
 #1:  (&rq->lock){-.-...}, at: [<ffffffff8105c48a>] task_rq_lock+0x4d/0x9b

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc4-test+ #3
Hardware name: MSI MS-7823/CSM-H87M-G43 (MS-7823), BIOS V1.6 02/22/2014
 0000000000000001 ffffffff82203cd8 ffffffff81a2bb53 0000000000000de1
 ffffffff822164a0 ffffffff82203d08 ffffffff81075ada ffff880215118000
 ffff88021ea13a00 0000000000000000 0000000000000000 ffffffff82203d58
Call Trace:
 [<ffffffff81a2bb53>] dump_stack+0x46/0x58
 [<ffffffff81075ada>] lockdep_rcu_suspicious+0x107/0x110
 [<ffffffff81064a0e>] sched_move_task+0xdd/0x153
 [<ffffffff81064aab>] cpu_cgroup_fork+0xe/0x10
 [<ffffffff810b3e8b>] cgroup_post_fork+0x83/0xa5
 [<ffffffff8103d69d>] copy_process+0x169b/0x1870
 [<ffffffff81a1f440>] ? rest_init+0x134/0x134
 [<ffffffff81078117>] ? trace_hardirqs_on_caller+0x160/0x197
 [<ffffffff812f84be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8103d995>] do_fork+0x7c/0x23b
 [<ffffffff81a34c63>] ? mutex_unlock+0xe/0x10
 [<ffffffff810d259c>] ? ftrace_process_locs+0x482/0x4cd
 [<ffffffff8105bda9>] ? cpumask_next+0x19/0x1b
 [<ffffffff8103db7a>] kernel_thread+0x26/0x28
 [<ffffffff81a1f332>] rest_init+0x26/0x134
 [<ffffffff823e77eb>] ? ftrace_init+0xad/0x140
 [<ffffffff823c8eab>] start_kernel+0x42c/0x439
 [<ffffffff823c8887>] ? set_init_arg+0x55/0x55
 [<ffffffff823c8491>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff823c8585>] x86_64_start_kernel+0xf2/0xf9

I did a bisect and came across this commit:

Commit eeb61e53ea19 "sched: Fix race between task_group and
sched_task_group".

It added a callback of the fork() method which calls sched_move_task().
But this function does a task_css_check() which expects to have one of
these locks held: cgroup_mutex, css_set_rwsem, or siglock (for this
case), or at least have the task exiting.

By moving the taking of the css_set_rwsem semaphore out to include the
call to ss->fork(), it quiets this warning.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

I'm not sure this is the correct fix, but it "works for me".

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 136eceadeed1..a08ad94d62cf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5150,17 +5150,16 @@ void cgroup_post_fork(struct task_struct *child)
 	 * in the init_css_set before cg_links is enabled and there's no
 	 * operation which transfers all tasks out of init_css_set.
 	 */
+	down_write(&css_set_rwsem);
 	if (use_task_css_set_links) {
 		struct css_set *cset;
 
-		down_write(&css_set_rwsem);
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			rcu_assign_pointer(child->cgroups, cset);
 			list_add(&child->cg_list, &cset->tasks);
 			get_css_set(cset);
 		}
-		up_write(&css_set_rwsem);
 	}
 
 	/*
@@ -5173,6 +5172,7 @@ void cgroup_post_fork(struct task_struct *child)
 			if (ss->fork)
 				ss->fork(child);
 	}
+	up_write(&css_set_rwsem);
 }
 
 /**
