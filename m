Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068Ab3DHQb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:31:56 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33456 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935022Ab3DHQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:31:53 -0400
Message-ID: <5162EF4C.10707@gmail.com>
Date: Mon, 08 Apr 2013 18:24:44 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2 v2][RFC] fsfreeze: replace sb_start_write with sb_start_write_killable
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sb_start_write with sb_start_write_killable where it's
possible to manage a SIGKILL.

Signed-of-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/btrfs/file.c   |    4 +++-
 fs/cifs/file.c    |    4 +++-
 fs/fuse/file.c    |    4 +++-
 fs/ntfs/file.c    |    4 +++-
 fs/ocfs2/file.c   |    4 +++-
 fs/open.c         |    8 ++++++--
 fs/splice.c       |    4 +++-
 fs/xfs/xfs_file.c |    4 +++-
 mm/filemap.c      |    4 +++-
 mm/filemap_xip.c  |    4 +++-
 10 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ade03e6..a7cae1b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1514,7 +1514,9 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	size_t count, ocount;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 
-	sb_start_write(inode->i_sb);
+	err = sb_start_write_killable(inode->i_sb);
+	if (err)
+		return err;
 
 	mutex_lock(&inode->i_mutex);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7a0dd99..d4c812b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2520,7 +2520,9 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	rc = sb_start_write_killable(inode->i_sb);
+	if (rc)
+		return rc;
 
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 34b80ba..55eabac 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -971,7 +971,9 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		return err;
 
 	count = ocount;
-	sb_start_write(inode->i_sb);
+	err = sb_start_write_killable(inode->i_sb);
+	if (err)
+		return err;
 	mutex_lock(&inode->i_mutex);
 
 	/* We can write back this queue in page reclaim */
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 5b2d4f0..dba2cd4 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2129,7 +2129,9 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6474cb4..77024ef 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2248,7 +2248,9 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	if (iocb->ki_left == 0)
 		return 0;
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
 	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
diff --git a/fs/open.c b/fs/open.c
index 6835446..ab86208 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -182,7 +182,9 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (IS_APPEND(inode))
 		goto out_putf;
 
-	sb_start_write(inode->i_sb);
+	error = sb_start_write_killable(inode->i_sb);
+	if (error)
+		return error;
 	error = locks_verify_truncate(inode, f.file, length);
 	if (!error)
 		error = security_path_truncate(&f.file->f_path);
@@ -293,7 +295,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 	ret = file->f_op->fallocate(file, mode, offset, len);
 	sb_end_write(inode->i_sb);
 	return ret;
diff --git a/fs/splice.c b/fs/splice.c
index 29e394e..9931f09 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1000,7 +1000,9 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	};
 	ssize_t ret;
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 
 	pipe_lock(pipe);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f03bf1a..8054601 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -775,7 +775,9 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ret = -EIO;
diff --git a/mm/filemap.c b/mm/filemap.c
index e1979fd..6820e47 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2528,7 +2528,9 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index a912da6..acef625 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -404,7 +404,9 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	loff_t pos;
 	ssize_t ret;
 
-	sb_start_write(inode->i_sb);
+	ret = sb_start_write_killable(inode->i_sb);
+	if (ret)
+		return ret;
 
 	mutex_lock(&inode->i_mutex);
 
-- 
1.7.3.4
