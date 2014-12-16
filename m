Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaLPQv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:51:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47984 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaLPQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:51:55 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <5490631C.1010309@jp.fujitsu.com>
Date: Wed, 17 Dec 2014 01:51:40 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: =?ISO-2022-JP?B?IklzaGltYXRzdSwgWWFzdWFraS8bJEJAUD4+GyhCIBskQkx3Pk8bKEI=?=
	 =?ISO-2022-JP?B?Ig==?= <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] workqueue: update cpumask at CPU_ONLINE if necessary
References: <54905F87.2030302@jp.fujitsu.com>
In-Reply-To: <54905F87.2030302@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some case, cpu's numa affinity will be changed in cpu_up().
It happens after a new node is onlined.
(in x86, online cpus are tied to onlined node at boot.
 so, if memory is added later, cpu mapping can be changed at cpu_up()

Although wq_numa_possible_cpumask at el. are maintained against
node hotplug, this case should be handled.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/workqueue.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f6ad05a..59d8be5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4618,6 +4618,27 @@ void workqueue_node_unregister(int node)
 	mutex_unlock(&wq_pool_mutex);
 }
 
+static void workqueue_may_update_numa_affinity(int cpu)
+{
+	int curnode = cpu_to_node(cpu);
+	int node;
+
+	if (likely(cpumask_test_cpu(cpu, wq_numa_possible_cpumask[curnode])))
+		return;
+
+	/* cpu<->node relationship is changed in cpu_up() */
+	for_each_node_state(node, N_POSSIBLE)
+		cpumask_clear_cpu(cpu, wq_numa_possible_cpumask[node]);
+
+	workqueue_update_cpu_numa_affinity(cpu, curnode);
+}
+#else
+
+static void workqueue_may_update_numa_affinity(int cpu)
+{
+	return;
+}
+
 #endif
 
 /*
@@ -4647,6 +4668,8 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 	case CPU_ONLINE:
 		mutex_lock(&wq_pool_mutex);
 
+		workqueue_may_update_numa_affinity(cpu);
+
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->attach_mutex);
 
-- 
1.8.3.1



