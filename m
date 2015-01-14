Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbbANIy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:54:56 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:12615 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756344AbbANIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:53:40 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56041183"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC PATCH 1/2 shit_A shit_B] workqueue: reset pool->node and unhash the pool when the node is offline
Date: Wed, 14 Jan 2015 16:54:15 +0800
Message-ID: <1421225658-3978-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
References: <54B5D8B4.7010708@cn.fujitsu.com>
 <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6202b08..19bca3e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -36,6 +36,7 @@
 #include <linux/notifier.h>
 #include <linux/kthread.h>
 #include <linux/hardirq.h>
+#include <linux/memory.h>
 #include <linux/mempolicy.h>
 #include <linux/freezer.h>
 #include <linux/kallsyms.h>
@@ -4573,6 +4574,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       void *hcpu)
 {
 	int cpu = (unsigned long)hcpu;
+	int node = cpu_to_node(cpu);
 	struct worker_pool *pool;
 	struct workqueue_struct *wq;
 	int pi;
@@ -4580,6 +4582,7 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		for_each_cpu_worker_pool(pool, cpu) {
+			pool->node = node;
 			if (pool->nr_workers)
 				continue;
 			if (!create_worker(pool))
@@ -4796,6 +4799,33 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */
 
+static int wq_numa_callback(struct notifier_block *self,
+			    unsigned long action, void *arg)
+{
+	struct memory_notify *marg = arg;
+	int node = marg->status_change_nid_normal;
+	struct worker_pool *pool;
+	int pi;
+
+	switch (action) {
+	case MEM_GOING_ONLINE:
+		mutex_lock(&wq_pool_mutex);
+		for_each_pool(pool, pi) {
+			if (pool->node == node) {
+				pool->node = NUMA_NO_NODE;
+				if (pool->cpu < 0)
+					hash_del(&pool->hash_node);
+			}
+		}
+		mutex_unlock(&wq_pool_mutex);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static void __init wq_numa_init(void)
 {
 	cpumask_var_t *tbl;
@@ -4835,6 +4865,7 @@ static void __init wq_numa_init(void)
 	}
 
 	wq_numa_possible_cpumask = tbl;
+	hotplug_memory_notifier(wq_numa_callback, 0);
 	wq_numa_enabled = true;
 }
 
-- 
2.1.0

