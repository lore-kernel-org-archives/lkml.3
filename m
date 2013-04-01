Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab3DAKkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:40:43 -0400
Received: from relay.parallels.com ([195.214.232.42]:54487 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab3DAKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:40:41 -0400
Subject: [PATCH 04/14] fuse: Prepare to handle multiple pages in writeback
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:41:16 +0400
Message-ID: <20130401104111.19027.1794.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .writepages callback will issue writeback requests with more than one
page aboard. Make existing end/check code be aware of this.

Original patch by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 648de34..ee44b24 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -345,7 +345,8 @@ static bool fuse_page_is_writeback(struct inode *inode, pgoff_t index)
 
 		BUG_ON(req->inode != inode);
 		curr_index = req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
-		if (curr_index == index) {
+		if (curr_index <= index &&
+		    index < curr_index + req->num_pages) {
 			found = true;
 			break;
 		}
@@ -1295,7 +1296,10 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
-	__free_page(req->pages[0]);
+	int i;
+
+	for (i = 0; i < req->num_pages; i++)
+		__free_page(req->pages[i]);
 	fuse_file_put(req->ff, false);
 }
 
@@ -1304,10 +1308,13 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	struct inode *inode = req->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+	int i;
 
 	list_del(&req->writepages_entry);
-	dec_bdi_stat(bdi, BDI_WRITEBACK);
-	dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
+	for (i = 0; i < req->num_pages; i++) {
+		dec_bdi_stat(bdi, BDI_WRITEBACK);
+		dec_zone_page_state(req->pages[i], NR_WRITEBACK_TEMP);
+	}
 	bdi_writeout_inc(bdi);
 	wake_up(&fi->page_waitq);
 }
@@ -1320,14 +1327,15 @@ __acquires(fc->lock)
 	struct fuse_inode *fi = get_fuse_inode(req->inode);
 	loff_t size = i_size_read(req->inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
+	__u64 data_size = req->num_pages * PAGE_CACHE_SIZE;
 
 	if (!fc->connected)
 		goto out_free;
 
-	if (inarg->offset + PAGE_CACHE_SIZE <= size) {
-		inarg->size = PAGE_CACHE_SIZE;
+	if (inarg->offset + data_size <= size) {
+		inarg->size = data_size;
 	} else if (inarg->offset < size) {
-		inarg->size = size & (PAGE_CACHE_SIZE - 1);
+		inarg->size = size - inarg->offset;
 	} else {
 		/* Got truncated off completely */
 		goto out_free;

