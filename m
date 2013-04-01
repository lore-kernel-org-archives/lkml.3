Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab3DAKlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:41:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:54572 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3DAKlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:41:11 -0400
Subject: [PATCH 07/14] fuse: Trust kernel i_mtime only
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:41:45 +0400
Message-ID: <20130401104141.19027.67785.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the kernel maintain i_mtime locally:
 - clear S_NOCMTIME
 - implement i_op->update_time()
 - flush mtime on fsync and last close
 - update i_mtime explicitly on truncate and fallocate

Fuse inode flag FUSE_I_MTIME_UPDATED serves as indication that local i_mtime
should be flushed to the server eventually. Some operations (direct write,
truncate, fallocate and setattr) leads to updating mtime on server. So, we can
clear FUSE_I_MTIME_UPDATED when such an operation is completed. This is safe
because these operations (as well as i_op->update_time and fsync) are
protected by i_mutex.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c    |  116 ++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/fuse/file.c   |   33 +++++++++++++--
 fs/fuse/fuse_i.h |    6 ++-
 fs/fuse/inode.c  |   13 +++++-
 4 files changed, 147 insertions(+), 21 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8672ee4..8c04677 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -848,8 +848,11 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
 	/* see the comment in fuse_change_attributes() */
-	if (fc->writeback_cache && S_ISREG(inode->i_mode))
+	if (fc->writeback_cache && S_ISREG(inode->i_mode)) {
 		attr->size = i_size_read(inode);
+		attr->mtime = inode->i_mtime.tv_sec;
+		attr->mtimensec = inode->i_mtime.tv_nsec;
+	}
 
 	stat->dev = inode->i_sb->s_dev;
 	stat->ino = attr->ino;
@@ -1559,6 +1562,89 @@ void fuse_release_nowrite(struct inode *inode)
 	spin_unlock(&fc->lock);
 }
 
+static void fuse_setattr_fill(struct fuse_conn *fc, struct fuse_req *req,
+			      struct inode *inode,
+			      struct fuse_setattr_in *inarg_p,
+			      struct fuse_attr_out *outarg_p)
+{
+	req->in.h.opcode = FUSE_SETATTR;
+	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(*inarg_p);
+	req->in.args[0].value = inarg_p;
+	req->out.numargs = 1;
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(*outarg_p);
+	req->out.args[0].value = outarg_p;
+}
+
+/*
+ * Flush inode->i_mtime to the server
+ */
+int fuse_flush_mtime(struct file *file, bool nofail)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req = NULL;
+	struct fuse_setattr_in inarg;
+	struct fuse_attr_out outarg;
+	int err;
+
+	if (nofail) {
+		req = fuse_get_req_nofail_nopages(fc, file);
+	} else {
+		req = fuse_get_req_nopages(fc);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+	}
+
+	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
+
+	inarg.valid |= FATTR_MTIME;
+	inarg.mtime = inode->i_mtime.tv_sec;
+	inarg.mtimensec = inode->i_mtime.tv_nsec;
+
+	fuse_setattr_fill(fc, req, inode, &inarg, &outarg);
+	fuse_request_send(fc, req);
+	err = req->out.h.error;
+	fuse_put_request(fc, req);
+
+	if (!err)
+		clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+
+	return err;
+}
+
+static inline void set_mtime_helper(struct inode *inode, struct timespec mtime)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	inode->i_mtime = mtime;
+	clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+}
+
+/*
+ * S_NOCMTIME is clear, so we need to update inode->i_mtime manually. But
+ * we can also clear FUSE_I_MTIME_UPDATED if FUSE_SETATTR has just changed
+ * mtime on server.
+ */
+static void fuse_set_mtime_local(struct iattr *iattr, struct inode *inode)
+{
+	unsigned ivalid = iattr->ia_valid;
+
+	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
+		if (ivalid & ATTR_MTIME_SET)
+			set_mtime_helper(inode, iattr->ia_mtime);
+		else
+			set_mtime_helper(inode, current_fs_time(inode->i_sb));
+	} else if (ivalid & ATTR_SIZE)
+		set_mtime_helper(inode, current_fs_time(inode->i_sb));
+}
+
 /*
  * Set attributes, and at the same time refresh them.
  *
@@ -1619,17 +1705,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 		inarg.valid |= FATTR_LOCKOWNER;
 		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
 	}
-	req->in.h.opcode = FUSE_SETATTR;
-	req->in.h.nodeid = get_node_id(inode);
-	req->in.numargs = 1;
-	req->in.args[0].size = sizeof(inarg);
-	req->in.args[0].value = &inarg;
-	req->out.numargs = 1;
-	if (fc->minor < 9)
-		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
-	else
-		req->out.args[0].size = sizeof(outarg);
-	req->out.args[0].value = &outarg;
+	fuse_setattr_fill(fc, req, inode, &inarg, &outarg);
 	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
@@ -1646,6 +1722,10 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	}
 
 	spin_lock(&fc->lock);
+	/* the kernel maintains i_mtime locally */
+	if (fc->writeback_cache && S_ISREG(inode->i_mode))
+		fuse_set_mtime_local(attr, inode);
+
 	fuse_change_attributes_common(inode, &outarg.attr,
 				      attr_timeout(&outarg));
 	oldsize = inode->i_size;
@@ -1865,6 +1945,17 @@ static int fuse_removexattr(struct dentry *entry, const char *name)
 	return err;
 }
 
