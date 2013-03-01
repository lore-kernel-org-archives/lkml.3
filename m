Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3CAAs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:48:56 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:38162 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3CAAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 13/30] staging: sync: Optimize fence merges
Date: Thu, 28 Feb 2013 16:43:09 -0800
Message-Id: <1362098606-26469-14-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

If the two fences being merged contain sync_pts from the same timeline,
those two pts will be collapsed into a single pt representing the latter
of the two.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Whitespace fixes]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   52 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 2afbd69..6cb7c88 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -312,6 +312,56 @@ static int sync_fence_copy_pts(struct sync_fence *dst, struct sync_fence *src)
 	return 0;
 }
 
+static int sync_fence_merge_pts(struct sync_fence *dst, struct sync_fence *src)
+{
+	struct list_head *src_pos, *dst_pos, *n;
+
+	list_for_each(src_pos, &src->pt_list_head) {
+		struct sync_pt *src_pt =
+			container_of(src_pos, struct sync_pt, pt_list);
+		bool collapsed = false;
+
+		list_for_each_safe(dst_pos, n, &dst->pt_list_head) {
+			struct sync_pt *dst_pt =
+				container_of(dst_pos, struct sync_pt, pt_list);
+			/* collapse two sync_pts on the same timeline
+			 * to a single sync_pt that will signal at
+			 * the later of the two
+			 */
+			if (dst_pt->parent == src_pt->parent) {
+				if (dst_pt->parent->ops->compare(dst_pt, src_pt)
+						 == -1) {
+					struct sync_pt *new_pt =
+						sync_pt_dup(src_pt);
+					if (new_pt == NULL)
+						return -ENOMEM;
+
+					new_pt->fence = dst;
+					list_replace(&dst_pt->pt_list,
+						     &new_pt->pt_list);
+					sync_pt_activate(new_pt);
+					sync_pt_free(dst_pt);
+				}
+				collapsed = true;
+				break;
+			}
+		}
+
+		if (!collapsed) {
+			struct sync_pt *new_pt = sync_pt_dup(src_pt);
+
+			if (new_pt == NULL)
+				return -ENOMEM;
+
+			new_pt->fence = dst;
+			list_add(&new_pt->pt_list, &dst->pt_list_head);
+			sync_pt_activate(new_pt);
+		}
+	}
+
+	return 0;
+}
+
 static void sync_fence_free_pts(struct sync_fence *fence)
 {
 	struct list_head *pos, *n;
@@ -386,7 +436,7 @@ struct sync_fence *sync_fence_merge(const char *name,
 	if (err < 0)
 		goto err;
 
-	err = sync_fence_copy_pts(fence, b);
+	err = sync_fence_merge_pts(fence, b);
 	if (err < 0)
 		goto err;
 
-- 
1.7.10.4

