Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaJTFT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:60009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaJTFTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:55 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 07/11] f2fs: reuse core function in f2fs_readdir for inline_dentry
Date: Sun, 19 Oct 2014 22:19:35 -0700
Message-Id: <1413782379-11758-7-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a core function, f2fs_fill_dentries, to remove
redundant code in f2fs_readdir and f2fs_read_inline_dir.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 64 +++++++++++++++++++++++++++++++++-----------------------
 fs/f2fs/f2fs.h   |  3 +++
 fs/f2fs/inline.c | 39 +++++++---------------------------
 3 files changed, 48 insertions(+), 58 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 334e227..721d061 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -705,23 +705,50 @@ bool f2fs_empty_dir(struct inode *dir)
 	return true;
 }
 
+bool f2fs_fill_dentries(struct dir_context *ctx,
+			const void *bitmap, struct f2fs_dir_entry *dentry,
+			__u8 (*filenames)[F2FS_SLOT_LEN], int max,
+			unsigned int start_pos)
+{
+	unsigned char d_type = DT_UNKNOWN;
+	unsigned int bit_pos;
+	struct f2fs_dir_entry *de = NULL;
+
+	bit_pos = ((unsigned long)ctx->pos % max);
+
+	while (bit_pos < max) {
+		bit_pos = find_next_bit_le(bitmap, max, bit_pos);
+		if (bit_pos >= max)
+			break;
+
+		de = &dentry[bit_pos];
+		if (de->file_type < F2FS_FT_MAX)
+			d_type = f2fs_filetype_table[de->file_type];
+		else
+			d_type = DT_UNKNOWN;
+		if (!dir_emit(ctx, filenames[bit_pos],
+					le16_to_cpu(de->name_len),
+					le32_to_cpu(de->ino), d_type))
+			return true;
+
+		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
+		ctx->pos = start_pos + bit_pos;
+	}
+	return false;
+}
+
 static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
 	unsigned long npages = dir_blocks(inode);
-	unsigned int bit_pos = 0;
 	struct f2fs_dentry_block *dentry_blk = NULL;
-	struct f2fs_dir_entry *de = NULL;
 	struct page *dentry_page = NULL;
 	struct file_ra_state *ra = &file->f_ra;
 	unsigned int n = ((unsigned long)ctx->pos / NR_DENTRY_IN_BLOCK);
-	unsigned char d_type = DT_UNKNOWN;
 
 	if (f2fs_has_inline_dentry(inode))
 		return f2fs_read_inline_dir(file, ctx);
 
-	bit_pos = ((unsigned long)ctx->pos % NR_DENTRY_IN_BLOCK);
-
 	/* readahead for multi pages of dir */
 	if (npages - n > 1 && !ra_has_index(ra, n))
 		page_cache_sync_readahead(inode->i_mapping, ra, file, n,
@@ -733,28 +760,13 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 			continue;
 
 		dentry_blk = kmap(dentry_page);
-		while (bit_pos < NR_DENTRY_IN_BLOCK) {
-			bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
-							NR_DENTRY_IN_BLOCK,
-							bit_pos);
-			if (bit_pos >= NR_DENTRY_IN_BLOCK)
-				break;
-
-			de = &dentry_blk->dentry[bit_pos];
-			if (de->file_type < F2FS_FT_MAX)
-				d_type = f2fs_filetype_table[de->file_type];
-			else
-				d_type = DT_UNKNOWN;
-			if (!dir_emit(ctx,
-					dentry_blk->filename[bit_pos],
-					le16_to_cpu(de->name_len),
-					le32_to_cpu(de->ino), d_type))
-				goto stop;
 
-			bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-			ctx->pos = n * NR_DENTRY_IN_BLOCK + bit_pos;
-		}
-		bit_pos = 0;
+		if (f2fs_fill_dentries(ctx,
+				&dentry_blk->dentry_bitmap, dentry_blk->dentry,
+				dentry_blk->filename,
+				NR_DENTRY_IN_BLOCK, n * NR_DENTRY_IN_BLOCK))
+			goto stop;
+
 		ctx->pos = (n + 1) * NR_DENTRY_IN_BLOCK;
 		kunmap(dentry_page);
 		f2fs_put_page(dentry_page, 1);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9c4c8d1..3b0f490 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1247,6 +1247,9 @@ extern unsigned char f2fs_filetype_table[F2FS_FT_MAX];
 void set_de_type(struct f2fs_dir_entry *, struct inode *);
 struct f2fs_dir_entry *find_target_dentry(struct qstr *, int *, const void *,
 			struct f2fs_dir_entry *, __u8 (*)[F2FS_SLOT_LEN]);
+bool f2fs_fill_dentries(struct dir_context *,
+			const void *, struct f2fs_dir_entry *,
+			__u8 (*)[F2FS_SLOT_LEN], int, unsigned int);
 struct page *init_inode_metadata(struct inode *, struct inode *,
 			const struct qstr *, struct page *);
 void update_parent_metadata(struct inode *, struct inode *, unsigned int);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 633d5e8..403c8f7 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -519,49 +519,24 @@ bool f2fs_empty_inline_dir(struct inode *dir)
 int f2fs_read_inline_dir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	unsigned int bit_pos = 0;
 	struct f2fs_inline_dentry *inline_dentry = NULL;
-	struct f2fs_dir_entry *de = NULL;
 	struct page *ipage = NULL;
-	unsigned char d_type = DT_UNKNOWN;
 
 	if (ctx->pos == NR_INLINE_DENTRY)
 		return 0;
 
-	ipage = get_node_page(sbi, inode->i_ino);
+	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
 
-	bit_pos = ((unsigned long)ctx->pos % NR_INLINE_DENTRY);
-
 	inline_dentry = inline_data_addr(ipage);
-	while (bit_pos < NR_INLINE_DENTRY) {
-		bit_pos = find_next_bit_le(&inline_dentry->dentry_bitmap,
-						NR_INLINE_DENTRY,
-						bit_pos);
-		if (bit_pos >= NR_INLINE_DENTRY)
-			break;
-
-		de = &inline_dentry->dentry[bit_pos];
-		if (de->file_type < F2FS_FT_MAX)
-			d_type = f2fs_filetype_table[de->file_type];
-		else
-			d_type = DT_UNKNOWN;
-
-		if (!dir_emit(ctx,
-				inline_dentry->filename[bit_pos],
-				le16_to_cpu(de->name_len),
-				le32_to_cpu(de->ino), d_type))
-			goto out;
-
-		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-		ctx->pos = bit_pos;
-	}
 
-	ctx->pos = NR_INLINE_DENTRY;
-out:
-	f2fs_put_page(ipage, 1);
+	if (!f2fs_fill_dentries(ctx, &inline_dentry->dentry_bitmap,
+				inline_dentry->dentry,
+				inline_dentry->filename,
+				NR_INLINE_DENTRY, 0))
+		ctx->pos = NR_INLINE_DENTRY;
 
+	f2fs_put_page(ipage, 1);
 	return 0;
 }
-- 
2.1.1

