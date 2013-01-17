Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3AQBqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:46:14 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39974 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab3AQBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/17] workqueue: add worker_pool->id
Date: Wed, 16 Jan 2013 17:42:38 -0800
Message-Id: <1358386969-945-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add worker_pool->id which is allocated from worker_pool_idr.  This
will be used to record the last associated worker_pool in work->data.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9da3db2..fbe2e24 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -151,6 +151,7 @@ struct worker {
 
 struct worker_pool {
 	struct global_cwq	*gcwq;		/* I: the owning gcwq */
+	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
 
 	struct list_head	worklist;	/* L: list of pending works */
@@ -472,6 +473,10 @@ static atomic_t unbound_pool_nr_running[NR_STD_WORKER_POOLS] = {
 	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
 };
 
+/* idr of all pools */
+static DEFINE_MUTEX(worker_pool_idr_mutex);
+static DEFINE_IDR(worker_pool_idr);
+
 static int worker_thread(void *__worker);
 static unsigned int work_cpu(struct work_struct *work);
 
@@ -488,6 +493,19 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 		return &unbound_global_cwq;
 }
 
+/* allocate ID and assign it to @pool */
+static int worker_pool_assign_id(struct worker_pool *pool)
+{
+	int ret;
+
+	mutex_lock(&worker_pool_idr_mutex);
+	idr_pre_get(&worker_pool_idr, GFP_KERNEL);
+	ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
+	mutex_unlock(&worker_pool_idr_mutex);
+
+	return ret;
+}
+
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
 	int cpu = pool->gcwq->cpu;
@@ -3839,6 +3857,9 @@ static int __init init_workqueues(void)
 
 			mutex_init(&pool->assoc_mutex);
 			ida_init(&pool->worker_ida);
+
+			/* alloc pool ID */
+			BUG_ON(worker_pool_assign_id(pool));
 		}
 	}
 
-- 
1.8.0.2

