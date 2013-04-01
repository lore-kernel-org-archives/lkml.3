Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab3DAKmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:42:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:55244 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab3DAKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:42:11 -0400
Subject: [PATCH 13/14] fuse: Turn writeback cache on
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:42:45 +0400
Message-ID: <20130401104242.19027.82087.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
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
 fs/fuse/file.c            |    5 +++++
 fs/fuse/fuse_i.h          |    4 ++++
 fs/fuse/inode.c           |   13 +++++++++++++
 include/uapi/linux/fuse.h |    2 ++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 14880bb..5d2c77f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -205,6 +205,8 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 	}
+	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
+		fuse_link_write_file(file);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
@@ -1099,6 +1101,9 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct iov_iter i;
 	loff_t endbyte = 0;
 
+	if (get_fuse_conn(inode)->writeback_cache)
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+
 	WARN_ON(iocb->ki_pos != pos);
 
 	ocount = 0;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f54d669..f023814 100644
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
index 921930f..2271177 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -457,6 +457,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_ALLOW_WBCACHE,
 	OPT_ERR
 };
 
@@ -469,6 +470,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_ALLOW_WBCACHE,		"allow_wbcache"},
 	{OPT_ERR,			NULL}
 };
 
@@ -542,6 +544,10 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			d->blksize = value;
 			break;
 
+		case OPT_ALLOW_WBCACHE:
+			d->flags |= FUSE_ALLOW_WBCACHE;
+			break;
+
 		default:
 			return 0;
 		}
@@ -569,6 +575,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
 		seq_printf(m, ",blksize=%lu", sb->s_blocksize);
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		seq_puts(m, ",allow_wbcache");
 	return 0;
 }
 
@@ -882,6 +890,9 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 				fc->do_readdirplus = 1;
 			if (arg->flags & FUSE_READDIRPLUS_AUTO)
 				fc->readdirplus_auto = 1;
+			if (arg->flags & FUSE_WRITEBACK_CACHE &&
+			    fc->flags & FUSE_ALLOW_WBCACHE)
+				fc->writeback_cache = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -910,6 +921,8 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 		FUSE_SPLICE_WRITE | FUSE_SPLICE_MOVE | FUSE_SPLICE_READ |
 		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA |
 		FUSE_DO_READDIRPLUS | FUSE_READDIRPLUS_AUTO;
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		arg->flags |= FUSE_WRITEBACK_CACHE;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 4c43b44..6acda83 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -220,6 +220,7 @@ struct fuse_file_lock {
  * FUSE_AUTO_INVAL_DATA: automatically invalidate cached pages
  * FUSE_DO_READDIRPLUS: do READDIRPLUS (READDIR+LOOKUP in one)
  * FUSE_READDIRPLUS_AUTO: adaptive readdirplus
+ * FUSE_WRITEBACK_CACHE: use writeback cache for buffered writes
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -236,6 +237,7 @@ struct fuse_file_lock {
 #define FUSE_AUTO_INVAL_DATA	(1 << 12)
 #define FUSE_DO_READDIRPLUS	(1 << 13)
 #define FUSE_READDIRPLUS_AUTO	(1 << 14)
+#define FUSE_WRITEBACK_CACHE	(1 << 15)
 
 /**
  * CUSE INIT request/reply flags

