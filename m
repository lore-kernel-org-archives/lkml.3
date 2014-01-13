Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaAMNDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:03:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39705 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaAMNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:02:53 -0500
Subject: [PATCH 5/7] android: convert sync to fence api, v3
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, ccross@google.com,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Mon, 13 Jan 2014 13:32:38 +0100
Message-ID: <20140113123222.20574.99732.stgit@patser>
In-Reply-To: <20140113122818.20574.34710.stgit@patser>
References: <20140113122818.20574.34710.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android syncpoints can be mapped to a timeline. This removes the need
to maintain a separate api for synchronization. I've left the android
trace events in place, but the core fence events should already be
sufficient for debugging.

v2:
- Call fence_remove_callback in sync_fence_free if not all fences have fired.
v3:
- Merge Colin Cross' bugfixes, and the android fence merge optimization.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/staging/android/Kconfig      |    1 
 drivers/staging/android/Makefile     |    2 
 drivers/staging/android/sw_sync.c    |    4 
 drivers/staging/android/sync.c       |  895 +++++++++++-----------------------
 drivers/staging/android/sync.h       |   85 ++-
 drivers/staging/android/sync_debug.c |  245 +++++++++
 drivers/staging/android/trace/sync.h |   12 
 7 files changed, 592 insertions(+), 652 deletions(-)
 create mode 100644 drivers/staging/android/sync_debug.c

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 1e9ab6dfc90d..c8d28dc3050c 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -77,6 +77,7 @@ config SYNC
 	bool "Synchronization framework"
 	default n
 	select ANON_INODES
+	select DMA_SHARED_BUFFER
 	---help---
 	  This option enables the framework for synchronization between multiple
 	  drivers.  Sync implementations can take advantage of hardware
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index c136299e05af..81b8293ba1a9 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
 obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
 obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
 obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
-obj-$(CONFIG_SYNC)			+= sync.o
+obj-$(CONFIG_SYNC)			+= sync.o sync_debug.o
 obj-$(CONFIG_SW_SYNC)			+= sw_sync.o
diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index f24493ac65e3..a76db3ff87cb 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -50,7 +50,7 @@ static struct sync_pt *sw_sync_pt_dup(struct sync_pt *sync_pt)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *) sync_pt;
 	struct sw_sync_timeline *obj =
-		(struct sw_sync_timeline *)sync_pt->parent;
+		(struct sw_sync_timeline *)sync_pt_parent(sync_pt);
 
 	return (struct sync_pt *) sw_sync_pt_create(obj, pt->value);
 }
@@ -59,7 +59,7 @@ static int sw_sync_pt_has_signaled(struct sync_pt *sync_pt)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
 	struct sw_sync_timeline *obj =
-		(struct sw_sync_timeline *)sync_pt->parent;
+		(struct sw_sync_timeline *)sync_pt_parent(sync_pt);
 
 	return sw_sync_cmp(obj->value, pt->value) >= 0;
 }
diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 38e5d3b5ed9b..ba0d69e269b5 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -31,22 +31,13 @@
 #define CREATE_TRACE_POINTS
 #include "trace/sync.h"
 
-static void sync_fence_signal_pt(struct sync_pt *pt);
-static int _sync_pt_has_signaled(struct sync_pt *pt);
-static void sync_fence_free(struct kref *kref);
-static void sync_dump(void);
-
-static LIST_HEAD(sync_timeline_list_head);
-static DEFINE_SPINLOCK(sync_timeline_list_lock);
-
-static LIST_HEAD(sync_fence_list_head);
-static DEFINE_SPINLOCK(sync_fence_list_lock);
+static const struct fence_ops android_fence_ops;
+static const struct file_operations sync_fence_fops;
 
 struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
 					   int size, const char *name)
 {
 	struct sync_timeline *obj;
-	unsigned long flags;
 
 	if (size < sizeof(struct sync_timeline))
 		return NULL;
@@ -57,17 +48,14 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
 
 	kref_init(&obj->kref);
 	obj->ops = ops;
+	obj->context = fence_context_alloc(1);
 	strlcpy(obj->name, name, sizeof(obj->name));
 
 	INIT_LIST_HEAD(&obj->child_list_head);
-	spin_lock_init(&obj->child_list_lock);
-
 	INIT_LIST_HEAD(&obj->active_list_head);
-	spin_lock_init(&obj->active_list_lock);
+	spin_lock_init(&obj->child_list_lock);
 
-	spin_lock_irqsave(&sync_timeline_list_lock, flags);
-	list_add_tail(&obj->sync_timeline_list, &sync_timeline_list_head);
-	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
+	sync_timeline_debug_add(obj);
 
 	return obj;
 }
@@ -77,18 +65,25 @@ static void sync_timeline_free(struct kref *kref)
 {
 	struct sync_timeline *obj =
 		container_of(kref, struct sync_timeline, kref);
-	unsigned long flags;
+
+	sync_timeline_debug_remove(obj);
 
 	if (obj->ops->release_obj)
 		obj->ops->release_obj(obj);
 
-	spin_lock_irqsave(&sync_timeline_list_lock, flags);
-	list_del(&obj->sync_timeline_list);
-	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
-
 	kfree(obj);
 }
 
+static void sync_timeline_get(struct sync_timeline *obj)
+{
+	kref_get(&obj->kref);
+}
+
+static void sync_timeline_put(struct sync_timeline *obj)
+{
+	kref_put(&obj->kref, sync_timeline_free);
+}
+
 void sync_timeline_destroy(struct sync_timeline *obj)
 {
 	obj->destroyed = true;
@@ -98,75 +93,31 @@ void sync_timeline_destroy(struct sync_timeline *obj)
 	 * that their parent is going away.
 	 */
 
-	if (!kref_put(&obj->kref, sync_timeline_free))
-		sync_timeline_signal(obj);
+	sync_timeline_signal(obj);
+	sync_timeline_put(obj);
 }
 EXPORT_SYMBOL(sync_timeline_destroy);
 
