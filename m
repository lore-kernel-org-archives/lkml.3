Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3CAAoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:13 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41290 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3CAAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:10 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 19/30] staging: sync: Dump sync state to console on timeout
Date: Thu, 28 Feb 2013 16:43:15 -0800
Message-Id: <1362098606-26469-20-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

If we hit a timeout, dump sync state to console

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Add commit message, whitespace fixups]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 7fccfcd..d54fa8d 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -31,6 +31,7 @@
 static void sync_fence_signal_pt(struct sync_pt *pt);
 static int _sync_pt_has_signaled(struct sync_pt *pt);
 static void sync_fence_free(struct kref *kref);
+static void sync_dump(void);
 
 static LIST_HEAD(sync_timeline_list_head);
 static DEFINE_SPINLOCK(sync_timeline_list_lock);
@@ -574,8 +575,10 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 	if (fence->status < 0)
 		return fence->status;
 
-	if (fence->status == 0)
+	if (fence->status == 0) {
+		sync_dump();
 		return -ETIME;
+	}
 
 	return 0;
 }
@@ -914,7 +917,34 @@ static __init int sync_debugfs_init(void)
 	debugfs_create_file("sync", S_IRUGO, NULL, NULL, &sync_debugfs_fops);
 	return 0;
 }
-
 late_initcall(sync_debugfs_init);
 
+#define DUMP_CHUNK 256
+static char sync_dump_buf[64 * 1024];
+void sync_dump(void)
+{
+	struct seq_file s = {
+		.buf = sync_dump_buf,
+		.size = sizeof(sync_dump_buf) - 1,
+	};
+	int i;
+
+	sync_debugfs_show(&s, NULL);
+
+	for (i = 0; i < s.count; i += DUMP_CHUNK) {
+		if ((s.count - i) > DUMP_CHUNK) {
+			char c = s.buf[i + DUMP_CHUNK];
+			s.buf[i + DUMP_CHUNK] = 0;
+			pr_cont("%s", s.buf + i);
+			s.buf[i + DUMP_CHUNK] = c;
+		} else {
+			s.buf[s.count] = 0;
+			pr_cont("%s", s.buf + i);
+		}
+	}
+}
+#else
+static void sync_dump(void)
+{
+}
 #endif
-- 
1.7.10.4

