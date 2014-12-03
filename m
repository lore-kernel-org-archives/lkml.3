Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaLCL22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:28:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaLCL1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andreas Rohner <andreas.rohner@gmx.net>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/101] nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()
Date: Wed,  3 Dec 2014 12:26:59 +0100
Message-Id: <0d68992fb4250d00a906ee886ec541a6afeab066.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Rohner <andreas.rohner@gmx.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e2c7617ae36b27f97643bfa08aabe27e630c1a76 upstream.

Under normal circumstances nilfs_sync_fs() writes out the super block,
which causes a flush of the underlying block device.  But this depends
on the THE_NILFS_SB_DIRTY flag, which is only set if the pointer to the
last segment crosses a segment boundary.  So if only a small amount of
data is written before the call to nilfs_sync_fs(), no flush of the
block device occurs.

In the above case an additional call to blkdev_issue_flush() is needed.
To prevent unnecessary overhead, the new flag nilfs->ns_flushed_device
is introduced, which is cleared whenever new logs are written and set
whenever the block device is flushed.  For convenience the function
nilfs_flush_device() is added, which contains the above logic.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nilfs2/file.c      |  8 +++-----
 fs/nilfs2/ioctl.c     |  8 +++-----
 fs/nilfs2/segment.c   |  3 +++
 fs/nilfs2/super.c     |  6 ++++++
 fs/nilfs2/the_nilfs.h | 22 ++++++++++++++++++++++
 5 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 08fdb77852ac..e31952112eb4 100644
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
index b44bdb291b84..4915e543dc51 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -694,11 +694,9 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
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
index a1a191634abc..0b7d2cad0426 100644
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
index 7ac2a122ca1d..0bdc0245e0aa 100644
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
index de8cc53b4a5c..005e1dcf8afb 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -45,6 +45,7 @@ enum {
 /**
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
+ * @ns_flushed_device: flag indicating if all volatile data was flushed
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
  * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
@@ -98,6 +99,7 @@ enum {
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
+	int			ns_flushed_device;
 
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
@@ -353,4 +355,24 @@ static inline int nilfs_segment_is_active(struct the_nilfs *nilfs, __u64 n)
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
2.1.3

