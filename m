Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaLOLRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:17:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43784 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaLOLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:17:01 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548EC320.3060206@jp.fujitsu.com>
Date: Mon, 15 Dec 2014 20:16:48 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: [PATCH 2/4] workqueue: update per-cpu workqueue's node affinity at,online-offline
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548EC1E2.1010101@jp.fujitsu.com>
In-Reply-To: <548EC1E2.1010101@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu workqueue pool are persistend and never be freed.
But cpu<->node relationship can be changed by cpu hotplug and pool->node
can point to an offlined node.

If pool->node points to an offlined node,
following allocation failure can happen.
    ==
     SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
      cache: kmalloc-192, object size: 192, buffer size: 192, default
order:
    1, min order: 0
      node 0: slabs: 6172, objs: 259224, free: 245741
      node 1: slabs: 3261, objs: 136962, free: 127656
    ==

This patch clears per-cpu workqueue pool's node affinity at
cpu offlining and restore it at cpu onlining.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/workqueue.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7809154..2fd0bd7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4586,6 +4586,11 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
 		mutex_lock(&wq_pool_mutex);
+		/*
+		 * now cpu <-> node info is established. update numa node
+		 */
+		for_each_cpu_worker_pool(pool, cpu)
+			pool->node = cpu_to_node(cpu);
 
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->attach_mutex);
@@ -4619,6 +4624,7 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 	int cpu = (unsigned long)hcpu;
 	struct work_struct unbind_work;
 	struct workqueue_struct *wq;
+	struct worker_pool *pool;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -4626,10 +4632,13 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 		INIT_WORK_ONSTACK(&unbind_work, wq_unbind_fn);
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 
-		/* update NUMA affinity of unbound workqueues */
 		mutex_lock(&wq_pool_mutex);
+		/* update NUMA affinity of unbound workqueues */
 		list_for_each_entry(wq, &workqueues, list)
 			wq_update_unbound_numa(wq, cpu, false);
+		/* clear per-cpu workqueues's numa affinity. */
+		for_each_cpu_worker_pool(pool, cpu)
+			pool->node = NUMA_NO_NODE; /* restored at online */
 		mutex_unlock(&wq_pool_mutex);
 
 		/* wait for per-cpu unbinding to finish */
-- 
1.8.3.1




