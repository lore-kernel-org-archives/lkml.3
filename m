Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaJTFTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:59737 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaJTFSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:37 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 03/09] f2fs: should truncate any allocated block for inline_data write
Date: Sun, 19 Oct 2014 22:18:26 -0700
Message-Id: <1413782312-11631-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to write inline_data, we should truncate any data block allocated
and pointed by the inode block.
We should consider the data index is not 0.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 88036fd..e3abcfb 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -166,6 +166,14 @@ int f2fs_write_inline_data(struct inode *inode,
 		return err;
 	ipage = dn.inode_page;
 
+	/* Release any data block if it is allocated */
+	if (!f2fs_has_inline_data(inode)) {
+		int count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
+		truncate_data_blocks_range(&dn, count);
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+		stat_inc_inline_inode(inode);
+	}
+
 	f2fs_wait_on_page_writeback(ipage, NODE);
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
@@ -174,13 +182,6 @@ int f2fs_write_inline_data(struct inode *inode,
 	memcpy(dst_addr, src_addr, size);
 	kunmap(page);
 
-	/* Release the first data block if it is allocated */
-	if (!f2fs_has_inline_data(inode)) {
-		truncate_data_blocks_range(&dn, 1);
-		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
-		stat_inc_inline_inode(inode);
-	}
-
 	set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
 	sync_inode_page(&dn);
 	f2fs_put_dnode(&dn);
-- 
2.1.1

