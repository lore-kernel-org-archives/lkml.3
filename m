Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612Ab3IEJ2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763532Ab3IEJ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/6] GFS2: Merge ordered and writeback writepage
Date: Thu,  5 Sep 2013 10:02:09 +0100
Message-Id: <1378371732-3947-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
References: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The writepages function was recently merged between writeback
and ordered mode. This completes the change by doing the same
with writepage. The remaining differences in writepage were
left over from some earlier time and not actually doing anything
useful.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index ee48ad3..a9ea6f0 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -122,14 +122,13 @@ out:
 }
 
 /**
- * gfs2_writeback_writepage - Write page for writeback mappings
+ * gfs2_writepage - Write page for writeback mappings
  * @page: The page
  * @wbc: The writeback control
  *
  */
 
-static int gfs2_writeback_writepage(struct page *page,
-				    struct writeback_control *wbc)
+static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
 
@@ -141,32 +140,6 @@ static int gfs2_writeback_writepage(struct page *page,
 }
 
 /**
- * gfs2_ordered_writepage - Write page for ordered data files
- * @page: The page to write
- * @wbc: The writeback control
- *
- */
-
-static int gfs2_ordered_writepage(struct page *page,
-				  struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	int ret;
-
-	ret = gfs2_writepage_common(page, wbc);
-	if (ret <= 0)
-		return ret;
-
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				     (1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	gfs2_page_add_databufs(ip, page, 0, inode->i_sb->s_blocksize-1);
-	return block_write_full_page(page, gfs2_get_block_noalloc, wbc);
-}
-
-/**
  * __gfs2_jdata_writepage - The core of jdata writepage
  * @page: The page to write
  * @wbc: The writeback control
@@ -1107,7 +1080,7 @@ cannot_release:
 }
 
 static const struct address_space_operations gfs2_writeback_aops = {
-	.writepage = gfs2_writeback_writepage,
+	.writepage = gfs2_writepage,
 	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
@@ -1123,7 +1096,7 @@ static const struct address_space_operations gfs2_writeback_aops = {
 };
 
 static const struct address_space_operations gfs2_ordered_aops = {
-	.writepage = gfs2_ordered_writepage,
+	.writepage = gfs2_writepage,
 	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
-- 
1.7.4

