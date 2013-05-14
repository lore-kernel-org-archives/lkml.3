Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3ENP6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:58:16 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:45091 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab3ENP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:58:15 -0400
Date: Tue, 14 May 2013 08:58:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        dirk@gouders.net, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue fixes for v3.10-rc1
Message-ID: <20130514155810.GF6795@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive a fix for
workqueue_congested() regression which broke fscache.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-fixes

Thanks.

  workqueue: workqueue_congested() shouldn't translate WORK_CPU_UNBOUND into node number (2013-05-10 11:10:17 -0700)

----------------------------------------------------------------
Tejun Heo (1):
      workqueue: workqueue_congested() shouldn't translate WORK_CPU_UNBOUND into node number

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