-static void sync_timeline_add_pt(struct sync_timeline *obj, struct sync_pt *pt)
-{
-	unsigned long flags;
-
-	pt->parent = obj;
-
-	spin_lock_irqsave(&obj->child_list_lock, flags);
-	list_add_tail(&pt->child_list, &obj->child_list_head);
-	spin_unlock_irqrestore(&obj->child_list_lock, flags);
-}
-
-static void sync_timeline_remove_pt(struct sync_pt *pt)
-{
-	struct sync_timeline *obj = pt->parent;
-	unsigned long flags;
-
-	spin_lock_irqsave(&obj->active_list_lock, flags);
-	if (!list_empty(&pt->active_list))
-		list_del_init(&pt->active_list);
-	spin_unlock_irqrestore(&obj->active_list_lock, flags);
-
-	spin_lock_irqsave(&obj->child_list_lock, flags);
-	if (!list_empty(&pt->child_list))
-		list_del_init(&pt->child_list);
-
-	spin_unlock_irqrestore(&obj->child_list_lock, flags);
-}
-
 void sync_timeline_signal(struct sync_timeline *obj)
 {
 	unsigned long flags;
 	LIST_HEAD(signaled_pts);
-	struct list_head *pos, *n;
+	struct sync_pt *pt, *next;
 
 	trace_sync_timeline(obj);
 
-	spin_lock_irqsave(&obj->active_list_lock, flags);
-
-	list_for_each_safe(pos, n, &obj->active_list_head) {
-		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, active_list);
-
-		if (_sync_pt_has_signaled(pt)) {
-			list_del_init(pos);
-			list_add(&pt->signaled_list, &signaled_pts);
-			kref_get(&pt->fence->kref);
-		}
-	}
-
-	spin_unlock_irqrestore(&obj->active_list_lock, flags);
-
-	list_for_each_safe(pos, n, &signaled_pts) {
-		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, signaled_list);
-
-		list_del_init(pos);
-		sync_fence_signal_pt(pt);
-		kref_put(&pt->fence->kref, sync_fence_free);
+	spin_lock_irqsave(&obj->child_list_lock, flags);
+	list_for_each_entry_safe(pt, next, &obj->active_list_head, active_list) {
+		if (__fence_is_signaled(&pt->base))
+			list_del(&pt->active_list);
 	}
+	spin_unlock_irqrestore(&obj->child_list_lock, flags);
 }
 EXPORT_SYMBOL(sync_timeline_signal);
 
-struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
+struct sync_pt *sync_pt_create(struct sync_timeline *obj, int size)
 {
+	unsigned long flags;
 	struct sync_pt *pt;
 
 	if (size < sizeof(struct sync_pt))
@@ -176,87 +127,27 @@ struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
 	if (pt == NULL)
 		return NULL;
 
+	spin_lock_irqsave(&obj->child_list_lock, flags);
+	sync_timeline_get(obj);
+	__fence_init(&pt->base, &android_fence_ops, &obj->child_list_lock, obj->context, ++obj->value);
+	list_add_tail(&pt->child_list, &obj->child_list_head);
 	INIT_LIST_HEAD(&pt->active_list);
-	kref_get(&parent->kref);
-	sync_timeline_add_pt(parent, pt);
-
+	spin_unlock_irqrestore(&obj->child_list_lock, flags);
 	return pt;
 }
 EXPORT_SYMBOL(sync_pt_create);
 
 void sync_pt_free(struct sync_pt *pt)
 {
-	if (pt->parent->ops->free_pt)
-		pt->parent->ops->free_pt(pt);
-
-	sync_timeline_remove_pt(pt);
-
-	kref_put(&pt->parent->kref, sync_timeline_free);
-
-	kfree(pt);
+	fence_put(&pt->base);
 }
 EXPORT_SYMBOL(sync_pt_free);
 
-/* call with pt->parent->active_list_lock held */
-static int _sync_pt_has_signaled(struct sync_pt *pt)
-{
-	int old_status = pt->status;
-
-	if (!pt->status)
-		pt->status = pt->parent->ops->has_signaled(pt);
-
-	if (!pt->status && pt->parent->destroyed)
-		pt->status = -ENOENT;
-
-	if (pt->status != old_status)
-		pt->timestamp = ktime_get();
-
-	return pt->status;
-}
-
-static struct sync_pt *sync_pt_dup(struct sync_pt *pt)
-{
-	return pt->parent->ops->dup(pt);
-}
-
-/* Adds a sync pt to the active queue.  Called when added to a fence */
-static void sync_pt_activate(struct sync_pt *pt)
-{
-	struct sync_timeline *obj = pt->parent;
-	unsigned long flags;
-	int err;
-
-	spin_lock_irqsave(&obj->active_list_lock, flags);
-
-	err = _sync_pt_has_signaled(pt);
-	if (err != 0)
-		goto out;
-
-	list_add_tail(&pt->active_list, &obj->active_list_head);
-
-out:
-	spin_unlock_irqrestore(&obj->active_list_lock, flags);
-}
-
-static int sync_fence_release(struct inode *inode, struct file *file);
-static unsigned int sync_fence_poll(struct file *file, poll_table *wait);
-static long sync_fence_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg);
-
-
-static const struct file_operations sync_fence_fops = {
-	.release = sync_fence_release,
-	.poll = sync_fence_poll,
-	.unlocked_ioctl = sync_fence_ioctl,
-	.compat_ioctl = sync_fence_ioctl,
-};
-
-static struct sync_fence *sync_fence_alloc(const char *name)
+static struct sync_fence *sync_fence_alloc(int size, const char *name)
 {
 	struct sync_fence *fence;
-	unsigned long flags;
 
-	fence = kzalloc(sizeof(struct sync_fence), GFP_KERNEL);
+	fence = kzalloc(size, GFP_KERNEL);
 	if (fence == NULL)
 		return NULL;
 
@@ -268,16 +159,8 @@ static struct sync_fence *sync_fence_alloc(const char *name)
 	kref_init(&fence->kref);
 	strlcpy(fence->name, name, sizeof(fence->name));
 
-	INIT_LIST_HEAD(&fence->pt_list_head);
-	INIT_LIST_HEAD(&fence->waiter_list_head);
-	spin_lock_init(&fence->waiter_list_lock);
-
 	init_waitqueue_head(&fence->wq);
 
-	spin_lock_irqsave(&sync_fence_list_lock, flags);
-	list_add_tail(&fence->sync_fence_list, &sync_fence_list_head);
-	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
-
 	return fence;
 
 err:
@@ -285,119 +168,40 @@ err:
 	return NULL;
 }
 
+static void fence_check_cb_func(struct fence *f, struct fence_cb *cb)
+{
+	struct sync_fence_cb *check = container_of(cb, struct sync_fence_cb, cb);
+	struct sync_fence *fence = check->fence;
+
+	// TODO: Add a fence->status member and check it
+	if (atomic_dec_and_test(&fence->status))
+		wake_up_all(&fence->wq);
+}
+
 /* TODO: implement a create which takes more that one sync_pt */
 struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
 {
 	struct sync_fence *fence;
 
-	if (pt->fence)
-		return NULL;
-
-	fence = sync_fence_alloc(name);
+	fence = sync_fence_alloc(offsetof(struct sync_fence, cbs[1]), name);
 	if (fence == NULL)
 		return NULL;
 
-	pt->fence = fence;
-	list_add(&pt->pt_list, &fence->pt_list_head);
-	sync_pt_activate(pt);
+	fence->num_fences = 1;
+	atomic_set(&fence->status, 1);
 
-	/*
-	 * signal the fence in case pt was activated before
-	 * sync_pt_activate(pt) was called
-	 */
-	sync_fence_signal_pt(pt);
+	fence_get(&pt->base);
+	fence->cbs[0].sync_pt = &pt->base;
+	fence->cbs[0].fence = fence;
+	if (fence_add_callback(&pt->base, &fence->cbs[0].cb, fence_check_cb_func))
+		atomic_dec(&fence->status);
+
+	sync_fence_debug_add(fence);
 
 	return fence;
 }
 EXPORT_SYMBOL(sync_fence_create);
 
