Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3JBRif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:38:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:39814 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3JBRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:38:33 -0400
Subject: [PATCH 2/4] fuse: writepages: crop secondary requests
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 21:38:32 +0400
Message-ID: <20131002173823.31188.77171.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If writeback happens while fuse is in FUSE_NOWRITE condition, the request
will be queued but not processed immediately (see fuse_flush_writepages()).
Until FUSE_NOWRITE becomes relaxed, more writebacks can happen. They will
be queued as "secondary" requests to that first ("primary") request.

Existing implementation crops only primary request. This is not correct
because a subsequent extending write(2) may increase i_size and then secondary
requests won't be cropped properly. The result would be stale data written to
the server to a file offset where zeros must be.

Similar problem may happen if secondary requests are attached to an in-flight
request that was already cropped.

The patch solves the issue by cropping all secondary requests in
fuse_writepage_end(). Thanks to Miklos for idea.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   52 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 575e44f..a3c7123 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1435,6 +1435,22 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up(&fi->page_waitq);
 }
 
+/* Returns zero if the request is truncated off completely */
+static inline loff_t fuse_crop_request(struct fuse_req *req, loff_t size)
+{
+	struct fuse_write_in *inarg = &req->misc.write.in;
+	__u64 data_size = inarg->size ? : req->num_pages * PAGE_CACHE_SIZE;
+
+	if (inarg->offset + data_size <= size)
+		inarg->size = data_size;
+	else if (inarg->offset < size)
+		inarg->size = size - inarg->offset;
+	else
+		return 0;
+
+	return inarg->size;
+}
+
 /* Called under fc->lock, may release and reacquire it */
 static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
 __releases(fc->lock)
@@ -1442,22 +1458,14 @@ __acquires(fc->lock)
 {
 	struct fuse_inode *fi = get_fuse_inode(req->inode);
 	loff_t size = i_size_read(req->inode);
-	struct fuse_write_in *inarg = &req->misc.write.in;
-	__u64 data_size = req->num_pages * PAGE_CACHE_SIZE;
 
 	if (!fc->connected)
 		goto out_free;
 
-	if (inarg->offset + data_size <= size) {
-		inarg->size = data_size;
-	} else if (inarg->offset < size) {
-		inarg->size = size - inarg->offset;
-	} else {
-		/* Got truncated off completely */
-		goto out_free;
-	}
+	req->in.args[1].size = fuse_crop_request(req, size);
+	if (req->in.args[1].size == 0)
+		goto out_free; /* Got truncated off completely */
 
-	req->in.args[1].size = inarg->size;
 	fi->writectr++;
 	fuse_request_send_background_locked(fc, req);
 	return;
@@ -1495,13 +1503,24 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct inode *inode = req->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_req *drop = NULL;
 
 	mapping_set_error(inode->i_mapping, req->out.h.error);
 	spin_lock(&fc->lock);
 	while (req->misc.write.next) {
 		struct fuse_req *next = req->misc.write.next;
+		struct fuse_write_in *inarg = &req->misc.write.in;
+		loff_t size = inarg->offset + inarg->size;
+
 		req->misc.write.next = next->misc.write.next;
 		next->misc.write.next = NULL;
+
+		if (fuse_crop_request(next, size) == 0) {
+			next->misc.write.next = drop;
+			drop = next;
+			continue;
+		}
+
 		list_add(&next->writepages_entry, &fi->writepages);
 		list_add_tail(&next->list, &fi->queued_writes);
 		fuse_flush_writepages(inode);
@@ -1510,6 +1529,17 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 	fuse_writepage_finish(fc, req);
 	spin_unlock(&fc->lock);
 	fuse_writepage_free(fc, req);
+
+	while (drop) {
+		struct fuse_req *next = drop->misc.write.next;
+		struct backing_dev_info *bdi =
+			drop->inode->i_mapping->backing_dev_info;
+		dec_bdi_stat(bdi, BDI_WRITEBACK);
+		dec_zone_page_state(drop->pages[0], NR_WRITEBACK_TEMP);
+		fuse_writepage_free(fc, drop);
+		fuse_put_request(fc, drop);
+		drop = next;
+	}
 }
 
 static struct fuse_file *fuse_write_file_get(struct fuse_conn *fc,

