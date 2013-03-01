Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3CAAsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:48:22 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45000 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3CAAoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 15/30] staging: sync: Add reference counting to timelines
Date: Thu, 28 Feb 2013 16:43:11 -0800
Message-Id: <1362098606-26469-16-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

If a timeline is destroyed while fences still hold pts on it, the reworked
fence release handler can cause the timeline to be freed before all it's points
are freed.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Squished in compiler warning fix]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   29 +++++++++++++----------------
 drivers/staging/android/sync.h |    2 ++
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 7d4e9aa..61c27bd 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -51,6 +51,7 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
 	if (obj == NULL)
 		return NULL;
 
+	kref_init(&obj->kref);
 	obj->ops = ops;
 	strlcpy(obj->name, name, sizeof(obj->name));
 
@@ -68,8 +69,10 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
 }
 EXPORT_SYMBOL(sync_timeline_create);
 
-static void sync_timeline_free(struct sync_timeline *obj)
+static void sync_timeline_free(struct kref *kref)
 {
+	struct sync_timeline *obj =
+		container_of(kref, struct sync_timeline, kref);
 	unsigned long flags;
 
 	if (obj->ops->release_obj)
@@ -84,17 +87,14 @@ static void sync_timeline_free(struct sync_timeline *obj)
 
 void sync_timeline_destroy(struct sync_timeline *obj)
 {
-	unsigned long flags;
-	bool needs_freeing;
-
-	spin_lock_irqsave(&obj->child_list_lock, flags);
 	obj->destroyed = true;
-	needs_freeing = list_empty(&obj->child_list_head);
-	spin_unlock_irqrestore(&obj->child_list_lock, flags);
 
-	if (needs_freeing)
-		sync_timeline_free(obj);
-	else
+	/*
+	 * If this is not the last reference, signal any children
+	 * that their parent is going away.
+	 */
+
+	if (!kref_put(&obj->kref, sync_timeline_free))
 		sync_timeline_signal(obj);
 }
 EXPORT_SYMBOL(sync_timeline_destroy);
@@ -114,7 +114,6 @@ static void sync_timeline_remove_pt(struct sync_pt *pt)
 {
 	struct sync_timeline *obj = pt->parent;
 	unsigned long flags;
-	bool needs_freeing = false;
 
 	spin_lock_irqsave(&obj->active_list_lock, flags);
 	if (!list_empty(&pt->active_list))
@@ -124,13 +123,8 @@ static void sync_timeline_remove_pt(struct sync_pt *pt)
 	spin_lock_irqsave(&obj->child_list_lock, flags);
 	if (!list_empty(&pt->child_list)) {
 		list_del_init(&pt->child_list);
-		needs_freeing = obj->destroyed &&
-			list_empty(&obj->child_list_head);
 	}
 	spin_unlock_irqrestore(&obj->child_list_lock, flags);
-
-	if (needs_freeing)
-		sync_timeline_free(obj);
 }
 
 void sync_timeline_signal(struct sync_timeline *obj)
@@ -177,6 +171,7 @@ struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
 		return NULL;
 
 	INIT_LIST_HEAD(&pt->active_list);
+	kref_get(&parent->kref);
 	sync_timeline_add_pt(parent, pt);
 
 	return pt;
@@ -190,6 +185,8 @@ void sync_pt_free(struct sync_pt *pt)
 
 	sync_timeline_remove_pt(pt);
 
+	kref_put(&pt->parent->kref, sync_timeline_free);
+
 	kfree(pt);
 }
 EXPORT_SYMBOL(sync_pt_free);
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 00c9bae..15863a6 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -80,6 +80,7 @@ struct sync_timeline_ops {
 
 /**
  * struct sync_timeline - sync object
+ * @kref:		reference count on fence.
  * @ops:		ops that define the implementaiton of the sync_timeline
  * @name:		name of the sync_timeline. Useful for debugging
  * @destoryed:		set when sync_timeline is destroyed
@@ -90,6 +91,7 @@ struct sync_timeline_ops {
  * @sync_timeline_list:	membership in global sync_timeline_list
  */
 struct sync_timeline {
+	struct kref		kref;
 	const struct sync_timeline_ops	*ops;
 	char			name[32];
 
-- 
1.7.10.4

