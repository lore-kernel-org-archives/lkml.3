Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3BRQNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:13:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31245 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3BRQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:13:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724942"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 03/15] workqueue: remname current worker->id to worker->id_in_pool
Date: Tue, 19 Feb 2013 00:12:04 +0800
Message-Id: <1361203940-6300-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:07,
	Serialize complete at 2013/02/19 00:13:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use worker->id for global worker id.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   20 +++++++++++---------
 kernel/workqueue_internal.h |    2 +-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f90d0bd..764ad45 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1722,10 +1722,10 @@ static struct worker *create_worker(struct worker_pool *pool)
 {
 	const char *pri = std_worker_pool_pri(pool) ? "H" : "";
 	struct worker *worker = NULL;
-	int id = -1;
+	int id_in_pool = -1;
 
 	spin_lock_irq(&pool->lock);
-	while (ida_get_new(&pool->worker_ida, &id)) {
+	while (ida_get_new(&pool->worker_ida, &id_in_pool)) {
 		spin_unlock_irq(&pool->lock);
 		if (!ida_pre_get(&pool->worker_ida, GFP_KERNEL))
 			goto fail;
@@ -1738,15 +1738,17 @@ static struct worker *create_worker(struct worker_pool *pool)
 		goto fail;
 
 	worker->pool = pool;
-	worker->id = id;
+	worker->id_in_pool = id_in_pool;
 
 	if (pool->cpu != WORK_CPU_UNBOUND)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(pool->cpu),
-					"kworker/%u:%d%s", pool->cpu, id, pri);
+					"kworker/%u:%d%s", pool->cpu,
+					id_in_pool, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/u:%d%s", id, pri);
+					      "kworker/u:%d%s",
+					      id_in_pool, pri);
 	if (IS_ERR(worker->task))
 		goto fail;
 
@@ -1771,9 +1773,9 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	return worker;
 fail:
-	if (id >= 0) {
+	if (id_in_pool >= 0) {
 		spin_lock_irq(&pool->lock);
-		ida_remove(&pool->worker_ida, id);
+		ida_remove(&pool->worker_ida, id_in_pool);
 		spin_unlock_irq(&pool->lock);
 	}
 	kfree(worker);
@@ -1809,7 +1811,7 @@ static void start_worker(struct worker *worker)
 static void destroy_worker(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	int id = worker->id;
+	int id_in_pool = worker->id_in_pool;
 
 	/* sanity check frenzy */
 	BUG_ON(worker->current_work);
@@ -1829,7 +1831,7 @@ static void destroy_worker(struct worker *worker)
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
-	ida_remove(&pool->worker_ida, id);
+	ida_remove(&pool->worker_ida, id_in_pool);
 }
 
 static void idle_worker_timeout(unsigned long __pool)
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 328be4a..e6afb59 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -35,7 +35,7 @@ struct worker {
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-	int			id;		/* I: worker id */
+	int			id_in_pool;	/* I: worker id in the pool */
 
 	/* for rebinding worker to CPU */
 	struct work_struct	rebind_work;	/* L: for busy worker */
-- 
1.7.7.6

