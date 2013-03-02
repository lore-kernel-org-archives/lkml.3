Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3CBD2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:28:38 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63677 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3CBDZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:07 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/31] workqueue: restructure __alloc_workqueue_key()
Date: Fri,  1 Mar 2013 19:24:13 -0800
Message-Id: <1362194662-2344-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move initialization and linking of pool_workqueues into
  init_and_link_pwq().

* Make the failure path use destroy_workqueue() once pool_workqueue
  initialization succeeds.

These changes are to prepare for dynamic management of pool_workqueues
and don't introduce any functional changes.

While at it, convert list_del(&wq->list) to list_del_init() as a
precaution as scheduled changes will make destruction more complex.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 67 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bcc02bb..d0604ee 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3322,6 +3322,23 @@ fail:
 	return NULL;
 }
 
+/* initialize @pwq which interfaces with @pool for @wq and link it in */
+static void init_and_link_pwq(struct pool_workqueue *pwq,
+			      struct workqueue_struct *wq,
+			      struct worker_pool *pool)
+{
+	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
+
+	pwq->pool = pool;
+	pwq->wq = wq;
+	pwq->flush_color = -1;
+	pwq->max_active = wq->saved_max_active;
+	INIT_LIST_HEAD(&pwq->delayed_works);
+	INIT_LIST_HEAD(&pwq->mayday_node);
+
+	list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
+}
+
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
@@ -3338,23 +3355,23 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			struct worker_pool *cpu_pools =
 				per_cpu(cpu_worker_pools, cpu);
 
-			pwq->pool = &cpu_pools[highpri];
-			list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
+			init_and_link_pwq(pwq, wq, &cpu_pools[highpri]);
 		}
 	} else {
 		struct pool_workqueue *pwq;
+		struct worker_pool *pool;
 
 		pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
 		if (!pwq)
 			return -ENOMEM;
 
-		pwq->pool = get_unbound_pool(unbound_std_wq_attrs[highpri]);
-		if (!pwq->pool) {
+		pool = get_unbound_pool(unbound_std_wq_attrs[highpri]);
+		if (!pool) {
 			kmem_cache_free(pwq_cache, pwq);
 			return -ENOMEM;
 		}
 
-		list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
+		init_and_link_pwq(pwq, wq, pool);
 	}
 
 	return 0;
@@ -3399,7 +3416,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	wq = kzalloc(sizeof(*wq) + namelen, GFP_KERNEL);
 	if (!wq)
-		goto err;
+		return NULL;
 
 	vsnprintf(wq->name, namelen, fmt, args1);
 	va_end(args);
@@ -3422,18 +3439,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	INIT_LIST_HEAD(&wq->list);
 
 	if (alloc_and_link_pwqs(wq) < 0)
-		goto err;
-
-	local_irq_disable();
-	for_each_pwq(pwq, wq) {
-		BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
-		pwq->wq = wq;
-		pwq->flush_color = -1;
-		pwq->max_active = max_active;
-		INIT_LIST_HEAD(&pwq->delayed_works);
-		INIT_LIST_HEAD(&pwq->mayday_node);
-	}
-	local_irq_enable();
+		goto err_free_wq;
 
 	/*
 	 * Workqueues which may be used during memory reclaim should
@@ -3442,16 +3448,19 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (flags & WQ_MEM_RECLAIM) {
 		struct worker *rescuer;
 
-		wq->rescuer = rescuer = alloc_worker();
+		rescuer = alloc_worker();
 		if (!rescuer)
-			goto err;
+			goto err_destroy;
 
 		rescuer->rescue_wq = wq;
 		rescuer->task = kthread_create(rescuer_thread, rescuer, "%s",
 					       wq->name);
-		if (IS_ERR(rescuer->task))
-			goto err;
+		if (IS_ERR(rescuer->task)) {
+			kfree(rescuer);
+			goto err_destroy;
+		}
 
+		wq->rescuer = rescuer;
 		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
@@ -3472,12 +3481,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	spin_unlock_irq(&workqueue_lock);
 
 	return wq;
-err:
-	if (wq) {
-		free_pwqs(wq);
-		kfree(wq->rescuer);
-		kfree(wq);
-	}
+
+err_free_wq:
+	kfree(wq);
+	return NULL;
+err_destroy:
+	destroy_workqueue(wq);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
@@ -3519,7 +3528,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	list_del(&wq->list);
+	list_del_init(&wq->list);
 
 	spin_unlock_irq(&workqueue_lock);
 
-- 
1.8.1.2

