Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3HDOKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:10:13 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41265 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3HDOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:10:10 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 1/3] f2fs: add sysfs support for controlling the gc_thread
Date: Sun,  4 Aug 2013 23:09:40 +0900
Message-Id: <1375625380-2801-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add sysfs entries to control the timing parameters for
f2fs gc thread.

Various Sysfs options introduced are:
gc_min_sleep_time: Min Sleep time for GC in ms
gc_max_sleep_time: Max Sleep time for GC in ms
gc_no_gc_sleep_time: Default Sleep time for GC in ms

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |   22 ++++++
 Documentation/filesystems/f2fs.txt      |   26 +++++++
 fs/f2fs/f2fs.h                          |    4 +
 fs/f2fs/gc.c                            |   17 +++--
 fs/f2fs/gc.h                            |   33 +++++----
 fs/f2fs/super.c                         |  122 +++++++++++++++++++++++++++++++
 6 files changed, 204 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-f2fs

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
new file mode 100644
index 0000000..5f44095
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -0,0 +1,22 @@
+What:		/sys/fs/f2fs/<disk>/gc_max_sleep_time
+Date:		July 2013
+Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
+Description:
+		 Controls the maximun sleep time for gc_thread. Time
+		 is in milliseconds.
+
+What:		/sys/fs/f2fs/<disk>/gc_min_sleep_time
+Date:		July 2013
+Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
+Description:
+		 Controls the minimum sleep time for gc_thread. Time
+		 is in milliseconds.
+
+What:		/sys/fs/f2fs/<disk>/gc_no_gc_sleep_time
+Date:		July 2013
+Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
+Description:
+		 Controls the default sleep time for gc_thread. Time
+		 is in milliseconds.
+
+
diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 0500c19..5daf3bb 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -133,6 +133,32 @@ f2fs. Each file shows the whole f2fs information.
  - current memory footprint consumed by f2fs.
 
 ================================================================================
+SYSFS ENTRIES
+================================================================================
+
+Information about mounted f2f2 file systems can be found in
+/sys/fs/f2fs.  Each mounted filesystem will have a directory in
+/sys/fs/f2fs based on its device name (i.e., /sys/fs/f2fs/sda).
+The files in each per-device directory are shown in table below.
+
+Files in /sys/fs/f2fs/<devname>
+(see also Documentation/ABI/testing/sysfs-fs-f2fs)
+..............................................................................
+ File                         Content
+
+ gc_max_sleep_time            This tuning parameter controls the maximum sleep
+                              time for the garbage collection thread. Time is
+                              in milliseconds.
+
+ gc_min_sleep_time            This tuning parameter controls the minimum sleep
+                              time for the garbage collection thread. Time is
+                              in milliseconds.
+
+ gc_no_gc_sleep_time          This tuning parameter controls the default sleep
+                              time for the garbage collection thread. Time is
+                              in milliseconds.
+
+================================================================================
 USAGE
 ================================================================================
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 78777cd..63813be 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -430,6 +430,10 @@ struct f2fs_sb_info {
 #endif
 	unsigned int last_victim[2];		/* last victim segment # */
 	spinlock_t stat_lock;			/* lock for stat operations */
+
+	/* For sysfs suppport */
+	struct kobject s_kobj;
+	struct completion s_kobj_unregister;
 };
 
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 35f9b1a..60d4f67 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -29,10 +29,11 @@ static struct kmem_cache *winode_slab;
 static int gc_thread_func(void *data)
 {
 	struct f2fs_sb_info *sbi = data;
+	struct f2fs_gc_kthread *gc_th = sbi->gc_thread;
 	wait_queue_head_t *wq = &sbi->gc_thread->gc_wait_queue_head;
 	long wait_ms;
 
-	wait_ms = GC_THREAD_MIN_SLEEP_TIME;
+	wait_ms = gc_th->min_sleep_time;
 
 	do {
 		if (try_to_freeze())
@@ -45,7 +46,7 @@ static int gc_thread_func(void *data)
 			break;
 
 		if (sbi->sb->s_writers.frozen >= SB_FREEZE_WRITE) {
-			wait_ms = GC_THREAD_MAX_SLEEP_TIME;
+			wait_ms = increase_sleep_time(gc_th, wait_ms);
 			continue;
 		}
 
@@ -66,15 +67,15 @@ static int gc_thread_func(void *data)
 			continue;
 
 		if (!is_idle(sbi)) {
-			wait_ms = increase_sleep_time(wait_ms);
+			wait_ms = increase_sleep_time(gc_th, wait_ms);
 			mutex_unlock(&sbi->gc_mutex);
 			continue;
 		}
 
 		if (has_enough_invalid_blocks(sbi))
-			wait_ms = decrease_sleep_time(wait_ms);
+			wait_ms = decrease_sleep_time(gc_th, wait_ms);
 		else
-			wait_ms = increase_sleep_time(wait_ms);
+			wait_ms = increase_sleep_time(gc_th, wait_ms);
 
 #ifdef CONFIG_F2FS_STAT_FS
 		sbi->bg_gc++;
@@ -82,7 +83,7 @@ static int gc_thread_func(void *data)
 
 		/* if return value is not zero, no victim was selected */
 		if (f2fs_gc(sbi))
-			wait_ms = GC_THREAD_NOGC_SLEEP_TIME;
+			wait_ms = gc_th->no_gc_sleep_time;
 	} while (!kthread_should_stop());
 	return 0;
 }
