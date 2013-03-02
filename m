Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3CBDZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:19 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52017 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3CBDYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:55 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/31] workqueue: separate out init_worker_pool() from init_workqueues()
Date: Fri,  1 Mar 2013 19:24:06 -0800
Message-Id: <1362194662-2344-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used to implement unbound pools with custom attributes.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 68b3443..f97539b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3121,6 +3121,26 @@ int keventd_up(void)
 	return system_wq != NULL;
 }
 
+static void init_worker_pool(struct worker_pool *pool)
+{
+	spin_lock_init(&pool->lock);
+	pool->flags |= POOL_DISASSOCIATED;
+	INIT_LIST_HEAD(&pool->worklist);
+	INIT_LIST_HEAD(&pool->idle_list);
+	hash_init(pool->busy_hash);
+
+	init_timer_deferrable(&pool->idle_timer);
+	pool->idle_timer.function = idle_worker_timeout;
+	pool->idle_timer.data = (unsigned long)pool;
+
+	setup_timer(&pool->mayday_timer, pool_mayday_timeout,
+		    (unsigned long)pool);
+
+	mutex_init(&pool->manager_mutex);
+	mutex_init(&pool->assoc_mutex);
+	ida_init(&pool->worker_ida);
+}
+
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
@@ -3789,23 +3809,8 @@ static int __init init_workqueues(void)
 		struct worker_pool *pool;
 
 		for_each_std_worker_pool(pool, cpu) {
-			spin_lock_init(&pool->lock);
+			init_worker_pool(pool);
 			pool->cpu = cpu;
-			pool->flags |= POOL_DISASSOCIATED;
-			INIT_LIST_HEAD(&pool->worklist);
-			INIT_LIST_HEAD(&pool->idle_list);
-			hash_init(pool->busy_hash);
-
-			init_timer_deferrable(&pool->idle_timer);
-			pool->idle_timer.function = idle_worker_timeout;
-			pool->idle_timer.data = (unsigned long)pool;
-
-			setup_timer(&pool->mayday_timer, pool_mayday_timeout,
-				    (unsigned long)pool);
-
-			mutex_init(&pool->manager_mutex);
-			mutex_init(&pool->assoc_mutex);
-			ida_init(&pool->worker_ida);
 
 			/* alloc pool ID */
 			BUG_ON(worker_pool_assign_id(pool));
-- 
1.8.1.2

