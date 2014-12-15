Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbaLOLW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:22:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42869 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaLOLW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:22:28 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548EC469.7030601@jp.fujitsu.com>
Date: Mon, 15 Dec 2014 20:22:17 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: [PATCH 4/4] workqueue: Handle cpu-node affinity change at CPU_ONLINE.
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548EC1E2.1010101@jp.fujitsu.com>
In-Reply-To: <548EC1E2.1010101@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a corner case fix. In general, cpu-to-node relationship is
fixed when cpu/memory are visible to kernel based on firmware
information. But in some case, cpu-to-node relationship is updated
at CPU_ONLINE.

In arch/x86/mm/numa.c::numa_init_array(), a cpu will be tied to
a random numa node if the node firmware tells is memry-less node.
Such cpu's cpu affinity can be changed in cpu_up().

For example,
  step 1. boot with mem= boot option, hide memory.
  step 2. online hidden memory with using memory hot-add.
  step 3. offline cpus.
  step 4. online cpus.

In step 4, cpu's numa node affinity can be modified if memory-less
node turns out to be an usual node by step 2.

This patch handles the event in CPU_ONLINE callback of workqueue.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/workqueue.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5499b76..cc0e1d4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4583,6 +4583,20 @@ void workqueue_node_register(int node)
 	}
 	mutex_unlock(&wq_pool_mutex);
 }
+/*
+ * When a cpu boot up with a memory less node, the cpu is be tied 
+ * a random node (see arch/x86/mm/numa.c::numa_init_array()).
+ * The relationship is fixed when a proper memory node comes up and
+ * it's visible after CPU_ONLINE. check and reflesh it.
+ */
+void check_reflesh_node_cpumask(int cpu)
+{
+	int node = cpu_to_node(cpu);
+
+	if (likely(cpumask_test_cpu(cpu, wq_numa_possible_cpumask[node])))
+		return;
+	reflesh_wq_possible_mask(cpu, node);
+}
 
 #endif
 
@@ -4617,6 +4631,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 		 */
 		for_each_cpu_worker_pool(pool, cpu)
 			pool->node = cpu_to_node(cpu);
+		check_reflesh_node_cpumask(cpu);
 
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->attach_mutex);
-- 
1.8.3.1



