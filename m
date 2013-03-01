Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3CAAsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:48:37 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52216 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3CAAoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:01 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 14/30] staging: sync: Add internal refcounting to fences
Date: Thu, 28 Feb 2013 16:43:10 -0800
Message-Id: <1362098606-26469-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

If a fence is released while a timeline that one of it's pts is on is being
signaled, it is possible for that fence to be deleted before it is signaled.
This patch adds a refcount for internal references such as signaled pt
processing.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   54 ++++++++++++++++++++++++++++++++++------
 drivers/staging/android/sync.h |    5 ++++
 2 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 6cb7c88..7d4e9aa 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -30,6 +30,7 @@
 
 static void sync_fence_signal_pt(struct sync_pt *pt);
 static int _sync_pt_has_signaled(struct sync_pt *pt);
+static void sync_fence_free(struct kref *kref);
 
 static LIST_HEAD(sync_timeline_list_head);
 static DEFINE_SPINLOCK(sync_timeline_list_lock);
@@ -113,7 +114,7 @@ static void sync_timeline_remove_pt(struct sync_pt *pt)
 {
 	struct sync_timeline *obj = pt->parent;
 	unsigned long flags;
-	bool needs_freeing;
+	bool needs_freeing = false;
 
 	spin_lock_irqsave(&obj->active_list_lock, flags);
 	if (!list_empty(&pt->active_list))
@@ -121,8 +122,11 @@ static void sync_timeline_remove_pt(struct sync_pt *pt)
 	spin_unlock_irqrestore(&obj->active_list_lock, flags);
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
-	list_del(&pt->child_list);
-	needs_freeing = obj->destroyed && list_empty(&obj->child_list_head);
+	if (!list_empty(&pt->child_list)) {
+		list_del_init(&pt->child_list);
+		needs_freeing = obj->destroyed &&
+			list_empty(&obj->child_list_head);
+	}
 	spin_unlock_irqrestore(&obj->child_list_lock, flags);
 
 	if (needs_freeing)
@@ -141,18 +145,22 @@ void sync_timeline_signal(struct sync_timeline *obj)
 		struct sync_pt *pt =
 			container_of(pos, struct sync_pt, active_list);
 
-		if (_sync_pt_has_signaled(pt))
-			list_move(pos, &signaled_pts);
+		if (_sync_pt_has_signaled(pt)) {
+			list_del_init(pos);
+			list_add(&pt->signaled_list, &signaled_pts);
+			kref_get(&pt->fence->kref);
+		}
 	}
 
 	spin_unlock_irqrestore(&obj->active_list_lock, flags);
 
 	list_for_each_safe(pos, n, &signaled_pts) {
 		struct sync_pt *pt =
-			container_of(pos, struct sync_pt, active_list);
+			container_of(pos, struct sync_pt, signaled_list);
 
 		list_del_init(pos);
 		sync_fence_signal_pt(pt);
+		kref_put(&pt->fence->kref, sync_fence_free);
 	}
 }
 EXPORT_SYMBOL(sync_timeline_signal);
@@ -253,6 +261,7 @@ static struct sync_fence *sync_fence_alloc(const char *name)
 	if (fence->file == NULL)
 		goto err;
 
+	kref_init(&fence->kref);
 	strlcpy(fence->name, name, sizeof(fence->name));
 
 	INIT_LIST_HEAD(&fence->pt_list_head);
@@ -362,6 +371,16 @@ static int sync_fence_merge_pts(struct sync_fence *dst, struct sync_fence *src)
 	return 0;
 }
 
+static void sync_fence_detach_pts(struct sync_fence *fence)
+{
+	struct list_head *pos, *n;
+
+	list_for_each_safe(pos, n, &fence->pt_list_head) {
+		struct sync_pt *pt = container_of(pos, struct sync_pt, pt_list);
+		sync_timeline_remove_pt(pt);
+	}
+}
+
 static void sync_fence_free_pts(struct sync_fence *fence)
 {
 	struct list_head *pos, *n;
@@ -565,18 +584,37 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 }
 EXPORT_SYMBOL(sync_fence_wait);
 
+static void sync_fence_free(struct kref *kref)
+{
+	struct sync_fence *fence = container_of(kref, struct sync_fence, kref);
+
+	sync_fence_free_pts(fence);
+
+	kfree(fence);
+}
+
 static int sync_fence_release(struct inode *inode, struct file *file)
 {
 	struct sync_fence *fence = file->private_data;
 	unsigned long flags;
 
+	/*
+	 * We need to remove all ways to access this fence before droping
+	 * our ref.
+	 *
+	 * start with its membership in the global fence list
+	 */
 	spin_lock_irqsave(&sync_fence_list_lock, flags);
 	list_del(&fence->sync_fence_list);
 	spin_unlock_irqrestore(&sync_fence_list_lock, flags);
 
-	sync_fence_free_pts(fence);
+	/*
+	 * remove its pts from their parents so that sync_timeline_signal()
+	 * can't reference the fence.
+	 */
+	sync_fence_detach_pts(fence);
 
-	kfree(fence);
+	kref_put(&fence->kref, sync_fence_free);
 
 	return 0;
 }
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 943f414..00c9bae 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #ifdef __KERNEL__
 
+#include <linux/kref.h>
 #include <linux/ktime.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -109,6 +110,7 @@ struct sync_timeline {
  * @parent:		sync_timeline to which this sync_pt belongs
  * @child_list:		membership in sync_timeline.child_list_head
  * @active_list:	membership in sync_timeline.active_list_head
+ * @signaled_list:	membership in temorary signaled_list on stack
  * @fence:		sync_fence to which the sync_pt belongs
  * @pt_list:		membership in sync_fence.pt_list_head
  * @status:		1: signaled, 0:active, <0: error
@@ -120,6 +122,7 @@ struct sync_pt {
 	struct list_head	child_list;
 
 	struct list_head	active_list;
+	struct list_head	signaled_list;
 
 	struct sync_fence	*fence;
 	struct list_head	pt_list;
@@ -133,6 +136,7 @@ struct sync_pt {
 /**
  * struct sync_fence - sync fence
  * @file:		file representing this fence
+ * @kref:		referenace count on fence.
  * @name:		name of sync_fence.  Useful for debugging
  * @pt_list_head:	list of sync_pts in ths fence.  immutable once fence
  *			  is created
@@ -145,6 +149,7 @@ struct sync_pt {
  */
 struct sync_fence {
 	struct file		*file;
+	struct kref		kref;
 	char			name[32];
 
 	/* this list is immutable once the fence is created */
-- 
1.7.10.4

