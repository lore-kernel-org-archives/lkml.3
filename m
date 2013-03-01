Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3CAArx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:47:53 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:39854 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3CAAoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Rebecca Schultz Zavin <rebecca@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 17/30] staging: sw_sync: Fix error paths
Date: Thu, 28 Feb 2013 16:43:13 -0800
Message-Id: <1362098606-26469-18-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Check the return value of get_unused_fd to make sure a valid
file descriptor is returned.

Make sure to call put_unused_fd even if an error occurs before
the fd can be used.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sw_sync.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index d689760..d768893 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -170,8 +170,13 @@ long sw_sync_ioctl_create_fence(struct sw_sync_timeline *obj, unsigned long arg)
 	struct sync_fence *fence;
 	struct sw_sync_create_fence_data data;
 
-	if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
-		return -EFAULT;
+	if (fd < 0)
+		return fd;
+
+	if (copy_from_user(&data, (void __user *)arg, sizeof(data))) {
+		err = -EFAULT;
+		goto err;
+	}
 
 	pt = sw_sync_pt_create(obj, data.value);
 	if (pt == NULL) {
-- 
1.7.10.4

