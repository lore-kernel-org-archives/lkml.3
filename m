Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3AYSVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:21:32 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10218 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab3AYSV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:21:29 -0500
Subject: [PATCH 02/14] fuse: Getting file for writeback helper
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 25 Jan 2013 22:21:06 +0400
Message-ID: <20130125182056.10037.35850.stgit@maximpc.sw.ru>
In-Reply-To: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There will be a .writepageS callback implementation which will need to
get a fuse_file out of a fuse_inode, thus make a helper for this.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9bdc0fa..ad89b21 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1375,6 +1375,20 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 	fuse_writepage_free(fc, req);
 }
 
+static struct fuse_file *fuse_write_file(struct fuse_conn *fc,
+					 struct fuse_inode *fi)
+{
+	struct fuse_file *ff;
+
+	spin_lock(&fc->lock);
+	BUG_ON(list_empty(&fi->write_files));
+	ff = list_entry(fi->write_files.next, struct fuse_file, write_entry);
+	fuse_file_get(ff);
+	spin_unlock(&fc->lock);
+
+	return ff;
+}
+
 static int fuse_writepage_locked(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -1382,7 +1396,6 @@ static int fuse_writepage_locked(struct page *page)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
-	struct fuse_file *ff;
 	struct page *tmp_page;
 
 	set_page_writeback(page);
@@ -1395,13 +1408,8 @@ static int fuse_writepage_locked(struct page *page)
 	if (!tmp_page)
 		goto err_free;
 
-	spin_lock(&fc->lock);
-	BUG_ON(list_empty(&fi->write_files));
-	ff = list_entry(fi->write_files.next, struct fuse_file, write_entry);
-	req->ff = fuse_file_get(ff);
-	spin_unlock(&fc->lock);
-
-	fuse_write_fill(req, ff, page_offset(page), 0);
+	req->ff = fuse_write_file(fc, fi);
+	fuse_write_fill(req, req->ff, page_offset(page), 0);
 
 	copy_highpage(tmp_page, page);
 	req->misc.write.in.write_flags |= FUSE_WRITE_CACHE;

