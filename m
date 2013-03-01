Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3CAAoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:07 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32939 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3CAAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:05 -0500
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
Subject: [PATCH 16/30] staging: sync: Fix error paths
Date: Thu, 28 Feb 2013 16:43:12 -0800
Message-Id: <1362098606-26469-17-git-send-email-john.stultz@linaro.org>
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
 drivers/staging/android/sync.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 61c27bd..c4a3c1d 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -647,8 +647,13 @@ static long sync_fence_ioctl_merge(struct sync_fence *fence, unsigned long arg)
 	struct sync_fence *fence2, *fence3;
 	struct sync_merge_data data;
 
-	if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
-		return -EFAULT;
+	if (fd < 0)
+		return fd;
+
+	if (copy_from_user(&data, (void __user *)arg, sizeof(data))) {
+		err = -EFAULT;
+		goto err_put_fd;
+	}
 
 	fence2 = sync_fence_fdget(data.fd2);
 	if (fence2 == NULL) {
-- 
1.7.10.4

