Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab3DDCHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:07:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36933 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab3DDCGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:06:01 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998074"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/7] workqueue: node-awared allocation for unbound pool
Date: Thu, 4 Apr 2013 10:05:37 +0800
Message-Id: <1365041143-3088-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:05:00,
	Serialize complete at 2013/04/04 10:05:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calculate the node of the pool earlier, and allocate the pool
from the node.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 737646d..3f33077 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -539,7 +539,7 @@ static int worker_pool_assign_id(struct worker_pool *pool)
  * @wq: the target workqueue
  * @node: the node ID
  *
- * This must be called either with pwq_lock held or sched RCU read locked.
+ * This must be called either with wq->mutex held or sched RCU read locked.
  * If the pwq needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pwq stays online.
  */
@@ -3555,7 +3555,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
-	int node;
+	int pool_node = NUMA_NO_NODE, node;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
@@ -3563,29 +3563,30 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
 		if (wqattrs_equal(pool->attrs, attrs)) {
 			pool->refcnt++;
-			goto out_unlock;
+			goto out_pool;
 		}
 	}
 
-	/* nope, create a new one */
-	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-	if (!pool || init_worker_pool(pool) < 0)
-		goto fail;
-
-	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
-	copy_workqueue_attrs(pool->attrs, attrs);
-
 	/* if cpumask is contained inside a NUMA node, we belong to that node */
 	if (wq_numa_enabled) {
 		for_each_node(node) {
-			if (cpumask_subset(pool->attrs->cpumask,
+			if (cpumask_subset(attrs->cpumask,
 					   wq_numa_possible_cpumask[node])) {
-				pool->node = node;
+				pool_node = node;
 				break;
 			}
 		}
 	}
 
+	/* create a new one */
+	pool = kzalloc_node(sizeof(*pool), GFP_KERNEL, pool_node);
+	if (!pool || init_worker_pool(pool) < 0)
+		goto fail;
+
+	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
+	copy_workqueue_attrs(pool->attrs, attrs);
+	pool->node = pool_node;
+
 	if (worker_pool_assign_id(pool) < 0)
 		goto fail;
 
@@ -3595,7 +3596,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 
 	/* install */
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
-out_unlock:
+out_pool:
 	return pool;
 fail:
 	if (pool)
-- 
1.7.7.6

