Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaLCLb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:31:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaLCL1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/101] fix O_SYNC|O_APPEND syncing the wrong range on write()
Date: Wed,  3 Dec 2014 12:26:58 +0100
Message-Id: <79a423edd0ce526b6a28fd1fed4478d0ecda03e0.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d311d79de305f1ada47cadd672e6ed1b28a949eb upstream.

It actually goes back to 2004 ([PATCH] Concurrent O_SYNC write support)
when sync_page_range() had been introduced; generic_file_write{,v}() correctly
synced
	pos_after_write - written .. pos_after_write - 1
but generic_file_aio_write() synced
	pos_before_write .. pos_before_write + written - 1
instead.  Which is not the same thing with O_APPEND, obviously.
A couple of years later correct variant had been killed off when
everything switched to use of generic_file_aio_write().

All users of generic_file_aio_write() are affected, and the same bug
has been copied into other instances of ->aio_write().

The fix is trivial; the only subtle point is that generic_write_sync()
ought to be inlined to avoid calculations useless for the majority of
calls.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/file.c     |  4 ++--
 fs/ext4/file.c     |  2 +-
 fs/ntfs/file.c     |  2 +-
 fs/sync.c          | 17 -----------------
 fs/xfs/xfs_file.c  |  2 +-
 include/linux/fs.h |  8 +++++++-
 mm/filemap.c       |  4 ++--
 7 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a2793c93d6ed..f9715276a257 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2590,8 +2590,8 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 	if (rc > 0) {
 		ssize_t err;
 
-		err = generic_write_sync(file, pos, rc);
-		if (err < 0 && rc > 0)
+		err = generic_write_sync(file, iocb->ki_pos - rc, rc);
+		if (err < 0)
 			rc = err;
 	}
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 1b890101397b..7b316011bfef 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -152,7 +152,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (ret > 0) {
 		ssize_t err;
 
-		err = generic_write_sync(file, pos, ret);
+		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
 		if (err < 0 && ret > 0)
 			ret = err;
 	}
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index a0b2f345da2b..86ddab916b66 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2133,7 +2133,7 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 	if (ret > 0) {
-		int err = generic_write_sync(file, pos, ret);
+		int err = generic_write_sync(file, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/fs/sync.c b/fs/sync.c
index 905f3f6b3d85..354831ddf54b 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -219,23 +219,6 @@ SYSCALL_DEFINE1(fdatasync, unsigned int, fd)
 	return do_fsync(fd, 1);
 }
 
-/**
- * generic_write_sync - perform syncing after a write if file / inode is sync
- * @file:	file to which the write happened
- * @pos:	offset where the write started
- * @count:	length of the write
- *
- * This is just a simple wrapper about our general syncing function.
- */
-int generic_write_sync(struct file *file, loff_t pos, loff_t count)
-{
-	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
-		return 0;
-	return vfs_fsync_range(file, pos, pos + count - 1,
-			       (file->f_flags & __O_SYNC) ? 0 : 1);
-}
-EXPORT_SYMBOL(generic_write_sync);
-
 /*
  * sys_sync_file_range() permits finely controlled syncing over a segment of
  * a file in the range offset .. (offset+nbytes-1) inclusive.  If nbytes is
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d56b136e68fe..aa606453a0f8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -811,7 +811,7 @@ xfs_file_aio_write(
 		XFS_STATS_ADD(xs_write_bytes, ret);
 
 		/* Handle various SYNC-type writes */
-		err = generic_write_sync(file, pos, ret);
+		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 164d2a91667f..6535d5af027e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2217,7 +2217,13 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
 extern int vfs_fsync(struct file *file, int datasync);
-extern int generic_write_sync(struct file *file, loff_t pos, loff_t count);
+static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
+{
+	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
+		return 0;
+	return vfs_fsync_range(file, pos, pos + count - 1,
+			       (file->f_flags & __O_SYNC) ? 0 : 1);
+}
 extern void emergency_sync(void);
 extern void emergency_remount(void);
 #ifdef CONFIG_BLOCK
diff --git a/mm/filemap.c b/mm/filemap.c
index b012daefc2d7..e94c70380deb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2723,8 +2723,8 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (ret > 0) {
 		ssize_t err;
 
-		err = generic_write_sync(file, pos, ret);
-		if (err < 0 && ret > 0)
+		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		if (err < 0)
 			ret = err;
 	}
 	return ret;
-- 
2.1.3

