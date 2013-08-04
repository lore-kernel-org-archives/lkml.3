Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3HDOK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:10:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60860 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3HDOKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:10:24 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 2/3] f2fs: add sysfs entries to select the gc policy
Date: Sun,  4 Aug 2013 23:10:15 +0900
Message-Id: <1375625415-2835-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add sysfs entry gc_idle to control the gc policy. Where
gc_idle = 1 corresponds to selecting a cost benefit approach,
while gc_idle = 2 corresponds to selecting a greedy approach
to garbage collection. The selection is mutually exclusive one
approach will work at any point. If gc_idle = 0, then this
option is disabled.

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |    6 +++++-
 Documentation/filesystems/f2fs.txt      |    6 ++++++
 fs/f2fs/gc.c                            |   24 +++++++++++++++++++++---
 fs/f2fs/gc.h                            |    3 +++
 fs/f2fs/super.c                         |    2 ++
 5 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 5f44095..31942ef 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -19,4 +19,8 @@ Description:
 		 Controls the default sleep time for gc_thread. Time
 		 is in milliseconds.
 
-
+What:		/sys/fs/f2fs/<disk>/gc_idle
+Date:		July 2013
+Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
+Description:
+		 Controls the victim selection policy for garbage collection.
diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 5daf3bb..3cd27be 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -158,6 +158,12 @@ Files in /sys/fs/f2fs/<devname>
                               time for the garbage collection thread. Time is
                               in milliseconds.
 
+ gc_idle                      This parameter controls the selection of victim
+                              policy for garbage collection. Setting gc_idle = 0
+                              (default) will disable this option. Setting
+                              gc_idle = 1 will select the Cost Benefit approach
+                              & setting gc_idle = 2 will select the greedy aproach.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 60d4f67..2c0c8ad 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -106,6 +106,8 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	gc_th->max_sleep_time = DEF_GC_THREAD_MAX_SLEEP_TIME;
 	gc_th->no_gc_sleep_time = DEF_GC_THREAD_NOGC_SLEEP_TIME;
 
+	gc_th->gc_idle = 0;
+
 	sbi->gc_thread = gc_th;
 	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
 	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
@@ -130,9 +132,25 @@ void stop_gc_thread(struct f2fs_sb_info *sbi)
 	sbi->gc_thread = NULL;
 }
 
-static int select_gc_type(int gc_type)
+static int select_gc_type(struct f2fs_gc_kthread *gc_th, int gc_type)
 {
-	return (gc_type == BG_GC) ? GC_CB : GC_GREEDY;
+	int gc_mode;
+
+	if (gc_th && gc_th->gc_idle) {
+		/* Cost Benefit Policy */
+		if (gc_th->gc_idle == 1) {
+			gc_mode = GC_CB;
+			goto out;
+		} else if (gc_th->gc_idle == 2) {
+			/* Greedy Policy */
+			gc_mode = GC_GREEDY;
+			goto out;
+		}
+	}
+
+	gc_mode = (gc_type == BG_GC) ? GC_CB : GC_GREEDY;
+out:
+	return gc_mode;
 }
 
 static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
@@ -145,7 +163,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 		p->dirty_segmap = dirty_i->dirty_segmap[type];
 		p->ofs_unit = 1;
 	} else {
-		p->gc_mode = select_gc_type(gc_type);
+		p->gc_mode = select_gc_type(sbi->gc_thread, gc_type);
 		p->dirty_segmap = dirty_i->dirty_segmap[DIRTY];
 		p->ofs_unit = sbi->segs_per_sec;
 	}
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index f4bf44c..c22dee9 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -30,6 +30,9 @@ struct f2fs_gc_kthread {
 	unsigned int min_sleep_time;
 	unsigned int max_sleep_time;
 	unsigned int no_gc_sleep_time;
+
+	/* for changing gc mode */
+	unsigned int gc_idle;
 };
 
 struct inode_entry {
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0a3e88f..f9c6c0b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -148,12 +148,14 @@ static struct f2fs_attr f2fs_attr_##_name = {			\
 F2FS_RW_ATTR(gc_min_sleep_time, min_sleep_time);
 F2FS_RW_ATTR(gc_max_sleep_time, max_sleep_time);
 F2FS_RW_ATTR(gc_no_gc_sleep_time, no_gc_sleep_time);
+F2FS_RW_ATTR(gc_idle, gc_idle);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(gc_min_sleep_time),
 	ATTR_LIST(gc_max_sleep_time),
 	ATTR_LIST(gc_no_gc_sleep_time),
+	ATTR_LIST(gc_idle),
 	NULL,
 };
 
-- 
1.7.9.5

