Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3JJNMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:12:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:48439 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3JJNM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:12:27 -0400
Subject: [PATCH 11/11] fuse: Turn writeback cache on
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Thu, 10 Oct 2013 17:12:18 +0400
Message-ID: <20131010131210.10089.94645.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

Introduce a bit kernel and userspace exchange between each-other on
the init stage and turn writeback on if the userspace want this and
mount option 'allow_wbcache' is present (controlled by fusermount).

Also add each writable file into per-inode write list and call the
generic_file_aio_write to make use of the Linux page cache engine.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c            |    5 +++++
 fs/fuse/fuse_i.h          |    4 ++++
 fs/fuse/inode.c           |   13 +++++++++++++
 include/uapi/linux/fuse.h |    2 ++
 4 files changed, 24 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 653ae9c..aa38e77 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -208,6 +208,8 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		spin_unlock(&fc->lock);
 		fuse_invalidate_attr(inode);
 	}
+	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
+		fuse_link_write_file(file);
 }
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
@@ -1228,6 +1230,9 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct iov_iter i;
 	loff_t endbyte = 0;
 
+	if (get_fuse_conn(inode)->writeback_cache)
+		return generic_file_aio_write(iocb, iov, nr_segs, pos);
+
 	WARN_ON(iocb->ki_pos != pos);
 
 	ocount = 0;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 129af78..76c4f77 100644
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
index 253701f..6ddf135 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -460,6 +460,7 @@ enum {
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
+	OPT_ALLOW_WBCACHE,
 	OPT_ERR
 };
 
@@ -472,6 +473,7 @@ static const match_table_t tokens = {
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
 	{OPT_BLKSIZE,			"blksize=%u"},
+	{OPT_ALLOW_WBCACHE,		"allow_wbcache"},
 	{OPT_ERR,			NULL}
 };
 
@@ -545,6 +547,10 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			d->blksize = value;
 			break;
 
+		case OPT_ALLOW_WBCACHE:
+			d->flags |= FUSE_ALLOW_WBCACHE;
+			break;
+
 		default:
 			return 0;
 		}
@@ -572,6 +578,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
 		seq_printf(m, ",blksize=%lu", sb->s_blocksize);
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		seq_puts(m, ",allow_wbcache");
 	return 0;
 }
 
@@ -889,6 +897,9 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 			}
 			if (arg->flags & FUSE_ASYNC_DIO)
 				fc->async_dio = 1;
+			if (arg->flags & FUSE_WRITEBACK_CACHE &&
+			    fc->flags & FUSE_ALLOW_WBCACHE)
+				fc->writeback_cache = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -917,6 +928,8 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 		FUSE_SPLICE_WRITE | FUSE_SPLICE_MOVE | FUSE_SPLICE_READ |
 		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA |
 		FUSE_DO_READDIRPLUS | FUSE_READDIRPLUS_AUTO | FUSE_ASYNC_DIO;
+	if (fc->flags & FUSE_ALLOW_WBCACHE)
+		arg->flags |= FUSE_WRITEBACK_CACHE;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 60bb2f9..5c98dd1 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -219,6 +219,7 @@ struct fuse_file_lock {
  * FUSE_DO_READDIRPLUS: do READDIRPLUS (READDIR+LOOKUP in one)
  * FUSE_READDIRPLUS_AUTO: adaptive readdirplus
  * FUSE_ASYNC_DIO: asynchronous direct I/O submission
+ * FUSE_WRITEBACK_CACHE: use writeback cache for buffered writes
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -236,6 +237,7 @@ struct fuse_file_lock {
 #define FUSE_DO_READDIRPLUS	(1 << 13)
 #define FUSE_READDIRPLUS_AUTO	(1 << 14)
 #define FUSE_ASYNC_DIO		(1 << 15)
+#define FUSE_WRITEBACK_CACHE	(1 << 16)
 
 /**
  * CUSE INIT request/reply flags

