Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbaGXJ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:56:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbaGXJtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/128] workqueue: zero cpumask of wq_numa_possible_cpumask on init
Date: Thu, 24 Jul 2014 10:45:57 +0100
Message-Id: <1406195177-8656-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

commit 5a6024f1604eef119cf3a6fa413fe0261a81a8f3 upstream.

When hot-adding and onlining CPU, kernel panic occurs, showing following
call trace.

  BUG: unable to handle kernel paging request at 0000000000001d08
  IP: [<ffffffff8114acfd>] __alloc_pages_nodemask+0x9d/0xb10
  PGD 0
  Oops: 0000 [#1] SMP
  ...
  Call Trace:
   [<ffffffff812b8745>] ? cpumask_next_and+0x35/0x50
   [<ffffffff810a3283>] ? find_busiest_group+0x113/0x8f0
   [<ffffffff81193bc9>] ? deactivate_slab+0x349/0x3c0
   [<ffffffff811926f1>] new_slab+0x91/0x300
   [<ffffffff815de95a>] __slab_alloc+0x2bb/0x482
   [<ffffffff8105bc1c>] ? copy_process.part.25+0xfc/0x14c0
   [<ffffffff810a3c78>] ? load_balance+0x218/0x890
   [<ffffffff8101a679>] ? sched_clock+0x9/0x10
   [<ffffffff81105ba9>] ? trace_clock_local+0x9/0x10
   [<ffffffff81193d1c>] kmem_cache_alloc_node+0x8c/0x200
   [<ffffffff8105bc1c>] copy_process.part.25+0xfc/0x14c0
   [<ffffffff81114d0d>] ? trace_buffer_unlock_commit+0x4d/0x60
   [<ffffffff81085a80>] ? kthread_create_on_node+0x140/0x140
   [<ffffffff8105d0ec>] do_fork+0xbc/0x360
   [<ffffffff8105d3b6>] kernel_thread+0x26/0x30
   [<ffffffff81086652>] kthreadd+0x2c2/0x300
   [<ffffffff81086390>] ? kthread_create_on_cpu+0x60/0x60
   [<ffffffff815f20ec>] ret_from_fork+0x7c/0xb0
   [<ffffffff81086390>] ? kthread_create_on_cpu+0x60/0x60

In my investigation, I found the root cause is wq_numa_possible_cpumask.
All entries of wq_numa_possible_cpumask is allocated by
alloc_cpumask_var_node(). And these entries are used without initializing.
So these entries have wrong value.

When hot-adding and onlining CPU, wq_update_unbound_numa() is called.
wq_update_unbound_numa() calls alloc_unbound_pwq(). And alloc_unbound_pwq()
calls get_unbound_pool(). In get_unbound_pool(), worker_pool->node is set
as follow:

3592         /* if cpumask is contained inside a NUMA node, we belong to that node */
3593         if (wq_numa_enabled) {
3594                 for_each_node(node) {
3595                         if (cpumask_subset(pool->attrs->cpumask,
3596                                            wq_numa_possible_cpumask[node])) {
3597                                 pool->node = node;
3598                                 break;
3599                         }
3600                 }
3601         }

But wq_numa_possible_cpumask[node] does not have correct cpumask. So, wrong
node is selected. As a result, kernel panic occurs.

By this patch, all entries of wq_numa_possible_cpumask are allocated by
zalloc_cpumask_var_node to initialize them. And the panic disappeared.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: bce903809ab3 ("workqueue: add wq_numa_tbl_len and wq_numa_possible_cpumask[]")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ac1336d91ba1..7ae565366ba9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4997,7 +4997,7 @@ static void __init wq_numa_init(void)
 	BUG_ON(!tbl);
 
 	for_each_node(node)
-		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
+		BUG_ON(!zalloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
 				node_online(node) ? node : NUMA_NO_NODE));
 
 	for_each_possible_cpu(cpu) {
-- 
1.9.1

