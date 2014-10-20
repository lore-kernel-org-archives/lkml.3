Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaJTFUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:20:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:60041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaJTFT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:59 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 10/11] f2fs: reuse make_empty_dir code for inline_dentry
Date: Sun, 19 Oct 2014 22:19:38 -0700
Message-Id: <1413782379-11758-10-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces do_make_empty_dir to mitigate code redundancy
for inline_dentry.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 42 ++++++++++++++++++++++++++----------------
 fs/f2fs/f2fs.h   |  2 ++
 fs/f2fs/inline.c | 20 +++-----------------
 3 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 80665ce..b751f94 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -322,12 +322,35 @@ int update_dent_inode(struct inode *inode, const struct qstr *name)
 	return 0;
 }
 
+void do_make_empty_dir(struct inode *inode, struct inode *parent,
+					struct f2fs_dentry_ptr *d)
+{
+	struct f2fs_dir_entry *de;
+
+	de = &d->dentry[0];
+	de->name_len = cpu_to_le16(1);
+	de->hash_code = 0;
+	de->ino = cpu_to_le32(inode->i_ino);
+	memcpy(d->filename[0], ".", 1);
+	set_de_type(de, inode);
+
+	de = &d->dentry[1];
+	de->hash_code = 0;
+	de->name_len = cpu_to_le16(2);
+	de->ino = cpu_to_le32(parent->i_ino);
+	memcpy(d->filename[1], "..", 2);
+	set_de_type(de, inode);
+
+	test_and_set_bit_le(0, (void *)d->bitmap);
+	test_and_set_bit_le(1, (void *)d->bitmap);
+}
+
 static int make_empty_dir(struct inode *inode,
 		struct inode *parent, struct page *page)
 {
 	struct page *dentry_page;
 	struct f2fs_dentry_block *dentry_blk;
-	struct f2fs_dir_entry *de;
+	struct f2fs_dentry_ptr d;
 
 	if (f2fs_has_inline_dentry(inode))
 		return make_empty_inline_dir(inode, parent, page);
@@ -338,22 +361,9 @@ static int make_empty_dir(struct inode *inode,
 
 	dentry_blk = kmap_atomic(dentry_page);
 
-	de = &dentry_blk->dentry[0];
-	de->name_len = cpu_to_le16(1);
-	de->hash_code = 0;
-	de->ino = cpu_to_le32(inode->i_ino);
-	memcpy(dentry_blk->filename[0], ".", 1);
-	set_de_type(de, inode);
-
-	de = &dentry_blk->dentry[1];
-	de->hash_code = 0;
-	de->name_len = cpu_to_le16(2);
-	de->ino = cpu_to_le32(parent->i_ino);
-	memcpy(dentry_blk->filename[1], "..", 2);
-	set_de_type(de, inode);
+	make_dentry_ptr(&d, dentry_blk, NULL, 1);
+	do_make_empty_dir(inode, parent, &d);
 
-	test_and_set_bit_le(0, &dentry_blk->dentry_bitmap);
-	test_and_set_bit_le(1, &dentry_blk->dentry_bitmap);
 	kunmap_atomic(dentry_blk);
 
 	set_page_dirty(dentry_page);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0856a38..267d54e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1274,6 +1274,8 @@ struct f2fs_dir_entry *find_target_dentry(struct qstr *, int *,
 			struct f2fs_dentry_ptr *);
 bool f2fs_fill_dentries(struct dir_context *, struct f2fs_dentry_ptr *,
 			unsigned int);
+void do_make_empty_dir(struct inode *, struct inode *,
+			struct f2fs_dentry_ptr *);
 struct page *init_inode_metadata(struct inode *, struct inode *,
 			const struct qstr *, struct page *);
 void update_parent_metadata(struct inode *, struct inode *, unsigned int);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index edacfa1..825995f 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -314,26 +314,12 @@ int make_empty_inline_dir(struct inode *inode, struct inode *parent,
 							struct page *ipage)
 {
 	struct f2fs_inline_dentry *dentry_blk;
-	struct f2fs_dir_entry *de;
+	struct f2fs_dentry_ptr d;
 
 	dentry_blk = inline_data_addr(ipage);
 
-	de = &dentry_blk->dentry[0];
-	de->name_len = cpu_to_le16(1);
-	de->hash_code = 0;
-	de->ino = cpu_to_le32(inode->i_ino);
-	memcpy(dentry_blk->filename[0], ".", 1);
-	set_de_type(de, inode);
-
-	de = &dentry_blk->dentry[1];
-	de->hash_code = 0;
-	de->name_len = cpu_to_le16(2);
-	de->ino = cpu_to_le32(parent->i_ino);
-	memcpy(dentry_blk->filename[1], "..", 2);
-	set_de_type(de, inode);
-
-	test_and_set_bit_le(0, &dentry_blk->dentry_bitmap);
-	test_and_set_bit_le(1, &dentry_blk->dentry_bitmap);
+	make_dentry_ptr(&d, NULL, dentry_blk, 2);
+	do_make_empty_dir(inode, parent, &d);
 
 	set_page_dirty(ipage);
 
-- 
2.1.1

