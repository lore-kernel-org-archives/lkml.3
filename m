Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3F2Rmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 13:42:40 -0400
Received: from relay.parallels.com ([195.214.232.42]:51407 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3F2Rma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 13:42:30 -0400
Subject: [PATCH 02/16] fuse: Getting file for writeback helper
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: riel@redhat.com, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        linux-mm@kvack.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, devel@openvz.org, mgorman@suse.de
Date: Sat, 29 Jun 2013 21:42:20 +0400
Message-ID: <20130629174215.20175.22933.stgit@maximpc.sw.ru>
In-Reply-To: <20130629172211.20175.70154.stgit@maximpc.sw.ru>
References: <20130629172211.20175.70154.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

There will be a .writepageS callback implementation which will need to
get a fuse_file out of a fuse_inode, thus make a helper for this.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cc858ee..6b6d307 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1505,6 +1505,20 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
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
@@ -1512,7 +1526,6 @@ static int fuse_writepage_locked(struct page *page)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
-	struct fuse_file *ff;
 	struct page *tmp_page;
 
 	set_page_writeback(page);
@@ -1526,13 +1539,8 @@ static int fuse_writepage_locked(struct page *page)
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

