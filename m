Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161716AbaKNScK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:32:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965733AbaKNSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:30:36 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Rob Clark <robdclark@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 RESEND 1/2] drm: rework flip-work helpers to avoid calling func when the FIFO is full
Date: Fri, 14 Nov 2014 19:30:29 +0100
Message-Id: <1415989830-17691-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415989830-17691-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415989830-17691-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of lists instead of kfifo in order to dynamically allocate
task entry when someone require some delayed work, and thus preventing
drm_flip_work_queue from directly calling func instead of queuing this
call.
This allow drm_flip_work_queue to be safely called even within irq
handlers.

Add new helper functions to allocate a flip work task and queue it when
needed. This prevents allocating data within irq context (which might
impact the time spent in the irq handler).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/drm_flip_work.c | 97 +++++++++++++++++++++++++++++++----------
 include/drm/drm_flip_work.h     | 31 +++++++++----
 2 files changed, 96 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/drm_flip_work.c b/drivers/gpu/drm/drm_flip_work.c
index f9c7fa3..6f4ae5b 100644
--- a/drivers/gpu/drm/drm_flip_work.c
+++ b/drivers/gpu/drm/drm_flip_work.c
@@ -25,6 +25,44 @@
 #include "drm_flip_work.h"
 
 /**
+ * drm_flip_work_allocate_task - allocate a flip-work task
+ * @data: data associated to the task
+ * @flags: allocator flags
+ *
+ * Allocate a drm_flip_task object and attach private data to it.
+ */
+struct drm_flip_task *drm_flip_work_allocate_task(void *data, gfp_t flags)
+{
+	struct drm_flip_task *task;
+
+	task = kzalloc(sizeof(*task), flags);
+	if (task)
+		task->data = data;
+
+	return task;
+}
+EXPORT_SYMBOL(drm_flip_work_allocate_task);
+
+/**
+ * drm_flip_work_queue_task - queue a specific task
+ * @work: the flip-work
+ * @task: the task to handle
+ *
+ * Queues task, that will later be run (passed back to drm_flip_func_t
+ * func) on a work queue after drm_flip_work_commit() is called.
+ */
+void drm_flip_work_queue_task(struct drm_flip_work *work,
+			      struct drm_flip_task *task)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&work->lock, flags);
+	list_add_tail(&task->node, &work->queued);
+	spin_unlock_irqrestore(&work->lock, flags);
+}
+EXPORT_SYMBOL(drm_flip_work_queue_task);
+
+/**
  * drm_flip_work_queue - queue work
  * @work: the flip-work
  * @val: the value to queue
@@ -34,10 +72,14 @@
  */
 void drm_flip_work_queue(struct drm_flip_work *work, void *val)
 {
-	if (kfifo_put(&work->fifo, val)) {
-		atomic_inc(&work->pending);
+	struct drm_flip_task *task;
+
+	task = drm_flip_work_allocate_task(val,
+				drm_can_sleep() ? GFP_KERNEL : GFP_ATOMIC);
+	if (task) {
+		drm_flip_work_queue_task(work, task);
 	} else {
-		DRM_ERROR("%s fifo full!\n", work->name);
+		DRM_ERROR("%s could not allocate task!\n", work->name);
 		work->func(work, val);
 	}
 }
@@ -56,9 +98,12 @@ EXPORT_SYMBOL(drm_flip_work_queue);
 void drm_flip_work_commit(struct drm_flip_work *work,
 		struct workqueue_struct *wq)
 {
-	uint32_t pending = atomic_read(&work->pending);
-	atomic_add(pending, &work->count);
-	atomic_sub(pending, &work->pending);
+	unsigned long flags;
+
+	spin_lock_irqsave(&work->lock, flags);
+	list_splice_tail(&work->queued, &work->commited);
+	INIT_LIST_HEAD(&work->queued);
+	spin_unlock_irqrestore(&work->lock, flags);
 	queue_work(wq, &work->worker);
 }
 EXPORT_SYMBOL(drm_flip_work_commit);
@@ -66,14 +111,26 @@ EXPORT_SYMBOL(drm_flip_work_commit);
 static void flip_worker(struct work_struct *w)
 {
 	struct drm_flip_work *work = container_of(w, struct drm_flip_work, worker);
-	uint32_t count = atomic_read(&work->count);
-	void *val = NULL;
+	struct list_head tasks;
+	unsigned long flags;
 
-	atomic_sub(count, &work->count);
+	while (1) {
+		struct drm_flip_task *task, *tmp;
 
-	while(count--)
-		if (!WARN_ON(!kfifo_get(&work->fifo, &val)))
-			work->func(work, val);
+		INIT_LIST_HEAD(&tasks);
+		spin_lock_irqsave(&work->lock, flags);
+		list_splice_tail(&work->commited, &tasks);
+		INIT_LIST_HEAD(&work->commited);
+		spin_unlock_irqrestore(&work->lock, flags);
+
+		if (list_empty(&tasks))
+			break;
+
+		list_for_each_entry_safe(task, tmp, &tasks, node) {
+			work->func(work, task->data);
+			kfree(task);
+		}
+	}
 }
 
 /**
@@ -91,19 +148,12 @@ static void flip_worker(struct work_struct *w)
 int drm_flip_work_init(struct drm_flip_work *work, int size,
 		const char *name, drm_flip_func_t func)
 {
-	int ret;
-
 	work->name = name;
-	atomic_set(&work->count, 0);
-	atomic_set(&work->pending, 0);
+	INIT_LIST_HEAD(&work->queued);
+	INIT_LIST_HEAD(&work->commited);
+	spin_lock_init(&work->lock);
 	work->func = func;
 
-	ret = kfifo_alloc(&work->fifo, size, GFP_KERNEL);
-	if (ret) {
-		DRM_ERROR("could not allocate %s fifo\n", name);
-		return ret;
-	}
-
 	INIT_WORK(&work->worker, flip_worker);
 
 	return 0;
@@ -118,7 +168,6 @@ EXPORT_SYMBOL(drm_flip_work_init);
  */
 void drm_flip_work_cleanup(struct drm_flip_work *work)
 {
-	WARN_ON(!kfifo_is_empty(&work->fifo));
-	kfifo_free(&work->fifo);
+	WARN_ON(!list_empty(&work->queued) || !list_empty(&work->commited));
 }
 EXPORT_SYMBOL(drm_flip_work_cleanup);
diff --git a/include/drm/drm_flip_work.h b/include/drm/drm_flip_work.h
index 9eed34d..3fcb4c4 100644
--- a/include/drm/drm_flip_work.h
+++ b/include/drm/drm_flip_work.h
@@ -25,6 +25,7 @@
 #define DRM_FLIP_WORK_H
 
 #include <linux/kfifo.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
 /**
@@ -32,9 +33,9 @@
  *
  * Util to queue up work to run from work-queue context after flip/vblank.
  * Typically this can be used to defer unref of framebuffer's, cursor
- * bo's, etc until after vblank.  The APIs are all safe (and lockless)
- * for up to one producer and once consumer at a time.  The single-consumer
- * aspect is ensured by committing the queued work to a single work-queue.
+ * bo's, etc until after vblank.  The APIs are all thread-safe.
+ * Moreover, drm_flip_work_queue_task and drm_flip_work_queue can be called
+ * in atomic context.
  */
 
 struct drm_flip_work;
@@ -51,22 +52,36 @@ struct drm_flip_work;
 typedef void (*drm_flip_func_t)(struct drm_flip_work *work, void *val);
 
 /**
+ * struct drm_flip_task - flip work task
+ * @node: list entry element
+ * @data: data to pass to work->func
+ */
+struct drm_flip_task {
+	struct list_head node;
+	void *data;
+};
+
+/**
  * struct drm_flip_work - flip work queue
  * @name: debug name
- * @pending: number of queued but not committed items
- * @count: number of committed items
  * @func: callback fxn called for each committed item
  * @worker: worker which calls @func
- * @fifo: queue of committed items
+ * @queued: queued tasks
+ * @commited: commited tasks
+ * @lock: lock to access queued and commited lists
  */
 struct drm_flip_work {
 	const char *name;
-	atomic_t pending, count;
 	drm_flip_func_t func;
 	struct work_struct worker;
-	DECLARE_KFIFO_PTR(fifo, void *);
+	struct list_head queued;
+	struct list_head commited;
+	spinlock_t lock;
 };
 
+struct drm_flip_task *drm_flip_work_allocate_task(void *data, gfp_t flags);
+void drm_flip_work_queue_task(struct drm_flip_work *work,
+			      struct drm_flip_task *task);
 void drm_flip_work_queue(struct drm_flip_work *work, void *val);
 void drm_flip_work_commit(struct drm_flip_work *work,
 		struct workqueue_struct *wq);
-- 
1.9.1

