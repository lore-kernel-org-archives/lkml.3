Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521AbaKSWfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:35:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:54113 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbaKSWfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:35:17 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: call flush_dcache_page when the page was updated
Date: Wed, 19 Nov 2014 14:35:08 -0800
Message-Id: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 7 ++++++-
 fs/f2fs/inline.c | 4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 5a49995..312fbfc 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	f2fs_wait_on_page_writeback(page, type);
 	de->ino = cpu_to_le32(inode->i_ino);
 	set_de_type(de, inode);
-	if (!f2fs_has_inline_dentry(dir))
+	if (!f2fs_has_inline_dentry(dir)) {
 		kunmap(page);
+		flush_dcache_page(page);
+	}
 	set_page_dirty(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(dir);
@@ -366,6 +368,7 @@ static int make_empty_dir(struct inode *inode,
 	do_make_empty_dir(inode, parent, &d);
 
 	kunmap_atomic(dentry_blk);
+	flush_dcache_page(dentry_page);
 
 	set_page_dirty(dentry_page);
 	f2fs_put_page(dentry_page, 1);
@@ -579,6 +582,7 @@ fail:
 		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
 	}
 	kunmap(dentry_page);
+	flush_dcache_page(dentry_page);
 	f2fs_put_page(dentry_page, 1);
 	return err;
 }
@@ -661,6 +665,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 			NR_DENTRY_IN_BLOCK,
 			0);
 	kunmap(page); /* kunmap - pair of f2fs_find_entry */
+	flush_dcache_page(page);
 	set_page_dirty(page);
 
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index f26fb87..8b7cc51 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -45,8 +45,8 @@ void read_inline_data(struct page *page, struct page *ipage)
 	src_addr = inline_data_addr(ipage);
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
-	flush_dcache_page(page);
 	kunmap_atomic(dst_addr);
+	flush_dcache_page(page);
 	SetPageUptodate(page);
 }
 
@@ -107,6 +107,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
 	kunmap_atomic(dst_addr);
+	flush_dcache_page(page);
 	SetPageUptodate(page);
 no_update:
 	/* write data page to try to make data consistent */
@@ -358,6 +359,7 @@ static int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
 					NR_INLINE_DENTRY * F2FS_SLOT_LEN);
 
 	kunmap_atomic(dentry_blk);
+	flush_dcache_page(page);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 
-- 
2.1.1

