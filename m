Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaAQPwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:52:43 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62388 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaAQPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:52:41 -0500
Date: Fri, 17 Jan 2014 16:53:30 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [oops?] what protects buf->ops->confirm() from rmmod fuse
 unmapping buf->ops?
Message-ID: <20140117155330.GH24171@tucsk.piliscsaba.szeredi.hu>
References: <20140117045949.GZ10323@ZenIV.linux.org.uk>
 <CAJfpeguAvP5Sxo5T7foc4Y=JWk-sA38X91w=gM8kfJ2wZe8MRA@mail.gmail.com>
 <20140117114832.GB10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117114832.GB10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 11:48:32AM +0000, Al Viro wrote:
> On Fri, Jan 17, 2014 at 10:49:30AM +0100, Miklos Szeredi wrote:
> 
> > Can't we just move the  fuse_dev_pipe_buf_ops to some non-modular
> > place (splice.c).  It's a hack, yes, but it seems to be the simplest
> > fix.
> 
> Umm...  Not even that much of a hack, really, when you consider that it
> ends up identical to socket pipe_buf_ops (page_cache_release() and
> put_page() are the same thing, so sock_pipe_buf_release() is the same
> as generic_pipe_buf_release()).  Might as well merge them (and
> take to pipe.c or splice.c)...

Okay, patch below.

Thanks,
Miklos
----

Subject: fuse: fix pipe_buf_operations
From: Miklos Szeredi <mszeredi@suse.cz>

Having this struct in module memory could Oops when if the module is
unloaded while the buffer still persists in a pipe.

Since sock_pipe_buf_ops is essentially the same as fuse_dev_pipe_buf_steal
merge them into nosteal_pipe_buf_ops (this is the same as
default_pipe_buf_ops except stealing the page from the buffer is not
allowed).

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/fuse/dev.c             |   22 +++++-----------------
 fs/splice.c               |   19 +++++++++++++++++++
 include/linux/pipe_fs_i.h |    2 ++
 net/core/skbuff.c         |   32 +-------------------------------
 4 files changed, 27 insertions(+), 48 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1296,22 +1296,6 @@ static ssize_t fuse_dev_read(struct kioc
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
@@ -1358,7 +1342,11 @@ static ssize_t fuse_dev_splice_read(stru
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
@@ -555,6 +555,25 @@ static const struct pipe_buf_operations
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
+
 static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
 			    unsigned long vlen, loff_t offset)
 {
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -157,6 +157,8 @@ int generic_pipe_buf_confirm(struct pipe
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
@@ -1830,7 +1800,7 @@ int skb_splice_bits(struct sk_buff *skb,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
 		.flags = flags,
-		.ops = &sock_pipe_buf_ops,
+		.ops = &nosteal_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	struct sk_buff *frag_iter;
