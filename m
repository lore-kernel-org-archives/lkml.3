Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3CAAvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:51:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52816 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3CAAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:45 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/30] staging: sync: Add timestamps to sync_pts
Date: Thu, 28 Feb 2013 16:42:59 -0800
Message-Id: <1362098606-26469-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Add ktime timestamps to sync_pt structure and
update them when signaled

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Added commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |    5 +++++
 drivers/staging/android/sync.h |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 4a9e63d..88d7e66 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -155,12 +155,17 @@ void sync_pt_free(struct sync_pt *pt)
 /* call with pt->parent->active_list_lock held */
 static int _sync_pt_has_signaled(struct sync_pt *pt)
 {
+	int old_status = pt->status;
+
 	if (!pt->status)
 		pt->status = pt->parent->ops->has_signaled(pt);
 
 	if (!pt->status && pt->parent->destroyed)
 		pt->status = -ENOENT;
 
+	if (pt->status != old_status)
+		pt->timestamp = ktime_get();
+
 	return pt->status;
 }
 
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 388acd1..a8e289d 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #ifdef __KERNEL__
 
+#include <linux/ktime.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
@@ -90,6 +91,8 @@ struct sync_timeline {
  * @fence:		sync_fence to which the sync_pt belongs
  * @pt_list:		membership in sync_fence.pt_list_head
  * @status:		1: signaled, 0:active, <0: error
+ * @timestamp:		time which sync_pt status transitioned from active to
+ *			  singaled or error.
  */
 struct sync_pt {
 	struct sync_timeline		*parent;
@@ -102,6 +105,8 @@ struct sync_pt {
 
 	/* protected by parent->active_list_lock */
 	int			status;
+
+	ktime_t			timestamp;
 };
 
 /**
-- 
1.7.10.4

