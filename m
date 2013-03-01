Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3CAAq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:46:58 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50980 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3CAAoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 22/30] staging: sync: Protect unlocked access to fence status
Date: Thu, 28 Feb 2013 16:43:18 -0800
Message-Id: <1362098606-26469-23-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Fence status is checked outside of locks in both sync_fence_wait and
sync_fence_poll.  This patch adds propper barrier protection in these
cases to avoid seeing stale status.

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
 drivers/staging/android/sync.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 36ffa20..2394189 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -556,6 +556,16 @@ int sync_fence_cancel_async(struct sync_fence *fence,
 }
 EXPORT_SYMBOL(sync_fence_cancel_async);
 
+static bool sync_fence_check(struct sync_fence *fence)
+{
+	/*
+	 * Make sure that reads to fence->status are ordered with the
+	 * wait queue event triggering
+	 */
+	smp_rmb();
+	return fence->status != 0;
+}
+
 int sync_fence_wait(struct sync_fence *fence, long timeout)
 {
 	int err = 0;
@@ -563,7 +573,7 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 	if (timeout > 0) {
 		timeout = msecs_to_jiffies(timeout);
 		err = wait_event_interruptible_timeout(fence->wq,
-						       fence->status != 0,
+						       sync_fence_check(fence),
 						       timeout);
 	} else if (timeout < 0) {
 		err = wait_event_interruptible(fence->wq, fence->status != 0);
@@ -630,6 +640,12 @@ static unsigned int sync_fence_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &fence->wq, wait);
 
+	/*
+	 * Make sure that reads to fence->status are ordered with the
+	 * wait queue event triggering
+	 */
+	smp_rmb();
+
 	if (fence->status == 1)
 		return POLLIN;
 	else if (fence->status < 0)
-- 
1.7.10.4

