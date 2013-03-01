Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3CAAty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:49:54 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54863 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3CAAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 09/30] staging: sync: Allow async waits to be canceled
Date: Thu, 28 Feb 2013 16:43:05 -0800
Message-Id: <1362098606-26469-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

In order to allow drivers to cleanly handled teardown we need to allow them
to cancel pending async waits.  To do this cleanly, we move allocation of
sync_fence_waiter to the driver calling sync_async_wait().

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
 drivers/staging/android/sync.c |   46 +++++++++++++++++++++++++++-------------
 drivers/staging/android/sync.h |   36 +++++++++++++++++++++++++------
 2 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 9e35ea3..54f84d9 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -421,33 +421,22 @@ static void sync_fence_signal_pt(struct sync_pt *pt)
 				container_of(pos, struct sync_fence_waiter,
 					     waiter_list);
 
-			waiter->callback(fence, waiter->callback_data);
 			list_del(pos);
-			kfree(waiter);
+			waiter->callback(fence, waiter);
 		}
 		wake_up(&fence->wq);
 	}
 }
 
 int sync_fence_wait_async(struct sync_fence *fence,
-			  void (*callback)(struct sync_fence *, void *data),
-			  void *callback_data)
+			  struct sync_fence_waiter *waiter)
 {
-	struct sync_fence_waiter *waiter;
 	unsigned long flags;
 	int err = 0;
 
-	waiter = kzalloc(sizeof(struct sync_fence_waiter), GFP_KERNEL);
-	if (waiter == NULL)
-		return -ENOMEM;
-
-	waiter->callback = callback;
-	waiter->callback_data = callback_data;
-
 	spin_lock_irqsave(&fence->waiter_list_lock, flags);
 
 	if (fence->status) {
-		kfree(waiter);
 		err = fence->status;
 		goto out;
 	}
@@ -459,6 +448,34 @@ out:
 	return err;
 }
 
+int sync_fence_cancel_async(struct sync_fence *fence,
+			     struct sync_fence_waiter *waiter)
+{
+	struct list_head *pos;
+	struct list_head *n;
+	unsigned long flags;
+	int ret = -ENOENT;
+
+	spin_lock_irqsave(&fence->waiter_list_lock, flags);
+	/*
+	 * Make sure waiter is still in waiter_list because it is possible for
+	 * the waiter to be removed from the list while the callback is still
+	 * pending.
+	 */
+	list_for_each_safe(pos, n, &fence->waiter_list_head) {
+		struct sync_fence_waiter *list_waiter =
+			container_of(pos, struct sync_fence_waiter,
+				     waiter_list);
+		if (list_waiter == waiter) {
+			list_del(pos);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
+	return ret;
+}
+
 int sync_fence_wait(struct sync_fence *fence, long timeout)
 {
 	int err;
@@ -739,8 +756,7 @@ static void sync_print_fence(struct seq_file *s, struct sync_fence *fence)
 			container_of(pos, struct sync_fence_waiter,
 				     waiter_list);
 
-		seq_printf(s, "waiter %pF %p\n", waiter->callback,
-			   waiter->callback_data);
+		seq_printf(s, "waiter %pF\n", waiter->callback);
 	}
 	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
 }
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 4f19938..943f414 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -159,6 +159,10 @@ struct sync_fence {
 	struct list_head	sync_fence_list;
 };
 
+struct sync_fence_waiter;
+typedef void (*sync_callback_t)(struct sync_fence *fence,
+				struct sync_fence_waiter *waiter);
+
 /**
  * struct sync_fence_waiter - metadata for asynchronous waiter on a fence
  * @waiter_list:	membership in sync_fence.waiter_list_head
@@ -168,10 +172,15 @@ struct sync_fence {
 struct sync_fence_waiter {
 	struct list_head	waiter_list;
 
-	void (*callback)(struct sync_fence *fence, void *data);
-	void *callback_data;
+	sync_callback_t		callback;
 };
 
+static inline void sync_fence_waiter_init(struct sync_fence_waiter *waiter,
+					  sync_callback_t callback)
+{
+	waiter->callback = callback;
+}
+
 /*
  * API for sync_timeline implementers
  */
@@ -284,16 +293,29 @@ void sync_fence_install(struct sync_fence *fence, int fd);
 /**
  * sync_fence_wait_async() - registers and async wait on the fence
  * @fence:		fence to wait on
- * @callback:		callback
- * @callback_data	data to pass to the callback
+ * @waiter:		waiter callback struck
  *
  * Returns 1 if @fence has already signaled.
  *
- * Registers a callback to be called when @fence signals or has an error
+ * Registers a callback to be called when @fence signals or has an error.
+ * @waiter should be initialized with sync_fence_waiter_init().
  */
 int sync_fence_wait_async(struct sync_fence *fence,
-			  void (*callback)(struct sync_fence *, void *data),
-			  void *callback_data);
+			  struct sync_fence_waiter *waiter);
+
+/**
+ * sync_fence_cancel_async() - cancels an async wait
+ * @fence:		fence to wait on
+ * @waiter:		waiter callback struck
+ *
+ * returns 0 if waiter was removed from fence's async waiter list.
+ * returns -ENOENT if waiter was not found on fence's async waiter list.
+ *
+ * Cancels a previously registered async wait.  Will fail gracefully if
+ * @waiter was never registered or if @fence has already signaled @waiter.
+ */
+int sync_fence_cancel_async(struct sync_fence *fence,
+			    struct sync_fence_waiter *waiter);
 
 /**
  * sync_fence_wait() - wait on fence
-- 
1.7.10.4

