Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3CAAuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:50:20 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47502 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3CAAnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 08/30] staging: sync: Add poll support
Date: Thu, 28 Feb 2013 16:43:04 -0800
Message-Id: <1362098606-26469-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Support poll on sync fence

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Add commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index f84caad..9e35ea3 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -18,6 +18,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
+#include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -221,12 +222,14 @@ out:
 }
 
 static int sync_fence_release(struct inode *inode, struct file *file);
+static unsigned int sync_fence_poll(struct file *file, poll_table *wait);
 static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg);
 
 
 static const struct file_operations sync_fence_fops = {
 	.release = sync_fence_release,
+	.poll = sync_fence_poll,
 	.unlocked_ioctl = sync_fence_ioctl,
 };
 
@@ -497,6 +500,20 @@ static int sync_fence_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static unsigned int sync_fence_poll(struct file *file, poll_table *wait)
+{
+	struct sync_fence *fence = file->private_data;
+
+	poll_wait(file, &fence->wq, wait);
+
+	if (fence->status == 1)
+		return POLLIN;
+	else if (fence->status < 0)
+		return POLLERR;
+	else
+		return 0;
+}
+
 static long sync_fence_ioctl_wait(struct sync_fence *fence, unsigned long arg)
 {
 	__s32 value;
-- 
1.7.10.4

