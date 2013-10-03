Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3JCJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:57:10 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36976 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:57:08 -0400
Date: Thu, 3 Oct 2013 11:57:49 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] fuse: writepages: crop secondary requests
Message-ID: <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
 <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 09:38:32PM +0400, Maxim Patlasov wrote:
> If writeback happens while fuse is in FUSE_NOWRITE condition, the request
> will be queued but not processed immediately (see fuse_flush_writepages()).
> Until FUSE_NOWRITE becomes relaxed, more writebacks can happen. They will
> be queued as "secondary" requests to that first ("primary") request.
> 
> Existing implementation crops only primary request. This is not correct
> because a subsequent extending write(2) may increase i_size and then secondary
> requests won't be cropped properly. The result would be stale data written to
> the server to a file offset where zeros must be.
> 
> Similar problem may happen if secondary requests are attached to an in-flight
> request that was already cropped.
> 
> The patch solves the issue by cropping all secondary requests in
> fuse_writepage_end(). Thanks to Miklos for idea.

How about this, even simpler, one?

Thanks,
Miklos


Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2013-10-03 11:27:00.597084704 +0200
+++ linux/fs/fuse/file.c	2013-10-03 11:53:30.477208467 +0200
@@ -1436,12 +1436,12 @@ static void fuse_writepage_finish(struct
 }
 
 /* Called under fc->lock, may release and reacquire it */
-static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
+static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req,
+				loff_t size)
 __releases(fc->lock)
 __acquires(fc->lock)
 {
 	struct fuse_inode *fi = get_fuse_inode(req->inode);
-	loff_t size = i_size_read(req->inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
 	__u64 data_size = req->num_pages * PAGE_CACHE_SIZE;
 
@@ -1476,7 +1476,7 @@ __acquires(fc->lock)
  *
  * Called with fc->lock
  */
-void fuse_flush_writepages(struct inode *inode)
+void __fuse_flush_writepages(struct inode *inode, loff_t crop)
 __releases(fc->lock)
 __acquires(fc->lock)
 {
@@ -1487,9 +1487,15 @@ __acquires(fc->lock)
 	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {
 		req = list_entry(fi->queued_writes.next, struct fuse_req, list);
 		list_del_init(&req->list);
-		fuse_send_writepage(fc, req);
+		fuse_send_writepage(fc, req, crop);
 	}
 }
+void fuse_flush_writepages(struct inode *inode)
+__releases(fc->lock)
+__acquires(fc->lock)
+{
+	__fuse_flush_writepages(inode, i_size_read(inode));
+}
 
 static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 {
@@ -1499,12 +1505,13 @@ static void fuse_writepage_end(struct fu
 	mapping_set_error(inode->i_mapping, req->out.h.error);
 	spin_lock(&fc->lock);
 	while (req->misc.write.next) {
+		struct fuse_write_in *inarg = &req->misc.write.in;
 		struct fuse_req *next = req->misc.write.next;
 		req->misc.write.next = next->misc.write.next;
 		next->misc.write.next = NULL;
 		list_add(&next->writepages_entry, &fi->writepages);
 		list_add_tail(&next->list, &fi->queued_writes);
-		fuse_flush_writepages(inode);
+		__fuse_flush_writepages(inode, inarg->offset + inarg->size);
 	}
 	fi->writectr--;
 	fuse_writepage_finish(fc, req);
