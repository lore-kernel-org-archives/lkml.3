Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3CAAoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:20 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52417 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3CAAoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:16 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 23/30] staging: sync: Update new fence status with sync_fence_signal_pt
Date: Thu, 28 Feb 2013 16:43:19 -0800
Message-Id: <1362098606-26469-24-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

If a fence's pt is signaled before sync_fence_create is called, the fence
will never transition into the signaled state.  This also address a tiny
race if a merged fence's pt after sync_fence_get_status checks it's status
and before fence->status is updated.

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
 drivers/staging/android/sync.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 2394189..889ca6e 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -295,6 +295,12 @@ struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
 	list_add(&pt->pt_list, &fence->pt_list_head);
 	sync_pt_activate(pt);
 
+	/*
+	 * signal the fence in case pt was activated before
+	 * sync_pt_activate(pt) was called
+	 */
+	sync_fence_signal_pt(pt);
+
 	return fence;
 }
 EXPORT_SYMBOL(sync_fence_create);
@@ -457,7 +463,13 @@ struct sync_fence *sync_fence_merge(const char *name,
 	if (err < 0)
 		goto err;
 
-	fence->status = sync_fence_get_status(fence);
+	/*
+	 * signal the fence in case one of it's pts were activated before
+	 * they were activated
+	 */
+	sync_fence_signal_pt(list_first_entry(&fence->pt_list_head,
+					      struct sync_pt,
+					      pt_list));
 
 	return fence;
 err:
-- 
1.7.10.4

