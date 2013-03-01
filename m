Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3CAAoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:15 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61006 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3CAAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:09 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 18/30] staging: sync: Change wait timeout to mirror poll semantics
Date: Thu, 28 Feb 2013 16:43:14 -0800
Message-Id: <1362098606-26469-19-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Change wait timeout to act like poll

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Added commit message, squished typo-fix]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |    6 +++---
 drivers/staging/android/sync.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index c4a3c1d..7fccfcd 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -557,14 +557,14 @@ EXPORT_SYMBOL(sync_fence_cancel_async);
 
 int sync_fence_wait(struct sync_fence *fence, long timeout)
 {
-	int err;
+	int err = 0;
 
-	if (timeout) {
+	if (timeout > 0) {
 		timeout = msecs_to_jiffies(timeout);
 		err = wait_event_interruptible_timeout(fence->wq,
 						       fence->status != 0,
 						       timeout);
-	} else {
+	} else if (timeout < 0) {
 		err = wait_event_interruptible(fence->wq, fence->status != 0);
 	}
 
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 15863a6..75ed5f1 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -329,8 +329,8 @@ int sync_fence_cancel_async(struct sync_fence *fence,
  * @fence:	fence to wait on
  * @tiemout:	timeout in ms
  *
- * Wait for @fence to be signaled or have an error.  Waits indefintly
- * if @timeout = 0
+ * Wait for @fence to be signaled or have an error.  Waits indefinitely
+ * if @timeout < 0
  */
 int sync_fence_wait(struct sync_fence *fence, long timeout);
 
@@ -389,9 +389,9 @@ struct sync_fence_info_data {
 /**
  * DOC: SYNC_IOC_WAIT - wait for a fence to signal
  *
- * pass timeout in milliseconds.
+ * pass timeout in milliseconds.  Waits indefinitely timeout < 0.
  */
-#define SYNC_IOC_WAIT		_IOW(SYNC_IOC_MAGIC, 0, __u32)
+#define SYNC_IOC_WAIT		_IOW(SYNC_IOC_MAGIC, 0, __s32)
 
 /**
  * DOC: SYNC_IOC_MERGE - merge two fences
-- 
1.7.10.4

