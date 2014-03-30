Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaCaAGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:06:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbaC3Xmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>,
        "Miklos Szeredi" <mszeredi@suse.cz>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.18487638@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 050/200] fuse: fix pipe_buf_operations
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dev.c             | 22 +++++-----------------
 fs/splice.c               | 18 ++++++++++++++++++
 include/linux/pipe_fs_i.h |  2 ++
 net/core/skbuff.c         | 32 +-------------------------------
 4 files changed, 26 insertions(+), 48 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1199,22 +1199,6 @@ static ssize_t fuse_dev_read(struct kioc
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
@@ -1261,7 +1245,11 @@ static ssize_t fuse_dev_splice_read(stru
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
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -554,6 +554,24 @@ static const struct pipe_buf_operations
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
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -160,6 +160,8 @@ int generic_pipe_buf_confirm(struct pipe
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
+extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
+
 /* for F_SETPIPE_SZ and F_GETPIPE_SZ */
 long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
 struct pipe_inode_info *get_pipe_info(struct file *file);
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -74,36 +74,6 @@
 static struct kmem_cache *skbuff_head_cache __read_mostly;
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
 /*
  *	Keep out-of-line to prevent kernel bloat.
  *	__builtin_return_address is not used because it is not always
@@ -1665,7 +1635,7 @@ int skb_splice_bits(struct sk_buff *skb,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
 		.flags = flags,
-		.ops = &sock_pipe_buf_ops,
+		.ops = &nosteal_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	struct sk_buff *frag_iter;

