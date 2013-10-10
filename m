Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JJNKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:10:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:48128 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3JJNK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:10:27 -0400
Subject: [PATCH 02/11] fuse: Prepare to handle short reads
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Thu, 10 Oct 2013 17:10:16 +0400
Message-ID: <20131010131010.10089.38632.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

A helper which gets called when read reports less bytes than was requested.
See patch #4 (trust kernel i_size only) for details.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/fuse/file.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5e49c8f..886f3a2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -654,6 +654,15 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
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
 	struct fuse_io_priv io = { .async = 0, .file = file };
@@ -691,18 +700,18 @@ static int fuse_readpage(struct file *file, struct page *page)
 	req->page_descs[0].length = count;
 	num_read = fuse_send_read(req, &io, pos, count, NULL);
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
@@ -725,13 +734,9 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
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
 

