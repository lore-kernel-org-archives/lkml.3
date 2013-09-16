Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3IPWUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:20:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54763 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3IPWUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:44 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v5 05/10] VFS hot tracking: Add an ioctl to get hot tracking information
Date: Tue, 17 Sep 2013 06:17:50 +0800
Message-Id: <1379369875-5123-6-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-5806-0000-0000-000022C0D281
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

FS_IOC_GET_HEAT_INFO: return a struct containing the various
metrics collected in hot_freq_data structs, and also return a
calculated data temperature based on those metrics.

Optionally, retrieve the temperature from the hot data hash list
instead of recalculating it.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/compat_ioctl.c            |  5 ++++
 fs/ioctl.c                   | 71 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h | 21 +++++++++++++
 3 files changed, 97 insertions(+)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5d19acf..9026b8a 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/hot_tracking.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -1399,6 +1400,9 @@ COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
 
+/*Hot data tracking*/
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_INFO)
+
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
    them as compatible here. */
@@ -1578,6 +1582,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
+	case FS_IOC_GET_HEAT_INFO:
 		if (S_ISREG(file_inode(f.file)->i_mode))
 			break;
 		/*FALL THROUGH*/
diff --git a/fs/ioctl.c b/fs/ioctl.c
index fd507fb..fd2d8ec 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/ioctls.h>
 
@@ -537,6 +538,73 @@ static int ioctl_fsthaw(struct file *filp)
 }
 
 /*
+ * Retrieve information about access frequency for the given inode.
+ *
+ * The temperature that is returned can be "live" -- that is, recalculated when
+ * the ioctl is called -- or it can be returned from the map list, reflecting
+ * the (possibly old) value that the system will use when considering files
+ * for migration. This behavior is determined by hot_heat_info->live.
+ */
+static int ioctl_heat_info(struct file *file, void __user *argp)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct hot_info *root = inode->i_sb->s_hot_root;
+	struct hot_heat_info heat_info;
+	struct hot_inode_item *he;
+	int ret = 0;
+
+	/* The 'live' field need to be read from the user space */
+	if (copy_from_user((void *)&heat_info,
+			argp,
+			sizeof(struct hot_heat_info)) != 0) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	he = hot_inode_item_lookup(root, inode->i_ino, 0);
+	if (IS_ERR(he)) {
+		/* we don't have any info on this file yet */
+		ret = -ENODATA;
+		goto err;
+	}
+
+	heat_info.avg_delta_reads =
+		(__u64) he->freq.avg_delta_reads;
+	heat_info.avg_delta_writes =
+		(__u64) he->freq.avg_delta_writes;
+	heat_info.last_read_time =
+	(__u64) timespec_to_ns(&he->freq.last_read_time);
+	heat_info.last_write_time =
+	(__u64) timespec_to_ns(&he->freq.last_write_time);
+	heat_info.num_reads = (__u32) he->freq.nr_reads;
+	heat_info.num_writes = (__u32) he->freq.nr_writes;
+
+	if (heat_info.live > 0) {
+		/*
+		 * got a request for live temperature,
+		 * call hot_calc_temp() to recalculate
+		 */
+		heat_info.temp = hot_temp_calc(&he->freq);
+	} else {
+		/* not live temperature, get it from the map list */
+		heat_info.temp = he->freq.last_temp;
+	}
+
+	spin_lock(&root->t_lock);
+	hot_inode_item_put(he);
+	spin_unlock(&root->t_lock);
+
+	if (copy_to_user(argp, (void *)&heat_info,
+			sizeof(struct hot_heat_info))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+err:
+	return ret;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -591,6 +659,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_GET_HEAT_INFO:
+		return ioctl_heat_info(filp, argp);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 455bfe8..4f80e72 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -18,6 +18,19 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
+struct hot_heat_info {
+	__u8 live;
+	__u8 resv[3];
+	__u32 temp;
+	__u64 avg_delta_reads;
+	__u64 avg_delta_writes;
+	__u64 last_read_time;
+	__u64 last_write_time;
+	__u32 num_reads;
+	__u32 num_writes;
+	__u64 future[4]; /* For future expansions */
+};
+
 #ifdef __KERNEL__
 
 #include <linux/rbtree.h>
@@ -88,6 +101,14 @@ struct hot_info {
 	struct shrinker hot_shrink;
 };
 
+/*
+ * Hot data tracking ioctls:
+ *
+ * HOT_INFO - retrieve info on frequency of access
+ */
+#define FS_IOC_GET_HEAT_INFO _IOR('f', 17, \
+			struct hot_heat_info)
+
 extern void __init hot_cache_init(void);
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
-- 
1.7.11.7

