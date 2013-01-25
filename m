Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771Ab3AYS1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:27:34 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36918 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab3AYS13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:27:29 -0500
Subject: [PATCH 12/14] fuse: Fix O_DIRECT operations vs cached writeback
 misorder - v2
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 25 Jan 2013 22:27:06 +0400
Message-ID: <20130125182614.10037.79953.stgit@maximpc.sw.ru>
In-Reply-To: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is:

1. write cached data to a file
2. read directly from the same file (via another fd)

The 2nd operation may read stale data, i.e. the one that was in a file
before the 1st op. Problem is in how fuse manages writeback.

When direct op occurs the core kernel code calls filemap_write_and_wait
to flush all the cached ops in flight. But fuse acks the writeback right
after the ->writepages callback exits w/o waiting for the real write to
happen. Thus the subsequent direct op proceeds while the real writeback
is still in flight. This is a problem for backends that reorder operation.

Fix this by making the fuse direct IO callback explicitly wait on the
in-flight writeback to finish.

Changed in v2:
 - do not wait on writeback if fuse_direct_io() call came from
   CUSE (because it doesn't use fuse inodes)

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    5 +++--
 fs/fuse/file.c   |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h |   13 ++++++++++++-
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 6f96a8d..fb63185 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -93,7 +93,7 @@ static ssize_t cuse_read(struct file *file, char __user *buf, size_t count,
 	loff_t pos = 0;
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
 
-	return fuse_direct_io(file, &iov, 1, count, &pos, 0);
+	return fuse_direct_io(file, &iov, 1, count, &pos, FUSE_DIO_CUSE);
 }
 
 static ssize_t cuse_write(struct file *file, const char __user *buf,
@@ -106,7 +106,8 @@ static ssize_t cuse_write(struct file *file, const char __user *buf,
 	 * No locking or generic_write_checks(), the server is
 	 * responsible for locking and sanity checks.
 	 */
-	return fuse_direct_io(file, &iov, 1, count, &pos, 1);
+	return fuse_direct_io(file, &iov, 1, count, &pos,
+			      FUSE_DIO_WRITE | FUSE_DIO_CUSE);
 }
 
 static int cuse_open(struct inode *inode, struct file *file)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 3767824..e6e064c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -349,6 +349,31 @@ u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
 	return (u64) v0 + ((u64) v1 << 32);
 }
 
+static bool fuse_range_is_writeback(struct inode *inode, pgoff_t idx_from,
+				    pgoff_t idx_to)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_req *req;
+	bool found = false;
+
+	spin_lock(&fc->lock);
+	list_for_each_entry(req, &fi->writepages, writepages_entry) {
+		pgoff_t curr_index;
+
+		BUG_ON(req->inode != inode);
+		curr_index = req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
+		if (!(idx_from >= curr_index + req->num_pages ||
+		      idx_to < curr_index)) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&fc->lock);
+
+	return found;
+}
+
 /*
  * Check if page is under writeback
  *
@@ -393,6 +418,19 @@ static int fuse_wait_on_page_writeback(struct inode *inode, pgoff_t index)
 	return 0;
 }
 
+static void fuse_wait_on_writeback(struct inode *inode, pgoff_t start,
+				   size_t bytes)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	pgoff_t idx_from, idx_to;
+
+	idx_from = start >> PAGE_CACHE_SHIFT;
+	idx_to = (start + bytes - 1) >> PAGE_CACHE_SHIFT;
+
+	wait_event(fi->page_waitq,
+		   !fuse_range_is_writeback(inode, idx_from, idx_to));
+}
+
 static int fuse_flush(struct file *file, fl_owner_t id)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1245,8 +1283,10 @@ static inline int fuse_iter_npages(const struct iov_iter *ii_p)
 
 ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		       unsigned long nr_segs, size_t count, loff_t *ppos,
-		       int write)
+		       int flags)
 {
+	int write = flags & FUSE_DIO_WRITE;
+	int cuse = flags & FUSE_DIO_CUSE;
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fc;
 	size_t nmax = write ? fc->max_write : fc->max_read;
@@ -1271,6 +1311,10 @@ ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 			break;
 		}
 
+		if (!cuse)
+			fuse_wait_on_writeback(file->f_mapping->host, pos,
+					       nbytes);
+
 		if (write)
 			nres = fuse_send_write(req, file, pos, nbytes, owner);
 		else
@@ -1339,7 +1383,8 @@ static ssize_t __fuse_direct_write(struct file *file, const struct iovec *iov,
 
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res) {
-		res = fuse_direct_io(file, iov, nr_segs, count, ppos, 1);
+		res = fuse_direct_io(file, iov, nr_segs, count, ppos,
+				     FUSE_DIO_WRITE);
 		if (res > 0) {
 			struct fuse_inode *fi = get_fuse_inode(inode);
 			fuse_write_update_size(inode, *ppos);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index fdeccc5..86caa8c 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -823,9 +823,20 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
 
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir);
+
+/**
+ * fuse_direct_io() flags
+ */
+
+/** If set, it is WRITE; otherwise - READ */
+#define FUSE_DIO_WRITE (1 << 0)
+
+/** CUSE pass fuse_direct_io() a file which f_mapping->host is not from FUSE */
+#define FUSE_DIO_CUSE  (1 << 1)
+
 ssize_t fuse_direct_io(struct file *file, const struct iovec *iov,
 		       unsigned long nr_segs, size_t count, loff_t *ppos,
-		       int write);
+		       int flags);
 long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		   unsigned int flags);
 long fuse_ioctl_common(struct file *file, unsigned int cmd,

