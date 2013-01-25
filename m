Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab3AYSY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:24:27 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15903 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab3AYSYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:24:25 -0500
Subject: [PATCH 07/14] fuse: Update i_mtime on buffered writes
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 25 Jan 2013 22:24:02 +0400
Message-ID: <20130125182242.10037.3237.stgit@maximpc.sw.ru>
In-Reply-To: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If writeback cache is on, buffered write doesn't result in immediate mtime
update in userspace because the userspace will see modified data later, when
writeback happens. Consequently, mtime provided by userspace may be older than
actual time of buffered write.

The problem can be solved by generating mtime locally (will come in next
patches) and flushing it to userspace periodically. Here we introduce a flag to
keep the state of fuse_inode: the flag is ON if and only if locally generated
mtime (stored in inode->i_mtime) was not pushed to the userspace yet.

The patch also implements all bits related to flushing and clearing the flag.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c    |   42 +++++++++++++++++++++++++----
 fs/fuse/file.c   |   31 ++++++++++++++++++---
 fs/fuse/fuse_i.h |   13 ++++++++-
 fs/fuse/inode.c  |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 154 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ff8b603..969c60d 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -177,6 +177,13 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (flags & LOOKUP_RCU)
 			return -ECHILD;
 
+		if (test_bit(FUSE_I_MTIME_UPDATED,
+			     &get_fuse_inode(inode)->state)) {
+			err = fuse_flush_mtime(inode, 0);
+			if (err)
+				return 0;
+		}
+
 		fc = get_fuse_conn(inode);
 		req = fuse_get_req_nopages(fc);
 		if (IS_ERR(req))
@@ -839,7 +846,7 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 }
 
 static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
-			   struct file *file)
+			   struct file *file, int locked)
 {
 	int err;
 	struct fuse_getattr_in inarg;
@@ -848,6 +855,12 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	struct fuse_req *req;
 	u64 attr_version;
 
+	if (test_bit(FUSE_I_MTIME_UPDATED, &get_fuse_inode(inode)->state)) {
+		err = fuse_flush_mtime(inode, locked);
+		if (err)
+			return err;
+	}
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -893,7 +906,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 }
 
 int fuse_update_attributes(struct inode *inode, struct kstat *stat,
-			   struct file *file, bool *refreshed)
+			   struct file *file, bool *refreshed, int locked)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	int err;
@@ -901,7 +914,7 @@ int fuse_update_attributes(struct inode *inode, struct kstat *stat,
 
 	if (fi->i_time < get_jiffies_64()) {
 		r = true;
-		err = fuse_do_getattr(inode, stat, file);
+		err = fuse_do_getattr(inode, stat, file, locked);
 	} else {
 		r = false;
 		err = 0;
@@ -1055,7 +1068,7 @@ static int fuse_perm_getattr(struct inode *inode, int mask)
 	if (mask & MAY_NOT_BLOCK)
 		return -ECHILD;
 
-	return fuse_do_getattr(inode, NULL, NULL);
+	return fuse_do_getattr(inode, NULL, NULL, 0);
 }
 
 /*
@@ -1524,6 +1537,12 @@ void fuse_release_nowrite(struct inode *inode)
 	spin_unlock(&fc->lock);
 }
 
+static inline bool fuse_operation_updates_mtime_on_server(unsigned ivalid)
+{
+	return (ivalid & ATTR_SIZE) ||
+		((ivalid & ATTR_MTIME) && update_mtime(ivalid));
+}
+
 /*
  * Set attributes, and at the same time refresh them.
  *
@@ -1564,6 +1583,15 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	if (attr->ia_valid & ATTR_SIZE)
 		is_truncate = true;
 
+	if (!fuse_operation_updates_mtime_on_server(attr->ia_valid)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+		if (test_bit(FUSE_I_MTIME_UPDATED, &fi->state)) {
+			err = fuse_flush_mtime(inode, 1);
+			if (err)
+				return err;
+		}
+	}
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -1611,6 +1639,10 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	}
 
 	spin_lock(&fc->lock);
+	if (fuse_operation_updates_mtime_on_server(attr->ia_valid)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+		clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+	}
 	fuse_change_attributes_common(inode, &outarg.attr,
 				      attr_timeout(&outarg));
 	oldsize = inode->i_size;
@@ -1659,7 +1691,7 @@ static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	return fuse_update_attributes(inode, stat, NULL, NULL);
+	return fuse_update_attributes(inode, stat, NULL, NULL, 0);
 }
 
 static int fuse_setxattr(struct dentry *entry, const char *name,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6b64e11..4f8fa45 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -383,6 +383,13 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	if (test_bit(FUSE_I_MTIME_UPDATED,
+		     &get_fuse_inode(inode)->state)) {
+		err = fuse_flush_mtime(inode, 0);
+		if (err)
+			return err;
+	}
+
 	if (fc->no_flush)
 		return 0;
 
@@ -486,6 +493,15 @@ out:
 static int fuse_fsync(struct file *file, loff_t start, loff_t end,
 		      int datasync)
 {
+	struct inode *inode = file->f_mapping->host;
+
+	if (test_bit(FUSE_I_MTIME_UPDATED,
+		     &get_fuse_inode(inode)->state)) {
+		int err = fuse_flush_mtime(inode, 0);
+		if (err)
+			return err;
+	}
+
 	return fuse_fsync_common(file, start, end, datasync, 0);
 }
 
@@ -772,7 +788,8 @@ static ssize_t fuse_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	if (fc->auto_inval_data ||
 	    (pos + iov_length(iov, nr_segs) > i_size_read(inode))) {
 		int err;
-		err = fuse_update_attributes(inode, NULL, iocb->ki_filp, NULL);
+		err = fuse_update_attributes(inode, NULL, iocb->ki_filp, NULL,
+					     0);
 		if (err)
 			return err;
 	}
@@ -1290,8 +1307,11 @@ static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
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
@@ -1758,7 +1778,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int whence)
 		return generic_file_llseek(file, offset, whence);
 
 	mutex_lock(&inode->i_mutex);
-	retval = fuse_update_attributes(inode, NULL, file, NULL);
+	retval = fuse_update_attributes(inode, NULL, file, NULL, 1);
 	if (!retval)
 		retval = generic_file_llseek(file, offset, whence);
 	mutex_unlock(&inode->i_mutex);
@@ -2339,8 +2359,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (change_i_size) {
 		struct inode *inode = file->f_mapping->host;
 
-		if (!err)
+		if (!err) {
+			struct fuse_inode *fi = get_fuse_inode(inode);
 			fuse_write_update_size(inode, offset + length);
+			clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+		}
 
 		mutex_unlock(&inode->i_mutex);
 	}
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 65d76cd..fdeccc5 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -106,6 +106,15 @@ struct fuse_inode {
 
 	/** List of writepage requestst (pending or sent) */
 	struct list_head writepages;
+
+	/** Miscellaneous bits describing inode state */
+	unsigned long state;
+};
+
+/** FUSE inode state bits */
+enum {
+	/** i_mtime has been updated locally; a flush to userspace needed */
+	FUSE_I_MTIME_UPDATED,
 };
 
 struct fuse_conn;
