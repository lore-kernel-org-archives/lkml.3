Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab3AYS2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:28:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31427 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab3AYS2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:28:09 -0500
Subject: [PATCH 13/14] fuse: Turn writeback cache on
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 25 Jan 2013 22:27:47 +0400
Message-ID: <20130125182711.10037.38176.stgit@maximpc.sw.ru>
In-Reply-To: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a bit kernel and userspace exchange between each-other on
the init stage and turn writeback on if the userspace want this and
mount option 'allow_wbcache' is present (controlled by fusermount).

Also add each writable file into per-inode write list and call the
generic_file_aio_write to make use of the Linux page cache engine.

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c            |   15 +++++++++++++++
 fs/fuse/fuse_i.h          |    4 ++++
 fs/fuse/inode.c           |   13 +++++++++++++
 include/uapi/linux/fuse.h |    2 ++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e6e064c..147e618 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -211,6 +211,8 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 	}
+	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
+		fuse_link_write_file(file);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
@@ -1096,6 +1098,19 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct iov_iter i;
 	loff_t endbyte = 0;
 
+	if (get_fuse_conn(inode)->writeback_cache) {
+		if (!(file->f_flags & O_DIRECT)) {
+			struct fuse_conn *fc = get_fuse_conn(inode);
+			struct fuse_inode *fi = get_fuse_inode(inode);
+
+			spin_lock(&fc->lock);
+			inode->i_mtime = current_fs_time(inode->i_sb);
+			set_bit(FUSE_I_MTIME_UPDATED, &fi->state);
+			spin_unlock(&fc->lock);
+		}
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	}
+
 	WARN_ON(iocb->ki_pos != pos);
 
 	ocount = 0;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 86caa8c..a207744 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -44,6 +44,10 @@
     doing the mount will be allowed to access the filesystem */
 #define FUSE_ALLOW_OTHER         (1 << 1)
 
+/** If the FUSE_ALLOW_WBCACHE flag is given, the filesystem
+    module will enable support of writback cache */
+#define FUSE_ALLOW_WBCACHE       (1 << 2)
+
 /** Number of page pointers embedded in fuse_req */
 #define FUSE_REQ_INLINE_PAGES 1
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3687daf..541fc4f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -521,6 +521,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_ALLOW_WBCACHE,
 	OPT_ERR
 };
 
@@ -533,6 +534,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_ALLOW_WBCACHE,		"allow_wbcache"},
 	{OPT_ERR,			NULL}
 };
 
@@ -606,6 +608,10 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			d->blksize = value;
 			break;
 
+		case OPT_ALLOW_WBCACHE:
+			d->flags |= FUSE_ALLOW_WBCACHE;
+			break;
+
 		default:
 			return 0;
 		}
@@ -633,6 +639,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
 		seq_printf(m, ",blksize=%lu", sb->s_blocksize);
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		seq_puts(m, ",allow_wbcache");
 	return 0;
 }
 
@@ -944,6 +952,9 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 				fc->auto_inval_data = 1;
 			if (arg->flags & FUSE_DO_READDIRPLUS)
 				fc->do_readdirplus = 1;
+			if (arg->flags & FUSE_WRITEBACK_CACHE &&
+			    fc->flags & FUSE_ALLOW_WBCACHE)
+				fc->writeback_cache = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -972,6 +983,8 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 		FUSE_SPLICE_WRITE | FUSE_SPLICE_MOVE | FUSE_SPLICE_READ |
 		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA |
 		FUSE_DO_READDIRPLUS;
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		arg->flags |= FUSE_WRITEBACK_CACHE;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5dc1fea..20a9553 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -179,6 +179,7 @@ struct fuse_file_lock {
  * FUSE_FLOCK_LOCKS: remote locking for BSD style file locks
  * FUSE_HAS_IOCTL_DIR: kernel supports ioctl on directories
  * FUSE_AUTO_INVAL_DATA: automatically invalidate cached pages
+ * FUSE_WRITEBACK_CACHE: use writeback cache for buffered writes
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -194,6 +195,7 @@ struct fuse_file_lock {
 #define FUSE_HAS_IOCTL_DIR	(1 << 11)
 #define FUSE_AUTO_INVAL_DATA	(1 << 12)
 #define FUSE_DO_READDIRPLUS	(1 << 13)
+#define FUSE_WRITEBACK_CACHE	(1 << 14)
 
 /**
  * CUSE INIT request/reply flags

