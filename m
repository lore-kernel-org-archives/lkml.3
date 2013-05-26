Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab3EZCFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 22:05:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40638 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab3EZCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 22:05:39 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v2 1/2] f2fs: return proper error from start_gc_thread
Date: Sun, 26 May 2013 11:05:32 +0900
Message-Id: <1369533932-6921-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

when there is an error from kthread_run, then return proper error
rather than returning -ENOMEM.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 25b083c..ddc2c67 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -91,23 +91,28 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_gc_kthread *gc_th;
 	dev_t dev = sbi->sb->s_bdev->bd_dev;
+	int err = 0;
 
 	if (!test_opt(sbi, BG_GC))
-		return 0;
+		goto out;
 	gc_th = kmalloc(sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
-	if (!gc_th)
-		return -ENOMEM;
+	if (!gc_th) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	sbi->gc_thread = gc_th;
 	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
 	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
 			"f2fs_gc-%u:%u", MAJOR(dev), MINOR(dev));
 	if (IS_ERR(gc_th->f2fs_gc_task)) {
+		err = PTR_ERR(gc_th->f2fs_gc_task);
 		kfree(gc_th);
 		sbi->gc_thread = NULL;
-		return -ENOMEM;
 	}
-	return 0;
+
+out:
+	return err;
 }
 
 void stop_gc_thread(struct f2fs_sb_info *sbi)
-- 
1.7.9.5

