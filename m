Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3CAAo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:29 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:63592 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3CAAoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:24 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?=C3=98rjan=20Eide?= <orjan.eide@arm.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 28/30] staging: sync: Fix race condition between merge and signal
Date: Thu, 28 Feb 2013 16:43:24 -0800
Message-Id: <1362098606-26469-29-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ørjan Eide <orjan.eide@arm.com>

The copied sync_pt was activated immediately. If the sync_pt was
signaled before the entire merge was completed, the new fence's pt_list
could be iterated over while it is still in the process of being
created.

Moving the the sync_pt_activate call for all new sync_pts to after both
the sync_fence_copy_pts and the sync_fence_merge_pts calls ensure that
the pt_list is complete and immutable before it can be reached from the
timeline's active list.

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
 drivers/staging/android/sync.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 1ddc404..bd18c75 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -324,7 +324,6 @@ static int sync_fence_copy_pts(struct sync_fence *dst, struct sync_fence *src)
 
 		new_pt->fence = dst;
 		list_add(&new_pt->pt_list, &dst->pt_list_head);
-		sync_pt_activate(new_pt);
 	}
 
 	return 0;
@@ -357,7 +356,6 @@ static int sync_fence_merge_pts(struct sync_fence *dst, struct sync_fence *src)
 					new_pt->fence = dst;
 					list_replace(&dst_pt->pt_list,
 						     &new_pt->pt_list);
-					sync_pt_activate(new_pt);
 					sync_pt_free(dst_pt);
 				}
 				collapsed = true;
@@ -373,7 +371,6 @@ static int sync_fence_merge_pts(struct sync_fence *dst, struct sync_fence *src)
 
 			new_pt->fence = dst;
 			list_add(&new_pt->pt_list, &dst->pt_list_head);
-			sync_pt_activate(new_pt);
 		}
 	}
 
@@ -454,6 +451,7 @@ struct sync_fence *sync_fence_merge(const char *name,
 				    struct sync_fence *a, struct sync_fence *b)
 {
 	struct sync_fence *fence;
+	struct list_head *pos;
 	int err;
 
 	fence = sync_fence_alloc(name);
@@ -468,6 +466,12 @@ struct sync_fence *sync_fence_merge(const char *name,
 	if (err < 0)
 		goto err;
 
+	list_for_each(pos, &fence->pt_list_head) {
+		struct sync_pt *pt =
+			container_of(pos, struct sync_pt, pt_list);
+		sync_pt_activate(pt);
+	}
+
 	/*
 	 * signal the fence in case one of it's pts were activated before
 	 * they were activated
-- 
1.7.10.4

