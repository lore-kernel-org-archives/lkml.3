Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaLMQdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:33:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51712 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaLMQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:33:36 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548C6A54.2020807@jp.fujitsu.com>
Date: Sun, 14 Dec 2014 01:33:24 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: [PATCH 2/4] workqueue: add warning if pool->node is offline
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com>
In-Reply-To: <548C68DA.20507@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add warning if pool->node is offline.

This patch was originaly made for debug.
I think add warning here can show what may happen.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/workqueue.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f6cb357c..35f4f00 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -760,6 +760,15 @@ static bool too_many_workers(struct worker_pool *pool)
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
 
+/* Check pool->node */
+static int pool_to_node(struct worker_pool *pool)
+{
+	if (WARN_ON_ONCE(pool->node != NUMA_NO_NODE
+                         && !node_online(pool->node)))
+		return NUMA_NO_NODE;
+	return pool->node;
+}
+
 /*
  * Wake up functions.
  */
@@ -1679,7 +1688,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (id < 0)
 		goto fail;
 
-	worker = alloc_worker(pool->node);
+	worker = alloc_worker(pool_to_node(pool));
 	if (!worker)
 		goto fail;
 
@@ -1692,7 +1701,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	else
 		snprintf(id_buf, sizeof(id_buf), "u%d:%d", pool->id, id);
 
-	worker->task = kthread_create_on_node(worker_thread, worker, pool->node,
+	worker->task = kthread_create_on_node(worker_thread, worker,
+					      pool_to_node(pool),
 					      "kworker/%s", id_buf);
 	if (IS_ERR(worker->task))
 		goto fail;
@@ -3651,7 +3661,7 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 	if (!pool)
 		return NULL;
 
-	pwq = kmem_cache_alloc_node(pwq_cache, GFP_KERNEL, pool->node);
+	pwq = kmem_cache_alloc_node(pwq_cache, GFP_KERNEL, pool_to_node(pool));
 	if (!pwq) {
 		put_unbound_pool(pool);
 		return NULL;
-- 
1.8.3.1



