Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab3DAKkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:40:33 -0400
Received: from relay.parallels.com ([195.214.232.42]:54466 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3DAKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:40:31 -0400
Subject: [PATCH 03/14] fuse: Prepare to handle short reads
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:41:06 +0400
Message-ID: <20130401104100.19027.72423.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A helper which gets called when read reports less bytes than was requested.
See patch #6 (trust kernel i_size only) for details.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6fc65b4..648de34 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -538,6 +538,15 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	spin_unlock(&fc->lock);
 }
 
+static void fuse_short_read(struct fuse_req *req, struct inode *inode,
+			    u64 attr_ver)
+{
+	size_t num_read = req->out.args[0].size;
+
+	loff_t pos = page_offset(req->pages[0]) + num_read;
+	fuse_read_update_size(inode, pos, attr_ver);
+}
+
 static int fuse_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
@@ -574,18 +583,18 @@ static int fuse_readpage(struct file *file, struct page *page)
 	req->page_descs[0].length = count;
 	num_read = fuse_send_read(req, file, pos, count, NULL);
 	err = req->out.h.error;
-	fuse_put_request(fc, req);
 
 	if (!err) {
 		/*
 		 * Short read means EOF.  If file size is larger, truncate it
 		 */
 		if (num_read < count)
-			fuse_read_update_size(inode, pos + num_read, attr_ver);
+			fuse_short_read(req, inode, attr_ver);
 
 		SetPageUptodate(page);
 	}
 
+	fuse_put_request(fc, req);
 	fuse_invalidate_attr(inode); /* atime changed */
  out:
 	unlock_page(page);
@@ -608,13 +617,9 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		/*
 		 * Short read means EOF. If file size is larger, truncate it
 		 */
-		if (!req->out.h.error && num_read < count) {
-			loff_t pos;
+		if (!req->out.h.error && num_read < count)
+			fuse_short_read(req, inode, req->misc.read.attr_ver);
 
-			pos = page_offset(req->pages[0]) + num_read;
-			fuse_read_update_size(inode, pos,
-					      req->misc.read.attr_ver);
-		}
 		fuse_invalidate_attr(inode); /* atime changed */
 	}
 

