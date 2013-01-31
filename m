Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3AaSmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:42:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab3AaSmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:42:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672843"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 12/13] workqueue: add worker's global worker ID
Date: Fri, 1 Feb 2013 02:41:35 +0800
Message-Id: <1359657696-2767-13-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:41:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:41:06,
	Serialize complete at 2013/02/01 02:41:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add worker->gwid which is allocated from worker_idr.  This
will be used to record the last running worker in work->data.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   28 ++++++++++++++++++++++++++++
 kernel/workqueue_internal.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04d1286..bc57faf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -439,6 +439,10 @@ static atomic_t unbound_std_pool_nr_running[NR_STD_WORKER_POOLS] = {
 static DEFINE_MUTEX(worker_pool_idr_mutex);
 static DEFINE_IDR(worker_pool_idr);
 
+/* idr of all workers */
+static DEFINE_MUTEX(worker_gwid_idr_mutex);
+static DEFINE_IDR(worker_gwid_idr);
+
 static int worker_thread(void *__worker);
 
 static struct worker_pool *std_worker_pools(int cpu)
@@ -454,6 +458,26 @@ static int std_worker_pool_pri(struct worker_pool *pool)
 	return pool - std_worker_pools(pool->cpu);
 }
 
+/* allocate ID and assign it to @worker */
+static int worker_assign_gwid(struct worker *worker)
+{
+	int ret;
+
+	mutex_lock(&worker_gwid_idr_mutex);
+	idr_pre_get(&worker_gwid_idr, GFP_KERNEL);
+	ret = idr_get_new(&worker_gwid_idr, worker, &worker->gwid);
+	mutex_unlock(&worker_gwid_idr_mutex);
+
+	return ret;
+}
+
+static void free_worker_gwid(struct worker *worker)
+{
+	mutex_lock(&worker_gwid_idr_mutex);
+	idr_remove(&worker_gwid_idr, worker->gwid);
+	mutex_unlock(&worker_gwid_idr_mutex);
+}
+
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
@@ -1814,6 +1838,9 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->pool = pool;
 	worker->id = id;
 
+	if (worker_assign_gwid(worker))
+		goto fail;
+
 	if (pool->cpu != WORK_CPU_UNBOUND)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(pool->cpu),
@@ -1900,6 +1927,7 @@ static void destroy_worker(struct worker *worker)
 	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
+	free_worker_gwid(worker);
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 328be4a..eccd50c 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -36,6 +36,7 @@ struct worker {
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
+	int			gwid;		/* I: global worker id */
 
 	/* for rebinding worker to CPU */
 	struct work_struct	rebind_work;	/* L: for busy worker */
-- 
1.7.7.6

