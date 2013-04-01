Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab3DAKlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 06:41:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:54935 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3DAKln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 06:41:43 -0400
Subject: [PATCH 10/14] fuse: fuse_writepage_locked() should wait on writeback
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Date: Mon, 01 Apr 2013 14:42:18 +0400
Message-ID: <20130401104214.19027.30729.stgit@maximpc.sw.ru>
In-Reply-To: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_writepage_locked() should never submit new i/o for given page->index
if there is another one 'in progress' already. In most cases it's safe to
wait on page writeback. But if it was called due to memory shortage
(WB_SYNC_NONE), we should redirty page rather than blocking caller.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6ceffdf..2409654 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1472,7 +1472,8 @@ static struct fuse_file *fuse_write_file(struct fuse_conn *fc,
 	return ff;
 }
 
-static int fuse_writepage_locked(struct page *page)
+static int fuse_writepage_locked(struct page *page,
+				 struct writeback_control *wbc)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
@@ -1481,6 +1482,14 @@ static int fuse_writepage_locked(struct page *page)
 	struct fuse_req *req;
 	struct page *tmp_page;
 
+	if (fuse_page_is_writeback(inode, page->index)) {
+		if (wbc->sync_mode != WB_SYNC_ALL) {
+			redirty_page_for_writepage(wbc, page);
+			return 0;
+		}
+		fuse_wait_on_page_writeback(inode, page->index);
+	}
+
 	set_page_writeback(page);
 
 	req = fuse_request_alloc_nofs(1);
@@ -1527,7 +1536,7 @@ static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int err;
 
-	err = fuse_writepage_locked(page);
+	err = fuse_writepage_locked(page, wbc);
 	unlock_page(page);
 
 	return err;
@@ -1797,7 +1806,10 @@ static int fuse_launder_page(struct page *page)
 	int err = 0;
 	if (clear_page_dirty_for_io(page)) {
 		struct inode *inode = page->mapping->host;
-		err = fuse_writepage_locked(page);
+		struct writeback_control wbc = {
+			.sync_mode = WB_SYNC_ALL,
+		};
+		err = fuse_writepage_locked(page, &wbc);
 		if (!err)
 			fuse_wait_on_page_writeback(inode, page->index);
 	}

