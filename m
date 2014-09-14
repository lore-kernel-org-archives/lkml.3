Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaINKSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:18:53 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36265 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaINKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:18:48 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Sun, 14 Sep 2014 19:11:44 +0900
Message-Id: <1410689504-10032-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1410689504-10032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1410689504-10032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Rohner <andreas.rohner@gmx.net>

Under normal circumstances nilfs_sync_fs() writes out the super block,
which causes a flush of the underlying block device. But this depends on
the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
last segment crosses a segment boundary. So if only a small amount of
data is written before the call to nilfs_sync_fs(), no flush of the
block device occurs.

In the above case an additional call to blkdev_issue_flush() is needed.
To prevent unnecessary overhead, the new flag nilfs->ns_flushed_device
is introduced, which is cleared whenever new logs are written and set
whenever the block device is flushed. For convenience the function
nilfs_flush_device() is added, which contains the above logic.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c      |    8 +++-----
 fs/nilfs2/ioctl.c     |    8 +++-----
 fs/nilfs2/segment.c   |    3 +++
 fs/nilfs2/super.c     |    6 ++++++
 fs/nilfs2/the_nilfs.h |   22 ++++++++++++++++++++++
 5 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 2497815..e9e3325 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -56,11 +56,9 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	mutex_unlock(&inode->i_mutex);
 
 	nilfs = inode->i_sb->s_fs_info;
-	if (!err && nilfs_test_opt(nilfs, BARRIER)) {
-		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-		if (err != -EIO)
-			err = 0;
-	}
+	if (!err)
+		err = nilfs_flush_device(nilfs);
+
 	return err;
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 422fb54..9a20e51 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1022,11 +1022,9 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 		return ret;
 
 	nilfs = inode->i_sb->s_fs_info;
-	if (nilfs_test_opt(nilfs, BARRIER)) {
-		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
-		if (ret == -EIO)
-			return ret;
-	}
+	ret = nilfs_flush_device(nilfs);
+	if (ret < 0)
+		return ret;
 
 	if (argp != NULL) {
 		down_read(&nilfs->ns_segctor_sem);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a1a1916..0b7d2ca 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1833,6 +1833,7 @@ static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 	nilfs_set_next_segment(nilfs, segbuf);
 
 	if (update_sr) {
+		nilfs->ns_flushed_device = 0;
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno++);
 
@@ -2216,6 +2217,8 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	sci->sc_dsync_end = end;
 
 	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
+	if (!err)
+		nilfs->ns_flushed_device = 0;
 
 	nilfs_transaction_unlock(sb);
 	return err;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 228f5bd..2e5b3ec 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -310,6 +310,9 @@ int nilfs_commit_super(struct super_block *sb, int flag)
 					    nilfs->ns_sbsize));
 	}
 	clear_nilfs_sb_dirty(nilfs);
+	nilfs->ns_flushed_device = 1;
+	/* make sure store to ns_flushed_device cannot be reordered */
+	smp_wmb();
 	return nilfs_sync_super(sb, flag);
 }
 
@@ -514,6 +517,9 @@ static int nilfs_sync_fs(struct super_block *sb, int wait)
 	}
 	up_write(&nilfs->ns_sem);
 
+	if (!err)
+		err = nilfs_flush_device(nilfs);
+
 	return err;
 }
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index d01ead1..23778d3 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -46,6 +46,7 @@ enum {
 /**
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
+ * @ns_flushed_device: flag indicating if all volatile data was flushed
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
  * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
@@ -103,6 +104,7 @@ enum {
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
+	int			ns_flushed_device;
 
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
@@ -371,4 +373,24 @@ static inline int nilfs_segment_is_active(struct the_nilfs *nilfs, __u64 n)
 	return n == nilfs->ns_segnum || n == nilfs->ns_nextnum;
 }
 
+static inline int nilfs_flush_device(struct the_nilfs *nilfs)
+{
+	int err;
+
+	if (!nilfs_test_opt(nilfs, BARRIER) || nilfs->ns_flushed_device)
+		return 0;
+
+	nilfs->ns_flushed_device = 1;
+	/*
+	 * the store to ns_flushed_device must not be reordered after
+	 * blkdev_issue_flush().
+	 */
+	smp_wmb();
+
+	err = blkdev_issue_flush(nilfs->ns_bdev, GFP_KERNEL, NULL);
+	if (err != -EIO)
+		err = 0;
+	return err;
+}
+
 #endif /* _THE_NILFS_H */
-- 
1.7.9.4

