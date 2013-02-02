Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3BBOwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:52:41 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:52584 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3BBOwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:52:37 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/6] f2fs: name gc task as per the block device
Date: Sat,  2 Feb 2013 23:52:28 +0900
Message-Id: <1359816749-16321-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Currently GC task is started for each f2fs formatted/mounted device.
But, when we check the task list, using 'ps', there is no distinguishing
factor between the tasks. So, name the task as per the block device just
like the flusher threads.
Also, remove the macro GC_THREAD_NAME and instead use the name: f2fs_gc
to avoid name length truncation, as the command length is 16
-> TASK_COMM_LEN 16 and example name like:
f2fs_gc_task:8:16 -> this exceeds name length

Before Patch for 2 F2FS formatted partitions:
root  28061  0.0  0.0  0 0 ? S 10:31   0:00 [f2fs_gc_task]
root  28087  0.0  0.0  0 0 ? S 10:32   0:00 [f2fs_gc_task]

After Patch:
root  7833  0.0  0.0   0 0 ? S 10:38   0:00 [f2fs_gc-8:32]
root  7843  0.0  0.0   0 0 ? S 10:38   0:00 [f2fs_gc-8:16]

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/gc.c |    2 +-
 fs/f2fs/gc.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 66ac6ad..d344784 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -104,7 +104,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	sbi->gc_thread = gc_th;
 	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
 	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
-				GC_THREAD_NAME);
+				"f2fs_gc-%s", dev_name(sbi->sb->s_bdi->dev));
 	if (IS_ERR(gc_th->f2fs_gc_task)) {
 		kfree(gc_th);
 		return -ENOMEM;
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index b026d93..3abdf83 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -8,7 +8,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#define GC_THREAD_NAME	"f2fs_gc_task"
 #define GC_THREAD_MIN_WB_PAGES		1	/*
 						 * a threshold to determine
 						 * whether IO subsystem is idle
-- 
1.7.9.5

