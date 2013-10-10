Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3JJFu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:50:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61987 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3JJFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:50:57 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-42-5256403d5736
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix the starvation problem on cp_rwsem
Date: Thu, 10 Oct 2013 14:50:25 +0900
Message-id: <1381384225-32126-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zI11bh7Agg89P9S2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymjfvYGlYI5wxbcT
	ig2M9/i7GDk5JARMJA5da2KBsMUkLtxbzwZiCwksY5RYMjUSpmbDl+OsXYxcQPHpjBKblt9g
	gXCamST+vX3D1MXIwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SeBaRGWMBW4mWfI0gN
	i4CqxJm7M1hBbF4Bd4lrU9axQyzTltj2fCJYr4TAfTaJcxN+MkI0CEh8m3wIbI6EgKzEpgPM
	EPWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZI+PXvYLx7wPoQYzLQ
	uInMUqLJ+cDwzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDo82HpSGmij/SXA/4x/sc+a1WYb1VrneG3sa2FKXb6Z8vHKhRLNny0EnAc+sEpjnW
	WVM+hc/iOPSg96WhaFLJ8T0/ntV89rmz8+RTYz/e36UvjizaosTVFPxKaYtZ99NUwXmFjffD
	inKi73i/Fmz9/n3rvtOPDq35GPSAu9Znx4YHjDZqfr8zZJVYijMSDbWYi4oTAV4sNMRVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQV1bh7AggxcftS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xo372BpWCOcMW3E4oNjPf4uxg5OSQETCQ2fDnOCmGLSVy4t56ti5GLQ0hg
	OqPEpuU3WCCcZiaJf2/fMHUxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwGpERaw
	lXjZ5whSwyKgKnHm7gywBbwC7hLXpqxjh1imLbHt+UTGCYzcCxgZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIEh/czqR2MKxssDjEKcDAq8fBWlIUGCbEmlhVX5h5ilOBgVhLhnX4SKMSb
	klhZlVqUH19UmpNafIgxGWj7RGYp0eR8YOzllcQbGpuYGVkamVkYmZibkyasJM57oNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAMj14NusUkGS554PrZuOOSYyj7DYJpXkdvzV44TT87csufHd9sd
	Ko8K9BOuJ6y1KErZrhljfWSltG39ntTk/b8+2eb84Q5dFyU3//3saQaqE+UVYv1tZXmKRbMS
	hD7rV6nPuFO65OJ8laJT8tePfrGX4+VhtBJL+cewZveqlfpnnk96vPP6jGkzlFiKMxINtZiL
	ihMBXmHQ/7MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the logic previously introduced to address the starvation
on cp_rwsem.

One potential there-in bug is that we should cover the wait.list with spin_lock,
but the previous code broke this rule.

And, actually current rwsem handles this starvation issue reasonably, so that we
didn't need to do this before neither.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  | 13 -------------
 fs/f2fs/super.c |  1 -
 2 files changed, 14 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a955a59..308967b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -18,8 +18,6 @@
 #include <linux/crc32.h>
 #include <linux/magic.h>
 #include <linux/kobject.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
 
 /*
  * For mount options
@@ -360,7 +358,6 @@ struct f2fs_sb_info {
 	struct inode *meta_inode;		/* cache meta blocks */
 	struct mutex cp_mutex;			/* checkpoint procedure lock */
 	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
-	wait_queue_head_t cp_wait;		/* checkpoint wait queue */
 	struct mutex node_write;		/* locking node writes */
 	struct mutex writepages;		/* mutex for writepages() */
 	int por_doing;				/* recovery is doing or not */
@@ -516,13 +513,6 @@ static inline void clear_ckpt_flags(struct f2fs_checkpoint *cp, unsigned int f)
 
 static inline void f2fs_lock_op(struct f2fs_sb_info *sbi)
 {
-	/*
-	 * If the checkpoint thread is waiting for cp_rwsem, add cuurent task
-	 * into wait list to avoid the checkpoint thread starvation
-	 */
-	while (!list_empty(&sbi->cp_rwsem.wait_list))
-		wait_event_interruptible(sbi->cp_wait,
-				list_empty(&sbi->cp_rwsem.wait_list));
 	down_read(&sbi->cp_rwsem);
 }
 
@@ -539,9 +529,6 @@ static inline void f2fs_lock_all(struct f2fs_sb_info *sbi)
 static inline void f2fs_unlock_all(struct f2fs_sb_info *sbi)
 {
 	up_write(&sbi->cp_rwsem);
-
-	/* wake up all tasks blocked by checkpoint */
-	wake_up_all(&sbi->cp_wait);
 }
 
 /*
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 539c009..3b786c8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -841,7 +841,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	spin_lock_init(&sbi->stat_lock);
 	init_rwsem(&sbi->bio_sem);
 	init_rwsem(&sbi->cp_rwsem);
-	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
 
 	/* get an inode for meta space */
-- 
1.8.4.474.g128a96c