+static int fuse_update_time(struct inode *inode, struct timespec *now,
+			    int flags)
+{
+	if (flags & S_MTIME) {
+		inode->i_mtime = *now;
+		set_bit(FUSE_I_MTIME_UPDATED, &get_fuse_inode(inode)->state);
+		BUG_ON(!S_ISREG(inode->i_mode));
+	}
+	return 0;
+}
+
 static const struct inode_operations fuse_dir_inode_operations = {
 	.lookup		= fuse_lookup,
 	.mkdir		= fuse_mkdir,
@@ -1904,6 +1995,7 @@ static const struct inode_operations fuse_common_inode_operations = {
 	.getxattr	= fuse_getxattr,
 	.listxattr	= fuse_listxattr,
 	.removexattr	= fuse_removexattr,
+	.update_time	= fuse_update_time,
 };
 
 static const struct inode_operations fuse_symlink_inode_operations = {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index af58bbf..6821e95 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -288,6 +288,10 @@ static int fuse_open(struct inode *inode, struct file *file)
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	if (test_bit(FUSE_I_MTIME_UPDATED,
+		     &get_fuse_inode(inode)->state))
+		fuse_flush_mtime(file, true);
+
 	fuse_release_common(file, FUSE_RELEASE);
 
 	/* return value is ignored by VFS */
@@ -454,6 +458,13 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
 
 	fuse_sync_writes(inode);
 
+	if (test_bit(FUSE_I_MTIME_UPDATED,
+		     &get_fuse_inode(inode)->state)) {
+		int err = fuse_flush_mtime(file, false);
+		if (err)
+			goto out;
+	}
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -820,16 +831,21 @@ static size_t fuse_send_write(struct fuse_req *req, struct file *file,
 	return req->misc.write.out.size;
 }
 
-void fuse_write_update_size(struct inode *inode, loff_t pos)
+bool fuse_write_update_size(struct inode *inode, loff_t pos)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	bool ret = false;
 
 	spin_lock(&fc->lock);
 	fi->attr_version = ++fc->attr_version;
-	if (pos > inode->i_size)
+	if (pos > inode->i_size) {
 		i_size_write(inode, pos);
+		ret = true;
+	}
 	spin_unlock(&fc->lock);
+
+	return ret;
 }
 
 static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
@@ -1290,8 +1306,11 @@ static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res) {
 		res = fuse_direct_io(file, iov, nr_segs, count, ppos, 1);
-		if (res > 0)
+		if (res > 0) {
+			struct fuse_inode *fi = get_fuse_inode(inode);
 			fuse_write_update_size(inode, *ppos);
+			clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+		}
 	}
 
 	fuse_invalidate_attr(inode);
@@ -2340,8 +2359,12 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (change_i_size) {
 		struct inode *inode = file->f_mapping->host;
 
-		if (!err)
-			fuse_write_update_size(inode, offset + length);
+		if (!err && fuse_write_update_size(inode, offset + length)) {
+			struct fuse_inode *fi = get_fuse_inode(inode);
+
+			inode->i_mtime = current_fs_time(inode->i_sb);
+			clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+		}
 
 		mutex_unlock(&inode->i_mutex);
 	}
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 09c3139..ddf482b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -115,6 +115,8 @@ struct fuse_inode {
 enum {
 	/** Advise readdirplus  */
 	FUSE_I_ADVISE_RDPLUS,
+	/** i_mtime has been updated locally; a flush to userspace needed */
+	FUSE_I_MTIME_UPDATED,
 };
 
 struct fuse_conn;
@@ -836,6 +838,8 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
 unsigned fuse_file_poll(struct file *file, poll_table *wait);
 int fuse_dev_release(struct inode *inode, struct file *file);
 
-void fuse_write_update_size(struct inode *inode, loff_t pos);
+bool fuse_write_update_size(struct inode *inode, loff_t pos);
+
+int fuse_flush_mtime(struct file *file, bool nofail);
 
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 94319e6..921930f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -170,8 +170,11 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	inode->i_blocks  = attr->blocks;
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
-	inode->i_mtime.tv_sec   = attr->mtime;
-	inode->i_mtime.tv_nsec  = attr->mtimensec;
+	/* mtime from server may be stale due to local buffered write */
+	if (!fc->writeback_cache || !S_ISREG(inode->i_mode)) {
+		inode->i_mtime.tv_sec   = attr->mtime;
+		inode->i_mtime.tv_nsec  = attr->mtimensec;
+	}
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
@@ -249,6 +252,8 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
 {
 	inode->i_mode = attr->mode & S_IFMT;
 	inode->i_size = attr->size;
+	inode->i_mtime.tv_sec  = attr->mtime;
+	inode->i_mtime.tv_nsec = attr->mtimensec;
 	if (S_ISREG(inode->i_mode)) {
 		fuse_init_common(inode);
 		fuse_init_file_inode(inode);
@@ -295,7 +300,9 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		return NULL;
 
 	if ((inode->i_state & I_NEW)) {
-		inode->i_flags |= S_NOATIME|S_NOCMTIME;
+		inode->i_flags |= S_NOATIME;
+		if (!fc->writeback_cache)
+			inode->i_flags |= S_NOCMTIME;
 		inode->i_generation = generation;
 		inode->i_data.backing_dev_info = &fc->bdi;
 		fuse_init_inode(inode, attr);