-static int sync_fence_copy_pts(struct sync_fence *dst, struct sync_fence *src)
-{
-	struct list_head *pos;
-
-	list_for_each(pos, &src->pt_list_head) {
-		struct sync_pt *orig_pt =
-			container_of(pos, struct sync_pt, pt_list);
-		struct sync_pt *new_pt = sync_pt_dup(orig_pt);
-
-		if (new_pt == NULL)
-			return -ENOMEM;
-
-		new_pt->fence = dst;
-		list_add(&new_pt->pt_list, &dst->pt_list_head);
-	}
-
-	return 0;
-}
-
-static int sync_fence_merge_pts(struct sync_fence *dst, struct sync_fence *src)
-{
-	struct list_head *src_pos, *dst_pos, *n;
-
-	list_for_each(src_pos, &src->pt_list_head) {
-		struct sync_pt *src_pt =
-			container_of(src_pos, struct sync_pt, pt_list);
-		bool collapsed = false;
-
-		list_for_each_safe(dst_pos, n, &dst->pt_list_head) {
-			struct sync_pt *dst_pt =
-				container_of(dst_pos, struct sync_pt, pt_list);
-			/* collapse two sync_pts on the same timeline
-			 * to a single sync_pt that will signal at
-			 * the later of the two
-			 */
-			if (dst_pt->parent == src_pt->parent) {
-				if (dst_pt->parent->ops->compare(dst_pt, src_pt)
-						 == -1) {
-					struct sync_pt *new_pt =
-						sync_pt_dup(src_pt);
-					if (new_pt == NULL)
-						return -ENOMEM;
-
-					new_pt->fence = dst;
-					list_replace(&dst_pt->pt_list,
-						     &new_pt->pt_list);
-					sync_pt_free(dst_pt);
-				}
-				collapsed = true;
-				break;
-			}
-		}
-
-		if (!collapsed) {
-			struct sync_pt *new_pt = sync_pt_dup(src_pt);
-
-			if (new_pt == NULL)
-				return -ENOMEM;
-
-			new_pt->fence = dst;
-			list_add(&new_pt->pt_list, &dst->pt_list_head);
-		}
-	}
-
-	return 0;
-}
-
-static void sync_fence_detach_pts(struct sync_fence *fence)
-{
-	struct list_head *pos, *n;
-
-	list_for_each_safe(pos, n, &fence->pt_list_head) {
-		struct sync_pt *pt = container_of(pos, struct sync_pt, pt_list);
-		sync_timeline_remove_pt(pt);
-	}
-}
-
-static void sync_fence_free_pts(struct sync_fence *fence)
-{
-	struct list_head *pos, *n;
-
-	list_for_each_safe(pos, n, &fence->pt_list_head) {
-		struct sync_pt *pt = container_of(pos, struct sync_pt, pt_list);
-		sync_pt_free(pt);
-	}
-}
-
 struct sync_fence *sync_fence_fdget(int fd)
 {
 	struct file *file = fget(fd);
@@ -428,197 +232,148 @@ void sync_fence_install(struct sync_fence *fence, int fd)
 }
 EXPORT_SYMBOL(sync_fence_install);
 
