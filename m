Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab3GaOdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:33:24 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33060 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811Ab3GaOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:33:21 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 2/2] f2fs: add sysfs entries to select the gc policy
Date: Wed, 31 Jul 2013 23:33:13 +0900
Message-Id: <1375281193-15560-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add sysfs entries namely gc_long_idle and gc_short_idle to control the
gc policy. Where long idle corresponds to selecting a cost benefit approach,
while short idle corresponds to selecting a greedy approach to garbage
collection. The selection is mutually exclusive one approach will work at
any point.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |   12 +++++++
 Documentation/filesystems/f2fs.txt      |    8 +++++
 fs/f2fs/gc.c                            |   22 ++++++++++--
 fs/f2fs/gc.h                            |    4 +++
 fs/f2fs/super.c                         |   59 +++++++++++++++++++++++++++++--
 5 files changed, 99 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 5f44095..96b62ea 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -19,4 +19,16 @@ Description:
 		 Controls the default sleep time for gc_thread. Time
 		 is in milliseconds.
 
+What:		/sys/fs/f2fs/<disk>/gc_long_idle
+Date:		July 2013
+Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
+Description:
+		 Controls the selection of gc policy. long_idle is used
+		 to select the cost benefit approach for garbage collection.
 
+What:		/sys/fs/f2fs/<disk>/gc_short_idle
+Date:		July 2013
+Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
+Description:
+		 Controls the selection of gc policy. short_idle is used
+		 to select the greedy approach for garbage collection.
diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 2e9e873..06dd5d7 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -158,6 +158,14 @@ Files in /sys/fs/f2fs/<devname>
                               time for the garbage collection thread. Time is
                               in milliseconds.
 
+ gc_long_idle                 This parameter controls the selection of cost
+                              benefit approach for garbage collectoin. Writing
+                              1 to this file will select the cost benefit policy.
+
+ gc_short_idle                This parameter controls the selection of greedy
+                              approach for the garbage collection. Writing 1
+                              to this file will select the greedy policy.
+
 ================================================================================
 USAGE
 ================================================================================
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 60d4f67..af2d9d7 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -106,6 +106,8 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	gc_th->max_sleep_time = DEF_GC_THREAD_MAX_SLEEP_TIME;
 	gc_th->no_gc_sleep_time = DEF_GC_THREAD_NOGC_SLEEP_TIME;
 
+	gc_th->long_idle = gc_th->short_idle = 0;
+
 	sbi->gc_thread = gc_th;
 	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
 	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
@@ -130,9 +132,23 @@ void stop_gc_thread(struct f2fs_sb_info *sbi)
 	sbi->gc_thread = NULL;
 }
 
-static int select_gc_type(int gc_type)
+static int select_gc_type(struct f2fs_gc_kthread *gc_th, int gc_type)
 {
-	return (gc_type == BG_GC) ? GC_CB : GC_GREEDY;
+	int gc_mode;
+
+	if (gc_th) {
+		if (gc_th->long_idle) {
+			gc_mode = GC_CB;
+			goto out;
+		} else if (gc_th->short_idle) {
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
@@ -145,7 +161,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 		p->dirty_segmap = dirty_i->dirty_segmap[type];
 		p->ofs_unit = 1;
 	} else {
-		p->gc_mode = select_gc_type(gc_type);
+		p->gc_mode = select_gc_type(sbi->gc_thread, gc_type);
 		p->dirty_segmap = dirty_i->dirty_segmap[DIRTY];
 		p->ofs_unit = sbi->segs_per_sec;
 	}
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index f4bf44c..b2faae5 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -30,6 +30,10 @@ struct f2fs_gc_kthread {
 	unsigned int min_sleep_time;
 	unsigned int max_sleep_time;
 	unsigned int no_gc_sleep_time;
+
+	/* for changing gc mode */
+	unsigned int long_idle;
+	unsigned int short_idle;
 };
 
 struct inode_entry {
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 30de280..3db806b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -107,6 +107,56 @@ static ssize_t f2fs_sbi_store(struct f2fs_attr *a,
 	return count;
 }
 
+static ssize_t f2fs_gc_long_idle_store(struct f2fs_attr *a,
+			    struct f2fs_sb_info *sbi,
+			    const char *buf, size_t count)
+{
+	struct f2fs_gc_kthread *gc_kth = sbi->gc_thread;
+	unsigned long t;
+	ssize_t ret;
+
+	if (!gc_kth)
+		return -EFAULT;
+
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret < 0)
+		return ret;
+
+	if (t == 0)
+		gc_kth->long_idle = 0;
+	else if (t == 1) {
+		gc_kth->long_idle = 1;
+		gc_kth->short_idle = 0;
+	}
+
+	return count;
+}
+
+static ssize_t f2fs_gc_short_idle_store(struct f2fs_attr *a,
+			    struct f2fs_sb_info *sbi,
+			    const char *buf, size_t count)
+{
+	struct f2fs_gc_kthread *gc_kth = sbi->gc_thread;
+	unsigned long t;
+	ssize_t ret;
+
+	if (!gc_kth)
+		return -EFAULT;
+
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret < 0)
+		return ret;
+
+	if (t == 0)
+		gc_kth->short_idle = 0;
+	else if (t == 1) {
+		gc_kth->short_idle = 1;
+		gc_kth->long_idle = 0;
+	}
+
+	return count;
+}
+
 static ssize_t f2fs_attr_show(struct kobject *kobj,
 				struct attribute *attr, char *buf)
 {
@@ -142,21 +192,24 @@ static struct f2fs_attr f2fs_attr_##_name = {			\
 	.offset = offsetof(struct f2fs_gc_kthread, _elname),	\
 }
 
-#define F2FS_ATTR(name, mode, show, store) \
-static struct f2fs_attr f2fs_attr_##name = __ATTR(name, mode, show, store)
-
 #define F2FS_RW_ATTR(name, elname)	\
 	F2FS_ATTR_OFFSET(name, 0644, f2fs_sbi_show, f2fs_sbi_store, elname)
 
 F2FS_RW_ATTR(gc_min_sleep_time, min_sleep_time);
 F2FS_RW_ATTR(gc_max_sleep_time, max_sleep_time);
 F2FS_RW_ATTR(gc_no_gc_sleep_time, no_gc_sleep_time);
+F2FS_ATTR_OFFSET(gc_long_idle, 0644, f2fs_sbi_show,
+			 f2fs_gc_long_idle_store, long_idle);
+F2FS_ATTR_OFFSET(gc_short_idle, 0644, f2fs_sbi_show,
+			 f2fs_gc_short_idle_store, short_idle);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(gc_min_sleep_time),
 	ATTR_LIST(gc_max_sleep_time),
 	ATTR_LIST(gc_no_gc_sleep_time),
+	ATTR_LIST(gc_long_idle),
+	ATTR_LIST(gc_short_idle),
 	NULL,
 };
 
-- 
1.7.9.5