@@ -101,6 +102,10 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 		goto out;
 	}
 
+	gc_th->min_sleep_time = DEF_GC_THREAD_MIN_SLEEP_TIME;
+	gc_th->max_sleep_time = DEF_GC_THREAD_MAX_SLEEP_TIME;
+	gc_th->no_gc_sleep_time = DEF_GC_THREAD_NOGC_SLEEP_TIME;
+
 	sbi->gc_thread = gc_th;
 	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
 	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 2c6a6bd..f4bf44c 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -13,9 +13,9 @@
 						 * whether IO subsystem is idle
 						 * or not
 						 */
-#define GC_THREAD_MIN_SLEEP_TIME	30000	/* milliseconds */
-#define GC_THREAD_MAX_SLEEP_TIME	60000
-#define GC_THREAD_NOGC_SLEEP_TIME	300000	/* wait 5 min */
+#define DEF_GC_THREAD_MIN_SLEEP_TIME	30000	/* milliseconds */
+#define DEF_GC_THREAD_MAX_SLEEP_TIME	60000
+#define DEF_GC_THREAD_NOGC_SLEEP_TIME	300000	/* wait 5 min */
 #define LIMIT_INVALID_BLOCK	40 /* percentage over total user space */
 #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
 
@@ -25,6 +25,11 @@
 struct f2fs_gc_kthread {
 	struct task_struct *f2fs_gc_task;
 	wait_queue_head_t gc_wait_queue_head;
+
+	/* for gc sleep time */
+	unsigned int min_sleep_time;
+	unsigned int max_sleep_time;
+	unsigned int no_gc_sleep_time;
 };
 
 struct inode_entry {
@@ -56,25 +61,25 @@ static inline block_t limit_free_user_blocks(struct f2fs_sb_info *sbi)
 	return (long)(reclaimable_user_blocks * LIMIT_FREE_BLOCK) / 100;
 }
 
-static inline long increase_sleep_time(long wait)
+static inline long increase_sleep_time(struct f2fs_gc_kthread *gc_th, long wait)
 {
-	if (wait == GC_THREAD_NOGC_SLEEP_TIME)
+	if (wait == gc_th->no_gc_sleep_time)
 		return wait;
 
-	wait += GC_THREAD_MIN_SLEEP_TIME;
-	if (wait > GC_THREAD_MAX_SLEEP_TIME)
-		wait = GC_THREAD_MAX_SLEEP_TIME;
+	wait += gc_th->min_sleep_time;
+	if (wait > gc_th->max_sleep_time)
+		wait = gc_th->max_sleep_time;
 	return wait;
 }
 
