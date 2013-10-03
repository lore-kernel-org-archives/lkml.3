Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3JCPNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:13:54 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:40837 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3JCPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:13:51 -0400
Date: Thu, 3 Oct 2013 17:14:32 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] fuse: writepages: crop secondary requests
Message-ID: <20131003151432.GE14242@tucsk.piliscsaba.szeredi.hu>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
 <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru>
 <20131003095749.GB14242@tucsk.piliscsaba.szeredi.hu>
 <524D70FE.5000701@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D70FE.5000701@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 05:28:30PM +0400, Maxim Patlasov wrote:

> 1. There is an in-flight primary request with a chain of secondary ones.
> 2. User calls ftruncate(2) to extend file; fuse_set_nowrite() makes
> fi->writectr negative and starts waiting for completion of that
> in-flight request
> 3. Userspace fuse daemon ACKs the request and fuse_writepage_end()
> is called; it calls __fuse_flush_writepages(), but the latter does
> nothing because fi->writectr < 0
> 4. fuse_do_setattr() proceeds extending i_size and calling
> __fuse_release_nowrite(). But now new (increased) i_size will be
> used as 'crop' arg of __fuse_flush_writepages()
> 
> stale data can leak to the server.

So, lets do this then: skip fuse_flush_writepages() and call
fuse_send_writepage() directly.  It will ignore the NOWRITE logic, but that's
okay, this happens rarely and cannot happen more than once in a row.

Does this look good?

Can you actually trigger this path with your testing?

Thanks,
Miklos


Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2013-10-03 12:12:33.480918954 +0200
+++ linux/fs/fuse/file.c	2013-10-03 17:06:23.702510854 +0200
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
 
@@ -1482,12 +1482,13 @@ __acquires(fc->lock)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	size_t crop = i_size_read(inode);
 	struct fuse_req *req;
 
 	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {
 		req = list_entry(fi->queued_writes.next, struct fuse_req, list);
 		list_del_init(&req->list);
-		fuse_send_writepage(fc, req);
+		fuse_send_writepage(fc, req, crop);
 	}
 }
 
@@ -1499,12 +1500,13 @@ static void fuse_writepage_end(struct fu
 	mapping_set_error(inode->i_mapping, req->out.h.error);
 	spin_lock(&fc->lock);
 	while (req->misc.write.next) {
+		struct fuse_conn *fc = get_fuse_conn(inode);
+		struct fuse_write_in *inarg = &req->misc.write.in;
 		struct fuse_req *next = req->misc.write.next;
 		req->misc.write.next = next->misc.write.next;
 		next->misc.write.next = NULL;
 		list_add(&next->writepages_entry, &fi->writepages);
-		list_add_tail(&next->list, &fi->queued_writes);
-		fuse_flush_writepages(inode);
+		fuse_send_writepage(fc, next, inarg->offset + inarg->size);
 	}
 	fi->writectr--;
 	fuse_writepage_finish(fc, req);
