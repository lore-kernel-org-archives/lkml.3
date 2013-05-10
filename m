Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3EJSVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:21:17 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:42161 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3EJSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:21:15 -0400
Date: Fri, 10 May 2013 11:21:10 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH wq/for-3.10-fixes] workqueue: workqueue_congested() shouldn't
 translate WORK_CPU_UNBOUND into node number
Message-ID: <20130510182110.GB15502@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d3251859168b0b12841e1b90d6d768ab478dc23d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 10 May 2013 11:10:17 -0700

df2d5ae499 ("workqueue: map an unbound workqueues to multiple per-node
pool_workqueues") made unbound workqueues to map to multiple per-node
pool_workqueues and accordingly updated workqueue_contested() so that,
for unbound workqueues, it maps the specified @cpu to the NUMA node
number to obtain the matching pool_workqueue to query the congested
state.

Before this change, workqueue_congested() ignored @cpu for unbound
workqueues as there was only one pool_workqueue and some users
(fscache) called it with WORK_CPU_UNBOUND.  After the commit, this
causes the following oops as WORK_CPU_UNBOUND gets translated to
garbage by cpu_to_node().

  BUG: unable to handle kernel paging request at ffff8803598d98b8
  IP: [<ffffffff81043b7e>] unbound_pwq_by_node+0xa1/0xfa
  PGD 2421067 PUD 0
  Oops: 0000 [#1] SMP
  CPU: 1 PID: 2689 Comm: cat Tainted: GF            3.9.0-fsdevel+ #4
  task: ffff88003d801040 ti: ffff880025806000 task.ti: ffff880025806000
  RIP: 0010:[<ffffffff81043b7e>]  [<ffffffff81043b7e>] unbound_pwq_by_node+0xa1/0xfa
  RSP: 0018:ffff880025807ad8  EFLAGS: 00010202
  RAX: 0000000000000001 RBX: ffff8800388a2400 RCX: 0000000000000003
  RDX: ffff880025807fd8 RSI: ffffffff81a31420 RDI: ffff88003d8016e0
  RBP: ffff880025807ae8 R08: ffff88003d801730 R09: ffffffffa00b4898
  R10: ffffffff81044217 R11: ffff88003d801040 R12: 0000000064206e97
  R13: ffff880036059d98 R14: ffff880038cc8080 R15: ffff880038cc82d0
  FS:  00007f21afd9c740(0000) GS:ffff88003d100000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: ffff8803598d98b8 CR3: 000000003df49000 CR4: 00000000000007e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Stack:
   ffff8800388a2400 0000000000000002 ffff880025807b18 ffffffff810442ce
   ffffffff81044217 ffff880000000002 ffff8800371b4080 ffff88003d112ec0
   ffff880025807b38 ffffffffa00810b0 ffff880036059d88 ffff880036059be8
  Call Trace:
   [<ffffffff810442ce>] workqueue_congested+0xb7/0x12c
   [<ffffffffa00810b0>] fscache_enqueue_object+0xb2/0xe8 [fscache]
   [<ffffffffa007facd>] __fscache_acquire_cookie+0x3b9/0x56c [fscache]
   [<ffffffffa00ad8fe>] nfs_fscache_set_inode_cookie+0xee/0x132 [nfs]
   [<ffffffffa009e112>] do_open+0x9/0xd [nfs]
   [<ffffffff810e804a>] do_dentry_open+0x175/0x24b
   [<ffffffff810e8298>] finish_open+0x41/0x51

Fix it by using smp_processor_id() if @cpu is WORK_CPU_UNBOUND.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Howells <dhowells@redhat.com>
Tested-and-Acked-by: David Howells <dhowells@redhat.com>
---
 kernel/workqueue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4aa9f5b..1ae6028 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4311,6 +4311,12 @@ bool current_is_workqueue_rescuer(void)
  * no synchronization around this function and the test result is
  * unreliable and only useful as advisory hints or for debugging.
  *
+ * If @cpu is WORK_CPU_UNBOUND, the test is performed on the local CPU.
+ * Note that both per-cpu and unbound workqueues may be associated with
+ * multiple pool_workqueues which have separate congested states.  A
+ * workqueue being congested on one CPU doesn't mean the workqueue is also
+ * contested on other CPUs / NUMA nodes.
+ *
  * RETURNS:
  * %true if congested, %false otherwise.
  */
@@ -4321,6 +4327,9 @@ bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 
 	rcu_read_lock_sched();
 
+	if (cpu == WORK_CPU_UNBOUND)
+		cpu = smp_processor_id();
+
 	if (!(wq->flags & WQ_UNBOUND))
 		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
 	else
-- 
1.8.1.4

