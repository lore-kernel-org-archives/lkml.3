Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaBGLve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaBGLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 161/233] fuse: fix pipe_buf_operations
Date: Fri,  7 Feb 2014 11:46:20 +0000
Message-Id: <1391773652-25214-162-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 28a625cbc2a14f17b83e47ef907b2658576a32aa upstream.

Having this struct in module memory could Oops when if the module is
unloaded while the buffer still persists in a pipe.

Since sock_pipe_buf_ops is essentially the same as fuse_dev_pipe_buf_steal
merge them into nosteal_pipe_buf_ops (this is the same as
default_pipe_buf_ops except stealing the page from the buffer is not
allowed).

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/dev.c             | 22 +++++-----------------
 fs/splice.c               | 18 ++++++++++++++++++
 include/linux/pipe_fs_i.h |  2 ++
 net/core/skbuff.c         | 32 +-------------------------------
 4 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1d55f94..23bf1a5 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1296,22 +1296,6 @@ static ssize_t fuse_dev_read(struct kiocb *iocb, const struct iovec *iov,
 	return fuse_dev_do_read(fc, file, &cs, iov_length(iov, nr_segs));
 }
 
-static int fuse_dev_pipe_buf_steal(struct pipe_inode_info *pipe,
-				   struct pipe_buffer *buf)
-{
-	return 1;
-}
-
-static const struct pipe_buf_operations fuse_dev_pipe_buf_ops = {
-	.can_merge = 0,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
-	.confirm = generic_pipe_buf_confirm,
-	.release = generic_pipe_buf_release,
-	.steal = fuse_dev_pipe_buf_steal,
-	.get = generic_pipe_buf_get,
-};
-
 static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 				    struct pipe_inode_info *pipe,
 				    size_t len, unsigned int flags)
@@ -1358,7 +1342,11 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 		buf->page = bufs[page_nr].page;
 		buf->offset = bufs[page_nr].offset;
 		buf->len = bufs[page_nr].len;
-		buf->ops = &fuse_dev_pipe_buf_ops;
+		/*
+		 * Need to be careful about this.  Having buf->ops in module
+		 * code can Oops if the buffer persists after module unload.
+		 */
+		buf->ops = &nosteal_pipe_buf_ops;
 
 		pipe->nrbufs++;
 		page_nr++;
diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee65..84f810d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -555,6 +555,24 @@ static const struct pipe_buf_operations default_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
+static int generic_pipe_buf_nosteal(struct pipe_inode_info *pipe,
+				    struct pipe_buffer *buf)
+{
+	return 1;
+}
+
+/* Pipe buffer operations for a socket and similar. */
+const struct pipe_buf_operations nosteal_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = generic_pipe_buf_release,
+	.steal = generic_pipe_buf_nosteal,
+	.get = generic_pipe_buf_get,
+};
+EXPORT_SYMBOL(nosteal_pipe_buf_ops);
+
 static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
 			    unsigned long vlen, loff_t offset)
 {
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index b8809fe..ab57526 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -157,6 +157,8 @@ int generic_pipe_buf_confirm(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
+extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
+
 /* for F_SETPIPE_SZ and F_GETPIPE_SZ */
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
 struct pipe_inode_info *get_pipe_info(struct file *file);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b2cd9a4..290f73b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -74,36 +74,6 @@
 struct kmem_cache *skbuff_head_cache __read_mostly;
 static struct kmem_cache *skbuff_fclone_cache __read_mostly;
 
-static void sock_pipe_buf_release(struct pipe_inode_info *pipe,
-				  struct pipe_buffer *buf)
-{
-	put_page(buf->page);
-}
-
-static void sock_pipe_buf_get(struct pipe_inode_info *pipe,
-				struct pipe_buffer *buf)
-{
-	get_page(buf->page);
-}
-
-static int sock_pipe_buf_steal(struct pipe_inode_info *pipe,
-			       struct pipe_buffer *buf)
-{
-	return 1;
-}
-
-
-/* Pipe buffer operations for a socket. */
-static const struct pipe_buf_operations sock_pipe_buf_ops = {
-	.can_merge = 0,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
-	.confirm = generic_pipe_buf_confirm,
-	.release = sock_pipe_buf_release,
-	.steal = sock_pipe_buf_steal,
-	.get = sock_pipe_buf_get,
-};
-
 /**
  *	skb_panic - private function for out-of-line support
  *	@skb:	buffer
@@ -1800,7 +1770,7 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
 		.flags = flags,
-		.ops = &sock_pipe_buf_ops,
+		.ops = &nosteal_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	struct sk_buff *frag_iter;
-- 
1.8.3.2

