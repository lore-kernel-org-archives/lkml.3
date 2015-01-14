Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbbANIxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:53:47 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:25445 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756359AbbANIxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:53:44 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56041196"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC PATCH 3/3 shit_B] workqueue: directly update attrs of pools when cpu hot[un]plug
Date: Wed, 14 Jan 2015 16:54:18 +0800
Message-ID: <1421225658-3978-5-git-send-email-laijs@cn.fujitsu.com>
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

If the "attrs" of the per-node pool is allowed to be updated,
we just directly update it and reduce the rebuild overhead and
memory-uasage. But the overhead of set_cpus_allowed_ptr() can not
be reduced yet.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 03ce500..53d2757 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -166,9 +166,10 @@ struct worker_pool {
 
 	struct ida		worker_ida;	/* worker IDs for task name */
 
-	struct workqueue_attrs	*attrs;		/* I: worker attributes */
+	struct workqueue_attrs	*attrs;		/* A: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
 	int			refcnt;		/* PL: refcnt for unbound pools */
+	struct list_head	unbound_pwqs;	/* PL: list of pwq->unbound_pwq */
 
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
@@ -202,6 +203,7 @@ struct pool_workqueue {
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
 	struct list_head	pwqs_node;	/* WR: node on wq->pwqs */
+	struct list_head	unbound_pwq;	/* PL: node on pool->unbound_pwqs */
 	struct list_head	mayday_node;	/* MD: node on wq->maydays */
 
 	/*
@@ -3554,6 +3556,7 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	mutex_unlock(&wq->mutex);
 
 	mutex_lock(&wq_pool_mutex);
+	list_del(&pwq->unbound_pwq);
 	put_unbound_pool(pool);
 	mutex_unlock(&wq_pool_mutex);
 
@@ -3674,6 +3677,7 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 	}
 
 	init_pwq(pwq, wq, pool);
+	list_add(&pwq->unbound_pwq, &pool->unbound_pwqs);
 	return pwq;
 }
 
@@ -3683,6 +3687,7 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
 	lockdep_assert_held(&wq_pool_mutex);
 
 	if (pwq) {
+		list_del(&pwq->unbound_pwq);
 		put_unbound_pool(pwq->pool);
 		kmem_cache_free(pwq_cache, pwq);
 	}
@@ -3869,6 +3874,58 @@ enomem:
 }
 
 /**
+ * pool_update_unbound_numa - update NUMA affinity of a pool for CPU hot[un]plug
+ * @pool: the target pool
+ * @cpu: the CPU coming up or going down
+ * @online: whether @cpu is coming up or going down
+ *
+ * This function is to be called from %CPU_DOWN_PREPARE, %CPU_ONLINE and
+ * %CPU_DOWN_FAILED.  @cpu is being hot[un]plugged, update NUMA affinity of
+ * @pool when allowed.
+ */
+static void pool_update_unbound_numa(struct worker_pool *pool, int cpu, bool online)
+{
+	u32 hash;
+	struct pool_workqueue *pwq;
+	struct worker *worker;
+
+	if (pool->cpu >= 0 || pool->node != cpu_to_node(cpu))
+		return; /* it must not be an unbound pool of the node */
+	if (online && cpumask_test_cpu(cpu, pool->attrs->cpumask))
+		return; /* it already has the online cpu */
+	if (!online && !cpumask_test_cpu(cpu, pool->attrs->cpumask))
+		return; /* it doesn't has the cpu to be removed */
+	if (!online && cpumask_weight(pool->attrs->cpumask) == 1)
+		return; /* the last cpu can't be removed from the pool */
+
+	/* It is called from CPU hot[un]plug, wq->unbound_attrs is stable */
+	list_for_each_entry(pwq, &pool->unbound_pwqs, unbound_pwq) {
+		if (wqattrs_equal(pool->attrs, pwq->wq->unbound_attrs))
+			return; /* the pool serves for at least a default pwq */
+		if (online && !cpumask_test_cpu(cpu, pwq->wq->unbound_attrs->cpumask))
+			return; /* this wq doesn't allow us to add the cpu */
+	}
+
+	/* OK, all pwqs allows us to update the pool directly, let's go */
+	mutex_lock(&pool->attach_mutex);
+	if (online)
+		cpumask_set_cpu(cpu, pool->attrs->cpumask);
+	else
+		cpumask_clear_cpu(cpu, pool->attrs->cpumask);
+
+	/* rehash */
+	hash = wqattrs_hash(pool->attrs);
+	hash_del(&pool->hash_node);
+	hash_add(unbound_pool_hash, &pool->hash_node, hash);
+
+	/* update worker's cpumask */
+	for_each_pool_worker(worker, pool)
+		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
+						  pool->attrs->cpumask) < 0);
+	mutex_unlock(&pool->attach_mutex);
+}
+
+/**
  * wq_update_unbound_numa - update NUMA affinity of a wq for CPU hot[un]plug
  * @wq: the target workqueue
  * @cpu: the CPU coming up or going down
@@ -4598,6 +4655,8 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 				restore_unbound_workers_cpumask(pool, cpu);
 
 			mutex_unlock(&pool->attach_mutex);
+
+			pool_update_unbound_numa(pool, cpu, true);
 		}
 
 		/* update NUMA affinity of unbound workqueues */
@@ -4621,6 +4680,8 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 	int cpu = (unsigned long)hcpu;
 	struct work_struct unbind_work;
 	struct workqueue_struct *wq;
+	struct worker_pool *pool;
+	int pi;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -4628,10 +4689,16 @@ static int workqueue_cpu_down_callback(struct notifier_block *nfb,
 		INIT_WORK_ONSTACK(&unbind_work, wq_unbind_fn);
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 
-		/* update NUMA affinity of unbound workqueues */
 		mutex_lock(&wq_pool_mutex);
+
+		/* try to update NUMA affinity of unbound pool */
+		for_each_pool(pool, pi)
+			pool_update_unbound_numa(pool, cpu, false);
+
+		/* update NUMA affinity of unbound workqueues */
 		list_for_each_entry(wq, &workqueues, list)
 			wq_update_unbound_numa(wq, cpu, false);
+
 		mutex_unlock(&wq_pool_mutex);
 
 		/* wait for per-cpu unbinding to finish */
-- 
2.1.0

