Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3BRQN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:13:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3BRQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:13:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724943"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 04/15] workqueue: add worker's global worker ID
Date: Tue, 19 Feb 2013 00:12:05 +0800
Message-Id: <1361203940-6300-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:19,
	Serialize complete at 2013/02/19 00:13:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new worker->id which is allocated from worker_idr.  This
will be used to record the last running worker in work->data.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   28 ++++++++++++++++++++++++++++
 kernel/workqueue_internal.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 764ad45..5502188 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -435,6 +435,10 @@ static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
 static DEFINE_MUTEX(worker_pool_idr_mutex);
 static DEFINE_IDR(worker_pool_idr);
 
+/* idr of all workers */
+static DEFINE_MUTEX(worker_idr_mutex);
+static DEFINE_IDR(worker_idr);
+
 static int worker_thread(void *__worker);
 
 static struct worker_pool *std_worker_pools(int cpu)
@@ -450,6 +454,26 @@ static int std_worker_pool_pri(struct worker_pool *pool)
 	return pool - std_worker_pools(pool->cpu);
 }
 
+/* allocate ID and assign it to @worker */
+static int worker_assign_id(struct worker *worker)
+{
+	int ret;
+
+	mutex_lock(&worker_idr_mutex);
+	idr_pre_get(&worker_idr, GFP_KERNEL);
+	ret = idr_get_new(&worker_idr, worker, &worker->id);
+	mutex_unlock(&worker_idr_mutex);
+
+	return ret;
+}
+
+static void free_worker_id(struct worker *worker)
+{
+	mutex_lock(&worker_idr_mutex);
+	idr_remove(&worker_idr, worker->id);
+	mutex_unlock(&worker_idr_mutex);
+}
+
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
@@ -1740,6 +1764,9 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->pool = pool;
 	worker->id_in_pool = id_in_pool;
 
+	if (worker_assign_id(worker))
+		goto fail;
+
 	if (pool->cpu != WORK_CPU_UNBOUND)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(pool->cpu),
@@ -1828,6 +1855,7 @@ static void destroy_worker(struct worker *worker)
 	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
+	free_worker_id(worker);
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index e6afb59..3694bc1 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -36,6 +36,7 @@ struct worker {
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id_in_pool;	/* I: worker id in the pool */
+	int			id;		/* I: worker id (global) */
 
 	/* for rebinding worker to CPU */
 	struct work_struct	rebind_work;	/* L: for busy worker */
-- 
1.7.7.6