@@ -784,7 +793,7 @@ int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
 u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
 
 int fuse_update_attributes(struct inode *inode, struct kstat *stat,
-			   struct file *file, bool *refreshed);
+			   struct file *file, bool *refreshed, int locked);
 
 void fuse_flush_writepages(struct inode *inode);
 
@@ -826,4 +835,6 @@ int fuse_dev_release(struct inode *inode, struct file *file);
 
 void fuse_write_update_size(struct inode *inode, loff_t pos);
 
+int fuse_flush_mtime(struct inode *inode, int locked);
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 7e07dbd..3687daf 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -201,7 +201,8 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 	struct timespec old_mtime;
 
 	spin_lock(&fc->lock);
-	if (attr_version != 0 && fi->attr_version > attr_version) {
+	if ((attr_version != 0 && fi->attr_version > attr_version) ||
+	    test_bit(FUSE_I_MTIME_UPDATED, &fi->state)) {
 		spin_unlock(&fc->lock);
 		return;
 	}
@@ -257,6 +258,8 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
 				   new_decode_dev(attr->rdev));
 	} else
 		BUG();
+
+	get_fuse_inode(inode)->state = 0;
 }
 
 int fuse_inode_eq(struct inode *inode, void *_nodeidp)
@@ -335,6 +338,80 @@ int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
 	return 0;
 }
 
+/*
+ * Flush inode->i_mtime to the server and clear FUSE_I_MTIME_UPDATED flag
+ *
+ * Do nothing if anybody cleared FUSE_I_MTIME_UPDATED flag by the time we
+ * acquired i_mutex.
+ *
+ * Do not clear FUSE_I_MTIME_UPDATED flag after flush if anybody (buffered
+ * write) updated i_mtime by the time we acquired fc->lock.
+ */
+int fuse_flush_mtime(struct inode *inode, int locked)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req;
+	struct fuse_setattr_in inarg;
+	struct fuse_attr_out outarg;
+	int err;
+
+	req = fuse_get_req_nopages(fc);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
+
+	if (!locked)
+		mutex_lock(&inode->i_mutex);
+
+	/*
+	 * This is crucial. We must re-check flag holding i_mutex. Otherwise
+	 * it would be possible to overwrite fresh mtime on server (for
+	 * example, updated as result of dio write) with our already outdated
+	 * inode->i_mtime.
+	 */
+	if (!test_bit(FUSE_I_MTIME_UPDATED, &fi->state)) {
+		mutex_unlock(&inode->i_mutex);
+		fuse_put_request(fc, req);
+		return 0;
+	}
+
+	inarg.valid |= FATTR_MTIME;
+	inarg.mtime = inode->i_mtime.tv_sec;
+	inarg.mtimensec = inode->i_mtime.tv_nsec;
+
+	req->in.h.opcode = FUSE_SETATTR;
+	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	req->out.numargs = 1;
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+
+	fuse_request_send(fc, req);
+	err = req->out.h.error;
+	fuse_put_request(fc, req);
+
+	if (!err) {
+		spin_lock(&fc->lock);
+		if (inarg.mtime == inode->i_mtime.tv_sec &&
+		    inarg.mtimensec == inode->i_mtime.tv_nsec)
+			clear_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+		spin_unlock(&fc->lock);
+	}
+
+	if (!locked)
+		mutex_unlock(&inode->i_mutex);
+
+	return err;
+}
+
 static void fuse_umount_begin(struct super_block *sb)
 {
 	fuse_abort_conn(get_fuse_conn_super(sb));