-static inline long decrease_sleep_time(long wait)
+static inline long decrease_sleep_time(struct f2fs_gc_kthread *gc_th, long wait)
 {
-	if (wait == GC_THREAD_NOGC_SLEEP_TIME)
-		wait = GC_THREAD_MAX_SLEEP_TIME;
+	if (wait == gc_th->no_gc_sleep_time)
+		wait = gc_th->max_sleep_time;
 
-	wait -= GC_THREAD_MIN_SLEEP_TIME;
-	if (wait <= GC_THREAD_MIN_SLEEP_TIME)
-		wait = GC_THREAD_MIN_SLEEP_TIME;
+	wait -= gc_th->min_sleep_time;
+	if (wait <= gc_th->min_sleep_time)
+		wait = gc_th->min_sleep_time;
 	return wait;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 70dbb31..0a3e88f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -23,17 +23,21 @@
 #include <linux/exportfs.h>
 #include <linux/blkdev.h>
 #include <linux/f2fs_fs.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
 #include "xattr.h"
+#include "gc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/f2fs.h>
 
 static struct proc_dir_entry *f2fs_proc_root;
 static struct kmem_cache *f2fs_inode_cachep;
+static struct kset *f2fs_kset;
 
 enum {
 	Opt_gc_background,
@@ -59,6 +63,111 @@ static match_table_t f2fs_tokens = {
 	{Opt_err, NULL},
 };
 
+/*Sysfs support for F2fs */
+struct f2fs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct f2fs_attr *, struct f2fs_sb_info *, char *);
+	ssize_t (*store)(struct f2fs_attr *, struct f2fs_sb_info *,
+			 const char *, size_t);
+	int offset;
+};
+
+static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
+			   struct f2fs_sb_info *sbi, char *buf)
+{
+	struct f2fs_gc_kthread *gc_kth = sbi->gc_thread;
+	unsigned int *ui;
+
+	if (!gc_kth)
+		return -EFAULT;
+
+	ui = (unsigned int *) (((char *)gc_kth) + a->offset);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", *ui);
+}
+
+static ssize_t f2fs_sbi_store(struct f2fs_attr *a,
+			    struct f2fs_sb_info *sbi,
+			    const char *buf, size_t count)
+{
+	struct f2fs_gc_kthread *gc_kth = sbi->gc_thread;
+	unsigned long t;
+	unsigned int *ui;
+	ssize_t ret;
+
+	if (!gc_kth)
+		return -EFAULT;
+
+	ui = (unsigned int *) (((char *)gc_kth) + a->offset);
+
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret < 0)
+		return ret;
+	*ui = t;
+	return count;
+}
+
+static ssize_t f2fs_attr_show(struct kobject *kobj,
+				struct attribute *attr, char *buf)
+{
+	struct f2fs_sb_info *sbi = container_of(kobj, struct f2fs_sb_info,
+								s_kobj);
+	struct f2fs_attr *a = container_of(attr, struct f2fs_attr, attr);
+
+	return a->show ? a->show(a, sbi, buf) : 0;
+}
+
+static ssize_t f2fs_attr_store(struct kobject *kobj, struct attribute *attr,
+						const char *buf, size_t len)
+{
+	struct f2fs_sb_info *sbi = container_of(kobj, struct f2fs_sb_info,
+									s_kobj);
+	struct f2fs_attr *a = container_of(attr, struct f2fs_attr, attr);
+
+	return a->store ? a->store(a, sbi, buf, len) : 0;
+}
+
+static void f2fs_sb_release(struct kobject *kobj)
+{
+	struct f2fs_sb_info *sbi = container_of(kobj, struct f2fs_sb_info,
+								s_kobj);
+	complete(&sbi->s_kobj_unregister);
+}
+
+#define F2FS_ATTR_OFFSET(_name, _mode, _show, _store, _elname) \
+static struct f2fs_attr f2fs_attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,					\
+	.store	= _store,					\
+	.offset = offsetof(struct f2fs_gc_kthread, _elname),	\
+}
+
+#define F2FS_RW_ATTR(name, elname)	\
+	F2FS_ATTR_OFFSET(name, 0644, f2fs_sbi_show, f2fs_sbi_store, elname)
+
+F2FS_RW_ATTR(gc_min_sleep_time, min_sleep_time);
+F2FS_RW_ATTR(gc_max_sleep_time, max_sleep_time);
+F2FS_RW_ATTR(gc_no_gc_sleep_time, no_gc_sleep_time);
+
+#define ATTR_LIST(name) (&f2fs_attr_##name.attr)
+static struct attribute *f2fs_attrs[] = {
+	ATTR_LIST(gc_min_sleep_time),
+	ATTR_LIST(gc_max_sleep_time),
+	ATTR_LIST(gc_no_gc_sleep_time),
+	NULL,
+};
+
+static const struct sysfs_ops f2fs_attr_ops = {
+	.show   = f2fs_attr_show,
+	.store  = f2fs_attr_store,
+};
+
+static struct kobj_type f2fs_ktype = {
+	.default_attrs  = f2fs_attrs,
+	.sysfs_ops      = &f2fs_attr_ops,
+	.release        = f2fs_sb_release,
+};
+
 void f2fs_msg(struct super_block *sb, const char *level, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -243,6 +352,8 @@ static void f2fs_put_super(struct super_block *sb)
 	destroy_segment_manager(sbi);
 
 	kfree(sbi->ckpt);
+	kobject_del(&sbi->s_kobj);
+	wait_for_completion(&sbi->s_kobj_unregister);
 
 	sb->s_fs_info = NULL;
 	brelse(sbi->raw_super_buf);
@@ -818,6 +929,13 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 					"the device does not support discard");
 	}
 
+	sbi->s_kobj.kset = f2fs_kset;
+	init_completion(&sbi->s_kobj_unregister);
+	err = kobject_init_and_add(&sbi->s_kobj, &f2fs_ktype, NULL,
+							"%s", sb->s_id);
+	if (err)
+		goto fail;
+
 	return 0;
 fail:
 	stop_gc_thread(sbi);
@@ -892,6 +1010,9 @@ static int __init init_f2fs_fs(void)
 	err = create_checkpoint_caches();
 	if (err)
 		goto fail;
+	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
+	if (!f2fs_kset)
+		goto fail;
 	err = register_filesystem(&f2fs_fs_type);
 	if (err)
 		goto fail;
@@ -910,6 +1031,7 @@ static void __exit exit_f2fs_fs(void)
 	destroy_gc_caches();
 	destroy_node_manager_caches();
 	destroy_inodecache();
+	kset_unregister(f2fs_kset);
 }
 
 module_init(init_f2fs_fs)
-- 
1.7.9.5