-static int sync_fence_get_status(struct sync_fence *fence)
-{
-	struct list_head *pos;
-	int status = 1;
+static void sync_fence_add_pt(struct sync_fence *fence, int *i, struct fence *pt) {
+	fence->cbs[*i].sync_pt = pt;
+	fence->cbs[*i].fence = fence;
 
-	list_for_each(pos, &fence->pt_list_head) {
-		struct sync_pt *pt = container_of(pos, struct sync_pt, pt_list);
-		int pt_status = pt->status;
-
-		if (pt_status < 0) {
-			status = pt_status;
-			break;
-		} else if (status == 1) {
-			status = pt_status;
-		}
+	if (!fence_add_callback(pt, &fence->cbs[*i].cb, fence_check_cb_func)) {
+		fence_get(pt);
+		(*i)++;
 	}
-
-	return status;
 }
 
 struct sync_fence *sync_fence_merge(const char *name,
 				    struct sync_fence *a, struct sync_fence *b)
 {
+	int num_fences = a->num_fences + b->num_fences;
 	struct sync_fence *fence;
-	struct list_head *pos;
-	int err;
+	int i, i_a, i_b;
 
-	fence = sync_fence_alloc(name);
+	fence = sync_fence_alloc(offsetof(struct sync_fence, cbs[num_fences]), name);
 	if (fence == NULL)
 		return NULL;
 
-	err = sync_fence_copy_pts(fence, a);
-	if (err < 0)
-		goto err;
+	atomic_set(&fence->status, num_fences);
 
-	err = sync_fence_merge_pts(fence, b);
-	if (err < 0)
-		goto err;
+	/*
+	 * Assume sync_fence a and b are both ordered and have no
+	 * duplicates with the same context.
+	 *
+	 * If a sync_fence can only be created with sync_fence_merge
+	 * and sync_fence_create, this is a reasonable assumption.
+	 */
+	for (i = i_a = i_b = 0; i_a < a->num_fences && i_b < b->num_fences; ) {
+		struct fence *pt_a = a->cbs[i_a].sync_pt;
+		struct fence *pt_b = b->cbs[i_b].sync_pt;
+
+		if (pt_a->context < pt_b->context) {
+			sync_fence_add_pt(fence, &i, pt_a);
 
-	list_for_each(pos, &fence->pt_list_head) {
-		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, pt_list);
-		sync_pt_activate(pt);
+			i_a++;
+		} else if (pt_a->context > pt_b->context) {
+			sync_fence_add_pt(fence, &i, pt_b);
+
+			i_b++;
+		} else {
+			if (pt_a->seqno - pt_b->seqno <= INT_MAX)
+				sync_fence_add_pt(fence, &i, pt_a);
+			else
+				sync_fence_add_pt(fence, &i, pt_b);
+
+			i_a++;
+			i_b++;
+		}
 	}
 
-	/*
-	 * signal the fence in case one of it's pts were activated before
-	 * they were activated
-	 */
-	sync_fence_signal_pt(list_first_entry(&fence->pt_list_head,
-					      struct sync_pt,
-					      pt_list));
+	for (; i_a < a->num_fences; i_a++)
+		sync_fence_add_pt(fence, &i, a->cbs[i_a].sync_pt);
+
+	for (; i_b < b->num_fences; i_b++)
+		sync_fence_add_pt(fence, &i, b->cbs[i_b].sync_pt);
+
+	if (num_fences > i)
+		atomic_sub(num_fences - i, &fence->status);
+	fence->num_fences = i;
 
+	sync_fence_debug_add(fence);
 	return fence;
-err:
-	sync_fence_free_pts(fence);
-	kfree(fence);
-	return NULL;
 }
 EXPORT_SYMBOL(sync_fence_merge);
 
-static void sync_fence_signal_pt(struct sync_pt *pt)
+int sync_fence_wake_up_wq(wait_queue_t *curr, unsigned mode,
+				 int wake_flags, void *key)
 {
-	LIST_HEAD(signaled_waiters);
-	struct sync_fence *fence = pt->fence;
-	struct list_head *pos;
-	struct list_head *n;
-	unsigned long flags;
-	int status;
-
-	status = sync_fence_get_status(fence);
-
-	spin_lock_irqsave(&fence->waiter_list_lock, flags);
-	/*
-	 * this should protect against two threads racing on the signaled
-	 * false -> true transition
-	 */
-	if (status && !fence->status) {
-		list_for_each_safe(pos, n, &fence->waiter_list_head)
-			list_move(pos, &signaled_waiters);
-
-		fence->status = status;
-	} else {
-		status = 0;
-	}
-	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
-
-	if (status) {
-		list_for_each_safe(pos, n, &signaled_waiters) {
-			struct sync_fence_waiter *waiter =
-				container_of(pos, struct sync_fence_waiter,
-					     waiter_list);
+	struct sync_fence_waiter *wait = container_of(curr, struct sync_fence_waiter, work);
+	list_del_init(&wait->work.task_list);
 
-			list_del(pos);
-			waiter->callback(fence, waiter);
-		}
-		wake_up(&fence->wq);
-	}
+	wait->callback(wait->work.private, wait);
+	return 1;
 }
 
 int sync_fence_wait_async(struct sync_fence *fence,
 			  struct sync_fence_waiter *waiter)
 {
+	int err = atomic_read(&fence->status);
 	unsigned long flags;
-	int err = 0;
 
-	spin_lock_irqsave(&fence->waiter_list_lock, flags);
+	if (err < 0)
+		return err;
 
-	if (fence->status) {
-		err = fence->status;
-		goto out;
-	}
+	if (!err)
+		return 1;
 
-	list_add_tail(&waiter->waiter_list, &fence->waiter_list_head);
-out:
-	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
+	init_waitqueue_func_entry(&waiter->work, sync_fence_wake_up_wq);
+	waiter->work.private = fence;
 
-	return err;
+	spin_lock_irqsave(&fence->wq.lock, flags);
+	err = atomic_read(&fence->status);
+	if (err > 0)
+		__add_wait_queue_tail(&fence->wq, &waiter->work);
+	spin_unlock_irqrestore(&fence->wq.lock, flags);
+
+	if (err < 0)
+		return err;
+
+	return !err;
 }
 EXPORT_SYMBOL(sync_fence_wait_async);
 
 int sync_fence_cancel_async(struct sync_fence *fence,
 			     struct sync_fence_waiter *waiter)
 {
-	struct list_head *pos;
-	struct list_head *n;
 	unsigned long flags;
-	int ret = -ENOENT;
+	int ret = 0;
 
-	spin_lock_irqsave(&fence->waiter_list_lock, flags);
-	/*
-	 * Make sure waiter is still in waiter_list because it is possible for
-	 * the waiter to be removed from the list while the callback is still
-	 * pending.
-	 */
-	list_for_each_safe(pos, n, &fence->waiter_list_head) {
-		struct sync_fence_waiter *list_waiter =
-			container_of(pos, struct sync_fence_waiter,
-				     waiter_list);
-		if (list_waiter == waiter) {
-			list_del(pos);
-			ret = 0;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
+	spin_lock_irqsave(&fence->wq.lock, flags);
+	if (!list_empty(&waiter->work.task_list))
+		list_del_init(&waiter->work.task_list);
+	else
+		ret = -ENOENT;
+	spin_unlock_irqrestore(&fence->wq.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(sync_fence_cancel_async);
 
-static bool sync_fence_check(struct sync_fence *fence)
-{
-	/*
-	 * Make sure that reads to fence->status are ordered with the
-	 * wait queue event triggering
-	 */
-	smp_rmb();
-	return fence->status != 0;
-}
-
 int sync_fence_wait(struct sync_fence *fence, long timeout)
 {
-	int err = 0;
-	struct sync_pt *pt;
-
-	trace_sync_wait(fence, 1);
-	list_for_each_entry(pt, &fence->pt_list_head, pt_list)
-		trace_sync_pt(pt);
+	long ret;
+	int i;
 
-	if (timeout > 0) {
+	if (timeout < 0)
+		timeout = MAX_SCHEDULE_TIMEOUT;
+	else
 		timeout = msecs_to_jiffies(timeout);
-		err = wait_event_interruptible_timeout(fence->wq,
-						       sync_fence_check(fence),
-						       timeout);
-	} else if (timeout < 0) {
-		err = wait_event_interruptible(fence->wq,
-					       sync_fence_check(fence));
-	}
-	trace_sync_wait(fence, 0);
-
-	if (err < 0)
-		return err;
 
-	if (fence->status < 0) {
-		pr_info("fence error %d on [%p]\n", fence->status, fence);
-		sync_dump();
-		return fence->status;
-	}
+	trace_sync_wait(fence, 1);
+	for (i = 0; i < fence->num_fences; ++i)
+		trace_sync_pt(fence->cbs[i].sync_pt);
+	ret = wait_event_interruptible_timeout(fence->wq, atomic_read(&fence->status) <= 0, timeout);
+	trace_sync_wait(fence, 0);
 
-	if (fence->status == 0) {
-		if (timeout > 0) {
+	if (ret < 0)
+		return ret;
+	else if (ret == 0) {
+		if (timeout) {
 			pr_info("fence timeout on [%p] after %dms\n", fence,
 				jiffies_to_msecs(timeout));
 			sync_dump();
@@ -626,15 +381,132 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 		return -ETIME;
 	}
 
-	return 0;
+	ret = atomic_read(&fence->status);
+	if (ret) {
+		pr_info("fence error %ld on [%p]\n", ret, fence);
+		sync_dump();
+	}
+	return ret;
 }
 EXPORT_SYMBOL(sync_fence_wait);
 
+static const char *android_fence_get_driver_name(struct fence *fence)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	return parent->ops->driver_name;
+}
+
+static const char *android_fence_get_timeline_name(struct fence *fence)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	return parent->name;
+}
+
+static void android_fence_release(struct fence *fence)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+	unsigned long flags;
+
+	spin_lock_irqsave(fence->lock, flags);
+	list_del(&pt->child_list);
+	if (WARN_ON_ONCE(!list_empty(&pt->active_list)))
+		list_del(&pt->active_list);
+	spin_unlock_irqrestore(fence->lock, flags);
+
+	if (parent->ops->free_pt)
+		parent->ops->free_pt(pt);
+
+	sync_timeline_put(parent);
+	kfree(pt);
+}
+
+static bool android_fence_signaled(struct fence *fence)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+	int ret;
+
+	ret = parent->ops->has_signaled(pt);
+	if (ret < 0)
+		fence->status = ret;
+	return ret;
+}
+
+static bool android_fence_enable_signaling(struct fence *fence)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	if (android_fence_signaled(fence))
+		return false;
+
+	list_add_tail(&pt->active_list, &parent->active_list_head);
+	return true;
+}
+
+static int android_fence_fill_driver_data(struct fence *fence, void *data, int size)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	if (!parent->ops->fill_driver_data)
+		return 0;
+	return parent->ops->fill_driver_data(pt, data, size);
+}
+
+static void android_fence_value_str(struct fence *fence, char *str, int size)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	if (!parent->ops->pt_value_str) {
+		if (size)
+			*str = 0;
+		return;
+	}
+	parent->ops->pt_value_str(pt, str, size);
+}
+
+static void android_fence_timeline_value_str(struct fence *fence, char *str, int size)
+{
+	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	if (!parent->ops->timeline_value_str) {
+		if (size)
+			*str = 0;
+		return;
+	}
+	parent->ops->timeline_value_str(parent, str, size);
+}
+
+static const struct fence_ops android_fence_ops = {
+	.get_driver_name = android_fence_get_driver_name,
+	.get_timeline_name = android_fence_get_timeline_name,
+	.enable_signaling = android_fence_enable_signaling,
+	.signaled = android_fence_signaled,
+	.wait = fence_default_wait,
+	.release = android_fence_release,
+	.fill_driver_data = android_fence_fill_driver_data,
+	.fence_value_str = android_fence_value_str,
+	.timeline_value_str = android_fence_timeline_value_str,
+};
+
 static void sync_fence_free(struct kref *kref)
 {
 	struct sync_fence *fence = container_of(kref, struct sync_fence, kref);
+	int i, status = atomic_read(&fence->status);
 
-	sync_fence_free_pts(fence);
+	for (i = 0; i < fence->num_fences; ++i) {
+		if (status)
+			fence_remove_callback(fence->cbs[i].sync_pt, &fence->cbs[i].cb);
+		fence_put(fence->cbs[i].sync_pt);
+	}
 
 	kfree(fence);
 }
@@ -642,44 +514,25 @@ static void sync_fence_free(struct kref *kref)
 static int sync_fence_release(struct inode *inode, struct file *file)
 {
 	struct sync_fence *fence = file->private_data;
-	unsigned long flags;
-
-	/*
-	 * We need to remove all ways to access this fence before droping
-	 * our ref.
-	 *
-	 * start with its membership in the global fence list
-	 */
-	spin_lock_irqsave(&sync_fence_list_lock, flags);
-	list_del(&fence->sync_fence_list);
-	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
 
-	/*
-	 * remove its pts from their parents so that sync_timeline_signal()
-	 * can't reference the fence.
-	 */
-	sync_fence_detach_pts(fence);
+	sync_fence_debug_remove(fence);
 
 	kref_put(&fence->kref, sync_fence_free);
-
 	return 0;
 }
 
 static unsigned int sync_fence_poll(struct file *file, poll_table *wait)
 {
 	struct sync_fence *fence = file->private_data;
+	int status;
 
 	poll_wait(file, &fence->wq, wait);
 
-	/*
-	 * Make sure that reads to fence->status are ordered with the
-	 * wait queue event triggering
-	 */
-	smp_rmb();
+	status = atomic_read(&fence->status);
 
-	if (fence->status == 1)
+	if (!status)
 		return POLLIN;
-	else if (fence->status < 0)
+	else if (status < 0)
 		return POLLERR;
 	else
 		return 0;
@@ -744,7 +597,7 @@ err_put_fd:
 	return err;
 }
 
-static int sync_fill_pt_info(struct sync_pt *pt, void *data, int size)
+static int sync_fill_pt_info(struct fence *fence, void *data, int size)
 {
 	struct sync_pt_info *info = data;
 	int ret;
@@ -754,20 +607,23 @@ static int sync_fill_pt_info(struct sync_pt *pt, void *data, int size)
 
 	info->len = sizeof(struct sync_pt_info);
 
-	if (pt->parent->ops->fill_driver_data) {
-		ret = pt->parent->ops->fill_driver_data(pt, info->driver_data,
-							size - sizeof(*info));
+	if (fence->ops->fill_driver_data) {
+		ret = fence->ops->fill_driver_data(fence, info->driver_data,
+						   size - sizeof(*info));
 		if (ret < 0)
 			return ret;
 
 		info->len += ret;
 	}
 
-	strlcpy(info->obj_name, pt->parent->name, sizeof(info->obj_name));
-	strlcpy(info->driver_name, pt->parent->ops->driver_name,
+	strlcpy(info->obj_name, fence->ops->get_timeline_name(fence), sizeof(info->obj_name));
+	strlcpy(info->driver_name, fence->ops->get_driver_name(fence),
 		sizeof(info->driver_name));
-	info->status = pt->status;
-	info->timestamp_ns = ktime_to_ns(pt->timestamp);
+	if (fence_is_signaled(fence))
+		info->status = fence->status >= 0 ? 1 : fence->status;
+	else
+		info->status = 0;
+	info->timestamp_ns = ktime_to_ns(fence->timestamp);
 
 	return info->len;
 }
@@ -776,10 +632,9 @@ static long sync_fence_ioctl_fence_info(struct sync_fence *fence,
 					unsigned long arg)
 {
 	struct sync_fence_info_data *data;
-	struct list_head *pos;
 	__u32 size;
 	__u32 len = 0;
-	int ret;
+	int ret, i;
 
 	if (copy_from_user(&size, (void __user *)arg, sizeof(size)))
 		return -EFAULT;
@@ -795,12 +650,14 @@ static long sync_fence_ioctl_fence_info(struct sync_fence *fence,
 		return -ENOMEM;
 
 	strlcpy(data->name, fence->name, sizeof(data->name));
-	data->status = fence->status;
+	data->status = atomic_read(&fence->status);
+	if (data->status >= 0)
+		data->status = !data->status;
+
 	len = sizeof(struct sync_fence_info_data);
 
-	list_for_each(pos, &fence->pt_list_head) {
-		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, pt_list);
+	for (i = 0; i < fence->num_fences; ++i) {
+		struct fence *pt = fence->cbs[i].sync_pt;
 
 		ret = sync_fill_pt_info(pt, (u8 *)data + len, size - len);
 
@@ -842,176 +699,10 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 	}
 }
 
-#ifdef CONFIG_DEBUG_FS
-static const char *sync_status_str(int status)
-{
-	if (status > 0)
-		return "signaled";
-	else if (status == 0)
-		return "active";
-	else
-		return "error";
-}
-
-static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
-{
-	int status = pt->status;
-	seq_printf(s, "  %s%spt %s",
-		   fence ? pt->parent->name : "",
-		   fence ? "_" : "",
-		   sync_status_str(status));
-	if (pt->status) {
-		struct timeval tv = ktime_to_timeval(pt->timestamp);
-		seq_printf(s, "@%ld.%06ld", tv.tv_sec, tv.tv_usec);
-	}
-
-	if (pt->parent->ops->timeline_value_str &&
-	    pt->parent->ops->pt_value_str) {
-		char value[64];
-		pt->parent->ops->pt_value_str(pt, value, sizeof(value));
-		seq_printf(s, ": %s", value);
-		if (fence) {
-			pt->parent->ops->timeline_value_str(pt->parent, value,
-						    sizeof(value));
-			seq_printf(s, " / %s", value);
-		}
-	} else if (pt->parent->ops->print_pt) {
-		seq_puts(s, ": ");
-		pt->parent->ops->print_pt(s, pt);
-	}
-
-	seq_puts(s, "\n");
-}
-
-static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
-{
-	struct list_head *pos;
-	unsigned long flags;
-
-	seq_printf(s, "%s %s", obj->name, obj->ops->driver_name);
-
-	if (obj->ops->timeline_value_str) {
-		char value[64];
-		obj->ops->timeline_value_str(obj, value, sizeof(value));
-		seq_printf(s, ": %s", value);
-	} else if (obj->ops->print_obj) {
-		seq_puts(s, ": ");
-		obj->ops->print_obj(s, obj);
-	}
-
-	seq_puts(s, "\n");
-
-	spin_lock_irqsave(&obj->child_list_lock, flags);
-	list_for_each(pos, &obj->child_list_head) {
-		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, child_list);
-		sync_print_pt(s, pt, false);
-	}
-	spin_unlock_irqrestore(&obj->child_list_lock, flags);
-}
-
-static void sync_print_fence(struct seq_file *s, struct sync_fence *fence)
-{
-	struct list_head *pos;
-	unsigned long flags;
-
-	seq_printf(s, "[%p] %s: %s\n", fence, fence->name,
-		   sync_status_str(fence->status));
-
-	list_for_each(pos, &fence->pt_list_head) {
-		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, pt_list);
-		sync_print_pt(s, pt, true);
-	}
-
-	spin_lock_irqsave(&fence->waiter_list_lock, flags);
-	list_for_each(pos, &fence->waiter_list_head) {
-		struct sync_fence_waiter *waiter =
-			container_of(pos, struct sync_fence_waiter,
-				     waiter_list);
-
-		seq_printf(s, "waiter %pF\n", waiter->callback);
-	}
-	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
-}
-
-static int sync_debugfs_show(struct seq_file *s, void *unused)
-{
-	unsigned long flags;
-	struct list_head *pos;
-
-	seq_puts(s, "objs:\n--------------\n");
-
-	spin_lock_irqsave(&sync_timeline_list_lock, flags);
-	list_for_each(pos, &sync_timeline_list_head) {
-		struct sync_timeline *obj =
-			container_of(pos, struct sync_timeline,
-				     sync_timeline_list);
-
-		sync_print_obj(s, obj);
-		seq_puts(s, "\n");
-	}
-	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
-
-	seq_puts(s, "fences:\n--------------\n");
-
-	spin_lock_irqsave(&sync_fence_list_lock, flags);
-	list_for_each(pos, &sync_fence_list_head) {
-		struct sync_fence *fence =
-			container_of(pos, struct sync_fence, sync_fence_list);
-
-		sync_print_fence(s, fence);
-		seq_puts(s, "\n");
-	}
-	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
-	return 0;
-}
-
-static int sync_debugfs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sync_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations sync_debugfs_fops = {
-	.open           = sync_debugfs_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
+static const struct file_operations sync_fence_fops = {
+	.release = sync_fence_release,
+	.poll = sync_fence_poll,
+	.unlocked_ioctl = sync_fence_ioctl,
+	.compat_ioctl = sync_fence_ioctl,
 };
 
-static __init int sync_debugfs_init(void)
-{
-	debugfs_create_file("sync", S_IRUGO, NULL, NULL, &sync_debugfs_fops);
-	return 0;
-}
-late_initcall(sync_debugfs_init);
-
-#define DUMP_CHUNK 256
-static char sync_dump_buf[64 * 1024];
-static void sync_dump(void)
-{
-	struct seq_file s = {
-		.buf = sync_dump_buf,
-		.size = sizeof(sync_dump_buf) - 1,
-	};
-	int i;
-
-	sync_debugfs_show(&s, NULL);
-
-	for (i = 0; i < s.count; i += DUMP_CHUNK) {
-		if ((s.count - i) > DUMP_CHUNK) {
-			char c = s.buf[i + DUMP_CHUNK];
-			s.buf[i + DUMP_CHUNK] = 0;
-			pr_cont("%s", s.buf + i);
-			s.buf[i + DUMP_CHUNK] = c;
-		} else {
-			s.buf[s.count] = 0;
-			pr_cont("%s", s.buf + i);
-		}
-	}
-}
-#else
-static void sync_dump(void)
-{
-}
-#endif
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 38ea986dc70f..bcdd119402c0 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/fence.h>
 
 struct sync_timeline;
 struct sync_pt;
@@ -40,8 +41,6 @@ struct sync_fence;
  *			 -1 if a will signabl before b
  * @free_pt:		called before sync_pt is freed
  * @release_obj:	called before sync_timeline is freed
- * @print_obj:		deprecated
- * @print_pt:		deprecated
  * @fill_driver_data:	write implmentation specific driver data to data.
  *			  should return an error if there is not enough room
  *			  as specified by size.  This information is returned
@@ -67,13 +66,6 @@ struct sync_timeline_ops {
 	/* optional */
 	void (*release_obj)(struct sync_timeline *sync_timeline);
 
-	/* deprecated */
-	void (*print_obj)(struct seq_file *s,
-			  struct sync_timeline *sync_timeline);
-
-	/* deprecated */
-	void (*print_pt)(struct seq_file *s, struct sync_pt *sync_pt);
-
 	/* optional */
 	int (*fill_driver_data)(struct sync_pt *syncpt, void *data, int size);
 
@@ -90,7 +82,7 @@ struct sync_timeline_ops {
  * @kref:		reference count on fence.
  * @ops:		ops that define the implementaiton of the sync_timeline
  * @name:		name of the sync_timeline. Useful for debugging
- * @destoryed:		set when sync_timeline is destroyed
+ * @destroyed:		set when sync_timeline is destroyed
  * @child_list_head:	list of children sync_pts for this sync_timeline
  * @child_list_lock:	lock protecting @child_list_head, destroyed, and
  *			  sync_pt.status
@@ -104,42 +96,39 @@ struct sync_timeline {
 
 	/* protected by child_list_lock */
 	bool			destroyed;
+	int			context, value;
 
 	struct list_head	child_list_head;
 	spinlock_t		child_list_lock;
 
 	struct list_head	active_list_head;
-	spinlock_t		active_list_lock;
 
+#ifdef CONFIG_DEBUG_FS
 	struct list_head	sync_timeline_list;
+#endif
 };
 
 /**
  * struct sync_pt - sync point
- * @parent:		sync_timeline to which this sync_pt belongs
+ * @fence:		base fence class
  * @child_list:		membership in sync_timeline.child_list_head
  * @active_list:	membership in sync_timeline.active_list_head
- * @signaled_list:	membership in temorary signaled_list on stack
- * @fence:		sync_fence to which the sync_pt belongs
- * @pt_list:		membership in sync_fence.pt_list_head
- * @status:		1: signaled, 0:active, <0: error
- * @timestamp:		time which sync_pt status transitioned from active to
- *			  singaled or error.
  */
 struct sync_pt {
-	struct sync_timeline		*parent;
-	struct list_head	child_list;
+	struct fence base;
 
+	struct list_head	child_list;
 	struct list_head	active_list;
-	struct list_head	signaled_list;
-
-	struct sync_fence	*fence;
-	struct list_head	pt_list;
+};
 
-	/* protected by parent->active_list_lock */
-	int			status;
+static inline struct sync_timeline *sync_pt_parent(struct sync_pt *pt) {
+	return container_of(pt->base.lock, struct sync_timeline, child_list_lock);
+}
 
-	ktime_t			timestamp;
+struct sync_fence_cb {
+	struct fence_cb cb;
+	struct fence *sync_pt;
+	struct sync_fence *fence;
 };
 
 /**
@@ -149,9 +138,7 @@ struct sync_pt {
  * @name:		name of sync_fence.  Useful for debugging
  * @pt_list_head:	list of sync_pts in ths fence.  immutable once fence
  *			  is created
- * @waiter_list_head:	list of asynchronous waiters on this fence
- * @waiter_list_lock:	lock protecting @waiter_list_head and @status
- * @status:		1: signaled, 0:active, <0: error
+ * @status:		0: signaled, >0:active, <0: error
  *
  * @wq:			wait queue for fence signaling
  * @sync_fence_list:	membership in global fence list
@@ -160,17 +147,15 @@ struct sync_fence {
 	struct file		*file;
 	struct kref		kref;
 	char			name[32];
-
-	/* this list is immutable once the fence is created */
-	struct list_head	pt_list_head;
-
-	struct list_head	waiter_list_head;
-	spinlock_t		waiter_list_lock; /* also protects status */
-	int			status;
+#ifdef CONFIG_DEBUG_FS
+	struct list_head	sync_fence_list;
+#endif
+	int num_fences;
 
 	wait_queue_head_t	wq;
+	atomic_t		status;
 
-	struct list_head	sync_fence_list;
+	struct sync_fence_cb	cbs[];
 };
 
 struct sync_fence_waiter;
@@ -184,14 +169,14 @@ typedef void (*sync_callback_t)(struct sync_fence *fence,
  * @callback_data:	pointer to pass to @callback
  */
 struct sync_fence_waiter {
-	struct list_head	waiter_list;
-
-	sync_callback_t		callback;
+	wait_queue_t work;
+	sync_callback_t callback;
 };
 
 static inline void sync_fence_waiter_init(struct sync_fence_waiter *waiter,
 					  sync_callback_t callback)
 {
+	INIT_LIST_HEAD(&waiter->work.task_list);
 	waiter->callback = callback;
 }
 
@@ -423,4 +408,22 @@ struct sync_fence_info_data {
 #define SYNC_IOC_FENCE_INFO	_IOWR(SYNC_IOC_MAGIC, 2,\
 	struct sync_fence_info_data)
 
+#ifdef CONFIG_DEBUG_FS
+
+extern void sync_timeline_debug_add(struct sync_timeline *obj);
+extern void sync_timeline_debug_remove(struct sync_timeline *obj);
+extern void sync_fence_debug_add(struct sync_fence *fence);
+extern void sync_fence_debug_remove(struct sync_fence *fence);
+extern void sync_dump(void);
+
+#else
+# define sync_timeline_debug_add(obj)
+# define sync_timeline_debug_remove(obj)
+# define sync_fence_debug_add(fence)
+# define sync_fence_debug_remove(fence)
+# define sync_dump()
+#endif
+int sync_fence_wake_up_wq(wait_queue_t *curr, unsigned mode,
+				 int wake_flags, void *key);
+
 #endif /* _LINUX_SYNC_H */
diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
new file mode 100644
index 000000000000..2ef6496c7cd0
--- /dev/null
+++ b/drivers/staging/android/sync_debug.c
@@ -0,0 +1,245 @@
+/*
+ * drivers/base/sync.c
+ *
+ * Copyright (C) 2012 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/export.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/anon_inodes.h>
+#include "sync.h"
+
+#ifdef CONFIG_DEBUG_FS
+
+static LIST_HEAD(sync_timeline_list_head);
+static DEFINE_SPINLOCK(sync_timeline_list_lock);
+static LIST_HEAD(sync_fence_list_head);
+static DEFINE_SPINLOCK(sync_fence_list_lock);
+
+void sync_timeline_debug_add(struct sync_timeline *obj)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync_timeline_list_lock, flags);
+	list_add_tail(&obj->sync_timeline_list, &sync_timeline_list_head);
+	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
+}
+
+void sync_timeline_debug_remove(struct sync_timeline *obj)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync_timeline_list_lock, flags);
+	list_del(&obj->sync_timeline_list);
+	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
+}
+
+void sync_fence_debug_add(struct sync_fence *fence)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync_fence_list_lock, flags);
+	list_add_tail(&fence->sync_fence_list, &sync_fence_list_head);
+	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
+}
+
+void sync_fence_debug_remove(struct sync_fence *fence)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sync_fence_list_lock, flags);
+	list_del(&fence->sync_fence_list);
+	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
+}
+
+static const char *sync_status_str(int status)
+{
+	if (status == 0)
+		return "signaled";
+	else if (status > 0)
+		return "active";
+	else
+		return "error";
+}
+
+static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
+{
+	int status = 1;
+	struct sync_timeline *parent = sync_pt_parent(pt);
+
+	if (__fence_is_signaled(&pt->base))
+		status = pt->base.status;
+
+	seq_printf(s, "  %s%spt %s",
+		   fence ? parent->name : "",
+		   fence ? "_" : "",
+		   sync_status_str(status));
+
+	if (status <= 0) {
+		struct timeval tv = ktime_to_timeval(pt->base.timestamp);
+		seq_printf(s, "@%ld.%06ld", tv.tv_sec, tv.tv_usec);
+	}
+
+	if (parent->ops->timeline_value_str &&
+	    parent->ops->pt_value_str) {
+		char value[64];
+		parent->ops->pt_value_str(pt, value, sizeof(value));
+		seq_printf(s, ": %s", value);
+		if (fence) {
+			parent->ops->timeline_value_str(parent, value,
+						    sizeof(value));
+			seq_printf(s, " / %s", value);
+		}
+	}
+
+	seq_puts(s, "\n");
+}
+
+static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
+{
+	struct list_head *pos;
+	unsigned long flags;
+
+	seq_printf(s, "%s %s", obj->name, obj->ops->driver_name);
+
+	if (obj->ops->timeline_value_str) {
+		char value[64];
+		obj->ops->timeline_value_str(obj, value, sizeof(value));
+		seq_printf(s, ": %s", value);
+	}
+
+	seq_puts(s, "\n");
+
+	spin_lock_irqsave(&obj->child_list_lock, flags);
+	list_for_each(pos, &obj->child_list_head) {
+		struct sync_pt *pt =
+			container_of(pos, struct sync_pt, child_list);
+		sync_print_pt(s, pt, false);
+	}
+	spin_unlock_irqrestore(&obj->child_list_lock, flags);
+}
+
+static void sync_print_fence(struct seq_file *s, struct sync_fence *fence)
+{
+	wait_queue_t *pos;
+	unsigned long flags;
+	int i;
+
+	seq_printf(s, "[%p] %s: %s\n", fence, fence->name,
+		   sync_status_str(atomic_read(&fence->status)));
+
+	for (i = 0; i < fence->num_fences; ++i) {
+		struct sync_pt *pt =
+			container_of(fence->cbs[i].sync_pt, struct sync_pt, base);
+		sync_print_pt(s, pt, true);
+	}
+
+	spin_lock_irqsave(&fence->wq.lock, flags);
+	list_for_each_entry(pos, &fence->wq.task_list, task_list) {
+		struct sync_fence_waiter *waiter;
+
+		if (pos->func != &sync_fence_wake_up_wq)
+			continue;
+
+		waiter = container_of(pos, struct sync_fence_waiter, work);
+
+		seq_printf(s, "waiter %pF\n", waiter->callback);
+	}
+	spin_unlock_irqrestore(&fence->wq.lock, flags);
+}
+
+static int sync_debugfs_show(struct seq_file *s, void *unused)
+{
+	unsigned long flags;
+	struct list_head *pos;
+
+	seq_puts(s, "objs:\n--------------\n");
+
+	spin_lock_irqsave(&sync_timeline_list_lock, flags);
+	list_for_each(pos, &sync_timeline_list_head) {
+		struct sync_timeline *obj =
+			container_of(pos, struct sync_timeline,
+				     sync_timeline_list);
+
+		sync_print_obj(s, obj);
+		seq_puts(s, "\n");
+	}
+	spin_unlock_irqrestore(&sync_timeline_list_lock, flags);
+
+	seq_puts(s, "fences:\n--------------\n");
+
+	spin_lock_irqsave(&sync_fence_list_lock, flags);
+	list_for_each(pos, &sync_fence_list_head) {
+		struct sync_fence *fence =
+			container_of(pos, struct sync_fence, sync_fence_list);
+
+		sync_print_fence(s, fence);
+		seq_puts(s, "\n");
+	}
+	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
+	return 0;
+}
+
+static int sync_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sync_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations sync_debugfs_fops = {
+	.open           = sync_debugfs_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static __init int sync_debugfs_init(void)
+{
+	debugfs_create_file("sync", S_IRUGO, NULL, NULL, &sync_debugfs_fops);
+	return 0;
+}
+late_initcall(sync_debugfs_init);
+
+#define DUMP_CHUNK 256
+static char sync_dump_buf[64 * 1024];
+void sync_dump(void)
+{
+	struct seq_file s = {
+		.buf = sync_dump_buf,
+		.size = sizeof(sync_dump_buf) - 1,
+	};
+	int i;
+
+	sync_debugfs_show(&s, NULL);
+
+	for (i = 0; i < s.count; i += DUMP_CHUNK) {
+		if ((s.count - i) > DUMP_CHUNK) {
+			char c = s.buf[i + DUMP_CHUNK];
+			s.buf[i + DUMP_CHUNK] = 0;
+			pr_cont("%s", s.buf + i);
+			s.buf[i + DUMP_CHUNK] = c;
+		} else {
+			s.buf[s.count] = 0;
+			pr_cont("%s", s.buf + i);
+		}
+	}
+}
+
+#endif
diff --git a/drivers/staging/android/trace/sync.h b/drivers/staging/android/trace/sync.h
index 95462359ba57..77edb977a7bf 100644
--- a/drivers/staging/android/trace/sync.h
+++ b/drivers/staging/android/trace/sync.h
@@ -45,7 +45,7 @@ TRACE_EVENT(sync_wait,
 
 	TP_fast_assign(
 			__assign_str(name, fence->name);
-			__entry->status = fence->status;
+			__entry->status = atomic_read(&fence->status);
 			__entry->begin = begin;
 	),
 
@@ -54,19 +54,19 @@ TRACE_EVENT(sync_wait,
 );
 
 TRACE_EVENT(sync_pt,
-	TP_PROTO(struct sync_pt *pt),
+	TP_PROTO(struct fence *pt),
 
 	TP_ARGS(pt),
 
 	TP_STRUCT__entry(
-		__string(timeline, pt->parent->name)
+		__string(timeline, pt->ops->get_timeline_name(pt))
 		__array(char, value, 32)
 	),
 
 	TP_fast_assign(
-		__assign_str(timeline, pt->parent->name);
-		if (pt->parent->ops->pt_value_str) {
-			pt->parent->ops->pt_value_str(pt, __entry->value,
+		__assign_str(timeline, pt->ops->get_timeline_name(pt));
+		if (pt->ops->fence_value_str) {
+			pt->ops->fence_value_str(pt, __entry->value,
 							sizeof(__entry->value));
 		} else {
 			__entry->value[0] = '\0';

