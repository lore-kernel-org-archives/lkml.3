Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaDOLbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:31:44 -0400
Received: from relay.parallels.com ([195.214.232.42]:54916 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaDOLbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:31:41 -0400
Subject: [PATCH 5/7] fuse: trust kernel i_ctime only
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:31:40 +0400
Message-ID: <20140415113049.11860.84702.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the kernel maintain i_ctime locally:
 - clear S_NOCMTIME (implemented earlier)
 - update i_ctime in i_op->update_time()
 - flush ctime on fsync and last close (previous patch)
 - update i_ctime explicitly on truncate, fallocate, open(O_TRUNC),
   setxattr, link, rename, unlink.

Fuse inode flag FUSE_I_CTIME_DIRTY serves as indication that local i_ctime
should be flushed to the server eventually. The patch sets the flag and updates
i_ctime in course of operations listed above.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c   |   24 +++++++++++++++++++++++-
 fs/fuse/file.c  |    8 ++++++--
 fs/fuse/inode.c |    6 ++++--
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0596726..2187960 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -679,6 +679,15 @@ static int fuse_symlink(struct inode *dir, struct dentry *entry,
 	return create_new_entry(fc, req, dir, entry, S_IFLNK);
 }
 
+static inline void fuse_update_ctime(struct fuse_conn *fc, struct inode *inode)
+{
+	if (fc->writeback_cache && S_ISREG(inode->i_mode)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+		inode->i_ctime = current_fs_time(inode->i_sb);
+		set_bit(FUSE_I_CTIME_DIRTY, &fi->state);
+	}
+}
+
 static int fuse_unlink(struct inode *dir, struct dentry *entry)
 {
 	int err;
@@ -713,6 +722,7 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 		fuse_invalidate_attr(inode);
 		fuse_invalidate_attr(dir);
 		fuse_invalidate_entry_cache(entry);
+		fuse_update_ctime(fc, inode);
 	} else if (err == -EINTR)
 		fuse_invalidate_entry(entry);
 	return err;
@@ -771,6 +781,7 @@ static int fuse_rename(struct inode *olddir, struct dentry *oldent,
 	if (!err) {
 		/* ctime changes */
 		fuse_invalidate_attr(oldent->d_inode);
+		fuse_update_ctime(fc, oldent->d_inode);
 
 		fuse_invalidate_attr(olddir);
 		if (olddir != newdir)
@@ -780,6 +791,7 @@ static int fuse_rename(struct inode *olddir, struct dentry *oldent,
 		if (newent->d_inode) {
 			fuse_invalidate_attr(newent->d_inode);
 			fuse_invalidate_entry_cache(newent);
+			fuse_update_ctime(fc, newent->d_inode);
 		}
 	} else if (err == -EINTR) {
 		/* If request was interrupted, DEITY only knows if the
@@ -829,6 +841,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 		inc_nlink(inode);
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
+		fuse_update_ctime(fc, inode);
 	} else if (err == -EINTR) {
 		fuse_invalidate_attr(inode);
 	}
@@ -846,6 +859,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 		attr->size = i_size_read(inode);
 		attr->mtime = inode->i_mtime.tv_sec;
 		attr->mtimensec = inode->i_mtime.tv_nsec;
+		attr->ctime = inode->i_ctime.tv_sec;
+		attr->ctimensec = inode->i_ctime.tv_nsec;
 	}
 
 	stat->dev = inode->i_sb->s_dev;
@@ -1830,8 +1845,10 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 		fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
-	if (!err)
+	if (!err) {
 		fuse_invalidate_attr(inode);
+		fuse_update_ctime(fc, inode);
+	}
 	return err;
 }
 
@@ -1974,6 +1991,11 @@ static int fuse_update_time(struct inode *inode, struct timespec *now,
 		set_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state);
 		BUG_ON(!S_ISREG(inode->i_mode));
 	}
+	if (flags & S_CTIME) {
+		inode->i_ctime = *now;
+		set_bit(FUSE_I_CTIME_DIRTY, &get_fuse_inode(inode)->state);
+		BUG_ON(!S_ISREG(inode->i_mode));
+	}
 	return 0;
 }
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9ed8590b..f644aeb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -224,8 +224,10 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 		if (fc->writeback_cache) {
-			inode->i_mtime = current_fs_time(inode->i_sb);
+			inode->i_ctime = inode->i_mtime =
+				current_fs_time(inode->i_sb);
 			set_bit(FUSE_I_MTIME_DIRTY, &fi->state);
+			set_bit(FUSE_I_CTIME_DIRTY, &fi->state);
 		}
 	}
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
@@ -3029,8 +3031,10 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		if (changed && fc->writeback_cache) {
 			struct fuse_inode *fi = get_fuse_inode(inode);
 
-			inode->i_mtime = current_fs_time(inode->i_sb);
+			inode->i_ctime = inode->i_mtime =
+				current_fs_time(inode->i_sb);
 			set_bit(FUSE_I_MTIME_DIRTY, &fi->state);
+			set_bit(FUSE_I_CTIME_DIRTY, &fi->state);
 		}
 	}
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 299e553..8b9a1d1 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -175,9 +175,9 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	if (!fc->writeback_cache || !S_ISREG(inode->i_mode)) {
 		inode->i_mtime.tv_sec   = attr->mtime;
 		inode->i_mtime.tv_nsec  = attr->mtimensec;
+		inode->i_ctime.tv_sec   = attr->ctime;
+		inode->i_ctime.tv_nsec  = attr->ctimensec;
 	}
-	inode->i_ctime.tv_sec   = attr->ctime;
-	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
 	if (attr->blksize != 0)
 		inode->i_blkbits = ilog2(attr->blksize);
@@ -256,6 +256,8 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
 	inode->i_size = attr->size;
 	inode->i_mtime.tv_sec  = attr->mtime;
 	inode->i_mtime.tv_nsec = attr->mtimensec;
+	inode->i_ctime.tv_sec  = attr->ctime;
+	inode->i_ctime.tv_nsec = attr->ctimensec;
 	if (S_ISREG(inode->i_mode)) {
 		fuse_init_common(inode);
 		fuse_init_file_inode(inode);

