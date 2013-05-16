Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3EPSbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:31:17 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:49417 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3EPSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:31:15 -0400
Date: Thu, 16 May 2013 11:31:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] more workqueue fixes for v3.10-rc1
Message-ID: <20130516183110.GE7171@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Three more workqueue regression fixes.

* Fix unbalanced unlock in trylock failure path of manage_workers().
  This shouldn't happen often in the wild but is possible.

* While making schedule_work() and friends inline, they become
  unavailable to !GPL modules.  Allow !GPL modules to access basic
  stuff - system_wq and queue_*work_on() - so that schedule_work() and
  friends can be used.

* During boot, the unbound NUMA support code allocates a cpumask for
  each possible node using alloc_cpumask_var_node(), which ends up
  trying to allocate node-specific memory even for offline nodes
  triggering BUG in the memory alloc code.  Use NUMA_NO_NODE for
  offline nodes.

The above three fixes are available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-fixes

for you to fetch changes up to 1be0c25da56e860992af972a60321563ca2cfcd1:

  workqueue: don't perform NUMA-aware allocations on offline nodes in wq_numa_init() (2013-05-15 14:24:24 -0700)

Thanks.

----------------------------------------------------------------
Joonsoo Kim (1):
      workqueue: correct handling of the pool spin_lock

Marc Dionne (1):
      workqueue: Make schedule_work() available again to non GPL modules

Tejun Heo (1):
      workqueue: don't perform NUMA-aware allocations on offline nodes in wq_numa_init()

 kernel/workqueue.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ae6028..ee8e29a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -296,7 +296,7 @@ static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
 
 struct workqueue_struct *system_wq __read_mostly;
-EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_highpri_wq);
 struct workqueue_struct *system_long_wq __read_mostly;
@@ -1411,7 +1411,7 @@ bool queue_work_on(int cpu, struct workqueue_struct *wq,
 	local_irq_restore(flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(queue_work_on);
+EXPORT_SYMBOL(queue_work_on);
 
 void delayed_work_timer_fn(unsigned long __data)
 {
@@ -1485,7 +1485,7 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	local_irq_restore(flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(queue_delayed_work_on);
+EXPORT_SYMBOL(queue_delayed_work_on);
 
 /**
  * mod_delayed_work_on - modify delay of or queue a delayed work on specific CPU
@@ -2059,6 +2059,7 @@ static bool manage_workers(struct worker *worker)
 	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
 		spin_unlock_irq(&pool->lock);
 		mutex_lock(&pool->manager_mutex);
+		spin_lock_irq(&pool->lock);
 		ret = true;
 	}
 
@@ -4904,7 +4905,8 @@ static void __init wq_numa_init(void)
 	BUG_ON(!tbl);
 
 	for_each_node(node)
-		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL, node));
+		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
+				node_online(node) ? node : NUMA_NO_NODE));
 
 	for_each_possible_cpu(cpu) {
 		node = cpu_to_node(cpu);
