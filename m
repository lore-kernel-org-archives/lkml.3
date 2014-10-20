Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaJTFTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:59955 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbaJTFTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:48 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 03/11] f2fs: fix to wait correct block type
Date: Sun, 19 Oct 2014 22:19:31 -0700
Message-Id: <1413782379-11758-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode page needs to wait NODE block io.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 3 ++-
 fs/f2fs/inline.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c60b93f..644b480 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -282,8 +282,9 @@ ino_t f2fs_inode_by_name(struct inode *dir, struct qstr *qstr)
 void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 		struct page *page, struct inode *inode)
 {
+	enum page_type type = f2fs_has_inline_dentry(dir) ? NODE : DATA;
 	lock_page(page);
-	f2fs_wait_on_page_writeback(page, DATA);
+	f2fs_wait_on_page_writeback(page, type);
 	de->ino = cpu_to_le32(inode->i_ino);
 	set_de_type(de, inode);
 	if (!f2fs_has_inline_dentry(dir))
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 6f9ba80..6fbdce7 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -429,7 +429,7 @@ int f2fs_add_inline_entry(struct inode *dir, const struct qstr *name,
 		goto out;
 	}
 
-	f2fs_wait_on_page_writeback(ipage, DATA);
+	f2fs_wait_on_page_writeback(ipage, NODE);
 
 	down_write(&F2FS_I(inode)->i_sem);
 	page = init_inode_metadata(inode, dir, name);
@@ -474,7 +474,7 @@ void f2fs_delete_inline_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	int i;
 
 	lock_page(page);
-	f2fs_wait_on_page_writeback(page, DATA);
+	f2fs_wait_on_page_writeback(page, NODE);
 
 	inline_dentry = inline_data_addr(page);
 	bit_pos = dentry - inline_dentry->dentry;
-- 
2.1.1

